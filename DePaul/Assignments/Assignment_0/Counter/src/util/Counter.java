package util;

public class Counter {
    public int count(int x) {
    // TODO check that x > 0 and <= 255
    // if not throw a new RuntimeException
    // Example for a RuntimeException:

    if (x <= 0 || x > 255)
        throw new RuntimeException("x should be between 1 and 255");

    // TODO calculate the numbers from 1 to x
    // for example if x is 5, calculate
    // 1 + 2 + 3 + 4 + 5
    int sum = 0;
    for (int i = 1; i <= x; i++)
        sum += i;


    // TODO return your calculated value
    // instead of 0
    return sum;
    }
}
