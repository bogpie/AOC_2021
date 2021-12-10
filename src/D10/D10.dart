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
    '(': 1,
    '[': 2,
    '{': 3,
    '<': 4,
  };

  static Future<void> main() async {
    D10 data = D10();
    await data.read();

    print(data.findErrorScore());
    print(data.findAutoCompleteScore());
  }

  Future<void> read() async {
    String input = await File('D10.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    lines = splitter.convert(input).toList();
  }

  int findErrorScore() {
    int score = 0;
    List<String> stack = [];

    for (int idLine = 0; idLine < lines.length; ++idLine) {
      String line = lines[idLine];
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
            lines[idLine] = '';
            break;
          }
        }
      }
    }
    lines.removeWhere((line) => line.length == 0);
    return score;
  }

  bool isOpen(String char) {
    return char == '(' || char == '[' || char == '{' || char == '<';
  }

  int findAutoCompleteScore() {
    List<int> scores = [];

    List<String> stack = [];

    for (final String line in lines) {
      stack.clear();
      int score = 0;

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
            exit(1);
          }
        }
      }

      while (stack.isNotEmpty) {
        String top = stack.last;
        int? value = autoCompleteValue[top];
        score = score * 5 + (value ?? 0);
        stack.removeLast();
      }
      scores.add(score);
    }
    scores.sort();
    return scores[scores.length ~/ 2];
  }
}

main() {
  D10.main();
}
