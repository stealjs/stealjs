@page StealJS.loading-from-cdn Loading Scripts from a CDN
@parent StealJS.production

@body

Steal can be used to load script files from a URL, such as a Content Delivery Network (CDN).


## Loading from a CDN in production

A common use case is to load a script from a CDN in production-mode only.
This example will show you how to load jQuery from NPM in development mode, but use jQuery's CDN in production.

There are two changes that need to be made for this to work:

* Set the Steal config to use the CDN path for production
* Modify the build script to ignore jQuery when creating production bundles

### System configuration

Here is an example showing how to set the System config to load jQuery from a CDN in production.

```
  "steal": {
    "meta": {
      "jquery": {
        "format": "global",
        "exports": "jQuery",
        "build": false
      }
    },
    "envs": {
      "window-production": {
        "paths": {
          "jquery": "https://code.jquery.com/jquery-2.2.4.min.js"
        }
      }
    }
  }
```

### Build script

Update the build script to ignore jQuery.
This example shows how to do this with a simple build.js file.

```
var stealTools = require('steal-tools');

stealTools.build({
    config: __dirname + "/package.json!npm"
}, {
    ignore: [ 'jquery' ]
});
```

