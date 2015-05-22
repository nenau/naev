--[[

   Accurate ship positioning using control theory

   Usage : asserv(myPilot, targetPilot, offset, Kp, Kd) : myPilot will try to join the position given by the sum of targetPilot's position and offset.

   myPilot and targetPilot are compulsory and offset, Kp, Kd are optionnal

   If Kp goes upper, the ship's answer is more accurate and faster, but the risk to become unstable rises
   If Kd goes upper, the ship's answer is less accurate and faster, and the risk to become unstable falls

   In general, a heavy ship has more risk to be unstable

   By default, offset = vec2(0,0), Kp = 10, Kd = 200
   offset = vec2(0,0), Kp = 1, Kd = 0 gives exactly the same results as pliot.follow()

--]]

function asserv(myPilot, target, offset, Kp, Kd)

   if not myPilot then
      error "need a pilot as first argument"
   end

   if not target then
      error "need a pilot as second argument"
   end

   if not offset then
      offset = vec2.new(0, 0)
   end

   if not Kp then
      Kp = 10
   end

   if not Kd then
      Kd = 200
   end

   --Create the table where the data is stored
   if not asservmem then
      asservmem = {}
   end
   asservmem[myPilot:id()] = vec2.new(0, 0)

   controlLoop({myPilot, target, offset, Kp, Kd})
   
end

function controlLoop(data)
   local myPilot = data[1]
   local target = data[2]
   local offset = data[3]
   local Kp = data[4]
   local Kd = data[5]

   local lastdist = asservmem[myPilot:id()]

   -- do vectorial operations
   local prop = target:pos() + offset - myPilot:pos()

   local deri = prop - lastdist      -- the derivative of the distance

   local cons = prop*Kp + deri*Kd

   local goal = cons + myPilot:pos()

   --p:stats().thrust

   myPilot:control()   --clear orders
   if cons:mod() >= 300 then
      myPilot:goto(goal, false, false)
      else
      myPilot:face(goal)
   end
   
   myPilot:face(target:pos())
   --print(goal:mod())

   --update the memo
   asservmem[myPilot:id()] = prop

   thook = hook.timer(100, "controlLoop", data) -- re-calls itself
end
