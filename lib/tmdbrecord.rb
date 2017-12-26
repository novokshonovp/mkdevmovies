require_relative 'record'
require_relative 'tmdbfetcher'

module MkdevMovies
  class TMDBRecord < Record
    FIELDS = {  title: :title_ru,
                poster_path: :poster_id }.freeze
     
    def self.attributes
      FIELDS.values
    end
    
    private

    def fetch
      data = TMDBFetcher.new.data(@imdb_id)
      data = JSON(data)['movie_results'].first.select do |field_name, _value|
        FIELDS.keys.include?(field_name.to_sym)
      end
      translate_names(data)
    end

    def translate_names(data)
      data.map { |field_name, value| [FIELDS[field_name.to_sym], value] }.to_h
    end
  end
end
