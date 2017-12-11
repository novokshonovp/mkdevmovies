require_relative 'record'
require_relative 'imdbfetcher'

module MkdevMovies
  class IMDBRecord < Record
    
    class << self
      attr_reader :attributes
    end
    @attributes = [:budget]
    
    def fetch
      IMDBFetcher.new.data(@imdb_id)
    end
  end
end
