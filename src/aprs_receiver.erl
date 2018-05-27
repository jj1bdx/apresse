-module(aprs_receiver).

-export([start/0,
         connect_dump/0]).

start() ->
    loop().

loop() ->
    connect_dump(),
    loop().

connect_dump() ->
    {ok, Socket} = gen_tcp:connect("fukuoka.aprs2.net", 10152, 
        [binary, {active, false}, {packet, line},
            {nodelay, true}, {keepalive, true}
        ]),
    {ok, Prompt} = gen_tcp:recv(Socket, 0, 5000),
    io:format("~s", [Prompt]),
    ok = gen_tcp:send(Socket, "user N6BDX pass -1 vers apresse 0.01\n"),
    C = connect_dump_receive_loop(Socket, 0, aprs_is_decode:init_cp(), true),
    io:format("Total: ~p packets~n~n", [C]),
    ok = gen_tcp:close(Socket).

connect_dump_receive_loop(_, C, _, false) -> C;
connect_dump_receive_loop(S, C, CP, true) ->
    case gen_tcp:recv(S, 0, 10000) of
        {ok, D} ->
            io:format("~s", [D]),
            case binary:first(D) of
                $# -> io:format("Comment: not a packet~n~n", []);
                _ -> {Source, Destination, Relay, Info} = 
                        aprs_is_decode:decode_header(D, CP),
                        io:format("Source: ~s~nDestination: ~s~nRelay: ~p~nInfo: ~s~n",
                            [Source, Destination, Relay, Info]),
                        io:format("Decoded: ~p~n~n", 
                            [aprs_is_decode:info_dispatch(Info)])
            end;
        {error, E} ->
            io:format("Error: ~p~n~n", [E]),
            connect_dump_receive_loop(S, C, CP, false)
    end,
    connect_dump_receive_loop(S, C + 1, CP, true).

