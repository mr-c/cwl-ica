/** @type {import('ts-jest/dist/types').InitialOptionsTsJest} */
module.exports = {
  transform: {
    "^.+\\.tsx?$": "ts-jest"
  },
  testRegex: "(tests/.*|(\\.|/)(test|spec))\\.(jsx?|tsx?)$",
  testEnvironment: 'node',
  rootDir: ""
};
