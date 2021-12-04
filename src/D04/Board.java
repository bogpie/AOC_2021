package D04;

import java.util.Arrays;
import java.util.concurrent.atomic.AtomicBoolean;

public class Board {
    static int noLines = 5;
    private int[][] values;
    private AtomicBoolean hasWon;
    private int id;

    public Board() {
        this.values = new int[5][5];
        hasWon = new AtomicBoolean();
        hasWon.set(false);
    }

    public static int getNoLines() {
        return noLines;
    }

    public static void setNoLines(int noLines) {
        Board.noLines = noLines;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int[][] getValues() {
        return values;
    }

    public void setValues(int[][] values) {
        this.values = values;
    }

    public AtomicBoolean getHasWon() {
        return hasWon;
    }

    public void setHasWon(AtomicBoolean hasWon) {
        this.hasWon = hasWon;
    }

    public void setHasWon(boolean hasWon) {
        this.hasWon.set(hasWon);
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
