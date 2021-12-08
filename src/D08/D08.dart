import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  List<int> alphabetAscii =
      new List.generate(26, (index) => 'a'.codeUnitAt(0) + index);
  List<String> alphabet = [];
  alphabet = alphabetAscii
      .map((asciiValue) => String.fromCharCode(asciiValue))
      .toList();

  print(alphabet);

  List<String> signalPatterns = [];
  List<String> outputNumbers = [];

  await read(signalPatterns, outputNumbers);

  print(countUniques(outputNumbers));

  print(findSum(signalPatterns, outputNumbers, alphabet));
}

int findSum(List<String> signalPatterns, List<String> outputNumbers,
    List<String> alphabet) {
  List<List<String>> mappinngs = //
      List.generate(
          signalPatterns.length,
          (index) => //
              List.generate(10, (index) => ""));

  for (int idLine = 0; idLine < signalPatterns.length; ++idLine) {
    String signalPattern = signalPatterns[idLine];
    String outputNumber = outputNumbers[idLine];
    List<String> split = signalPattern.split(" ");

    String seven = split.where((signal) => signal.length == 3).first;
    mappinngs[idLine][7] = seven;

    String three = //
        split
            .where((signal) =>
                signal.length == 5 && signal.containsAllOf(seven, alphabet))
            .first;
    mappinngs[idLine][3] = three;

    print(three);
  }
  return 0;
}

int countUniques(List<String> outputNumbers) {
  return outputNumbers
      .join(" ") // Strings at the end of the line need a separator
      .split(" ")
      .where((string) => isUnique(string.length) == true)
      .length;
}

bool isUnique(int length) {
  return length != 5 && length != 6;
}

Future<void> read(List<String> leftStrings, List<String> rightStrings) async {
  String input = await File('D08.in').readAsStringSync();
  LineSplitter splitter = LineSplitter();
  List<String> lines = splitter.convert(input);

  lines.forEach(
    (line) {
      List<String> split = line.split(" | ");
      leftStrings.add(split.first);
      rightStrings.add(split.last);
    },
  );
}

int findDigit(String string) {
  if (string.length == 2) {
    return 1;
  } else if (string.length == 4) {
    return 4;
  } else if (string.length == 3) {
    return 7;
  } else if (string.length == 7) {
    return 8;
  }
  return 0;
}

extension StringExtension on String {
  bool containsAllOf(String second, List<String> alphabet) {
    for (final letter in alphabet) {
      if (second.contains(letter)) {
        if (contains(letter) == false) {
          return false;
        }
      }
    }
    return true;
  }
}
