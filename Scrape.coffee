system = require("system")
args = system.args
if args.length is 1
  console.log "Try to pass some arguments when invoking this script!"
else
  args.forEach (arg, i) ->
    console.log i + ": " + arg
    return

page = require("webpage").create()
page.viewportSize = { width:1024, height:768 }

onAuth = ->
  page.evaluate ->
    #  Load the admin page to later upload emoticons to
    window.location.href = "/admin/emoji"

page.open("http://slack.com/signin").then (status) ->

  phantom.exit()

  return
