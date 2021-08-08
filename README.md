# Prebuilt FastText WASM
This is a modified version of the WASM build provided by https://github.com/loretoparisi/fasttext.js/

# Changes
* Removed all files related to example/building the project
* Modified the fasttext_wasm.js file to take out the "unresolvedPromise" handler - this was overlapping with Promises outside the WASM code
* Changed the lid.176.ftz file to a base64 encoded JS file so it can be embeded via webpack/require in your code
* Modified the fasttext.js to automatically load and decode the base64 model instead of downloading it - falls back to downloading if base64 model file is missing
* Pretty printed the JS files