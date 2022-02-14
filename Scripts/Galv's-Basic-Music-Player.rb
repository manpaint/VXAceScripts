#------------------------------------------------------------------------------#
#  Galv's Basic Music Player
#------------------------------------------------------------------------------#
#  For: RPGMAKER VX ACE
#  Version 1.6
#------------------------------------------------------------------------------#
#  2013-01-08 - Version 1.6 - plays auto map music or default battle when STOP
#  2013-01-08 - Version 1.5 - added a stop button
#  2012-11-03 - Version 1.4 - added ability to change separate vehicle music
#                           - fixed bug with vehicle music not going to default
#  2012-10-28 - Version 1.3 - tweak to right col position was a few px out
#  2012-10-28 - Version 1.2 - added option to set battle bgm to a known track
#                           - added option to set vehicle bgm to a known track
#                           - more script calls for eventing purposes
#                           - can access music player in battle
#  2012-10-27 - Version 1.1 - fixed bug with folder locations
#  2012-10-25 - Version 1.0 - release
#------------------------------------------------------------------------------#
#  This script allows the player to bring up a list of music to play. This can
#  be added as a menu option or called via an event call.
#  You can choose to add all files from a folder to this list or allow the 
#  player to collect music by adding tracks with event calls.
#  Within this list a player can set vehicle and combat music to their choice.
#------------------------------------------------------------------------------#
#  INSTRUCTIONS:
#  Read the setup options below and set it up as desired.
#
#  Script calls to use:
#------------------------------------------------------------------------------#
#
#  SceneManager.call(Scene_MusicPlayer)   # Calls the scene with an event.
#
#  add_music("Music Name")                # Adds song to the music player.
#
#  know_music?("Music Name")              # Returns true or false. Use in
#                                         # conditional branches.
#
#  play_last                    # Play the last track the player chose
#
#  restore_bgm                  # restores Battle BGM to what the player's choice
#                               # use this if you changed the BGM for a boss fight
#                               # then restore bgm to player preference after
#
#------------------------------------------------------------------------------#
#  Example script call:
#  add_music("Battle1")
#------------------------------------------------------------------------------#
#  NOTE:
#  The script can only see the AUDIO_FOLDER music in your project audio folder,
#  not in the RTP. This is only for the folder-generated music list on game start.
#  You can add music from the RTP via the add_music script call.
#------------------------------------------------------------------------------#
 
$imported = {} if $imported.nil?
$imported["Music_Player"] = true
 
module Galv_Music_Player
 
#------------------------------------------------------------------------------#
#  SCRIPT SETUP OPTIONS
#------------------------------------------------------------------------------#
 
  AUDIO_FOLDER = "C:/"   # Adds ALL files from this folder to the music
                                # list at game start. Make sure to only have
                                # playable audio in the folder.
                                # The format for this option is: "Audio/BGM/"
                                # AUDIO_FOLDER = "C:/" to add music via script
                                # calls throughout the game.
   
  MAP_BGM_SWITCH = 1            # Turn switch ON to disable map auto BGM change
                                # When switch is OFF, it will play as normal.
                                # Make this 0 if you will never want to disable
                                 
  # MENU COMMAND OPTIONS
  ADD_TO_MENU = true            # Add it to default menu? true or false.
  MENU_VOCAB = "Music Player"   # How it displays in the menu.
 
  ADD_TO_BATTLE_MENU = true     # Add it to default battle menu? true or false.
  BATTLE_MENU_VOCAB = "Music"   # How it displays in the battle menu.
 
  ENABLE_MENU_SWITCH = 2        # Turn switch ON to disable command in both menus.
                                # Make this 0 if you will never want to disable
 
  # OTHER OPTIONS
  MUSIC_ICON = 118                # Icon ID for all musics 
  BATTLE_BGM_ICON = 131           # Icon ID for the selected Battle BGM
  VEHICLE_BGM_ICON = 179          # Icons ID for the selected Vehicle BGM
    BOAT_ICON = 162
    SHIP_ICON = 442
    AIRSHIP_ICON = 328
   
  OPTIONS_WIDTH = 280             # Width of the options window.
   
  # OPTIONS VOCAB
  PLAY_SELECTED = "Play track"
  SET_BATTLE = "Set as battle music"
  SET_VEHICLE = "Set as vehicle music"
    SET_BOAT = "Boat music"
    SET_SHIP = "Ship music"
    SET_AIRSHIP = "Airship music"
    SET_ALL = "Use for all"
  RESTORE_DEFAULTS = "Restore defaults"
  STOP_MUSIC = "Stop music"
 
