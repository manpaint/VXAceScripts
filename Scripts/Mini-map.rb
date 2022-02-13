
 
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ ミニマップ - KMS_MiniMap ◆ VX Ace ◆
#_/    ◇ Last update : 2012/02/12  (TOMY@Kamesoft) ◇ 
#_/----------------------------------------------------------------------------
#_/  ミニマップ表示機能を追加します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
 
#==============================================================================
# ★ 設定項目 - BEGIN Setting ★
#==============================================================================
 
module KMS_MiniMap
  # ◆ ミニマップ表示切替ボタン
  #  nil にするとボタン切り替え無効。
  SWITCH_BUTTON = :Z #c'est le boutton D
 
  # ◆ ミニマップ表示位置・サイズ (X, Y, 幅, 高さ) Position de la minicarte dans le jeu
  MAP_RECT = Rect.new(364, 20, 160, 120)
  # ◆ ミニマップの Z 座標
  #  大きくしすぎると色々なものに被ります。
  MAP_Z = 0
  # ◆ １マスのサイズ
  #  3 以上を推奨。
  GRID_SIZE = 5
 
  # ◆ ミニマップカラー
  FOREGROUND_COLOR = Color.new(224, 224, 255, 160)  # 前景色 (通行可)
  BACKGROUND_COLOR = Color.new(  0,   0,   0, 160)  # 背景色 (通行不可)
  POSITION_COLOR   = Color.new(255,   0,   0, 192)  # 現在位置 joueur
  MOVE_EVENT_COLOR = Color.new(255, 160,   0, 100) # マップ移動イベント tout les events
  VEHICLE_COLOR    = Color.new( 96, 128,   0, 192)  # 乗り物 
 
  # ◆ オブジェクトの色 (Red, Green, Blue, Opacity)
  #  要素の先頭から順に OBJ1, OBJ2, ... に対応。
  OBJECT_COLOR = [
    Color.new(255,   0,   0, 192),  # OBJ 1 -> Ennemi (rouge)
    Color.new(  0, 160, 160, 192),  # OBJ 2 -> membre du groupe (cyan)
    Color.new(160,   0, 160, 192),  # OBJ 3 -> marchand (violet)
    Color.new(204, 204,   0, 192),  # OBJ 4 -> item, tresors (jaune)
    Color.new(255, 255, 255, 192),  # OBJ 5 -> (bleu marine)
    Color.new(  0, 128,   0, 192),  # OBJ 6 -> PNJ (vert)
  ]  # ← この ] は消さないこと！Ne pas toucher cette ligne
 
  # ◆ アイコンの点滅の強さ lumière clignotante
  #  5 ～ 8 あたりを推奨。 a definir entre 5 et 8.
  BLINK_LEVEL = 7
 
  # ◆ マップのキャッシュ数
  #  この数を超えると、長期間参照していないものから削除。
  CACHE_NUM = 10
end
 
#==============================================================================
# ☆ 設定ここまで - END Setting ☆
#==============================================================================
 
$kms_imported = {} if $kms_imported == nil
$kms_imported["MiniMap"] = true
 
module KMS_MiniMap
  # ミニマップ非表示 hoter la mini map 
  # il faut mettre dans la "note" de la map : <cacherminicarte>
  REGEX_NO_MINIMAP_NOTE = /<cacherminicarte>/i   # /<(?:cacher|MINIMAP)\s*(?:minicarte|HIDE)>/i -> c'est celui d'origine
  REGEX_NO_MINIMAP_NAME = /\[NOMAP\]/i
 
  
  # 障害物 L'event va apparaitre sur la carte comme une partie inccessible.
  # il faut mettre en "commentaire" dans l'event : <obstacle>
  REGEX_WALL_EVENT =   /<obstacle>/i   # /<(?:ミニマップ|MINIMAP)\s*(?:壁|障害物|WALL)>/i -> c'est celui d'origine
 
  # 移動イベント Pour voir les Events qui n'ont pas d'utilité fixe.
  # il faut mettre en "commentaire" dans l'event : <envent>
  REGEX_MOVE_EVENT =  /<envent>/i  #/<(?:ミニマップ|MINIMAP)\s*(?:移動|MOVE)>/i -> c'est celui d'origine
 
  # オブジェクト Donne une couleurs particulière aux évent. A définir à la ligne 36->41:
  #Possibilité d'en rajouter à volonté. Utile pour donner une couleur aux events un peu plus important.
  # il faut mettre en "commentaire" dans l'event : <objet objN> -> exemple <objet obj1>
  REGEX_OBJECT = /<(?:objet|MINIMAP)\s+OBJ(?:ECT)?\s*(\d+)>/i
