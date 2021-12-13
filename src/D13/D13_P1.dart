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
    Fold fold = folds[0];
    int noOverlaps = 0;
    for (final sharp in sharps) {
      Point complementary = Point(sharp.x, sharp.y);
      if (fold.type == 'x') {
        complementary.x = maximum.x - sharp.x;
      } else {
        complementary.y = maximum.y - sharp.y;
      }

      if (sharps.contains(complementary)) {
        ++noOverlaps;
      }
    }
    noSharps = sharps.length - noOverlaps + noOverlaps ~/ 2;

    print(noSharps);
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
