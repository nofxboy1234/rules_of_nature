local class = require "lib.middleclass.middleclass"

Player = class('Player')

function Player:initialize(name)
  self.name = name

  self.l = 400
  self.t = 50
  self.w = 20
  self.h = 20

  self.xVelocity = 0
  self.yVelocity = 0

  self.playerState = "stand"

  self.playerJumpVelocity = -750
  self.runSpeed = 300
end

return Player
