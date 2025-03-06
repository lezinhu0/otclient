local CONST_PAGE_RESULT = 'CONST_PAGE_RESULT'
local CONST_PAGE_FUSION = 'CONST_PAGE_FUSION'
local CONST_PAGE_CONVERSION = 'CONST_PAGE_CONVERSION'
local CONST_PAGE_HISTORY = 'CONST_PAGE_HISTORY'

local forgeWindow = nil
local improveSucces = false
local items = {}
local useCore = false
local selectedItem = nil
local tierUpgradeCosts = {}
local fusionPrice = 0
local playerCurrentCores = 0;
local currentPage = CONST_PAGE_FUSION

function init()
    forgeWindow = g_ui.displayUI('forge')
    forgeWindow:hide()

    connect(g_game, {
        onOpenForge = show,
        forgeLoadItems = loadItems,
        onResourcesBalanceChange = updatePlayerResources,
        onProcessForgingData = processForgingData,
        onProcessForgeResult = processForgeResult,
        onWalk = handleWalk,
        onGameEnd = hide
    })
end

function terminate()
    disconnect(g_game, {
        onOpenForge = show,
        forgeLoadItems = loadItems,
        onResourcesBalanceChange = updatePlayerResources,
        onProcessForgingData = processForgingData,
        onWalk = handleWalk,
        onGameEnd = hide
    })
    forgeWindow:destroy()
    forgeWindow = nil
end

function handleWalk()
    hide()
end

function processForgingData(newTierUpgradeCosts)
    tierUpgradeCosts = newTierUpgradeCosts
end

function clearItems()
    local forgeItems = forgeWindow:recursiveGetChildrenByStyleName('ForgeItem')
    for _, forgeItem in ipairs(forgeItems) do
        forgeItem:destroy()
        forgeItem = nil
    end
end

function hide()
    forgeWindow:ungrabMouse()
    forgeWindow:ungrabKeyboard()
    forgeWindow:hide()
end

function updatePlayerResources()
    playerCurrentCores = g_game.getLocalPlayer():getResourceBalance(RESOURCE_FORGE_CORES)
    drawForge()
end

local function drawFusionPage()
    local useCoreButton = forgeWindow:recursiveGetChildById('useCoreButton'):setOn(useCore)
    local selectedItemSlot = forgeWindow:recursiveGetChildById('selectedItem'):setItem(selectedItem)
    forgeWindow:recursiveGetChildById('totalCoresLabel'):setText(playerCurrentCores)

    local itemSprites = forgeWindow:recursiveGetChildrenByStyleName('ForgeItemSprite')
    for _, itemSprite in ipairs(itemSprites) do
        itemSprite:setOn(selectedItem and itemSprite:getItem() and itemSprite:getItem():getId() == selectedItem:getId() and selectedItem:getTier() == itemSprite:getItem():getTier())
    end

    local selectedItemBadge = forgeWindow:recursiveGetChildById('selectedItemBadge')
    selectedItemBadge:setVisible(false)
    if selectedItem then
        selectedItemBadge:setVisible(true)
        selectedItemBadge:setImageClip({
            x = (selectedItem:getTier()) * 9,
            y = 0,
            width = 10,
            height = 9
        })
    end

    local fusionGoldValueLabel = forgeWindow:recursiveGetChildById('fusionGoldValueLabel')
    fusionGoldValueLabel:setText(fusionPrice)

    local successRateValueLabel = forgeWindow:recursiveGetChildById('successRateValueLabel')
    successRateValueLabel:setText(useCore and '100%' or '50%')
    successRateValueLabel:setColor(useCore and 'green' or 'red')

    local fusionButton = forgeWindow:recursiveGetChildById('fusionButton')
    if selectedItem and g_game.getLocalPlayer():getTotalMoney() >= fusionPrice then
        fusionButton:enable()
    else
        fusionButton:disable()
    end

    forgeWindow:recursiveGetChildById('fusionPage'):setVisible(true)
end

function drawForge()
    local fusionPage = forgeWindow:recursiveGetChildById('fusionPage')
    fusionPage:setVisible(false)

    local sectionButtons = forgeWindow:recursiveGetChildrenByStyleName('SectionButton')
    for _, button in ipairs(sectionButtons) do
        button:setOn(currentPage == button:getId())
    end

    if currentPage == CONST_PAGE_FUSION then
        drawFusionPage()
    end

end

function show()
    if not forgeWindow:isVisible() then
        currentPage = CONST_PAGE_FUSION
        useCore = false
        selectedItem = nil
    
        forgeWindow:show()
        forgeWindow:focus()
        forgeWindow:grabMouse()
        forgeWindow:grabKeyboard()
    end
    drawForge()
end

function loadItems(forgeItems)
    clearItems()
    local listWidget = forgeWindow:recursiveGetChildById("List")
    for _, item in ipairs(forgeItems) do
        local forgeItem = g_ui.createWidget("ForgeItem", listWidget)
        forgeItem:setId(item:getId())
        forgeItem.Sprite:setItem(item)

        if item:getTier() > 0 then
            forgeItem.TierBadge:setImageSource("/images/inventory/tiers-strip")
            forgeItem.TierBadge:setImageClip({
                x = (item:getTier() - 1) * 9,
                y = 0,
                width = 10,
                height = 9
            })
        end
    end
end

function destroyWindows()
    if forgeWindow then
        forgeWindow:destroy()
        forgeWindow = nil
    end
end

function handleButtonClick(self)
    currentPage = self:getId()
    drawForge()
end

function handleItemClick(self)
    selectedItem = self:getItem()

    local itemClassification = selectedItem:getClassification()
    local itemTier = selectedItem:getTier()

    fusionPrice = tierUpgradeCosts[itemClassification][itemTier]
    drawForge()
end

function handleFusionClick()
    g_game.forgeFusionItem(selectedItem, useCore)
    hide()
end

function handleCoreClick()
    if playerCurrentCores <= 0 then return end
    useCore = not useCore
    drawForge()
end

function getTotalCores()
    return g_game.getLocalPlayer():getResourceBalance(RESOURCE_FORGE_CORES)
end

function processForgeResult(result)
    print("handling forge result xd")
end