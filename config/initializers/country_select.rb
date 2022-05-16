# config/initializers/country_select.rb

# Return an array to customize <option> text, `value` and other HTML attributes
CountrySelect::FORMATS[:with_full_country_name] = lambda do |country|
  [
    country.name,
    country.alpha2,
    {
      'value' => country.name,
    }
  ]
end
