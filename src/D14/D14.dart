import 'dart:convert';
import 'dart:io';
import 'dart:math';

class D14 {
  String template = '';
  Map<String, String> rules = Map();

  Future<void> main() async {
    await read();

    for (int step = 1; step <= 10; ++step) {
      rules.forEach(
        (key, value) {
          String newTemplate = '';
          newTemplate = template.replaceAll(key.toString(), value.toString());
          while (template != newTemplate) {
            template = newTemplate;
            newTemplate = template.replaceAll(key.toString(), value.toString());
          }
        },
      );
      template = template.toUpperCase();
    }

    // print(template);

    int minimum = template.length;
    int maximum = -1;
    for (int idCode = 'A'.codeUnitAt(0);
        idCode <= 'Z'.codeUnitAt(0);
        ++idCode) {
      String letter = String.fromCharCode(idCode);
      int noMatches = letter.allMatches(template).length;
      if (noMatches != 0) {
        minimum = min(minimum, noMatches);
      }
      maximum = max(maximum, noMatches);
    }
    print(maximum - minimum);
  }

  Future<void> read() async {
    String input = await File('D14.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    List<String> strings = splitter.convert(input).toList();

    Iterator iterator = strings.iterator;
    iterator.moveNext();
    template = iterator.current;
    iterator.moveNext();

    while (iterator.moveNext()) {
      String string = iterator.current;
      List<String> split = string.split(' -> ');
      String value = split.first[0] + split.last.toLowerCase() + split.first[1];
      rules[split.first] = value;
    }
  }
}

Future<void> main() async {
  D14 data = new D14();
  await data.main();
}
