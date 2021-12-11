import 'dart:convert';
import 'dart:io';

class D11 {
  List<List<int>> matrix = [];

  static Future<void> main() async {
    D11 data = D11();
    await data.read();
    print(data.matrix);
  }

  Future<void> read() async {
    String input = await File('D11.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    List<String> strings = splitter.convert(input).toList();
    // int noLines = strings.length;
    // int noCols = strings.first.length;
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

main() {
  D11.main();
}
