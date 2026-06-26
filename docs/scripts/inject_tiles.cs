using System;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

// Slice graphic/tiles.png (4 x 32x32 in a row) and inject each tile into a distinct
// client ground item's sprites in the 854 extended Tibia.spr (single rewrite).
class InjectTiles
{
    static int AttrDataSize(int a, byte[] d, int pos){
        if(a==24||a==21) return 4;
        if(a==33){ int sl=BitConverter.ToUInt16(d,pos+6); return 6+2+sl+4; }
        if(a==25||a==34||a==0||a==8||a==9||a==28||a==32||a==29) return 2;
        if(a==38) return 16;
        return 0;
    }
    static int Remap(int at){ if(at==8) return -1; if(at>8) return at-1; return at; }
    static uint[] GetItemSprites(byte[] d, int wantId){
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
            if(id==wantId) return sp;
        }
        return null;
    }
    static uint[] ReadOffsets(byte[] d, out uint count){
        count=BitConverter.ToUInt32(d,4);
        uint[] off=new uint[count]; int pos=8;
        for(uint i=0;i<count;i++){ off[i]=BitConverter.ToUInt32(d,pos); pos+=4; }
        return off;
    }
    static byte[] ReadChunk(byte[] d, uint[] off, uint count, uint sid){
        if(sid==0||sid>count) return null;
        uint addr=off[sid-1]; if(addr==0) return null;
        int p=(int)addr; ushort size=BitConverter.ToUInt16(d,p+3);
        byte[] c=new byte[3+2+size]; Array.Copy(d,p,c,0,c.Length); return c;
    }
    static byte[] EncodeChunk(Bitmap bmp){
        int W=32,H=32; Color[] px=new Color[W*H];
        for(int y=0;y<H;y++) for(int x=0;x<W;x++) px[y*W+x]=bmp.GetPixel(x,y);
        MemoryStream data=new MemoryStream(); BinaryWriter bw=new BinaryWriter(data);
        int i=0;
        while(i<W*H){
            ushort trans=0; while(i<W*H && px[i].A<128){ trans++; i++; }
            ushort col=0; int colStart=i; while(i<W*H && px[i].A>=128){ col++; i++; }
            bw.Write(trans); bw.Write(col);
            for(int j=0;j<col;j++){ Color c=px[colStart+j]; bw.Write(c.R); bw.Write(c.G); bw.Write(c.B); bw.Write((byte)0xFF); }
        }
        byte[] pix=data.ToArray();
        MemoryStream chunk=new MemoryStream(); BinaryWriter cw=new BinaryWriter(chunk);
        cw.Write((byte)255); cw.Write((byte)0); cw.Write((byte)255);
        cw.Write((ushort)pix.Length); cw.Write(pix);
        return chunk.ToArray();
    }

    static void Main(){
        string baseDir=@"C:\Users\allan\OneDrive\Desktop\backlands\otclientv8\data\things\854";
        string datPath=Path.Combine(baseDir,"Tibia.dat");
        string sprPath=Path.Combine(baseDir,"Tibia.spr");
        string imgPath=@"C:\Users\allan\OneDrive\Desktop\backlands\graphic\tiles.png";
        int[] clientIds={386,408,417,418};   // clients dos grounds andaveis server 384/405/414/415

        byte[] dat=File.ReadAllBytes(datPath);
        Bitmap sheet=new Bitmap(Image.FromFile(imgPath));
        Console.WriteLine("tiles.png="+sheet.Width+"x"+sheet.Height+"  -> "+clientIds.Length+" tiles de 32x32");

        // build sprite-id -> chunk replacement map across all 4 tiles
        var repl=new Dictionary<uint,byte[]>();
        for(int t=0;t<clientIds.Length;t++){
            Bitmap bmp=new Bitmap(32,32,PixelFormat.Format32bppArgb);
            using(Graphics g=Graphics.FromImage(bmp)){
                g.Clear(Color.Transparent);
                g.DrawImage(sheet, new Rectangle(0,0,32,32), new Rectangle(t*32,0,32,32), GraphicsUnit.Pixel);
            }
            byte[] chunk=EncodeChunk(bmp);
            uint[] sprites=GetItemSprites(dat,clientIds[t]);
            if(sprites==null){ Console.WriteLine("ERRO: client "+clientIds[t]+" nao achado"); return; }
            int n=0; foreach(uint s in sprites){ if(s!=0){ repl[s]=chunk; n++; } }
            Console.WriteLine("tile "+t+" -> client "+clientIds[t]+"  ("+n+" sprite slots)");
        }

        string bak=sprPath+".bkp-tiles";
        if(!File.Exists(bak)) File.Copy(sprPath,bak);

        byte[] spr=File.ReadAllBytes(sprPath);
        uint count; uint[] off=ReadOffsets(spr,out count);
        Console.WriteLine("spr sprites="+count+"  total slots a substituir="+repl.Count);

        using(MemoryStream outMs=new MemoryStream())
        using(BinaryWriter bw=new BinaryWriter(outMs)){
            bw.Write(BitConverter.ToUInt32(spr,0)); bw.Write(count);
            long tableOff=bw.BaseStream.Position;
            for(uint i=0;i<count;i++) bw.Write((uint)0);
            for(uint i=0;i<count;i++){
                uint sid=i+1;
                byte[] chunk = repl.ContainsKey(sid) ? repl[sid] : ReadChunk(spr,off,count,sid);
                if(chunk==null) continue;
                uint addr=(uint)bw.BaseStream.Position; long cur=bw.BaseStream.Position;
                bw.BaseStream.Seek(tableOff+(long)i*4,SeekOrigin.Begin); bw.Write(addr);
                bw.BaseStream.Seek(cur,SeekOrigin.Begin); bw.Write(chunk);
            }
            File.WriteAllBytes(sprPath,outMs.ToArray());
        }
        Console.WriteLine("DONE: 4 tiles injetados.");
    }
}
