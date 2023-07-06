function adjAverage(mat, n, m) {
  for (let x = 0; x < n; x++) {
    for (let y = 0; y < m; y++) {
      process.stdout.write((Math.floor([[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].filter((e) => (e[0] >= 0 && e[0] < n) && (e[1] >= 0 && e[1] < m)).reduce((a, c, _i, arr) => a+(mat[c[0]][c[1]]/arr.length), 0)*10)/10).toFixed(1) + " ");
    }
    process.stdout.write("\n");
  }
}

const mat = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
];

adjAverage(mat, 3, 3);
