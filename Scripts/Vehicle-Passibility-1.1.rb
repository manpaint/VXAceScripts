################################################################################
# CaitSith2's Vehicle Passibility 1.1
################################################################################
# Version History
#   1.0 - Initial Release
#   1.1 - Added options for controlling vehicle music per map/event.
################################################################################
# Do you wish you could redefine one of your boats/ships as a land vehicle
# that can possibly go over some areas that you can't walk on directly.
# Example, hovercraft over land / shallow oceans,
#
# Also, do you wish you could make your airship not able to pass over certain
# terrains.  Example being, that the airship can't withstand the heat of magma
# and would burn up.
#
# Also, would you like to do hidden passage ways, or invisible wall mazes,
# without needing to create duplicate tiles with altered passability settings.
# (another downside to the duplicate tiles method, is that you can't easily 
# tell where your hidden passages are on the map editor.)
#
# Do you also wish you could assign vehicle music per map. That is now an option.
################################################################################

$imported = {} if $imported.nil?
$imported["CaitSith2_Vehicle_Passibility"] = true

module CS2
  module VP
################################################################################
# INSTRUCTIONS
################################################################################
#Define these veriables like so. You can have multiple regions/terrains
#seperated by commas.  Put a -1 as a value in the *_DENY_* fields, if you
#wish to disallow walking/driving/landing/docking in regions not specified in
#*_ALLOW_* fields.
#
# Example with Walking
# WALK_ALLOW_REGION = [1] #Areas of map painted with these regions are
#                             #passable no matter what.
#
# WALK_DENY_REGION = [-1]  #Areas of map painted with these regions are
#                             #impassable no matter what.
#
# WALK_ALLOW_TERRAIN = [1]    #These Terrain tags are passable, even if marked
#                             #as impassable in the database, unless painted
#                             #over with _DENY_REGION
#
# WALK_DENY_TERRAIN = [-1]     #These terrain tags are impassable, even if
#                             #marked in the database otherwise.
#
# These can also be defined in the map note tags as follows, again with
# walking as the example.  Specify a -1 inside of deny to deny everything
# not allowed by allow. Specify -2 to clear the hard-coded defaults for
# the map.
#
# <walk allow region: 1,3,4>  #Single line comma seperated values
# <walk allow region: 1>      #or you can define multiple lines.
# <walk allow region: 3>
# <walk allow region: 4>
#
# <walk deny region: 2,5,6>
# <walk allow terrain: 5>
# <walk deny terrain: 6>
#
# All of the map note tag terms
#   <boat allow region: 0>
#   <boat deny region: 0>
#   <boat allow terrain: 0>
#   <boat deny terrain: 0>
#
#   <boat land allow region: 0>
#   <boat land deny region: 0>
#   <boat land allow terrain: 0>
#   <boat land deny terrain: 0>
#
#   <ship allow region: 0>
#   <ship deny region: 0>
#   <ship allow terrain: 0>
#   <ship deny terrain: 0>
#
#   <ship land allow region: 0>
#   <ship land deny region: 0>
#   <ship land allow terrain: 0>
#   <ship land deny terrain: 0>
#
#   <airship allow region: 0>
#   <airship deny region: 0>
#   <airship allow terrain: 0>
#   <airship deny terrain: 0>
#
#   <airship land allow region: 0>
#   <airship land deny region: 0>
#   <airship land allow terrain: 0>
#   <airship land deny terrain: 0>
#
#   <walk allow region: 0>
#   <walk deny region: 0>
#   <walk allow terrain: 0>
#   <walk deny terrain: 0>
#
#   The final method of control of these possible, happens with the script
#   function of events.  This could allow for events to open a hidden passage.
#
#   example given, again, with walking.
#   $game_map.walk_allow_region.clear   #clear the array
#   $game_map.walk_allow_region.push(3) #add a value to end of array
#
#   These are the names for use inside of script functions within events.
#   $game_map.boat_allow_region
#   $game_map.boat_deny_region
#   $game_map.boat_allow_terrain
#   $game_map.boat_deny_terrain
#
#   $game_map.boat_land_allow_region
#   $game_map.boat_land_deny_region
#   $game_map.boat_land_allow_terrain
#   $game_map.boat_land_deny_terrain
#
#   $game_map.ship_allow_region
#   $game_map.ship_deny_region
#   $game_map.ship_allow_terrain
#   $game_map.ship_deny_terrain
#
#   $game_map.ship_land_allow_region
#   $game_map.ship_land_deny_region
#   $game_map.ship_land_allow_terrain
#   $game_map.ship_land_deny_terrain
#
#   $game_map.airship_allow_region
#   $game_map.airship_deny_region
#   $game_map.airship_allow_terrain
#   $game_map.airship_deny_terrain
#
#   $game_map.airship_land_allow_region
#   $game_map.airship_land_deny_region
#   $game_map.airship_land_allow_terrain
#   $game_map.airship_land_deny_terrain
#
#   $game_map.walk_allow_region
#   $game_map.walk_deny_region
#   $game_map.walk_allow_terrain
#   $game_map.walk_deny_terrain
#   
#
#   And when you wish to reset things back to map defaults from inside of
#   event scripts, call $game_map.reset_passibility
#
# Control of the vehicle music is done either with these note-tags
#   <boat music: song>
#   <boat music vol: 100>
#   <boat music pitch: 100>
#
#   <ship music: song>
#   <ship music vol: 100>
#   <ship music pitch: 100>
#
#   <airship music: song>
#   <airship music vol: 100>
#   <airship music pitch: 100>
#
# Or with these script functions.
#   $game_map.boat_music = "song"
#   $game_map.boat_music_vol = 100
#   $game_map.boat_music_pitch = 100
#
#   $game_map.ship_music = "song"
#   $game_map.ship_music_vol = 100
#   $game_map.ship_music_pitch = 100
#
#   $game_map.airship_music = "song"
#   $game_map.airship_music_vol = 100
#   $game_map.airship_music_pitch = 100
#
#
################################################################################
# SETUP
################################################################################
  
  #These Default values will remain hard-coded throughout the game, unless
  #specifically overridden on the note tag.  Since allow takes precedence over
  #deny, you can override a deny here by specifying an allow in the note tag.
  
  #alternatively, if you have to deny an allowed value here, then you gotta
  #specify -2 in the specific note tag to clear all the allowed values for that 
  #map, then reload the desired allowed values.
  
  BOAT_ALLOW_REGION = [1]
  BOAT_DENY_REGION = [-1]
  BOAT_ALLOW_TERRAIN = [1]
  BOAT_DENY_TERRAIN = [-1]
  
  BOAT_LAND_ALLOW_REGION =  [1]
  BOAT_LAND_DENY_REGION = [-1]
  BOAT_LAND_ALLOW_TERRAIN = [1]
  BOAT_LAND_DENY_TERRAIN = [-1]
  
  SHIP_ALLOW_REGION = [1]
  SHIP_DENY_REGION = [-1]
  SHIP_ALLOW_TERRAIN = [1]
  SHIP_DENY_TERRAIN = [-1]
  
  SHIP_LAND_ALLOW_REGION = [1]
  SHIP_LAND_DENY_REGION = [-1]
  SHIP_LAND_ALLOW_TERRAIN = [1]
  SHIP_LAND_DENY_TERRAIN = [-1]
  
  AIRSHIP_ALLOW_REGION = []
  AIRSHIP_DENY_REGION = []
  AIRSHIP_ALLOW_TERRAIN = []
  AIRSHIP_DENY_TERRAIN = []
  
  AIRSHIP_LAND_ALLOW_REGION = []
  AIRSHIP_LAND_DENY_REGION = []
  AIRSHIP_LAND_ALLOW_TERRAIN = []
  AIRSHIP_LAND_DENY_TERRAIN = []
  
  WALK_ALLOW_REGION = []
  WALK_DENY_REGION = []
  WALK_ALLOW_TERRAIN = []
  WALK_DENY_TERRAIN = []
  
