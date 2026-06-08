local npcSpeechs =
{
"Hi.",
"Sorry, i'm busy.",
"Hello.",
"I see dead people.",
"Damn... im really tired...",
"Shibi is the pride of our clan. He is one of the greatest ninjas Konoha has ever seen.",
"Our clan is really strong, but we do not keep showing our force and claming we are the best, like the other clans.",

}

local focuses, controlId = {}, 3580

local talkState = {}


function onCreatureSay(cid, type, msg)
    if msgcontains(msg, "hi", "hello") and not isFocused(cid, focuses) and getDistanceToCreature(cid) < 5 then
       local _msg = npcSpeechs[math.random(1, #npcSpeechs)]
       selfSay(_msg, cid)
    end
    return true
end