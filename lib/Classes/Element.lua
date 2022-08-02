local Element = {}
Element.__index = Element

-- Typos

export type ElementObject = {
	Children: { ElementObject },
	Properties: { [string]: any },
	Functions: { [string]: (any) -> any },
	ClassName: string,

	SetState: (ElementObject, StateIdentifier: string, NewValue: any) -> nil,
	GetState: (ElementObject, StateIdentifier: string) -> any,
}

export type ElementFragment = {
    Children: { ElementObject }
}

--

function Element.new(Properties)
	local self = setmetatable({}, Element)

	self.Children = Properties.Children
	self.ClassName = Properties.ClassName
	self.Functions = {}

    self.OriginalProperties = table.clone(Properties)

	Properties.Children = nil
	Properties.ClassName = nil

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

    if typeof(self.OriginalProperties.Children) == "table" and self.OriginalProperties.Children.IsEssenceState then
        self.Children = self.OriginalProperties.Children.StateInitialValue -- Adds support for state managment in children object.
    end

    if self.ClassName == "Fragment" then
		return self :: ElementFragment
    else
        return self :: ElementObject
    end
end

function Element:SetState(StateId: string, StateValue: any)
	self.State[StateId] = StateValue
end

function Element:GetState(StateId: string)
	return self.State[StateId]
end

--

return Element
