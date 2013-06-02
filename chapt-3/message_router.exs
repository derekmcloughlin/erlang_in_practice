defmodule MessageRouter do

  @server :message_router
  

  def start() do
    :global.trans {@server, @server},
                  fn() -> 
                    case :global.whereis_name(@server) do
                      :undefined ->
                        pid = spawn(MessageRouter, :route_messages, [HashDict.new])
                        :global.register_name(@server, pid)
                      _ ->
                        :ok
                    end
                  end
  end

  def stop() do
    :global.trans {@server, @server},
                  fn() -> 
                    case :global.whereis_name(@server) do
                      :undefined ->
                        :ok
                      _ ->
                        :global.send @server, :shutdown
                     end
                   end
  end

  def send_chat_message(addressee, message_body) do
    :global.send @server, {:send_chat_msg, addressee, message_body}
  end

  def register_nick(client_name, print_fun) do
    :global.send @server, {:register_nick, client_name, print_fun}
  end

  def unregister_nick(client_name) do
    :global.send @server, {:unregister_nick, client_name}
  end

  def route_messages(clients) do
    receive do
      {:send_chat_msg,  client_name, message_body} ->
        case HashDict.get(clients, client_name) do
          nil ->
            IO.puts("Unknown client")
          client_pid ->
            client_pid <- {:printmsg, message_body}
        end
        route_messages(clients)

      {:register_nick, client_name, print_fun} ->
        route_messages(HashDict.put(clients, client_name, print_fun))

      {:unregister_nick, client_name} ->
        case HashDict.get(clients, client_name) do
          nil ->
            IO.puts("Unknown client")
            route_messages(clients)
          client_pid ->
            client_pid <- :stop
            route_messages(HashDict.delete(clients, client_name))
        end
        

      :shutdown ->
          IO.puts "Shutting down...done."

      _ ->
          IO.puts "Invalid Erlang message received."
          route_messages(clients)
    end

  end

end
