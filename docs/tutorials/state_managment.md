# Using Basic States

```lua title="BasicState.luau"
local Element = Essence.new("TextLabel", {
    Text = Essence.getState("CurrentText", "Initial value!")
})

local Production = Essence.build(Element)
Production.State.CurrentText = "Override!"
```

As you can see, using `Essence.getState` you can create a new state value which can be modified externally by the `State` metatable, optionally, you can also assign an initial value to the state as second parameter of the function.

## Compute State

If you want to concenate the State or do advanced computations with the new value, you can use the third parameter of `Essence.getState` which is a function that returns the new state value to be displayed to that property.

Here's an example:
```lua title="ComputeState.luau"
local Element = Essence.new("TextLabel", {
    Text = Essence.getState("CurrentNumber", 5, function(Value: any)
        return "Computation: "..Value
    end)
})

local Production = Essence.build(Element)
Production.State.CurrentNumber = 10
```

## Children State

Sadly, you can't interact externally with the children added to the Element, fortunately this is solved by using state as the children parameter.

```lua title="ChildrenState.luau"
local Element = Essence.new("TextLabel", {
    Text = "Hi mom!",
    Children = Essence.getState("BelovedChildren")
})

local Production = Essence.build(Element)

Production.State.BelovedChildren = {
    Test = Essence.new("Frame", {
        BackgroundColor3 = Essence.getState("Color")
    })
}
```

As you can see, you cannot interact with the children state directly but there is a new property that solves it:

```lua
local BelovedChildren = Production.State.BelovedChildren
BelovedChildren._Objects.Test.State.Color = Color3.fromRGB(255, 0, 0)
```

This new property is overriden each time you set the children state so don't make variables with it as it is unsafe for memory to reference destroyed children.