return function(StateIdentifier: string, InitialValue: any, Compute: ((any) -> any)?)
	local StateObject = {}

	StateObject.StateIdentifier = StateIdentifier
	StateObject.StateInitialValue = InitialValue
	StateObject.StateCompute = Compute
	StateObject.IsEssenceState = true

	return StateObject
end