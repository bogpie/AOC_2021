import 'dart:convert';
import 'dart:io';

class Point {
  int idLine, idCol;

  Point(this.idLine, this.idCol);

  @override
  bool operator ==(other) {
    return other is Point && idLine == other.idLine && idCol == other.idCol;
  }

  bool getIsVisited(List<List<bool>> isVisited) {
    return isVisited[idLine][idCol];
  }

  bool isInside(List<List<int>> matrix) {
    return idLine >= 0 &&
        idLine < matrix.length &&
        idCol >= 0 &&
        idCol < matrix[0].length;
  }

  int getValue(List<List<int>> matrix) {
    if (isInside(matrix) == false) {
      exit(1);
    }
    return matrix[idLine][idCol];
  }

  @override
  String toString() {
    return 'Point{idLine: $idLine, idCol: $idCol}\n';
  }

  Point getLeft() {
    return Point(idLine, idCol - 1);
  }

  Point getRight() {
    return Point(idLine, idCol + 1);
  }

  Point getUp() {
    return Point(idLine - 1, idCol);
  }

  Point getDown() {
    return Point(idLine + 1, idCol);
  }
}

Future<void> main() async {
  List<List<int>> matrix = [];
  List<Point> lowPoints = [];
  await read(matrix);
  print(findSumOfLowPoints(matrix, lowPoints));
  print(findProductBasins(matrix, lowPoints));
}

int findProductBasins(List<List<int>> matrix, List<Point> lowPoints) {
  List<int> basinSizes = [];
  List<List<bool>> isVisited = List.generate(
    matrix.length,
    (line) => List.generate(matrix[0].length, (index) => false),
  );
  for (final lowPoint in lowPoints) {
    int basinSize = fill(lowPoint, matrix, isVisited);
    basinSizes.add(basinSize);
  }
  basinSizes.sort((a, b) => b - a);
  int product = basinSizes[0] * basinSizes[1] * basinSizes[2];

  return product;
}

int fill(Point point, List<List<int>> matrix, List<List<bool>> isVisited) {
  if (point.isInside(matrix) == false) {
    return 0;
  }

  if (point.getValue(matrix) == 9 || point.getIsVisited(isVisited) == true) {
    return 0;
  }

  isVisited[point.idLine][point.idCol] = true;

  return 1 +
      fill(point.getLeft(), matrix, isVisited) +
      fill(point.getRight(), matrix, isVisited) +
      fill(point.getUp(), matrix, isVisited) +
      fill(point.getDown(), matrix, isVisited);
}

int findSumOfLowPoints(List<List<int>> matrix, List<Point> lowPoints) {
  int sum = 0;

  for (int idLine = 0; idLine < matrix.length; ++idLine) {
    for (int idCol = 0; idCol < matrix[idLine].length; ++idCol) {
      Point point = Point(idLine, idCol);

      Point left = point.getLeft();
      Point right = point.getRight();
      Point up = point.getUp();
      Point down = point.getDown();

      List<Point> neighbours = [];
      if (left.isInside(matrix)) neighbours.add(left);
      if (right.isInside(matrix)) neighbours.add(right);
      if (up.isInside(matrix)) neighbours.add(up);
      if (down.isInside(matrix)) neighbours.add(down);

      bool isLowPoint = true;
      for (final neighbour in neighbours) {
        if (neighbour.getValue(matrix) <= point.getValue(matrix)) {
          isLowPoint = false;
          break;
        }
      }

      if (isLowPoint == true) {
        sum += 1 + point.getValue(matrix);
        lowPoints.add(point);
      }
    }
  }

  return sum;
}

Future<void> read(List<List<int>> matrix) async {
  String input = await File('D09.in').readAsStringSync();
  LineSplitter splitter = LineSplitter();
  List<String> strings = splitter.convert(input);
  strings.forEach(
    (string) {
      List<String> split = string.split("");
      List<int> line = [];

      split.forEach(
        (character) {
          if (int.tryParse(character) == null) {
            exit(1);
          } else {
            line.add(int.parse(character));
          }
        },
      );

      matrix.add(line);
    },
  );
}
