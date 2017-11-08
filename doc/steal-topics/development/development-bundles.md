@page StealJS.development-bundles Development Bundles
@parent StealJS.development
@body

> *Note*, this guide assumes you have been through the [StealJS.guides.progressive_loading progressive loading] guide, or have an existing StealJS project set up.

Development bundles enable faster reload times during development by bundling together dependencies in the `node_modules/` folder. There are two kinds of development bundles, enabled by the following attributes in the Steal script tag:

* **dev-bundle**: A bundle that contains all of your *node_modules* dependencies, and the configuration contained within your *package.json*. Use this bundle type if you want the fastest page load times.
* **deps-bundle**: A bundle that contains all of your *node_modules* dependencies. Unlike the dev_bundle, this *does not* contain your package.json configuration. Use this bundle type if you plan on changing configuration often or are installing new npm dependencies.

## API

The API for development bundles is split between parts in [steal-tools], where the bundles are created, and [steal], where you configuration the loader to load the bundles.

### steal

* [config.depsbundle]: Specifies that a *deps bundle* should be preloaded before the [config.main].
* [config.devbundle]: Specifies that a *dev bundle* should be preloaded before the [config.main].

Note that these config values should almost always be specified in the steal script tag:

```html
<script src="node_modules/steal/steal.js" deps-bundle></script>
```

### steal-tools

Creating dev and deps bundles can be done either through the `steal-tools bundle` command, or through `stealTools.bundle()` when using the JavaScript API.

* [steal-tools.cmd.bundle]: A cli command that allows you to create a dev/deps bundle by passing a flag.

    ```shell
    steal-tools bundle --dev
    ```

* [steal-tools.bundle]: A JavaScript API that allows building configurable bundles. To create a deps bundle use the `filter` with these values:

    ```js
    var promise = stealTools.bundle({
      config: __dirname + "/package.json!npm"
    }, {
      filter: [ "node_modules/**/*", "package.json" ]
    });
    ```

## Enabling Development Bundles

> *Note*: The development bundles feature requires at least steal 1.2.0, steal-tools 1.3.0, and steal-less 1.2.0 (if using steal-less).

Edit your *package.json* and add a new npm script like the following:

```json
"scripts": {
  "deps-bundle": "steal-tools bundle --deps"
}
```

Save the changes and run the `deps-bundle` script:

> npm run deps-bundle

This should create a file `dev-bundle.js` at the root folder of your project. If StealJS is also loading your CSS files there should be a `dev-bundle.css` file, too.

> It is possible to provide an alternative destination folder using the `--dest`
> option, run `steal-tools bundle --help` to see all the options available.
