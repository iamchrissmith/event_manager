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

  def output
    contents = read_csv
    template_letter = File.read "./lib/form_letter.erb"
    erb_template = ERB.new template_letter
    contents.each do |row|
      name = row[:first_name]
      zipcode = clean_zipcode(row[:zipcode])
      legislators = retrieve_legislators_by(zipcode)
      form_letter = erb_template.result(binding)
      puts form_letter
    end
  end
end
EventManager.new.output
