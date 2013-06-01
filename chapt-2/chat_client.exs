defmodule ChatClient do

  def register_nickname(nickname) do
    MessageRouter.register_nick(nickname, fn(msg) -> ChatClient.print_message(nickname, msg) end)
  end

  def unregister_nickname(nickname) do
    MessageRouter.unregister_nick(nickname)
  end

  def print_message(who, message_body) do
    IO.puts "#{who}: #{message_body}"
  end

  def send_message(addressee, message_body) do
    MessageRouter.send_chat_message(addressee, message_body)
  end

  def start_router() do
    MessageRouter.start()
  end

end
