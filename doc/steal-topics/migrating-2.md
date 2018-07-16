@page StealJS.topics.migrating-two Migrating to StealJS 2.x
@parent StealJS.topics
@outline 0

This guide walks you through upgrading to StealJS 2.

1. [Getting StealJS 2](#getting-steal-2) for your existing project
2. [Breaking changes](#breaking-changes) that require updates to your code
3. [New features](#new-features) you might want to take advantage of

<a name="getting-steal-20"></a>
## Getting StealJS 2

The recommended way to get StealJS is using [npm](http://npmjs.org/). If you’re not already using StealJS with npm, we recommend doing so. You can install with:

```
npm install steal@2 --save
npm install steal-tools@2 --save-dev
```

If you’re already using StealJS through npm, you can run the above commands to upgrade and your `package.json` will be updated.

If you want to upgrade manually, change the versions of `steal` and `steal-tools` in your `package.json` to:

```
{
  "dependencies": {
    ...

    "steal": "^2.0.0"
  },
  "devDependencies": {
    ...

    "steal-tools": "^2.0.0"
  }
}
```
@highlight 5,10

## Breaking changes

StealJS 2.0 only contains 2 breaking changes, both of which are easy to upgrade.

### The main is no longer automatically loaded

Previously when steal started up it would like your configuration (the [config.configMain]) and then load the [config.main] (usually the `main` property in your package.json). This makes it easy to get started using steal but makes things more difficult later when you have a larger application and use demo pages.

In StealJS 2.0 the [config.main] is no longer loaded automatically. Instead you can turn on automatic main loading by simply adding the `main` boolean attribute.

*Before*

```html
<script src="node_modules/steal/steal.js"></script>
```

*After*

```html
<script src="node_modules/steal/steal.js" main></script>
```

You can also explicitly set the main that you want to load such as `main="~/app"`, the boolean main is a shortcut for the old behavior.

### Promise polyfill

In StealJS 1.x a polyfill for [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) is included in __steal.js__ and __steal.production.js__. Today Promises are supported natively in all modern browsers. In order to support Internet Explorer 11, however, you still need a Promise polyfill.

Change the steal script tag to point to __steal-with-promises.js__ like so:

*Before*

```html
<script src="node_modules/steal/steal.js"></script>
```

*After*

```html
<script src="node_modules/steal/steal-with-promises.js" main></script>
```

## New features

The following new features are turned on in StealJS 2.0. If you decide not to use them, you can opt out easily.

### Tree shaking

StealJS now tree shakes modules, preventing unused dependencies from being loaded at all.  This happens both in development (for faster page loads) and during the build (to minimize the amount of code included in your production bundles).

This is on by default. To turn the behavior off you can configure the loader. The package.json is the best place to do this:

```json
{
  "steal": {
    "treeShaking": false
  }
}
```
