require 'faraday'

props = eval(File.open('/home/vagrant/system.properties') {|f| f.read})
username = props[:username]
password = props[:password]

conn = Faraday.new(:url => 'http://localhost:8080') do |c|
  c.use Faraday::Request::Multipart
#  c.use Faraday::Request::UrlEncoded  # encode request params as "www-form-urlencoded"
  #c.use Faraday::Response::Logger     # log request & response to STDOUT
  c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
end
conn.basic_auth(username, password)

#response = conn.post '/fcrepo/rest' 
#puts 'Created an empty object'
#puts response.body.inspect


# upload a file
#payload = {:file => Faraday::UploadIO.new('data/yodl.rdf', 'application/rdf+xml ') }
#response = conn.post '/fcrepo/rest/test', payload
#puts 'Created an object from RDF'
#puts response.body.inspect

payload = {:file => Faraday::UploadIO.new('data/test.png', 'image/png') }
response = conn.post '/fcrepo/rest/test', payload
puts 'Created an object from PNG image'
puts response.body.inspect
