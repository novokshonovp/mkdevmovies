
require_relative 'netflix'
require_relative 'theatre'

DEFS = {filename_zip: "movies.txt.zip", 
            filename_txt: "movies.txt"}

filename_zip = ARGV[0]
if ARGV.length<1
    puts "Too few arguments. Use the default #{DEFS[:filename_zip]}."
    filename_zip = DEFS[:filename_zip]
end
if !File.exist?(filename_zip)
    puts "File #{filename} doesn't exist. Use the default #{DEFS[:filename_zip]}."
    filename_zip = DEFS[:filename_zip]
end

netflix = Netflix.new(filename_zip,DEFS[:filename_txt])
netflix.pay(10)
puts netflix.show(period: "AncientMovie")
theatre = Theatre.new(filename_zip,DEFS[:filename_txt])
puts theatre.show("23:59")
puts theatre.when?("Laura")
puts theatre.when?("The Terminator")


