require 'haml'
require 'open-uri'
require 'dotenv/load'
require 'ruby-progressbar'

class MovieRenderer
  TMDB_IMAGE_URL = ENV['TMDB_IMAGE_URL']
  LOCAL_IMAGES = ENV['POSTER_IMAGES']
  def initialize(render_object)
    @render_object = render_object
  end

  def render(template_file, output_file)
    template = File.read(template_file)
    output = Haml::Engine.new(template).render(@render_object)
    File.open(output_file, 'w') { |file| file.write(output) }
  end
  
  def download_tmdb_posters
    progressbar = ProgressBar.create(title: "Download images from #{TMDB_IMAGE_URL}",
                                        starting_at: 0, total: @render_object.all.count)
    @render_object.all.each do | movie | 
      path_to_save = "#{LOCAL_IMAGES}#{movie.poster_id}"
      File.open(path_to_save, 'wb') do |file|
        file.write open("#{TMDB_IMAGE_URL}#{movie.poster_id}").read
      end unless File.exist?(path_to_save)
      progressbar.increment
    end
    self
  end
end
