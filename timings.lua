script_name("LSPD Tools [Timings]")
script_authors("Max Erzgate")
script_version(1.0)

require 'lib.moonloader'
require 'lib.sampfuncs'

local lsg, sf               = pcall(require, 'sampfuncs')
local lsampev, sp           = pcall(require, 'lib.samp.events')
local encoding              = require 'encoding'
local dlstatus              = require('moonloader').download_status
encoding.default            = 'CP1251'
u8 = encoding.UTF8
robbedammo = false
robbedvict = false
robbedhosp = false
robbedi247 = false
robbedf247 = false

robbedammot = false
robbedvictt = false
robbedhospt = false
robbedi247t = false
robbedf247t = false
notify = true

rbm = true
nodata = false
beginlogmdc = false
mdcdata =
{
    sulvl = '0',
    reason = '',
    orga = ''
}

function ftext(text)
    sampAddChatMessage((' Timings | {ffffff}%s'):format(text),0x9966CC)
end
function registerCommands()
    if sampIsChatCommandDefined('reset_timings') then sampUnregisterChatCommand('reset_timings') end
    if sampIsChatCommandDefined('notify_timings') then sampUnregisterChatCommand('notify_timings') end
    if sampIsChatCommandDefined('toggle_rbm') then sampUnregisterChatCommand('toggle_rbm') end
    sampRegisterChatCommand('reset_timings', reset_timings)
    sampRegisterChatCommand('notify_timings', notify_timings)
    sampRegisterChatCommand('toggle_rbm', toggle_rbm)
end
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
	ftext('Тайминги [LSPD] Загружены!')
    ftext('Команды: reset_timings, notify_timings, toggle_rbm')
	print('Тайминги [LSPD] Загружены!')
    registerCommands()
end
function toggle_rbm()
    rbm = not rbm
    ftext('MDC-чекер /rb m id ' .. (rbm and 'включен' or 'выключен'))
end
function reset_timings()
    robbedammo = false
    robbedvict = false
    robbedhosp = false
    robbedi247 = false
    robbedf247 = false
    if type(robbedammot) ~= 'boolean' then
        robbedammot:terminate()
        robbedammot = false
    end
    if type(robbedvictt) ~= 'boolean' then
        robbedvictt:terminate()
        robbedvictt = false
    end
    if type(robbedhospt) ~= 'boolean' then
        robbedhospt:terminate()
        robbedhospt = false
    end
    if type(robbedi247t) ~= 'boolean' then
        robbedi247t:terminate()
        robbedi247t = false
    end
    if type(robbedf247t) ~= 'boolean' then
        robbedf247t:terminate()
        robbedf247t = false
    end
    ftext('Тайминги сброшены!')
end
function notify_timings()
    notify = not notify
    ftext('Оповещения в /r ' .. (notify and 'включены' or 'выключены'))
