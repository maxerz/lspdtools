script_name("Samp-Rp Reconnect")
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

sectimer = false
manrec = false
times = 0

function registerCommands()
    if sampIsChatCommandDefined('rrec') then sampUnregisterChatCommand('rrec') end
    sampRegisterChatCommand('rrec', rec)
end
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
	print('Samp-Rp Reconnect Loaded. Commands: /rrec')
    registerCommands()
    while true do
    	wait(0)
    	if sectimer then
    		sampAddChatMessage('Reconnecting...', 0x00FF00)
    		sampDisconnectWithReason(quit)
			wait(15500)
			sampSetGamestate(1)
			sectimer = false
		elseif manrec then
			sampAddChatMessage('Reconnecting...', 0x00FF00)
			sampDisconnectWithReason(quit)
			wait(times*1000+500)
			sampSetGamestate(1)
			manrec = false
		end
	end
end
function rec(pam)
    if #pam ~= 0 then
        times = tonumber(pam)
        if times == nil then
        	sampAddChatMessage('Введите /rrec [секунды]', 0xFFFFFF)
        	return
        end
        manrec = true
    else
        sampAddChatMessage('Введите /rrec [секунды]', 0xFFFFFF)
    end
end

if lsampev then
    function sp.onServerMessage(color, text)
    	if text:find('Повторный вход на сервер возможен не раньше чем через 15 секунд') then
    		sectimer = true
    	end
    	if text:find('Server closed the connection') then
    		sectimer = true
    	end
    end
end