local bump = require 'lib.bump.bump'
local bump_debug = require 'bump_debug'

local Player = require 'player'

local instructions = [[
  bump.lua simple demo

    arrows: move
    tab: toggle debug info
    delete: run garbage collector
]]

-- helper function
local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,70)
  love.graphics.rectangle("fill", box.l, box.t, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.l, box.t, box.w, box.h)
end

-- World creation
local world = bump.newWorld()
local gravity = 40

local player = Player:new('Whiskey')

local function updatePlayer(dt)
  -- local player.xVelocity, player.yVelocity = 0, 0
  if love.keyboard.isDown('right') then
    player.xVelocity = player.runSpeed * dt
  elseif love.keyboard.isDown('left') then
    player.xVelocity = -player.runSpeed * dt
  end

  if got_joystick then
    if joystick_01:isDown(13) then
      player.xVelocity = player.runSpeed * dt
    elseif joystick_01:isDown(12) then
      player.xVelocity = -player.runSpeed * dt
    end
  end

  if (player.playerState == "stand") and love.keyboard.isDown('x') then
    player.yVelocity = player.playerJumpVelocity * dt
    player.playerState = "jump"
  end

  if got_joystick then
    if (player.playerState == "stand") and joystick_01:isDown(1) then
      player.yVelocity = player.playerJumpVelocity * dt
      player.playerState = "jump"
    end
  end

  -- apply gravity
  player.yVelocity = player.yVelocity + (gravity * dt)

  -- update the player's position and check for collisions
  if player.xVelocity ~= 0 or player.yVelocity ~= 0 then
    local future_l, future_t = player.l + player.xVelocity, player.t + player.yVelocity

    local cols, len = world:check(player, future_l, future_t)
    if len == 0 then
      player.l, player.t = future_l, future_t
      world:move(player, future_l, future_t)
    else
      -- local col, tl, tt, sl, st
      local col, tl, tt, nx, ny, sl, st
      while len > 0 do
        col = cols[1]
        -- tl,tt,_,_,sl,st = col:getSlide()
        tl, tt, nx, ny, sl, st = col:getSlide()

        print("nx: " .. nx .. " ny: " .. ny)

        player.l, player.t = tl, tt
        world:move(player, tl, tt)

        cols, len = world:check(player, sl, st)
        if len == 0 then
          player.l, player.t = sl, st
          world:move(player, sl, st)

          player.yVelocity = 0
          if ny == -1 then
            player.playerState = "stand"
          end

        end
      end
    end
  end
end


local function drawPlayer()
  drawBox(player, 0, 255, 0)
end

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
  updatePlayer(dt)
end

function love.draw()
  drawBlocks()
  drawPlayer()
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
  if (key == "right") or (key == "left") then
    player.xVelocity = 0
  end
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
  if joystick == joystick_01 then
    if (button == 13) or (button == 12) then
      player.xVelocity = 0
    end

    -- if (button == 8) then
    --   print("Start pressed")
    --   world:remove(player)
    --   world:add(player, player.l, player.t, player.w, player.h)
    -- end
  end

end
