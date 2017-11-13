@page StealJS.hot-module-replacement Hot Module Replacement
@parent StealJS.development 4
@body

> This guide builds on code examples found in [StealJS.quick-start].

__Hot Module Replacement__ (or Hot Module Swapping) is a feature of StealJS (and other loaders) that allows modules to be updated in-place while the application runs, without the need to refresh the browser. In Steal, hot module replacement is handled by the [steal.live-reload] module.

## API

Responsibilities for HMR are divided between [steal] and [steal-tools].

### steal

The HMR functionality in steal is in [steal.live-reload]. This module includes several functions for dealing with reloaded modules. Also look into [steal.live-reload.options] which lists the options you have for live-reload such as:

* Which port it should connect with the server (using WebSockets), `liveReloadPort`.
* `liveReloadAttempts`, which says how many attempts it should make to reconnect to the server.

### steal-tools

The [steal-tools.cmd.live-reload] command is the CLI command used to launch a live-reload server. It takes a `--live-reload-port` flag (like the `liveReloadPort` config option in steal). You will need to set both of these to use a port other than 8012. See the docs there for more on what you can do with the CLI command.


## Using HMR

To enable hot module replacement, first update your package.json to include __live-reload__ as a configDependency:

```json
{
  "steal": {
    "configDependencies": [
      "live-reload"
    ]
  }
}
```

Then import the live-reload module anywhere in your application:

```js
import "live-reload";
```

This tells the module to connect to the live-reload server via WebSockets. To enable the live-reload server, use [steal-tools]:

```shell
steal-tools live-reload
```

Which should show:

```shell
Live-reload server listening on port 8012
```

> *Note*: To prevent having to globally install steal-tools, instead add a script to your *package.json*.

Next let's update the `index.js` file to import live-reload:

```js
import "./styles.css";
import $ from "jquery";
import "live-reload";

$(document.body).append("<h1>Hello World!</h1>");
```

@highlight 3

Now when you make a change to `index.js` and save it the module will reload and you should see something like this in the console:

```shell
Reloading stealjs@1.0.0#index
```

Back in your browser, though, you'll see that the `<h1>` has been appended twice, oops!

![live-reload double render](https://user-images.githubusercontent.com/361671/32618847-db2400e2-c546-11e7-9052-806878480aa9.png)

This is where the [steal.live-reload] API comes into play. The module exports a function that can take a callback. That callback will be called *after* the current module is reloaded.

We can use this API to remove the previous `<h1>` from the page. Update the code to be like this:

```js
import "./styles.css";
import $ from "jquery";
import reload from "live-reload";

var h1 = $("<h1>Hello World!</h1>");
$(document.body).append(h1);

reload(function(){
  // Since this module is re-executed, a new version
  // of the h1 will be appended, this deletes the old one.
  h1.remove();
});
```

@highlight 3,5-6,8-12

Now you should understand the basics of hot module replacement and the [steal.live-reload] API. See the detailed docs for more functions that you can use for more advanced usage.
