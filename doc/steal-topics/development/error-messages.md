@page StealJS.error-messages Error Messages
@parent StealJS.development 9
@body

The following are common __error messages__ that occur within StealJS apps. This guide lists some of the most common types of error messages and provides some advise on how to track down where the problem is in your code.

## 404 Not Found

This error occurs where requesting a module fails because the web server returned a __404__ status code.

<img width="641" alt="404 error" src="https://user-images.githubusercontent.com/361671/36808550-6b835694-1c93-11e8-8420-16789dde804e.png">

The cause of this error could be:

* The file hasn't been created (or saved) yet.
* There is a typo in the import statement. Click the link in the stack trace (__app.js:6__ in the above screenshot) to take you to the code in the debugger to see.
* If the module being imported is from a 3rd party dependency, you might have forgotten to save the dependency in your package.json's `dependencies` list.

## Mismatched package version

This error occurs when a dependency is not found for the requested version range.

<img width="729" alt="mismatched package versions" src="https://user-images.githubusercontent.com/361671/37489771-11929eb4-286f-11e8-9b24-c1e5c80c64f1.png">

In the above example the __canjs__ package is a dependency of __dep__. The semver range of __^4.0.0__ is requested but __5.0.0__ was found, which does not satisfy the range.

This error usually occurs changing versions and forgeting to run `npm install`.
