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
