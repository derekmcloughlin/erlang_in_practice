defmodule ChatClient do
    def send_message(router_pid, addressee, message_body) do
        MessageRouter.send_chat_message(router_pid, addressee, message_body)
    end
end
