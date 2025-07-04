class FibonacciCalculator {
  static int calculate(int n) {
    if (n <= 1) return n;
    return calculate(n - 1) + calculate(n - 2);
  }

  static int calculateIterative(int n) {
    if (n <= 1) return n;

    int prev1 = 0;
    int prev2 = 1;

    for (int i = 2; i <= n; i++) {
      int current = prev1 + prev2;
      prev1 = prev2;
      prev2 = current;
    }

    return prev2;
  }
}
