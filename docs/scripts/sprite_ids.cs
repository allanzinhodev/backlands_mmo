using System;
using System.IO;

// Print sprite ids for a list of client item ids (854 extended dat). No modification.
class SpriteIds
{
    static int AttrDataSize(int a, byte[] d, int pos){
        if(a==24||a==21) return 4;
        if(a==33){ int sl=BitConverter.ToUInt16(d,pos+6); return 6+2+sl+4; }
        if(a==25||a==34||a==0||a==8||a==9||a==28||a==32||a==29) return 2;
        if(a==38) return 16;
        return 0;
    }
    static int Remap(int at){ if(at==8) return -1; if(at>8) return at-1; return at; }

    static void Main(string[] args){
        string datPath=@"C:\Users\allan\OneDrive\Desktop\backlands\otclientv8\data\things\854\Tibia.dat";
        byte[] d=File.ReadAllBytes(datPath);
        // candidate ground client ids from different families
        int[] q = {4526,4405,4406,351,352,231,405,406,106,107,103,104,594,593,5405,5406,4615,4616};
        var want=new System.Collections.Generic.HashSet<int>(q);

        int pos=4;
        ushort itemCount=BitConverter.ToUInt16(d,pos); pos+=2; pos+=6;
        for(int id=100; id<=itemCount; id++){
            while(true){ byte at=d[pos++]; if(at==255) break; int ia=Remap(at); pos+= ia<0?0:AttrDataSize(ia,d,pos); }
            byte w=d[pos++], h=d[pos++];
            if(w>1||h>1) pos++;
            byte layers=d[pos++], px=d[pos++], py=d[pos++], pz=d[pos++], phases=d[pos++];
            if(phases>1) pos += 6 + phases*8;
            int total=w*h*layers*px*py*pz*phases;
            uint[] sp=new uint[total];
            for(int i=0;i<total;i++){ sp[i]=BitConverter.ToUInt32(d,pos); pos+=4; }
            if(want.Contains(id))
                Console.WriteLine("client "+id+"  ["+w+"x"+h+" l"+layers+" pat"+px+"x"+py+" ph"+phases+"]  n="+total+"  sprites="+string.Join(",",sp));
        }
    }
}
