require 'uri'
require 'base64'
# p Marshal.load(Base64.decode64(URI.decode(gets.split('--').first)))
p Base64.decode64(URI.decode(gets.split('--').first))
