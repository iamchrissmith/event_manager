module Sanitize
  def clean_zipcode(zip)
    zip.to_s.rjust(5,"0")[0..4]
  end
end
