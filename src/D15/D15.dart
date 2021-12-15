import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'Point.dart';

class D15 {
  List<List<int>> matrix = [];
  List<List<bool>> isVisited = [];

  Future<void> main() async {
    await read();
    findShortestPath();
  }

  Future<void> read() async {
    String input = await File('D15.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    List<String> strings = splitter.convert(input).toList();

    matrix.addAll(
      strings.map(
        (string) => string.split('').map(
          (char) {
            if (int.tryParse(char) == null) return 0;
            return int.parse(char);
          },
        ).toList(),
      ),
    );

    isVisited = List.generate(
      matrix.length,
      (index) => List.generate(matrix[0].length, (index) => false),
    );
  }

  void printPoint(Point point) {
    print('$point --> ${matrix[point.idLine][point.idCol]}');
  }

  void findShortestPath() {
    SplayTreeSet<SetElement> set = SplayTreeSet(
      (SetElement first, SetElement second) {
        if (first.cost == second.cost) {
          if (first.point.idLine == second.point.idLine) {
            return first.point.idCol - second.point.idCol;
          }
          return first.point.idLine - second.point.idLine;
        }
        return first.cost - second.cost;
      },
    );

    isVisited[0][0] = false;
    Point start = Point(0, 0);
    Point end = Point(matrix.length - 1, matrix[0].length - 1);
    set.add(SetElement(start, 0));

    List<List<int>> cost;

    cost = List.generate(matrix.length,
        (index) => List.generate(matrix[0].length, (index) => 0));

    while (set.isNotEmpty) {
      // set.forEach(print);
      // print('');

      SetElement top = set.first;
      set.remove(top);
      if (isVisited[top.point.idLine][top.point.idCol]) {
        continue;
      }
      isVisited[top.point.idLine][top.point.idCol] = true;

      if (top.point == end) {
        print(top.cost);
        break;
      }

      for (final neighbour in top.point.getNeighbours(matrix)) {
        if (isVisited[neighbour.idLine][neighbour.idCol] == true) {
          continue;
        }
        int newCost = top.cost + matrix[neighbour.idLine][neighbour.idCol];
        set.add(SetElement(neighbour, newCost));
      }
    }
  }
}

Future<void> main() async {
  D15 data = new D15();
  await data.main();
}
