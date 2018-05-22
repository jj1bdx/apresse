-module(aprs_is_decode).

-export([
        init_cp/0,
        decode_header/2,
        info_dispatch/1
    ]).

init_cp() ->
    {binary:compile_pattern(<<$>>>),
     binary:compile_pattern(<<$:>>),
     binary:compile_pattern(<<$,>>)}.

decode_header(D, {CPS, CPI, CPR}) ->
    [Header, InfoCRLF] = binary:split(D, CPI),
    [Source, Destrelay] = binary:split(Header, CPS),
    [Destination|Relay] = binary:split(Destrelay, CPR, [global]),
    Info = binary:part(InfoCRLF, 0, erlang:byte_size(InfoCRLF) - 2),
    {Source, Destination, Relay, Info}.

info_dispatch(Info) ->
    <<Type:8, Rest/binary>> = Info,
    info_dispatch_type(Type, Rest).

info_dispatch_type($!, Field) ->
    position_nomsg(binary:first(Field), Field); 
info_dispatch_type($=, Field) ->
    position_msg(binary:first(Field), Field); 
info_dispatch_type($/, Field) ->
    position_time_nomsg(binary:first(Field), Field); 
info_dispatch_type($@, Field) ->
    position_time_msg(binary:first(Field), Field); 
info_dispatch_type($T, Field) -> {telemetry, Field};
info_dispatch_type($:, Field) -> {message, Field};
info_dispatch_type($?, Field) -> {query, Field};
info_dispatch_type($>, Field) -> {status, Field};
info_dispatch_type($;, Field) -> {object, Field};
info_dispatch_type($), Field) -> {item, Field};
info_dispatch_type($$, Field) -> {nmea, Field};
info_dispatch_type($,, Field) -> {test_data, Field};
info_dispatch_type($}, Field) -> {third_party, Field};
info_dispatch_type(_, Field) -> {undefined, Field}.

position_nomsg(T, Field) when $0 =< T, T =< $9 ->
    % uncompressed position format
    {position, no_message, {uncompressed, Field}};
position_nomsg($/, Field) ->
    % compressed position format;
    {position, no_message, {compressed, Field}};
position_nomsg(_, Field) -> {undefined, Field}.

position_msg(T, Field) when $0 =< T, T =< $9 ->
    % uncompressed position format
    {position, message, {uncompressed, Field}};
position_msg($/, Field) ->
    % compressed position format;
    {position, message, {compressed, Field}};
position_msg(_, Field) -> {undefined, Field}.

position_time_nomsg(T, Field) when $0 =< T, T =< $9 ->
    % uncompressed position_time format
    {position_time, no_message, {uncompressed, Field}};
position_time_nomsg($/, Field) ->
    % compressed position_time format;
    {position_time, no_message, {compressed, Field}};
position_time_nomsg(_, Field) -> {undefined, Field}.

position_time_msg(T, Field) when $0 =< T, T =< $9 ->
    % uncompressed position_time format
    {position_time, message, {uncompressed, Field}};
position_time_msg($/, Field) ->
    % compressed position_time format;
    {position_time, message, {compressed, Field}};
position_time_msg(_, Field) -> {undefined, Field}.
