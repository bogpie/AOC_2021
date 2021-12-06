package D05;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.stream.IntStream;

import static java.lang.Math.max;
import static java.lang.Math.min;

public class D05 {
    static int noLines = 1000;
    int[][] matrix;
    Vector<Tunnel> tunnels;

    public D05() {
        matrix = new int[noLines][noLines];
        tunnels = new Vector<>();
    }

    public static void main(String[] args) throws FileNotFoundException {
        D05 data = new D05();
        data.readInput();
        data.solve(false);

        data = new D05();
        data.readInput();
        data.solve(true);

    }

    private void solve(boolean withDiagaonals) {
        fillMatrix(withDiagaonals);
        findIntersections(withDiagaonals);
    }

    private void findIntersections(boolean withDiagaonals) {
        Long noIntersections =
                Arrays.stream(matrix).map(
                        line ->
                                Arrays.stream(line).filter(
                                        value -> value > 1
                                ).count()

                ).reduce(0L, Long::sum);

        if (withDiagaonals) {
            System.out.println("Intersections with diagonals " + noIntersections);
        } else {
            System.out.println("Intersections without diagonals " + noIntersections);
        }
    }

    private void fillMatrix(boolean withDiagonals) {
        tunnels.forEach(
                tunnel -> {

                    Point minimum = new Point(
                            min(tunnel.left.line, tunnel.right.line),
                            min(tunnel.left.col, tunnel.right.col)
                    );

                    Point maximum = new Point(
                            1 + max(tunnel.left.line, tunnel.right.line),
                            1 + max(tunnel.left.col, tunnel.right.col)
                    );

                    Point direction = new Point(
                            tunnel.right.line - tunnel.left.line > 0 ? 1 : -1,
                            tunnel.right.col - tunnel.left.col > 0 ? 1 : -1
                    );

                    IntStream colRange = IntStream.range(
                            minimum.col, maximum.col
                    );

                    IntStream lineRange = IntStream.range(
                            minimum.line, maximum.line
                    );

                    if (tunnel.left.line == tunnel.right.line) {
                        colRange.forEach(idCol -> ++matrix[tunnel.left.line][idCol]);
                    } else if (tunnel.left.col == tunnel.right.col) {
                        lineRange.forEach(idLine -> ++matrix[idLine][tunnel.left.col]);

                    } else if (withDiagonals) {
                        int idLine = tunnel.left.line;
                        int idCol = tunnel.left.col;

                        while (idLine != tunnel.right.line &&
                                idCol != tunnel.right.col) {
                            ++matrix[idLine][idCol];
                            idLine += direction.line;
                            idCol += direction.col;
                        }
                        ++matrix[tunnel.right.line][tunnel.right.col];
                    }
                }
        );
    }

    private void readInput() throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("src/D05/D05.in"));

        while (scanner.hasNext()) {
            Point left = new Point();
            Point right = new Point();

            String string = scanner.nextLine();
            StringTokenizer tokenizer = new StringTokenizer(string, ",-> ");

            while (tokenizer.hasMoreTokens()) {
                left.col = Integer.parseInt(tokenizer.nextToken());
                left.line = Integer.parseInt(tokenizer.nextToken());
                right.col = Integer.parseInt(tokenizer.nextToken());
                right.line = Integer.parseInt(tokenizer.nextToken());
            }

            Tunnel tunnel = new Tunnel(left, right);
            tunnels.add(tunnel);
        }
    }
}
