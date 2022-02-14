#============================================================================
 #Enemy HUD
 #By Ventwig
 #Version 1.4 - July 29 2012
 #For RPGMaker VX Ace
 #============================================================================
 # Here's another window-ish thing to show HP Smile
 # Thanks Shaz for helping me out with this one Very Happy
 # Thanks ItsKouta for showing me a horrible bug!
 # Thanks to #tag-this for helping with the hide numbers option!
 # Thanks Helladen for pointing out a small error!
 # Thanks Ulises for helping with the hurdle of not having RMVXA with me!
 #=============================================================================
 # Description:
 # This code shows the name and HP for up to 8 enemies at once.
 # Plug'N'Play and the HP bar updates after every hit/kill.
 # You can also set it so the numbers are hidden! Oooh!
 # Options to scan enemies, show MP, or states will be added.
 #==============================================================================
 # Compatability:
 # alias-es Game_Enemy and Scene_Battle
 # Works with Neo Gauge Ultimate Ace (Recommended)
 #===============================================================================
 # Instructions: Put in materials, above main. Almost Plug and Play
 # Put above Neo Gauge Ultimate Ace if used
 #==============================================================================
 # Please give Credit to Ventwig if you would like to use one of my scripts
 # in a NON-COMMERCIAL project.
 # Please ask for permission if you would like to use it in a commercial game.
 # You may not re-distribute any of my scripts or claim as your own.
 # You may not release edits without permission, combatability patches are okay.
 #===============================================================================
 module EHUD
 #t/f - choose whether or not to make the background appear.
 WINDOW_BACK = false
 #Number, choose how long to wait between attacks (to let the player look
 #at the HP bars. Recommended 4-6
 WINDOW_WAIT = 5
 #Chooses the Y value of the window. Recommended 20.
 WINDOW_Y = 20

 #Decides whether or not to show the HP numbers/etc/etc.
 #0 means normal (HP name, current and max hp)
 #1 means hidden max hp
 #2 means just the bar and the word hp
 DRAW_HP_NUMBERS = 0
 #Selects whether or not you have Neo Gauge Ultimate Ace.
 #If the above is set to [[true]], this doesnt matter, if it's false,
 #make sure you have it right!!!
 NEO_ULTIMATE_ACE = false

 ###########################################################################
 #Boss Gauges - Setup info
 #==========================================================================
 #In version 1.2, there is now the option to draw longer gauges so bosses look
 #Way cooler (And it works).
 #Now, to set up a boss, you need to make sure the boss is
 #THE FIRST ENEMY IN THE TROOP. If not, then there won't be a boss gauge.
 #
 #Next, please note that if you want to draw the boss gauge, you have to make
 #Sure that the troop only has 5 enemies, counting the boss.
 #So a Demon and 4 spiders is allowed, but not a Demon and 6 spiders.
 #
 #Also, you can put multiple bosses in one troop but a gauge will only be
 #drawn for the first one, even when it's killed.
 #===========================================================================
 #Now, to set up bosses, make it like the example below
 #BOSS_ENEMY[Enemyid for the boss] = true
 #TRUE IS REQUIRED FOR IT TO WORK
 #
 #Don't worry, you don't need to put false for non-bosses.
 #Have Fun!
 ############################################################################

 #How long the boss gauge should be. Def: 475
 BOSS_GAUGE = 475

 #Sets enemies to draw the boss gauges!
 BOSS_ENEMY = [] #Do not touch
 #BOSS_ENEMY[Enemyid for the boss] = true
 BOSS_ENEMY[1] = true

 end

 class Game_Enemy < Game_Battler
 #--------------------------------------------------------------------------
 # * Method Aliases
 #--------------------------------------------------------------------------
 alias shaz_enemyhud_initialize initialize
 #--------------------------------------------------------------------------
 # * Public Instance Variables
 #--------------------------------------------------------------------------
 attr_accessor :old_hp # hp on last hud refresh
 attr_accessor :old_mp # mp on last hud refresh
 #--------------------------------------------------------------------------
 # * Object Initialization
 #--------------------------------------------------------------------------
 def initialize(index, enemy_id)
 shaz_enemyhud_initialize(index, enemy_id)
 @old_hp = mhp
 @old_mp = mmp
 end
 end

 class Window_Enemy_Hud < Window_Base

 ###################################################################
 #Sets up what appears in the HUD
 #Questions names and HUD, then displays them
 ################################################################# 
 #Set up the window's start-up
 def initialize
 #Draws window
 super(0,EHUD::WINDOW_Y,545,120)
 if EHUD::WINDOW_BACK == false
 self.opacity = 0
 end
 self.z = 0
 @x, @y = 0, 50 
 troop_fix
 if EHUD::BOSS_ENEMY[@enemy1.enemy_id] != nil and EHUD::BOSS_ENEMY[@enemy1.enemy_id] == true
 @boss_troop = true
 @boss_enemy = @enemy1
 else
 @boss_troop = false
 @boss_enemy = nil
 end
 enemy_hud
 refresh
 end



 if EHUD::DRAW_HP_NUMBERS == 1
 if EHUD::NEO_ULTIMATE_ACE == false
 def draw_actor_hp(actor, x, y, width = 124)
 draw_gauge(x, y, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
 change_color(system_color)
 draw_text(x, y, 30, line_height, Vocab::hp_a)
 change_color(hp_color(actor))
 draw_text(x, y, width, line_height, actor.hp)
 change_color(system_color)
 end
 else
 def draw_actor_hp(actor, x, y, width = 124)
 gwidth = width * actor.hp / actor.mhp
 cg = neo_gauge_back_color
 c1, c2, c3 = cg[0], cg[1], cg[2]
 draw_neo_gauge(x + HPMP_GAUGE_X_PLUS, y + line_height - 8 +
 HPMP_GAUGE_Y_PLUS, width, HPMP_GAUGE_HEIGHT, c1, c2, c3)
 (1..3).each {|i| eval("c#{i} = HP_GCOLOR_#{i}")}
 draw_neo_gauge(x + HPMP_GAUGE_X_PLUS, y + line_height - 8 +
 HPMP_GAUGE_Y_PLUS, gwidth, HPMP_GAUGE_HEIGHT, c1, c2, c3, false, false,
 width, 30)
 draw_text(x, y, 30, line_height, Vocab::hp_a)
 change_color(hp_color(actor))
 draw_text(x, y, width, line_height, actor.hp)
 change_color(system_color)

 end
 end
 end

 if EHUD::DRAW_HP_NUMBERS == 2
 if EHUD::NEO_ULTIMATE_ACE == false
 def draw_actor_hp(actor, x, y, width = 124)
 draw_gauge(x, y, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
 end
 else
 def draw_actor_hp(actor, x, y, width = 124)
 gwidth = width * actor.hp / actor.mhp
 cg = neo_gauge_back_color
 c1, c2, c3 = cg[0], cg[1], cg[2]
 draw_neo_gauge(x + HPMP_GAUGE_X_PLUS, y + line_height - 8 +
 HPMP_GAUGE_Y_PLUS, width, HPMP_GAUGE_HEIGHT, c1, c2, c3)
 (1..3).each {|i| eval("c#{i} = HP_GCOLOR_#{i}")}
 draw_neo_gauge(x + HPMP_GAUGE_X_PLUS, y + line_height - 8 +
 HPMP_GAUGE_Y_PLUS, gwidth, HPMP_GAUGE_HEIGHT, c1, c2, c3, false, false,
 width, 30)
 end
 end
 end


 def troop_fix
 if $game_troop.alive_members.size > 0
 @enemy1 = $game_troop.alive_members[0]
 end
 if $game_troop.alive_members.size > 1
 @enemy2 = $game_troop.alive_members[1]
 end
 if $game_troop.alive_members.size > 2
 @enemy3 = $game_troop.alive_members[2]
 end
 if $game_troop.alive_members.size > 3
 @enemy4 = $game_troop.alive_members[3]
 end
 if $game_troop.alive_members.size > 4
 @enemy5 = $game_troop.alive_members[4]
 end
 if $game_troop.alive_members.size > 5
 @enemy6 = $game_troop.alive_members[5]
 end
 if $game_troop.alive_members.size > 6
 @enemy7 = $game_troop.alive_members[6]
 end
 if $game_troop.alive_members.size > 7
 @enemy8 = $game_troop.alive_members[7]
 end
 end

 def enemy_hud
 troop_fix
 if $game_troop.alive_members.size > 0
 if @boss_troop == true and @boss_enemy.enemy_id == @enemy1.enemy_id
 draw_actor_name(@enemy1,10,0)
 draw_actor_hp(@enemy1,10,20,width=EHUD::BOSS_GAUGE)
 else
 draw_actor_name(@enemy1,10,0)
 draw_actor_hp(@enemy1,10,20,width=96)
 end
 end
 if $game_troop.alive_members.size > 1
 if @boss_troop == true and @boss_enemy.enemy_id == @enemy1.enemy_id
 draw_actor_name(@enemy2,10,50)
 draw_actor_hp(@enemy2,10,70,width=96)
 else
 draw_actor_name(@enemy2,10+125,0)
 draw_actor_hp(@enemy2,10+125,20,width=96)
 end
 end
 if $game_troop.alive_members.size > 2
 if @boss_troop == true and @boss_enemy.enemy_id == @enemy1.enemy_id
 draw_actor_name(@enemy3,10+125,50)
 draw_actor_hp(@enemy3,10+125,70,width=96)
 else
 draw_actor_name(@enemy3,10+250,0)
 draw_actor_hp(@enemy3,10+250,20,width=96)
 end
 end
 if $game_troop.alive_members.size > 3
 if @boss_troop == true and @boss_enemy.enemy_id == @enemy1.enemy_id
 draw_actor_name(@enemy4,10+250,50)
 draw_actor_hp(@enemy4,10+250,70,width=96)
 else
 draw_actor_name(@enemy4,10+375,0)
 draw_actor_hp(@enemy4,10+375,20,width=96)
 end
 end
 if $game_troop.alive_members.size > 4
 if @boss_troop == true and @boss_enemy.enemy_id == @enemy1.enemy_id
 draw_actor_name(@enemy5,10+375,50)
 draw_actor_hp(@enemy5,10+375,70,width=96)
 else
 draw_actor_name(@enemy5,10,50)
 draw_actor_hp(@enemy5,10,70,width=96)
 end
 end
 if $game_troop.alive_members.size > 5
 if @boss_troop == false
 draw_actor_name(@enemy6,10+125,50)
 draw_actor_hp(@enemy6,10+125,70,width=96)
 end
 end
 if $game_troop.alive_members.size > 6
 if @boss_troop == false
 draw_actor_name(@enemy7,10+250,50)
 draw_actor_hp(@enemy7,10+250,70,width=96)
 end
 end
 if $game_troop.alive_members.size > 7
 if @boss_troop == false
 draw_actor_name(@enemy8,10+375,50)
 draw_actor_hp(@enemy8,10+375,70,width=96)
 end
 end
 end

 def refresh
 contents.clear
 enemy_hud
 @old_size = $game_troop.alive_members.size
 if @old_size < 5 and @boss_troop == false
 self.height = 80
 end
 end

 def update
 # assume no refresh needed
 refresh_okay = false

 # loop through remaining enemies one at a time - each enemy is put into the temporary variable called 'enemy'
 $game_troop.alive_members.each do |enemy|
 # have the hp or mp changed since last time?
 if enemy.hp != enemy.old_hp || enemy.mp != enemy.old_mp
 # we do need to update the hud
 refresh_okay = true
 # and replace the old values with the current values
 enemy.old_hp = enemy.hp
 enemy.old_mp = enemy.mp
 end
 end

 if $game_troop.alive_members.size != @old_size
 refresh_okay = true
 end
 if @boss_enemy != nil
 if @enemy1.enemy_id == @boss_enemy.enemy_id
 @boss_troop = true
 else
 @boss_troop = false
 end
 end

 if refresh_okay
 refresh
 end
 end

 end

 class Window_BattleLog
 alias enemy_hud_battle_log_wait wait_and_clear
 def wait_and_clear
 wait while @num_wait < EHUD::WINDOW_WAIT if line_number > 0
 clear
 end
 end

 #Show the window on the map
 class Scene_Battle < Scene_Base
 alias original_create_all_windows create_all_windows
 def create_all_windows
 original_create_all_windows
 create_enemy_hud_window
 end
 def create_enemy_hud_window
 @enemy_hud_window = Window_Enemy_Hud.new
 end
 end
 #########################################################################
 #End Of Script #
 #########################################################################
