CarrierWave.configure do |config|
  if Rails.env.production? && ENV['AWS_BUCKET'].present?
    # 本番環境
    config.storage    = :aws
    config.aws_bucket = ENV['AWS_BUCKET']
    config.aws_acl    = 'public-read'
    config.aws_region = ENV['AWS_REGION']
    config.aws_credentials = {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  else
    # ローカル
    config.storage = :file
  end
end