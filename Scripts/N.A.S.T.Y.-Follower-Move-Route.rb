#===============================================================================
# N.A.S.T.Y. Follower Move Route 
# Nelderson's Awesome Scripts To You
#
# By: Nelderson
# Last Updated: 3/21/2012
#
# Version 1.0 - 3/21/2012
#===============================================================================
# Update History:
# - Version 1.0 - Initial release, made for BulletPlus
#===============================================================================
# This script allows you to use the move custom route command that you
# can use for all your other events, just now includes Followers!
#
# -Usage
# When you select a new move route command in your event, make sure to 
# put this script call in the FIRST SLOT:
#
# force_move_followers(id)
# - Where id is the follower id of the player(Starts with 0)
# and anything after that will affect the follower instead of the event!
#===============================================================================
class Game_Interpreter
def command_205
$game_map.refresh if $game_map.need_refresh
temp = @params[1].list[0].parameters
if temp[0] =~ /force_move_followers[(](\d+)[)]/i
character = $game_player.followers[$1.to_i]
else
character = get_character(@params[0])
end
if character
character.force_move_route(@params[1])
Fiber.yield while character.move_route_forcing if @params[1].wait
end
end
end

class Game_Character < Game_CharacterBase
def force_move_followers(id = nil)
end
end
