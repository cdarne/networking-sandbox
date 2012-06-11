require 'em-http-request'

EM.run do
  start = Time.now
  #conn = EM::HttpRequest.new('http://127.0.0.1:3000')
  conn = EM::HttpRequest.new('http://192.168.13.139')

  r1 = conn.get :path => "/users/search/friends.json",
    :query => {page: 1, per_page: 6},
    :head => {'authorization' => ['user', 'password'],
              'accept-encoding' => 'gzip, compressed'},
              :keepalive => true

  r1.errback do
    puts "#{Time.now - start} - request #1 failed"
    EM.stop
  end

  r1.callback do
    puts "#{Time.now - start} - request #1 finished #{r1.response_header.status}"

    r2 = conn.get :path => "/friends/summary.json",
      :query => {page: 1, q: ""},
      :head => {'authorization' => ['user', 'password'],
                'accept-encoding' => 'gzip, compressed'}

    r2.errback do
      puts "#{Time.now - start} - request #2 failed"
      EM.stop
    end

    r2.callback do
      puts "#{Time.now - start} - request #2 finished #{r2.response_header.status}"
      EM.stop
    end
  end
end
