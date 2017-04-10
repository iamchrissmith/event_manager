require 'spec_helper'

describe Sanitize do

  subject { EventManager.new }

  describe ".parse_date" do
    it "returns a date object from string" do
      expected_date_obj = DateTime.strptime('11/12/08 10:47', '%m/%d/%y %H:%M')
      expect(subject.parse_date('11/12/08 10:47')).to eq expected_date_obj
      expect(subject.parse_date('11/12/08 10:47').class).to be DateTime
    end
  end

  describe ".get_interval" do
    it "returns the time interval from date object" do
      expect(subject.get_interval('hour')).to eq "%H"
      expect(subject.get_interval('day')).to eq "%w"
    end
  end

  describe ".peak_registration" do
    it "returns peak registration hour" do
      expect(subject.peak_registration('hour')).to eq "15:00"
      expect(subject.peak_registration('hour','./data/full_event_attendees.csv')).to eq "16:00"
    end
    it "returns peak registration day" do
      expect(subject.peak_registration('day')).to eq "Tuesday"
      expect(subject.peak_registration('day','./data/full_event_attendees.csv')).to eq "Tuesday"
    end
  end

end
