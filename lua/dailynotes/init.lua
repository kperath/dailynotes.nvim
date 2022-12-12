-- module
local M = {}
M.command = vim.api.nvim_create_user_command
-- path to the daily notes (default is current directory)
M.path = ''
-- enables options and commands from v0.1.0
M.legacy = false
-- notifications from dailynotes by default enabled
M.notifications = true

local function notify(msg)
    if M.notifications then
        vim.notify('[dailynotes] ' .. msg)
    end
end

function M.setup(opts)
    if opts.path then
        M.path = opts.path
    end
    if opts.legacy then
        M.legacy = opts.legacy
    end
    if opts.notifications == false then
        M.notifications = opts.notifications
    end

    if M.legacy then
        M.setLegacyCommands(opts)
    end
end

-- gets todays daily note
function M.openTodaysDaily()
    local todayNote = os.date('%Y-%m-%d') .. ".md"
    vim.cmd(':e ' .. M.path .. todayNote)
end

-- when on a daily note file, returns the next daily note
-- direction is the number of days and the sign of direction if positive goes forward in time and if negative backwards in time
function M.getNextDaily(direction)
    local fileType = vim.bo.filetype
    if fileType ~= 'vimwiki' and fileType ~= 'markdown' then
        vim.notify('Invalid daily note: not a markdown file')
        return
    end
    local fileName = vim.fn.expand("%:t:r")
    -- hyphen is a special character in lua patterns so needs to be escape with %
    local datePattern = '%d%d%d%d%-%d%d%-%d%d'
    -- 8 numbers and 2 dashes make up the date format
    local datePatternLen = 10
    if string.len(fileName) ~= datePatternLen or
       string.find(fileName, datePattern) == nil then
        vim.notify('Invalid daily note: date format invalid')
        return
    end
    -- return if going forward and current daily note is todays note (latest note)
    if direction > 0 and fileName == os.date("%Y-%m-%d") then
        vim.notify('Reached latest daily note')
        return
    end

    -- get next daily note after this day
    local year = string.match(fileName, '%d%d%d%d')
    local month = string.match(fileName, '%d%d', 5)
    local day = string.match(fileName, '%d%d', 8)
    local nextDayAsTime = os.time({day = day+direction, month = month, year = year})
    local nextDay = os.date('%Y-%m-%d', nextDayAsTime)

    local nextDayNote = nextDay .. '.md'
    vim.cmd(':e ' .. M.path .. nextDayNote)
end


-- enables support for "legacy" options initially introduced in v0.1.0
function M.setLegacyCommands(opts)
    -- path has precendence over dailyNotesPath if already set
    if not opts.path and opts.dailyNotesPath then
        M.path = opts.dailyNotesPath
    end
    M.command(
        'NextDaily',
        function ()
            M.getNextDaily(1)
        end,
        {desc='get next daily note'}
    )
    M.command(
        'PrevDaily',
        function ()
            M.getNextDaily(-1)
        end,
        {desc='get previous daily note'}
    )
    notify('legacy commands enabled: :NextDaily, :PrevDaily')
end

return M
