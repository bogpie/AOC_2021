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

  Point get left {
    return Point(idLine, idCol - 1);
  }

  Point get right {
    return Point(idLine, idCol + 1);
  }

  Point get up {
    return Point(idLine - 1, idCol);
  }

  Point get down {
    return Point(idLine + 1, idCol);
  }

  bool isInside(List<List<int>> matrix) {
    return idLine >= 0 &&
        idLine < matrix.length &&
        idCol >= 0 &&
        idCol < matrix[0].length;
  }

  List<Point> getNeighbours(List<List<int>> matrix) {
    List<Point> neighbours = [];
    if (left.isInside(matrix)) neighbours.add(left);
    if (right.isInside(matrix)) neighbours.add(right);
    if (up.isInside(matrix)) neighbours.add(up);
    if (down.isInside(matrix)) neighbours.add(down);
    return neighbours;
  }
}

class SetElement {
  Point point;
  int cost;

  SetElement(this.point, this.cost);

  @override
  String toString() {
    return 'SetElement{point: $point, cost: $cost}';
  }

  @override
  bool operator ==(Object other) {
    if(other is SetElement){
      return point == other.point && cost == other.cost;
    }
    return false;
  }
}