#------------------------------------------------------------------------------#
#  SCRIPT SETUP OPTIONS
#------------------------------------------------------------------------------#
 
end
 
 
class Scene_MusicPlayer < Scene_MenuBase
   
  def start
    super
    create_music_option_window
    create_vehicle_option_window
    create_music_window
  end
   
  def create_music_option_window
    @music_option_window = Window_Music_Options.new
    @music_option_window.viewport = @info_viewport
    @music_option_window.set_handler(:ok,      method(:on_music_option_ok))
    @music_option_window.set_handler(:cancel, method(:on_music_option_cancel))
    @music_option_window.hide.deactivate
    @music_option_window.z = 400
  end
  def create_vehicle_option_window
    @vehicle_option_window = Window_Vehicle_Options.new
    @vehicle_option_window.viewport = @info_viewport
    @vehicle_option_window.set_handler(:ok,      method(:on_vehicle_option_ok))
    @vehicle_option_window.set_handler(:cancel, method(:on_vehicle_option_cancel))
    @vehicle_option_window.hide.deactivate
    @vehicle_option_window.z = 450
  end
   
  def create_music_window
    @music_window = Window_Music_List.new(0)
    @music_window.show
    @music_window.viewport = @info_viewport
    @music_window.set_handler(:ok,     method(:on_music_ok))
    @music_window.set_handler(:cancel, method(:on_music_cancel))
  end
   
  def on_vehicle_option_ok
    case @vehicle_option_window.current_symbol
    when :set_boat
      $game_system.vehicle_track = nil
      $game_system.vehicles_music[0] = $game_system.last_track
      @music_window.activate
      @music_option_window.hide.deactivate
      @vehicle_option_window.hide.deactivate
      @music_window.refresh(0)
    when :set_ship
      $game_system.vehicle_track = nil
      $game_system.vehicles_music[1] = $game_system.last_track
      @music_window.activate
      @music_option_window.hide.deactivate
      @vehicle_option_window.hide.deactivate
      @music_window.refresh(0)
    when :set_airship
      $game_system.vehicle_track = nil
      $game_system.vehicles_music[2] = $game_system.last_track
      @music_window.activate
      @music_option_window.hide.deactivate
      @vehicle_option_window.hide.deactivate
      @music_window.refresh(0)
    when :set_all
      $game_system.vehicle_track = $game_system.last_track
      @music_window.activate
      @music_option_window.hide.deactivate
      @vehicle_option_window.hide.deactivate
      @music_window.refresh(0)
    end
  end
   
  def on_vehicle_option_cancel
      @music_option_window.activate
      @vehicle_option_window.hide.deactivate
  end
   
  def on_music_option_ok
    case @music_option_window.current_symbol
    when :play_track
      RPG::BGM.new($game_system.last_track, 100, 100).play
      @music_window.activate
      @music_option_window.hide.deactivate
    when :set_battle_music
      $game_system.battle_bgm = RPG::BGM.new($game_system.last_track, 100, 100)
      $game_system.stored_bgm = $game_system.battle_bgm
      $game_system.stored_bgm.play if $game_party.in_battle
      @music_window.activate
      @music_option_window.hide.deactivate
      @music_window.refresh(0)
    when :set_vehicle_music
      @music_option_window.deactivate
      @vehicle_option_window.select(0)
      @vehicle_option_window.show.activate
    when :restore_defaults
      $game_system.battle_bgm = $data_system.battle_bgm
      $game_system.vehicle_track = nil
      $game_system.vehicles_music = [$data_system.boat.bgm.name,$data_system.ship.bgm.name,$data_system.airship.bgm.name]
      @music_window.activate
      @music_option_window.hide.deactivate
      @music_window.refresh(0)
    when :stop_music
      RPG::BGM.stop
      @music_window.activate
      @music_option_window.hide.deactivate
      $game_map.play_map_music
    end
  end
   
  def on_music_option_cancel
      @music_window.activate
      @music_option_window.hide.deactivate
  end
 
  def on_music_ok
    @music_window.deactivate
    @music_option_window.select(0)
    @music_option_window.show.activate
  end
 
  def on_music_cancel
    SceneManager.return
  end
  
