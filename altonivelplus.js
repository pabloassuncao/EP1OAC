function adjAverage(matrix, n, m) {
  const resp = new Array(n).fill(0).map(() => []);
  
  for (let x = 0; x < n; x++) {
    for (let y = 0; y < m; y++) {
      resp[x].push(Math.floor([[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].filter((ele) => (ele[0] >= 0 && ele[0] < matrix.length) && (ele[1] >= 0 && ele[1] < matrix[0].length)).reduce((acc, e, _i, arr) => acc+(matrix[e[0]][e[1]]/arr.length), 0)*10)/10);
    }
  }
  return resp;
}

const matrix = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
];

adjAverage(matrix, 3, 3);
