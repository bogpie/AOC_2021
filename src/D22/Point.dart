class Point implements Comparable {
  List<int> _coordinates = [];

  List<int> get coordinates => _coordinates;

  Point() {
    _coordinates = [];
  }

  Point.fromCoordinates(this._coordinates);

  // @override
  // bool operator ==(Object other) {
  //   bool result = true;
  //   if (other is Point) {
  //     for (int idCoord = 0; idCoord < coordinates.length; ++idCoord) {
  //       result &= (coordinates[idCoord] == other.coordinates[idCoord]);
  //     }
  //   }
  //   return result;
  // }

  @override
  int compareTo(other) {
    if (other is Point) {
      if (coordinates[0] == other.coordinates[0]) {
        if (coordinates[1] == other.coordinates[1]) {
          if (coordinates[2] == other.coordinates[2]) {
            return 0;
          }
          return coordinates[2] - other.coordinates[2];
        }
        return coordinates[1] - other.coordinates[1];
      }
      return coordinates[0] - other.coordinates[0];
    }
    return -1;
  }

  @override
  String toString() {
    return 'Point{_coordinates: $_coordinates}';
  }

// bool isInside(List<List<String>> matrix) {
//   return X >= 0 &&
//       X < matrix.length &&
//       Y >= 0 &&
//       Y < matrix[0].length;
// }
//
// List<String> getAllNeighboursValues(
//     List<List<String>> matrix, int iteration, List<String> algorithm) {
//   List<String> neighboursValues = [];
//   for (int deltaX = -1; deltaX <= 1; ++deltaX) {
//     for (int deltaY = -1; deltaY <= 1; ++deltaY) {
//       int newIdX = X + deltaX;
//       int newIdY = Y + deltaY;
//       if (Point(newIdX, newIdY).isInside(matrix)) {
//         neighboursValues.add(matrix[newIdX][newIdY]);
//       } else {
//         neighboursValues
//             .add(iteration % 2 == 1 ? algorithm[0] : algorithm[1 << 9 - 1]);
//         // edge cases where algorithm index is 0 0000 0000 or 1 1111 1111
//       }
//     }
//   }
//   return neighboursValues;
// }
}
