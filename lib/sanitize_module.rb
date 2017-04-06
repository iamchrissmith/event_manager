module Sanitize
  def clean_zipcode(zip)
    zip.to_s.rjust(5,"0")[0..4]
  end

  def format_legislator_names(legislators)
    legislator_names = legislators.collect do |legislator|
      "#{legislator.first_name} #{legislator.last_name}"
    end
    legislator_names.join(", ")
  end
end
