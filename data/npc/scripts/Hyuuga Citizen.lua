local npcSpeechs =
{
"Gai Sensei taijutsu is insane... If he had the Hyuuga Kekkei Genkai, he would be the strongest ninja on the village.",
"Well, hello.",
"Sorry, i'm busy.",
"That Ronuru is a shame to our clan. He keep saying those common words and saying that he is going to be a Hokage, and he is not even from the main family...",
"Ughhmm... I think that milk wasn't good.",
"Damn... im really tired...",
"Hello.",
"What if we had an internal conflict like the Uchihas had? Konoha power would colapse and we could enter on a new world war. That is why we have to maintain our rigorous tradictions.",

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