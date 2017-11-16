@page steal-tools.multi-main Multi-main Builds
@parent StealJS.bundling 3

@body

In a traditional server-rendered app you might not have a single *main* entry point. Rather you have a different main for each page. We call this a __multi-main__ project. With [steal] you can use a different main for each page in your application.

For example, you might have a *home.html* with this:

```html
<script src="./node_modules/steal/steal.js" main="app/home"></script>
```

And a *login.html* with this:

```html
<script src="./node_modules/steal/steal.js" main="app/login"></script>
```

With [steal-tools] you can create a build that puts all of these mains into their own modules.

# API

Multi-main app use the same APIs to build as single page apps.

* [steal-tools.build], the JavaScript build API.
* [steal-tools.cmd.build] the CLI API.

Additionally see [steal-tools.StealConfig] about how `main` can be an Array (which it will be in a multi-main app).

# Using multi-main

> This section explains how to set up a multi-main build. For an example app, check out [this gist](https://gist.github.com/matthewp/885153da3264bdaa1ecf028ca1c4cbf4).

To create a multi-main build, you need a build script. If you don't already have one, create *build.js*:

```js
var stealTools = require("steal-tools");

stealTools.build({
  main: ["app/home", "app/login"]
});
```

Then if you run this script:

```shell
node build.js
```

Which should output this:

```
OPENING: app/home
OPENING: app/login
Transpiling...
Minifying...
Calculating main bundle(s)...
Flattening main bundle(s)...
BUNDLE: app/home.js
+ [system-bundles-config]
+ npm-utils
+ npm-extension
+ npm-load
+ semver
+ npm-crawl
+ npm-convert
+ npm
+ package.json!npm
+ app@1.0.0#home
BUNDLE: app/login.js
+ [system-bundles-config]
+ npm-utils
+ npm-extension
+ npm-load
+ semver
+ npm-crawl
+ npm-convert
+ npm
+ package.json!npm
+ app@1.0.0#login
```

Notice here that there is a bit of duplication. Because each of these bundles is an *entry point* it needs to contain everything needed to configure itself, which will include the [npm] plugin.

Looking at the dist folder created, it should like this:

<img width="201" alt="dist folder of multi-main" src="https://user-images.githubusercontent.com/361671/32856322-7b49463e-ca12-11e7-984e-792666e66ba6.png">
