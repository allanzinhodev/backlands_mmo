local npcSpeechs =
{
"I think Gai Sensei is going to kill his pupil someday. Their train is insane... poor kid.",
"Oh, hi.",
"Did you heard about Akatsuki? Last week they ambushed some Kiri ANBU members, and they say that Uchiha Itachi, the golden boy, was the one who did that. Do you believe? He, an Uchiha, at Akatsuki?!",
"Bleeeeeeergh... what? I'm tring to take something from my mouth, get away!",
"Those kids are unbeliavible... Yesterday they threw poop at my window. POOP. Do you believe that? In some time, Sandaime is going to have to put Ibiki to take care of those kids.",
"Sorry, i'm busy.",
"I think Kakashi is SOOO sexy with that ANBU armor... oh god *o*",
"Ughhmm... I think that milk wasn't good.",
"Shot through the heart, and you're to blame darling, you ... oh, sorry! What's up?", -- Kakashi 
"Ahhh, what a good day! I love Konoha in days like that!",
"Hello.",
"Poor Uchihas... Now there are only that kid, brother of the traitor, and the group who came from the mission at suna...",

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