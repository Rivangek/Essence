local function renderChildren(ElementObject, ElementInstance, ProductionElement, ProductionChildren)
	if ElementObject.Children then
		for i, ChildElement in ElementObject.Children do
			if ElementObject.ClassName ~= "Fragment" then
				ChildElement.Properties.Parent = ElementInstance
			end

			local ProductionChildElement = require(script.Parent.build)(ChildElement)
			ProductionChildElement.Parent = ProductionElement

			ProductionChildren[i] = ProductionChildElement
			ElementObject.TrackedChildren[i] = ProductionChildElement
		end
	end
end

return function(ElementObject)
	local ElementInstance
	local OriginalProperties = ElementObject.OriginalProperties

    if not (ElementObject.ClassName == "Fragment") then
        ElementInstance = Instance.new(ElementObject.ClassName)
    end

	--

	local ProductionElement = {}
	local ProductionState = {}
	local ProductionChildren = {}

	--

	local ProductionElementMeta = {
		__index = function(tabl: { any }, index: string)
            if ElementObject.ClassName ~= "Fragment" then
                if index == "Instance" then
                    return ElementInstance
                elseif index == "State" then
                    return ProductionState
                end
            end
            
			if ProductionChildren[index] then
				return ProductionChildren[index]
			end
		end,
	}

	local ProductionStateMeta = {
		__newindex = function(_, index: string, value: any)
            if ElementObject.ClassName ~= "Fragment" then

                if not (typeof(value) == "table" ) then
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
                else
                    if (typeof(ElementObject.OriginalProperties.Children) == "table" and ElementObject.OriginalProperties.Children.IsEssenceState) then
                        local StateIdentifier = ElementObject.OriginalProperties.Children.StateIdentifier
                        local ProductionChildren = {}

                        ElementInstance:ClearAllChildren()

                        local ComputedValue = value
                        if ElementObject.OriginalProperties.Children.StateCompute then
                            ComputedValue = ElementObject.OriginalProperties.Children.StateCompute(value)
                        end

                        for i, Element in ComputedValue do
                            Element.Properties.Parent = ElementInstance
                            ProductionChildren[i] = require(script.Parent.build)(Element)
                        end

                        ElementObject:SetState(StateIdentifier, {
                            table.unpack(ComputedValue),
                            _Objects = ProductionChildren
                        })
                    end
                end

            else
                if ElementObject.OriginalChildren and ElementObject.OriginalChildren.IsEssenceState then
                    ElementObject.Children = value
                    ElementObject.State.Children = value

                    for _, Child in ElementObject.TrackedChildren do
                        Child.Instance:Destroy()
                    end

                    renderChildren(ElementObject, ElementInstance, ProductionElement, ProductionChildren)
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

    if ElementInstance then
        for Property: string, Value: any in ElementObject.Properties do
            ElementInstance[Property] = Value
        end
    end

	renderChildren(ElementObject, ElementInstance, ProductionElement, ProductionChildren)

	--

	return ProductionElement
end
