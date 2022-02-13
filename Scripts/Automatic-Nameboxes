                            #======================#
                            #  Z-Systems by: Zetu  #
#===========================#======================#===========================#
#               *  *  *  Z12 Automatic Nameboxes  v1.04  *  *  *               #
#=#==========================================================================#=#
  #  Set the module to decide what faces will return what names.  You can    #
  #  by-pass this by using a script call.                                    #
  #  $game_message.forced_text = ""      // Removes the next Textbox         #
  #  $game_message.forced_text = "NAME"  // Sets next Textbox to NAME        #
  #==========================================================================#
module Z12
  
  def self.namebox(faceset, index)
    case faceset
    when "main"
      case index
      when 0; return $game_actors[1].name
      when 1; return $game_actors[2].name
      when 2; return $game_actors[3].name
      when 3; return $game_actors[4].name
      when 4; return "Fixed Name"
      end
    end
    return ""
  end
  
end

class Window_Message < Window_Base
  alias :z12caw :create_all_windows
  def create_all_windows
    z12caw
    @messageName_window = Window_MessageName.new(self)
  end
  alias :z12civ :clear_instance_variables
  def clear_instance_variables
    z12civ
    @messageName_window.text = ""
  end
  alias :z12daw :dispose_all_windows
  def dispose_all_windows
    z12daw
    @messageName_window.dispose
  end
  alias :z12uaw :update_all_windows
  def update_all_windows
    z12uaw
    @messageName_window.update
  end
  alias :z12np :new_page
  def new_page(text, pos)
    z12np(text, pos)
    @messageName_window.new_face
  end
end

class Window_MessageName < Window_Base
  attr_accessor :text
  def initialize(window)
    super(0,0,128,48)
    @parent_window = window
    self.openness = 0
  end
  
  def new_face
    if $game_message.forced_text.nil?
      @text = Z12.namebox($game_message.face_name, $game_message.face_index)
    else
      @text = $game_message.forced_text
      $game_message.forced_text = nil
    end
    refresh
  end
  
  def update
    self.openness = @text=="" ? 0 : @parent_window.openness
    refresh if self.visible
    self.y = (@parent_window.y > 0 ? @parent_window.y-48 : @parent_window.window_height)
  end
  
  def refresh
    contents.clear
    draw_text(0, 0, 104, 24, @text, 1)
  end
  
end

class Game_Message
  attr_accessor :forced_text
end
