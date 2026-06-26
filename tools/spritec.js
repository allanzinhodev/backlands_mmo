#!/usr/bin/env node
/*
 * spritec.js — compilador de sprites/outfits para OTClientV8 (Tibia.dat/.spr 8.54 estendido).
 *
 * Modelo "fontes -> build": parte sempre de um .dat/.spr BASE limpo + manifesto JSON,
 * e regera os arquivos finais do zero. Idempotente (re-rodar nao acumula sprites orfaos)
 * e suporta substituir outfits existentes e adicionar novos (aumenta outfitCount).
 *
 * Formato implementado conforme otclientv8/src/client/{thingtype,animator,spritemanager}.cpp
 * e o Tibia.otfi (extended, transparency, frame-durations, frame-groups, sprite 32).
 *
 * Comandos:
 *   node spritec.js build [manifesto.json]   compila base+manifesto -> out
 *   node spritec.js verify                   percorre o out.dat e confere EOF
 *   node spritec.js check <id> <sheet.png>   confere outfit gravado x PNG (pixel-a-pixel)
 *   node spritec.js init [from.dat from.spr] cria o snapshot base (1x)
 */
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const SPRITES_U32 = true, ENHANCED_ANIM = true;
const SPRITE_SIZE = 32, SPRITE_DATA = SPRITE_SIZE * SPRITE_SIZE * 4;
const CAT_ITEM = 0, CAT_CREATURE = 1, CAT_EFFECT = 2, CAT_MISSILE = 3;

// ============================ util binario ============================
class Reader {
  constructor(buf, off = 0) { this.b = buf; this.o = off; }
  u8() { return this.b.readUInt8(this.o++); }
  u16() { const v = this.b.readUInt16LE(this.o); this.o += 2; return v; }
  u32() { const v = this.b.readUInt32LE(this.o); this.o += 4; return v; }
  skip(n) { this.o += n; }
}

// ============================ parser .dat ============================
function skipAttributes(r) {
  for (;;) {
    const fb = r.u8();
    if (fb === 255) break;
    if (fb === 8) continue;                 // Chargeable (7.80-8.54)
    const attr = fb > 8 ? fb - 1 : fb;
    switch (attr) {
      case 24: case 21: r.skip(4); break;   // Displacement / Light
      case 33: { r.skip(6); const len = r.u16(); r.skip(len + 4); break; } // Market
      case 25: case 0: case 8: case 9: case 28: case 32: case 29: case 34: r.skip(2); break;
      case 38: r.skip(16); break;           // Bones
      default: break;
    }
  }
}
function walkSpriteData(r, category, collectIds) {
  const hasFrameGroups = (category === CAT_CREATURE);
  const groupCount = hasFrameGroups ? r.u8() : 1;
  const ids = [];
  for (let g = 0; g < groupCount; g++) {
    if (hasFrameGroups) r.u8();
    const w = r.u8(), h = r.u8();
    if (w > 1 || h > 1) r.u8();
    const layers = r.u8(), pX = r.u8(), pY = r.u8(), pZ = r.u8(), phases = r.u8();
    if (phases > 1 && ENHANCED_ANIM) r.skip(1 + 4 + 1 + phases * 8);
    const total = w * h * layers * pX * pY * pZ * phases;
    if (collectIds) for (let i = 0; i < total; i++) ids.push(SPRITES_U32 ? r.u32() : r.u16());
    else r.skip(total * (SPRITES_U32 ? 4 : 2));
  }
  return ids;
}
function scanDat(buf) {
  const r = new Reader(buf, 0);
  const h = { signature: r.u32(), itemCount: r.u16(), outfitCount: r.u16(), effectCount: r.u16(), missileCount: r.u16() };
  const off = { headerEnd: r.o, items: r.o };
  for (let id = 100; id <= h.itemCount; id++) { skipAttributes(r); walkSpriteData(r, CAT_ITEM, false); }
  off.outfits = r.o;
  const outfitStart = [];
  for (let id = 1; id <= h.outfitCount; id++) { outfitStart[id] = r.o; skipAttributes(r); walkSpriteData(r, CAT_CREATURE, false); }
  off.outfitsEnd = r.o; off.effects = r.o;
  for (let id = 1; id <= h.effectCount; id++) { skipAttributes(r); walkSpriteData(r, CAT_EFFECT, false); }
  off.missiles = r.o;
  for (let id = 1; id <= h.missileCount; id++) { skipAttributes(r); walkSpriteData(r, CAT_MISSILE, false); }
  off.end = r.o;
  return { h, off, outfitStart };
}

