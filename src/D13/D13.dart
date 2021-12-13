import 'dart:convert';
import 'dart:io';
import 'dart:math';

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() {
    return 'Point{x: $x, y: $y}';
  }

  @override
  bool operator ==(Object other) {
    if (other is Point) {
      return x == other.x && y == other.y;
    }
    return false;
  }
}

class Fold {
  String type = '';
  int value = 0;

  Fold() {
    type = '';
    value = 0;
  }

  Fold.fromFields(this.type, this.value);

  @override
  String toString() {
    return 'Fold{type: $type, value: $value}';
  }
}

class D13 {
  static int SIZE = 2000;
  List<Point> sharps = [];
  List<Fold> folds = [];
  Point maximum = Point(0, 0);

  int noSharps = 0;

  Future<void> main() async {
    await read();
    int noOverlaps = 0;

    File output = File('D13.out');
    await output.writeAsString('');

    int idFold = 0;
    for (final fold in folds) {
      ++idFold;
      print(idFold);

      List<Point> overlaps = [];
      List<Point> complementaries = [];

      for (final sharp in sharps) {
        Point complementary = Point(sharp.x, sharp.y);
        complementaries.add(complementary);
        if (fold.type == 'x') {
          complementary.x = maximum.x - sharp.x;
        } else {
          complementary.y = maximum.y - sharp.y;
        }
        //if (sharps.contains(complementary)) {
        //++noOverlaps;
        //overlaps.add(sharp);
        //}
      }
      //noSharps = sharps.length - noOverlaps + noOverlaps ~/ 2;
      //print(noSharps);

      sharps.addAll(complementaries);
      sharps = sharps.toSet().toList(); // remove duplicates

      List <Point> newSharps = [];

      int newMaximumX = fold.type == 'x' ? maximum.x ~/ 2 - 1 : maximum.x;
      int newMaximumY = fold.type == 'y' ? maximum.y ~/ 2 - 1 : maximum.y;
      Point newMaximum = Point(newMaximumX, newMaximumY);
      sharps.removeWhere((sharp) => sharp.x > newMaximum.x);
      sharps.removeWhere((sharp) => sharp.y > newMaximum.y);
      if (idFold == folds.length) {
        for (int idCol = 0; idCol <= newMaximum.y; ++idCol) {
          for (int idLine = 0; idLine <= newMaximum.x; ++idLine) {
            if (sharps.contains(Point(idLine, idCol))) {
              await output.writeAsString('#', mode: FileMode.append);
            } else {
              await output.writeAsString(' ', mode: FileMode.append);
            }
          }
          await output.writeAsString('\n', mode: FileMode.append);
        }
        await output.writeAsString('\n\n', mode: FileMode.append);
      }

      maximum = newMaximum;
    }
  }

  Future<void> read() async {
    // matrix = List.generate(SIZE, (index) => List.generate(SIZE, (index) => 0));

    String input = await File('D13.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    List<String> strings = splitter.convert(input).toList();

    for (final string in strings) {
      if (string.length <= 0) continue;
      if (int.tryParse(string[0]) == null) {
        List<String> words = string.split(" ");
        Fold fold = Fold();
        fold.type = words[2][0];
        fold.value = int.parse(words[2].substring(2));
        folds.add(fold);
        continue;
      }
      List<String> split = string.split(",");
      int x = int.parse(split.first);
      int y = int.parse(split.last);
      maximum.x = max(x, maximum.x);
      maximum.y = max(y, maximum.y);
      sharps.add(Point(x, y));
    }
    print(sharps);
    print(folds);
    print(maximum);
  }
}

Future<void> main() async {
  D13 data = D13();
  await data.main();
}
