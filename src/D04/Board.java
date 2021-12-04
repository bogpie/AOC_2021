package D04;

import java.util.Arrays;

public class Board {
    static int noLines = 5;
    private int[][] values;

    public Board() {
        this.values = new int[5][5];
    }

    public static int getNoLines() {
        return noLines;
    }

    public static void setNoLines(int noLines) {
        Board.noLines = noLines;
    }

    public int[][] getValues() {
        return values;
    }

    public void setValues(int[][] values) {
        this.values = values;
    }

    @Override
    public String toString() {
        return "Board{" +
                "matrix=" + Arrays.toString(values) +
                '}';
    }

    int calculateScore(int drawn) {
        int score = 0;
        for (int idLine = 0; idLine < noLines; ++idLine) {
            for (int idCol = 0; idCol < noLines; ++idCol) {
                if (values[idLine][idCol] != -1) {
                    score += values[idLine][idCol];
                }
            }
        }
        score *= drawn;
        return score;
    }
}
