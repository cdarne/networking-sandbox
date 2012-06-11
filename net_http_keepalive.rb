require "net/http"
require "uri"

def get(http, uri)
  request = Net::HTTP::Get.new(uri)
  request["Accept-Encoding"] = "gzip, deflate"
  request.basic_auth("user", "password")
  http.request(request)
end

uri = URI.parse("http://192.168.13.139")

start = Time.now

http = Net::HTTP.new(uri.host, uri.port)
http.open_timeout = 5 # in seconds
http.read_timeout = 10 # in seconds
#http.set_debug_output($stderr)
http.start do
  p get(http, "/users/search/friends.json?page=1&per_page=6")

  #sleep 20

  p get(http, "/friends/summary.json?q=&page=1")

  p Time.now - start
end
