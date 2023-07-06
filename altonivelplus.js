function adjAverage(mat, n, m) {
  const r = new Array(n).fill(0).map(() => []);
  
  for (let x = 0; x < n; x++) {
    for (let y = 0; y < m; y++) {
      r[x].push(Math.floor([[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].filter((e) => (e[0] >= 0 && e[0] < mat.length) && (e[1] >= 0 && e[1] < mat[0].length)).reduce((a, c, _i, arr) => a+(mat[c[0]][c[1]]/arr.length), 0)*10)/10);
    }
  }
  return r;
}

const mat = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
];

console.log(adjAverage(mat, 3, 3));
