# Some Popup v 2.8
# VX Ace version
# by mikb89
 
# Details:
#  Show some popup text when facing an event.
#  Text can be placed in center of screen, over the player or over the event.
#  Write [pop] in a comment to assign the popup to an event and write in the
#   next comment the text that will be shown.
# NOTE: [pop] is by default, but you can change it in the settings.
#  Text can be also grayed, to indicate a non-available something. To do so,
#   write [npop] instead of [pop].
#  You can also show a picture instead of text. In order to do this, the first
#   comment must be [ppop] and the second will contain the name of the Picture.
#  It is possible to play a sound/music effect for each event. Just write in a
#   third comment these lines:
#    SE (or ME or BGM or BGS)
#    Audio filename
#    Volume (1-100)
#    Pitch (50-150)
#    You can omit the two last lines, and they will be set by default:
#    Volume 80 for BGS and SE, 100 for BGM and ME
#    Pitch 100
# ATTENTION: comments have to be the first two (or three) commands of the event.
#
#  You can also call a script with:
#    $game_player.remove_town_sprite
#   in it to remove the sprite. For example if you put the sprite on an event
#   which you'll speak, with this code you can remove the popup.
 
# Configurations:
module SPOP
  ID = "pop" # set "loc" for old version compatibility.
   # What you have to write on a event to be identified as popup one.
   # If the value here is for example "pop" you'll have to write:
   #  - [pop] for the common text popup;
   #  - [npop] for the grayed out popup;
   #  - [ppop] for the picture popup.
  AUTO_REMOVE_AT_TRANSFER = true
   # Test to understand what I mean.
   #  true - gives the same effect as the one in Chrono Trigger towns.
   #  false - let the popup be visible after the teleport. Will fade out at the
   #          first player movement.
  GRAYED_COLOR = Color.new(255,245,255,175)
   # Value of grey color. Red, green, blue, alpha. From 0 to 255.
  WALK_8_DIR = false
   # You don't have to include the 8dir script. Just set true this.
  POPUP_TRANSITION = 11
   # The effect of the popup appearing/disappearing.
   #  0: no effect
   #  1: fading in/out
   #  2: movement up/down
   #  3: movement & fading
   #  4: reduced movement
   #  5: reduced movement & fading
   #  6: zoom in/out
   #  7: zoom & fading
   #  8: zoom & movement
   #  9: zoom, movement, fading
   # 10: zoom & reduced movement
   # 11: zoom, reduced movement, fading
  POPUP_SOUND = ["SE", "", 80, 100]
   # Play something on popup.
   # 4 parameters:
   #  1. Sound kind ("SE", "ME", "BGS", "BGM");
   #  2. Name of the file;
   #  3. Volume (0-100);
   #  4. Pitch (50-150 (or 15-453 if you want MAXIMUM values)).
   # To deactivate sound just set "" the 2. or set 0 to 3. Examples:
   #  POPUP_SOUND = ["SE", "", 80, 100]
   #  POPUP_SOUND = ["SE", "Book1", 0, 100]
   # Won't be played.
   # Eventual BGM or BGS playing will fade as the graphic fade/zoom/move and
   #  will start after the popup close. Obviously not valid if using SE/ME.
 
   # Examples with ME, BGM, BGS:
   #  POPUP_SOUND = ["ME", "Item", 100, 100]
   #  POPUP_SOUND = ["BGM", "Town1", 100, 100]
   #  POPUP_SOUND = ["BGS", "Clock", 100, 100]
  POPUP_BINDING = 1
   # Where the popup should be binded.
   #  0: center of the screen
   #  1: over the player
   #  2: over the event
end
 
# Others:
#  You'll see 'town' everywhere in the script. This is because of the SECOND
#   name given to this script: "Popup town name".
#  The FIRST original name was "Location system", from this the [loc] to add in
#   event comments. By the way I never publicated the version with this name, so
#   you won't find anything.
 
#Codename: spop
 
($imported ||= {})[:mikb89_spop] = true
 
