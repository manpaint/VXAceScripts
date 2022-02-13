#==============================================================================
# ** Lemony's Zelda Camera (LZC), (March 2013), v.2.0
#==============================================================================
#  This scripts allows to move the camera when the player reaches the screen
# borders.
#==============================================================================
# (*) How to Use.-
#==============================================================================
#  * You can actiave and deactivate the system at will by setting ON or OFF
# the switch with the ID dessigned at LZC_SWITCH variable below.
# The system will be ON when the switch is OFF, and OFF when the switch is ON.
#------------------------------------------------------------------------------
#  * You can define the scroll speed for the camera movement by editing 
# LZC_SSPEED variable below. Default speed is 6.
#==============================================================================
# (**) Terms of Use.-
#==============================================================================
# This script is free to use in any commercial or non commercial game or 
# project created with any RPG Maker with a valid license as long as explicit
# credits are given to the author (Lemony).
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Switch ID.                                                        [OPT]
  #--------------------------------------------------------------------------
  LZC_SWITCH = 224
  #--------------------------------------------------------------------------
  # * Scroll Speed.                                                     [OPT]
  #--------------------------------------------------------------------------
  LZC_SSPEED = 6
  #--------------------------------------------------------------------------
  # * Scroll Processing.                                                [MOD]
  #--------------------------------------------------------------------------
  alias lzc_update_scroll update_scroll
  def update_scroll(*args)
    if !$game_switches[LZC_SWITCH]
     xx = (@x * ($game_map.width  / $game_map.screen_tile_x)) / $game_map.width
     yy = (@y * ($game_map.height / $game_map.screen_tile_y)) / $game_map.height
     @lzc_old_cell ||= [xx, yy]
     if @lzc_old_cell != [xx, yy]
       x, y = @lzc_old_cell
       tx, ty = xx * $game_map.screen_tile_x, yy * $game_map.screen_tile_y
       $game_map.start_scroll(4, $game_map.display_x - tx, LZC_SSPEED) if x > xx
       $game_map.start_scroll(6, tx - $game_map.display_x, LZC_SSPEED) if x < xx
       $game_map.start_scroll(8, $game_map.display_y - ty, LZC_SSPEED) if y > yy
       $game_map.start_scroll(2, ty - $game_map.display_y, LZC_SSPEED) if y < yy
       @lzc_old_cell = [xx, yy]
     end
    else
      lzc_update_scroll(*args)
    end
  end
end
