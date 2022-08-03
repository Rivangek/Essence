local Fragment = {}

-- Typos

export type Class = {
	Children: { any },
}

--

function Fragment.new(Children: { any })
    local self = {}

    self.ClassName = "Fragment"
    self.OriginalChildren = Children

    self.Children = self.OriginalChildren
    self.TrackedChildren = {}

    self.Functions = {}
    self.State = {}

    if self.OriginalChildren and self.OriginalChildren.IsEssenceState then
        if self.OriginalChildren.StateCompute then
            self.Children = self.OriginalChildren.StateCompute(self.OriginalChildren.StateInitialValue)
        else
			self.Children = self.OriginalChildren.StateInitialValue
        end

        self.State.Children = self.Children
    end

    return self
end

--

return Fragment