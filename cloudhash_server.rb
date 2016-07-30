require 'socket'

module CloudHash
  class Server
    SIZE_OF_INT = [11].pack('i').size

    def initialize(port)
      @server = TCPServer.new port
      puts "Listening on port #{@server.local_address.ip_port}"
      @storage = {}
    end

    def start
      Socket.accept_loop(@server) do |c|
        handle c
        c.close
      end
    end

    def handle(c)
      paacked_msg_length = c.read(SIZE_OF_INT)
      msg_length = paacked_msg_length.unpack('i').first

      request = c.read(msg_length)
      c.write process(request)
    end

    def process(req)
      cmd, key, val = req.split
      case cmd.upcase
      when 'GET'
        @storage[key]
      when 'SET'
        @storage[key] = val
      end
    end
  end
end

s = CloudHash::Server.new(4481)
s.start
