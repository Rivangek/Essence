return function(ElementObject)
	local ElementInstance = Instance.new(ElementObject.ClassName)
	local OriginalProperties = ElementObject.OriginalProperties

	--

	local ProductionElement = {}
	ProductionElement.Children = {}

	local ProductionState = {}
	local ProductionChildren = {}

	--

	local ProductionElementMeta = {
		__index = function(tabl: { any }, index: string)
			if index == "Instance" then
				return ElementInstance
			elseif index == "State" then
				return ProductionState
			end

			if ProductionChildren[index] then
				return ProductionChildren[index]
			end
		end,
	}

	local ProductionStateMeta = {
		__newindex = function(_, index: string, value: any)
			for Property: string, Value: any in OriginalProperties do
				if typeof(Value) == "table" and Value.IsEssenceState then
					local StateIdentifier = Value.StateIdentifier

					if index == StateIdentifier then
						if Value.StateCompute then
							ElementInstance[Property] = Value.StateCompute(value)
						else
							ElementInstance[Property] = value
						end

						ElementObject:SetState(StateIdentifier, value)
					end
				end
			end
		end,

		__index = function(_, index: string)
			return ElementObject:GetState(index)
		end,
	}

	setmetatable(ProductionElement, ProductionElementMeta)
	setmetatable(ProductionState, ProductionStateMeta)

	ProductionElement.State = ProductionState

	for Index, Function in ElementObject.Functions do
		ProductionElement[Index] = Function
	end

	--

	for Property: string, Value: any in ElementObject.Properties do
		ElementInstance[Property] = Value
	end

	if ElementObject.Children then
		for i, ChildElement in ElementObject.Children do
			ChildElement.Properties.Parent = ElementInstance
			ProductionChildren[i] = require(script.Parent.build)(ChildElement)
		end
	end

	--

	return ProductionElement
end
