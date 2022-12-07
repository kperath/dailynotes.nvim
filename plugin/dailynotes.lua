-- set up user commands
local dailynotes = require('dailynotes')

dailynotes.command('Daily',
    dailynotes.openTodaysNote,
    {desc='opens todays daily note'}
)

dailynotes.command('NextDaily',
function ()
    dailynotes.getNextNote(1)
end,
{desc='get next daily note'})

dailynotes.command('PrevDaily',
function ()
    dailynotes.getNextNote(-1)
end,
{desc='get previous daily note'})
