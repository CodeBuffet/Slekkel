path = require("path")
childProcess = require("child_process")
prompt = require("prompt")
walk = require("walk")
path = require("path")

String::endsWith = (suffix) ->
  @indexOf(suffix, @length - suffix.length) isnt -1

onErr = (err) ->
  console.log err
  1
console.log "Please enter your slack details:"
properties = [
  {
    message: "Enter your slack domain or company name"
    name: "domain"
    hidden: true
  }
  {
    name: "email"
    validator: /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    warning: "Email is invalid"
  }
  {
    message: "Enter your password (will be hidden)"
    name: "password"
    hidden: true
  }
]

listEmoji = (cb) ->
  files = []

  # Walker options
  walker = walk.walk("./emoji_to_upload",
    followLinks: false
  )
  walker.on "file", (root, stat, next) ->

    # Add this file to the list of files
    if stat.name.endsWith(".png") or stat.name.endsWith(".gif")
      files.push path.resolve(root + "/" + stat.name)

    next()

  walker.on "end", ->
    cb(files)

prompt.start()
prompt.get properties, (err, result) ->
  if err
    console.log err
    return null

  listEmoji (files) ->

    binPath = "./node_modules/casperjs/bin/casperjs"
    childArgs = [
      "--engine=slimerjs"
      path.join(__dirname, "Scrape.coffee"),
      result.domain,
      result.email,
      result.password,
      files.join("...")
    ]

    #console.log "Running with args: ", childArgs

    childProcess.execFile binPath, childArgs, (err, stdout, stderr) ->
      console.log "Result:\n#{stdout}\nerror: #{err} #{stderr}"

  return null
