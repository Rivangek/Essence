# Production Element Hierarchy

If you're wondering about the hierarchy in the `ProductionElement` result of `Essence.build` with typos, it is the following:

* Element
    * State: `{ [string]: any }`
    * Instance: `Instance`

    * Any other index will be considered a child and will error if doesn't exist.

As you can see, it allows you to interact with the element externally without using state managment internally.