package D03;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

public class D03 {
    Vector<String> strings;

    private void doPartOne() {
        Vector<Integer> noOnesVector = new Vector<>();
        noOnesVector.setSize(strings.get(0).length());
        Collections.fill(noOnesVector, 0);

        for (String string : strings) {
            for (int idChar = 0; idChar < string.length(); ++idChar) {
                if (string.charAt(idChar) == '1') {
                    noOnesVector.set(idChar, noOnesVector.get(idChar) + 1);
                }
            }
        }

        int gamma = 0, epsilon = 0;

        int length = strings.get(0).length();
        for (int idChar = 0; idChar < length; ++idChar) {
            int noOnes = noOnesVector.get(idChar);
            int noZeroes = strings.size() - noOnes;
            gamma += ((noOnes > noZeroes) ? 1 : 0) << (length - idChar - 1);
            epsilon += ((noOnes <= noZeroes) ? 1 : 0) << (length - idChar - 1);
        }

        System.out.println(gamma * epsilon);
    }

    int getValue(boolean isGamma) {
        int length = strings.get(0).length();
        String rating = "";
        for (int idChar = 0; idChar < length; ++idChar) {
            int noOnes = 0;
            for (String string : strings) {
                if (string.charAt(idChar) == '1') {
                    ++noOnes;
                }
            }
            int noZeroes = strings.size() - noOnes;

            char bit;
            if (isGamma) {
                bit = (noOnes >= noZeroes) ? '1' : '0';
            } else {
                bit = (noZeroes <= noOnes) ? '0' : '1';
            }

            Iterator<String> iterator = strings.iterator();
            while (iterator.hasNext()) {
                String string = (String) iterator.next();
                if (string.charAt(idChar) != bit) {
                    iterator.remove();
                }
            }

            if (strings.size() == 1) {
                rating = strings.get(0);
                break;
            }
        }
        return Integer.parseInt(rating, 2);
    }

    private void doPartTwo() {
        Vector<String> backupStrings = new Vector<>(strings);
        int gamma = getValue(true);
        strings = backupStrings;
        int epsilon = getValue(false);
        System.out.println(gamma * epsilon);
    }

    public static void main(String[] args) throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("src/D03/D03.in"));
        D03 d03 = new D03();
        d03.strings = new Vector<>();
        while (scanner.hasNextLine()) {
            d03.strings.add(scanner.nextLine());
        }
        d03.doPartOne();
        d03.doPartTwo();
    }
}
