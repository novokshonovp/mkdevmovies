require_relative 'tmdbfetcher'

module MkdevMovies
  class  TMDBRecord 

    def initialize(cache, fields) 
      @config_names = fields
      @cache = cache
    end

    def data(imdb_id, field_name)
      @cache.fetch(imdb_id, field_name) { get_remote(imdb_id) }
    end
    
    private

    def get_remote(imdb_id)
      data = TMDBFetcher.new.data(imdb_id)
      data = JSON(data)['movie_results'].first.select do |field_name, _value|
        @config_names.keys.include?(field_name.to_sym)
      end
      translate_names(data)
    end

    def translate_names(data)
      data.map { |field_name, value| [@config_names[field_name.to_sym], value] }.to_h
    end

  end
end
