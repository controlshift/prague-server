# Makes sure you've set up all the necessary encryptor env variables
ENV["ENCRYPTOR_SECRET_KEY"] = "xxx" if Rails.env.test?
if ENV["ENCRYPTOR_SECRET_KEY"].blank?
  raise ArgumentError, "Be sure to specify ENCRYPTOR_SECRET_KEY as an environment variable"
end