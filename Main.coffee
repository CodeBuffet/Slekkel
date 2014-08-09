page = require("webpage").create()
page.viewportSize = { width:1024, height:768 }

onAuth = ->
  page.evaluate ->
    #  Load the admin page to later upload emoticons to
    window.location.href = "/admin/emoji"

page.open("http://slack.com/signin").then (status) ->

  alert "Please sign in with your Slack Account to continue import process"

  (->
    timer = null
    checkAuth = ->

      if window.location.href.indexOf("/messages") != -1
        # Authenticated
        onAuth()
        clearInterval timer

      return null

    timer = setInterval checkAuth, 100
  )()

  return
