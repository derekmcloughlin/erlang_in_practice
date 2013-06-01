defmodule MessageRouter do

    def start() do
        spawn(MessageRouter, :route_messages, [])
    end

    def stop(router_pid) do
        router_pid <- :shutdown
    end

    def send_chat_message(router_pid, addressee, message_body) do
        router_pid <- {:send_chat_msg, addressee, message_body}
    end

    def route_messages do
        receive do
            {:send_chat_msg,  addressee, message_body} ->
                IO.puts "SENDING message:"
                addressee <- {:recv_chat_msg, message_body}
                route_messages
            {:recv_chat_msg, message_body} ->
                IO.puts "Got message:"
                IO.puts message_body
                route_messages
            :shutdown ->
                IO.puts "Shutting down...done."
            _ ->
                IO.puts "Invalid Erlang message received."
        end
    end
    
end
