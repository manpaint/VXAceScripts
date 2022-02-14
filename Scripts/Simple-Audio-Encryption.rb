=begin
#===============================================================================
 Title: Simple Audio Encryption
 Author: Hime
 Date: Mar 22, 2014
 URL: http://www.himeworks.com/2014/03/21/simple-audio-encryption/
--------------------------------------------------------------------------------
 ** Change log
 Apr 12, 2014
   - added support for movies as well
 Mar 22, 2014
   - added option to delete all audio files when loading a new audio file
   - does not crash when you try to play multiple audio files
   - adds a temporary extension to avoid deleting original files
 Mar 21, 2014
   - Initial release
--------------------------------------------------------------------------------   
 ** Terms of Use
 * Free to use in non-commercial projects
 * Contact me for commercial use
 * No real support. The script is provided as-is
 * Will do bug fixes, but no compatibility patches
 * Features may be requested but no guarantees, especially if it is non-trivial
 * Credits to Hime Works in your project
 * Preserve this header
--------------------------------------------------------------------------------
 ** Description
 
 This script provides very simple audio/video encryption.
 It allows you to store audio/video files inside the rgss3a archive.
 
 The data is decrypted and created outside of the archive when the engine
 wants to play an audio file.
 
 This means that while it is possible to easily copy the file once the game
 starts playing it, you can still protect files that they have not managed
 to unlock during the game.
 
--------------------------------------------------------------------------------
 ** Installation
 
 In the script editor, place this script below Materials and above Main

--------------------------------------------------------------------------------
 ** Usage 
 
 Follow these steps to encrypt your audio files. You should do this when you
 are ready to distribute your project.
 
 1. Move the Audio folder into the Data folder
 2. Compress the project and create an encrypted archive
 
 You can verify that when you extract the game, your audio files are no longer
 visible until you need it.
 
 To resume working on your project, simply move the audio folder back out.
 
 In the configuration, there is an option to delete all audio files that have
 been extracted whenever a new audio file is loaded. 
 
 For movies, it is the same process, except you move the "Movies" folder into
 the Data folder.
  
#===============================================================================
=end
$imported = {} if $imported.nil?
$imported[:TH_SimpleAudioEncryption] = true
#===============================================================================
# ** Configuration
#===============================================================================
module TH
  module Simple_Audio_Encryption
    
    # Automatically deletes files whenever a new music starts playing
    Auto_Delete = true
  end
end
#===============================================================================
# ** Rest of script
#===============================================================================
module TH
  module Crypt
    
    @@video_extensions = [".ogv"]
    @@audio_extensions = ["", ".ogg", ".mp3", ".mid"]
    
    def self.load_movie(path)
      load_file(path, @@video_extensions)
    end
    
    def self.load_audio(path)
      load_file(path, @@audio_extensions)
    end
    
    def self.load_file(path, exts)
      # File was already decrypted and is in use, so we don't bother looking
      return if File.exist?(path + ".tmp")
      base_path = "Data/" + path
      data = nil
      exts.each do |ext|
        begin
          data = load_data(base_path + ext)
        rescue
          # try again
        end
      end
      return unless data
      make_directory(path)
      write_file(path + ".tmp", data)
    end
    
    def self.delete_audio_files
      delete_files("Audio/**/*.tmp")
    end
    
    def self.delete_video_files
      delete_files("Movies/*.tmp")
    end
    
    def self.delete_files(path)
      return unless TH::Simple_Audio_Encryption::Auto_Delete
      Dir.glob(path).each do |f|
        next if File.directory?(f)
        begin
          File.delete(f)
        rescue
        end
      end
    end
    
    def self.make_directory(path)
      subpath = ""
      names = path.split("/")
      names.pop
      names.each do |part|
        subpath << part << "/"
        Dir.mkdir(subpath) unless File.exist?(subpath)
      end
      return subpath
    end
    
    def self.write_file(path, data)
      File.open(path, "wb") do |f|
        f.write(data)
      end
    end
  end
end

module Audio
  class << self
    alias :th_simple_audio_decryption_bgm_play :bgm_play
    alias :th_simple_audio_decryption_bgs_play :bgs_play
    alias :th_simple_audio_decryption_me_play :me_play
    alias :th_simple_audio_decryption_se_play :se_play
  end
  
  def self.bgm_play(*args)
    TH::Crypt.delete_audio_files
    TH::Crypt.load_audio(args[0])
    th_simple_audio_decryption_bgm_play(*args)
  end
  
  def self.bgs_play(*args)
    TH::Crypt.delete_audio_files
    TH::Crypt.load_audio(args[0])
    th_simple_audio_decryption_bgs_play(*args)
  end
  
  def self.me_play(*args)
    TH::Crypt.delete_audio_files
    TH::Crypt.load_audio(args[0])
    th_simple_audio_decryption_me_play(*args)
  end
  
  def self.se_play(*args)
    TH::Crypt.delete_audio_files
    TH::Crypt.load_audio(args[0])
    th_simple_audio_decryption_se_play(*args)
  end
  
  #-----------------------------------------------------------------------------
  # Loading from archive requires fully qualified path. This could be omitted
  # if users removed extensions, but it doesn't really matter.  
  #-----------------------------------------------------------------------------
end

module Graphics
  
  class << self
    alias :th_simple_audio_encryption_play_movie :play_movie
  end
  
  def self.play_movie(*args)
    TH::Crypt.delete_video_files
    TH::Crypt.load_movie(args[0])
    th_simple_audio_encryption_play_movie(*args)
  end
end

class << Marshal
  alias_method(:th_core_load, :load)
  def load(port, proc = nil)
    th_core_load(port, proc)
  rescue TypeError
    if port.kind_of?(File)
      port.rewind 
      port.read
    else
      port
    end
  end
end unless Marshal.respond_to?(:th_core_load)
