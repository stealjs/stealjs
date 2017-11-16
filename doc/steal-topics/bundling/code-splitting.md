@page steal-tools.code-splitting Code Splitting
@parent StealJS.bundling 1

@body

__Code splitting__ refers to breaking up a JavaScript bundle into smaller bundles that can be progressively loaded as needed in the client. This is done by dynamically importing a module. In steal this is done with [steal.import]:

```js
steal.import("app/pages/login").then(function(login){
  document.body.appendChild(login());
});
```

## API

The following are important APIs to configure code splitting.

* [steal.import]: A function to dynamically import a module. In production this will load a split bundle that contains this module.
* [config.bundle bundle configuration]: Specifies the split points. This usually coincides with each module that you dynamically import with [steal.import].
* [steal-tools.BuildOptions maxBundleRequests]: A [steal-tools] build option, this specifies the number of bundles that should be for any particular [config.bundle].
* [steal-tools.BuildOptions maxMainRequests]: Usually used in [steal-tools.multi-main], this is like *maxBundleRequests* but is applied to the [config.main].

## Adding code splitting

If you have an existing application that doesn't do any dynamic module loading, adding code splitting is a great performance enhancement.

### Progressively loading modules

As an example, consider this module when imports __login__ and __home__ pages statically:

```js
import login from "~/pages/login";
import home from "~/pages/home";

let page = location.pathname.substr(1);
if(page === "login") {
  document.body.appendChild(login());
} else if(page === "home") {
  document.body.appendChild(home());
}
```

We can prevent loading these two modules before they are needed by using [steal.import] to dynamically load them:

```js
function render(pageComponent) {
  document.body.appendChild(login());
}

let page = location.pathname.substr(1);

steal.import(`~/pages/${page}`).then(function(pageComponent){
  render(pageComponent);
});
```

This is what refactoring an application to include progressive loading usually consists of; moving some functionality into a function (in this case the `render` function), and calling that function *after* using [steal.import].

### Setting split points

Now the application code is fixed, but to get separate bundles add the [config.bundle] configuration to your *package.json*:

```js
{
  "steal": {
    "bundle": [
      "app/pages/login",
      "app/pages/home"
    ]
  }
}
```

The bundle names used here *should be* module names like `app/pages/login`, and include the package name. Do not use the [tilde] alias, steal-tools won't now how to find these modules.

### Specifying bundle depth

In a large application it is possible that [steal-tools] will create a large number of bundles because there is a lot of sharing between [config.bundle bundles]. By default steal-tools will let there be no more than __3__ bundles loaded for a particular split-point.

This is controlled with the __maxBundleRequests__ configuration. You might want to adjust this number to be higher/lower depending on your application. It can be changed in your build script like so:

```js
var stealTools = require("steal-tools");

stealTools.build({}, {
  maxBundleRequests: 5
});
```

## Bundling algorithm

What makes [steal-tools] code-splitting special is its two-pass algorithm that effectively weighs number of bundles and bundle-size. See the video below to learn how the algorithm works:

<iframe width="560" height="315" src="https://www.youtube.com/embed/C-kM0v9L9UY" frameborder="0" allowfullscreen></iframe>
