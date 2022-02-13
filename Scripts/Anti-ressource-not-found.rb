# --------------------------------------------------------
# ▼ Anti-"No such file" [VX Ace]
#    par Krosk - merci à Wawower et berka
# --------------------------------------------------------
#   Ce script permet de continuer le jeu malgré 
# l'absence d'une ressource graphique ou audio
# que le projet soit crypté ou non.
#
#   Il n'empêche pas le crash en cas 
# de manque d'une map ou d'un fichier data...
# 
#   L'image manquante est substituée par 
# une image vide, mais vous pouvez à la place 
# utiliser une image de substitution pour 
# mieux repérer où se situe la ressource manquante.
#   Indiquez le chemin d'une ressource existante 
# sur NOSUCHSUB = "Graphics/Picture/image_example"
#
#   Le son manquant n'est tout simplement pas joué.
# 
#   Personnalisez vous même le message NOSUCHTEXT 
# pour signaler au joueur la conduite à adopter.
#  (utilisez \n pour sauter une ligne)
#  (utilisez %s pour indiquer le nom du fichier)
#
#   Les messages d'avertissement apparaissent dans
# une boîte de dialogue par défaut. Pour les faire 
# apparaître dans la console, réglez NOSUCHBOX = true.
# --------------------------------------------------------

    if File.file?('default_langset=2')
    NOSUCHTEXT = "La ressource %s manque.\nVeuillez signaler ce bug.\n"
    else
    NOSUCHTEXT = "Ressource %s not found.\nPlease report this bug.\n"
    end
NOSUCHSUB  = ""
NOSUCHBOX  = false
 
# --------------------------------------------------------
# ▼ Vous n'avez rien à éditer en dessous, à priori
# --------------------------------------------------------
 
NOSUCH_print = NOSUCHBOX ? method(:print) : method(:msgbox)
 
class << Bitmap
  alias_method :krosk_new, :new unless method_defined?(:krosk_new)
  def new(*args)
    krosk_new(*args)
  rescue
    if args.size == 1
      NOSUCH_print.call sprintf NOSUCHTEXT, args[0]
    end
    begin
      krosk_new(NOSUCHSUB)
    rescue
      krosk_new(32, 32)
    end
  end
end
 
module Audio
  class << self
    alias_method :krosk_se_play, :se_play unless method_defined?(:krosk_se_play)
    alias_method :krosk_me_play, :me_play unless method_defined?(:krosk_me_play)
    alias_method :krosk_bgm_play, :bgm_play unless method_defined?(:krosk_bgm_play)
    alias_method :krosk_bgs_play, :bgs_play unless method_defined?(:krosk_bgs_play)
  end
 
  def self.se_play(filename, volume = 100, pitch = 100)
    self.krosk_se_play(filename, volume, pitch)
  rescue
    NOSUCH_print.call sprintf NOSUCHTEXT, filename
  end
  
  def self.me_play(filename, volume = 100, pitch = 100)
    self.krosk_me_play(filename, volume, pitch)
  rescue
    NOSUCH_print.call sprintf NOSUCHTEXT, filename
  end
  
  def self.bgm_play(filename, volume = 100, pitch = 100, pos = 0)
    self.krosk_bgm_play(filename, volume, pitch, pos)
  rescue
    NOSUCH_print.call sprintf NOSUCHTEXT, filename
  end
  
  def self.bgs_play(filename, volume = 100, pitch = 100, pos = 0)
    self.krosk_bgs_play(filename, volume, pitch, pos)
  rescue
    NOSUCH_print.call sprintf NOSUCHTEXT, filename
  end
end
 
# --------------------------------------------------------
# Fin de fichier
# --------------------------------------------------------
