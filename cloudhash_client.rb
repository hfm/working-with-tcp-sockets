require 'socket'

module CloudHash
  class Client
    class << self
      attr_accessor :host, :port
    end

    def self.get(key)
      request "GET #{key}"
    end

    def self.set(key, val)
      request "SET #{key} #{val}"
    end

    def self.request(string)
      @c = TCPSocket.new(host, port)

      msg_length = string.size
      packed_msg_length = [msg_length].pack 'i'

      @c.write(packed_msg_length)
      @c.write(string)
      @c.close_write
      @c.read
    end
  end
end

CloudHash::Client.host = 'localhost'
CloudHash::Client.port = 4481

puts CloudHash::Client.set 'prez', 'obama'
puts CloudHash::Client.get 'prez'
puts CloudHash::Client.get 'vp'
