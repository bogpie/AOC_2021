package D01;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.Vector;

public class D01 {
    Vector<Integer> elements = new Vector<>();

    void doPartOne() throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("src/D01/D01.in"));
        int previous = scanner.nextInt(), current, increases = 0;
        elements.add(previous);
        while (scanner.hasNext()) {
            current = scanner.nextInt();
            if (current > previous) {
                ++increases;
            }
            previous = current;
            elements.add(current);
        }
        System.out.println("Increases with window of 1 " + increases);
    }

    void doPartTwo() {
        int a = elements.get(0);
        int b = elements.get(1);
        int c = elements.get(2);
        int current = 0, increases = 0;
        int previous = a + b + c;

        for (int id = 3; id < elements.size(); ++id) {
            current = elements.get(id) +
                    elements.get(id - 1) +
                    elements.get(id - 2);

            if (current > previous) {
                ++increases;
            }

            previous = current;
        }

        System.out.println("Increases with window of 3 " + increases);
    }

    public static void main(String[] args) throws FileNotFoundException {
        D01 d01 = new D01();
        d01.doPartOne();
        d01.doPartTwo();
    }

}
