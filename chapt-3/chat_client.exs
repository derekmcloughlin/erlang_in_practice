defmodule ChatClient do

  def register_nickname(nickname) do
    pid = spawn(ChatClient, :handle_messages, [nickname])
    MessageRouter.register_nick(nickname, pid) 
  end

  def unregister_nickname(nickname) do
    MessageRouter.unregister_nick(nickname)
  end

  def send_message(addressee, message_body) do
    MessageRouter.send_chat_message(addressee, message_body)
  end

  def handle_messages(nickname) do
    receive do
      {:printmsg, message_body} ->
        IO.puts "#{nickname}: #{message_body}"
        handle_messages(nickname)

      :stop ->
        :ok
    end
      
  end

  def start_router() do
    MessageRouter.start()
  end

end
