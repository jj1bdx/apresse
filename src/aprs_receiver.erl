-module(aprs_receiver).

-export([connect_dump/0]).

connect_dump() ->
    {ok, Socket} = gen_tcp:connect("japan.aprs2.net", 10152, 
        [{active, false}, {packet, line}]),
    {ok, Prompt} = gen_tcp:recv(Socket, 0, 5000),
    % io:format("~s", [Prompt]),
    file:write(standard_io, Prompt),
    ok = gen_tcp:send(Socket, "user NOCALL pass -1 vers apresse 0.01\n"),
    connect_dump_receive_loop(Socket, 100000),
    ok = gen_tcp:close(Socket).

connect_dump_receive_loop(_, 0) -> ok;
connect_dump_receive_loop(S, N) ->
    case gen_tcp:recv(S, 0, 1000) of
        {ok, D} ->
            % io:format("~s", [D]);
            file:write(standard_io, D);
        {error, _} ->
            true
    end,
    connect_dump_receive_loop(S, N-1).
