---
layout: post
title: liquidctl
subtitle: Cross-platform CLI and Python drivers for AIO liquid coolers and other devices
#cover-img: /assets/img/liquidctl-logo.png
gh-repo: liquidctl/liquidctl
gh-badge: [star, follow]
image: /assets/img/liquidctl-logo.png
tags: [python, cli, open source]
categories: projects
---


Earlier in the year, shortly after the COVID-19 ~~world wide apocalypse~~ pandemic began I decided it was finally time that I build a computer.
I got a nice Corsair H100i Platinum all-in-one liquid cooler to keep my processor nice and cool, and have all the pretty RBG lighting effects and it was awesome.
Only there was one catch, everyone seems to only make the RGB and control software for Windows.
I don't use Windows.
What am I going to do? Nothing for several months it seems.

After a while of using my nice new computer (with the default RBG settings), October came around, and every year Github and Digital Ocean put on an awesome event called [Hacktoberfest](hacktoberfest.digitalocean.com) where you can get a cool t-shirt for contributing to open source projects.
This was something that I had wanted to do for several years, actually make some meaningful contributions to real projects, the hard part is finding a project I cared about, one that I could actually wrap my head around to contribute something, and something that would also be useful to me.

This is where liquidctl came in, I found it while I was working on finding a way to control my cooler.
It seemed awesome, it could control the fan and pump speeds as well as the RGB effects on a number of different devices, but not mine.
This made it the perfect project for me to work on for the month of October.

Before the month was over I ended up getting 9 pull requests submitted to the project!!!
This was a huge accomplishment for me, as most of the work I have done up until now has been school related and this was my first open source project that I worked on that wasn't one of the ones I was on the team for.

Jonas (the project maintainer) ended up asking if I wanted to join as a maintainer for the project (another huge accomplishment).


While working on this project there have been a ton of new leaning experiences (some of which I am going to try to write separate posts about).
- Working with a python project
- working on production level code, and not just my hacked together projects, and something that real people are using
- reverse engineering USB protocols
- looking into the legal differences between reverse engineering vs. decompiling software to re-implement it
- user support for debugging issues in the code-base
- working with hardware and the scary-ness that goes along with that
- writing testable code (and the tests to go along with that)



All in all, it has been a fantastic experience working on this project and I am super excited to be continuing with it beyond the initial Hactoberfest.
