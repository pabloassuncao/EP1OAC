function adjAverage(mat, n, m) {
  return new Array(n).fill(new Array(m).fill(0)).map((e, x, arr) => e.map((e, y) => (Math.floor([[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].filter((e) => (e[0] >= 0 && e[0] < n) && (e[1] >= 0 && e[1] < m)).reduce((a, c, _i, arr) => a+(mat[c[0]][c[1]]/arr.length), 0)*10)/10).toFixed(1)));
}

const mat = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
];

console.log(adjAverage(mat, 3, 3));
