require 'socket'
require_relative 'Key'


server = TCPServer.new('localhost', 2345)
key = Key.new
Thread.new{ key.periodic_refresh true}

loop do
  socket = server.accept
  request = socket.gets
  responseCode = 200
  request_type, path, protocol = request.chomp.split(' ')
  path = path.split('/')

  case path[1]
  when nil
    key.list_keys
    responseString = "API keys listed"
    
  when "E1"
    api_key = key.generate
    responseString = "API key generated: #{api_key}"
    
  when "E2"
    api_key = key.serve
    if !api_key
      responseCode = 404
      responseString = "No key available"
    else
      responseString = "API key served: #{api_key}"
    end
    
  when "E3"
    api_key = path[2]
    if key.unblock api_key
      responseString = "API key unblocked: #{api_key}"
    else
      responseString = "API key non-existent: #{api_key}"
    end
    
  when "E4"
    api_key = path[2]
    if key.purge api_key
      responseString = "API key deleted: #{api_key}"
    else
      responseString = "API key non-existent: #{api_key}"
    end

  when "E5"
    api_key = path[2]
    if key.refresh api_key
      responseString = "API key refreshed: #{api_key}"
    else
      responseString = "API key non-existent: #{api_key}"
    end
    
  else
    responseString = "Invalid endpoint requested"
  end
  
  puts responseString
  socket.print "HTTP/1.1 #{responseCode} OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{responseString.bytesize}\r\n" +
               "Connection: close\r\n"
  socket.print "\r\n"
  socket.print responseString
  socket.close
end