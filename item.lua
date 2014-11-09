local Item = class('Item')

local RED = {255, 0, 0}
local BLUE = {0, 0, 255}

function Item:initialize(name, l, t)
  self.name = name
  self.colour = BLUE

  self.l = l
  self.t = t
  self.w = 32
  self.h = 32

  self.start_l = self.l
  self.start_t = self.t
end

function Item:update(dt)
  if dt == 1 then
      if self.colour == RED then
        self.colour = BLUE
      else
        self.colour = RED
      end
  end
end

function Item:draw()
  drawBox(self, 0, 0, 255, 255)
end

return Item