package D04;

import java.util.Vector;
import java.util.concurrent.BrokenBarrierException;

public class MyThread extends Thread {
    private final int idThread;
    private final D04 data;

    public MyThread(int idThread, D04 data) {
        this.idThread = idThread;
        this.data = data;
    }

    private void drawValue(int[][] values, int drawn) {
        for (int idLine = 0; idLine < Board.getNoLines(); ++idLine) {
            for (int idCol = 0; idCol < Board.getNoLines(); ++idCol) {
                if (values[idLine][idCol] == drawn) {
                    values[idLine][idCol] = -1;
                }
            }
        }
    }

    private void checkWon(D04 data, int idBoard, int[][] values) {
        for (int idLine = 0; idLine < Board.getNoLines(); ++idLine) {
            int noMarked = 0;
            for (int idCol = 0; idCol < Board.getNoLines(); ++idCol) {
                if (values[idLine][idCol] == -1) {
                    ++noMarked;
                }
            }
            if (noMarked == Board.getNoLines()) {
                data.getHasWon()[idBoard].set(true);
            }
        }

        for (int idCol = 0; idCol < Board.getNoLines(); ++idCol) {
            int noMarked = 0;
            for (int idLine = 0; idLine < Board.getNoLines(); ++idLine) {
                if (values[idLine][idCol] == -1) {
                    ++noMarked;
                }
            }
            if (noMarked == Board.getNoLines()) {
                data.getHasWon()[idBoard].set(true);
            }
        }
    }

    @Override
    public void run() {
        int size = data.getBoards().size();
        int noThreads = data.getNoThreads();
        Vector<Integer> drawnValues = data.getDrawnValues();

        int start = idThread * size / noThreads;
        int end = Math.min((idThread + 1) * size / noThreads, size);

        for (int drawn : drawnValues) {
            for (int idBoard = start; idBoard < end; ++idBoard) {
                int[][] values = data.getBoards().get(idBoard).getValues();
                drawValue(values, drawn);
            }

            try {
                data.getBarrier().await();
            } catch (InterruptedException | BrokenBarrierException e) {
                e.printStackTrace();
            }

            for (int idBoard = start; idBoard < end; ++idBoard) {
                int[][] values = data.getBoards().get(idBoard).getValues();

                checkWon(data, idBoard, values);
            }

            try {
                data.getBarrier().await();
            } catch (InterruptedException | BrokenBarrierException e) {
                e.printStackTrace();
            }

            for (int idBoard = 0; idBoard < size; ++idBoard) {
                if (data.getHasWon()[idBoard].get()) {
                    if (idThread == 0)
                        System.out.println(data.getBoards().get(idBoard).calculateScore(drawn));
                    return;
                }
            }
        }
    }


}
