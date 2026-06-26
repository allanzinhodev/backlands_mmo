using System;
using System.IO;
using System.Collections.Generic;

// Grass/Water sprite swap for extended (frame-group) DAT/SPR.
// 854 set: classic-attr remap (>=780). NWO set: 10.x remap (>=1000). Both: u32 sprite ids, RGBA spr.
// Grass/water are ITEMS (category 0) -> no frame groups.
class GwSwap
{
    // bytes of data for an internal ThingAttr value (after version remap). 0 = flag only.
    static int AttrDataSize(int a, byte[] d, int pos){
        if(a==24||a==21) return 4;                                  // Displacement, Light
        if(a==33){ int sl=BitConverter.ToUInt16(d,pos+6); return 6+2+sl+4; } // Market
        if(a==25||a==34||a==0||a==8||a==9||a==28||a==32||a==29) return 2;    // Elevation,Usable,Ground,Writable,WritableOnce,MinimapColor,Cloth,LensHelp
        if(a==38) return 16;                                        // Bones
        return 0;
    }

    static int Remap(int at, int version){
        if(version>=1000){ if(at==16) return -1; if(at>16) return at-1; return at; }
        if(version>=860) return at;                       // 8.6-9.86: no remap
        if(at==8) return -1; if(at>8) return at-1; return at; // 7.80-8.54: charges@8 shift
    }

    // itemId -> sprite-id list, plus a shape key (dims) for compatibility check.
    static Dictionary<int,uint[]> ParseItems(byte[] d, int version, string tag, out Dictionary<int,string> shape){
        var map=new Dictionary<int,uint[]>(); shape=new Dictionary<int,string>();
        int pos=4; // signature
        ushort itemCount=BitConverter.ToUInt16(d,pos); pos+=2;
        pos+=6; // skip creature/effect/missile counts
        int id=100;
        try{
        for(; id<=itemCount; id++){
            while(true){ byte at=d[pos++]; if(at==255) break; int ia=Remap(at,version); pos+= ia<0?0:AttrDataSize(ia,d,pos); }
            byte w=d[pos++], h=d[pos++];
            if(w>1||h>1) pos++;
            byte layers=d[pos++], px=d[pos++], py=d[pos++], pz=d[pos++], phases=d[pos++];
            if(phases>1) pos += 6 + phases*8; // animator: async(1)+loop(4)+start(1) + phases*(min u32,max u32)
            int total=w*h*layers*px*py*pz*phases;
            if(total<=0||total>4096){ Console.WriteLine(tag+": SANITY FAIL id="+id+" w="+w+" h="+h+" total="+total+" pos="+pos); return map; }
            uint[] sp=new uint[total];
            for(int i=0;i<total;i++){ sp[i]=BitConverter.ToUInt32(d,pos); pos+=4; }
            map[id]=sp;
            shape[id]=string.Format("{0}x{1}|l{2}|p{3}x{4}x{5}|ph{6}|n{7}",w,h,layers,px,py,pz,phases,total);
        }
        } catch(Exception e){ Console.WriteLine(tag+": EXCEPTION id="+id+" pos="+pos+" "+e.GetType().Name); }
        return map;
    }

    static List<int> ParseIds(string s){
        var l=new List<int>();
        foreach(var part in s.Split(',')){ var p=part.Trim(); if(p.Length==0) continue;
            if(p.Contains("-")){ var a=p.Split('-'); for(int i=int.Parse(a[0]);i<=int.Parse(a[1]);i++) l.Add(i); }
            else l.Add(int.Parse(p)); }
        return l;
    }

    // ---- SPR ----
    static uint[] ReadSprOffsets(byte[] d, out uint count){
        count=BitConverter.ToUInt32(d,4);
        uint[] off=new uint[count];
        int pos=8;
        for(uint i=0;i<count;i++){ off[i]=BitConverter.ToUInt32(d,pos); pos+=4; }
        return off;
    }
    // raw chunk bytes for sprite id (1-based): colorKey(3)+size(2)+data(size). Returns null if blank.
    static byte[] ReadSprChunk(byte[] d, uint[] off, uint count, uint spriteId){
        if(spriteId==0 || spriteId>count) return null;
        uint addr=off[spriteId-1];
        if(addr==0) return null;
        int p=(int)addr;
        ushort size=BitConverter.ToUInt16(d,p+3);
        byte[] chunk=new byte[3+2+size];
        Array.Copy(d,p,chunk,0,chunk.Length);
        return chunk;
    }

