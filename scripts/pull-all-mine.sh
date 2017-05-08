#!/bin/bash

set -e

cd cellularmitosis
for i in *
do
    echo $i
    cd $i
    git pull
    cd ..
done
cd ..

cd pepaslabs 
for i in *
do
    echo $i
    cd $i
    git pull
    cd ..
done
cd ..
