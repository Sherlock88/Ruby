=begin

Key Server problem:
Write a server which can generate random api keys, assign them for usage and release them after sometime. Following endpoints should be available on the server to interact with it.

E1. There should be one endpoint to generate keys.

E2. There should be an endpoint to get an available key. On hitting this endpoint server should serve a random key which is not already being used. This key should be blocked and should not be served again by E2, till it is in this state. If no eligible key is available then it should serve 404.

E3. There should be an endpoint to unblock a key. Unblocked keys can be served via E2 again.

E4. There should be an endpoint to delete a key. Deleted keys should be purged.

E5. All keys are to be kept alive by clients calling this endpoint every 5 minutes. If a particular key has not received a keep alive in last five minutes then it should be deleted and never used again. 

Apart from these endpoints, following rules should be enforced:
R1. All blocked keys should get released automatically within 60 secs if E3 is not called.

No endpoint call should result in an iteration of whole set of keys i.e. no endpoint request should be O(n). They should either be O(lg n) or O(1).

You have to use rspec for writing test cases in this assignment

=end


require 'socket'
require 'securerandom'

#======================================================#

module Constants
  UNBLOCK_TIMEOUT = 5
  DELETION_TIMEOUT = 15
end


#======================================================#

class Key
  
  def initialize
    @storage = Storage.new
  end
  
  
  def generate
    api_key = SecureRandom.urlsafe_base64.upcase
    @storage.add_unblocked_key api_key
    api_key
  end
  
  
  def serve
    api_key = @storage.get_unblocked_key
    if !api_key
      false
    else
      api_key
    end
  end
  
  
  def unblock(api_key)
    @storage.unblock_blocked_key api_key
  end
  
  
  def purge(api_key)
    @storage.delete_key api_key
  end
  
  
  def refresh(api_key)
    @storage.refresh_key api_key
  end
  
  
  def periodic_refresh
    while true
      sleep 1
      @storage.periodic_refresh
    end
  end
  
  def list_keys
    @storage.list_keys
  end
  
end

#======================================================#

class Storage
  
  def initialize
    @blocked_api_keys = Hash.new
    @unblocked_api_keys = Hash.new
  end
  
  
  def add_unblocked_key(api_key)
    @unblocked_api_keys[api_key] = Time.now
  end
  
  
  def unblock_blocked_key(api_key)
    timestamp = @blocked_api_keys.delete(api_key)
    if timestamp == nil
      false
    else
      add_unblocked_key api_key
      true
    end
  end
  
  
  def get_unblocked_key
    if @unblocked_api_keys.length == 0
      false
    else
      api_key, timestamp = @unblocked_api_keys.shift
      @blocked_api_keys[api_key] = Time.now
      api_key
    end
  end
  
  
  def delete_key(api_key)
    timestamp = @blocked_api_keys.delete api_key
    if timestamp == nil
      timestamp = @unblocked_api_keys.delete api_key
      if timestamp == nil
        false
      else
        true
      end
    else
      true
    end
  end
  
  
  def refresh_key(api_key)
    if @unblocked_api_keys[api_key] == nil
      false
    else
      @unblocked_api_keys[api_key] = Time.now
      true
    end
  end
  
  
  def periodic_refresh
    cur_time = Time.now
    @blocked_api_keys.each do |api_key, timestamp|
      if cur_time - timestamp > Constants::UNBLOCK_TIMEOUT
        @blocked_api_keys.delete(api_key)
        @unblocked_api_keys[api_key] = cur_time
        p "API key auto-unblocked: #{api_key}"
      end
    end
    
    @unblocked_api_keys.each do |api_key, timestamp|
      if cur_time - timestamp > Constants::DELETION_TIMEOUT
        @unblocked_api_keys.delete(api_key)
        p "API key auto-deleted: #{api_key}"
      end
    end
  end
  
  
  def list_keys
    p @blocked_api_keys
    p @unblocked_api_keys
  end
  
end

#======================================================#

=begin

server = TCPServer.new('localhost', 2345)
key = Key.new
Thread.new{ key.periodic_refresh }

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

=end