#==============================================================================
# 
# ¥ Vel System - Random Title Screen v1.00
# -- Last Updated: 2/3/2013
# -- Author: Ven01273
# -- Level: Normal
# -- Requires: n/a
#  *Based on [RMVX] +Random Title Screen+ by Woratana*
#
#==============================================================================

$imported = {} if $imported.nil?
$imported["VS-RTS"] = true

#==============================================================================
# ¥ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2/3/2013 - Started Script and finished.
#==============================================================================
# ¥ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows you to randomize the title screen's background.
#==============================================================================
# ¥ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ¥ Materials but above ¥ Main Process. Remember to save.
#==============================================================================
# ¥ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script was made with RGSS3. I don't use the other versions, so I don't
# know if it'll work. See for yourself.
#==============================================================================

class Scene_Title < Scene_Base

Title  = Array.new
Title2 = Array.new

#==============================================================================
#                            EDITABLE REGION
#==============================================================================

Randomize_title1 = false
Randomize_title2 = false
Title  = ["Book","Castle"]
Title2 = ["Heroes","Forest"]
Title2 = ["Heroes","title14-15"]

#==============================================================================
#                          END EDITABLE REGION
#==============================================================================
# Don't edit anything past this point, unless you know what you're doing.
#==============================================================================

def create_background
  @sprite1 = Sprite.new
  title_random = rand(Title.size)
  if Randomize_title1 == true
  @sprite1.bitmap = Cache.title1(Title[title_random].to_s)
  else
  @sprite1.bitmap = Cache.title1($data_system.title1_name)
  end
  @sprite2 = Sprite.new
  title_random = rand(Title2.size)
  if Randomize_title2 == true
    @sprite2.bitmap = Cache.title2(Title2[title_random].to_s)
  else
    @sprite2.bitmap = Cache.title2($data_system.title2_name)
  end
  center_sprite(@sprite1)
  center_sprite(@sprite2)
end
end

#==============================================================================
#                               END OF FILE
#==============================================================================
