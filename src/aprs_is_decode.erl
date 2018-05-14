-module(aprs_is_decode).

-export([
        init_cp/0,
        decode_header/2
    ]).

init_cp() ->
    {binary:compile_pattern(<<$>>>),
     binary:compile_pattern(<<$:>>),
     binary:compile_pattern(<<$,>>),
     binary:compile_pattern(<<13, 10>>)}.

decode_header(D, {CPS, CPI, CPR, CPEND}) ->
    [Header, InfoCRLF] = binary:split(D, CPI),
    [Source, Destrelay] = binary:split(Header, CPS),
    [Destination|Relay] = binary:split(Destrelay, CPR, [global]),
    Info = binary:replace(InfoCRLF, CPEND, <<>>),
    {Source, Destination, Relay, Info}.
