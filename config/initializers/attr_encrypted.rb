# Makes sure you've set up all the necessary encryptor env variables
ENV["ENCRYPTOR_SECRET_KEY"] = "33ed5cc61b7909210dee772f9ac4cdec6a4f3052993b3ee928ae366556c4029aea610282051b047388cc4423a6ce14713199fe3d2250b8ee5825381c68a6365b" if Rails.env.test?
if ENV["ENCRYPTOR_SECRET_KEY"].blank?
  raise ArgumentError, "Be sure to specify ENCRYPTOR_SECRET_KEY as an environment variable"
end