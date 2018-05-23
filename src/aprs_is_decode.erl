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

info_dispatch_type(_, <<>>) -> {undefined, nofield};
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
info_dispatch_type($<, Field) -> {capabilities, Field};
info_dispatch_type($>, Field) -> {status, Field};
info_dispatch_type($;, Field) -> {object, Field};
info_dispatch_type($), Field) -> {item, Field};
info_dispatch_type($_, Field) -> {weather_report, Field};
info_dispatch_type($$, Field) -> {nmea, Field};
info_dispatch_type($,, Field) -> {test_data, Field};
info_dispatch_type(${, Field) -> {user_defined, Field};
info_dispatch_type($}, Field) -> {third_party, Field};
info_dispatch_type($', Field) -> {mic_e_current, Field};
info_dispatch_type($`, Field) -> {mic_e_old, Field};
info_dispatch_type($[, Field) -> {grid_locator, Field};
info_dispatch_type($*, Field) -> {weather_station_star, Field};
info_dispatch_type($#, Field) -> {weather_station_sharp, Field};
info_dispatch_type($%, Field) -> {agrelo, Field};
info_dispatch_type(_, Field) -> {undefined, Field}.

position_nomsg(T, Field) when $0 =< T, T =< $9 ->
    {position, no_message,
        {uncompressed, position_decode_uncompressed(Field)}};
position_nomsg($/, Field) ->
    {position, no_message,
        {compressed, position_decode_compressed(Field)}};
position_nomsg(_, Field) -> {undefined, Field}.

position_msg(T, Field) when $0 =< T, T =< $9 ->
    {position, no_message,
        {uncompressed, position_decode_uncompressed(Field)}};
position_msg($/, Field) ->
    {position, message,
        {compressed, position_decode_compressed(Field)}};
position_msg(_, Field) -> {undefined, Field}.

position_time_nomsg(T, Field) when $0 =< T, T =< $9 ->
    {position, no_message,
        {uncompressed, time_decode_uncompressed(Field)}};
position_time_nomsg($/, Field) ->
    {position_time, no_message,
        {compressed, time_decode_compressed(Field)}};
position_time_nomsg(_, Field) -> {undefined, Field}.

position_time_msg(T, Field) when $0 =< T, T =< $9 ->
    {position, no_message,
        {uncompressed, time_decode_uncompressed(Field)}};
position_time_msg($/, Field) ->
    % compressed position_time format;
    {position_time, message, 
        {compressed, time_decode_compressed(Field)}};
position_time_msg(_, Field) -> {undefined, Field}.

time_decode_uncompressed(Field) ->
    case erlang:byte_size(Field) >= 7 of
        true -> 
            <<Time:6/binary, TimeZone:8, Rest/binary>> = Field,
            {time, Time, TimeZone,
                position_decode_uncompressed(Rest)};
        false ->
            {undefined}
    end.

position_decode_uncompressed(Field) ->
    case erlang:byte_size(Field) >= 18 of
        true -> 
            <<Lat:8/binary, SymID:8, Long:9/binary, Rest/binary>> = Field,
            {{longlat, 
                 latitude_decode_uncompressed(Lat),
                 longitude_decode_uncompressed(Long)},
                {symid, SymID}, Rest};
        false ->
            {undefined}
    end.

time_decode_compressed(Field) ->
    case erlang:byte_size(Field) >= 7 of
        true -> 
            <<Time:6/binary, TimeZone:8, Rest/binary>> = Field,
            {time, Time, TimeZone,
                position_decode_compressed(Rest)};
        false ->
            {undefined}
    end.

position_decode_compressed(Field) ->
    case erlang:byte_size(Field) >= 13 of
        true -> 
            <<_:8, LatComp:4/binary, LongComp:4/binary,
              Symbol:4/binary, Rest/binary>> = Field,
            {{longlat, 
                 base91_to_latitude(LatComp),
                 base91_to_longitude(LongComp)},
                {symbol, Symbol}, Rest};
        false ->
            {undefined}
    end.

space_to_zero(C) ->
    case C of
        % treat space as zero
        32 -> $0;
        C -> C
    end.

digits_with_space(D1, D2) ->
    ((space_to_zero(D1) - $0) * 10) +
     (space_to_zero(D2) - $0).

dmh_to_degree(D, M, H) ->
    (((float(H) / 100.0) + float(M)) / 60.0) + float(D).

latitude_decode_uncompressed(Lat) ->
    <<D1:8, D2:8, M1:8, M2:8, P:8, H1:8, H2:8, NS:8>> = Lat,
    L = dmh_to_degree(
          ((D1 - $0) * 10) + (D2 - $0),
           digits_with_space(M1, M2),
           digits_with_space(H1, H2)),
    case P of
        $. ->
            case NS of
                $N -> L;
                $S -> 0.0 - L; 
                _ -> undefined
            end;
        _ -> undefined
    end.

longitude_decode_uncompressed(Long) -> 
    <<D0:8, D1:8, D2:8, M1:8, M2:8, P:8, H1:8, H2:8, EW:8>> = Long,
    L = dmh_to_degree(
          ((D0 - $0) * 100) + ((D1 - $0) * 10) + (D2 - $0),
           digits_with_space(M1, M2),
           digits_with_space(H1, H2)),
    case P of
        $. ->
            case EW of
                $E -> L;
                $W -> 0.0 - L; 
                _ -> undefined
            end;
        _ -> undefined
    end.

base91_to_integer(Comp) ->
    <<V1:8, V2:8, V3:8, V4:8>> = Comp,
    ((((((V1 - 33) * 91) + (V2 - 33)) * 91) + (V3 - 33)) * 91) + (V4 - 33).

base91_to_latitude(Comp) ->
    90.0 - (float(base91_to_integer(Comp)) / 380926.0).

base91_to_longitude(Comp) ->
    -180.0 + (float(base91_to_integer(Comp)) / 190463.0).

