import 'dart:io';

void main() async {
  String input = await File('D06.in').readAsString();

  List<int> healths = input.split(",").map(
    (String string) {
      if (int.tryParse(string) == null) {
        exit(1);
      }
      return int.parse(string);
    },
  ).toList();

  int remainingDays = 80;
  List<int> healthsBackup = [];
  healthsBackup.addAll(healths);

  while (remainingDays > 0) {
    int length = healths.length;
    for (int idHealth = 0; idHealth < length; ++idHealth) {
      --healths[idHealth];
      if (healths[idHealth] == -1) {
        healths[idHealth] = 6;
        healths.add(8);
      }
    }
    --remainingDays;
  }
  print(healths.length);

  healths = healthsBackup;
  remainingDays = 256;

  int noFish = 0;
  List<List<int>> dp = List.generate(
    9,
    (index) {
      return List.filled(remainingDays + 1, -2, growable: false);
    },
  );

  for (int health in healths) {
    noFish += countFish(health, remainingDays, dp) + 1;
  }

  print(noFish);
}

int countFish(int health, int remainingDays, List<List<int>> dp) {
  // We have already calculated the value
  if (dp[health][remainingDays] != -2) {
    return dp[health][remainingDays];
  }

  // Fish won't regenerate
  if (remainingDays <= health) {
    dp[health][remainingDays] = 0;
  }

  // Fish can regenerate himself and create clones
  else {
    dp[health][remainingDays] = 1 +
        countFish(6, remainingDays - health - 1, dp) +
        countFish(8, remainingDays - health - 1, dp);
  }

  return dp[health][remainingDays];
}
