use Rack::Static,
  :urls => ["guides/assets/javascripts", "guides/assets/assets"],
  :root => "guides"

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    },

    if env["REQUEST_PATH"] =~ /^\/assets/
      File.open("guides/" + env["REQUEST_PATH"], File::RDONLY)
    else

      # Default path is /introduction.html
      env["REQUEST_PATH"] = "/introduction.html" if env["REQUEST_PATH"] == "/"

      # To avoid "../../sensitive_data", expand_path cuts the leading ".." chars.
      normalized_path = File.expand_path(env["REQUEST_PATH"])

      File.open(File.join("./guides/public", normalized_path), File::RDONLY)
    end
  ]
}