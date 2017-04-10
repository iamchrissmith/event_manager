require 'pry'
require 'csv'
require 'sunlight/congress'
require 'erb'
require './lib/sanitize_module'

class EventManager
  include Sanitize
  Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

  def read_csv(csv_source)
    CSV.open csv_source, headers:true, header_converters: :symbol
  end

  def retrieve_legislators_by(zip)
    Sunlight::Congress::Legislator.by_zipcode(zip)
  end

  def save_thank_you_letter(id, form_letter)
    Dir.mkdir("output") unless Dir.exists? "output"
    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
      file.puts form_letter
    end
  end

  def get_interval(interval)
    intervals = {
      "hour" => "%H",
      "day" => "%w",
      "%H" => "%H:%M",
      "%w" => "%A"
    }
    intervals[interval]
  end

  def parse_date(date)
    DateTime.strptime(date, '%m/%d/%y %H:%M')
  end

  def find_average(items)
    items.inject(0) {|sum, el| sum + (el.to_i + 1) } / items.length
  end

  def back_to_time(average, interval)
    fake_date = DateTime.strptime(average.to_s,interval)
    fake_date.strftime(get_interval(interval))
  end

  def peak_registration(interval, csv_source = "./data/event_attendees.csv")
    contents = read_csv(csv_source)
    date_interval = get_interval(interval)
    times = contents.map do |row|
      # binding.pry
      parse_date(row[:regdate]).strftime(date_interval)
    end
    average = find_average(times)
    back_to_time(average - 1,date_interval)
  end

  def count_time(times, interval)
    times.each_with_object(Hash.new(0)) do |time,counts|
      label = back_to_time(time, interval)
      counts[label] += 1
    end
  end

  def output_dashboard (csv_source = "./data/event_attendees.csv")
    contents = read_csv (csv_source)
    template_dashboard = File.read "./views/dashboard.erb"
    erb_template = ERB.new template_dashboard
    days = contents.map do |row|
      parse_date(row[:regdate]).strftime("%w")
    end
    contents.rewind
    days_count = count_time(days, "%w")
    days_labels = days_count.keys
    days_data = days_count.values
    hours = contents.map do |row|
      parse_date(row[:regdate]).strftime("%H")
    end
    hours_count = count_time(hours, "%H")
    hours_labels = hours_count.keys
    hours_data = hours_count.values

    dashboard = erb_template.result(binding)

    Dir.mkdir("output") unless Dir.exists? "output"
    filename = "output/dashboard.html"

    File.open(filename, 'w') do |file|
      file.puts dashboard
    end

  end

  def output
    contents = read_csv("./data/event_attendees.csv")
    template_letter = File.read "./views/form_letter.erb"
    erb_template = ERB.new template_letter
    contents.each do |row|
      id = row[0]
      name = row[:first_name]

      zipcode = clean_zipcode(row[:zipcode])

      legislators = retrieve_legislators_by(zipcode)

      form_letter = erb_template.result(binding)

      save_thank_you_letter(id, form_letter)
    end
  end
end
EventManager.new.output
EventManager.new.output_dashboard('./data/full_event_attendees.csv')
