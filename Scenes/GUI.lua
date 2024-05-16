local GUI = {}

function newButton(pX, pY, pW, pH, pText)
  local myButton = {}
  myButton.X = pX
  myButton.Y = pY
  myButton.W = pW
  myButton.H = pH
  myButton.Text = pText
  myButton.Visible = true

  function myButton:draw()
    if self.Visible == false then
      return
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.X, self.Y, self.W, self.H)
    love.graphics.print(self.Text, self.X, self.Y, 0, 1, 1)
  end

  function myButton:setVisible(pVisible)
    self.Visible = pVisible
  end

  return myButton
end

function GUI:newGroup()
  local myGroup = {}
  myGroup.elements = {}

  function myGroup:addElement(pElement)
    table.insert(self.elements, pElement)
  end

  function myGroup:setVisible(pVisible)
    for n, v in pairs(myGroup.elements) do
      v:setVisible(pVisible)
    end
  end

  function myGroup:draw()
    for n, v in pairs(myGroup.elements) do
      v:draw()
    end
  end

  function myGroup:clickedOnButton(pMouseX, pMouseY)
    for n, v in pairs(myGroup.elements) do
      if pMouseX > v.X and pMouseX < v.X + v.W and pMouseY > v.Y and pMouseY < v.Y + v.H then
        return true
      end
    end
    return false
  end

  return myGroup
end

return GUI
