require 'dotenv'
require 'open-uri'
require_relative 'record'

module MkdevMovies
  class FileRecord < Record
    FILENAME_TXT = ENV['FILE_RECORD_TXT']
    FIELDS = { link: %i[link to_s],
               title: %i[title to_s],
               r_year: %i[r_year to_i],
               country: %i[country to_s],
               r_date: [:r_date, Date.method(:parse)],
               genres: [:genres, ->(v) { v.split(',') }],
               runtime: %i[runtime to_i],
               rating: %i[rating to_f],
               director: %i[director to_s],
               actors: [:actors, ->(v) { v.split(',') }] }.freeze

    def data(field_name)
      fetch(field_name)
    end
  end
end