end
if lsampev then
    function sp.onServerMessage(color, text)

        if text:match(' Уровень розыска%: .+') and beginlogmdc == true then
            mdcdata.sulvl = text:match(' Уровень розыска%: (.+)')
        end
        if text:match(' Причина%: .+') and beginlogmdc == true then
            mdcdata.reason = text:match(' Причина%: (.+)')
        end
        if text:match(' Организация%: .+') and beginlogmdc == true then
            mdcdata.orga = text:match(' Организация%: (.+)')
        end
        if (text:find('Вы не в служебной машине / своем участке') or text:find('Игрок оффлайн')) and beginlogmdc == true then
            nodata = true
            beginlogmdc = false
        end
        if text:match('.+  .+%:  %(%( m .+ %)%)') and beginlogmdc == false and rbm == true then
            faceid = text:match('.+  .+%:  %(%( m (.+) %)%)')
            beginlogmdc = true
            lua_thread.create(function()
                wait(1000)
                sampSendChat('/mdc '..faceid)
                wait(1000)
                if nodata == true then
                    sampSendChat('/rb Игрок не в сети / Я не в машине / участке.')
                    nodata = false
                    return
                end
                sampSendChat('/rb SU: '..mdcdata.sulvl..', R: '..mdcdata.reason..', O: '..mdcdata.orga)
                mdcdata.sulvl = '0'
                mdcdata.reason = ''
                mdcdata.orga = ''
                nodata = false
                beginlogmdc = false
            end
            )
        end

        if text:find('Wanted') and text:find('Свидетель') then
            if text:find('Ограбление Ammo LS') and robbedammo == false then
                robbedammo = true
                robbedammot = lua_thread.create(function()
                    ftext('Было ограблено Ammo LS, Следующее ограбление через 30 минут')
                    wait(1380000)
                    ftext('Внимание: Планируется ограбление Ammo LS через 5 минут')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 5 минут возможно ограбление Ammo LS')
                    end
                    wait(120000)
                    ftext('Внимание: Планируется ограбление Ammo LS через 3 минуты')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 3 минуты возможно ограбление Ammo LS')
                    end
                    wait(120000)
                    robbedammo = false
                    ftext('Внимание: Планируется ограбление Ammo LS через 1 минуту')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 1 минуту возможно ограбление Ammo LS')
                    end
                    robbedammot = false
                end)
                robbedammot.work_in_pause = true
            end
            if text:find('Ограбление Victim LS') and robbedvict == false then
                robbedvict = true
                robbedvictt = lua_thread.create(function()
                    ftext('Было ограблено Victim LS, Следующее ограбление через 30 минут')
                    wait(1380000)
                    ftext('Внимание: Планируется ограбление Victim LS через 5 минут')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 5 минут возможно ограбление Victim LS')
                    end
                    wait(120000)
                    ftext('Внимание: Планируется ограбление Victim LS через 3 минуты')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 3 минуты возможно ограбление Victim LS')
                    end
                    wait(120000)
                    ftext('Внимание: Планируется ограбление Victim LS через 1 минуту')
                    robbedvict = false
                    if notify then
                        sampSendChat('/rb [Warning]: Через 1 минуту возможно ограбление Victim LS')
                    end
                    robbedvictt = false
                end)
                robbedvictt.work_in_pause = true
            end
            if text:find('Ограбление больницы') and text:find('ASGH') and robbedhosp == false then
                robbedhosp = true
                robbedhospt = lua_thread.create(function()
                    ftext('Была ограблена больница ASGH, Следующее ограбление через 30 минут')
                    wait(1380000)
                    ftext('Внимание: Планируется ограбление больницы ASGH через 5 минут')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 5 минут возможно ограбление больницы ASGH')
                    end
                    wait(120000)
                    ftext('Внимание: Планируется ограбление больницы ASGH через 3 минуты')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 3 минуты возможно ограбление больницы ASGH')
                    end
                    wait(120000)
                    robbedhosp = false
                    ftext('Внимание: Планируется ограбление больницы ASGH через 1 минуту')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 1 минуту возможно ограбление больницы ASGH')
                    end
                    robbedhospt = false
                end)
                robbedhospt.work_in_pause = true
            end
            if text:find('Ограбление Idlewood') and robbedi247 == false then
                robbedi247 = true
                robbedi247t = lua_thread.create(function()
                    ftext('Был ограблен Idlewood 24-7, Следующее ограбление через 30 минут')
                    wait(1380000)
                    ftext('Внимание: Планируется ограбление Idlewood 24-7 через 5 минут')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 5 минут возможно ограбление Idlewood 24-7')
                    end
                    wait(120000)
                    ftext('Внимание: Планируется ограбление Idlewood 24-7 через 3 минуты')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 3 минуты возможно ограбление Idlewood 24-7')
                    end
                    wait(120000)
                    robbedi247 = false
                    ftext('Внимание: Планируется ограбление Idlewood 24-7 через 1 минуту')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 1 минуту возможно ограбление Idlewood 24-7')
                    end
                    robbedi247t = false
                end)
                robbedi247t.work_in_pause = true
            end
            if text:find('Ограбление Flint') and robbedf247 == false then
                robbedf247 = true
                robbedf247t = lua_thread.create(function()
                    ftext('Был ограблен Flint 24-7, Следующее ограбление через 30 минут')
                    wait(1380000)
                    ftext('Внимание: Планируется ограбление Flint 24-7 через 5 минут')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 5 минут возможно ограбление Flint 24-7')
                    end
                    wait(120000)
                    ftext('Внимание: Планируется ограбление Flint 24-7 через 3 минуты')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 3 минуты возможно ограбление Flint 24-7')
                    end
                    wait(120000)
                    robbedf247 = false
                    ftext('Внимание: Планируется ограбление Flint 24-7 через 1 минуту')
                    if notify then
                        sampSendChat('/rb [Warning]: Через 1 минуту возможно ограбление Flint 24-7')
                    end
                    robbedf247t = false
                end)
                robbedf247t.work_in_pause = true
            end
        end
    end
end