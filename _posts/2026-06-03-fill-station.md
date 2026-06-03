---
layout: post
title: Fill Station
subtitle: Tracking gas fills and cylinder maintenance for a dive shop
#cover-img: /assets/img/path.jpg
gh-repo: MarshallAsch/fill-station
gh-badge: [star, follow]
image: /assets/img/scuba-sticker.png
tags: [node, typescript, scuba, open source]
categories: projects
---

If you have read my [scuba post]({% post_url 2025-01-22-scuba %}) you know I spend a lot of
my free time underwater, so it was only a matter of time before one of my projects ended up
pointed at the dive world. This one I built together with [Kellen Wiltshire](https://kellenwiltshire.com/),
and it came out of watching how much paperwork goes into keeping a dive shop's gear safe and
legal to use.

Every cylinder that gets filled needs to be tracked. When was its last hydrostatic test? When
was the last visual inspection? Is it O2 clean? What was the start and end pressure on that
last nitrox fill? Traditionally all of this lives in paper logbooks and binders, which works
right up until you actually need to find something. So I built a web app to keep track of it
all in one place.

Fill Station manages the things a fill operator actually cares about:

- **Gas fill tracking** -- record air, nitrox, and trimix fills with start and end pressures
- **Visual inspections** -- a full PSI inspection workflow with per-section grading
- **Cylinder management** -- hydro dates, visual dates, O2 clean status, manufacturer, and service pressure all tracked per tank
- **Customer accounts** -- manage clients, their certifications, and the cylinders they own
- **Compressor maintenance** -- log oil changes, filter changes, air tests, and service hours
- **Email reminders** -- automated notifications when a hydro test or visual inspection is coming due

Because not everyone walking into a shop should be able to do everything, there are
proper roles baked in -- regular users, fillers, inspectors, and admins -- with permissions
enforced at the route level. Login is handled through OIDC (I run [Authelia]) and Google OAuth
via NextAuth, so there are no passwords for the app itself to manage.

Under the hood it is built with Next.js 16 and React 19, TypeScript, Redux Toolkit and React
Query on the frontend, and Sequelize talking to a MariaDB database. The whole thing runs from a
single `docker compose up` that spins up the database, a mail server for testing, and the app
itself, running migrations and seeding on first boot.

You can see it running live at [dive.marshallasch.ca](https://dive.marshallasch.ca), and the
code is open source over on [GitHub](https://github.com/MarshallAsch/fill-station) if you want
to take a look.

[Authelia]: https://www.authelia.com/