################################################################################
# End of Setup.  Edit below this point at your own risk.
################################################################################
  end
end

module CS2
  module VP
    module REGEXP
      module MAP
        BOAT_ALLOW_REGION =
          /<(?:BOAT_ALLOW_REGION|boat allow region):/i
        BOAT_DENY_REGION = 
          /<(?:BOAT_DENY_REGION|boat deny region):/i
        BOAT_ALLOW_TERRAIN = 
          /<(?:BOAT_ALLOW_TERRAIN|boat allow terrain):/i
        BOAT_DENY_TERRAIN = 
          /<(?:BOAT_DENY_TERRAIN|boat deny terrain):/i
          
        BOAT_LAND_ALLOW_REGION =
          /<(?:BOAT_LAND_ALLOW_REGION|boat land allow region):/i
        BOAT_LAND_DENY_REGION = 
          /<(?:BOAT_LAND_DENY_REGION|boat land deny region):/i
        BOAT_LAND_ALLOW_TERRAIN = 
          /<(?:BOAT_LAND_ALLOW_TERRAIN|boat land allow terrain):/i
        BOAT_LAND_DENY_TERRAIN = 
          /<(?:BOAT_LAND_DENY_TERRAIN|boat land deny terrain):/i
          
        SHIP_ALLOW_REGION =
          /<(?:SHIP_ALLOW_REGION|ship allow region):/i
        SHIP_DENY_REGION = 
          /<(?:SHIP_DENY_REGION|ship deny region):/i
        SHIP_ALLOW_TERRAIN = 
          /<(?:SHIP_ALLOW_TERRAIN|ship allow terrain):/i
        SHIP_DENY_TERRAIN = 
          /<(?:SHIP_DENY_TERRAIN|ship deny terrain):/i
          
        SHIP_LAND_ALLOW_REGION =
          /<(?:SHIP_LAND_ALLOW_REGION|ship land allow region):/i
        SHIP_LAND_DENY_REGION = 
          /<(?:SHIP_LAND_DENY_REGION|ship land deny region):/i
        SHIP_LAND_ALLOW_TERRAIN = 
          /<(?:SHIP_LAND_ALLOW_TERRAIN|ship land allow terrain):/i
        SHIP_LAND_DENY_TERRAIN = 
          /<(?:SHIP_LAND_DENY_TERRAIN|ship land deny terrain):/i
          
        AIRSHIP_ALLOW_REGION =
          /<(?:AIRSHIP_ALLOW_REGION|airship allow region):/i
        AIRSHIP_DENY_REGION = 
          /<(?:AIRSHIP_DENY_REGION|airship deny region):/i
        AIRSHIP_ALLOW_TERRAIN = 
          /<(?:AIRSHIP_ALLOW_TERRAIN|airship allow terrain):/i
        AIRSHIP_DENY_TERRAIN = 
          /<(?:AIRSHIP_DENY_TERRAIN|airship deny terrain):/i
          
        AIRSHIP_LAND_ALLOW_REGION =
          /<(?:AIRSHIP_LAND_ALLOW_REGION|airship land allow region):/i
        AIRSHIP_LAND_DENY_REGION = 
          /<(?:AIRSHIP_LAND_DENY_REGION|airship land deny region):/i
        AIRSHIP_LAND_ALLOW_TERRAIN = 
          /<(?:AIRSHIP_LAND_ALLOW_TERRAIN|airship land allow terrain):/i
        AIRSHIP_LAND_DENY_TERRAIN = 
          /<(?:AIRSHIP_LAND_DENY_TERRAIN|airship land deny terrain):/i
          
        WALK_ALLOW_REGION =
          /<(?:WALK_ALLOW_REGION|walk allow region):/i
        WALK_DENY_REGION = 
          /<(?:WALK_DENY_REGION|walk deny region):/i
        WALK_ALLOW_TERRAIN = 
          /<(?:WALK_ALLOW_TERRAIN|walk allow terrain):/i
        WALK_DENY_TERRAIN = 
          /<(?:WALK_DENY_TERRAIN|walk deny terrain):/i
        
        BOAT_MUSIC = 
          /<(?:BOAT_MUSIC|boat music):/i
        BOAT_MUSIC_VOL = 
          /<(?:BOAT_MUSIC_VOL|boat music vol):/i
        BOAT_MUSIC_PITCH = 
          /<(?:BOAT_MUSIC_PITCH|boat music pitch):/i
        
        SHIP_MUSIC = 
          /<(?:SHIP_MUSIC|ship music):/i
        SHIP_MUSIC_VOL = 
          /<(?:SHIP_MUSIC_VOL|ship music vol):/i
        SHIP_MUSIC_PITCH = 
          /<(?:SHIP_MUSIC_PITCH|ship music pitch):/i
        
        AIRSHIP_MUSIC = 
          /<(?:AIRSHIP_MUSIC|airship music):/i
        AIRSHIP_MUSIC_VOL = 
          /<(?:AIRSHIP_MUSIC_VOL|airship music vol):/i
        AIRSHIP_MUSIC_PITCH = 
          /<(?:AIRSHIP_MUSIC_PITCH|airship music pitch):/i
      end
    end
  end
