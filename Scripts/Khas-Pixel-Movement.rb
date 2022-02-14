#-------------------------------------------------------------------------------
# * [ACE] Khas Pixel Movement
#-------------------------------------------------------------------------------
# * Par Khas Arcthunder
# * Traduit par Gummy - rpgmakervx-fr.com
# * Version: 1.0 BR
# * Créé le: 30/12/2011
#
#-------------------------------------------------------------------------------
# * Conditions d'utilisation
#-------------------------------------------------------------------------------
# Si vous utilisez ce script, merci de créditer Khas Arcthunder.
# Tous mes scripts sont sous licence Creative Commons et sont donc protégés.
# Ces scripts sont prévus pour un usage non-commercial. Si toutefois vous
# désiriez changer cela, contactez-moi à l'adresse nilokruch@live.com.
# Tous mes scripts sont réalisés pour des fins personnelles.
# Vous pouvez utiliser et modifier mes scripts, mais vous ne pouvez poster
# une version modifiée sans mon autorisation. Merci.
#-------------------------------------------------------------------------------
# * Caractéristiques
#-------------------------------------------------------------------------------
# O Khas Pixel Movement ajoute diverses nouvelles choses:
# - Mouvement par pixel pour le joueur
# - Mouvement par pixel des personnages de la chenille
# - Mouvement par pixel des évènements
# - Mouvement par pixel des véhicules
# - Plug and Play
# - Pas de lag
# - Cartes préchargées
# - Intelligence artificielle des personnages de la chenille améliorée
# - Collisions configurables
# - Compatible avec les régions et les zones
# - Compatible avec les véhicules
# - Multiplication de commandes auto
# - Compatible avec les sols
#
#-------------------------------------------------------------------------------
# * Instructions
#-------------------------------------------------------------------------------
# 1. Comment installer ce script
# Ce script fonctionne seul. Il gère les mouvements par pixel du joueur, des
# personnages de la chenille, des évènements et même des véhicules dans le jeu.
 
# 2. Systèmes physiques
# Pour que ce script fonctionne correctement, il nécessite une gestion de la
# physique. Ce système précharge automatiquement les cartes de jeu, pour maximiser
# les performances. Il se peut qu'il y ait un minuscule temps de chargement
# entre les cartes du jeu, surtout sur les grandes cartes.
#
# 3. Commandes d'évènements (Commentaires dans l'évènement)
# Vous voudrez sans doute personnaliser les évènements également. Voici les
# commandes à utiliser :
#
# a. [collision_x A]
# Cette commande modifie la collision avec l'axe X (A doit être entier)
#
# b. [collision_y B]
# Cette commande modifie la collision avec l'axe Y (B doit être entier)
#
# 4. Commandes d'évènements (Appels de scripts)
# Commandes qui peuvent être appelées pour le joueur ou les évènements :
# 
# character.centralize(x,y)
# Cette commande centre le personnage sur le point (x,y).
#
# character.px
# Cette commande retourne le pixel en X.
#
# character.py
# Cette commande retourne le pixel en Y.
#
# character.pixel_passable?(px,py)
# Cette commande vérifie la passabilité au pixel (px,py).
# 
#-------------------------------------------------------------------------------
# * Incompatibilités
#-------------------------------------------------------------------------------
# O Khas Pixel Movement est incompatible avec :
# 1. Cartes qui bouclent
# 2. Toute modification de Game_Character, Game_Player et Game_Event
# 3. Scripts Anti-Lag
# 4. Fonction "Dommages au sol" (cette fonction a été supprimée)
#
#-------------------------------------------------------------------------------
# * Configuration
#-------------------------------------------------------------------------------
module Pixel_Core
  
  # Cartes où le mouvement par pixel est activé (ID)
  # Exemple: 
  # Maps = [1,3,4,5,6,7]
  Maps = [1,2]
  
  # Multiplier les commandes pour évènements?
  Multiply_Commands = true
  
  # Commandes à être multipliées
  Commands = [1,2,3,4,5,6,7,8,9,10,11,12,13]
  
  # Le vaisseau peut-il atterrir sur l'herbe?
  Airship_Bush = true
  
  # Distance d'activation des personnages de la chenille (non entier)
  Follow_Distance = 0.75
  
