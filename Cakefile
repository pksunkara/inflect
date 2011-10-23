{spawn, exec} = require 'child_process'

task 'lib', 'Generate the library from the src', ->
  coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()

task 'docs', 'Generate the documentation from the src', ->
  exec([
    'for i in $(find src -name *.coffee)'
    'do mkdir -p $(dirname $i | sed -s "s/src/docs/")'
    'docco $i'
    'mv docs/$(basename $i | sed -s "s/coffee/html/") $(echo $i | sed -s "s/coffee/html/;s/src/docs/")'
    'done'
  ].join('; '), (err) ->
    throw err if err
  )
