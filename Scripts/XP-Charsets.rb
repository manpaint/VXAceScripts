#==============================================================================
# ** MSX - XP Characters on VX/VXAce
#==============================================================================
# Author: Melosx
# Notes translated by ShinGamix
# http://www.rpgmakervxace.net/index.php?/user/1272-shingamix/
# Version: 1.0
# Compatible with VX and VXAce
#
#==============================================================================
# * Description
# -----------------------------------------------------------------------------
# This script allows you to use xp in vx chara simply inserting the tag
# $xp
# Before the name of the file.		  
# You can then use the normal VX / VXAce along with those of XP.
#
#==============================================================================
# * Instructions
# -----------------------------------------------------------------------------
# Place the script under Materials and above Main. Add to chara of XP
# $xp before the tag name.
#
#==============================================================================
#==============================================================================
# ** Sprite_Character
#==============================================================================
class Sprite_Character < Sprite_Base

  def update_bitmap
	if @tile_id != @character.tile_id or
		  @character_name != @character.character_name or
		  @character_index != @character.character_index
		  @tile_id = @character.tile_id
		  @character_name = @character.character_name
		  @character_index = @character.character_index
		  if @tile_id > 0
			sx = (@tile_id / 128 % 2 * 8 + @tile_id % 8) * 32;
			sy = @tile_id % 256 / 8 % 16 * 32;
			self.bitmap = tileset_bitmap(@tile_id)
			self.src_rect.set(sx, sy, 32, 32)
			self.ox = 16
			self.oy = 32
		  else
			self.bitmap = Cache.character(@character_name)
			sign = @character_name[/^[!$]./]
			if sign != nil and sign.include?('$')
				  @cw = bitmap.width / 3
				  @ch = bitmap.height / 4
			else
				  @cw = bitmap.width / 12
				  @ch = bitmap.height / 8
			end
			if @character_name != nil and @character_name.include?('$xp')
				  @cw = bitmap.width / 4
				  @ch = bitmap.height / 4
			end
			self.ox = @cw / 2
			self.oy = @ch
		  end
	end
  end
				
  def update_src_rect
	if @character_name != nil and @character_name.include?('$xp')
		  if @tile_id == 0
			pattern = @character.pattern > 0 ? @character.pattern - 1 : 3
			sx = pattern * @cw
			sy = (@character.direction - 2) / 2 * @ch
			self.src_rect.set(sx, sy, @cw, @ch)
		  end
	else
		  if @tile_id == 0
			index = @character.character_index
			pattern = @character.pattern < 3 ? @character.pattern : 1
			sx = (index % 4 * 3 + pattern) * @cw
			sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
			self.src_rect.set(sx, sy, @cw, @ch)
		  end
	end
  end
end
#==========================================================================
# ** Window_Base
#==========================================================================
class Window_Base < Window
  def draw_character(character_name, character_index, x, y)
	return if character_name == nil
	bitmap = Cache.character(character_name)
	sign = character_name[/^[!$]./]
	if character_name != nil and character_name.include?('$xp')
		  cw = bitmap.width / 4
		  ch = bitmap.height / 4
		  n = character_index
		  src_rect = Rect.new(0, 0, cw, ch)
	else
		  if sign != nil and sign.include?('$')
			cw = bitmap.width / 3
			ch = bitmap.height / 4
		  else
			cw = bitmap.width / 12
			ch = bitmap.height / 8
		  end
		  n = character_index
		  src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
	end
	self.contents.blt(x - cw / 2, y - ch, bitmap, src_rect)
  end

end
