defmodule MessageRouter do

  @server :message_router
  

  def start() do
    pid = spawn(MessageRouter, :route_messages, [HashDict.new])
    :global.register_name(@server, pid)
  end

  def stop() do
    :global.send @server, :shutdown
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
        :global.send @server, {:recv_chat_msg, client_name, message_body}
        route_messages(clients)

      {:recv_chat_msg, client_name, message_body} ->
        case HashDict.get(clients, client_name) do
          nil ->
            IO.puts("Unknown client")
          print_fun ->
            print_fun.(message_body)
        end
        route_messages(clients)

      {:register_nick, client_name, print_fun} ->
        route_messages(HashDict.put(clients, client_name, print_fun))

      {:unregister_nick, client_name} ->
        route_messages(HashDict.delete(clients, client_name))

      :shutdown ->
          IO.puts "Shutting down...done."

      _ ->
          IO.puts "Invalid Erlang message received."
          route_messages(clients)
    end

  end

end