    static void Main(string[] args){
        string mode=args.Length>0?args[0]:"analyze";
        string baseDir=@"C:\Users\allan\OneDrive\Desktop\Project\otclientv8\data\things\854";
        string targetDat=Path.Combine(baseDir,"Tibia.dat");
        string targetSpr=Path.Combine(baseDir,"Tibia.spr");
        string srcDir=@"C:\Users\allan\Downloads\SPRS + 2026\SPRS + 2026\naruto world online_2026";
        string sourceDat=Path.Combine(srcDir,"NWO.dat");
        string sourceSpr=Path.Combine(srcDir,"NWO.spr");
        string ids=args.Length>1?args[1]:"4526-4553,4580-4594,493,4608-4625,4664-4666,4820-4825";

        var tdat=File.ReadAllBytes(targetDat);
        var sdat=File.ReadAllBytes(sourceDat);
        Dictionary<int,string> tsh, ssh;
        var tmap=ParseItems(tdat,854,"854",out tsh);
        var smap=ParseItems(sdat,860,"NWO",out ssh);
        Console.WriteLine("854 items="+tmap.Count+"  NWO items="+smap.Count);

        var idList=ParseIds(ids);
        var swapIds=new List<int>();
        int ok=0,mism=0,miss=0;
        foreach(int id in idList){
            if(!tmap.ContainsKey(id)||!smap.ContainsKey(id)){ miss++; continue; }
            if(tmap[id].Length==smap[id].Length && tsh[id]==ssh[id]){ ok++; swapIds.Add(id); }
            else { mism++; if(mism<=20) Console.WriteLine("  MISMATCH id "+id+" 854["+tsh[id]+"] NWO["+ssh[id]+"]"); }
        }
        Console.WriteLine(string.Format("SUMMARY ids: OK={0} mismatch={1} missing={2} total={3}",ok,mism,miss,idList.Count));

        if(mode!="swap"){
            int shown=0; foreach(int id in swapIds){ if(shown++>=8) break; Console.WriteLine("  OK id "+id+" shape="+tsh[id]+" 854sprites=["+string.Join(",",Array.ConvertAll(tmap[id],x=>x.ToString()))+"] NWOsprites=["+string.Join(",",Array.ConvertAll(smap[id],x=>x.ToString()))+"]"); }
            Console.WriteLine("(analyze only; run 'swap' to apply)");
            return;
        }

        // ---- SWAP: copy NWO sprite chunks into 854 spr at the matching item's sprite ids ----
        var tspr=File.ReadAllBytes(targetSpr);
        var sspr=File.ReadAllBytes(sourceSpr);
        uint tcount, scount;
        var toff=ReadSprOffsets(tspr,out tcount);
        var soff=ReadSprOffsets(sspr,out scount);
        Console.WriteLine("854 spr sprites="+tcount+"  NWO spr sprites="+scount);

        // map: target sprite-id -> replacement chunk (from NWO)
        var repl=new Dictionary<uint,byte[]>();
        int copied=0, skipped=0;
        foreach(int id in swapIds){
            var ta=tmap[id]; var sa=smap[id];
            for(int i=0;i<ta.Length;i++){
                uint tsid=ta[i], ssid=sa[i];
                if(tsid==0||ssid==0) continue;
                byte[] chunk=ReadSprChunk(sspr,soff,scount,ssid);
                if(chunk==null){ skipped++; continue; }
                repl[tsid]=chunk; copied++;
            }
        }
        Console.WriteLine("sprite slots to replace="+repl.Count+" (copied refs="+copied+" skippedBlank="+skipped+")");

        // rebuild 854 spr: keep all sprites, but for ids in repl use the new chunk
        using(var ms=new MemoryStream())
        using(var bw=new BinaryWriter(ms)){
            bw.Write(BitConverter.ToUInt32(tspr,0)); // signature
            bw.Write(tcount);
            long tableOff=bw.BaseStream.Position;
            for(uint i=0;i<tcount;i++) bw.Write((uint)0);
            for(uint i=0;i<tcount;i++){
                uint sid=i+1;
                byte[] chunk;
                if(repl.ContainsKey(sid)) chunk=repl[sid];
                else chunk=ReadSprChunk(tspr,toff,tcount,sid);
                if(chunk==null) continue; // blank -> offset stays 0
                uint addr=(uint)bw.BaseStream.Position;
                long cur=bw.BaseStream.Position;
                bw.BaseStream.Seek(tableOff+(long)i*4,SeekOrigin.Begin);
                bw.Write(addr);
                bw.BaseStream.Seek(cur,SeekOrigin.Begin);
                bw.Write(chunk);
            }
            File.WriteAllBytes(targetSpr,ms.ToArray());
        }
        Console.WriteLine("DONE. 854 Tibia.spr rewritten with "+repl.Count+" grass/water sprite slots replaced from NWO.");
    }
}
