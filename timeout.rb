require 'socket'
require 'timeout'

Socket.tcp_server_loop(4481) do |c|
  begin
    c.read_nonblock(4096)
  rescue Errno::EAGAIN
    if IO.select([c], nil, nil, timeout)
      retry
    else
      raise Timeout::Error
    end
  end

  c.close
end
