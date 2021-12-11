import 'dart:convert';
import 'dart:io';

class D11 {
  List<List<int>> matrix = []; // Input
  int flashes = 0; // Output
  int momentAllFlashed = 0;

  static Future<void> main() async {
    D11 data = D11();
    await data.read();
    data.countFlashes(100);
    print(data.flashes.toString() + " flashes after 100 steps");

    await data.read();
    data.countFlashes(5000);
    print("All octopus have first flashed at " +
        data.momentAllFlashed.toString());
  }

  Future<void> read() async {
    flashes = 0;
    matrix = [];
    String input = await File('D11.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    List<String> strings = splitter.convert(input).toList();
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

  void countFlashes(int limit) {
    for (int step = 0; step <= limit; ++step) {
      // printMatrix(step);
      if (step == limit) break; // Print one more time, for the last step

      matrix = matrix
          .map((List<int> line) =>
              line.map((int element) => element + 1).toList())
          .toList();

      for (int idLine = 0; idLine < matrix.length; ++idLine) {
        for (int idCol = 0; idCol < matrix[idLine].length; ++idCol) {
          if (matrix[idLine][idCol] == 0) {
            // Has already flashed
            continue;
          }

          if (matrix[idLine][idCol] > 9) {
            // Should flash
            chainIncrement(idLine, idCol);
          }
        }
      }
      int flashesOnStep = matrix
          .map((line) => line.where((element) => element == 0).length)
          .reduce((value, element) => value + element);
      flashes += flashesOnStep;

      if (flashesOnStep == matrix.length * matrix[0].length) {
        momentAllFlashed = step + 1;
        return;
      }
    }
  }

  void chainIncrement(int idLine, int idCol) {
    if (isInside(idLine, idCol) == false) {
      return;
    }

    if (matrix[idLine][idCol] == 0) {
      return;
    }

    ++matrix[idLine][idCol];
    if (matrix[idLine][idCol] > 9) {
      matrix[idLine][idCol] = 0;
      for (int deltaLine = -1; deltaLine <= 1; ++deltaLine) {
        for (int deltaCol = -1; deltaCol <= 1; ++deltaCol) {
          if (deltaLine == 0 && deltaCol == 0) {
            // Don't continue recursion on the same point
            continue;
          }
          chainIncrement(idLine + deltaLine, idCol + deltaCol);
        }
      }
    }
  }

  bool isInside(int idLine, int idCol) {
    return idLine >= 0 &&
        idLine < matrix.length &&
        idCol >= 0 &&
        idCol < matrix[0].length;
  }

  void printMatrix(int step) {
    print("step " + step.toString());

    matrix.forEach(
      (line) {
        line.forEach(
          (element) {
            stdout.write(element.toString() + " ");
          },
        );
        print('');
      },
    );
    print('');
  }
}

main() {
  D11.main();
}