// ============================ PNG (zlib) ============================
function paeth(a, b, c) { const p = a + b - c, pa = Math.abs(p - a), pb = Math.abs(p - b), pc = Math.abs(p - c); return pa <= pb && pa <= pc ? a : pb <= pc ? b : c; }
function decodePng(file) {
  const data = fs.readFileSync(file);
  let p = 8, width, height, bitDepth, colorType; const idat = [];
  while (p < data.length) {
    const len = data.readUInt32BE(p); p += 4;
    const type = data.toString('ascii', p, p + 4); p += 4;
    const chunk = data.slice(p, p + len); p += len + 4;
    if (type === 'IHDR') { width = chunk.readUInt32BE(0); height = chunk.readUInt32BE(4); bitDepth = chunk.readUInt8(8); colorType = chunk.readUInt8(9); }
    else if (type === 'IDAT') idat.push(chunk);
    else if (type === 'IEND') break;
  }
  if (bitDepth !== 8) throw new Error('bitDepth nao suportado: ' + bitDepth);
  const ch = colorType === 6 ? 4 : colorType === 2 ? 3 : colorType === 0 ? 1 : -1;
  if (ch < 0) throw new Error('colorType nao suportado: ' + colorType);
  const raw = zlib.inflateSync(Buffer.concat(idat));
  const stride = width * ch; const out = Buffer.alloc(height * stride);
  let pos = 0, prev = Buffer.alloc(stride);
  for (let y = 0; y < height; y++) {
    const f = raw[pos++]; const cur = Buffer.alloc(stride);
    for (let x = 0; x < stride; x++) {
      const rb = raw[pos + x], a = x >= ch ? cur[x - ch] : 0, b = prev[x], c = x >= ch ? prev[x - ch] : 0;
      let v; switch (f) { case 0: v = rb; break; case 1: v = rb + a; break; case 2: v = rb + b; break; case 3: v = rb + ((a + b) >> 1); break; case 4: v = rb + paeth(a, b, c); break; default: throw new Error('filtro ' + f); }
      cur[x] = v & 0xff;
    }
    pos += stride; cur.copy(out, y * stride); prev = cur;
  }
  const rgba = Buffer.alloc(width * height * 4);
  for (let i = 0; i < width * height; i++) {
    if (ch === 4) out.copy(rgba, i * 4, i * 4, i * 4 + 4);
    else if (ch === 3) { rgba[i*4]=out[i*3]; rgba[i*4+1]=out[i*3+1]; rgba[i*4+2]=out[i*3+2]; rgba[i*4+3]=255; }
    else { rgba[i*4]=rgba[i*4+1]=rgba[i*4+2]=out[i]; rgba[i*4+3]=255; }
  }
  return { width, height, rgba };
}
function extractCell(img, col, row) {
  const cell = Buffer.alloc(SPRITE_DATA), x0 = col * SPRITE_SIZE, y0 = row * SPRITE_SIZE;
  for (let y = 0; y < SPRITE_SIZE; y++) for (let x = 0; x < SPRITE_SIZE; x++) {
    const s = ((y0 + y) * img.width + (x0 + x)) * 4, d = (y * SPRITE_SIZE + x) * 4;
    img.rgba.copy(cell, d, s, s + 4);
  }
  return cell;
}