end

class RPG::Map

  attr_accessor :boat_allow_region
  attr_accessor :boat_deny_region
  attr_accessor :boat_allow_terrain
  attr_accessor :boat_deny_terrain
  
  attr_accessor :boat_land_allow_region
  attr_accessor :boat_land_deny_region
  attr_accessor :boat_land_allow_terrain
  attr_accessor :boat_land_deny_terrain
  
  attr_accessor :ship_allow_region
  attr_accessor :ship_deny_region
  attr_accessor :ship_allow_terrain
  attr_accessor :ship_deny_terrain
  
  attr_accessor :ship_land_allow_region
  attr_accessor :ship_land_deny_region
  attr_accessor :ship_land_allow_terrain
  attr_accessor :ship_land_deny_terrain
  
  attr_accessor :airship_allow_region
  attr_accessor :airship_deny_region
  attr_accessor :airship_allow_terrain
  attr_accessor :airship_deny_terrain
  
  attr_accessor :airship_land_allow_region
  attr_accessor :airship_land_deny_region
  attr_accessor :airship_land_allow_terrain
  attr_accessor :airship_land_deny_terrain
  
  attr_accessor :walk_allow_region
  attr_accessor :walk_deny_region
  attr_accessor :walk_allow_terrain
  attr_accessor :walk_deny_terrain
  
  attr_accessor :boat_music
  attr_accessor :boat_music_vol
  attr_accessor :boat_music_pitch
  
  attr_accessor :ship_music
  attr_accessor :ship_music_vol
  attr_accessor :ship_music_pitch
  
  attr_accessor :airship_music
  attr_accessor :airship_music_vol
  attr_accessor :airship_music_pitch
  
  
  def load_notetags_vp
    @boat_allow_region = CS2::VP::BOAT_ALLOW_REGION.clone
    @boat_deny_region = CS2::VP::BOAT_DENY_REGION.clone
    @boat_allow_terrain = CS2::VP::BOAT_ALLOW_TERRAIN.clone
    @boat_deny_terrain = CS2::VP::BOAT_DENY_TERRAIN.clone
    
    @boat_land_allow_region = CS2::VP::BOAT_LAND_ALLOW_REGION.clone
    @boat_land_deny_region = CS2::VP::BOAT_LAND_DENY_REGION.clone
    @boat_land_allow_terrain = CS2::VP::BOAT_LAND_ALLOW_TERRAIN.clone
    @boat_land_deny_terrain = CS2::VP::BOAT_LAND_DENY_TERRAIN.clone
    
    @ship_allow_region = CS2::VP::SHIP_ALLOW_REGION.clone
    @ship_deny_region = CS2::VP::SHIP_DENY_REGION.clone
    @ship_allow_terrain = CS2::VP::SHIP_ALLOW_TERRAIN.clone
    @ship_deny_terrain = CS2::VP::SHIP_DENY_TERRAIN.clone
    
    @ship_land_allow_region = CS2::VP::SHIP_LAND_ALLOW_REGION.clone
    @ship_land_deny_region = CS2::VP::SHIP_LAND_DENY_REGION.clone
    @ship_land_allow_terrain = CS2::VP::SHIP_LAND_ALLOW_TERRAIN.clone
    @ship_land_deny_terrain = CS2::VP::SHIP_LAND_DENY_TERRAIN.clone
    
    @airship_allow_region = CS2::VP::AIRSHIP_ALLOW_REGION.clone
    @airship_deny_region = CS2::VP::AIRSHIP_DENY_REGION.clone
    @airship_allow_terrain = CS2::VP::AIRSHIP_ALLOW_TERRAIN.clone
    @airship_deny_terrain = CS2::VP::AIRSHIP_DENY_TERRAIN.clone
    
    @airship_land_allow_region = CS2::VP::AIRSHIP_LAND_ALLOW_REGION.clone
    @airship_land_deny_region = CS2::VP::AIRSHIP_LAND_DENY_REGION.clone
    @airship_land_allow_terrain = CS2::VP::AIRSHIP_LAND_ALLOW_TERRAIN.clone
    @airship_land_deny_terrain = CS2::VP::AIRSHIP_LAND_DENY_TERRAIN.clone
    
    @walk_allow_region = CS2::VP::WALK_ALLOW_REGION.clone
    @walk_deny_region = CS2::VP::WALK_DENY_REGION.clone
    @walk_allow_terrain = CS2::VP::WALK_ALLOW_TERRAIN.clone
    @walk_deny_terrain = CS2::VP::WALK_DENY_TERRAIN.clone
    
    @boat_music = nil
    @ship_music = nil
    @airship_music = nil
    
    @boat_music_vol = 100
    @ship_music_vol = 100
    @airship_music_vol = 100
    
    @boat_music_pitch = 100
    @ship_music_pitch = 100
    @airship_music_pitch = 100
    
    
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when /<[A-Za-z0-9_ ]+:[ ]*((-)?\d+(?:\s*,\s*(-)?\d+)*)>/i
        p line
        $1.scan(/[-]?\d+/).each { |num| 
          case line
          when CS2::VP::REGEXP::MAP::BOAT_ALLOW_REGION
            @boat_allow_region.push(num.to_i) if num.to_i >= 0
            @boat_allow_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::BOAT_DENY_REGION
            @boat_deny_region.push(num.to_i) if num.to_i >= -1
            @boat_deny_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::BOAT_ALLOW_TERRAIN
            @boat_allow_terrain.push(num.to_i) if num.to_i >= 0
            @boat_allow_terrain.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::BOAT_DENY_TERRAIN
            @boat_deny_terrain.push(num.to_i) if num.to_i >= -1 
            @boat_deny_terrain.clear if num.to_i == -2
          
          when CS2::VP::REGEXP::MAP::BOAT_LAND_ALLOW_REGION
            @boat_land_allow_region.push(num.to_i) if num.to_i >= 0
            @boat_land_allow_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::BOAT_LAND_DENY_REGION
            @boat_land_deny_region.push(num.to_i) if num.to_i >= -1 
            @boat_land_deny_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::BOAT_LAND_ALLOW_TERRAIN
            @boat_land_allow_terrain.push(num.to_i) if num.to_i >= 0
            @boat_land_allow_terrain.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::BOAT_LAND_DENY_TERRAIN
            @boat_land_deny_terrain.push(num.to_i) if num.to_i >= -1 
            @boat_land_deny_terrain.clear if num.to_i == -2
          
          when CS2::VP::REGEXP::MAP::SHIP_ALLOW_REGION
            @ship_allow_region.push(num.to_i) if num.to_i >= 0
            @ship_allow_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::SHIP_DENY_REGION
            @ship_deny_region.push(num.to_i) if num.to_i >= -1 
            @ship_deny_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::SHIP_ALLOW_TERRAIN
            @ship_allow_terrain.push(num.to_i) if num.to_i >= 0
            @ship_allow_terrain.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::SHIP_DENY_TERRAIN
            @ship_deny_terrain.push(num.to_i) if num.to_i >= -1 
            @ship_deny_terrain.clear if num.to_i == -2
          
          when CS2::VP::REGEXP::MAP::SHIP_LAND_ALLOW_REGION
            @ship_land_allow_region.push(num.to_i) if num.to_i >= 0
            @ship_land_allow_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::SHIP_LAND_DENY_REGION
            @ship_land_deny_region.push(num.to_i) if num.to_i >= -1 
            @ship_land_deny_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::SHIP_LAND_ALLOW_TERRAIN
            @ship_land_allow_terrain.push(num.to_i) if num.to_i >= 0
            @ship_land_allow_terrain.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::SHIP_LAND_DENY_TERRAIN
            @ship_land_deny_terrain.push(num.to_i) if num.to_i >= -1
            @ship_land_deny_terrain.clear if num.to_i == -2
          
          when CS2::VP::REGEXP::MAP::AIRSHIP_ALLOW_REGION
            @airship_allow_region.push(num.to_i) if num.to_i >= 0
            @airship_allow_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::AIRSHIP_DENY_REGION
            @airship_deny_region.push(num.to_i) if num.to_i >= -1 
            @airship_deny_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::AIRSHIP_ALLOW_TERRAIN
            @airship_allow_terrain.push(num.to_i) if num.to_i >= 0
            @airship_allow_terrain.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::AIRSHIP_DENY_TERRAIN
            @airship_deny_terrain.push(num.to_i) if num.to_i >= -1 
            @airship_deny_terrain.clear if num.to_i == -2
          
          when CS2::VP::REGEXP::MAP::AIRSHIP_LAND_ALLOW_REGION
            @airship_land_allow_region.push(num.to_i) if num.to_i >= 0
            @airship_land_allow_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::AIRSHIP_LAND_DENY_REGION
            @airship_land_deny_region.push(num.to_i) if num.to_i >= -1 
            @airship_land_deny_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::AIRSHIP_LAND_ALLOW_TERRAIN
            @airship_land_allow_terrain.push(num.to_i) if num.to_i >= 0
            @airship_land_allow_terrain.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::AIRSHIP_LAND_DENY_TERRAIN
            @airship_land_deny_terrain.push(num.to_i) if num.to_i >= -1 
            @airship_land_deny_terrain.clear if num.to_i == -2
          
          when CS2::VP::REGEXP::MAP::WALK_ALLOW_REGION
            @walk_allow_region.push(num.to_i) if num.to_i >= 0
            @walk_allow_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::WALK_DENY_REGION
            @walk_deny_region.push(num.to_i) if num.to_i >= -1 
            @walk_deny_region.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::WALK_ALLOW_TERRAIN
            @walk_allow_terrain.push(num.to_i) if num.to_i >= 0
            @walk_allow_terrain.clear if num.to_i == -2
          when CS2::VP::REGEXP::MAP::WALK_DENY_TERRAIN
            @walk_deny_terrain.push(num.to_i) if num.to_i >= -1 
            @walk_deny_terrain.clear if num.to_i == -2
            
          when CS2::VP::REGEXP::MAP::BOAT_MUSIC_VOL
            @boat_music_vol = num.to_i if num.to_i >= 0 && num.to_i <= 100
          when CS2::VP::REGEXP::MAP::BOAT_MUSIC_PITCH
            @boat_music_pitch = num.to_i if num.to_i >= 50 && num.to_i <= 150
            
          when CS2::VP::REGEXP::MAP::SHIP_MUSIC_VOL
            @ship_music_vol = num.to_i if num.to_i >= 0 && num.to_i <= 100
          when CS2::VP::REGEXP::MAP::SHIP_MUSIC_PITCH
            @ship_music_pitch = num.to_i if num.to_i >= 50 && num.to_i <= 150
            
          when CS2::VP::REGEXP::MAP::AIRSHIP_MUSIC_VOL
            @airship_music_vol = num.to_i if num.to_i >= 0 && num.to_i <= 100
          when CS2::VP::REGEXP::MAP::AIRSHIP_MUSIC_PITCH
            @airship_music_pitch = num.to_i if num.to_i >= 50 && num.to_i <= 150
          end
        }
      when /<[A-Za-z0-9_ ]+:[ ]*([A-Za-z0-9_ ]+*)>/i
        p line
        music = $1
        case line
        when CS2::VP::REGEXP::MAP::BOAT_MUSIC
          @boat_music = music
        when CS2::VP::REGEXP::MAP::SHIP_MUSIC
          @ship_music = music
        when CS2::VP::REGEXP::MAP::AIRSHIP_MUSIC
          @airship_music = music
        end
      end
    }
  end
