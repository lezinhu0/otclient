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
        nextStepScheduleTimer = 1500
    end

    if step == 4 then
        local rightItemSlot = resultWindow:recursiveGetChildById('rightItemSlot')
        rightItemSlot:setReplaceShader(false)
        if m_success then
            resultWindow:recursiveGetChildById('rightItemSlot')
            rightItemSlot:setColor('#ffffff')
            rightItemSlot.itemBadge:setVisible(true)
        else
            rightItemSlot:setColor('#ff0000')
        end
        nextStepScheduleTimer = 2000
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
    print('\n\n\nhandling forge result')

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

    local leftItemSlot = resultWindow:recursiveGetChildById('leftItemSlot')
    leftItemSlot:setItemId(m_leftItemId)
    if m_leftItemTier > 0 then
        leftItemSlot.itemBadge:setImageClip({
            x = (m_leftItemTier - 1) * 9,
            y = 0,
            width = 10,
            height = 9
        })
        leftItemSlot.itemBadge:setVisible(true)
    end
    local rightItemSlot = resultWindow:recursiveGetChildById('rightItemSlot')
    if m_success then
        rightItemSlot.itemBadge:setImageClip({
            x = (m_rightItemTier - 1) * 9,
            y = 0,
            width = 10,
            height = 9
        })
    end
    rightItemSlot:setItemId(m_rightItemId)

    nextStep()
end