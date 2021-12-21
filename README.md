# CSAFE Fitness Library

This is a dart library that implements the [CSAFE Protocol Framework](https://web.archive.org/web/20071207110624/http://www.fitlinxx.com/CSAFE/Framework.htm) used by fitness machines.

This CSAFE protocol is used in at least some devices made by:
- [Concept2](https://www.concept2.com/service/software/software-development-kit)
- [Wahoo Fitness](https://www.dcrainmaker.com/2016/01/announces-gymconnect-integration.html)
- [Cybex](https://www.cybexintl.com/manuals/treadmills/770t%20treadmill/english/lt-22983-4_htmlfiles/other/csafe_port.html)
- [Star Trac](https://support.corehandf.com/Brands/StarTrac/Manuals/620-8558B.pdf)
- [Primo Fitness](https://primofitnessusa.com/wp-content/uploads/2017/01/TRM-932i-MANUALS-111014-English-manual.pdf)
- [Matrix Fitness](https://www.matrixfitness.com/us/eng/cardio/consoles)


## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Vocabulary

Where possible, this library tries to re-use language from the CSAFE specification.

One notable exception to this is that this library will use the term "server" instead of "slave" to represent the fitness device providing the data and the term "client" instead of "master" to represent the device that is requesting the data.  


## Unit Testing
Tests can be run with `dart test`.

Coverage reports can be created with the following commands:
```bash
dart test --coverage=./coverage
dart run coverage:format_coverage --packages=.packages --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage # create the lcov.info file
genhtml -o ./coverage/report ./coverage/lcov.info # generate the report
```

## Assumptions made about the spec

This library assumes that, when a Csafe Frame is sent containing multiple commands, the responses to those commands will also be contained in a single frame.

This library also relies quite heavily on the order in which commands are responded to.