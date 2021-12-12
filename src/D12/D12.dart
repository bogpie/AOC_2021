import 'dart:collection';
import 'dart:convert';
import 'dart:io';

class D12 {
  Map<String, SplayTreeSet<String>> graph = Map();
  Map<String, bool> isVisited = Map();
  int noPaths = 0;

  static Future<void> main() async {
    D12 data = D12();
    await data.read();
    print(data.graph);
    data.isVisited["start"] = true;
    data.DFS("start");
    print(data.noPaths);
  }

  Future<void> read() async {
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
          isVisited[split.first] = false;
        }

        if (isSmall(split.last)) {
          isVisited[split.last] = false;
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
      if (isSmall(neighbour) && isVisited[neighbour] == null) return;
      if (isSmall(neighbour) && isVisited[neighbour] == true) {
        continue;
      }

      if (isSmall(neighbour) == true) {
        isVisited[neighbour] = true;
      }
      DFS(neighbour);
      if (isSmall(neighbour) == true) {
        isVisited[neighbour] = false;
      }
    }
  }
}

main() {
  D12.main();
}
