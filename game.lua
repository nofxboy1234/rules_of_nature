local Game = class('Game')

function Game:initialize()
  print("Game:initialize()")
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

  self:addBlock(0,       0,     800, 32)
  self:addBlock(0,      32,      32, 600-32*2)
  self:addBlock(800-32, 32,      32, 600-32*2)
  self:addBlock(0,      600-32, 800, 32)

  for i=1,30 do
    self:addBlock( math.random(100, 600),
              math.random(100, 400),
              math.random(10, 100),
              math.random(10, 100)
    )
  end

end

function Game:update(dt)
  player:update(dt)
end

function Game:draw()
  self:drawBlocks()
  player:draw()
  if shouldDrawDebug then self:drawDebug() end
  self:drawMessage()
end

function Game:keypressed(k, isrepeat)
  -- if k=="escape" then love.event.quit() end
  if k=="escape" then gamestate.switch(require("menu")()) end
  if k=="tab"    then shouldDrawDebug = not shouldDrawDebug end
  if k=="delete" then collectgarbage("collect") end
end

function Game:keyreleased(key)
  player:keyreleased(key)
end

function Game:joystickreleased(joystick, button)
  player:joystickreleased(joystick, button)
  if (joystick == joystick_01) and (button == 8) then
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
    drawBox(block, 255,0,0)
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