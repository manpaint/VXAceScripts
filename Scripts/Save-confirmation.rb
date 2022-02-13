#-------------------------------------------------------------------------------
# Yanfly's Ace Save Engine - Confirmation Add-on
# Requires Yanfly's Ace Save Engine. Includes New Game Plus add-on confirm.
# by GALV
# Put this script after Yanfly's Save Engine script
# Last updated 2014-04-03 - Fixed bug where loading greater than 9 save file
# index crashes the game
#-------------------------------------------------------------------------------
  
module YEA
  module SAVE
    if File.file?('default_langset=2')    
    CONFIRM_DELETE = "Supprimer cette sauvegarde?"
    CONFIRM_SAVE = "Écraser cette sauvegarde?"
    CONFIRM_LOAD = "Charger cette sauvegarde?"
    CONFIRM_NEW_GAME_PLUS = "Recommencer cette sauvegarde en mode avancé?"  # For Yanfly's 'New Game Plus'    
    else   
    CONFIRM_DELETE = "Delete this save file?"
    CONFIRM_SAVE = "Overwrite this save file?"
    CONFIRM_LOAD = "Load this save file?"
    CONFIRM_NEW_GAME_PLUS = "Restart this game?"  # For Yanfly's 'New Game Plus'       
    end    
  end
end
  
class Scene_File < Scene_MenuBase
  
  alias galv_yf_save_scene_file create_all_windows
  def create_all_windows
    galv_yf_save_scene_file
    create_confirm_window
  end
  
  def create_confirm_window
    @confirm_window = Window_Confirm.new
    @confirm_window.help_window = @help_window
    @confirm_window.hide.deactivate
    @confirm_window.set_handler(:ok, method(:on_confirm_ok))
    @confirm_window.set_handler(:cancel, method(:on_confirm_cancel))
  end
  
  def on_confirm_ok
    case @confirm_window.current_symbol
    when :on_confirm_ok
      case @action_window.current_symbol
      when :load; on_action_confirmed_load
      when :save; do_save; refresh_windows
      when :delete; do_delete; refresh_windows
      when :new_game_plus; on_action_ngp_confirmed
      end
    when :on_confirm_cancel
      on_confirm_cancel
    end
    @action_window.activate
    @confirm_window.hide.deactivate
  end
  
  def on_confirm_cancel
    @action_window.activate
    @confirm_window.hide.deactivate
  end
  
  def on_action_load
    n = @file_window.index >= 9 ? "" : "0"
    if SceneManager.scene_is?(Scene_Load)
      if DataManager.load_game(@file_window.index)
        on_load_success
      else
        Sound.play_buzzer
      end
    #elsif !Dir.glob('Save0' + (@file_window.index + 1).to_s + '.rvdata2').empty?
    elsif !Dir.glob('Save'+ n + (@file_window.index + 1).to_s + '.rvdata2').empty?
      confirm_choice
    else
      Sound.play_buzzer
    end
  end
  
if $imported["YEA-NewGame+"]
  def on_action_ngp
    confirm_choice
  end
  
  def on_action_ngp_confirmed
    Sound.play_load
    DataManager.setup_new_game_plus(@file_window.index)
    fadeout_all
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
end
  
  def on_action_confirmed_load
    if DataManager.load_game(@file_window.index)
      on_load_success
    end
  end
  
  def on_load_success
    Sound.play_load
    fadeout_all
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
  
  def confirm_choice
    @action_window.deactivate
    @confirm_window.select(0)
    @confirm_window.show.activate
    case @action_window.current_symbol
    when :load; @help_window.set_text(YEA::SAVE::CONFIRM_LOAD)
    when :save; @help_window.set_text(YEA::SAVE::CONFIRM_SAVE)
    when :delete; @help_window.set_text(YEA::SAVE::CONFIRM_DELETE)
    when :new_game_plus; @help_window.set_text(YEA::SAVE::CONFIRM_NEW_GAME_PLUS)
    end
  end
  
  def on_action_save
    header = DataManager.load_header(@file_window.index)
    if header.nil?
      do_save
      refresh_windows
    else
      confirm_choice
    end
  end
  
  def do_save
    @action_window.activate
    if DataManager.save_game(@file_window.index)
      on_save_success
    else
      Sound.play_buzzer
    end
  end
  
  def on_action_delete
    confirm_choice
  end
  
  def do_delete
    @action_window.activate
    DataManager.delete_save_file(@file_window.index)
    on_delete_success
    refresh_windows
  end
  
end # Scene_File
  
class Window_Confirm < Window_Command
  def initialize
    super(0, 0)
    self.back_opacity = 255
    update_position
  end
  
  def window_width
    return 200
  end
  
  def update_position
    self.x = (Graphics.width - width) / 2
    self.y = Graphics.height / 2
  end
  
  def update_help; end
  
  def make_command_list
    if File.file?('default_langset=2')
    add_command("Oui", :on_confirm_ok)
    add_command("Non", :on_confirm_cancel)
  else
    add_command("Yes", :on_confirm_ok)
    add_command("No", :on_confirm_cancel)
   end 
  end
  
end # Window_Confirm < Window_Command
