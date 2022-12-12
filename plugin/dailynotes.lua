-- set up user commands
local dailynotes = require('dailynotes')

dailynotes.command(
    'Daily',
    dailynotes.openTodaysDaily,
    {desc='opens todays daily note'}
)

dailynotes.command(
    'DailyNext',
    function()
        dailynotes.getNextDaily(1)
    end,
    {desc='get next daily note'}
)

dailynotes.command(
    'DailyPrev',
    function()
        dailynotes.getNextDaily(-1)
    end,
    {desc='get previous daily note'}
)
