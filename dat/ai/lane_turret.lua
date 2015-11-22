include("dat/ai/tpl/sentry.lua")
include("dat/ai/personality/turret.lua")

-- Settings
mem.aggressive = true


function create ()

   -- Not too many credits.
   ai.setcredits( rnd.rnd(ai.pilot():ship():price()/300, ai.pilot():ship():price()/70) )

   -- See if can be bribed
   if rnd.rnd() > 0.7 then
      mem.bribe = math.sqrt( ai.pilot():stats().mass ) * (500. * rnd.rnd() + 1750.)
      mem.bribe_prompt = string.format("\"For some %d credits I could forget about seeing you.\"", mem.bribe )
      mem.bribe_paid = "\"Now scram before I change my mind.\""
   else
     bribe_no = {
            "\"You won't buy your way out of this one.\"",
            "\"You've made a huge mistake.\"",
            "\"Bribery carries a harsh penalty, scum.\"",
            "\"I'm not interested in your blood money!\"",
            "\"All the money in the world won't save you now!\""
     }
     mem.bribe_no = bribe_no[ rnd.rnd(1,#bribe_no) ]
     
   end

   -- Finish up creation
   create_post()
end

-- taunts
function taunt ( target, offense )

   -- Only 50% of actually taunting.
   if rnd.rnd(0,1) == 0 then
      return
   end

   -- some taunts
   if offense then
      taunts = {
            "Enjoy your last moments, criminal!"
      }
   else
      taunts = {
            "Static defense under attack!"
      }
   end

   ai.pilot():comm(target, taunts[ rnd.rnd(1,#taunts) ])
end


