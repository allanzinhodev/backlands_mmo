using System;
using System.IO;

// Generate a small flat OTBM map made entirely of grass (item 4526), with one
// town/temple, covering the players' login position. Header (version/items) is
// replicated from the existing map for compatibility.
class MakeGrassMap
{
    const byte NODE_START=0xFE, NODE_END=0xFF, ESCAPE=0xFD;
    static MemoryStream ms;

    static void WB(byte b){ if(b==NODE_START||b==NODE_END||b==ESCAPE) ms.WriteByte(ESCAPE); ms.WriteByte(b); }
    static void Raw(byte b){ ms.WriteByte(b); }
    static void WU16(ushort v){ WB((byte)(v&0xFF)); WB((byte)((v>>8)&0xFF)); }
    static void WU32(uint v){ WB((byte)(v&0xFF)); WB((byte)((v>>8)&0xFF)); WB((byte)((v>>16)&0xFF)); WB((byte)((v>>24)&0xFF)); }
    static void WStr(string s){ WU16((ushort)s.Length); foreach(char c in s) WB((byte)c); }

    static void Main(){
        string worldDir=@"C:\Users\allan\OneDrive\Desktop\backlands\data\world";
        string outPath=Path.Combine(worldDir,"grass_test.otbm");

        // replicated header from the existing map
        uint otbmVersion=2, majorItems=3, minorItems=16;
        byte rootType=0;

        // 4 grounds andáveis (server ids; clients 386/408/417/418), xadrez 2x2 para ver as 4 variações
        ushort[] GROUNDS={384,405,414,415};
        int baseX=940, baseY=1023, baseZ=7, size=80;   // 80x80 -> x:940..1019  y:1023..1102
        int templeX=980, templeY=1063, templeZ=7;       // = players' login position

        ms=new MemoryStream();
        // 4-byte file header
        Raw(0);Raw(0);Raw(0);Raw(0);
        // ROOT
        Raw(NODE_START); Raw(rootType);
        WU32(otbmVersion); WU16(2048); WU16(2048); WU32(majorItems); WU32(minorItems);
            // MAP_DATA (2)
            Raw(NODE_START); Raw(2);
            WB(11); WStr("grass_test-spawn.xml");   // OTBM_ATTR_EXT_SPAWN_FILE
            WB(13); WStr("grass_test-house.xml");   // OTBM_ATTR_EXT_HOUSE_FILE
                // TILE_AREA (4)
                Raw(NODE_START); Raw(4);
                WU16((ushort)baseX); WU16((ushort)baseY); WB((byte)baseZ);
                Random rng=new Random(12345);       // seed fixa: layout aleatório porém estável
                for(int y=0;y<size;y++) for(int x=0;x<size;x++){
                    ushort ground=GROUNDS[rng.Next(GROUNDS.Length)];   // tile aleatório das 4 variações
                    Raw(NODE_START); Raw(5);        // TILE
                    WB((byte)x); WB((byte)y);
                    WB(9); WU16(ground);            // OTBM_ATTR_ITEM -> ground
                    Raw(NODE_END);
                }
                Raw(NODE_END);                      // end TILE_AREA
                // TOWNS (12)
                Raw(NODE_START); Raw(12);
                    Raw(NODE_START); Raw(13);       // TOWN
                    WU32(1); WStr("Grass"); WU16((ushort)templeX); WU16((ushort)templeY); WB((byte)templeZ);
                    Raw(NODE_END);
                Raw(NODE_END);                      // end TOWNS
            Raw(NODE_END);                          // end MAP_DATA
        Raw(NODE_END);                              // end ROOT

        File.WriteAllBytes(outPath, ms.ToArray());
        Console.WriteLine("WROTE "+outPath+"  bytes="+ms.Length+"  tiles="+(size*size)+"  temple="+templeX+","+templeY+","+templeZ);
    }
}
