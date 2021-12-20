class Point {
  int _idLine;
  int _idCol;

  int get idLine => _idLine;

  int get idCol => _idCol;

  Point(this._idLine, this._idCol);

  @override
  bool operator ==(Object other) {
    if (other is Point) {
      return idLine == other.idLine && idCol == other.idCol;
    }
    return false;
  }

  @override
  String toString() {
    return '$idLine, $idCol';
  }

  bool isInside(List<List<String>> matrix) {
    return idLine >= 0 &&
        idLine < matrix.length &&
        idCol >= 0 &&
        idCol < matrix[0].length;
  }

  List<String> getAllNeighboursValues(
      List<List<String>> matrix, int iteration, List<String> algorithm) {
    List<String> neighboursValues = [];
    for (int deltaLine = -1; deltaLine <= 1; ++deltaLine) {
      for (int deltaCol = -1; deltaCol <= 1; ++deltaCol) {
        int newIdLine = idLine + deltaLine;
        int newIdCol = idCol + deltaCol;
        if (Point(newIdLine, newIdCol).isInside(matrix)) {
          neighboursValues.add(matrix[newIdLine][newIdCol]);
        } else {
          neighboursValues
              .add(iteration % 2 == 1 ? algorithm[0] : algorithm[1 << 9 - 1]);
          // edge cases where algorithm index is 0 0000 0000 or 1 1111 1111
        }
      }
    }
    return neighboursValues;
  }
}
