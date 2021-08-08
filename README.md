# Prebuilt FastText WASM
This is a modified version of the WASM build provided by https://github.com/loretoparisi/fasttext.js/

# Changes
* Removed all files related to example/building the project
* Modified the fasttext_wasm.js file to take out the "unresolvedPromise" handler - this was overlapping with Promises outside the WASM code
* Changed the lid.176.ftz file to a base64 encoded JS file so it can be embeded via webpack/require in your code
* Modified the fasttext.js to automatically load and decode the base64 model instead of downloading it - falls back to downloading if base64 model file is missing
* Pretty printed the JS files

# How to use
1. Install using npm:
  `npm install "git+https://github.com/av-virlan/browser-fasttext.js.git"
2. Load in project:
  `const { FastText, addOnPostRun } = require('browser-fasttext.js');`
3. The module uses CommonJS so you need to have `require` available - this means you will have to use WebPack to build your bundle
4. Make sure you have the following dependencies installed using `npm install`:
  - browserfs
  - node-polyfill-webpack-plugin
5. Configure you webpack to shim the NodeJS core modules that FastText needs:
  ```
  {
    ...
    resolve: {
      ...    
      fallback: {
        'fs': 'browserfs/dist/shims/fs.js',
      }
    },
    plugins: [
      new NodePolyfillPlugin(),
      ...
    ],
    ...
  }
```
7. In the places where you want to use FastText make sure you initialize the library (make sure the FastText instance is only initialized once, but you can call addOnPostRun multiple times):
  ```
  function initFastText() {
    return new Promise((resolve) => {
      addOnPostRun(() => {
        if(!window.fastText) {
          window.fastText = new FastText();
          window.fastText.loadModel("model.bin").then((model) => {
            window.fastTextModel = window.fastTextModel || model;
            resolve();
          });
        } else {
          resolve();
        }
      });
    });
 }
 
 initFastText().then(() => {
    const prediction = window.fastTextModel.predict("this is a sentence");
    const predictions = [];
    for (let i = 0; i < result.size(); i++) {
      const prediction = prediction.get(i);
      predictions.push({ score: prediction[0], label: prediction[1].substring("__label__".length) });
    }
    predictions.sort((a,b) => b.score - a.score);
    console.log("The text language is: " + predictions[0].label + " confidence " + predictions[0].score);
});
 ```
