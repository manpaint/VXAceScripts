#==============================================================================
# ** Logo
#------------------------------------------------------------------------------
#==============================================================================
 
def show_logo
  sprite = Sprite.new
  Graphics.fadeout(0)
  sprite.bitmap = Cache.system('logo1')
  Graphics.fadein(30)
  Graphics.wait(30)
  Graphics.fadeout(30)
  sprite.bitmap = Cache.system('logo2')
  Graphics.fadein(30)
  Graphics.wait(30)
  Graphics.fadeout(30)
end
 
show_logo  # unless $TEST
