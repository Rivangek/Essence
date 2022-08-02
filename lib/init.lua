local Modules = script:WaitForChild("Modules")
local Classes = script:WaitForChild("Classes")

local Element = require(Classes.Element)

--

type ProductionComponent = {
    State: { [string]: any },
    [string]: ProductionComponent
}

type Essence = {
    build: (ElementObject: Element.ElementObject) -> ProductionComponent,
    new: (ClassObject: string, Props: any) -> (Element.ElementObject | Element.ElementFragment),
    getState: (StateIdentifier: string, InitialValue: any, Compute: ((newValue: any) -> any)?) -> { any }
}

--

return {
    build = require(Modules.build),
    new = require(Modules.new),
    getState = require(Modules.getState),
} :: Essence