#-------------------------------------------------------------------------------
# * Configuration des pixels (D'AUTRES PARAMETRES PEUVENT PLANTER VOTRE JEU!)
#-------------------------------------------------------------------------------
  Pixel = 4
  Tile = 0.25
  Default_Collision_X = 3
  Default_Collision_Y = 3
  Body_Axis = [0.25,0.25,0.5,0.75]
  Bush_Axis = [0.5,0.75]
  Counter_Axis = [0.25,0.25,0.25,0.25]
  Ladder_Axis = [0.25,0.25]
  Pixel_Range = {2=>[0,0.25],4=>[-0.25,0],6=>[0.25,0],8=>[0,-0.25]}
  Tile_Range = {2=>[0,1],4=>[-1,0],6=>[1,0],8=>[0,-1]}
  Trigger_Range = {2=>[0,2],4=>[-2,0],6=>[2,0],8=>[0,-2]}
  Counter_Range = {2=>[0,3],4=>[-3,0],6=>[3,0],8=>[0,-3]}
  Vehicle_Range = {2=>[0,3],4=>[-3,0],6=>[3,0],8=>[0,-3]}
end
#-------------------------------------------------------------------------------
# * S'enregistrer
#-------------------------------------------------------------------------------
if $khas_awesome.nil?
  $khas_awesome = []
else
  scripts = []
  $khas_awesome.each { |script| scripts << script[0] }
  if scripts.include?("Sapphire Action System")
    error = Sprite.new
    error.bitmap = Bitmap.new(544,416)
    error.bitmap.draw_text(0,208,544,32,"Veuillez supprimer le script Khas Pixel Movement.",1)
    error.bitmap.draw_text(0,240,544,32,"Le script Sapphire Action System l'empêche de fonctionner.",1)
    continue = Sprite.new
    continue.bitmap = Bitmap.new(544,416)
    continue.bitmap.font.color = Color.new(0,255,0)
    continue.bitmap.font.size = error.bitmap.font.size - 3
    continue.bitmap.draw_text(0,384,544,32,"Appuyez sur ENTER pour continuer.",1)
    add = Math::PI/80; max = 2*Math::PI; angle = 0
    loop do
      Graphics.update; Input.update
      angle += add; angle %= max
      continue.opacity = 185 + 70* Math.cos(angle)
      break if Input.trigger?(Input::C)
    end
    error.bitmap.dispose; continue.bitmap.dispose
    error.bitmap = nil; continue.bitmap = nil
    error.dispose; continue.dispose
    error = nil; continue = nil
    exit
  elsif scripts.include?("Tactical Battle System")
    error = Sprite.new
    error.bitmap = Bitmap.new(544,416)
    error.bitmap.draw_text(0,208,544,32,"Veuillez supprimer le script Khas Pixel Movement.",1)
    error.bitmap.draw_text(0,240,544,32,"Le script Tactical Battle System l'empêche de fonctionner.",1)
    continue = Sprite.new
    continue.bitmap = Bitmap.new(544,416)
    continue.bitmap.font.color = Color.new(0,255,0)
    continue.bitmap.font.size = error.bitmap.font.size - 3
    continue.bitmap.draw_text(0,384,544,32,"Appuyez sur ENTER pour continuer.",1)
    add = Math::PI/80; max = 2*Math::PI; angle = 0
    loop do
      Graphics.update; Input.update
      angle += add; angle %= max
      continue.opacity = 185 + 70* Math.cos(angle)
      break if Input.trigger?(Input::C)
    end
    error.bitmap.dispose; continue.bitmap.dispose
    error.bitmap = nil; continue.bitmap = nil
    error.dispose; continue.dispose
    error = nil; continue = nil
    exit
  end
