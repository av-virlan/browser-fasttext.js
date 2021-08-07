## What is FastText and FastText.js
[FastText](https://github.com/facebookresearch/fastText) is a library for efficient learning of word representations and sentence classification. FastText is provided by Facebook Inc. 
`browser-FastText.js` is a `JavaScript` library  that wraps `FastText` to run smoothly within `browser` or `node`.

# Table of Contents
- [browser-FastText.js APIs](https://github.com/av-virlan/browser-fasttext.js#fasttextjs-apis)
- [How to Install](https://github.com/av-virlan/browser-fasttext.js#how-to-install)
	* [WASM](https://github.com/av-virlan/browser-fasttext.js#wasm) :new:
- [How to Use](https://github.com/av-virlan/browser-fasttext.js#how-to-use)
	* [Train](https://github.com/av-virlan/browser-fasttext.js#train)
	* [Train Supervised](https://github.com/av-virlan/browser-fasttext.js#train-supervised)
	* [Train Unsupervised](https://github.com/av-virlan/browser-fasttext.js#train-unsupervised)
	* [Track Progress](https://github.com/av-virlan/browser-fasttext.js#track-progress)
	* [Test](https://github.com/av-virlan/browser-fasttext.js#test)
	* [Predict](https://github.com/av-virlan/browser-fasttext.js#predict)
	* [Nearest Neighbor](https://github.com/av-virlan/browser-fasttext.js#nearest-neighbor)
- [Datasets](https://github.com/av-virlan/browser-fasttext.js#datasets) :new:
- [Models](https://github.com/av-virlan/browser-fasttext.js#models) :new:
– [How It Works](https://github.com/av-virlan/browser-fasttext.js#how-it-works)
– [Disclaimer](https://github.com/av-virlan/browser-fasttext.js#disclaimer)

## FastText.js APIs
This version of `browser-FastText.js` comes with the following `JavaScript` APIs

```javascript
FastText.new(options)
FastText.load()
FastText.loadnn() [NEW API]
FastText.word2vec() [NEW API]
FastText.train()
FastText.test()
FastText.predict(string)
FastText.nn() [NEW API]
```

## How to Install

```bash
git clone https://github.com/loretoparisi/fasttext.js.git
cd fasttext.js
npm install
```

### WASM
We provide a WASM compiled binary of `FastText` to be used natively NodeJS. Please check `/wasm` folder for library and examples. :new:

## How to Use

### Train
You can specify all the train parameters supported by fastText as a json object

```javascript
train: {
    // number of concurrent threads
    thread: 8,
    // verbosity level [2]
    verbose: 4,
    // number of negatives sampled [5]
    neg: 5,
    // loss function {ns, hs, softmax} [ns]
    loss: process.env.TRAIN_LOSS || 'ns',
    // learning rate [0.05]
    lr: process.env.TRAIN_LR || 0.05,
    // change the rate of updates for the learning rate [100]
    lrUpdateRate: 100,
    // max length of word ngram [1]
    wordNgrams: process.env.TRAIN_NGRAM || 1,
    // minimal number of word occurences
    minCount: 1,
    // minimal number of word occurences
    minCountLabel: 1,
    // size of word vectors [100]
    dim: process.env.TRAIN_DIM || 100,
    // size of the context window [5]
    ws: process.env.TRAIN_WS || 5,
    //  number of epochs [5]
    epoch: process.env.TRAIN_EPOCH || 5,
    // number of buckets [2000000]
    bucket: 2000000,
    // min length of char ngram [3]
    minn: process.env.TRAIN_MINN || 3,
    // max length of char ngram [6]
    maxn: process.env.TRAIN_MAXN || 6,
    // sampling threshold [0.0001]
    t: 0.0001,
    // load pre trained word vectors from unsupervised model
    pretrainedVectors: process.env.WORD2VEC || ''
    }
```

#### Train Supervised
To train the model you must specificy the training set as `trainFile` and the file where the model must be serialized as `serializeTo`. All the `FastText` supervised options are supported. See [here](https://github.com/facebookresearch/fastText#full-documentation) for more details about training options. Note that `serializeTo` does not need to have the file extension in. A `bin` extension for the quantized model will be automatically added. You can use the `pretrainedVectors` option to load an unsupervised pre-trained model. Please use the `word2vec` api to train this model.

```javascript
var fastText = new FastText({
    serializeTo: './band_model',
    trainFile: './band_train.txt'
});
fastText.train()
.then(done=> {
    console.log("train done.");
})
.catch(error => {
    console.error(error);
})
```

#### Train Unsupervised
To train an unsupervised model use the `word2vec` api. You can specify the words representation to train using `word2vec.model` parameter set to `skipgram` or `cbow` and use the `train` parameters as usual:

```javascript
fastText.word2vec()
    .then(done => {
    })
    .catch(error => {
        console.error("Train error", error);
    })
```

## Track Progress
It is possible to track the training progress using the callback parameters `trainProgress` in the options:

```javascript
{
    trainCallback: function(res) {
        console.log( "\t"+JSON.stringify(res) );
    }
}
```

This will print out the training progress in the following format:

```json
{
    "progress":17.2,
    "words":174796,
    "lr":0.041382,
    "loss":1.232538,
    "eta":"0h0m",
    "eta_msec":0
}
```

that is the parsed JSON representation of `fasttext` output 

```
Progress:  17.2% words/sec/thread:  174796 lr:  0.041382 loss:  1.232538 ETA:   0h 0m
```

where `eta_msec` represents the ETA (estimated time of arrival) in milliseconds.

So a typical progress will fire the `trainCallback` several times like

```json
{"progress":0.6,"loss":4.103271,"lr":0.0498,"words":21895,"eta":"0h9m","eta_msec":540000}
{"progress":0.6,"loss":3.927083,"lr":0.049695,"words":21895,"eta":"0h6m","eta_msec":360000}
{"progress":0.6,"loss":3.927083,"lr":0.049695,"words":21895,"eta":"0h6m","eta_msec":360000}
{"progress":0.6,"loss":3.676603,"lr":0.049611,"words":26813,"eta":"0h5m","eta_msec":300000}
{"progress":0.6,"loss":3.676603,"lr":0.049611,"words":26813,"eta":"0h5m","eta_msec":300000}
{"progress":0.6,"loss":3.345654,"lr":0.04949,"words":33691,"eta":"0h4m","eta_msec":240000}
{"progress":1.2,"loss":3.345654,"lr":0.04949,"words":39604,"eta":"0h4m","eta_msec":240000}
```

Until the progress will reach 100%:

```json
{"progress":99,"loss":0.532964,"lr":0.000072,"words":159556,"eta":"0h0m","eta_msec":0}
{"progress":99,"loss":0.532964,"lr":0.000072,"words":159556,"eta":"0h0m","eta_msec":0}
{"progress":99,"loss":0.532392,"lr":-0.000002,"words":159482,"eta":"0h0m","eta_msec":0}
{"progress":100,"loss":0.532392,"lr":0,"words":159406,"eta":"0h0m","eta_msec":0}
{"progress":100,"loss":0.532392,"lr":0,"words":159406,"eta":"0h0m","eta_msec":0}
```

__NOTE__. Please note that some approximation errors may occur in the output values.

### Test
To test your model you must specificy the test set file as `testFile` and the model file to be loaded as `loadModel`. Optionally you can specificy the precision and recall at `k` (P@k and R@k) passing the object `test: { precisionRecall: k }`.

```javascript
var fastText = new FastText({
    loadModel: './band_model.bin',
    testFile:  './band_test.txt'
});
fastText.test()
.then(evaluation=> {
    console.log("test done.",evaluation);
})
.catch(error => {
    console.error(error);
})
```

The `evaluation` will contain the precision `P`, recall `R` and number of samples `N` as a json object `{ P: '0.278', R: '0.278' }`.
If a train is called just before test the `evaluation` will contain the number of words `W` and the number of labels `L` as well as a json object: `{ W: 524, L: 2, N: '18', P: '0.278', R: '0.278' }`:

```javascript
fastText.train()
.then(done=> {
    return fastText.test();
})
.then(evaluation=> {
    console.log("train & test done.",evaluation);
})
.catch(error => {
    console.error("train error",error);
})
```

### Test-Labels
:new: The api `testLabels` evaluate labels `F1-Score`, `Recall` and `Precision` for each label in the model.

```javascript
var fastText = new FastText({
    loadModel: './band_model.bin',
    testFile:  './band_test.txt'
});
fastText.testLabels()
.then(evaluation=> {
    console.log("test-labels:",evaluation);
})
.catch(error => {
    console.error(error);
})
```

This will print out the values `F1`, `P` and `R` for each label.

```json
[
  {
    "ham": {
      "F1": "0.172414",
      "P": "0.094340",
      "R": "1.000000"
    }
  },
  {
    "spam": {
      "F1": "0.950495",
      "P": "0.905660",
      "R": "1.000000"
    }
  }
]
```

### Predict
To inference your model with new data and predict the label you must specify the model file to be loaded as `loadModel`. You can then call the `load` method once, and `predict(string)` to classify a string. Optionally you can specify the `k` most likely labels to print for each line as `predict: { precisionRecall: k }`

```javascript
var sample="Our Twitter run by the band and crew to give you an inside look into our lives on the road. Get #FutureHearts now: http://smarturl.it/futurehearts";
fastText.load()
.then(done => {
    return fastText.predict(sample);
})
.then(labels=> {
    console.log("TEXT:", sample, "\nPREDICT:",labels );
    sample="LBi Software provides precisely engineered, customer-focused #HRTECH solutions. Our flagship solution, LBi HR HelpDesk, is a SaaS #HR Case Management product.";
    return fastText.predict(sample);
})
.then(labels=> {
    console.log("TEXT:", sample, "\nPREDICT:",labels );
    fastText.unload();
})
.catch(error => {
    console.error(error);
});
```


### Nearest Neighbor
To get the nearest neighbor words for a given term use the `nn` api:

```javascript
fastText.loadnn()
.then(labels=> {
    return fastText.nn(text)
})
.then(labels=> {
    console.log("Nearest Neighbor\n", JSON.stringify(labels, null, 2));
})
.catch(error => {
    console.error("predict error",error);
});
```

### Train Language Identification Model
We train a langauge identification model from scratch. Please see in the [examples/models](https://github.com/av-virlan/browser-fasttext.js/tree/master/examples/models) folder.

## Training set and Test set format
The `trainFile` and `testFile` are a TSV or CSV file where the fist column is the label, the second column is the text sample. `FastText.js` will try to normalize the dataset to the `FastText` format using `FastText.prepareDataset` method. You do not have to call this method explicitly by the way, `FastText.js` will do for you. For more info see [here](https://github.com/facebookresearch/fastText#text-classification).

## Datasets
We host some example datasets in order to train, test and predict FastText models on the fly. For more info how to download and work with datasets, please see in the [examples/datasets](https://github.com/av-virlan/browser-fasttext.js/tree/master/examples/dataset) folder.

## Models
We host some example pretrained models. For more info how to download and work with pretrained models, please see in the [examples/models](https://github.com/av-virlan/browser-fasttext.js/tree/master/examples/models) folder.

## Disclaimer
For more info about `FastText` and `FastText` license see [here](https://github.com/facebookresearch/fastText).
