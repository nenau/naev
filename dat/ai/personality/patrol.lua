-- Default task to run when idle
function idle ()
   if ai.pilot():name() == "toto" then print("idle") end
   if mem.loiter == nil then mem.loiter = 3 end
   if mem.loiter == 0 then -- Try to leave.
       local planet = ai.landplanet( mem.land_friendly )
       -- planet must exist
       if planet == nil or mem.land_planet == false then
          ai.settimer(0, rnd.int(1000, 3000))
          ai.pushtask("enterdelay")
       else
          mem.land = planet:pos()
          ai.pushtask("hyperspace")
          if not mem.tookoff then
             ai.pushtask("land")
          end
       end
   else -- Stay. Have a beer.
      if mem.followlanes then
         if ai.pilot():name() == "toto" then print("followlane") end
         goal = ai.pilot():getNode()
         ai.pushtask("goto_path", goal)
      else
         sysrad = rnd.rnd() * system.cur():radius()
         angle = rnd.rnd() * 2 * math.pi
         ai.pushtask("__goto_nobrake", vec2.new(math.cos(angle) * sysrad, math.sin(angle) * sysrad))
      end
   end
   mem.loiter = mem.loiter - 1
end

-- Settings
mem.land_friendly = true -- Land on only friendly by default
