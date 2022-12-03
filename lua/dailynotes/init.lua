-- module
local M = {}
M.command = vim.api.nvim_create_user_command
M.dailyNotesPath = ''

-- gets todays daily note
function M.openTodaysDailyNote()
    local dailyNote = os.date('%Y-%m-%d') .. ".md"
    vim.cmd(':e ' .. M.dailyNotesPath .. dailyNote)
end

-- when on a daily note file, returns the next daily note
-- direction is the number of days and the sign of direction if positive goes forward in time and if negative backwards in time
function M.getNextDailyNote(direction)
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

    local nextDailyNote = nextDay .. '.md'
    vim.cmd(':e ' .. M.dailyNotesPath .. nextDailyNote)
end

function M.setup(opts)
    if opts.dailyNotesPath then
        M.dailyNotesPath = opts.dailyNotesPath
    end
end

return M
