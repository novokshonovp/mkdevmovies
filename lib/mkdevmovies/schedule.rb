require_relative 'period'

module Mkdevmovies
  # @author Pavel Novokshonov
  module Schedule
    # @return [Hash] Returns a hash of halls and theirs params ( { hall_id: { title: "Example title", places: int_number_of_places } } ).
    attr_reader :halls
    # @return [Array<Period>] Returns an array of Period objects.
    attr_reader :schedule
    # Handles initialization
    #  Passes additional params (@args) to class that uses the module.
    #  Checks given block and fills @halls and @schedule structures.
    # @param args [Array] Additional params.
    # @param block [Proc] A block of a schedule definition
    # @example
    #   cinema = Class.new { include Schedule }
    #   cinema.new do
    #                hall :red, title:'Red hall', places: 100
    #                hall :blue, title: 'Blue hall', places: 50
    #                period '06:00'..'12:00' do
    #                  description 'Morning show'
    #                  filters period: 'AncientMovie'
    #                  price 3
    #                  hall :red, :blue
    #                end
    #              end
    def initialize(*args, &block)
      raise 'Need a block to create Theatre!' unless block_given?
      super(*args)
      instance_eval(&block)
    end

    # Composes halls and periods in form of { hall_x: ["Opening time".."Closing time"], hall_y: ["Opening time".."Closing time"] }
    # @return [Hash] Hash of halls and periods
    def halls_by_periods
      @halls.map do |hall|
        time_range = @schedule.select { |period| period.halls.include?(hall.first) }
                              .map(&:time_range)
        [hall.first, time_range]
      end.to_h
    end
    # Checks that a schedule includes a hall(any hall for nil value) and schedule working hours cover the time param.
    # @param time [Time] Time to check
    # @param hall [Symbol, nil] A hall id
    # @return [Period] Returns a Period object
    def period_by_time(time, hall)
      periods = @schedule.select do |period|
        is_hall_included = hall.nil? ? true : period.halls.include?(hall)
        period.cover?(time.strftime('%H:%M')) && is_hall_included
      end
      validate_period!(periods)
      periods.first
    end

    private

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
