casper = require("casper").create(
  viewportSize: { width: 1024, height: 768 }
)
args = casper.cli.args
#require("utils").dump(casper.cli.args);

email = password = team = null
files = []

if args.length < 3
  console.log "Try to pass some arguments when invoking this script!"
  casper.exit()
else
  email = args[0]
  password = args[1]
  team = args[2]
  files = args[3].split("...")

casper.start "http://#{team}.slack.com/signin", ->

  @fill "form[action=\"/\"]",
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

casper.then ->
  @evaluate ->
    TS.web.toggleSection 'add_emoji_section'

getEmojiName = (a) ->
  a = a.replace(/^.*[\\\/]/, '')
  output = a.substr(0, a.lastIndexOf(".")) or a
  return output

for file in files
  ((f) ->
      casper.then ->
        @fill "form[action=\"/customize/emoji\"]",
          img: f
          name: getEmojiName f
        , true

  )(file)

casper.run ->
  casper.exit()
