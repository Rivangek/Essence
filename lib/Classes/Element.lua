local Element = {}
Element.__index = Element

-- Typos

export type Class = {
   Children: { Class },
   Properties: { [string]: any },
   Functions: { [string]: (any) -> any },
   ClassName: string,

   SetState: (Class, StateIdentifier: string, NewValue: any) -> nil,
   GetState: (Class, StateIdentifier: string) -> any
}

--

function Element.new(Properties)
   local self = setmetatable({}, Element)

   self.Children = Properties.Children
   self.ClassName = Properties.ClassName
   self.Functions = {}

   Properties.Children = nil
   Properties.ClassName = nil

   self.Properties = Properties
   self.OriginalProperties = table.clone(self.Properties)

   self.State = {}

   for Property: string, Value: any in self.Properties do
      if typeof(Value) == "string" and string.match(Value, "STATE;") then -- Is State
         local StateValues = string.split(Value, ";")

         local StateIdentifier = StateValues[2]
         local StateInitialValue = StateValues[3]

         self.State[StateIdentifier] = StateInitialValue
         self.Properties[Property] = self.State[StateIdentifier]
      end
   end

   return self
end

function Element:SetState(StateId: string, StateValue: any)
   self.State[StateId] = StateValue
end

function Element:GetState(StateId: string)
   return self.State[StateId]
end

--

return Element