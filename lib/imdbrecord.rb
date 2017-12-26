require_relative 'record'
require_relative 'imdbfetcher'

module MkdevMovies
  class IMDBRecord < Record
 
    def self.attributes 
      [:budget]
    end
    
    def fetch
      IMDBFetcher.new.data(@imdb_id)
    end
  end
end
