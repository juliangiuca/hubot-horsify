# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   hubot mustache me <url> - Adds a mustache to the specified URL.
#   hubot mustache me <query> - Searches Google Images for the specified query and mustaches it.

module.exports = (robot) ->

  robot.respond /horsify me (.*)/i, (msg) ->
    horseface = "http://horseface.me/horsify?url="
    imagery = msg.match[1]

    if imagery.match /^https?:\/\//i
      encodedUrl = encodeURIComponent imagery
      msg.send "#{horseface}#{encodedUrl}"
    else
      imageMe msg, imagery, (url) ->
        encodedUrl = encodeURIComponent url
        msg.send "#{horseface}#{encodedUrl}"

imageMe = (msg, query, cb) ->
  q = v: '1.0', rsz: '8', q: query, safe: 'active', imgtype: 'face'
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image = msg.random images
        cb ensureImageExtension image.unescapedUrl

ensureImageExtension = (url) ->
  ext = url.split('.').pop()
  if /(png|jpe?g|gif)/i.test(ext)
    url
  else
    "#{url}#.png"
