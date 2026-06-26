using System;
using System.IO;
using System.Collections.Generic;

// Cross OTB (ground server items -> client id) with DAT (client id -> sprite set)
// to pick N ground items that are single-sprite and have pairwise-disjoint sprites.
class FindGrounds
{
    // ---- OTB ----
    const byte NODE_START=0xFE, NODE_END=0xFF, ESCAPE=0xFD;
    const byte ATTR_SERVERID=0x10, ATTR_CLIENTID=0x11;
    static byte ReadRaw(byte[] d, ref int pos){ byte b=d[pos++]; if(b==ESCAPE) b=d[pos++]; return b; }
    static uint ReadU32(byte[] d, ref int pos){ uint v=0; for(int i=0;i<4;i++) v|=(uint)ReadRaw(d,ref pos)<<(8*i); return v; }

    // ---- DAT ----
    static int AttrDataSize(int a, byte[] d, int pos){
        if(a==24||a==21) return 4;
        if(a==33){ int sl=BitConverter.ToUInt16(d,pos+6); return 6+2+sl+4; }
        if(a==25||a==34||a==0||a==8||a==9||a==28||a==32||a==29) return 2;
        if(a==38) return 16;
        return 0;
    }
    static int Remap(int at){ if(at==8) return -1; if(at>8) return at-1; return at; }

    static void Main(){
        string otbPath=@"C:\Users\allan\OneDrive\Desktop\backlands\data\items\items.otb";
        string datPath=@"C:\Users\allan\OneDrive\Desktop\backlands\otclientv8\data\things\854\Tibia.dat";

        // OTB: ground server -> client
        byte[] o=File.ReadAllBytes(otbPath);
        int pos=4;
        var groundServerToClient=new SortedDictionary<int,int>();
        var groundFlags=new Dictionary<int,uint>();
        while(pos<o.Length){
            byte b=o[pos++]; if(b!=NODE_START) continue;
            byte group=ReadRaw(o, ref pos);
            uint flags=ReadU32(o, ref pos); // FLAG_BLOCK_SOLID=1, BLOCK_PROJECTILE=2, BLOCK_PATHFIND=4
            int serverId=-1, clientId=-1;
            while(pos<o.Length){
                byte peek=o[pos];
                if(peek==NODE_END){ pos++; break; }
                if(peek==NODE_START) break;
                byte attr=ReadRaw(o, ref pos);
                int len=ReadRaw(o,ref pos)|(ReadRaw(o,ref pos)<<8);
                byte[] data=new byte[len]; for(int i=0;i<len;i++) data[i]=ReadRaw(o, ref pos);
                if(attr==ATTR_SERVERID && len>=2) serverId=data[0]|(data[1]<<8);
                else if(attr==ATTR_CLIENTID && len>=2) clientId=data[0]|(data[1]<<8);
            }
            if(group==1 && serverId>=0 && clientId>=0 && !groundServerToClient.ContainsKey(serverId)){
                groundServerToClient[serverId]=clientId;
                groundFlags[serverId]=flags;
            }
        }

        // DAT: client -> sprite set
        byte[] d=File.ReadAllBytes(datPath);
        var clientSprites=new Dictionary<int,uint[]>();
        int p=4; ushort itemCount=BitConverter.ToUInt16(d,p); p+=2; p+=6;
        for(int id=100; id<=itemCount; id++){
            while(true){ byte at=d[p++]; if(at==255) break; int ia=Remap(at); p+= ia<0?0:AttrDataSize(ia,d,p); }
            byte w=d[p++], h=d[p++]; if(w>1||h>1) p++;
            byte layers=d[p++], px=d[p++], py=d[p++], pz=d[p++], phases=d[p++];
            if(phases>1) p += 6 + phases*8;
            int total=w*h*layers*px*py*pz*phases;
            uint[] sp=new uint[total];
            for(int i=0;i<total;i++){ sp[i]=BitConverter.ToUInt32(d,p); p+=4; }
            clientSprites[id]=sp;
        }

        // greedily pick single-sprite grounds with pairwise-disjoint sprites
        // diagnostico dos ids que estavam em uso
        int[] check={101,357,359,360};
        Console.WriteLine("--- diagnostico dos ids em uso ---");
        foreach(int sv in check){
            string g = groundServerToClient.ContainsKey(sv) ? ("ground client="+groundServerToClient[sv]+" flags=0x"+groundFlags[sv].ToString("X")+((groundFlags[sv]&1)!=0?" BLOCK_SOLID":"")+((groundFlags[sv]&4)!=0?" BLOCK_PATH":"")) : "NAO e ground (group!=1)";
            Console.WriteLine("server "+sv+": "+g);
        }

        var usedSprites=new HashSet<uint>();
        int picked=0;
        Console.WriteLine("--- grounds andaveis (sem BLOCK_SOLID/PATH), single-sprite, disjuntos ---");
        Console.WriteLine("server\tclient\tsprite\tflags");
        foreach(var kv in groundServerToClient){
            int sv=kv.Key, cl=kv.Value;
            if((groundFlags[sv] & 5)!=0) continue;        // pula BLOCK_SOLID(1) e BLOCK_PATHFIND(4)
            if(!clientSprites.ContainsKey(cl)) continue;
            uint[] sp=clientSprites[cl];
            if(sp.Length!=1 || sp[0]==0) continue;       // single, non-blank
            if(usedSprites.Contains(sp[0])) continue;     // disjoint
            usedSprites.Add(sp[0]);
            Console.WriteLine(sv+"\t"+cl+"\t"+sp[0]+"\t0x"+groundFlags[sv].ToString("X"));
            if(++picked>=12) break;
        }
    }
}