end
$khas_awesome << ["Pixel Movement",1.0]
#-------------------------------------------------------------------------------
# * Game_Map
#-------------------------------------------------------------------------------
class Game_Map
  include Pixel_Core
  attr_reader :pixel_table
  alias kp_referesh_vehicles referesh_vehicles
  def pixel_valid?(x, y)
    x >= 0 && x <= @pixel_wm && y >= 0 && y <= @pixel_hm
  end
  def referesh_vehicles
    setup_table if Pixel_Core::Maps.include?(@map_id)
    kp_referesh_vehicles
  end
  def setup_table
    Graphics.update
    @pixel_table = Table.new(width*Pixel, height*Pixel,6)
    for x in 0...(width*Pixel)
      for y in 0...(height*Pixel)
        @pixel_table[x,y,0] = table_collision(x*Tile,y*Tile,0x0f)
        @pixel_table[x,y,1] = table_collision(x*Tile,y*Tile,0x0200)
        @pixel_table[x,y,2] = table_collision(x*Tile,y*Tile,0x0400)
        @pixel_table[x,y,3] = table_ladder(x*Tile,y*Tile)
        @pixel_table[x,y,4] = table_bush(x*Tile+Bush_Axis[0],y*Tile+Bush_Axis[1])
        @pixel_table[x,y,5] = table_counter(x*Tile+Counter_Axis[0],y*Tile+Counter_Axis[1])
      end
    end
    @pixel_wm = (width-1)*Pixel
    @pixel_hm = (height-1)*Pixel
  end
  def table_collision(x,y,flag)
    return 0 unless table_passage((x+Body_Axis[0]).to_i,(y+Body_Axis[1]).to_i,flag)
    return 0 unless table_passage((x+Body_Axis[2]).to_i,(y+Body_Axis[1]).to_i,flag)
    return 0 unless table_passage((x+Body_Axis[0]).to_i,(y+Body_Axis[3]).to_i,flag)
    return 0 unless table_passage((x+Body_Axis[2]).to_i,(y+Body_Axis[3]).to_i,flag)
    return 1
  end
  def table_bush(x,y)
    return layered_tiles_flag?(x.to_i, y.to_i, 0x40) ? 1 : 0
  end
  def table_ladder(x,y)
    return 1 if layered_tiles_flag?(x.to_i,(y+Ladder_Axis[1]).to_i, 0x20)
    return 1 if layered_tiles_flag?((x+Ladder_Axis[0]).to_i, (y+Ladder_Axis[1]).to_i, 0x20)
    return 0
  end
  def table_counter(x,y)
    return 1 if layered_tiles_flag?(x.to_i,y.to_i, 0x80)
    return 1 if layered_tiles_flag?((x+Counter_Axis[2]).to_i,y.to_i, 0x80)
    return 1 if layered_tiles_flag?(x.to_i,(y+Counter_Axis[3]).to_i, 0x80)
    return 1 if layered_tiles_flag?((x+Counter_Axis[2]).to_i,(y+Counter_Axis[3]).to_i, 0x80)
    return 0
  end
  def table_passage(x,y,bit)
    layered_tiles(x,y).each do |tile_id|
      flag = tileset.flags[tile_id]
      next if flag & 0x10 != 0
      return true  if flag & bit == 0
      return false if flag & bit == bit
    end
    return false
  end
