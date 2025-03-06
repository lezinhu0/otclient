local resultWindow
local m_actionType
local m_convergence
local m_success
local m_leftItemId
local m_leftItemTier
local m_rightItemId
local m_rightItemTier
local m_bonus
local m_coreCount
local m_keptItemId
local m_keptItemTier

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
        resultWindow:recursiveGetChildById('rightItemSlot'):setColor('white')
        nextStepScheduleTimer = 3000
    end

    
    if step == 5 then
        print('trying to handle animation finish')
        resultWindow:destroy()
        resultWindow = nil
        modules.game_forge.showingResult = false
        modules.game_forge.show()
        return
    end
    
    step = step + 1
    scheduleEvent(nextStep, nextStepScheduleTimer)
end

function showForgeResult(actionType, convergence, success, leftItemId, leftItemTier, rightItemId, rightItemTier, bonus, coreCount, keptItemId, keptItemTier)
    m_actionType = actionType
    m_convergence = convergence
    m_success = success
    m_leftItemId = leftItemId
    m_leftItemTier = leftItemTier
    m_rightItemId = rightItemId
    m_rightItemTier = rightItemTier
    m_bonus = bonus
    m_coreCount = coreCount
    m_keptItemId = keptItemId
    m_keptItemTier = keptItemTier

    step = 0
    if not resultWindow then
        resultWindow = g_ui.displayUI('forge_result_window')
    end

    resultWindow:recursiveGetChildById('leftItemSlot'):setItemId(m_leftItemId)
    resultWindow:recursiveGetChildById('rightItemSlot'):setItemId(m_rightItemId)

    nextStep()
end