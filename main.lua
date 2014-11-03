class = require "lib.middleclass.middleclass"
bump = require 'lib.bump.bump'
bump_debug = require 'bump_debug'

local Player = require 'player'

local instructions = [[
  bump.lua simple demo

    arrows: move
    tab: toggle debug info
    delete: run garbage collector
]]

-- helper function
function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,70)
  love.graphics.rectangle("fill", box.l, box.t, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.l, box.t, box.w, box.h)
end

-- World creation
world = bump.newWorld()
gravity = 40
local player = Player:new('Whiskey')

-- Block functions

local blocks = {}



local function addBlock(l,t,w,h)
  local block = {l=l,t=t,w=w,h=h}
  blocks[#blocks+1] = block
  world:add(block, l,t,w,h)
end

local function drawBlocks()
  for _,block in ipairs(blocks) do
    drawBox(block, 255,0,0)
  end
end

-- Message/debug functions
local function drawMessage()
  local msg = instructions:format(tostring(shouldDrawDebug))
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(msg, 550, 10)
end

local function drawDebug()
  bump_debug.draw(world)

  local statistics = ("fps: %d, mem: %dKB"):format(love.timer.getFPS(), collectgarbage("count"))
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(statistics, 630, 580 )
end


function love.load()
  got_joystick = get_joystick()
  print("Controller available: " .. tostring(got_joystick))

  world:add(player, player.l, player.t, player.w, player.h)

  addBlock(0,       0,     800, 32)
  addBlock(0,      32,      32, 600-32*2)
  addBlock(800-32, 32,      32, 600-32*2)
  addBlock(0,      600-32, 800, 32)

  for i=1,30 do
    addBlock( math.random(100, 600),
              math.random(100, 400),
              math.random(10, 100),
              math.random(10, 100)
    )
  end
end

function love.update(dt)
  player:update(dt)
end

function love.draw()
  drawBlocks()
  player:draw()
  if shouldDrawDebug then drawDebug() end
  drawMessage()
end

-- Non-player keypresses
function love.keypressed(k)
  if k=="escape" then love.event.quit() end
  if k=="tab"    then shouldDrawDebug = not shouldDrawDebug end
  if k=="delete" then collectgarbage("collect") end
end

function love.keyreleased(key)
  player:keyreleased(key)
end

function get_joystick()
  joysticks = love.joystick.getJoysticks()

  if #joysticks ~= 0 then
    joystick_01 = love.joystick.getJoysticks()[1]
    return true
  else
    return false
  end
end

function love.joystickreleased(joystick, button)
  player:joystickreleased(joystick, button)
end
