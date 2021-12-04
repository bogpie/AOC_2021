package D02;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

import static java.lang.System.exit;

public class D02 {
    private void doPartOne() throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("src/D02/D02.in"));
        int horizontal = 0, depth = 0;
        while (scanner.hasNextLine()) {
            String direction = scanner.next();
            int count = scanner.nextInt();
            switch (direction) {
                case "forward" -> {
                    horizontal += count;
                }
                case "down" -> {
                    depth += count;
                }
                case "up" -> {
                    depth -= count;
                }
                default -> {
                    exit(-1);
                }
            }
        }
        System.out.println(horizontal * depth);
    }

    private void doPartTwo() throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("src/D02/D02.in"));
        int aim = 0, horizontal = 0, depth = 0;
        while (scanner.hasNextLine()) {
            String direction = scanner.next();
            int count = scanner.nextInt();
            switch (direction) {
                case "forward" -> {
                    horizontal += count;
                    depth += aim * count;
                }
                case "down" -> {
                    aim += count;
                }
                case "up" -> {
                    aim -= count;
                }
                default -> {
                    exit(-1);
                }
            }
        }
        System.out.println(horizontal * depth);
    }

    public static void main(String[] args) throws FileNotFoundException {
        D02 d02 = new D02();
        d02.doPartOne();
        d02.doPartTwo();
    }
}