# License:
# - You can ask me to include support for other scripts as long as these scripts
#   use the $imported[script] = true;
# - You can modify and even repost my scripts, after having received a response
#   by me. For reposting it, anyway, you must have done heavy edit or porting,
#   you can't do a post with the script as is;
# - You can use my scripts for whatever you want, from free to open to
#   commercial games. I'd appreciate by the way if you let me know about what
#   you're doing;
# - You must credit me, if you use this script or part of it.
 
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias_method(:initGP_b4_spop, :initialize) unless method_defined?(:initGP_b4_spop)
#class Game_Player#def initialize() <- aliased
  def initialize
    initGP_b4_spop
    @town_sprite = nil
    @town_text = ""
    reset_audio
    @town_ex_audio = nil
    @sync_event = nil
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias_method(:updateGP_b4_spop, :update) unless method_defined?(:updateGP_b4_spop)
#class Game_Player#def update() <- aliased
  def update
    updateGP_b4_spop
    if @town_sprite != nil
      case SPOP::POPUP_BINDING
      when 1
        @town_sprite.x = $game_player.screen_x
        if @town_sprite.y != $game_player.screen_y && $game_player.screen_y != @sync_y
          @town_sprite.y = $game_player.screen_y - (@town_sprite.y - @sync_y).abs
          @sync_y = $game_player.screen_y
        end
      when 2
        if @sync_event != nil
          @town_sprite.x = @sync_event.screen_x
          if @town_sprite.y != @sync_event.screen_y && @sync_event.screen_y != @sync_y
            @town_sprite.y = @sync_event.screen_y - (@town_sprite.y - @sync_y).abs
            @sync_y = @sync_event.screen_y
          end
          remove_town_sprite if Math.hypot(@sync_event.distance_x_from($game_player.x), @sync_event.distance_y_from($game_player.y)) > 2
        end
      end
      rem = false
      @town_sprite.visible = SceneManager.scene_is?(Scene_Map)
      @town_sprite.update
      if [1,3,5,7,9,11].include?(SPOP::POPUP_TRANSITION)
        @town_sprite.opacity -= 15 if @town_sprite.z == 5 && @town_sprite.opacity > 0
        @town_sprite.opacity += 15 if @town_sprite.z >= 10 && @town_sprite.opacity < 255
        rem = true if @town_sprite.opacity <= 0
      end
      if [2,3,4,5,8,9,10,11].include?(SPOP::POPUP_TRANSITION)
        mov = [4,5,10,11].include?(SPOP::POPUP_TRANSITION) ? 32 : 64
        val = mov/16
        t = @town_sprite.y
        @town_sprite.y += val if @town_sprite.z == 5 && @toadd > -mov
        @town_sprite.y -= val if @town_sprite.z >= 10 && @toadd > 0
        @toadd -= val if t != @town_sprite.y
        rem = true if @toadd <= -mov
      end
      if [6,7,8,9,10,11].include?(SPOP::POPUP_TRANSITION)
        if @town_sprite.z == 5 && @town_sprite.zoom_x > 0
          @town_sprite.zoom_x -= 0.25
          @town_sprite.zoom_y -= 0.25
        end
        if @town_sprite.z >= 10 && @town_sprite.zoom_x < 1
          @town_sprite.zoom_x += 0.25
          @town_sprite.zoom_y += 0.25
        end
        rem = true if @town_sprite.zoom_x <= 0
      end
      if @town_ex_audio != nil
        if @audiowait > 0
          @audiowait -= 1
        elsif @audiowait == 0
          if @town_audio != nil
            @town_audio.play
            if @town_ex_audio.class != @town_audio.class
              @town_ex_audio.replay
              @town_ex_audio = nil
            end
            reset_audio if @town_audio.name != SPOP::POPUP_SOUND[1]
          end
          @audiowait = -1
        end
      end
      remove_town_sprite(true) if rem
    end
  end
  #--------------------------------------------------------------------------
  # * Removing of town sprite when changing map
  #--------------------------------------------------------------------------
  alias_method(:perform_transfer_b4_spop, :perform_transfer) unless method_defined?(:perform_transfer_b4_spop)