end
 
# *****************************************************************************
 
#==============================================================================
# □ KMS_Commands
#==============================================================================
 
module KMS_Commands
  module_function
  #--------------------------------------------------------------------------
  # ○ ミニマップを表示 J'affiche une mini-carte
  #--------------------------------------------------------------------------
  def show_minimap
    $game_temp.minimap_manual_visible = false
    $game_system.minimap_show         = true
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップを隠す Je cache une mini-carte
  #--------------------------------------------------------------------------
  def hide_minimap
    $game_system.minimap_show = false
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ表示状態の取得 
  #--------------------------------------------------------------------------
  def minimap_showing?
    return $game_system.minimap_show
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップをリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_minimap
    return unless SceneManager.scene_is?(Scene_Map)
 
    $game_map.refresh if $game_map.need_refresh
    SceneManager.scene.refresh_minimap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップのオブジェクトを更新
  #--------------------------------------------------------------------------
  def update_minimap_object
    return unless SceneManager.scene_is?(Scene_Map)
 
    $game_map.refresh if $game_map.need_refresh
    SceneManager.scene.update_minimap_object
  end
end
 
#==============================================================================
# ■ Game_Interpreter
#==============================================================================
 
class Game_Interpreter
  # イベントコマンドから直接コマンドを叩けるようにする
  include KMS_Commands
end
 
#==============================================================================
# ■ RPG::Map
#==============================================================================
 
