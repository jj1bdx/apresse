# APRS-IS message brief analysis results

## Samples

* APRS-IS messages sampled from a APRS-IS Tier-2 network server
* 50000 messages, 60~70 messages/sec, sampled around 2018-05-11 1400UTC
* Each message ends with CR+LF
* Caution: messages are not necessarily encoded in UTF-8

## All messages conformed TNC-2 format

No message violated TNC-2 format, that is

    Source>Destination,relay1,...,relayN:Information<CR><LF>

This means:

* All messages end with CR/LF
* All messages have the source field
* All messages have the destination field
* The first `>` splits the source and the rest of the fields
* The first `:` splits the header fields and the information field 
* The string between the first `>` and the first `:` can be treated as the destination and relays, separated by zero or more `,`
* The callsigns (source, destination, relays) may contain both upper and lower case alphabets, as well as digits and hyphens `-`

## Other findings

* Source could be ONE letter such as `0` (this is not really a callsign, but still a valid APRS-IS message)
* The number of relays sometimes exceeds the APRS or AX.25 upper limit of seven (7)
* The number of commas `,` separating relays could be zero, but all of the sampled messages had at least one comma
* The case of callsigns must be preserved 

[End of document]