end
#-------------------------------------------------------------------------------
# * Game_CharacterBase
#-------------------------------------------------------------------------------
class Game_CharacterBase
  include Pixel_Core
  attr_accessor :px
  attr_accessor :py
  attr_accessor :cx
  attr_accessor :cy
  alias kp_public_members init_public_members
  alias kp_moveto moveto
  alias kp_move_straight move_straight
  alias kp_move_diagonal move_diagonal
  alias kp_bush? bush?
  alias kp_ladder? ladder?
  alias kp_terrain_tag terrain_tag
  alias kp_region_id region_id
  def init_public_members
    kp_public_members
    if (Maps.include?($game_map.map_id) rescue false)
      @x = @x.to_f
      @y = @y.to_f
      @pixel = true
    else
      @pixel = false
    end
    @px = (@x*Pixel).to_i
    @py = (@y*Pixel).to_i
    @cx = Default_Collision_X
    @cy = Default_Collision_Y
  end
  def moveto(x,y)
    @pixel = Maps.include?($game_map.map_id)
    kp_moveto(x,y)
    if @pixel
      @x = @x.to_f
      @y = @y.to_f
    end
    @px = (@x*Pixel).to_i
    @py = (@y*Pixel).to_i
  end
  def pixel_passable?(px,py,d)
    nx = px+Tile_Range[d][0]
    ny = py+Tile_Range[d][1]
    return false unless $game_map.pixel_valid?(nx,ny)
    return true if @through || debug_through?
    return false if $game_map.pixel_table[nx,ny,0] == 0
    return false if collision?(nx,ny)
    return true
  end
  def collision?(px,py)
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        next if event.through || event == self
        return true if event.priority_type == 1
      end
    end
    if @priority_type == 1 && !$game_player.in_airship?
      return true if ($game_player.px - px).abs <= @cx && ($game_player.py - py).abs <= @cy
    end
    return false
  end
  def move_straight(d,turn_ok = true)
    @pixel ? move_pixel(d,turn_ok) : kp_move_straight(d,turn_ok)
  end
  def move_diagonal(horz, vert)
    @pixel ? move_dpixel(horz,vert) : kp_move_diagonal(horz,vert)
  end
  def move_pixel(d,t)
    @move_succeed = pixel_passable?(@px,@py,d)
    if @move_succeed
      set_direction(d)
      @px += Tile_Range[d][0]
      @py += Tile_Range[d][1]
      @real_x = @x
      @real_y = @y
      @x += Pixel_Range[d][0]
      @y += Pixel_Range[d][1]
      increase_steps
    elsif t
      set_direction(d)
      front_pixel_touch?(@px + Tile_Range[d][0],@py + Tile_Range[d][1])
    end
  end
  def move_dpixel(h,v)
    ss1 = pixel_passable?(@px,@py,v)
    ss2 = pixel_passable?(@px,@py,h)
    @move_succeed = (ss1 || ss2)
    if @move_succeed
      @real_x = @x
      @real_y = @y
    else
      return
    end
    if ss1
      set_direction(v)
      @px += Tile_Range[v][0]
      @py += Tile_Range[v][1]
      @x += Pixel_Range[v][0]
      @y += Pixel_Range[v][1]
      increase_steps
    else
      set_direction(v)
      front_pixel_touch?(@px + Tile_Range[v][0],@py + Tile_Range[v][1])
    end
    if ss2
      set_direction(h)
      @px += Tile_Range[h][0]
      @py += Tile_Range[h][1]
      @x += Pixel_Range[h][0]
      @y += Pixel_Range[h][1]
      increase_steps
    else
      set_direction(h)
      front_pixel_touch?(@px + Tile_Range[h][0],@py + Tile_Range[h][1])
    end
  end
  def bush?
    return (@pixel ? $game_map.pixel_table[@px, @py, 4] == 1 : kp_bush?)
  end
  def ladder?
    return (@pixel ? $game_map.pixel_table[@px, @py, 3] == 1 : kp_ladder?)
  end
  def terrain_tag
    if @pixel
      rx = ((@px % Pixel) > 1 ? @x.to_i + 1 : @x.to_i)
      ry = ((@py % Pixel) > 1 ? @y.to_i + 1 : @y.to_i)
      return $game_map.terrain_tag(rx,ry)
    else
      return kp_terrain_tag
    end
  end
  def region_id
    if @pixel
      rx = ((@px % Pixel) > 1 ? @x.to_i + 1 : @x.to_i)
      ry = ((@py % Pixel) > 1 ? @y.to_i + 1 : @y.to_i)
      return $game_map.region_id(rx, ry)
    else
      return kp_region_id
    end
  end
  def front_pixel_touch?(x,y)
  end
