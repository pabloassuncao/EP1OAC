function adjAverage(matrix, i, j) {
    let sum = 0;
    let count = 0;
		
    for (let x = i - 1; x <= i + 1; x++) {
      for (let y = j - 1; y <= j + 1; y++) {
        if (x >= 0 && x < matrix.length && y >= 0 && y < matrix[0].length && (x == i || y == j) && (x != i || y != j)) {
          sum += matrix[x][y];
          count++;
        }
      }
    }
    return sum / count;
}

const matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
];

console.log(adjAverage(matrix, 1, 1)); // 5
