---
layout: post
title: A Journy into wiring a house for internet
subtitle: For when wifi isnt good enough
tags: [networking, building, hands-on]
categories: blog
comments: true
readtime: true
---

About a year ago, around the beginning of 2020 before the apocalypse (AKA COVID-19) began, I starting messing around with servers and networking.
I am a developer and I absolutely love setting up servers and just having them around to run various projects, and raspberry pi's were starting to
not quite cut it anymore.
But, that is not the point of this post, as I went through setting up my [raspbery pi's], [NUC], server, and NAS I ran out of ethernet ports on my Rogers router.
This got me looking for a switch, and a new wireless access point, and a router.
I went down quite the rabbit hole and got a bunch of stuff from [Ubiquitu] (which I find very nice) and got my network all
set up the way I want it.
I have an isolated wifi network for questionable IoT devices, I have control over port forwarding rules, [PoE], and all the fun stuff that goes
along with that.


Fast forward to later in the year when my sister Kristen buys a house.
Some people would call it a "Death trap"[^1].
It is in the middle of nowhere, had old cow pens in the basement (from when that was normal), wiring that had not been updated since electricity was first invented, and more importantly for the sake of this post crappy wifi coverage, and no one wants crappy wifi in their new house.
Kristen and Joe are very hands on people and decided to remedy these problems by tearing all the insides out and trying their hand at putting it back together themselves (to Karens dismay).


And I decided to help solve one of those problems.
After excitedly texting Kristen "Congratulations on getting a new house, can I come over and hit things with a sledge hammer!!!" I did just that and tore out a wall, and maybe some floor too, but lets not talk about that.
I also started planning out where in the house would be good spots to have ethernet plugs and where some good places to put wifi access points would be, since its way easier to run the wires when there are no walls then it is to decide you want it later on.

![Me, Maria, and Kristen demoing her house](/assets/img/kristens_house.jpg "Marshall, Maria, and Kristen"){:.picture width="200"}


Once I got that task I started reading about residential wiring standards, namely the [ANSI/TIA-570-D] Residential Telecommunications Infrastructure Standard, different cable termination methods,
the differences between riser and plenum cable, which cable standard to use, how many jacks to put where and so on.
For me this was an interesting project, because I am finishing up university and thinking about what I want to do with my life and part of that includes
thinking of where I want to live and house features that will be important to me.
And I really do live on the internet and I have quite a number of things that need to be plugged in (because wired is always better then wireless).
There are several things to consider when coming up with my amazing plan:

- What rooms will have things plugged in?
- How many things will need to be plugged in in each room?
- What types of devices will be plugged in?
- Where in the room would things go?
- How much overkill should there be?
- Where will wifi be used most?
- Are there going to be security cameras?
- What happens if the rooms purpose changes?
- where should the other end of the cables all go?
- How much money can I spend?


Each of those questions is important and influences decisions that will be made.
And I'll break each of those into their own little paragraph.


### What rooms will have things plugged in? And what might be plugged in there?

When planning on running cables you obviously want to run cables to places where they will be used, and not to places where they wont.
It probably doesn't make much sense to have an ethernet jack in your bathroom or in a laundry room, but putting at least one in the office is a no brainer.
Next is what will be plugged in, the devices that you plug in in the living room will most likely be different for a bedroom, living room, or office
and will have different speed requirements.

- Office
  - desktops
  - printer
  - phone[^2]
- living room
  - smart tv
  - game consoles
  - phone[^2]
- bedroom
  - computer
  - smart tv
  - phone[^2]
- hallways
  - camera
  - wifi access point
- atic
  - external security camera


### Where in the room would the devices go and what would happen if you change the purpose of the room?

This is a larger thing to think about




[^1]: A very loving description of the house from Karen.
[^2]: An RJ11 phone line can be connected to an RJ45 wall jack and be used as a phone line as long as the other end is wired to a phone jack and *not* and ethernet switch.


<!--links -->
[PoE]: https://en.wikipedia.org/wiki/Power_over_Ethernet
[raspbery pi's]: https://www.raspberrypi.org/)
[NUC]: https://www.intel.ca/content/www/ca/en/products/boards-kits/nuc.html
[Ubiquitu]: https://www.ui.com/


[ANSI/TIA-570-D]: https://blog.siemon.com/standards/ansi-tia-570-d-residential-telecommunications-infrastructure-standard
