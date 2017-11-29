require 'nokogiri'
require 'open-uri'
require 'ruby-progressbar'
require_relative 'tmdbparser'

include MkdevMovies
module MkdevMovies
  module IMDBParser
    private def budget_by_link(link)
      doc = Nokogiri::HTML(open(link))
      budget_article = doc.css('div.article#titleDetails').xpath("//h4[text()='Budget:']").first
      budget_article.nil? ? 'not determined' : budget_article.parent.xpath('text()').to_s.strip
    end
  end

  class CinemaConverter
    TMDB_FIELDS = { title: :title_ru, poster_path: :poster_id }.freeze
    include IMDBParser
    include TMDbParser
    attr_reader :cinema

    def initialize(cinema, _filename_yaml)
      @cinema = cinema
      add_budgets
    end

    def add_tmpdb_data_to_collection(filename_yaml)
      yaml = YAML.load_stream(File.open(filename_yaml))
      yaml.each do |new_data|
        movie = cinema.filter(imdb_id: new_data[:imdb_id]).first
        new_data.each { |movie_field, value| movie.add_attribute(movie_field, String, value) }
      end
    end

    private def add_budgets
      progressbar = ProgressBar.create(title: 'Download data from IMDB',
                                       starting_at: 0, total: collection.count)
      collection.each do |movie|
        budget = budget_by_link(movie.link)
        movie.add_attribute(:budget, String, budget)
        progressbar.increment
      end
    end

    def load_tmdb_data_to_file(api_key, filename_yaml)
      progressbar = ProgressBar.create(title: 'Download data from TMDb',
                                       starting_at: 0, total: collection.count)
      File.new(filename_yaml, 'w')
      collection.each do |movie|
        data = json_by_imdb_id(movie.imdb_id, api_key)
        data_to_save = parse_json(data)
        data_to_save[:imdb_id] = movie.imdb_id
        append_data_to_yaml_file(filename_yaml, data_to_save)
        progressbar.increment
      end
    end

    private def parse_json(data)
      new_data = data['movie_results'].first.select do |field_name, _value|
        TMDB_FIELDS.keys.include?(field_name.to_sym)
      end
      new_data.map { |field_name, value| [TMDB_FIELDS[field_name.to_sym], value] }.to_h
    end

    def download_posters(path)
      progressbar = ProgressBar.create(title: 'Download images',
                                       starting_at: 0, total: collection.count)
      collection.each do |movie|
        download_and_save_poster_image(path, movie.poster_id)
        progressbar.increment
      end
    end

    def collection
      @cinema.all
    end
  end
end
