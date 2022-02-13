#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
#                                                                              #
#      ########    ######          ######        ########    ##      ##        #
#    ##            ##    ##      ##      ##    ##            ##      ##        #
#    ##            ######        ##########      ######      ##########        #
#    ##            ##  ##        ##      ##            ##    ##      ##        #
#      ########    ##    ##      ##      ##    ########      ##      ##        #
#                                                                      V 1.2.0 #
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# SCRIPT NAME: CrashSteps                                                      #
#                                                               made by Crash  #
# Date Created: 16/June/2014            Last Update date: 20/June/2014         #
#                                                                              #
#==============================================================================#
#  REQUIREMENTS                                                                #
#------------------------------------------------------------------------------#
#     none                                                                     #
#==============================================================================#
#  KNOWN COMPATIBILITY ISSUES                                                  #
#------------------------------------------------------------------------------#
#     No known compatability issues                                            #
#             alias list..:                                                    #
#                 Game_Player :: initialize                                    #
#                             :: update                                        #
#                             :: passable                                      #
#==============================================================================#
#  INTRODUCTION                                                                #
#------------------------------------------------------------------------------#
#     This Script gives you the choice to:                                     #
#    -  plays a collision sound when your character collides with something    #
#    -  plays a sound when you are walking                                     #
#                                                                              #
#==============================================================================#
#  INSTRUCTIONS                                                                #
#------------------------------------------------------------------------------#
#     Edit the config section to determine which sound effect to play,         #
#       how loud to play it, the pitch, and the duration of time between       #
#       repetitions of the sound effect.                                       #
#                                                                              #
#     Please note, sound effects MUST be in the resource folder                #
#                                                                              #
#     More is explained in the config section itself. For help and support     #
#       see line 291                                                           #
#                                                                              #
#==============================================================================#
#  COMMANDS                                                                    #
#------------------------------------------------------------------------------#
#     In game you can use the following commands to control crashsteps         #
#         Crashsteps.on                = turns footsteps & collisions on       #
#         Crashsteps.off               = turns footsteps & collisions off      #
#         Crashsteps.toggle            = toggles footsteps & collisions on/off #
#         Crashsteps_Footsteps.on      = turns footsteps ON                    #
#         Crashsteps_Footsteps.off     = turns footsteps OFF                   #
#         Crashsteps_Footsteps.toggle  = toggles footsteps on/off              #
#         Crashsteps_Collision.on      = turns collisions sounds ON            #
#         Crashsteps_Collision.off     = turns collision sounds OFF            #
#         Crashsteps_Collision.toggle  = toggles collision sounds on/off       #
#                                                                              #
#==============================================================================#
#  UPDATE LOG                                                                  #
#------------------------------------------------------------------------------#
# Update |    date    | Description of update                                  #    
#  1.0.1 |18/Jun/2014 | added print on initialization for debugging purposes   #
#  1.1.0 |19/Jun/2014 | added ability to turn and toggle script on/off in-game #
#                          using script commands.                              #
#  1.2.0 |20/Jun/2014 | added changeable steps on terrain.                     #
#                                                                              #
#                                                                              #
# #  #   #    #     #      #       #        #       #      #     #    #   #  # #
 # ## # # #  # #   # #    # #     # #      # #     # #    # #   # #  # # # ## #
   #   #   ##   # #   #  #   #   #   #    #   #   #   #  #   # #   ##   #   #
           #     #     ##     # #     #  #     # #     ##     #     #
                       #       #       ##       #       #
 
                     
#***reminder:: Please only edit config section.
 
class Game_Player < Game_Character
 
#==============================================================================
#  CONFIG
#------------------------------------------------------------------------------
# Please edit these to suite your needs.
#==============================================================================
 
#                          SCRIPT BEHAVIOUR
 
Crashsteps_uses_region_id = true # should the script change sound effects
                                 #      based on what region you are walking in?
                                 
Play_Footsteps_SE = true         # should script play footsteps sound effect?  (can be changed in game)                              
Footsteps_Wait = 15              # number of frames to wait before repeating se
Play_Collision_SE = false         # should script play Collisions sound effect? (can be changed in game)
Collision_Wait = 15              # number of frames to wait before repeating se
Collision_SE = ["", 30, 100 ]
             # [ name       ,vol,pitch] of sound effect for collisions
             
             
#                WHEN CRASHSTEPS IS NOT USING REGION_ID
 
Footsteps_SE = ["" , 50, 100 ]
             # [ name       ,vol,pitch] of sound effect for footsteps
             
 
#                  WHEN CRASHSTEPS IS USING REGION_ID
 
