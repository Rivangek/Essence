local Essence = {}

local Classes = script:WaitForChild("Classes")
local Modules = script:WaitForChild("Modules")

local Element = require(Classes.Element)

--

function Essence.new(...)
   local Parameters = {...}

   local ClassObject: string | { any } = Parameters[1] -- It can be an string containing the ClassName
   local Props = Parameters[2]

   if typeof(ClassObject) == "table" then -- It is a component.
      local ElementObject = ClassObject:Render(Props)

      for Index, Value in ClassObject do
         if typeof(Value) == "function" and not (Index == "Render") then
            ElementObject.Functions[Index] = Value
         end
      end

      return ElementObject;
   end

   -- Switch not passed, it's a Roblox class.

   local ElementProperties = Props
   ElementProperties.ClassName = ClassObject

   local ElementObject = Element.new(ElementProperties)
   return ElementObject
end

function Essence.build(ElementObject: Element.Class)
   local ElementInstance = Instance.new(ElementObject.ClassName)
   local OriginalProperties = ElementObject.OriginalProperties

   --

   local ProductionElement = {}
   ProductionElement.Children = {}

   local ProductionState = {}

   --

   local ProductionElementMeta = {
      __index = function(tabl: { any }, index: string)
         if index == "Instance" then
            return ElementInstance
         elseif index == "State" then
            return ProductionState
         end
      end
   }

   local ProductionStateMeta = {
      __newindex = function(_, index: string, value: any)
         for Property: string, Value: any in OriginalProperties do
            if typeof(Value) == "string" and string.match(Value, "STATE;") then
               local StateValues = string.split(Value, ";")
               local StateIdentifier = StateValues[2]

               if index == StateIdentifier then
                  ElementInstance[Property] = value
                  ElementObject:SetState(StateIdentifier, value)
               end
            end
         end
      end,

      __index = function(_, index: string)
         return ElementObject:GetState(index)
      end
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

   --

   return ProductionElement
end

function Essence.getState(StateIdentifier: string, InitialValue: any)
   return "STATE;"..StateIdentifier..";"..InitialValue
end

--

return Essence