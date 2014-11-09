local Player = class('Player')

function Player:initialize(name)
  self.name = name

  self.l = 50
  self.t = 50
  self.w = 32
  self.h = 32

  self.start_l = self.l
  self.start_t = self.t

  self.xVelocity = 0
  self.yVelocity = 0

  self.state = "stand"

  self.jump_vel = -750
  self.run_vel = 300
end

function Player:update(dt)
  if love.keyboard.isDown('right') then
    self.xVelocity = self.run_vel * dt
  elseif love.keyboard.isDown('left') then
    self.xVelocity = -self.run_vel * dt
  end

  if got_joystick then
    if joystick_01:isDown(13) then
      self.xVelocity = self.run_vel * dt
    elseif joystick_01:isDown(12) then
      self.xVelocity = -self.run_vel * dt
    end
  end

  if (self.state == "stand") and love.keyboard.isDown('x') then
    self.yVelocity = self.jump_vel * dt
    self.state = "jump"
  end

  if got_joystick then
    if (self.state == "stand") and joystick_01:isDown(1) then
      self.yVelocity = self.jump_vel * dt
      self.state = "jump"
    end
  end

  -- apply gravity
  self.yVelocity = self.yVelocity + (gravity * dt)

  -- update the player's position and check for collisions
  if self.xVelocity ~= 0 or self.yVelocity ~= 0 then
    local future_l, future_t = self.l + self.xVelocity, self.t + self.yVelocity

    local cols, len = world:check(self, future_l, future_t)
    if len == 0 then
      self.l, self.t = future_l, future_t
      world:move(self, future_l, future_t)
    else
      -- local col, tl, tt, sl, st
      local col, tl, tt, nx, ny, sl, st
      while len > 0 do
        col = cols[1]
        -- tl,tt,_,_,sl,st = col:getSlide()
        tl, tt, nx, ny, sl, st = col:getSlide()

        -- print("nx: " .. nx .. " ny: " .. ny)

        self.l, self.t = tl, tt
        world:move(self, tl, tt)

        cols, len = world:check(self, sl, st)
        if len == 0 then
          self.l, self.t = sl, st
          world:move(self, sl, st)

          self.yVelocity = 0
          if ny == -1 then
            self.state = "stand"
          end
        end
      end
    end
  end
end

function Player:draw()
  drawBox(self, 0, 255, 0, 255)
end

function Player:keyreleased(key)
  if (key == "right") or (key == "left") then
    self.xVelocity = 0
  end
end

function Player:joystickreleased(joystick, button)
  if joystick == joystick_01 then
    if (button == 13) or (button == 12) then
      self.xVelocity = 0
    end
  end
end

function Player:reset_pos()
  self.l, self.t = self.start_l, self.start_t
end

return Player
