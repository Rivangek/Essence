# Using Fragments

Fragments are a way to create multiple objects in a same build, think of it like `Roact` fragments as this library is highly inspired by Roact.

```lua
-- The second parameter are the children.
local Fragment = Essence.new("Fragment", {
    Frame1 = Essence.new("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    })
})
```

And it's done, you just created your first fragment! And if you're wondering if you can use state managment in fragments, the answer is yes; the logic behind the state in fragments it's the same as the children state logic.

Example of state managment in Fragments:
```lua
-- The second parameter are the children.
local Fragment = Essence.new("Fragment", Essence.getState("BelovedChildren", {}))
local ProductionElement = Essence.build(Fragment)

ProductionElement.State.BelovedChildren = {
    Frame1 = Essence.new("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    })
}
```

Note that the second parameter of `getState`(the initial value) must be a table or the entire function will error because it tries to iterate over null object.