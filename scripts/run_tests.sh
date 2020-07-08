#!/usr/bin/env bash

if [ -z "$1" ]; then
  git stash -k -u
fi

# lint code in lib directory
echo "pylint --rcfile=.pylintrc src/tolkein -f parseable -r n" &&
pylint --rcfile=.pylintrc src/tolkein -f parseable -r n &&
# check codestyle
echo "pycodestyle src/tolkein --max-line-length=120" &&
pycodestyle src/tolkein --max-line-length=120 &&
# check docstyle
echo "pydocstyle src/tolkein" &&
pydocstyle src/tolkein &&

# run tests and generate coverage report
echo "py.test --isort --cov-config .coveragerc --doctest-modules --cov=src/tolkein --cov-report term-missing" &&
py.test --isort --cov-config .coveragerc --doctest-modules --cov=src/tolkein --cov-report term-missing

if [ -z "$1" ]; then
  git stash pop
fi
