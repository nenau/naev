--[[

   Diversion from Raelid.
   Copyright (C) 2014, 2015 Julian Marchant <onpon4@riseup.net>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

--]]

include "dat/missions/flf/flf_diversion.lua"

-- localization stuff
lang = naev.lang()
if lang == "notreal" then
else -- default English
   title = {}
   text = {}

   title[1] = "Taking One for the Team"
   text[1] = [[The FLF officer smiles as he sees you approaching him.
    "Ah, if it isn't %s!" he says. "I think you might be perfect for this job. See, my team and I are going to be conducting an important covert operation in Raelid. I won't bore you with the details of that operation, but I need someone to distract the Dvaered forces while we do this. You'll basically need to travel to the %s system and wreak havoc there, make yourself a really visible target so we can conduct our operation inconspicuously. Would you be interested?"]]

   text[2] = [["Great! I and my team will be hiding out around Raelid until we get a chance to conduct the operation. I will message you when we succeed. Good luck, and try not to get yourself killed!" With that, he smiles and walks off, presumably to prepare his team for takeoff.]]

   title[3] = "Maybe Another Time"
   text[3] = [["OK, then. Feel free to come back if you change your mind."]]

   success_text = {}
   success_text[1] = [[You receive a transmission. It's from the leading officer. "Operation successful, soldier!" he says. "You should get back to the base now before you get killed! I'll be waiting for you there."]]

   pay_text = {}
   pay_text[1] = [[As you dock the station, the leading officer approaches you with a smile. "Thank you for your help," he says. "The mission was a rousing success! What we've accomplished will greatly help our efforts against the Dvaereds in the future." He hands you a credit chip. "That's your payment for the distraction. I hope to work with you again, soldier!" And with that, you shake hands and part ways. It occurs to you that you never learned what the mission actually was. Perhaps you will find out later.]]

   npc_name = "FLF officer"
   npc_desc = "An FLF officer leading an operation seems to be in search of another pilot."
end


function create ()
   missys = system.get( "Doranthex" )
   if not misn.claim( missys ) then misn.finish( false ) end

   local num_dvaereds = missys:presences()["Dvaered"]
   dv_attention_target = num_dvaereds / 20
   credits = 200000
   reputation = 20

   misn.setNPC( npc_name, "neutral/thief1" )
   misn.setDesc( npc_desc )
end


function accept ()
   if tk.yesno( title[1], text[2]:format( player.name(), missys:name() ) ) then
      tk.msg( title[1], text[2] )

      misn.accept()

      osd_desc[1] = osd_desc[1]:formt( missys:name() )
      misn.osdCreate( osd_title, osd_desc )

      dv_attention = 0
      job_done = false

      hook.enter( "enter" )
      hook.jumpout( "leave" )
      hook.land( "leave" )
   else
      tk.msg( title[3], text[3] )
   end
end


function land ()
   if planet.cur():faction():name() == "FLF" then
      tk.msg( "", pay_text[ rnd.rnd( 1, #pay_text ) ] )
      player.pay( credits )
      var.push( "_fcap_flf", 40 )
      faction.get("FLF"):modPlayer( reputation )
      misn.finish( true )
   end
end
