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

  def clean_phone_number(number)
    cleaned = remove_non_numerics(number.to_s)
    return phone_format(cleaned) if cleaned.length == 10
    # return '' if cleaned.length > 11 || cleaned.length < 10
    if cleaned.length == 11 && cleaned[0] == "1"
      return phone_format(cleaned[1..-1])
    end
    return ''
  end

  def remove_non_numerics(number)
    number.gsub(/\D/, '')
  end

  def phone_format(number)
    number.insert(0, "(")
    number.insert(4, ") ")
    number.insert(9, "-")
    number
  end
end
