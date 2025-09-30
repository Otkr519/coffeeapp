CarrierWave.configure do |config|
  if Rails.env.production? && ENV['AWS_BUCKET'].present?
    config.storage = :aws
    config.aws_bucket = ENV['AWS_BUCKET']
    config.aws_credentials = {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:            ENV['AWS_REGION']
    }
  else
    config.storage = :file
  end
end
