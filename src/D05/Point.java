package D05;

public class Point {
    int col;
    int line;

    public Point() {
        line = col = 0;
    }

    public Point(int line, int col) {
        this.col = col;
        this.line = line;
    }

    @Override
    public String toString() {
        return "Point{" +
                "col=" + col +
                ", line=" + line +
                '}';
    }
}
