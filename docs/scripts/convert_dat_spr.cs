using System;
using System.IO;
using System.Collections.Generic;

class Converter
{
    // Constants mapping for Tibia DAT format (780+)
    const byte ATTR_GROUND = 0;
    const byte ATTR_WRITABLE = 8;
    const byte ATTR_WRITABLE_ONCE = 9;
    const byte ATTR_LIGHT = 21;
    const byte ATTR_DISPLACEMENT = 24;
    const byte ATTR_ELEVATION = 25;
    const byte ATTR_MINIMAP_COLOR = 28;
    const byte ATTR_LENS_HELP = 29;
    const byte ATTR_CLOTH = 32;
    const byte ATTR_MARKET = 33;
    const byte ATTR_USABLE = 34;
    const byte ATTR_BONES = 38;
    const byte ATTR_LAST = 255;

    const int CATEGORY_ITEM = 0;
    const int CATEGORY_CREATURE = 1;
    const int CATEGORY_EFFECT = 2;
    const int CATEGORY_MISSILE = 3;

    static void Main(string[] args)
    {
        string baseDir = @"C:\Users\allan\OneDrive\Desktop\Project\otclientv8\data\things\854";
        string datPath = Path.Combine(baseDir, "Tibia.dat");
        string sprPath = Path.Combine(baseDir, "Tibia.spr");

        if (!File.Exists(datPath))
        {
            Console.WriteLine("ERRO: DAT nao encontrado: " + datPath);
            return;
        }

        if (!File.Exists(sprPath))
        {
            Console.WriteLine("ERRO: SPR nao encontrado: " + sprPath);
            return;
        }

        string datBak = datPath + ".bak";
        string sprBak = sprPath + ".bak";

        if (!File.Exists(datBak))
        {
            Console.WriteLine("Criando backup: " + datBak);
            File.Copy(datPath, datBak);
        }

        if (!File.Exists(sprBak))
        {
            Console.WriteLine("Criando backup: " + sprBak);
            File.Copy(sprPath, sprBak);
        }

        Console.WriteLine("\n=== Convertendo DAT ===");
        ConvertDat(datPath);

        Console.WriteLine("\n=== Convertendo SPR ===");
        ConvertSpr(sprPath);

        Console.WriteLine("\n=== Conversao completa! ===");
    }

    static int GetInternalAttr(int onDiskAttr)
    {
        if (onDiskAttr == 8) return -1;
        if (onDiskAttr > 8) return onDiskAttr - 1;
        return onDiskAttr;
    }

    static int SkipAttrData(byte[] data, int pos, int onDiskAttr)
    {
        int internalAttr = GetInternalAttr(onDiskAttr);
        if (internalAttr == -1) return pos;

        if (internalAttr == ATTR_GROUND || internalAttr == ATTR_WRITABLE || internalAttr == ATTR_WRITABLE_ONCE ||
            internalAttr == ATTR_ELEVATION || internalAttr == ATTR_MINIMAP_COLOR || internalAttr == ATTR_LENS_HELP ||
            internalAttr == ATTR_CLOTH || internalAttr == ATTR_USABLE)
        {
            return pos + 2;
        }
        else if (internalAttr == ATTR_LIGHT || internalAttr == ATTR_DISPLACEMENT)
        {
            return pos + 4;
        }
        else if (internalAttr == ATTR_MARKET)
        {
            pos += 6;
            int strLen = BitConverter.ToUInt16(data, pos);
            pos += 2 + strLen;
            return pos + 4;
        }
        else if (internalAttr == ATTR_BONES)
        {
            return pos + 16;
        }
        return pos;
    }

