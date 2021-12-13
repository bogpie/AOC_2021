import 'dart:convert';
import 'dart:io';
import 'dart:math';

class Point implements Comparable {
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

  @override
  int compareTo(other) {
    if (other is Point) {
      if (x == other.x) {
        if (y == other.y) {
          return 0;
        }
        return y - other.y;
      }
      return x - other.x;
    }
    return 0;
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
    File output = File('D13.out');
    await output.writeAsString('');

    int idFold = 0;
    for (final fold in folds) {
      List<Point> complementaries = [];

      for (final sharp in sharps) {
        Point complementary = Point(sharp.x, sharp.y);
        if (fold.type == 'x' && sharp.x > fold.value) {
          int difference = sharp.x - fold.value;
          complementary.x = sharp.x - difference * 2;

          complementaries.add(complementary);
        } else if (fold.type == 'y' && sharp.y > fold.value) {
          int difference = sharp.y - fold.value;
          complementary.y = sharp.y - difference * 2;
          complementaries.add(complementary);
        }
      }
      sharps.addAll(complementaries);
      int newMaximumX = fold.type == 'x' ? fold.value - 1 : maximum.x;
      int newMaximumY = fold.type == 'y' ? fold.value - 1 : maximum.y;
      Point newMaximum = Point(newMaximumX, newMaximumY);
      sharps.removeWhere((sharp) => sharp.x > newMaximum.x);
      sharps.removeWhere((sharp) => sharp.y > newMaximum.y);

      if (idFold == folds.length - 1) {
        for (int idCol = 0; idCol <= newMaximum.y; ++idCol) {
          for (int idLine = 0; idLine <= newMaximum.x; ++idLine) {
            if (sharps.contains(Point(idLine, idCol))) {
              await output.writeAsString('█', mode: FileMode.append);
            } else {
              await output.writeAsString('.', mode: FileMode.append);
            }
          }
          await output.writeAsString('\n', mode: FileMode.append);
        }
        await output.writeAsString('\n\n', mode: FileMode.append);
      }

      maximum = newMaximum;
      ++idFold;
    }
  }

  Future<void> read() async {
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
  }
}

Future<void> main() async {
  D13 data = D13();
  await data.main();
}
