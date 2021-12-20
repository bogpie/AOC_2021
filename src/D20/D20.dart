import 'dart:convert';
import 'dart:io';

import 'Point.dart';

class D20 {
  List<String> algorithm = [];
  List<List<String>> matrix = [];

  Future<void> main() async {
    await read();
    doPartOne();
  }

  Future<void> read() async {
    String input = await File('D20.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    List<String> strings = splitter.convert(input).toList();

    algorithm.addAll(strings.first.split('').toList());
    strings.remove(strings.first); // algorithm
    strings.remove(strings.first); // new line

    strings.forEach(
      (string) {
        matrix.add(string.split(""));
      },
    );
  }

  void doPartOne() {
    List<List<String>> oldMatrix = [];
    oldMatrix.addAll(matrix);
    List<List<String>> newMatrix = [];

    int resize = 3;

    for (int iteration = 0; iteration < 2; ++iteration) {
      newMatrix = List.generate(
        oldMatrix.length + resize * 2,
        (index) =>
            List.generate(oldMatrix[0].length + resize * 2, (index) => ''),
      );

      for (int idLine = -resize; idLine < oldMatrix.length + resize; ++idLine) {
        for (int idCol = -resize; idCol < oldMatrix[0].length + resize; ++idCol) {
          Point point = Point(idLine, idCol);
          List<String> neighboursValues =
              point.getAllNeighboursValues(oldMatrix, iteration);
          List<int> algorithmIndexList = neighboursValues
              .map((String value) => value == '.' ? 0 : 1)
              .toList();
          int algorithmIndexInBinary = algorithmIndexList.fold(
              0, (previousValue, digit) => previousValue * 10 + digit);

          int algorithmIndex =
              int.parse(algorithmIndexInBinary.toString(), radix: 2);

          newMatrix[idLine + resize][idCol + resize] = algorithm[algorithmIndex];
        }
      }

      oldMatrix = newMatrix;
    }

    matrix = newMatrix;

    print(matrix);

    int noLit = matrix
        .map((line) => line
            .where((element) => element == '#')
            .length) // turn each line into number of searched elements
        .reduce((value, element) => value + element); // sum of each counter
    print(noLit);
  }
}

Future<void> main() async {
  D20 data = new D20();
  await data.main();
}
