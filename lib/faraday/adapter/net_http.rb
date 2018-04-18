require 'socksify'
require 'socksify/http'
class Faraday::Adapter::NetHttp
  def net_http_connection(env)
    if proxy = env[:request][:proxy]
      proxy_uri = URI.parse(proxy[:uri])
			if proxy[:socks]
				TCPSocket.socks_username = proxy[:user] if proxy[:user]
				TCPSocket.socks_password = proxy[:password] if proxy[:password]
				Net::HTTP::SOCKSProxy(proxy_uri.host, proxy_uri.port)
			else
				Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port,proxy_uri.user, proxy_uri.password)
			end
		else
				Net::HTTP
		end.new(env[:url].host, env[:url].port)
	end
end