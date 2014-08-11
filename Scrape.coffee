casper = require("casper").create(
  viewportSize: { width: 1024, height: 768 }
)
args = casper.cli.args
#require("utils").dump(casper.cli.args);

email = password = null

if args.length < 2
  console.log "Try to pass some arguments when invoking this script!"
  casper.exit()
else
  email = args[0]
  password = args[1]

casper.start "http://slack.com/signin", ->


  @fill "form[action=\"/signin\"]",
    email: email
  , true

  return

casper.then ->
  @fill "form[action=\"/\"]",
    password: password
  , true

casper.then ->
  @evaluate ->
    #  Load the admin page to later upload emoticons to
    window.location.href = "/admin/emoji"

casper.run ->
