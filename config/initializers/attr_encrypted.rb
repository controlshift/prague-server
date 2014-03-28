# Makes sure you've set up all the necessary encryptor env variables
if ENV["ENCRYPTOR_SECRET_KEY"].blank?
  raise ArgumentError, "Be sure to specify ENCRYPTOR_SECRET_KEY as an environment variable"
end