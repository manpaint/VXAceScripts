=begin

  Usage :
  Use script call to add picture before battle
  (You can add many as many picture as you want)
 
  $game_system.extra_pics << "Picture Name 1"
  $game_system.extra_pics << "Picture Name 2"
  $game_system.extra_pics << "Picture Name 3"
 
  Use this script call outside battle to clear all the pictures
  $game_system.extra_pics.clear

=end
class Game_System
  def extra_pics
    @extra_pics ||= []
  end
end

class Spriteset_Battle
  alias theo_create_pic create_pictures
  def create_pictures
    theo_create_pic
    @extra_pics = []
    $game_system.extra_pics.each do |pic|
      spr = Sprite.new(@viewport1)
      spr.bitmap = Cache.picture(pic)
      spr.z = 9999
      @extra_pics << spr
    end
  end
 
  alias theo_pic_dispose dispose
  def dispose
    theo_pic_dispose
    @extra_pics.each {|pic| pic.dispose}
  end
end
