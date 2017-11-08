@page StealJS.using-npm-packages Using npm Packages
@parent StealJS.development
@body

[npm](https://www.npmjs.com/) is a JavaScript package managers that allows you to use and share all types of packages. StealJS supports using npm packages, and it is the recommended way to use Steal in any non-legacy application.

Using npm with StealJS is as easy as *installing steal* with npm:

```shell
npm install steal --save-dev
```

> Note, whether you use `--save-dev` or `--save` may depend on how you plan on deploying your application. Most of the time you will not need the [steal] package in production because your application has been built into separate bundles which will contain steal.

Then use steal with a script tag:

```html
<script src="./node_modules/steal/steal.js"></script>
```

This will tell steal to load your __package.json__ file, making any `dependencies` or `devDependencies` listed therein available to be imported.

Internally steal uses an included [npm] module to facilate this, but you largely don't need to know about that.

## Installing and using Packages

Install dependencies using the [npm install](https://docs.npmjs.com/getting-started/installing-npm-packages-locally) command. Steal only knows about packages that are saved within the `dependencies` and `devDependencies` properties in your package.json. With newer versions of npm, installs are saved as a dependency by default, in older versions you have to use the `--save` or `--save-dev` flags.

Here's an example of installing the [jquery](https://www.npmjs.com/package/jquery) package:

```shell
npm install jquery --save-dev
```

And then using it in [steal]:

```js
import $ from "jquery";

$("body")...
```

## Troubleshooting troublesome packages

Occasionally you might encounter a package that fails to load. Often this is because you are importing the package's *raw source* code that depends on specific bundler configuration, or intends to be run in Node.js. StealJS tries its best to emulate a Node environment but there are limitations.

Most packages include distributables intended for browser usage. You can find these by looking in the `node_modules/[PACKAGE]` folder. Often it is in `node_modules/[PACKAGE]/dist`. This is where jQuery's distributables are located and looks like this:

```
core.js
jquery.js
jquery.min.js
jquery.min.map
...
```

In the case of jQuery its package.json is correctly configured, so Steal loads the right file. For other packages that might not be the case. You can configure this yourself. In your package.json add a __steal__ property if it doesn't already exist:

```js
{
  "steal": {

  }
}
```

Let's assume we have a __foo__ package, and its distributable is located in `node_modules/foo/dist/foo.js`. This configuration will let you import foo correctly:

```json
{
  "steal": {
    "map": {
      "foo": "foo/dist/foo"
    },
    "meta": {
      "format": "global"
    }
  }
}
```

> *Note* that the [config.meta] configuration is often not needed. Only add it if it doesn't load without.

This uses two types of configuration. [config.map] configuration tells steal that when it encounters the __foo__ specifier, load __foo/dist/foo__ in its place. Secondly the [config.meta] configuration tells steal that this module is a *global*.
