theme: Zurich, 5 
footer: Kenji Rikitake / Code BEAM STO 2018
slidenumbers: true

<!-- Use Deckset 2.0, aspect ratio 16:9 -->

# [fit] APRS-IS Servers on The BEAM

... or how to prototype APRS-IS software on Erlang and Elixir quickly under a tight deadline

---

![right](jj1bdx-20170321-800x800.jpg)

Kenji Rikitake
1-JUN-2018
Code Beam STO 2018
Stockholm, Sweden
@jj1bdx

---

# Automatic Packet Reporting System (APRS) [^1]

* Amateur radio
* Short messaging (max 256 bytes)
* Broadcast on AX.25 UI frames
* Positing reporting and messaging

[^1]: APRS is a registered trademark of Bob Bruninga, WB4APR

---

# Amateur radio

> *amateur service*: A radiocommunication service for the purpose of self-training, intercommunication and technical investigations carried out by amateurs, that is, by duly authorized persons interested in radio technique solely with a personal aim and without pecuniary interest.  
-- ITU Radio Regulations, Number 1.56

---

# Amateur radio, in plain English

* Solely for technical experiments
* No business communication
* No cryptography, no privacy
* You need a license
* Pre-allocated radio spectrum only
* Third-party traffic handling is prohibited (expect for where allowed, and in case of emergency)

---

# 18 U.S. Code §2511 (2)(g)

* It shall not be unlawful under this chapter or chapter 121 of this title for any person
* (ii) to intercept any radio communication which is transmitted
* (III) by a station operating on an authorized frequency within the bands allocated to the amateur, citizens band, or general mobile radio services [...]

---

# Amateur radio privacy in the USA in plain English

* Anyone can record anything in the amateur radio bands (18 USC 2511(2)(g))
* Anyone can make a backup and disclosure of the information transmitted in amateur radio bands (18 USC chapter 121) 
* ... therefore **NO PRIVACY** [^2]

[^2]: Radio regulation details may differ in the country, region, or economy where the radio station operates.

---

# Then WHY amateur radio?

* You can *experiment* your ideas using radio transmitters and antennas
* It is an origin of all the internet cultures emerged after 1980s: sharing, helping each others, and the global friendship without borders
* ... and it's fun

---

![original](jj1bdx-packet-radio-1987.JPG)

# [fit] Me enjoying amateur radio, circa 1987

---

# Messaging on amateur radio

![right, fit](instagram-raspi-receiver.jpg)

* AX.25 protocol since 1980s
* 1200bps Bell202 + audio FM transceivers
* 9600bps GMSK + specific transceivers
* Modern gears: Raspberry Pi + SDR dongle for receiver

---

# [fit] A YouTube example of 1200bps AX.25/APRS sound [^3]

![](https://www.youtube.com/watch?v=32yuWezqjrI)

[^3]: by radionerd1, <https://www.youtube.com/watch?v=32yuWezqjrI>

---

![fit](Stockholm-aprs-fi-20180526.png)

---

![fit](Toyonaka-aprs-fi-20180526.png)

---

# [fit] Thank you
# [fit] Questions?

<!--
Local Variables:
mode: markdown
coding: utf-8
End:
-->
