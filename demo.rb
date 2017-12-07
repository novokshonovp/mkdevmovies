# require_relative './lib/netflix'

# require_relative './lib/movierenderer'
require 'dotenv'
Dotenv.load('./spec/movies.env')
require_relative './lib/theatre'

include MkdevMovies

# netflix = Netflix.new('./spec/test_movies.txt.zip', 'movies.txt')

module A
  def self.add_method(method_name, _context)
    # context.instance_eval
    define_method(method_name) do
      response
    end
  end
end

module B
  extend A
  add_method('title_ru', self)
  def response
    puts 'module B response'
  end
end
module C
  extend A
  add_method('budget', self)
  def response
    puts 'module C response'
  end
end

class Mov
  include B
  include C
end
x = Mov.new
x.title_ru
# puts x.methods
# collection = MovieCollection.new
# puts collection.all.first.title_ru
# puts m.has_genre?('Action')
# puts Record.attributes.inspect
# c.cache.data.each { |id, values|  puts "#{id},#{values[:title]}, #{values[:r_year]}" }