end



class Game_Vehicle < Game_Character
  def land_ok?(x, y, d)
    if @type == :airship
      return false if collide_with_vehicles?(x,y)
      return false unless $game_map.events_xy(x, y).empty?
      result = $game_map.check_landing(x, y, @type)
      return result unless result == nil
      return false unless $game_map.airship_land_ok?(x, y)
    else
      x2 = $game_map.round_x_with_direction(x, d)
      y2 = $game_map.round_y_with_direction(y, d)
      result = $game_map.check_landing(x2, y2, @type)
      return false unless $game_map.valid?(x2, y2)
      return false if collide_with_characters?(x2, y2)
      return result unless result == nil
      return false unless $game_map.passable?(x2, y2, reverse_dir(d))
    end
    return true
  end
  
  def get_on
    @driving = true
    @walk_anime = true
    @step_anime = true
    @walking_bgm = RPG::BGM.last
    
    case @type
    when :boat
      vehicle_music = $game_map.boat_music
      vehicle_music_vol = $game_map.boat_music_vol
      vehicle_music_pitch = $game_map.boat_music_pitch
    when :ship
      vehicle_music = $game_map.ship_music
      vehicle_music_vol = $game_map.ship_music_vol
      vehicle_music_pitch = $game_map.ship_music_pitch
    when :airship
      vehicle_music = $game_map.airship_music
      vehicle_music_vol = $game_map.airship_music_vol
      vehicle_music_pitch = $game_map.airship_music_pitch
    end
    p vehicle_music
    p vehicle_music_vol
    p vehicle_music_pitch
    if vehicle_music != nil
      begin
        RPG::BGM.new(vehicle_music,vehicle_music_vol,vehicle_music_pitch).play
      rescue Exception => ex
        p ex
      end
      return
    end
    system_vehicle.bgm.play
  end
