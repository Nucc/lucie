source 'https://rubygems.org'

# Lucie guides
if ENV["heroku"]
  gem "rack"
  return
end

# Travis CI system
if ENV["TRAVIS"]
  gem "rake"
  gem "minitest", "~>4.6.0"
  gem "mini_shoulda"
  gem "coveralls", require: false

  gem "open4", "1.3.0"
end

gemspec
