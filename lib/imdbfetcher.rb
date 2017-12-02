require 'nokogiri'
require 'open-uri'
require 'dotenv/load'

module MkdevMovies
  class IMDBFetcher
    IMDB_DATA_URL = ENV['IMDB_DATA_URL']
    def data(imdb_id)
      doc = Nokogiri::HTML(open("#{IMDB_DATA_URL}#{imdb_id}"))
      ba = doc.css('div.article#titleDetails').xpath("//h4[text()='Budget:']").first
      { budget: ba.nil? ? 'not determined' : ba.parent.xpath('text()').to_s.strip }
    end
  end
end
