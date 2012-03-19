fs = require('fs')
instanceLookup = require('../../lib/instance-lookup')

getConfig = ->
  server: JSON.parse(fs.readFileSync(process.env.HOME + '/.tedious/test-connection.json', 'utf8')).config.server
  instanceName: JSON.parse(fs.readFileSync(process.env.HOME + '/.tedious/test-connection.json', 'utf8')).instanceName

exports.goodInstance = (test) ->
  config = getConfig()

  if !config.instanceName
    # Config says don't do this test (probably because SQL Server Browser is not available).
    console.log('Skipping goodInstance test')
    test.done()
    return

  callback = (err, port) ->
    test.ok(!err)
    test.ok(port)

    test.done()

  instanceLookup(config.server, config.instanceName, callback)

exports.badInstance = (test) ->
  config = getConfig()

  callback = (err, port) ->
    test.ok(err)
    test.ok(!port)

    test.done()

  instanceLookup(config.server, 'badInstanceName', callback)

exports.badServer = (test) ->
  config = getConfig()

  callback = (err, port) ->
    test.ok(err)
    test.ok(!port)

    test.done()

  instanceLookup('badServer', config.instanceName, callback)
