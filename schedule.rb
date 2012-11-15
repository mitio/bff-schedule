# encoding: utf-8

require 'csv'
require 'date'

class Schedule
  include Enumerable

  class Event
    attr_accessor :number

    def initialize(fields)
      @fields = Hash[fields]
    end

    def method_missing(name, *args)
      if @fields.has_key?(name.to_s)
        get name
      else
        super
      end
    end

    def get(field)
      field = field.to_s
      value = @fields[field]

      return value unless value.kind_of? String

      value = case field
      when 'date'
        Date.parse(value)
      when /_at$/
        date = get 'date'
        hour, min, sec = value.split(':').map(&:to_i)
        Time.new date.year, date.month, date.day, hour, min, sec
      else
        value
      end

      @fields[field] = value
    end

    def set(field, value)
      @fields[field] = value
    end

    def name
      coffee_break? ? 'Почивка' : @fields['name']
    end

    def coffee_break?
      type == 'почивка'
    end

    # In seconds
    def duration
      return 1800 unless ends_at
      ends_at - starts_at
    end
  end

  def initialize(input_file)
    @rows = CSV.read input_file
    @field_names = @rows.shift

    # Convert rows to events and sort them by start time
    @events = @rows.map { |values| Event.new @field_names.zip(values) }.sort_by(&:starts_at)

    # Try to fill in the end time of most events
    @events.each_with_index do |event, i|
      next_event = @events[i + 1 .. -1].find { |e| e.date == event.date && e.location == event.location }
      event.set 'ends_at', event.ends_at || next_event.starts_at if next_event
    end
  end

  def each(&block)
    @events.each(&block)
  end
end
