Geocoder.configure(
  timeout: 3,
  lookup: :google,
  use_https: true,
  api_key: ENV['GOOGLE_MAP_KEY'],
  units: :km
)