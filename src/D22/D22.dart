import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'Point.dart';

class D22 {
  List<Command> commands = [];

  Future<void> main() async {
    await read();
    doPartOne();
  }

  Future<void> read() async {
    String input = await File('D22.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    List<String> strings = splitter.convert(input).toList();

    strings.forEach(
      (string) {
        List<String> stringsSplit = string.split(RegExp(r'[ ,]'));

        Command command = Command();
        command.isOn = stringsSplit.first == 'on';
        stringsSplit.remove(stringsSplit.first);
        for (int idCoord = 0; idCoord < 3; ++idCoord) {
          String rangeString = stringsSplit.first;
          List<String> rangeSplit = rangeString //
              .split(RegExp(r'[=.xyz]'))
            ..removeWhere((element) => element.isEmpty == true);

          Range range = Range();
          int leftSide = int.tryParse(rangeSplit.first) ?? 0;
          int rightSide = int.tryParse(rangeSplit.last) ?? 0;
          range.min = min(leftSide, rightSide);
          range.max = max(leftSide, rightSide);
          command.ranges.add(range);
          stringsSplit.remove(stringsSplit.first);
        }
        commands.add(command);
      },
    );
  }

  void doPartOne() {
    var points = SplayTreeSet<Point>();

    commands.removeWhere((Command command) =>
        command.ranges[0].isInside() == false ||
        command.ranges[1].isInside() == false ||
        command.ranges[2].isInside() == false);

    commands.forEach(
      (command) {
        List<Range> ranges = command.ranges;
        for (int x = ranges[0].min; x <= ranges[0].max; ++x) {
          for (int y = ranges[1].min; y <= ranges[1].max; ++y) {
            for (int z = ranges[2].min; z <= ranges[2].max; ++z) {
              Point point = Point();
              point.coordinates.add(x);
              point.coordinates.add(y);
              point.coordinates.add(z);
              if (command.isOn) {
                points.add(point);
              } else {
                points.remove(point);
              }
            }
          }
        }
      },
    );
    print(points.length);
  }
}

class Range {
  int min = -50;
  int max = 50;
  static const MIN = -50;
  static const MAX = 50;

  @override
  String toString() {
    return 'Range{min: $min, max: $max}';
  }

  isInside() {
    return min >= MIN && max <= MAX;
  }
}

class Command {
  bool isOn = false;
  List<Range> ranges = [];

  @override
  String toString() {
    return 'Command{isOn: $isOn, ranges: $ranges}';
  }
}

Future<void> main() async {
  D22 data = new D22();
  await data.main();
}
