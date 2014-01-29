# Samenspel

Samenspel is a project management software built on Ruby on Rails with a focus on team collaboration, based on the [crewmate fork](https://github.com/crewmate/crewmate) of [Teambox](https://github.com/teambox/teambox).

Workflow is project-centered; each project being visible only to people invited to it.
Projects have a status wall, conversations, tasks, shared pages and file uploads. You can even post
to everywhere just using email.

This fork of the Crewmate repository (a maintained fork of Teambox) has been developed by "@maggix":https://github.com/maggix and "@ohyoonkwn":https://github.com/ohyoonkwon for the 2013 edition of "Code for Europe":http://www.codeforeurope.net in Amsterdam. 


Project info
------------

- Code repository: <http://github.com/codeforeurope/samenspel>
- Open-source contributors: <http://github.com/codeforeurope/samenspel/contributors>
- License: [GNU Affero GPL 3](https://github.com/codeforeurope/samenspel/blob/master/LICENSE)

Code statuses
-------------

* [![Build Status](https://travis-ci.org/cvut/teambox.png)](https://travis-ci.org/codeforeurope/samenspel) 

Installation
------------

Hop to [our wiki](http://wiki.github.com/codeforeurope/samenspel/ "Wiki") to get detailed information on
installing the app.

Support
-------

Community support for the app is at [https://github.com/codeforeurope/samenspel](https://github.com/codeforeurope/samenspel). 

Contributing
------------

Follow our [contributor guide](https://github.com/codeforeurope/samenspel/wiki/Contributing) on our github wiki.

Thanks to the many Ruby projects we're using and the Famfamfam icon collection.

What's new in this fork?
------------------------

### Code for Europe specific
- Added management of Team Principles upon which Projects are managed
- New Timeline functionality to view the story of Projects
- Contact management (a sort of shared 'address book')

### Features
- Disabled 'community mode' so you can now create more than one organizations. Every organization may have its own projects (like as in hosted version).
- Implemented authentication via LDAP with automatic account creation. Also fixed "Forgot your password" to work correctly with users authenticated via LDAP.
- Added LDAP support for invitations. When you invite colleague by username and he's known in LDAP, it will automaticaly create user account for him and send e-mail invitation for log-in.
- Changed default time-zone to Prague and first day of week to monday :-)
- Introduced new role named supervisor and ability to create organizations. You can allow creating new organizations only to supervisors (or every user like as before).
- Option to set organization as default for all new users; every newly signed user will be automatically added to all default organizations as participant (i.e. will be able to create new projects).
- Support for Google Analytics tracking.

### Bug fixies 
- Used [fixed](https://github.com/davidmm/immortal) gem Immortal that works correctly with PostgreSQL etc.
- Fixed OAuth authentication controller for Google (see [this page](https://teambox.com/projects/teambox/conversations/76950)).
- Fixed broken processing of incoming e-mail attachments and multipart messages (thanks to [mrtorrent](https://github.com/mrtorrent/teambox/commit/74d9204b1fa0d5f18180b09f8d6d19ce49a16d7f) for the first part). Added filter that removes attachments of unwanted MIME type. That's for removing S/MIME signature files which are useless in Teambox.
- Fixed issue with incoming e-mails that contains non-ASCII compatible characters (e.g. Czech diacritic). This charset problem was even with text/plain in UTF-8! Successfully tested: ordinary text/plain email, multipart emails - S/MIME signed, with inline picture, with any attachments and all combinations. I suppose that every e-mail has at least one text/plain part, HTML-only emails doesn't work.