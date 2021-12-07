import 'dart:io';

void main() async {
  List<int> crabs = await readCrabs();
  List<int> sums = createSums(crabs);

  int minTotal = findMinTotalPartOne(crabs, sums);
  print(minTotal);

  minTotal = findMinTotalPartTwo(crabs);
  print(minTotal);
}

int findMinTotalPartTwo(List<int> crabs) {
  int minTotal = (1 << 31) - 1;
  int furthestCrab = crabs[crabs.length - 1];
  List<int> gauss = List.generate(furthestCrab + 1, (index) => -1);

  for (int spent = 0; spent < furthestCrab; ++spent) {
    int total = 0;
    for (int idCrab = 0; idCrab < crabs.length; ++idCrab) {
      total += findGauss(gauss, (crabs[idCrab] - spent).abs());
    }
    if (total < minTotal) minTotal = total;
  }
  return minTotal;
}

int findGauss(List<int> gauss, int number) {
  if (gauss[number] == -1) {
    gauss[number] = number * (number + 1) ~/ 2;
  }
  return gauss[number];
}

int findMinTotalPartOne(List<int> crabs, List<int> sums) {
  int minTotal = (1 << 31) - 1;
  int idCrab = 0, spent = 0, total = 0;
  while (idCrab < crabs.length) {
    if (spent < crabs[idCrab]) {
      int leftSide = spent * idCrab - sums[idCrab - 1];
      int rightSide = sums[crabs.length - 1] -
          sums[idCrab - 1] -
          spent * (crabs.length - idCrab);

      total = leftSide + rightSide;

      if (total < minTotal) {
        minTotal = total;
      }
      ++spent;
    } else {
      ++idCrab;
    }
  }
  return minTotal;
}

List<int> createSums(List<int> crabs) {
  List<int> sums = List.generate(crabs.length, (index) => 0);
  sums[0] = crabs[0];
  for (int idSum = 1; idSum < sums.length; ++idSum) {
    sums[idSum] = sums[idSum - 1] + crabs[idSum];
  }

  return sums;
}

Future<List<int>> readCrabs() async {
  String input = await File("D07.in").readAsStringSync();
  return input.split(",").map(
    (String string) {
      if (int.tryParse(string) == null) {
        exit(1);
      }
      return int.parse(string);
    },
  ).toList()
    ..sort();
}