// ============================ encode/append .spr ============================
function encodeSprite(cell) {
  const N = SPRITE_SIZE * SPRITE_SIZE, chunks = []; let p = 0;
  while (p < N) {
    let t = 0; while (p < N && cell[p * 4 + 3] === 0) { t++; p++; }
    const colored = []; while (p < N && cell[p * 4 + 3] !== 0) { colored.push(p); p++; }
    if (colored.length === 0) break;
    chunks.push({ t, colored });
  }
  let size = 0; for (const c of chunks) size += 4 + c.colored.length * 4;
  const body = Buffer.alloc(3 + 2 + size); let o = 0;
  body[o++] = 0; body[o++] = 0; body[o++] = 0; body.writeUInt16LE(size, o); o += 2;
  for (const c of chunks) {
    body.writeUInt16LE(c.t, o); o += 2; body.writeUInt16LE(c.colored.length, o); o += 2;
    for (const px of c.colored) { body[o++]=cell[px*4]; body[o++]=cell[px*4+1]; body[o++]=cell[px*4+2]; body[o++]=cell[px*4+3]; }
  }
  return body;
}
function appendSprites(sprBuf, bodies) {
  const sig = sprBuf.readUInt32LE(0);
  const oldCount = SPRITES_U32 ? sprBuf.readUInt32LE(4) : sprBuf.readUInt16LE(4);
  const ts = SPRITES_U32 ? 8 : 6, es = SPRITES_U32 ? 4 : 2;
  const dataStart = ts + oldCount * es, shift = bodies.length * es;
  const newCount = oldCount + bodies.length, newDataStart = ts + newCount * es;
  const oldData = sprBuf.slice(dataStart);
  const header = Buffer.alloc(ts); header.writeUInt32LE(sig, 0);
  if (SPRITES_U32) header.writeUInt32LE(newCount, 4); else header.writeUInt16LE(newCount, 4);
  const table = Buffer.alloc(newCount * es);
  for (let i = 0; i < oldCount; i++) {
    const off = SPRITES_U32 ? sprBuf.readUInt32LE(ts + i * es) : sprBuf.readUInt16LE(ts + i * es);
    const v = off === 0 ? 0 : off + shift;
    if (SPRITES_U32) table.writeUInt32LE(v, i * es); else table.writeUInt16LE(v, i * es);
  }
  let addr = newDataStart + oldData.length; const newIds = [];
  for (let k = 0; k < bodies.length; k++) {
    const idx = oldCount + k;
    if (SPRITES_U32) table.writeUInt32LE(addr, idx * es); else table.writeUInt16LE(addr, idx * es);
    newIds.push(idx + 1); addr += bodies[k].length;
  }
  return { buf: Buffer.concat([header, table, oldData, ...bodies]), newIds, oldCount, newCount };
}

// ============================ montagem de outfit (.dat) ============================
// groups: [{type, phases, ids:[...]}], phases>1 ganha animator (walk).
function buildOutfitEntry(groups, dirCount, walkDuration) {
  const parts = [Buffer.from([255]), Buffer.from([groups.length])];
  for (const g of groups) {
    parts.push(Buffer.from([g.type, 1, 1, 1, dirCount, 1, 1, g.phases])); // type,w,h,layers,pX,pY,pZ,phases
    if (g.phases > 1 && ENHANCED_ANIM) {
      const anim = Buffer.alloc(1 + 4 + 1 + g.phases * 8); let a = 0;
      anim.writeUInt8(0, a); a += 1; anim.writeInt32LE(0, a); a += 4; anim.writeInt8(0, a); a += 1;
      for (let i = 0; i < g.phases; i++) { anim.writeUInt32LE(walkDuration, a); a += 4; anim.writeUInt32LE(walkDuration, a); a += 4; }
      parts.push(anim);
    }
    const sbuf = Buffer.alloc(g.ids.length * 4); g.ids.forEach((id, i) => sbuf.writeUInt32LE(id, i * 4));
    parts.push(sbuf);
  }
  return Buffer.concat(parts);
}

