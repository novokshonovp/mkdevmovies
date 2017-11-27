require_relative 'period'

module MkdevMovies
  module Schedule
    attr_accessor :halls, :schedule
    def initialize(*args, &block)
      raise 'Need a block to create Theatre!' unless block_given?
      super(*args)
      instance_eval(&block)
    end

    def hall(id, title:, places:)
      raise 'Places should be > 0!' if places <= 0
      @halls ||= {}
      @halls[id] = { title: title, places: places }
    end

    def period(time_range, &block)
      @schedule ||= []
      p = Period.new(time_range, &block)
      @schedule.push(p) if validate(p)
    end
    
    def halls_by_periods
      @halls.map do |hall|
        time_range = @schedule.map { |period| period.time_range if period.halls.include?(hall.first) }
                              .compact
        { hall.first => time_range }
      end
    end
    
    private

    def validate(new_period)
      has_hall?(new_period.halls)
      raise 'Time range overlaps!' if period_overlaps?(new_period)
      true
    end

    def has_hall?(halls)
      not_found = Array(halls) - Array(@halls.keys)
      raise "Undefined halls: #{not_found}!" unless not_found.empty?
      not_found.empty?
    end

    def period_overlaps?(new_period)
      new_period.halls.any? do |_hall|
        @schedule.any? do |existing|
          existing.overlaps?(new_period)
        end
      end
    end

    def get_period_by_time(time)
      periods = get_periods_by_time(time)
      if periods.count > 1
        halls = periods.map(&:halls).flatten.uniq
        raise "Could not determine a hall. Choose hall (allowed halls: #{halls})"
      end
      periods.first
    end

    def get_period_by_time_and_hall(time, hall)
      periods = get_periods_by_time(time).select { |period| period.halls.include?(hall) }
      periods.first
    end

    def get_periods_by_time(time)
      @schedule.select { |period| period.cover?(time.strftime('%H:%M')) }
    end

  end
end
