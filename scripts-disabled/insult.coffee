# Description:
#   Allows Hubot to lambast someone with a random insult
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot insult <name> - give <name> the what-for
#
# Author:
#   William Mcgann <contact@WilliamMcGann.com>

module.exports = (robot) ->
  robot.respond /insult (.*)/i, (msg) ->
    name = msg.match[1].trim()
    robot.http("http://pleaseinsult.me/api?severity=extreme")
        .get() (err, res, body) ->
            data = JSON.parse(body)
            msg.send "#{name}: #{data.insult}"

