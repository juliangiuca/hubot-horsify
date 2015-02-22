# Description:
#   Put a horse on it. Add a horses head to any picture.
#
# Commands:
#   hubot horsify me <url> - Adds a horse to the specified URL.
#   hubot horsify me <query> - Searches Google Images for the specified query and puts a horse on it.

module.exports = (robot) ->

  robot.respond /horsify me (.*)/i, (msg) ->
    horseface = "http://horsify.me/horsify?url="
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
        cb image.unescapedUrl
