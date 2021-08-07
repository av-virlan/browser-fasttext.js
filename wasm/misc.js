const {FastText,addOnPostRun}  = require('./fasttext');

const printVector = function(predictions, limit) {
    limit = limit || Infinity;

    for (let i=0; i<predictions.size() && i<limit; i++){
        let prediction = predictions.get(i);
        console.log(predictions.get(i));
    }
}

addOnPostRun(() => {
    let ft = new FastText();

    const url = "lid.176.ftz";
    ft.loadModel(url).then(model => {
        /* isQuant */
        console.log(model.isQuant());

        /* getDimension */
        console.log(model.getDimension());

        /* getWordVector */
        let v = model.getWordVector("Hello");
        console.log(v);

        /* getSentenceVector */
        let v1 = model.getSentenceVector("Hello");
        console.log(v1);
        let v2 = model.getSentenceVector("Hello this is a sentence");
        console.log(v2);

        /* getNearestNeighbors */
        printVector(model.getNearestNeighbors("Hello", 10));

        /* getAnalogies */
        printVector(model.getAnalogies("paris", "france", "london", 10));

        /* getWordId */
        console.log(model.getWordId("Hello"));

        /* getSubwords */
        let subWordInformation = model.getSubwords("désinstitutionnalisation");
        printVector(subWordInformation[0]);

        /* getInputVector */
        console.log(model.getInputVector(832));
    });
});