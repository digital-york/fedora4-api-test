require 'faraday'

props = eval(File.open('/home/vagrant/system.properties') {|f| f.read})
username = props[:username]
password = props[:password]

conn = Faraday.new(:url => 'http://localhost:8080') do |c|
  c.use Faraday::Request::Multipart
  c.use Faraday::Response::Logger     # log request & response to STDOUT
  c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
end
conn.basic_auth(username, password)

response = conn.post '/fcrepo/rest/test' do |req|
  req.headers['Content-Type'] = 'image/png'
  #req.headers['File-Size'] = File.size('test.png').to_s
  req.headers['Content-Length'] = File.size('test.png').to_s
  req.body = Faraday::UploadIO.new('test.png', 'image/png')
end
puts response.body.inspect

