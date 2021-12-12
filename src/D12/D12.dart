import 'dart:collection';
import 'dart:convert';
import 'dart:io';

class D12 {
  Map<String, SplayTreeSet<String>> graph = Map();
  Map<String, int> noVisits = Map();
  int noPaths = 0;
  bool hasVisitedTwice = false;

  static Future<void> main() async {
    D12 data = D12();
    await data.read();
    data.noVisits["start"] = 1;
    data.DFS("start");
    print(data.noPaths);

    await data.read();
    data.noVisits["start"] = 1;
    data.specialDFS("start");
    print(data.noPaths);
  }

  Future<void> read() async {
    graph = Map();
    noVisits = Map();
    noPaths = 0;
    hasVisitedTwice = false;

    String input = await File('D12.in').readAsStringSync();
    LineSplitter splitter = LineSplitter();
    List<String> strings = splitter.convert(input).toList();
    strings.forEach(
      (string) {
        List<String> split = string.split("-");
        if (graph[split.first] == null) {
          graph[split.first] = SplayTreeSet();
        }
        graph[split.first]!.add(split.last);

        if (graph[split.last] == null) {
          graph[split.last] = SplayTreeSet();
        }
        graph[split.last]!.add(split.first);

        if (isSmall(split.first)) {
          noVisits[split.first] = 0;
        }

        if (isSmall(split.last)) {
          noVisits[split.last] = 0;
        }
      },
    );
  }

  bool isSmall(String cave) {
    return cave[0].toLowerCase() == cave[0];
  }

  void DFS(String cave) {
    if (cave == 'end') {
      ++noPaths;
      return;
    }

    if (graph[cave] == null) return;
    for (final neighbour in graph[cave]!) {
      if (isSmall(neighbour) == true) {
        if (noVisits[neighbour] == null) return;
        if (noVisits[neighbour] == 1) continue;
        noVisits[neighbour] = 1;
      }
      DFS(neighbour);
      if (isSmall(neighbour) == true) {
        noVisits[neighbour] = 0;
      }
    }
  }

  void specialDFS(String cave) {
    if (cave == 'end') {
      ++noPaths;
      return;
    }

    if (graph[cave] == null) return;
    for (final neighbour in graph[cave]!) {
      if (neighbour == 'start') {
        continue;
      } else if (isSmall(neighbour) == true) {
        if (noVisits[neighbour] == null) {
          return;
        }
        if (noVisits[neighbour] == 1 && hasVisitedTwice == true) {
        } else if (noVisits[neighbour] == 1 && hasVisitedTwice == false) {
          noVisits[neighbour] = noVisits[neighbour]! + 1;
          hasVisitedTwice = true;
          specialDFS(neighbour);
          noVisits[neighbour] = noVisits[neighbour]! - 1;
          hasVisitedTwice = false;
        } else if (noVisits[neighbour] == 0) {
          noVisits[neighbour] = noVisits[neighbour]! + 1;
          specialDFS(neighbour);
          noVisits[neighbour] = noVisits[neighbour]! - 1;
        }
        continue;
      }
      specialDFS(neighbour);
    }
  }
}

main() {
  D12.main();
}
