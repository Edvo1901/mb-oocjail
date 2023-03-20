local Translations = {
    success = {
        you_have_been_jailed = "You have been OOC Jail by admin",
        you_lost_job = "You've lost your current job",
        clear_inv = "Your inventory has been cleared out",
        you_are_free = "You are free from OOC Jail",
    },
    error = {
        fill_argument = "Please fill all the argument",
        no_permission = "No permission to use this command",
        invalid_argument = "Invalid input",
    },
    notify = {
        title = "OOC Jail",
        jailed_player = '• System • <font color="#C1C1C1">You have been OOC Jail for <font color="#53A263">%{time} <font color="#C1C1C1"> minutes (See discord for more information).',
        released_player = '• System • <font color="#C1C1C1">You have been <font color="#53A263">release<font color="#C1C1C1"> from OOC jail (dont break the rule again).',
        check_time = "You still have %{time} minutes left from OOC Jail, keep regreting!",
    },
    argument = {
        id = "ID",
        id_help = "Player's ID",
        time = "Time",
        time_help = "Jail time (minutes)",
        reason = "Reason",
        reason_help = "Reason for the jail"
    },
    log = {
        jail_title = "OOC Jail",
        jail_description = "`Total jail time: %{time} mins`\n`Reason: %{reason}`\n\n Join our discord for more information",
        jail_additional = "**Prisoner** (%{discord})\n`Player's ID: %{ID}`\n`In-game name: %{fName} %{lName}`\n`CID: %{CID}`\n\n**Admin** (%{adDiscord})\n`In-game name: %{adFName} %{adLName}`\n%{message}",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})