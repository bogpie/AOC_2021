package D04;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.atomic.AtomicInteger;

public class D04 {
    static String path = "src/D04/D04.in";
    private final Vector<Board> boards;
    private final int noThreads;
    private final Thread[] threads;
    private final CyclicBarrier barrier;
    private Vector<Integer> drawnValues;
    private final AtomicInteger lastScore;

    public D04() {
        drawnValues = new Vector<>();
        boards = new Vector<Board>();
        noThreads = Runtime.getRuntime().availableProcessors();
        barrier = new CyclicBarrier(noThreads);
        threads = new Thread[noThreads];
        lastScore = new AtomicInteger(-1);
    }

    public static void main(String[] args) throws FileNotFoundException {
        D04 data = new D04();
        data.read(path);

        for (int idThread = 0; idThread < data.noThreads; ++idThread) {
            data.threads[idThread] =
                    new MyThread(idThread, data);
            data.threads[idThread].start();
        }
        for (int idThread = 0; idThread < data.noThreads; idThread++) {
            try {
                data.threads[idThread].join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public AtomicInteger getLastScore() {
        return lastScore;
    }

    public void setLastScore(Integer lastScore) {
        this.lastScore.set(lastScore);
    }

    public Vector<Integer> getDrawnValues() {
        return drawnValues;
    }

    public Vector<Board> getBoards() {
        return boards;
    }

    public int getNoThreads() {
        return noThreads;
    }

    public CyclicBarrier getBarrier() {
        return barrier;
    }

    void readDrawn(Scanner scanner) {
        String drawnString = scanner.nextLine();
        StringTokenizer stringTokenizer = new StringTokenizer(drawnString, ",");
        drawnValues = new Vector<>();

        while (stringTokenizer.hasMoreTokens()) {
            drawnValues.add(Integer.parseInt(stringTokenizer.nextToken()));
        }
    }

    void readBoards(Scanner scanner) {
        int id = 0;
        while (scanner.hasNext()) {
            scanner.nextLine();
            Board board = new Board();
            for (int idLine = 0; idLine < Board.noLines; ++idLine) {
                for (int idCol = 0; idCol < Board.noLines; ++idCol) {
                    board.getValues()[idLine][idCol] = scanner.nextInt();
                }
            }
            board.setId(id++);
            boards.add(board);
        }
    }

    void read(String path) throws FileNotFoundException {
        Scanner scanner = new Scanner(new File(path));
        readDrawn(scanner);
//        System.out.println(drawnValues);
        readBoards(scanner);
    }
}

