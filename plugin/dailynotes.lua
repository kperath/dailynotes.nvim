-- set up user commands
DailyNotes = require('dailynotes')

DailyNotes.command('Daily',
    DailyNotes.openTodaysDailyNote,
    {desc='opens todays daily note'}
)

DailyNotes.command('NextDaily',
function ()
    DailyNotes.getNextDailyNote(1)
end,
{desc='get next daily note'})

DailyNotes.command('PrevDaily',
function ()
    DailyNotes.getNextDailyNote(-1)
end,
{desc='get previous daily note'})
