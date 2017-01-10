@page StealJS.topics.migrating-one Migrating to StealJS 1.X
@parent StealJS.topics
@outline 0

This guide walks you through upgrading to StealJS 1. It’s broken up into four parts:

1. [Getting StealJS 1](#getting-steal-1) for your existing project
2. [Breaking changes](#breaking-changes) that require updates to your code
3. [New features](#new-features) you might want to take advantage of
4. [Deprecations](#deprecations) to consider for the future

Overall, most of the changes needed to upgrade from a StealJS 0.16 project to StealJS 1 are quite small. If you are using an older version of StealJS and want to migrate to StealJS 1, please check out the [changelog](StealJS.changelog.html) to see the changes that have occurred since the version you are currently using.

<a name="getting-steal-10"></a>
## Getting StealJS 1

The recommended way to get StealJS is using [npm](http://npmjs.org/). If you’re not already using StealJS with npm, we recommend doing so. You can install with:

```
npm install steal@1 --save
npm install steal-tools@1 --save-dev
```

If you’re already using StealJS through npm, you can run the above commands to upgrade and your `package.json` will be updated.

If you want to upgrade manually, change the versions of `steal` and `steal-tools` in your `package.json` to:

```
{
  "dependencies": {
    ...

    "steal": "^1.0.0"
  },
  "devDependencies": {
    ...

    "steal-tools": "^1.0.0"
  }
}
```
@highlight 5,10

If you are using [Grunt](http://gruntjs.com/) for production builds, the Grunt tasks for StealJS have been moved to their own project, [grunt-steal](https://github.com/stealjs/grunt-steal). This is explained in [further detail below](#grunt-tasks), but for now you will want to install `grunt-steal`:

```
npm install grunt-steal --save-dev
```

## Breaking changes

The following are breaking changes to the way StealJS works that will require you to change your code. Most represent small (often one-line) changes; nothing drastic has changed since 0.16.

### Production script tag

If you are using the [npm](./npm.html) plugin (and you should be!), you may need to change the [config.main] attribute in the StealJS script tag for production.  If your script tag currently looks like this:

```html
<script src="./node_modules/steal/steal.production.js"
  main="index"></script>
```

Where `"index"` is your application’s main module, you’ll want to change that to:

```html
<script src="./node_modules/steal/steal.production.js"
  main="app/index"></script>
```
@highlight 2

Where `app` is your package’s `name` in your `package.json`. `steal-tools` now always includes the package name in the bundles it produces, so where it previously might have written to the file `dist/bundles/index.js`, it now writes to `dist/bundles/app/index.js`.

Using the new [configured steal.production](#easier-production-use) alleviates the need to know about this. The [StealJS.moving-to-prod] guide has been updated; it contains all of the ways to use StealJS in production.

### NPM 3

The [npm] plugin now defaults to compatibility with npm 3 and above. If you’re using Node version 5+, you have npm 3.  If you are using an older version of Node, or are using npm 2 for another reason, you need to update your configuration in your `package.json` to add:

```json
"steal": {
  "npmAlgorithm": "nested"
}
```

If you *are* using npm 3+ and have `"npmAlgorithm": "flat"` in your `package.json`, you can remove this, but leaving it in your config will not cause any harm.

### CSS and Less plugins

The CSS and Less plugins are no longer included with the steal npm package, but rather are contained within their own projects: [steal-css](http://npmjs.com/package/steal-css) and [steal-less](http://npmjs.com/package/steal-less). To use them, install them as `devDependencies`:

```
npm install steal-css steal-less --save-dev
```

Also update your `package.json` to use the new `plugins` configuration which tells Steal to load their `package.json` for metadata:

```json
"steal": {
  ...
  
  "plugins": ["steal-less"]
}
```

### Stache plugin

Similarly, if you’re using CanJS and the [steal-stache](https://www.npmjs.com/package/steal-stache) plugin, you’ll need to add it to the `plugins` configuration in your `package.json`:

```json
"steal": {
  ...

  "plugins": ["steal-stache"]
}
```

### Grunt tasks

Likewise, the Grunt tasks are no longer included with `steal-tools`. This is part of a long-term project of decreasing the size of our core packages; `steal-tools` being one of them.

Install [grunt-steal] as a dev-dependency:

```
npm install grunt-steal --save-dev
```

In your `Gruntfile.js`, change:

```js
grunt.loadNpmTasks("steal-tools");
```

to:

```js
grunt.loadNpmTasks("grunt-steal");
```

Finally, change the configuration object to be `steal` rather than `system` like so:

```
grunt.initConfig({
  "steal-build": {
    default: {
      options: {
        steal: {
          config: __dirname + "/package.json!npm"
        },
        buildOptions: {
          
        }
      }
    }
  }
});
```
@highlight 5

This also applies to the [grunt-steal.export] and [grunt-steal.live-reload] tasks. Learn more in the [grunt-steal] docs.

### bundlesPath

The use of [config.bundlesPath] in `steal-tools` is deprecated in favor of the new `dest` option.

[config.bundlesPath] has always been confusing because it means something different when used in the client (to set the path where production bundles are served) vs. in the build (which previously meant where the bundles are written).

`dest` clears this confusion up. Setting `dest` tells `steal-tools` where your production files go. It will write out your bundles inside of this path.

To upgrade, change your build script that looks something like this:

```js
stealTools.build({
  config: __dirname + "/package.json!npm",
  bundlesPath: __dirname + "/path/to/build/bundles"
});
```

To:

```js
stealTools.build({
  config: __dirname + "/package.json!npm"
}, {
  dest: __dirname + "/path/to/build"
});
```

`steal-tools` will write out bundles to `path/to/build/bundles` and also write out a pre-configured StealJS script to `path/to/build/steal.production.js`. More on that [below](#easier-production-use).


### bundlesDepth

Two configuration options have been renamed:

- `bundlesDepth` to `maxBundleRequests`
- `mainsDepth` to `maxMainRequests`

These options have been renamed to more accurately reflect what their purpose is: to control the number of requests that will be needed in production. The functionality remains the same.

Just change this option in your build script:

```js
stealTools.build({
  config: __dirname + "/package.json!npm"
}, {
  bundlesDepth: 3
}
```

becomes:

```js
stealTools.build({
  config: __dirname + "/package.json!npm"
}, {
  maxBundleRequests: 3
}
```
@highlight 4

## New features

Although StealJS 1 is mostly about solidifying that StealJS is production-ready, there are a few new features worth mentioning.

### Loading from your project’s root

Since the introduction of the npm plugin, there has been an issue with wanting to load code from the project’s root, which may not always be a sibling of your project’s `node_modules/` folder. In the past this was done by using your project’s package name to load: `app/components/tabs` where `app` is the `"name"` field in your `package.json`.

This wasn’t ideal because project names could be long, and if your project name changed, these imports would need to be refactored.

In StealJS 1, `~` refers to your project’s root.

```
import tabs from "~/components/tabs";
```

`~` is treated the same as your project’s package name in StealJS.

### Easier production use

Using Steal in development is as easy as adding a script tag that points to `steal.js` inside your `node_modules` folder, but up to now when changing to production you have to add a few attributes such as the [config.main], and possibly [config.bundlesPath] or even [config.baseURL].

Using Steal 1 in production is just as easy as in development. `steal-tools` now builds out a pre-configured `steal.production.js` to your `dest` folder. By default it will be written to `dist/steal.production.js`. So now all you need to do is use this script tag in production:

```js
<script src="./dist/steal.production.js"></script>
```

### Babel 6

StealJS 1 includes [Babel 6](https://babeljs.io/blog/2015/10/29/6.0.0)! We are using [Greenkeeper](https://greenkeeper.io/) to keep our packages up-to-date so there will be patch releases as new versions of [Babel](https://babeljs.io/) come out.

You can configure which presets/plugins are used in your `package.json` config:

```json
"steal": {
  "babelOptions": {
    "presets": ["es2015"]
  }
}
```

The available presets and plugins are listed in the [config.babelOptions] docs.

## Deprecations

These things still exist in StealJS 1 but are considered deprecated and might be removed in 2.0.

### system name replaced by steal

In 0.16, StealJS used a special property called `system` to configure StealJS. You have probably used this in your `package.json` like:

```json
"system": {
  "map": {

  }
}
```

In StealJS 1, this option is now called `steal`, so the above would become:

```json
"steal": {
  "map": {

  }
}
```
@highlight 1

Similarly, to dynamically import code we’ve previously taught to use `System.import`. This should be replaced by using [steal.import] instead:

```js
steal.import("my/app").then(function(){

});
```

StealJS was built on top of a specification for modules that was planned to be part of ES6, but never came to pass. `System.import()` is supported by StealJS, SystemJS, and WebPack, but will never appear in the browser natively, so we are moving away from the `System` name so that in the future we can support the browser’s native module system, `<script type="module">`.

The global `System` is still available and won’t be removed any time soon, but you should use `steal` in its place, or `steal.loader` if you really do need the loader.

### Configuring the loader directly

In the past you’ve been able to configure the System object directly to add [config.map], [config.ext], and other configuration values. In Steal 1, this is deprecated in favor of using [config.config steal.config()]:

```js
steal.config({
  map: {
    "foo": "bar"
  }
});
```
