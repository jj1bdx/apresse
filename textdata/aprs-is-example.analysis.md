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

## Top 14 data type IDs of APRS information fields

(This covers 49261 or 98.562% of 50000 messages)

|ID |number | Description (from APRS Specification)|
|:-:|------:|:------------|
| ! | 11611 | Position report without timestamp, no APRS messaging |
| ; | 8483 | Object report with position |
| @ | 6677 | Position report with timestamp, with APRS messaging |
| = | 6544 | Position report without timestamp, with APRS messaging |
| ` | 4622 | Mic-E Format data |
| > | 2558 | Status |
| T | 2555 | Telemetry data |
| : | 2550 | Message |
| / | 1201 | Position report with timestamp, no APRS messaging |
| < | 1082 | Station capabilities |
| ' | 748 | Mic-E Format data |
| _ | 272 | Weather report without position |
| ) | 194 | Item |
| $ | 164 | Raw GPS data |

[End of document]
