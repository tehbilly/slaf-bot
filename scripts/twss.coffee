# Description
#   Pretty advanced "TWSS" guesser!
#
# Commands:
#   None
#
# Configuration:
#   HUBOT_TWSS_PROB (optional)
#      if twss.prob evaluates to a probability above this, it will
#      respond with 'twss'.  Defaults to 0.98
#   HUBOT_TWSS_CHANCE (optional)
#      Float chance that phrase will be sent at all. Defaults
#      to 0.6 (60% of the time)
#
# Author:
#   https://github.com/aaronstaves/
twss = require 'twss'
twssChance = process.env.HUBOT_TWSS_CHANCE or 0.6

module.exports = (robot) ->
    robot.hear /(.*)/i, (msg) ->
        if Math.random() > twssChance
            return

        string = msg.match[0]
        prob = process.env.HUBOT_TWSS_PROB or 0.98

        if (twss.prob string) >= prob
            msg.send "That's what she said."