// ============================ comandos ============================
function loadManifest(file) {
  const mf = path.resolve(file || path.join(__dirname, 'sprites.json'));
  const m = JSON.parse(fs.readFileSync(mf, 'utf8'));
  const dir = path.dirname(mf);
  const rel = p => path.resolve(dir, p);
  return { m, baseDat: rel(m.base.dat), baseSpr: rel(m.base.spr), outDat: rel(m.out.dat), outSpr: rel(m.out.spr), dir, rel };
}

function build(manifestFile) {
  const { m, baseDat, baseSpr, outDat, outSpr, rel } = loadManifest(manifestFile);
  for (const f of [baseDat, baseSpr]) if (!fs.existsSync(f)) { console.log(`base ausente: ${f}\nrode primeiro: node spritec.js init`); return; }
  const d = m.defaults || {};
  const dirCount = (d.directions || ['N','E','S','W']).length;

  const base = fs.readFileSync(baseDat);
  const scan = scanDat(base);
  const baseOutfitCount = scan.h.outfitCount;

  // 1) extrai + codifica todos os sprites de todos os outfits do manifesto
  const bodies = [];
  const byId = {}; // id -> {groups com indices locais em bodies}
  for (const o of m.outfits) {
    const idleRow = o.idleRow ?? d.idleRow ?? 0;
    const walkRows = o.walkRows ?? d.walkRows ?? [];
    const walkDuration = o.walkDuration ?? d.walkDuration ?? 300;
    const img = decodePng(rel(o.sheet));
    const grabRow = row => Array.from({ length: dirCount }, (_, c) => { bodies.push(encodeSprite(extractCell(img, c, row))); return bodies.length - 1; });
    const groups = [{ type: 0, phases: 1, idx: grabRow(idleRow) }];
    if (walkRows.length > 0) groups.push({ type: 1, phases: walkRows.length, idx: [].concat(...walkRows.map(grabRow)) });
    byId[o.id] = { groups, walkDuration };
  }

  // 2) base.spr + sprites custom -> ids reais
  const baseSprBuf = fs.readFileSync(baseSpr);
  const { buf: newSpr, newIds, oldCount, newCount } = appendSprites(baseSprBuf, bodies);
  const idOf = i => newIds[i];

  // 3) reconstroi a secao de outfits (originais + substituidos + novos)
  const maxId = Math.max(baseOutfitCount, ...m.outfits.map(o => o.id));
  const entries = [];
  for (let id = 1; id <= maxId; id++) {
    if (byId[id]) {
      const g = byId[id].groups.map(gr => ({ type: gr.type, phases: gr.phases, ids: gr.idx.map(idOf) }));
      entries.push(buildOutfitEntry(g, dirCount, byId[id].walkDuration));
    } else if (id <= baseOutfitCount) {
      const end = id < baseOutfitCount ? scan.outfitStart[id + 1] : scan.off.outfitsEnd;
      entries.push(base.slice(scan.outfitStart[id], end));
    } else {
      console.log(`ERRO: outfit ${id} ausente (ids devem ser contiguos 1..${maxId}).`); return;
    }
  }

  // 4) header (patch outfitCount) + itens + outfits + cauda(efeitos/missiles)
  const header = Buffer.from(base.slice(0, scan.off.headerEnd));
  header.writeUInt16LE(maxId, 6);
  const newDat = Buffer.concat([header, base.slice(scan.off.items, scan.off.outfits), ...entries, base.slice(scan.off.effects)]);

  // 5) auto-verificacao antes de gravar
  const chk = scanDat(newDat);
  if (chk.off.end !== newDat.length) { console.log(`ABORTADO: novo .dat invalido (${chk.off.end} != ${newDat.length}).`); return; }

  fs.writeFileSync(outSpr, newSpr);
  fs.writeFileSync(outDat, newDat);
  console.log(`build OK: ${m.outfits.length} outfit(s) | outfitCount ${baseOutfitCount} -> ${maxId} | sprites ${oldCount} -> ${newCount}`);
  console.log(`  -> ${path.relative(process.cwd(), outDat)} + ${path.relative(process.cwd(), outSpr)} (validado, parser bate com EOF)`);
}

