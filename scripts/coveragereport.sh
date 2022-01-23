#!/bin/bash

dart test --coverage=./coverage
dart run coverage:format_coverage --packages=.packages --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage # create the lcov.info file
genhtml -o ./coverage/report ./coverage/lcov.info # generate the report