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
                data.getBoards().get(idBoard).setHasWon(true);
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
                data.getBoards().get(idBoard).setHasWon(true);
            }
        }
    }

    @Override
    public void run() {
        int noThreads = data.getNoThreads();
        Vector<Integer> drawnValues = data.getDrawnValues();

        for (int drawn : drawnValues) {
            try {
                data.getBarrier().await();
            } catch (InterruptedException | BrokenBarrierException e) {
                e.printStackTrace();
            }

            int start = idThread * data.getBoards().size() / noThreads;
            int end = Math.min((idThread + 1) * data.getBoards().size() / noThreads, data.getBoards().size());
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


            try {
                data.getBarrier().await();
            } catch (InterruptedException | BrokenBarrierException e) {
                e.printStackTrace();
            }

            removeWinners(data, drawn);

            if (data.getBoards().size() == 0) {
                if (idThread == 0)
                    System.out.println("Last score is " + data.getLastScore());
                return;
            }

        }
    }

    private void removeWinners(D04 data, int drawn) {
        for (Board board : data.getBoards()) {
            if (board.getHasWon().get()) {
                int score = board.calculateScore(drawn);
                if (idThread == 0 && data.getLastScore().get() == -1) {
                    System.out.println("First score is " + score);
                }

                try {
                    data.getBarrier().await();
                } catch (InterruptedException | BrokenBarrierException e) {
                    e.printStackTrace();
                }

                data.setLastScore(score);
            }
        }
        try {
            data.getBarrier().await();
        } catch (InterruptedException | BrokenBarrierException e) {
            e.printStackTrace();
        }

        data.getBoards().removeIf(board -> board.getHasWon().get());
    }
}
