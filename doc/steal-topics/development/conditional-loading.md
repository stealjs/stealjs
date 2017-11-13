@page StealJS.conditionals Conditional Loading
@parent StealJS.development 6

@body

__Conditional Loading__ is a way to conditionally load a module based on run-time conditions. Using a special syntax you can conditionally load code based on values in other modules.

## API

Conditional loading is facilitated via [steal-conditional]. Refer to its documentation on using the syntax APIs.

Additionally there are two guides on using steal-conditional:

* [StealJS.guides.boolean_conditional_loading]
* [StealJS.guides.substitution_conditional_loading]

## Setting up

To use conditionals you first need to install [steal-conditional]:

```shell
npm install steal-conditional --save
```

And then add it as a config dependency in your package.json:

```json
{
  "steal": {
    "configDependencies": [
      "node_modules/steal-conditional/conditional"
    ]
  }
}
```

This loads steal-conditional before anything else in your application. You *cannot* rely on `node_modules` resolution here, because this module will be loaded before the [npm] plugin.

## Difference from dynamic module loading

Unlike *dynamic loading*, a conditional is defined like other static modules.

For example, here we are dynamically importing a module based on a `page` property on the root `<html>` element:

```html
<html data-page="login"> ... </html>
```

__main.js__

```js
let page = document.documentElement.dataset.page;

steal.import(`app/pages/${page}/${page}`).then(function(){
  // Login page is loaded.
});
```

This same code could be expressed using the conditional syntax like so:

__page.js__

```js
let page = document.documentElement.dataset.page;

export default page;
```

__main.js__

```js
import "app/pages/#{page}";

// Login page is loaded
```

The difference here is that the latter code only evaluates *once*, when the code is initially loaded. This means that we cannot change the `page` and rerun the code.

We can summarize when to use each this way:

* *Use dynamic loading* when conditions can be changed during the life of the application. As the above example shows, the __page__ might change as the user navigates. In this case we can use dynamic loading to go from page to page, to prevent loading code until its needed.
* Additionally, use dynamic loading to load code that is non-critical. An example would be if the user is unlikely to see a part of the page (maybe they have to click a link first), use dynamic loading to avoid loading the code that will possibly be unneeded.
* On the other hand, *use conditional loading* to code that is both __critical__ to the application and unlikely to change during its lifespan. Two examples are language files and polyfills. The user's language is not (likely) going to change, and neither are the browser's capabilities. Both of these, however, are essential dependencies of the code that needs them. So including them as static dependencies is the way to go.
