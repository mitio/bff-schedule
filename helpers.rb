# encoding: utf-8

def weekday_for(date)
  [
    'Понеделник',
    'Вторник',
    'Сряда',
    'Четвъртък',
    'Петък',
    'Събота',
    'Неделя',
  ][date.wday - 1]
end

def combine_events_in_boxes(pdf, events, hour_height, min_event_height)
  combined_events = []
  last_combined_event = []

  events.each do |event|
    if event.coffee_break?
      combined_events << last_combined_event if last_combined_event.any?
      last_combined_event = []
      combined_events << [event]
    else
      last_combined_event << event
      combined_events_height = last_combined_event.map { |e| e.duration / 3600.0 * hour_height }.reduce(:+)

      if combined_events_height >= min_event_height
        combined_events << last_combined_event
        last_combined_event = []
      end
    end
  end
  combined_events << last_combined_event if last_combined_event.any?

  combined_events
end
