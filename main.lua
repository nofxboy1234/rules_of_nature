class = require "lib.middleclass.middleclass"
bump = require 'lib.bump.bump'
bump_debug = require 'bump_debug'
gamestate = require 'lib.hump.gamestate'

local Player = require 'player'

playMusic = true

gravity = 40

window_width = love.graphics.getWidth()
window_height = love.graphics.getHeight()

player = Player:new('Whiskey')

-- helper function
function drawBox(box, r, g, b, alpha, overlay)
  alpha = alpha or 70
  overlay = overlay or true

  if overlay then
    love.graphics.setColor(r,g,b,alpha)
    love.graphics.rectangle("fill", box.l, box.t, box.w, box.h)
  end

  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.l, box.t, box.w, box.h)
end


function love.load()

  got_joystick = get_joystick()
  print("Controller available: " .. tostring(got_joystick))

  gamestate.registerEvents()
  gamestate.switch(require("menu")())
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

function love:joystickreleased(joystick, button)
  if (joystick == joystick_01) and (button == 7) then
    playMusic = not playMusic
  end
end