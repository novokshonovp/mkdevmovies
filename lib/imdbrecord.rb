require_relative 'imdbfetcher'

module MkdevMovies
  class IMDBRecord 
    
    def initialize(cache) 
      @cache = cache
    end
        
    def data(imdb_id, field_name)
      @cache.fetch(imdb_id, field_name) { IMDBFetcher.new.data(imdb_id) }
    end

  end
end
