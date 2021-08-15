const _ = require('lodash')
const fs = require('fs')

const t = fs.readFileSync('./intl_en.arb')
const tr = JSON.parse(t)

const tr2 = _.mapValues(tr, v => '********')
console.log(JSON.stringify(tr2))
