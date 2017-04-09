require 'pry'
require 'csv'
require 'sunlight/congress'
require 'erb'
require './lib/sanitize_module'

class EventManager
  include Sanitize
  Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

  def read_csv
    CSV.open "./data/event_attendees.csv", headers:true, header_converters: :symbol
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

  def output
    contents = read_csv
    template_letter = File.read "./lib/form_letter.erb"
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
