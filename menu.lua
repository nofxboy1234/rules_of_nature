local Menu = class('Menu')

function Menu:initialize()
  self.menu_items = {"start game", "credits", "help", "quit"}
  self.title_img = love.graphics.newImage("Resources/Images/SA-01_720.png")

  self.music = love.audio.newSource("Resources/Sounds/Circlerun_ZEQ2_Select_Your_Game_Mode.mp3", "stream")
  self.music:setLooping(true)
  self.music:setVolume(0.2)
  self.music:play()

  self.menu_sound = love.audio.newSource("Resources/Sounds/Menu_Selection_Click.wav", "static")
  -- menu_sound:setVolume(1.0)

  self.menuselection = 1
end

function Menu:update(dt)
  -- body
end

function Menu:draw()
  love.graphics.draw(self.title_img, 0, 0)
  -- Draw menu
  local center_v_offset = 150
  local offset = 0
  for i = 1, #self.menu_items do
    -- Set menu text colour depending on of it is selected
    if self.menuselection == i then
      love.graphics.setColor(255, 255, 255)
    else
      love.graphics.setColor(0, 0, 0)
    end

    love.graphics.print(menu_items[i], width/2, height/2 + center_v_offset  + offset)
    offset = offset + 20
  end
  love.graphics.setColor(255, 255, 255)

end

function Menu:keypressed(key, isrepeat)
  if key == "escape" then
      love.event.quit()
  end

  -- if (key == "up") and self.menuselection > 1 then
  --   self.menuselection = self.menuselection - 1
  -- elseif (key == "down") and self.menuselection < #menu_items then
  --     self.menuselection = self.menuselection + 1
  -- end

  if (key == "up") and self.menuselection > 1 then
    self.menuselection = self.menuselection - 1
    self.menu_sound:stop()
    self.menu_sound:play()
  elseif (key == "up") and self.menuselection == 1 then
    self.menuselection = #menu_items
    self.menu_sound:stop()
    self.menu_sound:play()
  elseif (key == "down") and self.menuselection < #menu_items then
    self.menuselection = self.menuselection + 1
    self.menu_sound:stop()
    self.menu_sound:play()
  elseif (key == "down") and self.menuselection == #menu_items then
    self.menuselection = 1
    self.menu_sound:stop()
    self.menu_sound:play()
  end

  if key == "return" and self.menuselection == 1 then
    self.music:stop()
    changegamestate("game")
  elseif key == "return" and self.menuselection == 4 then
    love.event.quit()
  end
end

return Menu