# Creating a Component

So, let's start with the first Component of the day, it will be a button which increments it's text when clicked.

```lua title="ExampleComponent.luau"
local Component = {}
local Essence = require(game.ReplicatedStorage.Essence)

function Component:Render(props)
	return Essence.new("ImageButton", {
		Parent = game.Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui"),
		Size = UDim2.fromOffset(200, 50),
		Image = "",
		
		Children = {
			Label = Essence.new("TextLabel", {
                Size = UDim2.fromScale(1, 1),
				Text = Essence.getState("Clicks", props.InitialClicks),
			})
		}
	})
end

-- This function only does exist
-- on production component.
function Component:Increment()
	self.Label.State.Clicks += 1
end

--

local PComp = Essence.build(
	Essence.new(Component, {
		InitialClicks = 20,
	})
)

PComp.Instance.MouseButton1Click:Connect(function()
	PComp:Increment()
end)
```

The hierarchy of the Production Component would be the following:

* PComp
    * Instance: TextButton
    * State: { [string]: any }
    * Increment: () -> nil

    * Label
        * Instance: TextLabel
        * State: { [string]: any }

As you can see, you can directly interact like if it was an actual Roblox
instance, this is extremely helpful when creating plugins.

And if you're wondering about the result, you can see it here:
<video alt="Video from Gyazo" width="228" autoplay muted loop playsinline controls><source src="https://i.gyazo.com/da17850255523e42eb5e8d5bb020a86f.mp4" type="video/mp4" /></video>