#class Game_Player#def perform_transfer() <- aliased
  def perform_transfer
    remove_town_sprite(true, false) if SPOP::AUTO_REMOVE_AT_TRANSFER
    perform_transfer_b4_spop
  end
  #--------------------------------------------------------------------------
  # * Processing of Movement via input from the Directional Buttons
  #--------------------------------------------------------------------------
#class Game_Player#def move_by_input() <- rewritten
  def move_by_input
    return unless movable?
    return if $game_map.interpreter.running?
    x, y = self.x, self.y
    case SPOP::WALK_8_DIR ? Input.dir8 : Input.dir4
    when 1
      move_diagonal(4,2)#lower_left
      if !@move_succeed
        check_town(x-1, y+1)
      else
        check_town(x-2, y+2)
      end
    when 2
      move_straight(2)#down
      if !@move_succeed
        check_town(x, y+1)
      else
        check_town(x, y+2)
      end
    when 3
      move_diagonal(6,2)#lower_right
      if !@move_succeed
        check_town(x+1, y+1)
      else
        check_town(x+2, y+2)
      end
    when 4
      move_straight(4)#left
      if !@move_succeed
        check_town(x-1, y)
      else
        check_town(x-2, y)
      end
    when 6
      move_straight(6)#right
      if !@move_succeed
        check_town(x+1, y)
      else
        check_town(x+2, y)
      end
    when 7
      move_diagonal(4,8)#upper_left
      if !@move_succeed
        check_town(x-1, y-1)
      else
        check_town(x-2, y-2)
      end
    when 8
      move_straight(8)#up
      if !@move_succeed
        check_town(x, y-1)
      else
        check_town(x, y-2)
      end
    when 9
      move_diagonal(6,8)#upper_right
      if !@move_succeed
        check_town(x+1, y-1)
      else
        check_town(x+2, y-2)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Operations for sprite removal and audio stopping
  #--------------------------------------------------------------------------
#class Game_Player#def remove_town_sprite(instant, audio)
  def remove_town_sprite(instant=false, audio=true)
    if @town_sprite != nil
      if instant || SPOP::POPUP_TRANSITION == 0
        if audio
          @town_audio.class.stop if @town_audio != nil
          @town_ex_audio.replay if @town_ex_audio != nil
        end
        @town_ex_audio = nil
        @town_sprite.dispose
        @town_sprite = nil
        @sync_event = nil
      else
        @town_sprite.z = 5
        unless @town_audio.is_a?(RPG::SE)
          @town_audio.class.fade(4) if @town_audio != nil
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set the audio as the one specified in SPOP or passed
  #--------------------------------------------------------------------------
#class Game_Player#def reset_audio(spn)
  def reset_audio(spn = SPOP::POPUP_SOUND)
    @town_audio = (spn[1] == "" ||
                  spn[2] <= 0) ? nil :
                    case spn[0]
                    when "BGM"; RPG::BGM.new(spn[1], spn[2], spn[3])
                    when "BGS"; RPG::BGS.new(spn[1], spn[2], spn[3])
                    when "ME"; RPG::ME.new(spn[1], spn[2], spn[3])
                    when "SE"; RPG::SE.new(spn[1], spn[2], spn[3])
                    end
  end
  #--------------------------------------------------------------------------
  # * Check if there is a town event in front of the player
  #--------------------------------------------------------------------------
