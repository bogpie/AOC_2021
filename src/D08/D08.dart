import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  List<int> alphabetAscii =
      new List.generate(7, (index) => 'a'.codeUnitAt(0) + index);
  List<String> alphabet = [];
  alphabet = alphabetAscii
      .map((asciiValue) => String.fromCharCode(asciiValue))
      .toList();

  List<String> signalPatterns = [];
  List<String> outputNumbers = [];

  await read(signalPatterns, outputNumbers);

  signalPatterns = sortStrings(signalPatterns);
  outputNumbers = sortStrings(outputNumbers);

  print(countUniques(outputNumbers));
  print(findSum(signalPatterns, outputNumbers, alphabet));
}

int findSum(List<String> signalPatterns, List<String> outputNumbers,
    List<String> alphabet) {
  List<Map<String, int>> mappings = //
      List.generate(signalPatterns.length, (index) => Map());
  int sum = 0;

  for (int idLine = 0; idLine < signalPatterns.length; ++idLine) {
    String signalPattern = signalPatterns[idLine];
    String outputNumber = outputNumbers[idLine];
    List<String> split = signalPattern.split(" ");

    String one = split.where((signal) => signal.length == 2).first;
    mappings[idLine][one] = 1;

    String four = split.where((signal) => signal.length == 4).first;
    mappings[idLine][four] = 4;

    String seven = split.where((signal) => signal.length == 3).first;
    mappings[idLine][seven] = 7;

    String eight = split.where((signal) => signal.length == 7).first;
    mappings[idLine][eight] = 8;

    String three = //
        split
            .where((signal) =>
                signal.length == 5 && signal.containsAllOf(seven, alphabet))
            .first;
    mappings[idLine][three] = 3;

    String nine = //
        split
            .where((signal) =>
                signal.length == 6 && signal.containsAllOf(three, alphabet))
            .first;
    mappings[idLine][nine] = 9;

    String five = //
        split
            .where((signal) =>
                signal.length == 5 &&
                nine.containsAllOf(signal, alphabet) &&
                signal.containsAllOf(one, alphabet) == false)
            .first;
    mappings[idLine][five] = 5;

    int number = 0;
    List<String> digits = outputNumber.split(" ");

    for (int idDigit = 0; idDigit < digits.length; ++idDigit) {
      String digit = digits[idDigit];
      int? digitValue = 0;
      if (mappings[idLine].containsKey(digit) &&
          mappings[idLine][digit] != null) {
        digitValue = mappings[idLine][digit];
      } else {
        if (digit.length == 5) {
          digitValue = 2;
        } else if (digit.containsAllOf(five, alphabet))
          digitValue = 6;
        else
          digitValue = 0;
      }
      number = number * 10 + digitValue!;
    }

    sum += number;
  }
  return sum;
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

List<String> sortStrings(List<String> strings) {
  List<String> sortedStrings = [];
  strings.forEach(
    (signal) {
      String sortedSignal =
          signal.split(" ").map((string) => sortLetters(string)).join(" ");
      sortedStrings.add(sortedSignal);
    },
  );
  return sortedStrings;
}

String sortLetters(String string) {
  List<int> alphabet =
      new List.generate(26, (index) => 'a'.codeUnitAt(0) + index);

  List<int> asciiValues = [];
  alphabet.forEach(
    (asciiValue) {
      String letter = String.fromCharCode(asciiValue);
      if (string.contains(letter)) {
        asciiValues.add(asciiValue);
      }
    },
  );

  return String.fromCharCodes(asciiValues);
}
