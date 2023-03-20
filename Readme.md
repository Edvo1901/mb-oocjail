# MB-OOCJAIL
This script allow you to jail a player if they breaking the server rule, but it is not too serious for a ban. The script allow the player to have time and look back what they done and hopefully they will make some changes.

# Credit
I personally inspect a lot from the [qb-prison](https://github.com/qbcore-framework/qb-prison) (QBCore Framework). So you might find some similarities in both script.

# Features
- Jail/unjail a player.
- Still process the jail even if they player quit and log back in.
- Keep track position of player to avoid escape.
- Display a notify to discord information about the jailled player and the admin that did so.

# Preview
[PREVIEW](https://www.youtube.com/watch?v=mYMGHzLiSxQ)

# Support
Join our discord today for latest update and faster support:

[![Discord](https://dcbadge.vercel.app/api/server/MkXfmb2M2V)](https://discord.gg/MkXfmb2M2V)

# Setup
1. Download the file from [Github](https://github.com/Edvo1901/mb-oocjail)
2. Unzipped the file
3. Drag and drop [mb-oocjail] to your server folder
4. Go to your `qb-core/server/player.lua` line 102 and add this
```PlayerData.metadata['oocjail'] = PlayerData.metadata['oocjail'] or 0```
5. Go to your `server.cfg` and ensure `mb-oocjail`

# Bugs/Optimise report
If you find any bugs or have any suggestion, feel free to open an "Issues" on Github or simply join my Discord for support

# Other script
Check out my other script at: https://guess-project.tebex.io/