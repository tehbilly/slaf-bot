# Description:
#   Steam group members/status.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_STEAM_GROUP = Group id to fetch members from
#   HUBOT_STEAM_TOKEN = Steam api token
#
# Commands:
#   hubot who's gaming - Provide a list of group members that are gaming
#
# Author:
#   William McGann <contact@WilliamMcGann.com>

# Variables
steamKey = process.env.HUBOT_STEAM_TOKEN
groupName = process.env.HUBOT_STEAM_GROUP
allGood = true

# No HUBOT_STEAM_TOKEN?
unless steamKey?
    console.log "Missing HUBOT_STEAM_TOKEN. Please set this and try again."
    allGood = false

# No HUBOT_STEAM_GROUP?
unless groupName?
    console.log "Missing HUBOT_STEAM_GROUP. Please set this and try again."
    allGood = false


module.exports = (robot) -> unless !allGood
    {parseString} = require 'xml2js'
    groupMembers = ''

    # Load group member list
    robot.http("http://steamcommunity.com/groups/#{groupName}/memberslistxml/")
        .get() (err, resp, body) ->
            parseString body, {trim: true}, (e, j) ->
                groupMembers = j.memberList.members[0].steamID64.join ','
                console.log "Loaded steam group members: #{groupMembers}"

    robot.respond "/(who's|who is|steam) gaming/i", (msg) ->
        if groupMembers == ''
            msg.reply "Sorry, member list for #{groupName} hasn't finished loading..."
        else
            req = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{steamKey}&steamids=#{groupMembers}"
            console.log req
            robot.http(req).get() (err, resp, body) ->
                if err
                    msg.reply "Eh, there was an error loading the list: #{err}"
                else
                    data = JSON.parse(body)
                    nowGaming = []
                    for player in data.response.players when player.gameextrainfo?
                        do (player) ->
                            nowGaming.push "#{player.personaname} is playing: #{player.gameextrainfo}"

                    if nowGaming.length > 0
                        msg.send nowGaming.join "\n"
                    else
                        msg.reply "Nobody's gaming right now. :("