end
#-------------------------------------------------------------------------------
# * Game_Character
#-------------------------------------------------------------------------------
class Game_Character < Game_CharacterBase
  alias kp_force_move_route force_move_route
  alias kp_move_toward_character move_toward_character
  alias kp_move_away_from_character move_away_from_character
  alias kp_jump jump
  def force_move_route(route)
    kp_force_move_route(route)
    multiply_commands
  end
  def multiply_commands
    return unless @pixel
    return unless Multiply_Commands
    return if @move_route.list.empty?
    new_route = []
    for cmd in @move_route.list
      if Commands.include?(cmd.code)
        Pixel.times do
          new_route << cmd
        end
      else
        new_route << cmd
      end
    end
    @move_route.list = new_route
  end
  def move_toward_character(character)
    if @pixel
      dx = distance_x_from(character.x)
      dy = distance_y_from(character.y)
      if dx == 0
        move_pixel(dy < 0 ? 2 : 8,true)
      else
        if dy == 0 
          move_pixel(dx < 0 ? 6 : 4,true)
        else
          move_dpixel(dx < 0 ? 6 : 4, dy < 0 ? 2 : 8)
        end
      end
    else
      kp_move_toward_character(character)
    end
  end
  def move_away_from_character(character)
    if @pixel
      dx = distance_x_from(character.x)
      dy = distance_y_from(character.y)
      if dx == 0
        move_pixel(dy > 0 ? 2 : 8,true)
      else
        if dy == 0 
          move_pixel(dx > 0 ? 6 : 4,true)
        else
          move_dpixel(dx > 0 ? 6 : 4, dy > 0 ? 2 : 8)
        end
      end
    else
      kp_move_away_from_character(character)
    end
  end
  def jump(xp,yp)
    kp_jump(xp,yp)
    @px = @x*Pixel
    @py = @y*Pixel
  end
