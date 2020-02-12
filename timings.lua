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
	ftext('�������� [LSPD] ���������!')
    ftext('�������: reset_timings, notify_timings, toggle_rbm')
	print('�������� [LSPD] ���������!')
    registerCommands()
end
function toggle_rbm()
    rbm = not rbm
    ftext('MDC-����� /rb m id ' .. (rbm and '�������' or '��������'))
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
    ftext('�������� ��������!')
end
function notify_timings()
    notify = not notify
    ftext('���������� � /r ' .. (notify and '��������' or '���������'))
end
if lsampev then
    function sp.onServerMessage(color, text)

        if text:match(' ������� �������%: .+') and beginlogmdc == true then
            mdcdata.sulvl = text:match(' ������� �������%: (.+)')
        end
        if text:match(' �������%: .+') and beginlogmdc == true then
            mdcdata.reason = text:match(' �������%: (.+)')
        end
        if text:match(' �����������%: .+') and beginlogmdc == true then
            mdcdata.orga = text:match(' �����������%: (.+)')
        end
        if (text:find('�� �� � ��������� ������ / ����� �������') or text:find('����� �������')) and beginlogmdc == true then
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
                    sampSendChat('/rb ����� �� � ���� / � �� � ������ / �������.')
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

        if text:find('Wanted') and text:find('���������') then
            if text:find('���������� Ammo LS') and robbedammo == false then
                robbedammo = true
                robbedammot = lua_thread.create(function()
                    ftext('���� ��������� Ammo LS, ��������� ���������� ����� 30 �����')
                    wait(1380000)
                    ftext('��������: ����������� ���������� Ammo LS ����� 5 �����')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 5 ����� �������� ���������� Ammo LS')
                    end
                    wait(120000)
                    ftext('��������: ����������� ���������� Ammo LS ����� 3 ������')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 3 ������ �������� ���������� Ammo LS')
                    end
                    wait(120000)
                    robbedammo = false
                    ftext('��������: ����������� ���������� Ammo LS ����� 1 ������')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 1 ������ �������� ���������� Ammo LS')
                    end
                    robbedammot = false
                end)
                robbedammot.work_in_pause = true
            end
            if text:find('���������� Victim LS') and robbedvict == false then
                robbedvict = true
                robbedvictt = lua_thread.create(function()
                    ftext('���� ��������� Victim LS, ��������� ���������� ����� 30 �����')
                    wait(1380000)
                    ftext('��������: ����������� ���������� Victim LS ����� 5 �����')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 5 ����� �������� ���������� Victim LS')
                    end
                    wait(120000)
                    ftext('��������: ����������� ���������� Victim LS ����� 3 ������')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 3 ������ �������� ���������� Victim LS')
                    end
                    wait(120000)
                    ftext('��������: ����������� ���������� Victim LS ����� 1 ������')
                    robbedvict = false
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 1 ������ �������� ���������� Victim LS')
                    end
                    robbedvictt = false
                end)
                robbedvictt.work_in_pause = true
            end
            if text:find('���������� ��������') and text:find('ASGH') and robbedhosp == false then
                robbedhosp = true
                robbedhospt = lua_thread.create(function()
                    ftext('���� ��������� �������� ASGH, ��������� ���������� ����� 30 �����')
                    wait(1380000)
                    ftext('��������: ����������� ���������� �������� ASGH ����� 5 �����')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 5 ����� �������� ���������� �������� ASGH')
                    end
                    wait(120000)
                    ftext('��������: ����������� ���������� �������� ASGH ����� 3 ������')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 3 ������ �������� ���������� �������� ASGH')
                    end
                    wait(120000)
                    robbedhosp = false
                    ftext('��������: ����������� ���������� �������� ASGH ����� 1 ������')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 1 ������ �������� ���������� �������� ASGH')
                    end
                    robbedhospt = false
                end)
                robbedhospt.work_in_pause = true
            end
            if text:find('���������� Idlewood') and robbedi247 == false then
                robbedi247 = true
                robbedi247t = lua_thread.create(function()
                    ftext('��� �������� Idlewood 24-7, ��������� ���������� ����� 30 �����')
                    wait(1380000)
                    ftext('��������: ����������� ���������� Idlewood 24-7 ����� 5 �����')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 5 ����� �������� ���������� Idlewood 24-7')
                    end
                    wait(120000)
                    ftext('��������: ����������� ���������� Idlewood 24-7 ����� 3 ������')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 3 ������ �������� ���������� Idlewood 24-7')
                    end
                    wait(120000)
                    robbedi247 = false
                    ftext('��������: ����������� ���������� Idlewood 24-7 ����� 1 ������')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 1 ������ �������� ���������� Idlewood 24-7')
                    end
                    robbedi247t = false
                end)
                robbedi247t.work_in_pause = true
            end
            if text:find('���������� Flint') and robbedf247 == false then
                robbedf247 = true
                robbedf247t = lua_thread.create(function()
                    ftext('��� �������� Flint 24-7, ��������� ���������� ����� 30 �����')
                    wait(1380000)
                    ftext('��������: ����������� ���������� Flint 24-7 ����� 5 �����')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 5 ����� �������� ���������� Flint 24-7')
                    end
                    wait(120000)
                    ftext('��������: ����������� ���������� Flint 24-7 ����� 3 ������')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 3 ������ �������� ���������� Flint 24-7')
                    end
                    wait(120000)
                    robbedf247 = false
                    ftext('��������: ����������� ���������� Flint 24-7 ����� 1 ������')
                    if notify then
                        sampSendChat('/rb [Warning]: ����� 1 ������ �������� ���������� Flint 24-7')
                    end
                    robbedf247t = false
                end)
                robbedf247t.work_in_pause = true
            end
        end
    end
end