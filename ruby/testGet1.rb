require 'faraday'

props = eval(File.open('/home/vagrant/system.properties') {|f| f.read})
username = props[:username]
password = props[:password]

conn = Faraday.new(:url => 'http://localhost:8080') do |c|
  c.use Faraday::Request::UrlEncoded  # encode request params as "www-form-urlencoded"
  c.use Faraday::Response::Logger     # log request & response to STDOUT
  c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
end
conn.basic_auth(username, password)

#By default, Fedora returns turtle
response = conn.get '/fcrepo/rest/test' 
puts '---------Text/Turtle response-----------'
#puts response.body.inspect

response = conn.get '/fcrepo/rest/test', {}, {'Accept' => 'application/rdf+xml'}
puts '---------XML response-----------'
File.open("/var/tmp/fedora4.xml", 'w') { |file| file.write(response.body.inspect) }
#puts response.body.inspect

puts '---------Downloading image------'
response = conn.get '/fcrepo/rest/test/PREVIEW_IMAGE'
File.open('/var/tmp/image.png', 'wb') { |fp| fp.write(response.body) }

