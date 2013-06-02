Note: If you try out this code on two nodes, as follows:

Node1:
    iex --sname foo --cookie derek
    iex(foo@snowy-2)1> ChatClient.start_router
    :yes
    iex(foo@snowy-2)2> :global.registered_names
    [:message_router]

Node2: 
    iex --sname bar --cookie derek
    iex(bar@snowy-2)1> :global.registered_names
    []

Node2 doesn't know about the registered names until it knows about Node1.

The easiest way to do this is to ping Node1 from Node2:


    iex(bar@snowy-2)2> :net_adm.ping :"foo@snowy-2"
    :pong

Now the message router is registered:

    iex(bar@snowy-2)3> :global.registered_names
    [:message_router]
