page = require("webpage").create()
page.viewportSize = { width:1024, height:768 }
page.open("http://slack.com/signin").then (status) ->

  alert "Please sign in with your Slack Account to continue import process"

  return
