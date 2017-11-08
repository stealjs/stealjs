@page StealJS.hot-module-replacement Hot Module Replacement
@parent StealJS.development
@body

__Hot Module Replacement__ (or Hot Module Swapping) is a feature of StealJS (and other loaders) that allows modules to be updated in-place while the application runs, without the need to refresh the browser. In Steal, hot module replacement is handled by the [steal.live-reload] module.

## Using HMR

To enable hot module replacement, import the __live-reload__ module anywhere in your application:

```js
import "live-reload";
```

This tells the module to connect to the live-reload server via WebSockets. To enable the live-reload server, use [steal-tools]:

```shell
steal-tools live-reload
```

> *Note*: To prevent having to globally install steal-tools, instead add a script to your *package.json*.
