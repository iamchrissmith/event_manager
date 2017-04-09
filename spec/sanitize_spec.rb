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

  describe ".clean_phone_number" do
    it "does nothing when phone is ok" do
      expect(subject.clean_phone_number("123-456-7890")).to eq "(123) 456-7890"
      expect(subject.clean_phone_number("123.456.7890")).to eq "(123) 456-7890"
      expect(subject.clean_phone_number("123 456 7890")).to eq "(123) 456-7890"
      expect(subject.clean_phone_number("(123)456-7890")).to eq "(123) 456-7890"
      expect(subject.clean_phone_number("(123) 456-7890")).to eq "(123) 456-7890"
      expect(subject.clean_phone_number("1234567890")).to eq "(123) 456-7890"
    end
    it "returns '' if less than 10 digits" do
      expect(subject.clean_phone_number("123-456-789")).to eq ""
      expect(subject.clean_phone_number(nil)).to eq ""
    end
    it "trims first '1' if 11 digits" do
      expect(subject.clean_phone_number("1 (123) 456-7890")).to eq "(123) 456-7890"
      expect(subject.clean_phone_number("1-123-456-7890")).to eq "(123) 456-7890"
      expect(subject.clean_phone_number("11234567890")).to eq "(123) 456-7890"
    end
    it "returns '' if 11 digits doesn't start with 1" do
      expect(subject.clean_phone_number("2-123-456-7890")).to eq ''
    end
    it "returns '' if more than 11" do
      expect(subject.clean_phone_number("112345678903")).to eq ""
      expect(subject.clean_phone_number("112345678901")).to eq ""
    end
  end

end
