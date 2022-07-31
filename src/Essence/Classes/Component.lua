local Component = {}
Component.__index = Component

--

function Component.new()
   local self = setmetatable({}, Component)

   self._Children = {}
   self._State = setmetatable({}, { __newindex = function(...) self:_Update(...) end })

   return self
end

function Component:GetState()
   if self.state then
      return self.state
   else
      return {}
   end
end

function Component:SetState(Callback)
   
end

function Component:_Render(Elements)

end

function Component:_Update(Table: { any }, Index: any, Value: any)
   
end

--

return Component