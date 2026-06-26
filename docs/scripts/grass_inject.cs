using System;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

// Replace the sprite(s) of a single item (default 4526 = main grass) in the
// 854 extended RGBA Tibia.spr with a PNG image. Backs up the spr first.
class GrassInject
{
    // ---- DAT parse (854) to find an item's sprite ids ----
    static int AttrDataSize(int a, byte[] d, int pos){
        if(a==24||a==21) return 4;                                       // Displacement, Light
        if(a==33){ int sl=BitConverter.ToUInt16(d,pos+6); return 6+2+sl+4; } // Market
        if(a==25||a==34||a==0||a==8||a==9||a==28||a==32||a==29) return 2;
        if(a==38) return 16;
        return 0;
    }
    static int Remap(int at){ if(at==8) return -1; if(at>8) return at-1; return at; } // 7.80-8.54

    static uint[] GetItemSprites(byte[] d, int wantId){
        int pos=4;
        ushort itemCount=BitConverter.ToUInt16(d,pos); pos+=2;
        pos+=6; // skip creature/effect/missile counts
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

    // ---- SPR ----
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

    // encode 32x32 RGBA bitmap into an spr chunk: colorKey(3)+size(u16)+ runs[transU16,colU16,col*RGBA]
    static byte[] EncodeChunk(Bitmap bmp){
        int W=32,H=32;
        Color[] px=new Color[W*H];
        for(int y=0;y<H;y++) for(int x=0;x<W;x++) px[y*W+x]=bmp.GetPixel(x,y);
        MemoryStream data=new MemoryStream(); BinaryWriter bw=new BinaryWriter(data);
        int i=0;
        while(i<W*H){
            ushort trans=0;
            while(i<W*H && px[i].A<128){ trans++; i++; }
            ushort col=0; int colStart=i;
            while(i<W*H && px[i].A>=128){ col++; i++; }
            bw.Write(trans); bw.Write(col);
            for(int j=0;j<col;j++){ Color c=px[colStart+j]; bw.Write(c.R); bw.Write(c.G); bw.Write(c.B); bw.Write((byte)0xFF); }
        }
        byte[] pix=data.ToArray();
        MemoryStream chunk=new MemoryStream(); BinaryWriter cw=new BinaryWriter(chunk);
        cw.Write((byte)255); cw.Write((byte)0); cw.Write((byte)255); // magenta color key
        cw.Write((ushort)pix.Length);
        cw.Write(pix);
        return chunk.ToArray();
    }

    static void Main(string[] args){
        string baseDir=@"C:\Users\allan\OneDrive\Desktop\backlands\otclientv8\data\things\854";
        string datPath=Path.Combine(baseDir,"Tibia.dat");
        string sprPath=Path.Combine(baseDir,"Tibia.spr");
        string imgPath=@"C:\Users\allan\OneDrive\Desktop\backlands\graphic\image.png";
        int GRASS = args.Length>0 ? int.Parse(args[0]) : 4526;

        byte[] dat=File.ReadAllBytes(datPath);
        uint[] sprites=GetItemSprites(dat,GRASS);
        if(sprites==null){ Console.WriteLine("ERRO: item "+GRASS+" nao encontrado no dat"); return; }
        Console.WriteLine("item "+GRASS+" sprite ids: "+string.Join(",",sprites));

        Bitmap srcImg=new Bitmap(Image.FromFile(imgPath));
        Console.WriteLine("imagem origem: "+srcImg.Width+"x"+srcImg.Height);
        Bitmap bmp=new Bitmap(32,32, PixelFormat.Format32bppArgb);
        using(Graphics g=Graphics.FromImage(bmp)){
            g.Clear(Color.Transparent);
            // encaixa a imagem em tamanho nativo, alinhada embaixo-direita (sem esticar)
            int dx=32-srcImg.Width, dy=32-srcImg.Height;
            if(dx<0) dx=0; if(dy<0) dy=0;
            g.DrawImageUnscaled(srcImg,dx,dy);
        }
        byte[] newChunk=EncodeChunk(bmp);
        Console.WriteLine("novo chunk bytes="+newChunk.Length);

        string bak=sprPath+".bkp-grass";
        if(!File.Exists(bak)){ File.Copy(sprPath,bak); Console.WriteLine("backup criado: "+bak); }

        byte[] spr=File.ReadAllBytes(sprPath);
        uint count; uint[] off=ReadOffsets(spr,out count);
        HashSet<uint> repl=new HashSet<uint>();
        foreach(uint s in sprites) if(s!=0) repl.Add(s);
        Console.WriteLine("spr sprites="+count+"  slots a substituir="+repl.Count);

        using(MemoryStream outMs=new MemoryStream())
        using(BinaryWriter bw=new BinaryWriter(outMs)){
            bw.Write(BitConverter.ToUInt32(spr,0));
            bw.Write(count);
            long tableOff=bw.BaseStream.Position;
            for(uint i=0;i<count;i++) bw.Write((uint)0);
            for(uint i=0;i<count;i++){
                uint sid=i+1;
                byte[] chunk = repl.Contains(sid) ? newChunk : ReadChunk(spr,off,count,sid);
                if(chunk==null) continue;
                uint addr=(uint)bw.BaseStream.Position;
                long cur=bw.BaseStream.Position;
                bw.BaseStream.Seek(tableOff+(long)i*4,SeekOrigin.Begin);
                bw.Write(addr);
                bw.BaseStream.Seek(cur,SeekOrigin.Begin);
                bw.Write(chunk);
            }
            File.WriteAllBytes(sprPath,outMs.ToArray());
        }
        Console.WriteLine("DONE: grama "+GRASS+" injetada em "+repl.Count+" slot(s).");
    }
}
