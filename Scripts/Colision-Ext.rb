class Game_Event < Game_Character
  alias shaz_large_event_collision_clear_page_settings clear_page_settings
  alias shaz_large_event_collision_setup_page_settings setup_page_settings

  def clear_page_settings
    shaz_large_event_collision_clear_page_settings
    @collide_width = 0
    @collide_height = 0
  end

  def setup_page_settings
    shaz_large_event_collision_setup_page_settings
    @collide_width = 0
    @collide_height = 0
    list_index = 0
    while list_index < @list.size && [108,408].include?(@list[list_index].code)
      colx, coly = @list[list_index].parameters[0].scan(/<collision: (\d+),(\d+)>/i)[0]
      @collide_width = colx.nil? ? 0 : (colx.to_i / 64)
      @collide_height = coly.nil? ? 0 : (coly.to_i / 32 - 1)
      list_index = @list.size if @collide_width != 32 || @collide_height != 32
      list_index += 1
    end
  end

  def pos?(x,y)
    x.between?(@x - @collide_width, @x + @collide_width) && 
      y.between?(@y - @collide_height, @y)
  end
end
