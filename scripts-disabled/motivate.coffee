# Description:
#   Allows Hubot to lift someone's spirits
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot motivate <name> - give <name> something inspirational
#
# Author:
#   William Mcgann <contact@WilliamMcGann.com>

module.exports = (robot) ->
  robot.respond /motivate (.*)/i, (msg) ->
    name = msg.match[1].trim()
    robot.http("http://pleasemotivate.me/api")
        .get() (err, res, body) ->
            data = JSON.parse(body)
            msg.send "#{name}: #{data.motivation}"

