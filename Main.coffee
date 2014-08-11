path = require("path")
childProcess = require("child_process")
prompt = require("prompt")

onErr = (err) ->
  console.log err
  1
console.log "Please enter your slack details:"
properties = [
  {
    name: "email"
    validator: /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    warning: "Email is invali"
  }
  {
    message: "Enter your password (will be hidden)"
    name: "password"
    hidden: true
  }
]
prompt.start()
prompt.get properties, (err, result) ->
  if err
    console.log err
    return null

  binPath = "./node_modules/casperjs/bin/casperjs"
  childArgs = [
    "--engine=slimerjs"
    path.join(__dirname, "Scrape.coffee"),
    result.email,
    result.password
  ]
  childProcess.execFile binPath, childArgs, (err, stdout, stderr) ->
    console.log "Result:\n#{stdout}\nerror: #{err} #{stderr}"

  return null
