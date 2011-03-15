$:.unshift 'lib/', File.dirname(__FILE__) + '/../lib'
require 'rubygems'

require 'shoulda'
require 'mocha'

# try = proc do |library, version|
#   begin
#     dashed = library.gsub('/','-')
#     gem dashed, version
#     require library
#   rescue LoadError
#     puts "=> You need the #{library} gem to run these tests.",
#          "=> $ sudo gem install #{dashed}"
#     exit
#   end
# end
#
# try['shoulda', '>= 2']
# try['mocha', '>= 0.9']

begin require 'redgreen'; rescue LoadError; nil end

def fixture(name)
  File.dirname(__FILE__) + "/fixtures/#{name}.html"
end
