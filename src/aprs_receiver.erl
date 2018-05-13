-module(aprs_receiver).

-export([connect_dump/0]).

connect_dump() ->
    {ok, Socket} = gen_tcp:connect("japan.aprs2.net", 10152, 
        [binary, {active, false}, {packet, line}]),
    {ok, Prompt} = gen_tcp:recv(Socket, 0, 5000),
    % io:format("~s", [Prompt]),
    file:write(standard_io, Prompt),
    ok = gen_tcp:send(Socket, "user NOCALL pass -1 vers apresse 0.01\n"),
    Count = connect_dump_receive_loop(Socket, 100001, 0),
    ok = gen_tcp:close(Socket),
    io:format("CRLF errorcount: ~p~n", [Count]).

connect_dump_receive_loop(_, 0, C) -> C;
connect_dump_receive_loop(S, N, C) ->
    case gen_tcp:recv(S, 0, 1000) of
        {ok, D} ->
            file:write(standard_io, D),
            case binary:match(D, <<13, 10>>) of
                nomatch ->
                file:write(standard_io, <<"# NO CRLF", 13, 10>>),
                C1 = C + 1;
            _ -> C1 = C
            end;
        {error, _} ->
            C1 = C
    end,
    connect_dump_receive_loop(S, N-1, C1).
