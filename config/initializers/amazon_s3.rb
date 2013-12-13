if Teambox.config.amazon_s3
  Paperclip::Attachment.default_options.update(
    :storage => :s3,
    :s3_credentials => Rails.root + 'config/amazon_s3.yml',
    :s3_host_name => 's3-eu-west-1.amazonaws.com',
    :s3_permissions => 'private',
    :url => ':s3_domain_url',
    :path => ":rails_root/assets/:id/:style/:filename"
  )
end
