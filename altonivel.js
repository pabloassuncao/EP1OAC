function adjAverage(matrix, n, m) {
    for (let x = 0; x < n; x++) {
      for (let y = 0; y < m; y++) {
        let sum = 0;
        let count = 0;
        [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].forEach(([i, j]) => {
          if (i >= 0 && i < matrix.length && j >= 0 && j < matrix[0].length) {
            sum += matrix[i][j];
            count++;
          }
        });
        process.stdout.write((Math.floor(sum / count * 10) / 10).toFixed(1) + " ");
      }
      process.stdout.write("\n");
    }
}

const matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
];

adjAverage(matrix, 3, 3);