Footsteps_Region_SE = [  #<< ignore this.. edit below.
 
# name        ,vol ,pitch] of sound effect for region::
[ ""     , 70 , 100 ],                            #default (no region)
[ "ice_steps"      , 100, 100 ],                            # 1
[ "grass_steps"    , 100, 100 ],                            # 2
[ "stone_steps"    , 100, 100 ],                            # 3
[ "0x144"          , 60, 100 ],                             # 4
[ "wood_steps"     , 100, 100 ],
[ "wood_steps"     , 100, 100 ],
[ "wood_steps"     , 100, 100 ],
[ "wood_steps"     , 100, 100 ],
[ "0x142"     , 1, 100 ], #orig volume 15
 
#to add more just copy and paste the following line changing footstep se name
#and deleting the # at the start..:
#["footstep se name", 50 , 100 ],                           # next region id.
#region IDs are numeric in ascending order (meaning the first entry will ALWAYS
#be the default, the second entry will ALWAYS be region 1, the third will ALWAYS
#be region 2, etc. this CANNOT change. [ "0x142"     , 15, 100 ],
 
#==============================================================================
#  Script
#------------------------------------------------------------------------------
# Do not edit anything below this comment.
#==============================================================================
[ nil ]]
  #----------------------------------------------------------------------------
  #  Initialize
  #----------------------------------------------------------------------------
   alias Crash_Crashsteps_gameplayer_initialize_crash                 initialize
  def initialize
    Crash_Crashsteps_gameplayer_initialize_crash()
 $crashsteps_footsteps  = Play_Footsteps_SE #changing to soft variable
 $crashsteps_collisions = Play_Collision_SE #changing to soft variable
  end
  #----------------------------------------------------------------------------
  #  Frame Update
  #----------------------------------------------------------------------------
  alias Crash_Collsound_gameplayer_update_crash                       update
  def update
    Crash_Collsound_gameplayer_update_crash()
    @cstimer = 0 unless @cstimer != nil
    @fstimer = 0 unless @fstimer != nil
    @cstimer -= 1 unless @cstimer == 0
    @fstimer -= 1 unless @fstimer == 0
  end
 
  #----------------------------------------------------------------------------
  # checks for passability and runs modules
  #----------------------------------------------------------------------------
  alias Crash_Collsound_gameplayer_passable_crash                    passable?
  def passable?( *args )
    passable = Crash_Collsound_gameplayer_passable_crash( *args )
#--------------------------------FOOTSTEPS--------------------------------------
    unless $crashsteps_footsteps == false
    if passable == true && @fstimer == 0
      if Crashsteps_uses_region_id == true
        unless Footsteps_Region_SE[$game_map.region_id(x, y)][0] == nil
      RPG::SE.new(*Footsteps_Region_SE[$game_map.region_id(x, y)]).play rescue
      @fstimer = Footsteps_Wait
    end
    else
      RPG::SE.new(*Footsteps_SE).play rescue print "invalid footsteps file name
"
    end
  end
end
#-------------------------------COLLISIONS--------------------------------------
    unless $crashsteps_collisions == false
    if passable == false && @cstimer == 0
      RPG::SE.new(*Collision_SE).play rescue
      @cstimer = Collision_Wait
    end
    end
    return passable
  end
end
#--------------------------------debug------------------------------------------
 print "Crashsteps Script Initialized...
"
#------------------------------------------------------------------------------#
#=====================IN GAME SCRIPT CALL COMMANDS=============================#
#------------------------------------------------------------------------------#
#====================================#
#==Crashsteps General================#
#====================================#
module Crashsteps                    #
  def self.off                       #
    $crashsteps_footsteps  = false   #
    $crashsteps_collisions = false   #
    print "collisions and foosteps turned off...
"                                    #
  end                                #
#------------------------------------#
  def self.on                        #
    $crashsteps_footsteps  = true    #
    $crashsteps_collisions = true    #
    print "collisions and footsteps turned on...
"                                    #
end                                  #
#------------------------------------#
  def self.toggle                    #
    if $crashsteps_footsteps = true  #
      $crashsteps_footsteps = false  #
    else                             #
      $crashsteps_footsteps = true   #
    end                              #
    if $crashsteps_collisions = true #
      $crashsteps_collisions = false #
    else                             #
      $crashsteps_collisions = true  #
    end                              #
  end                                #
end                                  #
#====================================#
#==FOOTSTEPS=========================#
#====================================#
module Crashsteps_footsteps          #
  def self.off                       #
    $crashsteps_footsteps = false    #
    print "footsteps turned off...      
"                                   #
  end                                #
#------------------------------------#
  def self.on                        #
    $crashsteps_footsteps = true     #
    print "footsteps turned on...
"                                    #
    end                              #
#------------------------------------#
  def self.toggle                    #
    if $crashsteps_footsteps = true  #
      $crashsteps_footsteps = false  #
      print "footsteps toggled off...  
"                                    #
    else                             #
      $crashsteps_footsteps = true   #
      print "footsteps toggled on...    
"                                    #
    end                              #
  end                                #
end                                  #
#====================================#
#==COLLISIONS========================#
#====================================#
module Crashsteps_collisions         #
  def self.off                       #
    $crashsteps_collisions = false   #
    print "collisions turned off...  
"                                    #
  end                                #
#------------------------------------#
  def self.on                        #
    $crashsteps_collisions = true    #
    print "collisions turned on...  
"                                    #
end                                  #
#------------------------------------#
  def self.toggle                    #
    if $crashsteps_collisions =true  #
      $crashsteps_collisions = false #
      print "collisions toggled off...
"                                    #
    else                             #
      $crashsteps_collisions = true  #
      print "collisions toggled on...
"                                    #
    end                              #
  end                                #
end                                  #
#====================================#
#===============================================================================
#  END OF SCRIPT
#===============================================================================
#  Potential List of future updates
# v 1.1.0 = Add ability to turn footsteps on or off via script call. **DONE**
# v 1.1.1 = Bug Fixes (if any)
# v 1.2.0 = Terrain Tagging  **DONE**
# v 1.2.1 = Bug Fixes (if any)
#===============================================================================
# If you were charged for this script you were scammed. Please contact me
#   immmediately.
#===============================================================================
# For help and support comment on the forum you found this script, OR,
#   email me using my email.
#===============================================================================
# My email: crashes2ashes@gmail.com   ::use it wisely.
#===============================================================================
#  LARGELY influenced by DiamondandPlatinum 3's script/tutorial
#     If you're interested in scripting, please be sure to check out his channel
#     at https://www.youtube.com/channel/UCz_JkwtwpQaKAiJiIRakDLw
#===============================================================================