end # Scene_MusicPlayer < Scene_MenuBase
 
 
class Window_Vehicle_Options < Window_Command
  def initialize
    super(0, 0)
    update_placement
  end
  def window_width
    return Galv_Music_Player::OPTIONS_WIDTH
  end
 
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height * 1.6 - height) / 2 - self.height
  end
   
  def make_command_list
    add_command(Galv_Music_Player::SET_BOAT, :set_boat)
    add_command(Galv_Music_Player::SET_SHIP, :set_ship)
    add_command(Galv_Music_Player::SET_AIRSHIP, :set_airship)
    add_command(Galv_Music_Player::SET_ALL, :set_all)
  end
 
end # Window_Vehicle_Options < Window_Command
 
 
class Window_Music_Options < Window_Command
  def initialize
    super(0, 0)
    update_placement
  end
  def window_width
    return Galv_Music_Player::OPTIONS_WIDTH
  end
 
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height * 1.6 - height) / 2
  end
   
  def make_command_list
    add_command(Galv_Music_Player::PLAY_SELECTED, :play_track)
    add_command(Galv_Music_Player::SET_BATTLE, :set_battle_music)
    add_command(Galv_Music_Player::SET_VEHICLE, :set_vehicle_music)
    add_command(Galv_Music_Player::RESTORE_DEFAULTS, :restore_defaults)
    add_command(Galv_Music_Player::STOP_MUSIC, :stop_music)
  end
 
end # Window_Music_Options < Window_Command
 
 
class Window_Music_List < Window_Selectable
 
  def initialize(data)
    super(0, 0, Graphics.width, Graphics.height) unless SceneManager.scene_is?(Scene_Battle)
    super(0, 0, Graphics.width, Graphics.height - 120) if SceneManager.scene_is?(Scene_Battle)
    @index = 0
    @data = data
    @item_max = $game_system.music_list.count
    refresh(data)
    select(0)
    activate
  end
  
  def refresh(data)
    self.contents.clear
    if @item_max > 0
      if @item_max.odd?
        self.contents = Bitmap.new(width - 32, (@item_max * 24) / col_max + 12)
      else
        self.contents = Bitmap.new(width - 32, (@item_max * 24) / col_max)
      end
       for i in 0...$game_system.music_list.count
          draw_item(i) unless i == nil
       end
    end
  end
     
  def check_item_max
    @data_max = $game_system.music_list.count / col_max
  end
   
  def col_max
    return 2
  end
   
  def item_height
    line_height * 1
  end
 
  def draw_item(index)
    return if $game_system.music_list[index] == nil
 
    x = Graphics.width / col_max + 4 if index.odd?
    x = 0 if index.even?
    y = (index) / col_max * 24
 
    music_name = $game_system.music_list[index].to_s
    change_color(normal_color,true)
    check_item_max
    d = @data_max > 99 ? "%03d" : @data_max > 9 ? "%02d" : "%01d"
     
    if $game_system.music_list[index].to_s == $game_system.battle_bgm.name
      draw_icon(Galv_Music_Player::BATTLE_BGM_ICON, x, y)
    elsif $game_system.music_list[index].to_s == $game_system.vehicle_track
      draw_icon(Galv_Music_Player::VEHICLE_BGM_ICON, x, y)
     
    elsif $game_system.music_list[index].to_s == $game_system.vehicles_music[0] && $game_system.vehicle_track.nil?
      draw_icon(Galv_Music_Player::BOAT_ICON, x, y)  
       
    elsif $game_system.music_list[index].to_s == $game_system.vehicles_music[1] && $game_system.vehicle_track.nil?
      draw_icon(Galv_Music_Player::SHIP_ICON, x, y)
    elsif $game_system.music_list[index].to_s == $game_system.vehicles_music[2] && $game_system.vehicle_track.nil?
      draw_icon(Galv_Music_Player::AIRSHIP_ICON, x, y)
    else
      draw_icon(Galv_Music_Player::MUSIC_ICON, x, y)
    end
    self.contents.draw_text(x + 30, y, 238, 24, music_name, 0)
  end
 
  def item_max
    return @item_max == nil ? 0 : @item_max
  end  
   
  def process_ok
    if $game_system.music_list[index].nil?
      return Sound.play_buzzer
    else
      $game_system.last_track = $game_system.music_list[index]
      call_ok_handler
    end
  end
   
end # Window_Music_List < Window_Selectable
 
