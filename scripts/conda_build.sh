#!/usr/bin/env bash

VERSION=0.0.18

case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
    export OS_NAME=linux
    ;;
  darwin*)
    export OS_NAME=osx
    ;;
  msys*)
    export OS_NAME=windows
    ;;
  *)
    export OS_NAME=notset
    ;;
esac
CONDA_DIR=$(which conda | sed "s:bin/conda:conda-bld/${OS_NAME}-64:")

eval "$(conda shell.bash hook)"

for PYTHON in 3.6 3.7 3.8; do
  conda build --python $PYTHON conda-recipe &&
  PYTHON=$(echo $PYTHON | sed "s:3\.:py3:") &&
  conda convert --platform linux-64 $CONDA_DIR/tolkein-${VERSION}-${PYTHON}_0.tar.bz2 -o dist/conda &&
  conda convert --platform osx-64 $CONDA_DIR/tolkein-${VERSION}-${PYTHON}_0.tar.bz2 -o dist/conda &&
  mkdir -p dist/conda/${OS_NAME}-64 &&
  cp $CONDA_DIR/tolkein-${VERSION}-${PYTHON}_0.tar.bz2 dist/conda/${OS_NAME}-64/ &&
  conda create -y -c $CONDA_DIR -n test_tolkein --force tolkein &&
  conda activate test_tolkein &&
  tolkein -v &&
  conda deactivate &&
  for FILE in dist/conda/*/*-$VERSION-${PYTHON}_0.tar.bz2; do
    anaconda -t $CONDA_TOKEN upload $FILE
  done ||
  conda deactivate
done