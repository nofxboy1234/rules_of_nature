local Game = class('Game')

local sti = require "lib.sti"

function Game:initialize()
  print("Game:initialize()")

  self.map = sti.new("maps/test")
  -- Get the platforms object layer
  local platformsLayer = self.map.layers["platforms"]
  -- Turn off visibility  property of platform layer so default draw() doesn't draw them
  platformsLayer.visible = false
  -- Get the collision rectangles from the platforms layer
  self.rectangles = platformsLayer.objects

  -- for _,rect in ipairs(self.rectangles) do
  --   print(rect.x)
  -- end

  self.blocks = {}
  self.instructions = [[
    bump.lua simple demo

      arrows: move
      tab: toggle debug info
      delete: run garbage collector
  ]]

  -- World creation
  world = bump.newWorld()

  player:reset_pos()
  world:add(player, player.l, player.t, player.w, player.h)

  -- Add the collision rectangle from the platforms layer to the
  -- list of blocks to be drawn, and the bump world, for collision
  for _,rect in ipairs(self.rectangles) do
    self:addBlock(rect.x, rect.y, rect.width, rect.height)
  end

  if playMusic then
    self.music = love.audio.newSource("sounds/04_Kill_U_2wise_Over.mp3", "stream")
    self.music:setLooping(true)
    self.music:setVolume(0.2)
    self.music:play()
  end

end

function Game:update(dt)
  self.map:update(dt)

  player:update(dt)
end

function Game:draw()
  self.map:draw()

  self:drawBlocks()
  player:draw()
  if shouldDrawDebug then self:drawDebug() end
  self:drawMessage()
end

function Game:keypressed(k, isrepeat)
  if k == "escape" then
    if playMusic then
      self.music:stop()
    end
    gamestate.switch(require("menu")())
  end

  if k=="tab"    then shouldDrawDebug = not shouldDrawDebug end
  if k=="delete" then collectgarbage("collect") end
end

function Game:keyreleased(key)
  player:keyreleased(key)
end

function Game:joystickreleased(joystick, button)
  player:joystickreleased(joystick, button)
  if (joystick == joystick_01) and (button == 8) then
    if playMusic then
      self.music:stop()
    end
    gamestate.switch(require("menu")())
  end
end

function Game:addBlock(l,t,w,h)
  local block = {l=l,t=t,w=w,h=h}
  self.blocks[#self.blocks+1] = block
  world:add(block, l,t,w,h)
end

function Game:drawBlocks()
  for _,block in ipairs(self.blocks) do
    drawBox(block, 255,0,0,_,false)
  end
end

-- Message/debug functions
function Game:drawMessage()
  local msg = self.instructions:format(tostring(shouldDrawDebug))
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(msg, 550, 10)
end

function Game:drawDebug()
  bump_debug.draw(world)

  local statistics = ("fps: %d, mem: %dKB"):format(love.timer.getFPS(), collectgarbage("count"))
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(statistics, 630, 580 )
end

return Game