class Game_System
  attr_accessor :music_list
  attr_accessor :last_track
  attr_accessor :stored_bgm
  attr_accessor :vehicle_track
  attr_accessor :vehicles_music
  alias galv_musicplayer_initialize initialize
  def initialize
    galv_musicplayer_initialize
    @music_list = []
    create_music_list unless Galv_Music_Player::AUDIO_FOLDER == ""
    @last_track = ""
    @vehicles_music = [$data_system.boat.bgm.name,$data_system.ship.bgm.name,$data_system.airship.bgm.name]
  end
  def last_track
    @last_track
  end
  def music_list
    @music_list
  end
  def stored_bgm
    @stored_bgm
  end
  def vehicle_track
    @vehicle_track
  end
  def vehicles_music
    @vehicles_music
  end
   
  def create_music_list
    @music_list = Dir[Galv_Music_Player::AUDIO_FOLDER + "*"]
    no_songs = @music_list.count
    no_songs.times { |i|
      if @music_list[i] =~ /(.*)\/(.*)\./i
        @music_list[i] = $2.to_s
      end
    }
  end
 
end # Game_System
 
 
class Game_Map
   
  alias galv_musicplayer_autoplay autoplay
  def autoplay
    if $game_switches[Galv_Music_Player::MAP_BGM_SWITCH]
      @map.bgs.play if @map.autoplay_bgs
      return
    end
    galv_musicplayer_autoplay
  end
  def play_map_music
    @map.bgm.play if @map.autoplay_bgm
  end
end # Game_Map
 
 
#------------------------------------------------------------------------------#
#  ADD TO MAIN MENU
#------------------------------------------------------------------------------#
 
class Window_MenuCommand < Window_Command
  alias galv_musicplayer_add_original_commands add_original_commands
  def add_original_commands
    add_command(Galv_Music_Player::MENU_VOCAB, :play_music, music_player_enabled) if Galv_Music_Player::ADD_TO_MENU
    galv_musicplayer_add_original_commands
  end
   
  def music_player_enabled
    !$game_switches[Galv_Music_Player::ENABLE_MENU_SWITCH] && !$game_system.music_list.empty?
  end
   
end # Window_MenuCommand < Window_Command
 
class Scene_Menu < Scene_MenuBase
  alias galv_musicplayer_create_command_window create_command_window
  def create_command_window
    galv_musicplayer_create_command_window
    @command_window.set_handler(:play_music,  method(:command_play_music))
  end
   
  def command_play_music
    SceneManager.call(Scene_MusicPlayer)
  end
end # Scene_Menu < Scene_MenuBase
 
 
#------------------------------------------------------------------------------#
#  ADD TO BATTLE MENU
#------------------------------------------------------------------------------#
 
class Window_PartyCommand < Window_Command
  alias galv_musicplayer_make_command_list make_command_list
  def make_command_list
    galv_musicplayer_make_command_list
    add_command(Galv_Music_Player::BATTLE_MENU_VOCAB, :play_music, music_player_enabled) if Galv_Music_Player::ADD_TO_BATTLE_MENU
  end
   
  def music_player_enabled
    !$game_switches[Galv_Music_Player::ENABLE_MENU_SWITCH] && !$game_system.music_list.empty?
  end
   
