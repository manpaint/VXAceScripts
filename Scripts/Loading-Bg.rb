#==============================================================================
# ** Logo
#------------------------------------------------------------------------------
#==============================================================================
# 
def show_logo
  sprite = Sprite.new
  Graphics.fadeout(0)
  sprite.bitmap = Cache.system('loading1')
  Graphics.fadein(30)
  Graphics.wait(100)
  Graphics.fadeout(30)
end
 
show_logo  # unless $TEST
#
