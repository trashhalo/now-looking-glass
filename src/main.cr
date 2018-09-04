require "kemal"
require "icmp"
require "socket"

response = HTTP::Client.get "http://ip-api.com/json"
geo = JSON.parse response.body

get "/" do |env|
  error = env.params.query["error"]?
  render "src/views/home.ecr", "src/views/layouts/layout.ecr"
end

post "/ping" do |env|
  ipStr = env.params.body["ip"].as(String)
  ip = Socket::Addrinfo.resolve(ipStr, 80, type: Socket::Type::STREAM).first
  ping = ICMP::Ping.new(ip.ip_address.address).ping(count: 3)
  render "src/views/ping.ecr", "src/views/layouts/layout.ecr"
rescue sEx : Socket::Error
  env.redirect "/?error=socket"
end

Kemal.run
