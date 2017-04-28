# gcp-snapshots
PowerShell scripts to automate Google Cloud Platform disk snapshot creation and retention.

Warning - Use these scripts at your own risk.  I accept no responsibility for you use of them.  However, if you run into any issues please let me know so I can work to improve the scripts.

As part of a project I am working on, I needed a way to automate disk snapshot creation and retention.  I found several good examples in BASH etc.  However, I was unable to find anything in native PowerShell that I liked.  So, I wrote some scripts and decided to publish them here in the hope of helping someone else.

- create-snaps.ps1 automates snapshot creation.
- remove-snaps.ps1 automates snapshot cleanup based on the age of the snapshot.

Obviously, you will need to schedule these to run at some interval.  I've used Windows task scheduler for that purpose, and it seems to work great.