end # Window_PartyCommand < Window_Command
 
 
class Scene_Battle < Scene_Base
   
  alias galv_musicplayer_create_all_windows create_all_windows
  def create_all_windows
    create_music_option_window
    create_vehicle_option_window
    create_music_window
    galv_musicplayer_create_all_windows
  end
   
  alias galv_musicplayer_create_party_command_window create_party_command_window
  def create_party_command_window
    galv_musicplayer_create_party_command_window
    @party_command_window.set_handler(:play_music,  method(:command_play_music))
  end
 
  def command_play_music
    @party_command_window.deactivate
    @music_window.show.activate
  end
   
  def create_music_option_window
    @music_option_window = Window_Music_Options.new
    @music_option_window.viewport = @info_viewport
    @music_option_window.set_handler(:ok,      method(:on_music_option_ok))
    @music_option_window.set_handler(:cancel, method(:on_music_option_cancel))
    @music_option_window.hide.deactivate
    @music_option_window.z = 400
  end
  def create_vehicle_option_window
    @vehicle_option_window = Window_Vehicle_Options.new
    @vehicle_option_window.viewport = @info_viewport
    @vehicle_option_window.set_handler(:ok,      method(:on_vehicle_option_ok))
    @vehicle_option_window.set_handler(:cancel, method(:on_vehicle_option_cancel))
    @vehicle_option_window.hide.deactivate
    @vehicle_option_window.z = 450
  end
   
  def create_music_window
    @music_window = Window_Music_List.new(0)
    @music_window.hide.deactivate
    @music_window.viewport = @info_viewport
    @music_window.set_handler(:ok,     method(:on_music_ok))
    @music_window.set_handler(:cancel, method(:on_music_cancel))
  end
   
  def on_vehicle_option_ok
    case @vehicle_option_window.current_symbol
    when :set_boat
      $game_system.vehicle_track = nil
      $game_system.vehicles_music[0] = $game_system.last_track
      @music_window.activate
      @music_option_window.hide.deactivate
      @vehicle_option_window.hide.deactivate
      @music_window.refresh(0)
    when :set_ship
      $game_system.vehicle_track = nil
      $game_system.vehicles_music[1] = $game_system.last_track
      @music_window.activate
      @music_option_window.hide.deactivate
      @vehicle_option_window.hide.deactivate
      @music_window.refresh(0)
    when :set_airship
      $game_system.vehicle_track = nil
      $game_system.vehicles_music[2] = $game_system.last_track
      @music_window.activate
      @music_option_window.hide.deactivate
      @vehicle_option_window.hide.deactivate
      @music_window.refresh(0)
    when :set_all
      $game_system.vehicle_track = $game_system.last_track
      @music_window.activate
      @music_option_window.hide.deactivate
      @vehicle_option_window.hide.deactivate
      @music_window.refresh(0)
    end
  end
   
  def on_vehicle_option_cancel
      @music_option_window.activate
      @vehicle_option_window.hide.deactivate
  end
   
  def on_music_option_ok
    case @music_option_window.current_symbol
    when :play_track
      RPG::BGM.new($game_system.last_track, 100, 100).play
      @music_window.activate
      @music_option_window.hide.deactivate
    when :set_battle_music
      $game_system.battle_bgm = RPG::BGM.new($game_system.last_track, 100, 100)
      $game_system.stored_bgm = $game_system.battle_bgm
      $game_system.stored_bgm.play if $game_party.in_battle
      @music_window.activate
      @music_option_window.hide.deactivate
      @music_window.refresh(0)
    when :set_vehicle_music
      @music_option_window.deactivate
      @vehicle_option_window.select(0)
      @vehicle_option_window.show.activate
    when :restore_defaults
      $game_system.battle_bgm = $data_system.battle_bgm
      $game_system.vehicle_track = nil
      $game_system.vehicles_music = [$data_system.boat.bgm.name,$data_system.ship.bgm.name,$data_system.airship.bgm.name]
      @music_window.activate
      @music_option_window.hide.deactivate
      @music_window.refresh(0)
    when :stop_music
      RPG::BGM.stop
      @music_window.activate
      @music_option_window.hide.deactivate
      $game_system.battle_bgm.play
    end
  end
   
  def on_music_option_cancel
      @music_window.activate
      @music_option_window.hide.deactivate
  end  
   
  def on_music_ok
    @music_window.deactivate
    @music_option_window.select(0)
    @music_option_window.show.activate
  end
 
  def on_music_cancel
    @music_window.hide.deactivate
    @party_command_window.activate
  end
   
   
end # Scene_Battle < Scene_Base
 
 
class Game_Vehicle < Game_Character
 
  alias galv_music_player_get_on get_on
  def get_on
    galv_music_player_get_on
     
    if !$game_system.vehicle_track.nil?
      RPG::BGM.new($game_system.vehicle_track, 100, 100).play
    end
     
    if @type == :boat && !$game_system.vehicles_music[0].nil?
      RPG::BGM.new($game_system.vehicles_music[0], 100, 100).play
    end
    if @type == :ship && !$game_system.vehicles_music[1].nil?
      RPG::BGM.new($game_system.vehicles_music[1], 100, 100).play
    end
    if @type == :airship && !$game_system.vehicles_music[2].nil?
      RPG::BGM.new($game_system.vehicles_music[2], 100, 100).play
    end
     
  end
end
 
 
#------------------------------------------------------------------------------#
#  SCRIPT CALLS
#------------------------------------------------------------------------------#
 
class Game_Interpreter
 
  def add_music(music_name)
    return if $game_system.music_list.include?(music_name)
    $game_system.music_list << music_name
  end
   
  def know_music?(music_name)
    $game_system.music_list.include?(music_name)
  end
   
  def play_last
    RPG::BGM.new($game_system.last_track, 100, 100).play
  end
   
  def restore_bgm
    $game_system.battle_bgm = $game_system.stored_bgm
  end
 
end
