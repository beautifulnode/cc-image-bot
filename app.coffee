http = require 'http'
request = require 'request'
sugar = require 'sugar'

app = http.createServer (req, resp) ->
  resp.writeHead 200, 'content-type': 'text/plain'
  resp.end "Image Bot Up and Running!!!!\n"

app.listen process.env.VCAP_APP_PORT || 3000, -> console.log 'listening'

postResponse = (msg) ->
  image_request = msg.body.split(' ')[1]
  msg.author = 'image-bot'
  msg.body = "<img src='http://#{image_request}.jpg.to' />"
  request.post
    uri: 'http://catchat.wilbur.io/messages'
    json: msg
    
checkMessages = ->
  # future look for messages for me -> endpoint = 'http://catchat.wilbur.io/messages/image'
  endpoint = 'http://catchat.wilbur.io/messages'
  startkey = "?startkey=" + (10).secondBefore('now').iso()
  console.log "checking messages"
  request.get
    uri: endpoint + startkey
    json: true
    (err, resp, body) ->
      postResponse(msg) for msg in body when msg.body.match /^@image-bot/

setInterval checkMessages, 10000

