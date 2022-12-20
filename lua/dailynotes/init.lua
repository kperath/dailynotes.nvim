-- module
local M = {}
M.command = vim.api.nvim_create_user_command
-- path to the daily notes (default is current directory)
M.path = ''
-- enables options and commands from v0.1.0
M.legacy = false
-- notifications from dailynotes by default enabled
M.notifications = true
-- ignores dailynotes that don't exist (instead of creating new file)
M.ignoreempty = false
-- won't create dailynotes beyond start point
-- required by "ignoreempty" to provide basecase 
M.startdate = false

-- if daily note file exists
local function fileExists(filename)
   local f = io.open(filename, 'r')
   if f ~= nil then
       io.close(f)
       return true
   else
       return false
   end
end

local function notify(msg)
    if M.notifications then
        vim.notify('[dailynotes] ' .. msg)
    end
end

local function logErr(msg)
    vim.notify('[error] ' .. msg)
end

local function isInvalidDateFormat(name)
    -- hyphen is a special character in lua patterns so needs to be escape with %
    local datePattern = '%d%d%d%d%-%d%d%-%d%d'
    -- 8 numbers and 2 dashes make up the date format
    local datePatternLen = 10
    return string.len(name) ~= datePatternLen or
           string.find(name, datePattern) == nil
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
    if opts.startdate then
        M.startdate = opts.startdate
    end
    if opts.ignoreempty then
        if not opts.startdate then
            logErr('startdate must be set for this feature to work')
            return
        end
        if isInvalidDateFormat(opts.startdate) then
            logErr('start date format invalid, should be: YYYY-MM-DD')
            return
        end
        M.ignoreempty = opts.ignoreempty
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
        logErr('Invalid daily note: not a markdown file')
        return
    end
    -- get just filename without extension (YYYY-MM-DD.md -> YYYY-MM-DD)
    local fileName = vim.fn.expand("%:t:r")
    if isInvalidDateFormat(fileName) then
        logErr('Invalid daily note: date format invalid')
        return
    end
    -- return if going forward and current daily note is todays note (latest note)
    if direction > 0 and fileName == os.date("%Y-%m-%d") then
        vim.notify('Reached latest daily note')
        return
    end
    -- return if going backward and current daily note is oldest note (if ignoreempty is set)
    if direction < 0 and fileName == M.startdate then
        vim.notify('Reached start of daily notes')
    end

    -- get next daily note from this day (before or after depends on direction)
    local year = string.match(fileName, '%d%d%d%d')
    local month = string.match(fileName, '%d%d', 5)
    local day = string.match(fileName, '%d%d', 8)
    local nextDayAsTime = os.time({day = day+direction, month = month, year = year})
    local nextDay = os.date('%Y-%m-%d', nextDayAsTime)

    local nextDayNote = nextDay .. '.md'
    if M.ignoreempty and M.startdate and not fileExists(nextDayNote) then
        if direction > 1 then
            M.getNextDaily(direction+1)
        else
            M.getNextDaily(direction-1)
        end
        return
    end
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
