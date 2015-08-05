casper = require("casper").create(
  viewportSize: { width: 1024, height: 768 }
)
args = casper.cli.args
#require("utils").dump(casper.cli.args);

email = password = null
files = []

if args.length < 3
  console.log "Try to pass some arguments when invoking this script!"
  casper.exit()
else
  domain = args[0]
  email = args[1]
  password = args[2]
  files = args[3].split("...")

casper.start "https://slack.com/signin", ->

  @fill "form[action=\"/signin\"]",
    domain: domain
  , true

  return

casper.then ->
  @evaluate ->
    #  Submit the form (Google account not supported)
    document.getElementsByTagName("form")[0].submit()

casper.then ->
  @fill "form[id=\"signin_form\"]",
    email: email
    password: password
  , true

  return

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
