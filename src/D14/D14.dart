import 'dart:convert';
import 'dart:io';
import 'dart:math';

class D14 {
  String template = '';
  Map<String, String> rules = Map();

  Future<void> main() async {
    await read();
    String templateBackup = jsonDecode(jsonEncode(template));
    doPartOne();

    template = templateBackup;
    doPartTwo();
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
      // Using lowercase to avoid overlaps (chained transformations in the same step)
      String value = split.first[0] + split.last.toLowerCase() + split.first[1];
      rules[split.first] = value;
    }
  }

  void doPartOne() {
    // Brute string generation
    for (int step = 0; step < 10; ++step) {
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
      // Allow remaining transformation to be executed, but for the next step
    }

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

  void doPartTwo() {
    /// frequency[XYZ, step] = frequency[XY, step - 1] + frequency[YZ, step -1]

    Map<String, int> frequencyTwoLetters = Map();
    for (int idLetter = 0; idLetter < template.length - 1; ++idLetter) {
      String substring = template.substring(idLetter, idLetter + 2);
      if (frequencyTwoLetters[substring] == null) {
        frequencyTwoLetters[substring] = 0;
      }
      frequencyTwoLetters[substring] = frequencyTwoLetters[substring]! + 1;
    }

    int noSteps = 40;
    for (int step = 0; step < noSteps; ++step) {
      List<String> keys = frequencyTwoLetters.keys
          .where((parent) => frequencyTwoLetters[parent]! > 0)
          .toList();

      for (final parent in keys) {
        if (rules.containsKey(parent) == false) {
          continue;
        }
        if (rules[parent] == null) {
          return;
        }
        String childrenString = rules[parent]!;
        List<String> children = [];
        children.add(childrenString.substring(0, 2));
        children.add(childrenString.substring(1, 3));

        int oldFrequency = frequencyTwoLetters[parent]!;
        frequencyTwoLetters[parent] = 0;
        for (final child in children) {
          if (frequencyTwoLetters.containsKey(child) == false) {
            frequencyTwoLetters[child] = 0;
          }
          if (frequencyTwoLetters[child] == null) {
            return;
          }
          frequencyTwoLetters[child] =
              frequencyTwoLetters[child]! + oldFrequency;
        }
      }

      keys = frequencyTwoLetters.keys.toList();
      for (final key in keys) {
        if (key.toUpperCase() != key) {
          if (frequencyTwoLetters.containsKey(key.toUpperCase()) == false) {
            frequencyTwoLetters[key.toUpperCase()] = 0;
          }
          frequencyTwoLetters[key.toUpperCase()] =
              frequencyTwoLetters[key.toUpperCase()]! +
                  frequencyTwoLetters[key]!;

          frequencyTwoLetters[key] = 0;
        }
      }

      frequencyTwoLetters
          .removeWhere((key, value) => frequencyTwoLetters[key]! == 0);
    }

    // Count one letter frequency using the previous two-letter frequency map
    Map<String, int> frequencyOneLetter = Map();
    frequencyOneLetter[template[0]] = 1;
    frequencyTwoLetters.forEach(
      (key, value) {
        if (frequencyOneLetter.containsKey(key[1]) == false) {
          frequencyOneLetter[key[1]] = 0;
        }
        frequencyOneLetter[key[1]] = frequencyOneLetter[key[1]]! + value;
      },
    );
    int maximum = frequencyOneLetter[template[0]]!;
    int minimum = frequencyOneLetter[template[0]]!;
    frequencyOneLetter.forEach(
      (key, value) {
        maximum = max(maximum, value);
        minimum = min(minimum, value);
      },
    );

    print(maximum - minimum);
  }
}

Future<void> main() async {
  D14 data = new D14();
  await data.main();
}
