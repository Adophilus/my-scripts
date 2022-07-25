const watch = require('node-watch')
const fs = require('fs')
const path = require('path')
const { exec } = require('child_process')

const workdir = process.cwd() || process.argv[1]
const extensions = [
  '.html',
  '.css',
  '.cjs',
  '.js',
  '.jsx',
  '.ts',
  '.tsx',
  '.md',
  '.json'
]
const prettify = (event, filePath) => {
  if (event === 'update') {
    for (let extension of extensions) {
      if (filePath.endsWith(extension) && event === 'update') {
        console.log(`prettifying ${filePath}`)
        exec(`pnpm format:prettier --write "${filePath}"`)
      }
    }
  }
}

watch(
  workdir,
  {
    recursive: true,
    filter: (f) => !/node_modules|\.git|\.next|\.public/.test(f)
  },
  function (event, filepath) {
    // console.log('%s changed.', name)
    prettify(event, filepath)
  }
)
