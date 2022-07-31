local Element = {}
Element.__index = Element

--

function Element.new()
   local self = setmetatable({}, Element)

   self._Children = {}
end