require 'pry'
require 'csv'
require './lib/sanitize_module'

class EventManager
  include Sanitize

  def read_csv
    CSV.open "./data/event_attendees.csv", headers:true, header_converters: :symbol
  end

  def output
    contents = read_csv
    contents.each do |row|
      name = row[:first_name]
      zipcode = clean_zipcode(row[:zipcode])
      puts "#{name} #{zipcode}"
    end
  end
end
