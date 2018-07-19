@page steal-tools.tree-shaking Tree Shaking
@parent StealJS.bundling 1

@body

Tree shaking is a specialized form of [dead code elimination](https://en.wikipedia.org/wiki/Dead_code_elimination) that targets the ES module system's `import` and `export` declarations to find unused code. [steal-tools] performs tree shaking as part of [steal-tools.build] and [steal-tools.optimize]. You do *not* need to do anything special to turn on tree shaking.

## API

Tree shaking is enabled by default and runs both in the client and then in the build. If you have an existing app that depends on side-effects created by unused import statements, you can disable tree shaking.

In the browser you can disable it one of two ways. If you want to disable tree-shaking just on a particular page, pass the `no-tree-shaking` attribute:

```html
<script src="node_modules/steal/steal.js" main no-tree-shaking></script>
```

To disable it globally (both in the client and during the build), add this flag to your `package.json`:

```json
{
  "steal": {
    "treeShaking": false
  }
}
```

> Note that this flag only works from the root package.

If you only want to disable tree-shaking during the build, you can use the [steal-tools.build JavaScript API] and set the same [steal-tools.BuildOptions]:

```js
const stealTools = require("steal-tools");

stealTools.build({}, {
  treeShaking: false
})
```

The same works for [StealJS.optimized-builds optimized builds]:

```js
const stealTools = require("steal-tools");

stealTools.optimize({}, {
  treeShaking: false
})
```

If using the [steal-tools.cmd.build cli] you can provide the `--no-tree-shaking` flag:

```bash
steal-tools build --no-tree-shaking
```

or

```bash
steal-tools optimize --no-tree-shaking
```

## Preventing code removal

Instead of disable tree shaking it is better to update your code to prevent needed side-effects from being removed. For example, you might have the following code:

```js
import thing from "~/thing";
```

Where the identifier `thing` is never referenced elsewhere in this module. Tree shaking will remove this import, and remove the `~/thing` module if also not used elsewhere.  If, by some reason, you need this module to be imported for side effects only, you can change this import statement to:

```js
import "~/thing";
```

And the module will remain a dependency. Alternative you can use the identifier in some where. Here we set it to a property on the window, making it a global:

```js
import thing from "~/thing";

window.APP = { thing };
```

As globals can lead to implicit dependencies, it's better to avoid this.
