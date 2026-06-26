using System;
using System.IO;
using System.Collections.Generic;

// Set the Displacement attribute (x,y) on specific outfit (creature) ids directly in the
// extended 854 Tibia.dat. On-disk attr byte for Displacement = 25 (internal 24), data = x(u16),y(u16).
class DatDisplacement
{
    const int CAT_ITEM=0, CAT_CREATURE=1, CAT_EFFECT=2, CAT_MISSILE=3;
    const byte ATTR_LAST=255;
    const byte ONDISK_DISPLACEMENT=25;

    static byte[] d;
    static int pos;

    // size (in bytes) of the data for an ON-DISK attribute in 854
    static int OnDiskAttrDataSize(byte a){
        // map on-disk -> internal (854: charges@8 is a flag, others >8 shift down by 1)
        if(a==8) return 0;                 // charges flag (no data)
        int internalAttr = a>8 ? a-1 : a;
        if(internalAttr==24 || internalAttr==21) return 4;                 // Displacement, Light
        if(internalAttr==33){ int sl=BitConverter.ToUInt16(d,pos+6); return 6+2+sl+4; } // Market
        if(internalAttr==25||internalAttr==34||internalAttr==0||internalAttr==8||
           internalAttr==9||internalAttr==28||internalAttr==32||internalAttr==29) return 2;
        if(internalAttr==38) return 16;    // Bones
        return 0;
    }

    static void ReadGeom(){
        byte w=d[pos++], h=d[pos++];
        if(w>1||h>1) pos++;                // exact size
        byte layers=d[pos++], px=d[pos++], py=d[pos++], pz=d[pos++], phases=d[pos++];
        if(phases>1) pos += 1 + 4 + 1 + phases*8;   // animator: async + loop(i32) + start(i8) + phases*(min,max u32)
        int total=w*h*layers*px*py*pz*phases;
        pos += total*4;                    // u32 sprite ids
    }

    static void Main(){
        string datPath=@"C:\Users\allan\OneDrive\Desktop\backlands\otclientv8\data\things\854\Tibia.dat";
        var targets=new HashSet<int>{1,2,3};
        int dx=8, dy=4;

        d=File.ReadAllBytes(datPath);
        pos=0;
        var outMs=new MemoryStream();
        var bw=new BinaryWriter(outMs);

        // header: signature + 4 counts
        bw.Write(BitConverter.ToUInt32(d,pos)); pos+=4;
        ushort[] counts=new ushort[4];
        for(int i=0;i<4;i++){ counts[i]=BitConverter.ToUInt16(d,pos); pos+=2; bw.Write(counts[i]); }

        int modified=0;
        for(int category=0; category<4; category++){
            int firstId=(category==CAT_ITEM)?100:1;
            for(int id=firstId; id<=counts[category]; id++){
                int thingStart=pos;
                // --- attributes ---
                int attrStart=pos;
                var attrBytes=new List<byte>();
                bool hasDisp=false; int dispDataPos=-1;
                while(true){
                    byte at=d[pos++];
                    if(at==ATTR_LAST) break;
                    int dsz=OnDiskAttrDataSize(at);
                    if(at==ONDISK_DISPLACEMENT){ hasDisp=true; }
                    // record start of this attr in the source
                    int attrFieldStart=pos-1;
                    pos+=dsz;
                    if(at==ONDISK_DISPLACEMENT) dispDataPos=attrFieldStart+1;
                }
                int attrEnd=pos; // points right after 0xFF

                bool isTarget = (category==CAT_CREATURE && targets.Contains(id));

                if(isTarget){
                    // rebuild attribute block with Displacement=(dx,dy)
                    // copy attrs [attrStart, attrEnd-1) (exclude trailing 0xFF), patching/adding displacement
                    int p=attrStart;
                    var outAttrs=new List<byte>();
                    bool wrote=false;
                    while(d[p]!=ATTR_LAST){
                        byte at=d[p];
                        int save=pos; pos=p+1; int dsz=OnDiskAttrDataSize(at); pos=save;
                        if(at==ONDISK_DISPLACEMENT){
                            outAttrs.Add(ONDISK_DISPLACEMENT);
                            outAttrs.Add((byte)(dx&0xFF)); outAttrs.Add((byte)((dx>>8)&0xFF));
                            outAttrs.Add((byte)(dy&0xFF)); outAttrs.Add((byte)((dy>>8)&0xFF));
                            wrote=true;
                            p += 1+dsz;
                        } else {
                            for(int k=0;k<1+dsz;k++) outAttrs.Add(d[p+k]);
                            p += 1+dsz;
                        }
                    }
                    if(!wrote){
                        outAttrs.Add(ONDISK_DISPLACEMENT);
                        outAttrs.Add((byte)(dx&0xFF)); outAttrs.Add((byte)((dx>>8)&0xFF));
                        outAttrs.Add((byte)(dy&0xFF)); outAttrs.Add((byte)((dy>>8)&0xFF));
                    }
                    outAttrs.Add(ATTR_LAST);
                    bw.Write(outAttrs.ToArray());
                    modified++;
                    Console.WriteLine("outfit "+id+": displacement "+(hasDisp?"sobrescrito":"inserido")+" -> ("+dx+","+dy+")");
                } else {
                    // copy attribute block verbatim
                    bw.Write(d, attrStart, attrEnd-attrStart);
                }

                // --- geometry + sprites (copy verbatim) ---
                int geomStart=pos;
                if(category==CAT_CREATURE){
                    byte groupCount=d[pos++];
                    for(int g=0; g<groupCount; g++){ pos++; /*frameGroupType*/ ReadGeom(); }
                } else {
                    ReadGeom();
                }
                bw.Write(d, geomStart, pos-geomStart);
            }
        }

        byte[] outBytes=outMs.ToArray();
        // self-check: re-parse the output fully and confirm it walks to the exact end
        d=outBytes; pos=0;
        pos+=4; ushort[] c2=new ushort[4]; for(int i=0;i<4;i++){ c2[i]=BitConverter.ToUInt16(d,pos); pos+=2; }
        for(int category=0; category<4; category++){
            int firstId=(category==CAT_ITEM)?100:1;
            for(int id=firstId; id<=c2[category]; id++){
                while(d[pos++]!=ATTR_LAST){ pos+=OnDiskAttrDataSize(d[pos-1]); }
                if(category==CAT_CREATURE){ byte gc=d[pos++]; for(int g=0;g<gc;g++){ pos++; ReadGeom(); } }
                else ReadGeom();
            }
        }
        bool ok = (pos==outBytes.Length);
        Console.WriteLine("self-check: parse terminou em "+pos+"/"+outBytes.Length+" -> "+(ok?"OK":"FALHA"));
        if(!ok){ Console.WriteLine("ABORTADO: nao sobrescreve o dat."); return; }

        File.WriteAllBytes(datPath+".new", outBytes);
        Console.WriteLine("DONE. outfits modificadas="+modified+"  novoTamanho="+outBytes.Length+"  (original="+File.ReadAllBytes(datPath).Length+")  -> escrito em Tibia.dat.new");
    }
}