    static void ConvertDat(string path)
    {
        byte[] data = File.ReadAllBytes(path);
        int pos = 0;

        using (MemoryStream ms = new MemoryStream())
        using (BinaryWriter outWriter = new BinaryWriter(ms))
        {
            uint signature = BitConverter.ToUInt32(data, pos); pos += 4;
            outWriter.Write(signature);

            ushort[] counts = new ushort[4];
            for (int i = 0; i < 4; i++)
            {
                counts[i] = BitConverter.ToUInt16(data, pos); pos += 2;
                outWriter.Write(counts[i]);
            }

            int converted = 0;
            int animatedCount = 0;

            for (int category = 0; category < 4; category++)
            {
                int firstId = (category == CATEGORY_ITEM) ? 100 : 1;
                int count = counts[category];

                for (int thingId = firstId; thingId <= count; thingId++)
                {
                    int attrsStart = pos;
                    while (true)
                    {
                        byte attr = data[pos++];
                        if (attr == ATTR_LAST) break;
                        pos = SkipAttrData(data, pos, attr);
                    }

                    outWriter.Write(data, attrsStart, pos - attrsStart);

                    bool isCreature = (category == CATEGORY_CREATURE);
                    if (isCreature)
                    {
                        outWriter.Write((byte)1); // groupCount = 1
                        outWriter.Write((byte)0); // frameGroupType = 0
                    }

                    byte width = data[pos++]; outWriter.Write(width);
                    byte height = data[pos++]; outWriter.Write(height);

                    if (width > 1 || height > 1)
                    {
                        outWriter.Write(data[pos++]);
                    }

                    byte layers = data[pos++]; outWriter.Write(layers);
                    byte patternX = data[pos++]; outWriter.Write(patternX);
                    byte patternY = data[pos++]; outWriter.Write(patternY);
                    byte patternZ = data[pos++]; outWriter.Write(patternZ);
                    byte animPhases = data[pos++]; outWriter.Write(animPhases);

                    if (animPhases > 1)
                    {
                        animatedCount++;
                        uint minDur = 0, maxDur = 0;
                        if (category == CATEGORY_ITEM) { minDur = 500; maxDur = 500; }
                        else if (category == CATEGORY_CREATURE) { minDur = 300; maxDur = 300; }
                        else { minDur = 75; maxDur = 75; }

                        if (category == CATEGORY_EFFECT || category == CATEGORY_MISSILE)
                        {
                            outWriter.Write((byte)0); // async = true
                            outWriter.Write((int)1);  // loopCount = 1
                            outWriter.Write((sbyte)0); // startPhase = 0
                        }
                        else
                        {
                            outWriter.Write((byte)1); // async = false
                            outWriter.Write((int)0);  // loopCount = infinite
                            outWriter.Write((sbyte)0); // startPhase = 0
                        }

                        for (int i = 0; i < animPhases; i++)
                        {
                            outWriter.Write(minDur);
                            outWriter.Write(maxDur);
                        }
                    }

                    int totalSprites = width * height * layers * patternX * patternY * patternZ * animPhases;
                    for (int i = 0; i < totalSprites; i++)
                    {
                        ushort spriteId = BitConverter.ToUInt16(data, pos); pos += 2;
                        outWriter.Write((uint)spriteId); // Convert U16 to U32
                    }
                    converted++;
                }
            }

            File.WriteAllBytes(path, ms.ToArray());
            Console.WriteLine(string.Format("  DAT convertido com sucesso! Things: {0}, animados: {1}", converted, animatedCount));
        }
    }

    static void ConvertSpr(string path)
    {
        byte[] data = File.ReadAllBytes(path);
        int pos = 0;

        uint signature = BitConverter.ToUInt32(data, pos); pos += 4;
        ushort spriteCount = BitConverter.ToUInt16(data, pos); pos += 2;

        Console.WriteLine(string.Format("  SPR original: {0} sprites", spriteCount));

        uint[] spriteAddresses = new uint[spriteCount];
        for (int i = 0; i < spriteCount; i++)
        {
            spriteAddresses[i] = BitConverter.ToUInt32(data, pos); pos += 4;
        }

        List<Tuple<byte[], byte[]>> convertedSprites = new List<Tuple<byte[], byte[]>>();
        int spritesWithData = 0;

        for (int i = 0; i < spriteCount; i++)
        {
            uint addr = spriteAddresses[i];
            if (addr == 0)
            {
                convertedSprites.Add(null);
                continue;
            }

            spritesWithData++;
            int spos = (int)addr;

            byte[] colorKey = new byte[3];
            Array.Copy(data, spos, colorKey, 0, 3);
            spos += 3;

            ushort pixelDataSize = BitConverter.ToUInt16(data, spos); spos += 2;

            using (MemoryStream chunkStream = new MemoryStream())
            using (BinaryWriter chunkWriter = new BinaryWriter(chunkStream))
            {
                int read = 0;
                while (read < pixelDataSize)
                {
                    ushort transparentPixels = BitConverter.ToUInt16(data, spos); spos += 2;
                    ushort coloredPixels = BitConverter.ToUInt16(data, spos); spos += 2;
                    read += 4;

                    chunkWriter.Write(transparentPixels);
                    chunkWriter.Write(coloredPixels);

                    for (int j = 0; j < coloredPixels; j++)
                    {
                        chunkWriter.Write(data[spos]);
                        chunkWriter.Write(data[spos + 1]);
                        chunkWriter.Write(data[spos + 2]);
                        chunkWriter.Write((byte)0xFF); // Alpha channel
                        spos += 3;
                        read += 3;
                    }
                }
                convertedSprites.Add(new Tuple<byte[], byte[]>(colorKey, chunkStream.ToArray()));
            }
        }

        using (MemoryStream ms = new MemoryStream())
        using (BinaryWriter outWriter = new BinaryWriter(ms))
        {
            outWriter.Write(signature);
            outWriter.Write((uint)spriteCount); // U32 sprite count

            long addrTableOffset = outWriter.BaseStream.Position;
            for (int i = 0; i < spriteCount; i++)
            {
                outWriter.Write((uint)0);
            }

            for (int i = 0; i < spriteCount; i++)
            {
                if (convertedSprites[i] == null) continue;

                uint spriteAddr = (uint)outWriter.BaseStream.Position;
                long currentPos = outWriter.BaseStream.Position;

                outWriter.BaseStream.Seek(addrTableOffset + i * 4, SeekOrigin.Begin);
                outWriter.Write(spriteAddr);
                outWriter.BaseStream.Seek(currentPos, SeekOrigin.Begin);

                var sprite = convertedSprites[i];
                outWriter.Write(sprite.Item1); // Color key
                outWriter.Write((ushort)sprite.Item2.Length);
                outWriter.Write(sprite.Item2);
            }

            File.WriteAllBytes(path, ms.ToArray());
            Console.WriteLine(string.Format("  SPR convertido com sucesso! Sprites validados: {0}/{1}", spritesWithData, spriteCount));
        }
    }
}
