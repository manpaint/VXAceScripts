#==============================================================================
# 8 Dir Move                                                  JV Master Script
#------------------------------------------------------------------------------
# Make player move in 8 dir, supports diagonal pattern.
#==============================================================================

module JvScripts
  module Dirs8
    
    Switch = 11               # Switch id for toggle 4/8 dir, 0 if always 8 dir
    DiagonalSuffix = "_di"   # Suffix for 8 dir charsets
                             # 8 dir charsets include in the first char
                             # the orthogonal and in the second the diagonal
  end
end

#==============================================================================
# Game CharacterBase
#==============================================================================
class Game_CharacterBase
  
  def move_diagonal(horz, vert)
    @move_succeed = diagonal_passable?(x, y, horz, vert)
    if @move_succeed
      @x = $game_map.round_x_with_direction(@x, horz)
      @y = $game_map.round_y_with_direction(@y, vert)
      @real_x = $game_map.x_with_direction(@x, reverse_dir(horz))
      @real_y = $game_map.y_with_direction(@y, reverse_dir(vert))
      increase_steps
    end
    if diagonal_charset?
      set_direction_diagonal(horz, vert)
    else
      set_direction(horz) if @direction == reverse_dir(horz)
      set_direction(vert) if @direction == reverse_dir(vert)
    end
  end
  
  def set_direction(d)
    if !@direction_fix && d != 0
      @direction = d
      @character_index = 0 if diagonal_charset?
    end
    @stop_count = 0
  end
  
  def set_direction_diagonal(horz, vert)
    if !@direction_fix && horz != 0 && vert != 0
      if horz == 4 && vert == 2
        @direction = 2
      elsif horz == 4 && vert == 8
        @direction = 4
      elsif horz == 6 && vert == 2
        @direction = 6
      elsif horz == 6 && vert == 8
        @direction = 8
      end
      
      @character_index = 1
    end
    @stop_count = 0
  end
  
  def diagonal_charset?
    true if @character_name.include?(JvScripts::Dirs8::DiagonalSuffix)
  end
end

#==============================================================================
# Game Player
#==============================================================================
class Game_Player < Game_Character
  def move_by_input
    return if !movable? || $game_map.interpreter.running?
    if JvScripts::Dirs8::Switch > 0
      if $game_switches[JvScripts::Dirs8::Switch] == true
        case Input.dir8
        when 2, 4, 6, 8
          move_straight(Input.dir4)
        when 1
          move_diagonal(4, 2)
        when 3
          move_diagonal(6, 2)
        when 7
          move_diagonal(4, 8)
        when 9
          move_diagonal(6, 8)
        end
      else
        move_straight(Input.dir4) if Input.dir4 > 0
      end
    else
      if Input.dir8 > 0
        case Input.dir8
        when 2, 4, 6, 8
          move_straight(Input.dir4)
        when 1
          move_diagonal(4, 2)
        when 3
          move_diagonal(6, 2)
        when 7
          move_diagonal(4, 8)
        when 9
          move_diagonal(6, 8)
        end
      end
    end
  end
end
#==============================================================================
