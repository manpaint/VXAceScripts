module Utility
  #############
  # DLL STUFF by Zerbian #
  #############
  #Utility.read_ini('Title')
  #Utility.write_ini('Windowskin', '3')
  #Utility.write_ini('Fullscreen', '1', 'Window')
  READ_INI         = Win32API.new('kernel32',  'GetPrivateProfileStringA',
                                  %w(p p p p l p), 'l')
  WRITE_INI        = Win32API.new('kernel32',  'WritePrivateProfileStringA',
                                  %w(p p p p), 'l')
  ##
  # Read from system ini
  #
  def self.read_ini(key_name, app_name = 'Game', filename = 'Game.ini',
                    buffer_size = 256, default = '')
    buffer = "\0" * buffer_size
    READ_INI.call(app_name, key_name, default, buffer, buffer_size - 1,
                  ".\\" + filename)
    return buffer.delete("\0")
  end
 
  ##
  # Write to system ini
  #
  def self.write_ini(key_name, value, app_name = 'Game', filename = 'Game.ini')
    return WRITE_INI.call(app_name, key_name, value.to_s, ".\\" + filename)
  end
end
