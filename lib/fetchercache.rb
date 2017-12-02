require_relative 'tmdbfetcher'
require_relative 'imdbfetcher'
require 'json'
require 'yaml'

module MkdevMovies
  class FetcherCache
    module MovieExtender
      CACHE_DEFEAULT_FILE_NAME = 'xmdb_cache.yaml'.freeze
      CONFIG = { title_ru: { fetcher: TMDBFetcher, field: :title },
                 poster_id: { fetcher: TMDBFetcher, field: :poster_path },
                 budget: { fetcher: IMDBFetcher, field: :budget } }.freeze
      CONFIG_NAMES_TRANLATED = CONFIG.map { |key, params| [params[:field], key] }.to_h

      def self.field_defs(config)
        config.each do |field, params|
          define_method(field) do
            imdb_id_sym = imdb_id.to_sym
            return cache.get(imdb_id_sym, field) if cache.cached?(imdb_id_sym, field)
            data = fetcher_data(params[:fetcher], imdb_id_sym)
            cache.put(imdb_id_sym, data)
            cache.get(imdb_id_sym, field)
          end
        end
      end

      def cache_file_name(cache_file_name)
        @cache_file_name = cache_file_name
      end

      private

      def cache
        cache_file = @cache_file_name.nil? ? CACHE_DEFEAULT_FILE_NAME : @cache_file_name
        @cache ||= FetcherCache.new(cache_file)
      end

      def fetcher_data(fetcher, imdb_id)
        data = fetcher.new.data(imdb_id)
        send("parse_#{fetcher.name.split('::').last}", data)
      end

      def parse_TMDBFetcher(data)
        new_data = JSON(data)['movie_results'].first.select do |field_name, _value|
          CONFIG.values.map { |params| params[:field] }.include?(field_name.to_sym)
        end
        translate_names(new_data)
      end

      def parse_IMDBFetcher(data)
        translate_names(data)
      end

      def translate_names(data)
        data.map { |field_name, value| [CONFIG_NAMES_TRANLATED[field_name.to_sym], value] }.to_h
      end

      field_defs CONFIG
    end

    def initialize(path_cache_file)
      @data = {}
      @filename_yaml = path_cache_file
      load
    end

    def cached?(imdb_id, field)
      return false if @data[imdb_id].nil?
      !@data[imdb_id][field].nil?
    end

    def get(imdb_id, field)
      @data[imdb_id][field]
    end

    def put(imdb_id, data)
      @data[imdb_id] = @data[imdb_id].nil? ? data : @data[imdb_id].merge(data)
      save
    end

    private

    def save
      File.open(@filename_yaml.to_s, 'w') do |file|
        file.write YAML.dump(@data)
      end
    end

    def load
      @data = YAML.load_stream(File.open(@filename_yaml)).first if File.exist?(@filename_yaml)
    end
  end
end
