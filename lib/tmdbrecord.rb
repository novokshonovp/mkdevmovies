require_relative 'record'
require_relative 'tmdbfetcher'

module MkdevMovies
  module TMDBRecord
    include Record

    CONFIG_NAMES = { title: :title_ru, poster_path: :poster_id }.freeze
    Record.add_attributes(CONFIG_NAMES.values)

    def self.def_fields(field_names)
      field_names.each do |field_name|
        define_method(field_name) do
          cached?(imdb_id, field_name) ? get(imdb_id, field_name) : fetch(imdb_id, field_name)
        end
      end
    end

    private

    def get_remote(imdb_id)
      data = TMDBFetcher.new.data(imdb_id)
      data = JSON(data)['movie_results'].first.select do |field_name, _value|
        CONFIG_NAMES.keys.include?(field_name.to_sym)
      end
      translate_names(data)
    end

    def translate_names(data)
      data.map { |field_name, value| [CONFIG_NAMES[field_name.to_sym], value] }.to_h
    end

    def_fields CONFIG_NAMES.values
  end
end
