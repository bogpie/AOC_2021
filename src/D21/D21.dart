import 'dart:io';
import 'dart:math';

class D21 {
  List<int> startingPositions = [];

  Future<void> main() async {
    await read();
    doPartOne();
  }

  Future<void> read() async {
    String input = await File('D21.in').readAsStringSync();
    List<String> split = input.split(': ');
    split.remove(split.first); // 'Player 1 starting position'
    startingPositions.add(
        int.tryParse(split.first.split('Player 2 starting position').first) ??
            0);
    startingPositions.add(int.tryParse(split.last) ?? 0);
  }

  void doPartOne() {
    int noRolls = 0;
    int noSpaces = 10;
    int noTurns = 3;

    List<int> score = List.generate(2, (index) => 0);
    List<int> positions = [];
    positions.addAll(startingPositions);
    int die = 1;
    int maxDie = 100;
    int maxScore = 1000;

    bool gameOver = false;
    while (gameOver == false) {
      for (int idPlayer = 0; idPlayer < 2; ++idPlayer) {
        int totalRoll = 0;
        for (int idTurn = 0; idTurn < noTurns; ++idTurn) {
          totalRoll += die;
          die = (die + 1) % maxDie;
          ++noRolls;
          if (die == 0) die = maxDie;
        }
        positions[idPlayer] = (positions[idPlayer] + totalRoll) % noSpaces;
        if (positions[idPlayer] == 0) {
          positions[idPlayer] = noSpaces;
        }
        score[idPlayer] += positions[idPlayer];

        if (score[idPlayer] >= maxScore) {
          gameOver = true;
          break;
        }
      }
    }

    print(min(score[0], score[1]) * noRolls);
  }
}

Future<void> main() async {
  D21 data = new D21();
  await data.main();
}
