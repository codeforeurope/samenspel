# Teambox
## Collaboration just got better

[Teambox is project management software](http://teambox.com/) built on Ruby on Rails with a focus on collaboration.

Teambox workflow is project-centered; each project being visible only to people invited to it.
Projects have a status wall, conversations, tasks, shared pages and file uploads. You can even post
to everywhere just using email.

You can [try Teambox online](http://teambox.com/) for free to see how it works. Teambox is open-source software, meaning you
can also download it, change its code and host yourself.

Project info
------------

- Official website: <http://teambox.com/>
- Code repository: <http://github.com/teambox/teambox>
- End user guide: <http://guide.teambox.com>
- Open-source contributors: <http://github.com/teambox/teambox/contributors>
- License: [GNU Affero GPL 3](https://github.com/teambox/teambox/blob/master/LICENSE)

Installation
------------

Hop to [our wiki](http://wiki.github.com/teambox/teambox/ "Teambox wiki") to get detailed information on
installing Teambox.

Support
-------

Community support for the open source user of Teambox is at [Teambox community](http://teambox.com/community). Its a Teambox-powered public project, free for anyone to join on [Teambox.com](http://teambox.com).

The support for the hosted version of Teambox, [Teambox.com](http://teambox.com), is available at [help.teambox.com](http://help.teambox.com/).

Contributing
------------

Follow our [contributor guide](https://github.com/teambox/teambox/wiki/Contributing) on our github wiki.

Thanks to the many Ruby projects we're using and the Famfamfam icon collection.

What's new in this fork?
------------------------

- Disabled 'community mode' so you can now create more than one organizations. Every organization may have its own projects (like as in hosted version).
- Implemented authentication via LDAP with automatic account creation. Also fixed "Forgot your password" to work correctly with users authenticated via LDAP.
- Added LDAP support for invitations. When you invite colleague by username and he's known in LDAP, it will automaticaly create user account for him and send e-mail invitation for log-in.
- Changed default time-zone to Prague and first day of week to monday :-)
- Used [fixed](https://github.com/davidmm/immortal) gem Immortal that works correctly with PostgreSQL etc.
- Fixed OAuth authentication controller for Google (see [this page](https://teambox.com/projects/teambox/conversations/76950)).
- Introduced new role named supervisor and ability to create organizations. You can allow creating new organizations only to supervisors (or every user like as before).
- Fixed broken processing of incoming e-mail attachments and multipart messages (thanks to [mrtorrent](https://github.com/mrtorrent/teambox/commit/74d9204b1fa0d5f18180b09f8d6d19ce49a16d7f) for the first part). Added filter that removes attachments of unwanted MIME type. That's for removing S/MIME signature files which are useless in Teambox.
