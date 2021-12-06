package D05;

public class Tunnel {
    Point left;
    Point right;

    public Tunnel(Point left, Point right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public String toString() {
        return "Tunnel{" +
                "left=" + left +
                ", right=" + right +
                '}';
    }
}