class RPG::Map
  #--------------------------------------------------------------------------
  # ○ ミニマップのキャッシュ生成
  #--------------------------------------------------------------------------
  def create_minimap_cache
    @__minimap_show = true
 
    note.each_line { |line|
      if line =~ KMS_MiniMap::REGEX_NO_MINIMAP_NOTE  # マップ非表示
        @__minimap_show = false
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ表示
  #--------------------------------------------------------------------------
  def minimap_show?
    create_minimap_cache if @__minimap_show.nil?
    return @__minimap_show
  end
end
 
#==============================================================================
# ■ RPG::MapInfo
#==============================================================================
 
class RPG::MapInfo
  #--------------------------------------------------------------------------
  # ● マップ名取得
  #--------------------------------------------------------------------------
  def name
    return @name.gsub(/\[.*\]/) { "" }
  end
  #--------------------------------------------------------------------------
  # ○ オリジナルマップ名取得
  #--------------------------------------------------------------------------
  def original_name
    return @name
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップのキャッシュ生成
  #--------------------------------------------------------------------------
  def create_minimap_cache
    @__minimap_show = !(@name =~ KMS_MiniMap::REGEX_NO_MINIMAP_NAME)
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ表示
  #--------------------------------------------------------------------------
  def minimap_show?
    create_minimap_cache if @__minimap_show == nil
    return @__minimap_show
  end
end
 
#==============================================================================
# ■ Game_Temp
#==============================================================================
 
class Game_Temp
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :minimap_manual_visible  # ミニマップ手動表示切り替えフラグ
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KMS_MiniMap initialize
  def initialize
    initialize_KMS_MiniMap
 
    @minimap_manual_visible = true
  end
end
 
#==============================================================================
# ■ Game_System
#==============================================================================
 
class Game_System
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :minimap_show  # ミニマップ表示フラグ
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KMS_MiniMap initialize
  def initialize
    initialize_KMS_MiniMap
 
    @minimap_show = true
  end
end
 
#==============================================================================
# ■ Game_Map
#==============================================================================
 
class Game_Map
  #--------------------------------------------------------------------------
  # ○ 定数 le nombre fixe
  #--------------------------------------------------------------------------
  MINIMAP_FADE_NONE = 0  # ミニマップ フェードなし Il n'y a aucune disparition de la carte
  MINIMAP_FADE_IN   = 1  # ミニマップ フェードイン Mini-carte s'efface in
  MINIMAP_FADE_OUT  = 2  # ミニマップ フェードアウト Mini-carte s'efface out
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :minimap_fade
  #--------------------------------------------------------------------------
  # ○ ミニマップを表示するか
  #--------------------------------------------------------------------------
  def minimap_show?
    return $data_mapinfos[map_id].minimap_show? && @map.minimap_show?
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップをフェードイン
  #--------------------------------------------------------------------------
  def fadein_minimap
    @minimap_fade = MINIMAP_FADE_IN
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップをフェードアウト
  #--------------------------------------------------------------------------
  def fadeout_minimap
    @minimap_fade = MINIMAP_FADE_OUT
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_KMS_MiniMap refresh
  def refresh
    refresh_KMS_MiniMap
 
    SceneManager.scene.refresh_minimap if SceneManager.scene_is?(Scene_Map)
  end
end
 
#==============================================================================
# ■ Game_Event
#==============================================================================
 
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # ○ ミニマップ用のキャッシュを作成
  #--------------------------------------------------------------------------
  def __create_minimap_cache
    @__last_page = @page
    @__minimap_wall_event  = false
    @__minimap_move_event  = false # Rend visible ou invisible la totalité des évents .Atention, les évent innactif et ceux servant aux scénario apparaisse aussi
    @__minimap_object_type = -1
 
    return if @page.nil?
 
    @page.list.each { |cmd|
      # 注釈以外に到達したら離脱
      break unless [108, 408].include?(cmd.code)
 
      # 正規表現判定
      case cmd.parameters[0]
      when KMS_MiniMap::REGEX_WALL_EVENT
        @__minimap_wall_event = true
      when KMS_MiniMap::REGEX_MOVE_EVENT
        @__minimap_move_event = true
      when KMS_MiniMap::REGEX_OBJECT
        @__minimap_object_type = $1.to_i
      end
    }
  end
  private :__create_minimap_cache
  #--------------------------------------------------------------------------
  # ○ グラフィックがあるか
  #--------------------------------------------------------------------------
  def graphic_exist?
    return (character_name != "" || tile_id > 0)
  end
  #--------------------------------------------------------------------------
  # ○ 障害物か
  #--------------------------------------------------------------------------
  def is_minimap_wall_event?
    if @__minimap_wall_event.nil? || @__last_page != @page
      __create_minimap_cache
    end
 
    return @__minimap_wall_event
  end
  #--------------------------------------------------------------------------
  # ○ 移動イベントか
  #--------------------------------------------------------------------------
  def is_minimap_move_event?
    if @__minimap_move_event.nil? || @__last_page != @page
      __create_minimap_cache
    end
 
    return @__minimap_move_event
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップオブジェクトか
  #--------------------------------------------------------------------------
  def is_minimap_object?
    if @__minimap_object_type.nil? || @__last_page != @page
      __create_minimap_cache
    end
 
    return @__minimap_object_type > 0
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップオブジェクトタイプ
  #--------------------------------------------------------------------------
  def minimap_object_type
    if @__minimap_object_type.nil? || @__last_page != @page
      __create_minimap_cache
    end
 
    return @__minimap_object_type
  end
end
 
#==============================================================================
# □ Game_MiniMap
#------------------------------------------------------------------------------
#   ミニマップを扱うクラスです。
#==============================================================================
 
class Game_MiniMap
  #--------------------------------------------------------------------------
  # ○ 構造体
  #--------------------------------------------------------------------------
  Point = Struct.new(:x, :y)
  Size  = Struct.new(:width, :height)
  PassageCache = Struct.new(:map_id, :table, :scan_table)
  #--------------------------------------------------------------------------
  # ○ クラス変数
  #--------------------------------------------------------------------------
  @@passage_cache = []  # 通行フラグテーブルキャッシュ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(tilemap)
    @map_rect  = KMS_MiniMap::MAP_RECT
    @grid_size = [KMS_MiniMap::GRID_SIZE, 1].max
 
    @x = 0
    @y = 0
    @grid_num = Point.new(
      (@map_rect.width  + @grid_size - 1) / @grid_size,
      (@map_rect.height + @grid_size - 1) / @grid_size
    )
    @draw_grid_num    = Point.new(@grid_num.x + 2, @grid_num.y + 2)
    @draw_range_begin = Point.new(0, 0)
    @draw_range_end   = Point.new(0, 0)
    @tilemap = tilemap
 
    @last_x = $game_player.x
    @last_y = $game_player.y
 
    @showing = false
    @hiding  = false
 
    create_sprites
    refresh
 
    unless $game_temp.minimap_manual_visible
      self.opacity = 0
    end
  end
  #--------------------------------------------------------------------------
  # ○ スプライト作成
  #--------------------------------------------------------------------------
  def create_sprites
    @viewport   = Viewport.new(@map_rect)
    @viewport.z = KMS_MiniMap::MAP_Z
 
    # ビットマップサイズ計算
    @bmp_size = Size.new(
      (@grid_num.x + 2) * @grid_size,
      (@grid_num.y + 2) * @grid_size
    )
    @buf_bitmap = Bitmap.new(@bmp_size.width, @bmp_size.height)
 
    # マップ用スプライト作成
    @map_sprite   = Sprite.new(@viewport)
    @map_sprite.x = -@grid_size
    @map_sprite.y = -@grid_size
    @map_sprite.z = 0
    @map_sprite.bitmap = Bitmap.new(@bmp_size.width, @bmp_size.height)
 
    # オブジェクト用スプライト作成
    @object_sprite   = Sprite_MiniMapIcon.new(@viewport)
    @object_sprite.x = -@grid_size
    @object_sprite.y = -@grid_size
    @object_sprite.z = 1
    @object_sprite.bitmap = Bitmap.new(@bmp_size.width, @bmp_size.height)
 
    # 現在位置スプライト作成
    @position_sprite   = Sprite_MiniMapIcon.new
    @position_sprite.x = @map_rect.x + @grid_num.x / 2 * @grid_size
    @position_sprite.y = @map_rect.y + @grid_num.y / 2 * @grid_size
    @position_sprite.z = @viewport.z + 2
    bitmap = Bitmap.new(@grid_size, @grid_size)
    bitmap.fill_rect(bitmap.rect, KMS_MiniMap::POSITION_COLOR)
    @position_sprite.bitmap = bitmap
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @buf_bitmap.dispose
    @map_sprite.bitmap.dispose
    @map_sprite.dispose
    @object_sprite.bitmap.dispose
    @object_sprite.dispose
    @position_sprite.bitmap.dispose
    @position_sprite.dispose
    @viewport.dispose
  end
  #--------------------------------------------------------------------------
  # ○ 可視状態取得
  #--------------------------------------------------------------------------
  def visible
    return @map_sprite.visible
  end
  #--------------------------------------------------------------------------
  # ○ 可視状態設定
  #--------------------------------------------------------------------------
  def visible=(value)
    @viewport.visible        = value
    @map_sprite.visible      = value
    @object_sprite.visible   = value
    @position_sprite.visible = value
  end
  #--------------------------------------------------------------------------
  # ○ 不透明度取得
  #--------------------------------------------------------------------------
  def opacity
    return @map_sprite.opacity
  end
  #--------------------------------------------------------------------------
  # ○ 不透明度設定
  #--------------------------------------------------------------------------
  def opacity=(value)
    @map_sprite.opacity      = value
    @object_sprite.opacity   = value
    @position_sprite.opacity = value
  end
  #--------------------------------------------------------------------------
  # ○ リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    update_draw_range
    update_passage_table
    update_object_list
    update_position
    draw_map
    draw_object
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ○ フェードイン
  #--------------------------------------------------------------------------
  def fadein
    @showing = true
    @hiding  = false
  end
  #--------------------------------------------------------------------------
  # ○ フェードアウト
  #--------------------------------------------------------------------------
  def fadeout
    @showing = false
    @hiding  = true
  end
  #--------------------------------------------------------------------------
  # ○ キー入力更新
  #--------------------------------------------------------------------------
  def update_input
    return if KMS_MiniMap::SWITCH_BUTTON.nil?
 
    if Input.trigger?(KMS_MiniMap::SWITCH_BUTTON)
      if opacity < 255 && !@showing
        $game_temp.minimap_manual_visible = true
        fadein
      elsif opacity > 0 && !@hiding
        $game_temp.minimap_manual_visible = false
        fadeout
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ 描画範囲更新
  #--------------------------------------------------------------------------
  def update_draw_range
    range = []
    (2).times { |i| range[i] = @draw_grid_num[i] / 2 }
 
    @draw_range_begin.x = $game_player.x - range[0]
    @draw_range_begin.y = $game_player.y - range[1]
    @draw_range_end.x   = $game_player.x + range[0]
    @draw_range_end.y   = $game_player.y + range[1]
  end
  #--------------------------------------------------------------------------
  # ○ 通行可否テーブル更新
  #--------------------------------------------------------------------------
  def update_passage_table
    cache = get_passage_table_cache
    @passage_table      = cache.table
    @passage_scan_table = cache.scan_table
 
    update_around_passage_table
  end
  #--------------------------------------------------------------------------
  # ○ 通行可否テーブルのキャッシュを取得
  #--------------------------------------------------------------------------
  def get_passage_table_cache
    map_id = $game_map.map_id
    cache  = @@passage_cache.find { |c| c.map_id == map_id }
 
    # キャッシュミスしたら新規作成
    if cache == nil
      cache = PassageCache.new(map_id)
      cache.table      = Table.new($game_map.width, $game_map.height)
      cache.scan_table = Table.new(
        ($game_map.width  + @draw_grid_num.x - 1) / @draw_grid_num.x,
        ($game_map.height + @draw_grid_num.y - 1) / @draw_grid_num.y
      )
    end
 
    # 直近のキャッシュは先頭に移動し、古いキャッシュは削除
    @@passage_cache.unshift(cache)
    @@passage_cache.delete_at(KMS_MiniMap::CACHE_NUM)
 
    return cache
  end
  #--------------------------------------------------------------------------
  # ○ 通行可否テーブルのキャッシュをクリア
  #--------------------------------------------------------------------------
  def clear_passage_table_cache
    return if @passage_scan_table == nil
 
    table = @passage_scan_table
    @passage_scan_table = Table.new(table.xsize, table.ysize)
  end
  #--------------------------------------------------------------------------
  # ○ 通行可否テーブルの探索
  #     x, y : 探索位置
  #--------------------------------------------------------------------------
  def scan_passage(x, y)
    dx = x / @draw_grid_num.x
    dy = y / @draw_grid_num.y
 
    # 探索済み
    return if @passage_scan_table[dx, dy] == 1
 
    # マップ範囲外
    return unless dx.between?(0, @passage_scan_table.xsize - 1)
    return unless dy.between?(0, @passage_scan_table.ysize - 1)
 
    rx = (dx * @draw_grid_num.x)...((dx + 1) * @draw_grid_num.x)
    ry = (dy * @draw_grid_num.y)...((dy + 1) * @draw_grid_num.y)
    mw = $game_map.width  - 1
    mh = $game_map.height - 1
 
    # 探索範囲内の通行テーブルを生成
    rx.each { |x|
      next unless x.between?(0, mw)
      ry.each { |y|
        next unless y.between?(0, mh)
 
        # 通行方向フラグ作成
        # (↓、←、→、↑ の順に 1, 2, 4, 8 が対応)
        flag = 0
        [2, 4, 6, 8].each{ |d|
          flag |= 1 << (d / 2 - 1) if $game_map.passable?(x, y, d)
        }
        @passage_table[x, y] = flag
      }
    }
    @passage_scan_table[dx, dy] = 1
  end
  #--------------------------------------------------------------------------
  # ○ 周辺の通行可否テーブル更新
  #--------------------------------------------------------------------------
  def update_around_passage_table
    gx = @draw_grid_num.x
    gy = @draw_grid_num.y
    dx = $game_player.x - gx / 2
    dy = $game_player.y - gy / 2
    scan_passage(dx,      dy)
    scan_passage(dx + gx, dy)
    scan_passage(dx,      dy + gy)
    scan_passage(dx + gx, dy + gy)
  end
  #--------------------------------------------------------------------------
  # ○ オブジェクト一覧更新
  #--------------------------------------------------------------------------
  def update_object_list
    events = $game_map.events.values
 
    # WALL
    @wall_events = events.find_all { |e| e.is_minimap_wall_event? }
 
    # MOVE
    @move_events = events.find_all { |e| e.is_minimap_move_event? }
 
    # OBJ
    @object_list = events.find_all { |e| e.is_minimap_object? }
  end
  #--------------------------------------------------------------------------
  # ○ 位置更新
  #--------------------------------------------------------------------------
  def update_position
    # 移動量算出
    pt = Point.new($game_player.x, $game_player.y)
    ox = ($game_player.real_x - pt.x) * @grid_size
    oy = ($game_player.real_y - pt.y) * @grid_size
 
    @viewport.ox = ox
    @viewport.oy = oy
 
    # 移動していたらマップ再描画
    if pt.x != @last_x || pt.y != @last_y
      draw_map
      @last_x = pt.x
      @last_y = pt.y
    end
  end
  #--------------------------------------------------------------------------
  # ○ 描画範囲内判定
  #--------------------------------------------------------------------------
  def in_draw_range?(x, y)
    rb = @draw_range_begin
    re = @draw_range_end
    return (x.between?(rb.x, re.x) && y.between?(rb.y, re.y))
  end
  #--------------------------------------------------------------------------
  # ○ マップ範囲内判定
  #--------------------------------------------------------------------------
  def in_map_range?(x, y)
    mw = $game_map.width
    mh = $game_map.height
    return (x.between?(0, mw - 1) && y.between?(0, mh - 1))
  end
  #--------------------------------------------------------------------------
  # ○ マップ描画
  #--------------------------------------------------------------------------
  def draw_map
    update_around_passage_table
 
    bitmap  = @map_sprite.bitmap
    bitmap.fill_rect(bitmap.rect, KMS_MiniMap::BACKGROUND_COLOR)
 
    draw_map_foreground(bitmap)
    draw_map_move_event(bitmap)
  end
  #--------------------------------------------------------------------------
  # ○ 通行可能領域の描画
  #--------------------------------------------------------------------------
  def draw_map_foreground(bitmap)
    range_x = (@draw_range_begin.x)..(@draw_range_end.x)
    range_y = (@draw_range_begin.y)..(@draw_range_end.y)
    map_w   = $game_map.width  - 1
    map_h   = $game_map.height - 1
    rect    = Rect.new(0, 0, @grid_size, @grid_size)
 
    range_x.each { |x|
      next unless x.between?(0, map_w)
      range_y.each { |y|
        next unless y.between?(0, map_h)
        next if @passage_table[x, y] == 0
        next if @wall_events.find { |e| e.x == x && e.y == y }  # 壁
 
        # グリッド描画サイズ算出
        rect.set(0, 0, @grid_size, @grid_size)
        rect.x = (x - @draw_range_begin.x) * @grid_size
        rect.y = (y - @draw_range_begin.y) * @grid_size
        flag = @passage_table[x, y]
        if flag & 0x01 == 0  # 下通行不能
          rect.height -= 1
        end
        if flag & 0x02 == 0  # 左通行不能
          rect.x     += 1
          rect.width -= 1
        end
        if flag & 0x04 == 0  # 右通行不能
          rect.width -= 1
        end
        if flag & 0x08 == 0  # 上通行不能
          rect.y      += 1
          rect.height -= 1
        end
        bitmap.fill_rect(rect, KMS_MiniMap::FOREGROUND_COLOR)
      }
    }
  end
  #--------------------------------------------------------------------------
  # ○ 移動イベントの描画
  #--------------------------------------------------------------------------
  def draw_map_move_event(bitmap)
    rect = Rect.new(0, 0, @grid_size, @grid_size)
    @move_events.each { |e|
      rect.x = (e.x - @draw_range_begin.x) * @grid_size
      rect.y = (e.y - @draw_range_begin.y) * @grid_size
      bitmap.fill_rect(rect, KMS_MiniMap::MOVE_EVENT_COLOR)
    }
  end
  #--------------------------------------------------------------------------
  # ○ アニメーション更新
  #--------------------------------------------------------------------------
  def update_animation
    if @showing
      # フェードイン
      self.opacity += 16
      if opacity == 255
        @showing = false
      end
    elsif @hiding
      # フェードアウト
      self.opacity -= 16
      if opacity == 0
        @hiding = false
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ オブジェクト描画
  #--------------------------------------------------------------------------
  def draw_object
    # 下準備
    bitmap = @object_sprite.bitmap
    bitmap.clear
    rect = Rect.new(0, 0, @grid_size, @grid_size)
 
    # オブジェクト描画
    @object_list.each { |obj|
      next unless in_draw_range?(obj.x, obj.y)
 
      color = KMS_MiniMap::OBJECT_COLOR[obj.minimap_object_type - 1]
      next if color.nil?
 
      rect.x = (obj.real_x - @draw_range_begin.x) * @grid_size
      rect.y = (obj.real_y - @draw_range_begin.y) * @grid_size
      bitmap.fill_rect(rect, color)
    }
 
    # 乗り物描画
    $game_map.vehicles.each { |vehicle|
      next if vehicle.transparent
 
      rect.x = (vehicle.real_x - @draw_range_begin.x) * @grid_size
      rect.y = (vehicle.real_y - @draw_range_begin.y) * @grid_size
      bitmap.fill_rect(rect, KMS_MiniMap::VEHICLE_COLOR)
    }
  end
  #--------------------------------------------------------------------------
  # ○ 更新
  #--------------------------------------------------------------------------
  def update
    update_input
 
    return unless need_update?
 
    update_draw_range
    update_position
    update_animation
    draw_object
 
    @map_sprite.update
    @object_sprite.update
    @position_sprite.update
  end
  #--------------------------------------------------------------------------
  # ○ 更新判定
  #--------------------------------------------------------------------------
  def need_update?
    return (visible && opacity > 0) || @showing || @hiding
  end
end
 
#==============================================================================
# □ Sprite_MiniMapIcon
#------------------------------------------------------------------------------
#   ミニマップ用アイコンのクラスです。
#==============================================================================
 
class Sprite_MiniMapIcon < Sprite
  DURATION_MAX = 60
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     viewport : ビューポート
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    @duration = DURATION_MAX / 2
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @duration += 1
    if @duration == DURATION_MAX
      @duration = 0
    end
    update_effect
  end
  #--------------------------------------------------------------------------
  # ○ エフェクトの更新
  #--------------------------------------------------------------------------
  def update_effect
    self.color.set(255, 255, 255,
      (@duration - DURATION_MAX / 2).abs * KMS_MiniMap::BLINK_LEVEL
    )
  end
end
 
#==============================================================================
# ■ Spriteset_Map
#==============================================================================
 
class Spriteset_Map
  attr_reader :minimap
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KMS_MiniMap initialize
  def initialize
    initialize_KMS_MiniMap
 
    create_minimap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップの作成
  #--------------------------------------------------------------------------
  def create_minimap
    @minimap = Game_MiniMap.new(@tilemap)
    @minimap.visible = $game_system.minimap_show && $game_map.minimap_show?
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias dispose_KMS_MiniMap dispose
  def dispose
    dispose_KMS_MiniMap
 
    dispose_minimap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップの解放
  #--------------------------------------------------------------------------
  def dispose_minimap
    @minimap.dispose
    @minimap = nil
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_KMS_MiniMap update
  def update
    update_KMS_MiniMap
 
    update_minimap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ更新
  #--------------------------------------------------------------------------
  def minimap_show?
    return $game_map.minimap_show? && $game_system.minimap_show
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ更新
  #--------------------------------------------------------------------------
  def update_minimap
    return if @minimap.nil?
 
    # 表示切替
    if minimap_show?
      @minimap.visible = true
    else
      @minimap.visible = false
      return
    end
 
    # フェード判定
    case $game_map.minimap_fade
    when Game_Map::MINIMAP_FADE_IN
      @minimap.fadein
      $game_map.minimap_fade = Game_Map::MINIMAP_FADE_NONE
    when Game_Map::MINIMAP_FADE_OUT
      @minimap.fadeout
      $game_map.minimap_fade = Game_Map::MINIMAP_FADE_NONE
    end
 
    @minimap.update
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ全体をリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_minimap
    return if @minimap.nil?
 
    @minimap.clear_passage_table_cache
    @minimap.refresh
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップのオブジェクトを更新
  #--------------------------------------------------------------------------
  def update_minimap_object
    @minimap.update_object_list unless @minimap.nil?
  end
end
 
#==============================================================================
# ■ Scene_Map
#==============================================================================
 
class Scene_Map
  #--------------------------------------------------------------------------
  # ● 場所移動後の処理
  #--------------------------------------------------------------------------
  alias post_transfer_KMS_MiniMap post_transfer
  def post_transfer
    refresh_minimap
 
    post_transfer_KMS_MiniMap
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップ全体をリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_minimap
    @spriteset.refresh_minimap unless @spriteset.nil?
  end
  #--------------------------------------------------------------------------
  # ○ ミニマップのオブジェクトを更新
  #--------------------------------------------------------------------------
  def update_minimap_object
    @spriteset.update_minimap_object unless @spriteset.nil?
  end
end
 
 
 
