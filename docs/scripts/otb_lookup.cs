using System;
using System.IO;
using System.Collections.Generic;

// Parse items.otb and print server<->client id mapping for grounds / specific ids.
class OtbLookup
{
    const byte NODE_START=0xFE, NODE_END=0xFF, ESCAPE=0xFD;
    const byte ATTR_SERVERID=0x10, ATTR_CLIENTID=0x11;

    static void Main(string[] args){
        string path=@"C:\Users\allan\OneDrive\Desktop\backlands\data\items\items.otb";
        byte[] raw=File.ReadAllBytes(path);
        // unescape whole stream into tokens is hard; we walk and unescape inline.
        int pos=4; // skip 4-byte file header
        // expect root NODE_START
        var serverToClient=new Dictionary<int,int>();
        var clientToServer=new Dictionary<int,int>();
        var serverToGroup=new Dictionary<int,int>();

        // simple recursive-ish walk: we only care about leaf item nodes' attributes.
        // Stack of node depth not needed; we scan for NODE_START, read group byte, flags(4), then attrs until NODE_END.
        // Root node also has this shape; its attributes get read & ignored (no serverid).
        while(pos<raw.Length){
            byte b=raw[pos++];
            if(b!=NODE_START) continue;
            // node: group(1)
            byte group=ReadRaw(raw, ref pos);
            // flags u32
            uint flags=ReadU32(raw, ref pos);
            int serverId=-1, clientId=-1;
            // attributes until NODE_END (but child NODE_START means this node has children -> handle)
            while(pos<raw.Length){
                byte peek=raw[pos];
                if(peek==NODE_END){ pos++; break; }
                if(peek==NODE_START){ break; } // child node: let outer loop pick it up
                byte attr=ReadRaw(raw, ref pos);
                ushort len=(ushort)(ReadRaw(raw,ref pos) | (ReadRaw(raw,ref pos)<<8));
                byte[] data=new byte[len];
                for(int i=0;i<len;i++) data[i]=ReadRaw(raw, ref pos);
                if(attr==ATTR_SERVERID && len>=2) serverId=data[0]|(data[1]<<8);
                else if(attr==ATTR_CLIENTID && len>=2) clientId=data[0]|(data[1]<<8);
            }
            if(serverId>=0 && clientId>=0){
                serverToClient[serverId]=clientId;
                serverToGroup[serverId]=group;
                if(!clientToServer.ContainsKey(clientId)) clientToServer[clientId]=serverId;
            }
        }

        Console.WriteLine("total mapped items="+serverToClient.Count);
        Console.WriteLine("--- reverse: client -> server (group) para tiles candidatos ---");
        int[] wantClients={107,405,406,4526};
        foreach(int wc in wantClients){
            if(clientToServer.ContainsKey(wc)){
                int sv=clientToServer[wc];
                Console.WriteLine("client "+wc+"  <- server "+sv+"  group="+serverToGroup[sv]+(serverToGroup[sv]==1?" (GROUND)":" (NAO-GROUND!)"));
            } else Console.WriteLine("client "+wc+"  <- (nenhum server)");
        }
        int[] q = {4526,4527,4528,4529,4530,106,4540,4541};
        foreach(int s in q){ if(serverToClient.ContainsKey(s)) Console.WriteLine("server "+s+" -> client "+serverToClient[s]); }
        Console.WriteLine("--- reverse: which server id renders as client 4526 ---");
        if(clientToServer.ContainsKey(4526)) Console.WriteLine("client 4526 <- server "+clientToServer[4526]);
        else Console.WriteLine("nenhum server id mapeia para client 4526");
        // list a few grounds whose client id is in grass range
        Console.WriteLine("--- server ids cujo client esta em 4526..4541 ---");
        foreach(var kv in serverToClient){ if(kv.Value>=4526 && kv.Value<=4541) Console.WriteLine("server "+kv.Key+" -> client "+kv.Value); }
    }

    static byte ReadRaw(byte[] d, ref int pos){
        byte b=d[pos++];
        if(b==ESCAPE) b=d[pos++];
        return b;
    }
    static uint ReadU32(byte[] d, ref int pos){
        uint v=0; for(int i=0;i<4;i++) v |= (uint)ReadRaw(d,ref pos)<<(8*i); return v;
    }
}
