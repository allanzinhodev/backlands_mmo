local npcSpeechs =
{
"Well, hello.",
"Sorry, i'm busy.",
"Ughhmm... I think that milk wasn't good.",
"Damn... im really tired...",
"Hello.",
"Seriously, PLEASE, DO NOT FART! Our senses are better than ordinary people's.",
"Hey!",
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