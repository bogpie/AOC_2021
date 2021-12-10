import 'dart:convert';
import 'dart:io';

class D10 {
  List<String> lines = [];

  static Map<String, String> bracketPairs = {
    '(': ')',
    '[': ']',
    '{': '}',
    '<': '>'
  };

  static Map<String, int> errorValue = {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137,
  };

  static Map<String, int> autoCompleteValue = {
    ')': 1,
    ']': 2,
    '}': 3,
    '>': 4,
  };

  static Future<void> main() async {
    D10 data = D10();
    await data.read();

    print(data.findErrorScore());
  }

  Future<void> read() async {
    String input = await File('D10.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    lines = splitter.convert(input).toList();
  }

  int findErrorScore() {
    int score = 0;
    List<String> stack = [];
    for (String line in lines) {
      stack.clear();
      for (int idChar = 0; idChar < line.length; ++idChar) {
        String char = line[idChar];
        if (isOpen(char)) {
          stack.add(char);
        } else {
          String top = stack.last;
          String? topPair = bracketPairs[top];
          if (topPair == null) exit(1);
          if (topPair == char) {
            stack.removeLast();
          } else {
            int? value = errorValue[char];
            if (value == null) exit(1);
            score += value;
            break;
          }
        }
      }
    }
    return score;
  }

  bool isOpen(String char) {
    return char == '(' || char == '[' || char == '{' || char == '<';
  }
}

main() {
  D10.main();
}