#class Game_Player#def check_town(x, y)
  def check_town(x, y)
    return false if $game_map.interpreter.running?
    result = false
    for event in $game_map.events_xy(x, y)
      unless [1,2].include?(event.trigger) and event.priority_type == 1
        if event.list != nil
          if event.list[0].code == 108 and
            ["[#{SPOP::ID}]", "[n#{SPOP::ID}]", "[p#{SPOP::ID}]"].include?(event.list[0].parameters[0])
            result = true
            next if @town_sprite != nil && @town_sprite.z >= 10 && @town_text == event.list[1].parameters[0]
            remove_town_sprite(true)
            @town_sprite = Sprite.new
            @town_sprite.z = 50 #10
            if [6,7,8,9,10,11].include?(SPOP::POPUP_TRANSITION)
              @town_sprite.zoom_x = @town_sprite.zoom_y = 0.0
            end
            @town_sprite.opacity = 15 if [1,3,5,7,9,11].include?(SPOP::POPUP_TRANSITION)
            if event.list[0].parameters[0] != "[p#{SPOP::ID}]"
              @town_sprite.bitmap ||= Bitmap.new(1,1)
              siz = @town_sprite.bitmap.text_size(event.list[1].parameters[0])
              h = siz.height
              s = siz.width
              @town_sprite.bitmap.dispose
              @town_sprite.bitmap = Bitmap.new(s, 24)
              if event.list[0].parameters[0] == "[n#{SPOP::ID}]"
                ex = @town_sprite.bitmap.font.color
                @town_sprite.bitmap.font.color = SPOP::GRAYED_COLOR
              end
              @town_sprite.bitmap.draw_text(0,2,s,22,event.list[1].parameters[0],1)
              @town_sprite.bitmap.font.color = ex if event.list[0].parameters[0] == "[n#{SPOP::ID}]"
            else
              @town_sprite.bitmap = Cache.picture(event.list[1].parameters[0])
              s = @town_sprite.bitmap.width
              h = @town_sprite.bitmap.height
            end
            @town_text = event.list[1].parameters[0]
            @town_sprite.ox = s/2
            @town_sprite.oy = h/2
            case SPOP::POPUP_BINDING
            when 1
              @town_sprite.x = $game_player.screen_x#*32+16
              @town_sprite.y = @sync_y = $game_player.screen_y#*32+16
            when 2
              @town_sprite.x = event.screen_x#*32+16
              @town_sprite.y = @sync_y = event.screen_y#*32+16
              @sync_event = event
            else
              @town_sprite.x = 544/2# - s/2
              @town_sprite.y = 416/2# - h/2
            end
            @town_sprite.y -= 64 if [0,1,6,7].include?(SPOP::POPUP_TRANSITION)
            @town_sprite.y -= 32 if [4,5,10,11].include?(SPOP::POPUP_TRANSITION)
            @toadd = [2,3,4,5,8,9,10,11].include?(SPOP::POPUP_TRANSITION) ? 64 : 0
            @toadd -= 32 if [4,5,10,11].include?(SPOP::POPUP_TRANSITION)
            if @town_audio != nil || event.list[2].code == 108
              if ["BGM", "ME", "BGS", "SE"].include?(event.list[2].parameters[0]) &&
                event.list[3].code == 408
                arr = []
                arr.push(event.list[2].parameters[0])
                arr.push(event.list[3].parameters[0])
                if event.list[4].code == 408
                  arr.push(event.list[4].parameters[0].to_i)
                  arr.push(event.list[5].parameters[0].to_i) if event.list[5].code == 408
                else
                  arr.push(["BGS", "SE"].include?(event.list[2].parameters[0]) ? 80 : 100)
                end
                arr.push(100) if arr.size < 4
                reset_audio(arr)
              end
              @town_ex_audio = @town_audio.class.last if [RPG::BGM, RPG::BGS].include?(@town_audio.class)
              if @town_ex_audio != nil
                @town_ex_audio.class.fade(4)
                @audiowait = 4
              else
                @town_audio.play if @town_audio != nil
                reset_audio if arr != nil
              end
            end
          end
        end
      end
    end
    remove_town_sprite unless result
    return result
  end
end
 
#--------------------------------------------------------------------------
# * Sprite removal at Save (can't save a Sprite) and End
#--------------------------------------------------------------------------
class Scene_Save < Scene_File
  if method_defined?(:start)
    alias_method(:start_SSav_b4_spop, :start) unless method_defined?(:start_SSav_b4_spop)
  end
#class Scene_Save#def start() <- aliased/added
  def start
    if respond_to?(:start_SSav_b4_spop)
      start_SSav_b4_spop
    else
      super
    end
    $game_player.remove_town_sprite(true)
  end
end
 
class Scene_End < Scene_MenuBase
  alias_method(:start_SEnd_b4_spop, :start) unless method_defined?(:start_SEnd_b4_spop)
#class Scene_End#def start() <- aliased
  def start
    start_SEnd_b4_spop
    $game_player.remove_town_sprite(true)
  end
end