function verify(manifestFile) {
  const { outDat } = loadManifest(manifestFile);
  const buf = fs.readFileSync(outDat); const s = scanDat(buf);
  console.log('Header:', JSON.stringify(s.h));
  console.log(s.off.end === buf.length ? `OK: parser bate com EOF (${buf.length}).` : `ERRO: ${buf.length - s.off.end} bytes de diferenca.`);
}

function decodeSpriteFromSpr(sprBuf, id) {
  const ts = SPRITES_U32 ? 8 : 6, es = SPRITES_U32 ? 4 : 2;
  const addr = SPRITES_U32 ? sprBuf.readUInt32LE(ts + (id - 1) * es) : sprBuf.readUInt16LE(ts + (id - 1) * es);
  const out = Buffer.alloc(SPRITE_DATA); if (addr === 0) return out;
  let o = addr + 3; const dataSize = sprBuf.readUInt16LE(o); o += 2; let read = 0, w = 0;
  while (read < dataSize && w < SPRITE_DATA) {
    const t = sprBuf.readUInt16LE(o); o += 2; const col = sprBuf.readUInt16LE(o); o += 2; w += t * 4;
    for (let i = 0; i < col && w < SPRITE_DATA; i++) { sprBuf.copy(out, w, o, o + 4); o += 4; w += 4; }
    read += 4 + col * 4;
  }
  return out;
}
function check(id, sheet, manifestFile) {
  id = parseInt(id, 10);
  const { m, outDat, outSpr, rel } = loadManifest(manifestFile);
  const d = m.defaults || {}; const dirCount = (d.directions || ['N','E','S','W']).length;
  const dat = fs.readFileSync(outDat), spr = fs.readFileSync(outSpr);
  const scan = scanDat(dat);
  const r = new Reader(dat, scan.outfitStart[id]); skipAttributes(r);
  const ids = walkSpriteData(r, CAT_CREATURE, true);
  const img = decodePng(rel(sheet));
  const idleRow = d.idleRow ?? 0, walkRows = d.walkRows ?? [];
  const cells = []; for (const c of Array.from({length:dirCount},(_,i)=>i)) cells.push([c, idleRow]);
  for (const row of walkRows) for (let c = 0; c < dirCount; c++) cells.push([c, row]);
  let mism = 0;
  for (let i = 0; i < ids.length && i < cells.length; i++) if (!decodeSpriteFromSpr(spr, ids[i]).equals(extractCell(img, cells[i][0], cells[i][1]))) mism++;
  console.log(`outfit ${id}: ${ids.length} sprites. ${mism === 0 ? 'OK: batem pixel-a-pixel com ' + path.basename(sheet) : 'ERRO: ' + mism + ' divergem'}`);
}

function init(manifestFile) {
  const { baseDat, baseSpr, outDat, outSpr } = loadManifest(manifestFile);
  const fromDat = process.argv[3] || outDat, fromSpr = process.argv[4] || outSpr;
  if (fs.existsSync(baseDat) || fs.existsSync(baseSpr)) { console.log('base ja existe; nao sobrescrevo. Apague manualmente se quiser recriar.'); return; }
  fs.copyFileSync(fromDat, baseDat); fs.copyFileSync(fromSpr, baseSpr);
  console.log(`base criado a partir de:\n  ${fromDat}\n  ${fromSpr}`);
}

const cmd = process.argv[2];
if (cmd === 'build') build(process.argv[3]);
else if (cmd === 'verify') verify();
else if (cmd === 'check') check(process.argv[3], process.argv[4]);
else if (cmd === 'init') init();
else console.log('uso: node spritec.js build [manifesto.json] | verify | check <id> <sheet.png> | init [from.dat from.spr]');
