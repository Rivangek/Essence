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

   self.OriginalProperties = table.clone(Properties)
   self.Properties = Properties

   self.State = {}

   for Property: string, Value: any in self.Properties do
      if typeof(Value) == "table" and Value.IsEssenceState then -- Is State
         local StateIdentifier = Value.StateIdentifier
         local StateInitialValue = Value.StateInitialValue

         self.State[StateIdentifier] = StateInitialValue

         if Value.StateCompute then
            self.Properties[Property] = Value.StateCompute(StateInitialValue)
         else
            self.Properties[Property] = StateInitialValue
         end
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