end


class Game_Player < Game_Character
  def get_type
    return @vehicle_type
  end
  
  alias VP_move_by_input move_by_input
  def move_by_input
    if @vehicle_type == :airship
      return unless Input.dir4 > 0
      front_x = $game_map.round_x_with_direction(@x, Input.dir4)
      front_y = $game_map.round_y_with_direction(@y, Input.dir4)
      return unless $game_map.check_passage_airship(front_x,front_y)
    end
    VP_move_by_input()
  end

end 


class Game_Map
  
  alias VP_game_map_setup setup
  def setup(map_id)
    VP_game_map_setup(map_id)
    @map.load_notetags_vp
  end
  
################################################################################
# New Methods
################################################################################
  def reset_passibility;@map.load_notetags_vp;end
  
  def boat_allow_region;return @map.boat_allow_region;end
  def boat_deny_region;return @map.boat_deny_region;end
  def boat_allow_terrain;return @map.boat_allow_terrain;end
  def boat_deny_terrain;return @map.boat_deny_terrain;end
  
  def boat_land_allow_region;return @map.boat_land_allow_region;end
  def boat_land_deny_region;return @map.boat_land_deny_region;end
  def boat_land_allow_terrain;return @map.boat_land_allow_terrain;end
  def boat_land_deny_terrain;return @map.boat_land_deny_terrain;end
  
  def ship_allow_region;return @map.ship_allow_region;end
  def ship_deny_region;return @map.ship_deny_region;end
  def ship_allow_terrain;return @map.ship_allow_terrain;end
  def ship_deny_terrain;return @map.ship_deny_terrain;end
  
  def ship_land_allow_region;return @map.ship_land_allow_region;end
  def ship_land_deny_region;return @map.ship_land_deny_region;end
  def ship_land_allow_terrain;return @map.ship_land_allow_terrain;end
  def ship_land_deny_terrain;return @map.ship_land_deny_terrain;end
  
  def airship_allow_region;return @map.airship_allow_region;end
  def airship_deny_region;return @map.airship_deny_region;end
  def airship_allow_terrain;return @map.airship_allow_terrain;end
  def airship_deny_terrain;return @map.airship_deny_terrain;end
  
  def airship_land_allow_region;return @map.airship_land_allow_region;end
  def airship_land_deny_region;return @map.airship_land_deny_region;end
  def airship_land_allow_terrain;return @map.airship_land_allow_terrain;end
  def airship_land_deny_terrain;return @map.airship_land_deny_terrain;end
  
  def walk_allow_region;return @map.walk_allow_region;end
  def walk_deny_region;return @map.walk_deny_region;end
  def walk_allow_terrain;return @map.walk_allow_terrain;end
  def walk_deny_terrain;return @map.walk_deny_terrain;end
  
  def boat_music;return @map.boat_music;end
  def boat_music=(val);@map.boat_music = val;end
  def boat_music_vol;return @map.boat_music_vol;end
  def boat_music_vol=(val);@map.boat_music_vol = val;end
  def boat_music_pitch;return @map.boat_music_pitch;end
  def boat_music_pitch=(val);@map.boat_music_pitch = val;end
  
  def ship_music;return @map.ship_music;end
  def ship_music=(val);@map.ship_music = val;end
  def ship_music_vol;return @map.ship_music_vol;end
  def ship_music_vol=(val);@map.ship_music_vol = val;end
  def ship_music_pitch;return @map.ship_music_pitch;end
  def ship_music_pitch=(val);@map.ship_music_pitch = val;end
  
  def airship_music;return @map.airship_music;end
  def airship_music=(val);@map.airship_music = val;end
  def airship_music_vol;return @map.airship_music_vol;end
  def airship_music_vol=(val);@map.airship_music_vol = val;end
  def airship_music_pitch;return @map.airship_music_pitch;end
  def airship_music_pitch=(val);@map.airship_music_pitch = val;end
  
  def check_passage_airship(x,y)
    regions_yes = @map.airship_allow_region
    regions_no = @map.airship_deny_region
    terrain_yes = @map.airship_allow_terrain
    terrain_no = @map.airship_deny_terrain
    return true if regions_yes.include?(region_id(x,y))
    return false if regions_no.include?(region_id(x,y))
    return true if terrain_yes.include?(terrain_tag(x,y))
    return false if terrain_no.include?(terrain_tag(x,y))
    return false if regions_no.include?(-1) && (regions_yes.size > 0)
    return false if terrain_no.include?(-1) && (terrain_yes.size > 0)
    return true
  end
  
  def check_landing(x,y,type)
    case type
    when :boat
      regions_yes = @map.boat_land_allow_region
      regions_no = @map.boat_land_deny_region
      terrain_yes = @map.boat_land_allow_terrain
      terrain_no = @map.boat_land_deny_terrain
    when :ship
      regions_yes = @map.ship_land_allow_region
      regions_no = @map.ship_land_deny_region
      terrain_yes = @map.ship_land_allow_terrain
      terrain_no = @map.ship_land_deny_terrain
    when :airship
      regions_yes = @map.airship_land_allow_region
      regions_no = @map.airship_land_deny_region
      terrain_yes = @map.airship_land_allow_terrain
      terrain_no = @map.airship_land_deny_terrain
    end
    
    return true if regions_yes.include?(region_id(x,y))
    return false if regions_no.include?(region_id(x,y))
    
    return true if terrain_yes.include?(terrain_tag(x,y))
    return false if terrain_no.include?(terrain_tag(x,y))
    
    return false if regions_no.include?(-1) && (regions_yes.size > 0)
    return false if terrain_no.include?(-1) && (terrain_yes.size > 0)
    return nil
  end
  
  alias VP_check_passage check_passage
  def check_passage(x, y, bit)
    result = false
    case bit & 0x0E00
    when 0x0200 #:boat
      result = true
      regions_yes = @map.boat_allow_region
      regions_no = @map.boat_deny_region
      terrain_yes = @map.boat_allow_terrain
      terrain_no = @map.boat_deny_terrain
    when 0x0400 #:ship
      result = true
      regions_yes = @map.ship_allow_region
      regions_no = @map.ship_deny_region
      terrain_yes = @map.ship_allow_terrain
      terrain_no = @map.ship_deny_terrain
    when 0x0000 #:walk
      result = true
      regions_yes = @map.walk_allow_region
      regions_no = @map.walk_deny_region
      terrain_yes = @map.walk_allow_terrain
      terrain_no = @map.walk_deny_terrain
    when 0x0800 #:airship
      #airship passage check is done elsewhere in this code.  Calls of airship
      #here is by the stock code checking if it is ok to land the airship.
      #we did our own checks ahead of this.
    end
    
    if result
      return true if regions_yes.include?(region_id(x,y))
      return false if regions_no.include?(region_id(x,y))
      
      return true if terrain_yes.include?(terrain_tag(x,y))
      return false if terrain_no.include?(terrain_tag(x,y))
      
      return false if regions_no.include?(-1) && (regions_yes.size > 0)
      return false if terrain_no.include?(-1) && (terrain_yes.size > 0)
    end
    VP_check_passage(x, y, bit)
  end

end
