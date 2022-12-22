function _OnFrame()
    World = ReadByte(Now + 0x00)
    Room = ReadByte(Now + 0x01)
    Place = ReadShort(Now + 0x00)
    Door = ReadShort(Now + 0x02)
    Map = ReadShort(Now + 0x04)
    Btl = ReadShort(Now + 0x06)
    Evt = ReadShort(Now + 0x08)
    Cheats()
end

function _OnInit()
    if GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301 and ENGINE_TYPE == "ENGINE" then--PCSX2
        Platform = 'PS2'
        Now = 0x032BAE0 --Current Location
        Save = 0x032BB30 --Save File
        Obj0 = 0x1C94100 --00objentry.bin
        Sys3 = 0x1CCB300 --03system.bin
        Btl0 = 0x1CE5D80 --00battle.bin
        Slot1 = 0x1C6C750 --Unit Slot 1
    elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then--PC
        Platform = 'PC'
        Now = 0x0714DB8 - 0x56454E
        Save = 0x09A7070 - 0x56450E
        Obj0 = 0x2A22B90 - 0x56450E
        Sys3 = 0x2A59DB0 - 0x56450E
        Btl0 = 0x2A74840 - 0x56450E
        Slot1 = 0x2A20C58 - 0x56450E
    end
end

function Events(M,B,E) --Check for Map, Btl, and Evt
    return ((Map == M or not M) and (Btl == B or not B) and (Evt == E or not E))
end

function Cheats()
	local Subtractor
	if ReadByte(Save+0x2498) < 3 then --Non-Critical
		Subtractor = 15
	else --Critical
		Subtractor = 12
	end
	if ReadByte(Slot1+0x0) > ReadByte(Slot1+0x4) then -- Current HP Cannot go above Max HP
		WriteByte(Slot1+0x0, ReadByte(Slot1+0x4))
	end
	if ReadShort(Now+0) == 0x2002 and ReadShort(Now+8) == 0x01 then -- Sets your HP in the first room of rando
		WriteByte(Slot1+0x4, 210)
		WriteByte(Slot1+0x0, 210)
	elseif ReadByte(Save+0x2498) < 3 and ReadByte(Slot1+0x4) % 10 ~= 0 and ReadByte(Slot1+0x4) > 15 then
		WriteByte(Slot1+0x4, ReadByte(Slot1+0x4) - Subtractor)
	elseif ReadByte(Slot1+0x4) % 5 ~= 0 and ReadByte(Slot1+0x4) > 12 then
		WriteByte(Slot1+0x4, ReadByte(Slot1+0x4) - Subtractor)
	elseif ReadByte(Slot1+0x4) == 12 then
		WriteByte(Slot1+0x4, 10)
	elseif ReadByte(Slot1+0x4) == 15 then
		WriteByte(Slot1+0x4, 10)
	end
end
