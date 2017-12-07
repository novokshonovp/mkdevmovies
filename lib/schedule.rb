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
        time_range = @schedule.select { |period| period.halls.include?(hall.first) }
                              .map(&:time_range)
        [hall.first, time_range]
      end.to_h
    end

    def period_by_time(time, hall)
      periods = @schedule.select do |period|
        is_hall_included = hall.nil? ? true : period.halls.include?(hall)
        period.cover?(time.strftime('%H:%M')) && is_hall_included
      end
      validate_period!(periods)
      periods.first
    end

    private

    def validate(new_period)
      validate_hall!(new_period.halls)
      raise 'Time range overlaps!' if period_overlaps?(new_period)
      true
    end

    def validate_hall!(halls)
      not_found = Array(halls) - Array(@halls.keys)
      raise "Undefined halls: #{not_found}!" unless not_found.empty?
      not_found.empty?
    end

    def period_overlaps?(new_period)
      @schedule.any? do |existing|
        existing.overlaps?(new_period)
      end
    end

    def validate_period!(periods)
      raise 'Cinema closed!' if periods.empty?
    end
  end
end