end
#-------------------------------------------------------------------------------
# * Game_Player
#-------------------------------------------------------------------------------
class Game_Player < Game_Character
  alias kp_move_by_input move_by_input
  alias kp_on_damage_floor? on_damage_floor?
  alias kp_get_on_off_vehicle get_on_off_vehicle
  alias kp_check_event_trigger_here check_event_trigger_here
  alias kp_check_event_trigger_there check_event_trigger_there
  def encounter_progress_value
    value = bush? ? 2 : 1
    value *= 0.5 if $game_party.encounter_half?
    value *= 0.5 if in_ship?
    value
  end
  def get_on_off_vehicle
    @pixel ? pixel_gov : kp_get_on_off_vehicle
  end
  def pixel_gov
    vehicle ? get_fv : get_nv
  end
  def get_nv
    fx = @px+Trigger_Range[@direction][0]
    fy = @py+Trigger_Range[@direction][1]
    if ($game_map.boat.px - fx).abs <= $game_map.boat.cx && ($game_map.boat.py - fy).abs <= $game_map.boat.cy
      return false if $game_map.pixel_table[@px+Vehicle_Range[@direction][0],@py+Vehicle_Range[@direction][1],1] == 0
      jump(Vehicle_Range[@direction][0]*Tile,Vehicle_Range[@direction][1]*Tile)
      @vehicle_type = :boat    
      @vehicle_getting_on = true
      @followers.gather
    elsif ($game_map.ship.px - fx).abs <= $game_map.ship.cx && ($game_map.ship.py - fy).abs <= $game_map.ship.cy
      return false if $game_map.pixel_table[@px+Vehicle_Range[@direction][0],@py+Vehicle_Range[@direction][1],2] == 0
      jump(Vehicle_Range[@direction][0]*Tile,Vehicle_Range[@direction][1]*Tile)
      @vehicle_type = :ship
      @vehicle_getting_on = true
      @followers.gather
    elsif ($game_map.airship.px - fx).abs <= $game_map.airship.cx && ($game_map.airship.py - fy).abs <= $game_map.airship.cy
      $game_player.centralize($game_map.airship.x,$game_map.airship.y)
      @vehicle_type = :airship 
      @vehicle_getting_on = true
      @followers.gather
    end
    return @vehicle_getting_on
  end
  def get_fv
    if in_airship?
      return unless pixel_airdocs?(@px,@py)
      set_direction(2)
    else
      fx = @px+Vehicle_Range[@direction][0]
      fy = @py+Vehicle_Range[@direction][1]
      return unless pixel_walk?(fx,fy)
      jump(Vehicle_Range[@direction][0]*Tile,Vehicle_Range[@direction][1]*Tile)
      @transparent = false
    end
    @followers.synchronize(@x, @y, @direction)
    vehicle.get_off
    @vehicle_getting_off = true
    @move_speed = 4
    @through = false
    make_encounter_count
    @followers.gather
  end
  def pixel_airdocs?(px,py)
    return false if $game_map.pixel_table[px,py,0] == 0
    return false if $game_map.pixel_table[px,py,4] == 1 && !Airship_Bush
    return false if collision?(px,py)
    return true
  end
  def pixel_walk?(px,py)
    return false if $game_map.pixel_table[px,py,0] == 0
    return false if collision?(px,py)
    return true
  end
  def centralize(fx=@x.to_i,fy=@y.to_i)
    cx = @x - fx
    cy = @y - fy
    tx = (cx/Tile).to_i
    ty = (cy/Tile).to_i
    tx.times do; move_pixel(cx > 0 ? 4 : 6,false); end
    ty.times do; move_pixel(cy > 0 ? 8 : 2,false); end
  end
  def check_event_trigger_here(triggers)
    if @pixel
      for event in $game_map.events.values
        if (event.px - @px).abs <= event.cx && (event.py - @py).abs <= event.cy
          event.start if triggers.include?(event.trigger) && event.priority_type != 1
        end
      end
    else
      kp_check_event_trigger_here(triggers)
    end
  end
  def check_event_trigger_there(triggers)
    if @pixel
      fx = @px+Trigger_Range[@direction][0]
      fy = @py+Trigger_Range[@direction][1]
      for event in $game_map.events.values
        if (event.px - fx).abs <= event.cx && (event.py - fy).abs <= event.cy
          if triggers.include?(event.trigger) && event.normal_priority?
            event.start
            return
          end
        end
      end
      if $game_map.pixel_table[fx,fy,5] == 1
        fx += Counter_Range[@direction][0]
        fy += Counter_Range[@direction][1]
        for event in $game_map.events.values
          if (event.px - fx).abs <= event.cx && (event.py - fy).abs <= event.cy
            if triggers.include?(event.trigger) && event.normal_priority?
              event.start
              return
            end
          end
        end
      end
    else
      kp_check_event_trigger_there(triggers)
    end
  end
  def front_pixel_touch?(px,py)
    return if $game_map.interpreter.running?
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        if [1,2].include?(event.trigger) && event.normal_priority?
          event.start
          result = true
        end
      end
    end
  end
  def pixel_passable?(px,py,d)
    nx = px+Tile_Range[d][0]
    ny = py+Tile_Range[d][1]
    return false unless $game_map.pixel_valid?(nx,ny)
    return true if @through || debug_through?
    case @vehicle_type
    when :boat
      return false if $game_map.pixel_table[nx,ny,1] == 0
    when :ship
      return false if $game_map.pixel_table[nx,ny,2] == 0
    when :airship
      return true
    else
      return false if $game_map.pixel_table[nx,ny,0] == 0
    end
    return false if collision?(nx,ny)
    return true
  end
  def move_by_input
    @pixel ? pixel_move_by_input : kp_move_by_input
  end
  def pixel_move_by_input
    return if !movable? || $game_map.interpreter.running?
    case Input.dir8
      when 1; move_dpixel(4,2)
      when 2; move_pixel(2,true)
      when 3; move_dpixel(6,2)
      when 4; move_pixel(4,true)
      when 6; move_pixel(6,true)
      when 7; move_dpixel(4,8)
      when 8; move_pixel(8,true)
      when 9; move_dpixel(6,8)
    end
  end
  def on_damage_floor?
    return (@pixel ? false : kp_on_damage_floor?)
  end
  def collision?(px,py)
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        next if event.through
        return true if event.priority_type == 1
      end
    end
    return false
  end
  def move_pixel(d,t)
    super(d,t)
    @followers.move
  end
  def move_dpixel(h,v)
    super(h,v)
    @followers.move
  end
