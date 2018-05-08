-module(aprs_receiver).

-export([connect_dump/0]).

connect_dump() ->
    {ok, Socket} = gen_tcp:connect("japan.aprs2.net", 10152, 
        [{active, false}, {packet, line}]),
    {ok, Prompt} = gen_tcp:recv(Socket, 0, 5000),
    io:format("~s", [Prompt]),
    ok = gen_tcp:send(Socket, "user NOCALL pass -1 vers apresse 0.01\n"),
    receive_loop(Socket).

receive_loop(S) ->
    case gen_tcp:recv(S, 0, 1000) of
        {ok, D} ->
            io:format("~s", [D]);
        {error, _} ->
            true
    end,
    receive_loop(S).
