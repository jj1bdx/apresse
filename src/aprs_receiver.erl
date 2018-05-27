-module(aprs_receiver).
-export([start/0,
         init/0,
         connect_dump/0]).

-include_lib("stdlib/include/ms_transform.hrl").

start() ->
    spawn_link(?MODULE, init, []).

init() ->
    ets:new(aprs_positions, [set, protected, named_table]),
    loop().

loop() ->
    connect_dump(),
    timer:sleep(timer:seconds(rand:uniform(6) + 4)),
    loop().

connect_dump() ->
    {ok, Socket} = gen_tcp:connect("fukuoka.aprs2.net", 10152, 
        [binary, {active, false}, {packet, line},
            {nodelay, true}, {keepalive, true}
        ]),
    {ok, _Prompt} = gen_tcp:recv(Socket, 0, 5000),
    ok = gen_tcp:send(Socket, "user N6BDX pass -1 vers apresse 0.01\n"),
    _C = connect_dump_receive_loop(Socket, 0, aprs_is_decode:init_cp(), true),
    ok = gen_tcp:close(Socket).

connect_dump_receive_loop(_, C, _, false) -> C;
connect_dump_receive_loop(S, C, CP, true) ->
    State = case gen_tcp:recv(S, 0, 10000) of
            {ok, D} ->
                case binary:first(D) of
                    $# -> comment; % do nothing
                    _ -> put_ets(aprs_is_decode:decode_header(D, CP))
                end;
            {error, _E} ->
                error
            end,
    Continue = case State of
                comment -> true;
                error -> false;
                _ -> true
            end,
    cleanup_ets(C), 
    connect_dump_receive_loop(S, C + 1, CP, Continue).

put_ets({Source, _Dest, _Relay, Info}) ->
    Time = erlang:monotonic_time(millisecond),
    put_ets(Time, Source, parse_message(aprs_is_decode:info_dispatch(Info))).
    
parse_message( {undefined, _}) -> undefined;
parse_message(
    {position, no_message,
        {uncompressed, {time, _, _, {{longlat, Lat, Long}, _, _}}}}) ->
    {Lat, Long};
parse_message(
    {position, no_message,
        {uncompressed, {{longlat, Lat, Long}, _, _}}}) ->
    {Lat, Long};
parse_message(
    {position, no_message,
        {compressed, {time, _, _, {{longlat, Lat, Long}, _, _}}}}) ->
    {Lat, Long};
parse_message(
    {position, no_message,
        {compressed, {{longlat, Lat, Long}, _, _}}}) ->
    {Lat, Long};
parse_message(
    {position, message,
        {uncompressed, {time, _, _, {{longlat, Lat, Long}, _, _}}}}) ->
    {Lat, Long};
parse_message(
    {position, message,
        {uncompressed, {{longlat, Lat, Long}, _, _}}}) ->
    {Lat, Long};
parse_message(
    {position, message,
        {compressed, {time, _, _, {{longlat, Lat, Long}, _, _}}}}) ->
    {Lat, Long};
parse_message(
    {position, message,
        {compressed, {{longlat, Lat, Long}, _, _}}}) ->
    {Lat, Long};
parse_message(_) -> undefined.

put_ets(Time, Source, {Lat, Long}) ->
    % io:format("~p~n", [{Time, Source, Lat, Long}]),
    ets:insert(aprs_positions, {Time, Source, Lat, Long});
put_ets(_Time, _Source, _) -> true. % do nothing

cleanup_ets(C) when (C rem 1000) == 0 ->
    T = erlang:monotonic_time(millisecond) - 180000,
    ets:select_delete(
        aprs_positions,
        ets:fun2ms(fun({Time, _, _, _}) -> Time < T end));
cleanup_ets(_) -> 0.
