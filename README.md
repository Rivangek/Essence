## Essence

The modular & component-based UI library that you likely have been waiting for. No more worrying about weird syntaxis and not accessible Lua objects, you can control everything here.

Note that this library isn't for games, it is oriented to create plugin interfaces.

### **Features**

* Component based, modular architecture.
* State managment, re-render based on the state.
* Interact with components externally without state managment.

---

## Installation

This section will teach you how to install Essence in your project.

### Wally
Add this to your `wally.toml`
```toml
[dependencies]
Essence = "rivangek/essence@1.0.0"
```

### Building with Rojo

Download the `/lib/` directory from the repository and place it under your libraries, then rename it to `Essence` and you will have the Essence module built.

Optionally, you can clone the entire repository and then build it with the Rojo `build` command, just reference the `build.project.json` from the repository.

### Downloading the rbxmx

You can download it at the releases page, it is the latest stable version, if you want the risky version you need to build it with Rojo.