import 'dart:io';

class D16 {
  String binary = '';

  Future<void> main() async {
    await read();
    int idChar = 0;
    int sum = 0;

    while (binary.length % 4 != 0) {
      binary = '0' + binary;
    }
    print(binary);

    while (idChar < binary.length) {
      int start = idChar;
      String versionString = binary.substring(idChar, idChar += 3);
      int version = int.parse(versionString, radix: 2);
      if (version == 0) {
        break;
      }
      sum += version;

      String typeIdString = binary.substring(idChar, idChar += 3);
      int typeId = int.parse(typeIdString, radix: 2);

      // Skip all bytes after version and type
      if (typeId == 4) {
        while (true) {
          String group = binary.substring(idChar, idChar += 5);
          if (group.substring(0, 1) == '0') {
            break;
          }
        }
      } else {
        String lengthTypeIdString = binary.substring(idChar, idChar += 1);
        int lengthTypeId = int.parse(lengthTypeIdString, radix: 2);
        if (lengthTypeId == 0) {
          String subPacketsLengthString =
              binary.substring(idChar, idChar += 15);
          int subPacketsLength = int.parse(subPacketsLengthString, radix: 2);
        } else {
          String noSubPacketsString = binary.substring(idChar, idChar += 11);
          // int noSubPackets = int.parse(noSubPacketsString, radix: 2);
          // idChar += 11 * noSubPackets;
        }
      }
      // idChar += (4 - (idChar - start) % 4);
    }
    print(sum);
  }

  Future<void> read() async {
    String input = await File('D16.in').readAsStringSync();
    binary = BigInt.parse(input, radix: 16).toRadixString(2);
  }
}

Future<void> main() async {
  D16 data = new D16();
  await data.main();
}