end
#-------------------------------------------------------------------------------
# * Game_Follower
#-------------------------------------------------------------------------------
class Game_Follower < Game_Character
  alias kp_chase_preceding_character chase_preceding_character
  alias kp_initialize initialize
  attr_accessor :through
  def initialize(i,p)
    kp_initialize(i,p)
    @through = false
  end
  def chase_preceding_character
    if @pixel
      return if moving?
      if $game_player.followers.gathering?
        dx = distance_x_from($game_player.x)
        dy = distance_y_from($game_player.y)
        if dx.abs < Follow_Distance
          if dy.abs < Follow_Distance
            return if gather?
            $game_player.in_airship? ? move_toward_character(@preceding_character) : jump(-dx,-dy)
          else
            move_pixel(dy < 0 ? 2 : 8,true)
          end
        else
          if dy.abs < Follow_Distance 
            move_pixel(dx < 0 ? 6 : 4,true)
          else
            move_dpixel(dx < 0 ? 6 : 4, dy < 0 ? 2 : 8)
          end
        end
      else
        dx = distance_x_from(@preceding_character.x)
        dy = distance_y_from(@preceding_character.y)
        if dx.abs < Follow_Distance
          unless dy.abs < Follow_Distance
            move_pixel(dy < 0 ? 2 : 8,true) 
            unless @move_succeed
              return if dx == 0 && dy == 0
              move_dpixel(dx < 0 ? 6 : 4, dy < 0 ? 2 : 8)
            end
          end
        else
          if dy.abs < Follow_Distance 
            move_pixel(dx < 0 ? 6 : 4,true)
            unless @move_succeed
              return if dx == 0 && dy == 0
              move_dpixel(dx < 0 ? 6 : 4, dy < 0 ? 2 : 8)
            end
          else
            move_dpixel(dx < 0 ? 6 : 4, dy < 0 ? 2 : 8)
          end
        end
      end
    else
      kp_chase_preceding_character
    end
  end
  def collision?(px,py)
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        next if event.through || event == self
        return true if event.priority_type == 1
      end
    end
    return false
  end
  def gather?
    result = !moving? && pos?(@preceding_character.x, @preceding_character.y)
    @through = !result
    return result
  end
end
#-------------------------------------------------------------------------------
# * Game_Followers
#-------------------------------------------------------------------------------
class Game_Followers
  alias kp_gather gather
  def gather
    kp_gather
    each { |char| char.through = true}
  end
end
#-------------------------------------------------------------------------------
# * Game_Vehicle
#-------------------------------------------------------------------------------
class Game_Vehicle < Game_Character
  alias kp_set_location set_location
  alias kp_sync_with_player sync_with_player
  def set_location(map_id, x, y)
    @px = (@x*Pixel).to_i
    @py = (@y*Pixel).to_i
    kp_set_location(map_id,x.to_f,y.to_f)
  end
  def sync_with_player
    @px = $game_player.px
    @py = $game_player.py
    kp_sync_with_player
  end
end
#-------------------------------------------------------------------------------
# * Game_Event
#-------------------------------------------------------------------------------
class Game_Event < Game_Character
  alias kp_move_type_toward_player move_type_toward_player
  alias kp_initialize initialize
  alias kp_setup_page_settings setup_page_settings
  def initialize(m,e)
    kp_initialize(m,e)
    setup_collision
  end
  def move_type_toward_player
    if @pixel
      move_toward_player if near_the_player?
    else
      kp_move_type_toward_player
    end
  end
  def setup_page_settings
    kp_setup_page_settings
    setup_collision
    multiply_commands
  end
  def collision?(px,py)
    for event in $game_map.events.values
      if (event.px - px).abs <= event.cx && (event.py - py).abs <= event.cy
        next if event.through || event == self
        return true if event.priority_type == 1
      end
    end
    if @priority_type == 1 && !$game_player.in_airship?
      return true if ($game_player.px - px).abs <= @cx && ($game_player.py - py).abs <= @cy
      for follower in $game_player.followers.visible_folloers
        return true if (follower.px - px).abs <= @cx && (follower.py - py).abs <= @cy
      end
    end
    return false
  end
  def setup_collision
    @cx = Default_Collision_X
    @cy = Default_Collision_Y
    unless @list.nil?
      for value in 0...@list.size
        next if @list[value].code != 108 && @list[value].code != 408
        if @list[value].parameters[0].include?("[collision_x ")
          @list[value].parameters[0].scan(/\[collision_x ([0.0-9.9]+)\]/)
          @cx = $1.to_i
        end
        if @list[value].parameters[0].include?("[collision_y ")
          @list[value].parameters[0].scan(/\[collision_y ([0.0-9.9]+)\]/)
          @cy = $1.to_i
        end
      end
    end
  end
  def front_pixel_touch?(px,py)
    return if $game_map.interpreter.running? || !$game_player.normal_walk?
    if @trigger == 2 && ($game_player.px - px).abs <= @cx && ($game_player.py - py).abs <= @cy
      start if !jumping? && normal_priority?
    end
  end
end
