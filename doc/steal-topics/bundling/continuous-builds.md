@page steal-tools.watch-mode Watch Mode
@parent StealJS.bundling 2

@body

[steal-tools] includes a __watch mode__ (using the `--watch` flag in the cli) in its build command (also known as __continuous builds__). This enables you to continuously rebuild your application as you work. This is useful if you prefer a workflow where you are debugging your application as it will appear in production.

## API

The watch mode is part of the [steal-tools.cmd.buildcli]. Refer to those documentation (as well as [steal-tools.build] for the JavaScript API) for more information. In particular refer to [steal-tools.BuildOptions] for the `watch` flag.

Using the JavaScript API, `stealTools.build` returns a Stream:

```js
const stealTools = require("steal-tools");

let buildStream = stealTools.build({}, {
  watch: true
});

buildStream.on('data', () => {
  console.log('A build completed!');
});
```

## Using Continuous Builds

> This part of the guide goes over creating a small app that automatically rebuilds using the watch mode. You can get the full source [here](https://gist.github.com/matthewp/530cfb69c32a03cf1c1e158626e1da7c).

To see how continuous builds work, let's set up a small example application. In your terminal create a new folder for our project:

```shell
mkdir watch-app
cd watch-app
```

Using [npm](https://www.npmjs.com/), create a new project and install our one dependency, [steal-tools]:

```shell
npm init --types
npm install steal-tools http-server --save-dev
```

### Add a main

To get something working, let's create an HTML file and our JavaScript main:

__index.html__

```html
<!doctype html>
<html lang="en">
<title>An app with watch mode</title>

<main></main>

<script src="./dist/steal.production.js"></script>
```

Notice here that you are using `./dist/steal.production.js` as the script tag. Since this app uses the watch mode, this app will *always* be working out of production builds. This production steal script will include everything that is needed to load the rest of the bundles.

Next let's create our JavaScript main:

__index.js__

```js
let main = document.querySelector("main");
main.textContent = "Hello world!";
```

### Create our development scripts

Not that you have a very basic app written, update your *package.json* to add scripts needed to run our watch mode and HTTP servers.

```json
{
  "scripts": {
    "serve": "http-server -p 8081",
    "watch": "steal-tools --watch"
  }
}
```

To start these open two terminal windows (or tabs). In one run the HTTP server:

```shell
npm run serve
```

And in another, run the watch mode:

```shell
npm run watch
```

Now open your browser to http://localhost:8081 and you should see the __Hello world!__ message.

### Adding another module

The point of using a bundler is to enable use of modules, which we can do by adding one. This module is a very basic counter, it just updates a div on an interval. Add this module as *home.js*:

__home.js__

```js
class Home {
  constructor() {
    this.count = 0;
  }

  start() {
    if(!this.started) {
      this.started = true;
      setInterval(() => this.increment(), 2000);
    }
  }

  increment() {
    let count = ++this.count;
    let counter = this.root.querySelector("#counter");
    counter.textContent = count;
  }

  render() {
    this.start();
    let root = this.root = document.createElement("div");
    root.innerHTML = `
      <div id="counter"></div>
    `;
    this.increment();
    return root;
  }
}

module.exports = Home;
```

Notice that this module has a `render()` method that when called, creates some DOM and sets up a setInterval to update it every 2 seconds.

To use this module, update your __index.js__:

```js
const Home = require("./home");

let main = document.querySelector("#main");
main.appendChild(new Home().render());
```

@highlight 1,4

## Notes on use

The `--watch` mode is meant to be used in development, to make it possibly to quickly iterate on an application. Although it creates production-like bundles, they are not optimized for production use. For example, the bundles are not minified.

To create production bundles, check out the [StealJS.guides.progressive_loading] guide.

In our example application, You could create a production build by updating your *package.json* scripts:

```json
{
  "scripts": {
    "build": "steal-tools optimize",
    "serve": "http-server -p 8081",
    "watch": "steal-tools --watch"
  }
}
```

@highlight 3

Which you can run with `npm run build`.
