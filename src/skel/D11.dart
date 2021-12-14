import 'dart:convert';
import 'dart:io';

class D14 {
  List<List<int>> matrix = [];

  Future<void> main() async {
    await read();
    print(matrix);
  }

  Future<void> read() async {
    String input = await File('D14.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    List<String> strings = splitter.convert(input).toList();

    Iterator iterator = strings.iterator;

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
}

Future<void> main() async {
  D14 data = new D14();
  await data.main();
}
