#!/bin/bash
#
# FastText Tools
# @author Loreto Parisi (loretoparisi at gmail dot com)
# v1.0.0
# @2018 Loreto Parisi (loretoparisi at gmail dot com)
#

myshuf() {
  perl -MList::Util=shuffle -e 'print shuffle(<>);' "$@";
}

FOLDER=./

if [ ! -f $FOLDER/sentences.tar ]; then
    echo $FOLDER/sentences.tar downloading...
    # let's download the training data:
    wget http://downloads.tatoeba.org/exports/sentences.tar.bz2 -P $FOLDER
    bunzip2 $FOLDER/sentences.tar.bz2
    tar xvf $FOLDER/sentences.tar -C $FOLDER
else
    echo $FOLDER/sentences.tar downloaded already!

    if [ ! -f $FOLDER/sentences.csv ]; then
        echo $FOLDER/sentences.tar extracting...
        tar xvf $FOLDER/sentences.tar -C $FOLDER
    else
        echo $FOLDER/sentences.csv present already!
    fi
fi

echo Converting to fasttext format...
# Then, we need to put our training data into fastText format, which is easily done using:
# on macos `shuf`` needs `brew install coreutils``
# this will print out a label in the ISO-639-2 format codes:
#
# __label__jpn 家を出ようとしていたら、トムから電話がかかってきた。
# __label__spa No se atrevió a aparecerse allí nunca más.
#
# while current pre-trained model has a ISO-639-1 labels e.g. "JA", "SP" codes
#
awk -F"\t" '{print"__label__"$2" "$3}' < $FOLDER/sentences.csv | myshuf > $FOLDER/lang_all.txt

echo Splitting into train and test set...
# We can then split our training data into training and validation sets:
head -n 10000 $FOLDER/lang_all.txt > $FOLDER/lang_valid.txt
tail -n +10001 $FOLDER/lang_all.txt > $FOLDER/lang_train.txt

echo Train set $FOLDER/lang_train.txt samples: $(wc -l < $FOLDER/lang_train.txt )
echo Validation set $FOLDER/lang_valid.txt: $(wc -l < $FOLDER/lang_valid.txt )

