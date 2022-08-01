# Creating a Component

Let's start with the first component of the day, it will be a TextButton that increments its value when clicked.

```lua
local Component = {}

function Component:Render(props)
   return Essence.new("TextButton", {
      Text = Essence.getState("Clicks", props.InitialClicks)
   })
end

-- This function only does exist
-- on production component.
function Component:Increment()
   self.State.Clicks += 1
end

--

local PComp = Essence.build(
   Essence.new(Component, {
      InitialClicks = 20
   })
)

PComp.Instance.MouseButton1Click:Connect(function()
   PComp:Increment()
end)
```

And 