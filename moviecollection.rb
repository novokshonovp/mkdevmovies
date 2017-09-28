require 'zip'
require 'csv'
require 'ostruct'
require 'date'

DATA_STRUCTURE = %i[link title r_year country r_date genres runtime rating director actors]

class MovieCollection < Movie
  attr_reader :movies
  def initialize(filename_zip, filename_txt)
    zip_file = Zip::File.new(DEFS[:filename_zip]).read(DEFS[:filename_txt])
    @movies = CSV.parse(zip_file,:col_sep=>"|",:headers=>DATA_STRUCTURE).map{ |i| Movie.new(OpenStruct.new(i.to_h),self) }
  end
  def all
    @movies
  end
  def sort_by(sortKey)
    if sortKey == :director
       @movies.sort {|x,y| x.director.split.last <=> y.director.split.last }
    else
       @movies.sort {|x,y| x.send(sortKey) <=> y.send(sortKey) }   
    end   
  end
  def filter(filterKey)
      @movies.select {|movie| movie.send(filterKey.keys.first).include? filterKey.values.first }
  end
  def stats(statKey)
  case statKey
    when :actors, :genres
          @movies.each_with_object(Hash.new(0)){ |movie,stats| movie.send(statKey).each{|actor| stats[actor]+=1 } }  
    when :month
          @movies
          .reject{ |movie| movie.r_date.count('-').zero? }
          .each_with_object(Hash.new(0)){ |movie,stats| stats[Date.strptime(movie.r_date,"%Y-%m").strftime("%B")]+=1 }   
    else
          @movies.each_with_object(Hash.new(0)){ |movie,stats| stats[movie.send(statKey)]+=1 }
    end
  end
end