local Classes = script.Parent.Parent:WaitForChild("Classes")

local Element = require(Classes.Element)
local Fragment = require(Classes.Fragment)

return function(...)
	local Parameters = {...}

	local ClassObject: string | { any } = Parameters[1] -- It can be an string containing the ClassName
	local Props = Parameters[2]

	if typeof(ClassObject) == "table" then -- It is a component.
		local ElementObject = ClassObject:Render(Props)
        ElementObject.ComponentState = ClassObject.State

		for Index, Value in ClassObject do
			if typeof(Value) == "function" and not (Index == "Render") then
				ElementObject.Functions[Index] = Value
			end
		end

		return ElementObject
    elseif ClassObject == "Fragment" then
        local FragmentObject = Fragment.new(Props)

		for Index, Value in ClassObject do
			if typeof(Value) == "function" and not (Index == "Render") then
				FragmentObject.Functions[Index] = Value
			end
		end

        return FragmentObject
	end

	-- Switch not passed, it's a Roblox class.

	local ElementProperties = Props
	ElementProperties.ClassName = ClassObject

	local ElementObject = Element.new(ElementProperties)
	return ElementObject
end