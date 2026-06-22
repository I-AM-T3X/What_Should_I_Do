-- Core/SlotMachine.lua
-- Slot machine animation
-- Author: I_AM_T3X | v1.0.0

local slotTimer=nil ; local slotTick=0 ; local slotTotal=0
local slotWinner=nil ; local slotLabel=nil ; local slotCallback=nil

function StopSlot()
    if slotTimer then slotTimer:Cancel() slotTimer = nil end
end

function StartSlot(label, pool, onDone)
    StopSlot()
    if not pool or #pool == 0 then
        label:SetText("No options!") ; if onDone then onDone(nil) end ; return
    end
    slotTick=0 ; slotTotal=26+math.random(0,10)
    slotWinner=pool[math.random(#pool)] ; slotLabel=label ; slotCallback=onDone
    local function Tick()
        slotTick = slotTick + 1
        if slotTick >= slotTotal then
            slotLabel:SetText(slotWinner) ; StopSlot()
            if slotCallback then slotCallback(slotWinner) end ; return
        end
        slotLabel:SetText(pool[math.random(#pool)])
        slotTimer = C_Timer.NewTimer(0.06 + 0.18*((slotTick/slotTotal)^2), Tick)
    end
    Tick()
end
