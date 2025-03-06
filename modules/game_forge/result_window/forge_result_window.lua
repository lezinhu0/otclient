local resultWindow = nil

local step = 0

local function nextStep()
    local nextStepScheduleTimer = 1000

    if step == 1 then
        resultWindow:recursiveGetChildById('firstStepIcon'):setBackgroundColor('white')
    end

    if step == 2 then
        resultWindow:recursiveGetChildById('secondStepIcon'):setBackgroundColor('white')
    end

    if step == 3 then
        resultWindow:recursiveGetChildById('thirdStepIcon'):setBackgroundColor('white')
    end

    if step == 4 then
        resultWindow:recursiveGetChildById('rightPanel'):setColor('white')
        nextStepScheduleTimer = 3000
    end

    
    if step == 5 then
        print('trying to handle animation finish')
        resultWindow:destroy()
        resultWindow = nil
        modules.game_forge.show()
        return
    end
    
    step = step + 1
    scheduleEvent(nextStep, nextStepScheduleTimer)
end

function showForgeResult(result)
    step = 0
    if not resultWindow then
        resultWindow = g_ui.displayUI('forge_result_window')
    end
    nextStep()
end