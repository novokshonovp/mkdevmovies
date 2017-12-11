require_relative 'record'
require_relative 'tmdbfetcher'

module MkdevMovies
  class TMDBRecord < Record
    FIELDS = {  title_ru: %i[title to_s],
                poster_id: %i[poster_path to_s] }.freeze
    CONFIG_NAMES = FIELDS.map { |key, value| [value.first, key] }.to_h

    def data(field_name)
      fetch(field_name) { fetch_remote(@imdb_id) }
    end

    private

    def fetch_remote(imdb_id)
      data = TMDBFetcher.new.data(imdb_id)
      data = JSON(data)['movie_results'].first.select do |field_name, _value|
        CONFIG_NAMES.keys.include?(field_name.to_sym)
      end
      translate_names(data)
    end

    def translate_names(data)
      data.map { |field_name, value| [CONFIG_NAMES[field_name.to_sym], value] }.to_h
    end
  end
end
