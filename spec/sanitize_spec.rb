require 'spec_helper'

describe Sanitize do

  subject { EventManager.new }

  describe ".clean_zipcode" do
    it "does nothing when ZIP ok" do
      expect(subject.clean_zipcode("12345")).to eq "12345"
    end
    it "fills with 0's when nil" do
      expect(subject.clean_zipcode(nil)).to eq "00000"
    end
    it "fills with 0's when < 5" do
      expect(subject.clean_zipcode("123")).to eq "00123"
    end
    it "trims when > 5" do
      expect(subject.clean_zipcode("123456")).to eq "12345"
    end
  end

end
