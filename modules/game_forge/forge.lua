local forgeWindow = nil
local improveSucces = false
local items = {}
local useCore = false
local selectedItem = nil

function init()
    forgeWindow = g_ui.displayUI('forge')
    forgeWindow:hide()

    connect(g_game, {
        onOpenForge = show,
        forgeLoadItems = loadItems,
        onResourcesBalanceChange = updatePlayerResources,
        onWalk = handleWalk,
        onGameEnd = hide
    })
end

function terminate()
    disconnect(g_game, {
        onOpenForge = show,
        forgeLoadItems = loadItems,
        onResourcesBalanceChange = updatePlayerResources,
        onWalk = handleWalk,
        onGameEnd = hide
    })
    forgeWindow:destroy()
    forgeWindow = nil
end

function handleWalk()
    hide()
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
    print('\n\n\n\nhandling update player resources')
    drawForge()
end

function drawForge()
    local useCoreButton = forgeWindow:recursiveGetChildById('useCoreButton'):setOn(useCore)
    local selectedItemSlot = forgeWindow:recursiveGetChildById('selectedItem'):setItem(selectedItem)
    forgeWindow:recursiveGetChildById('totalCoresLabel'):setText(g_game.getLocalPlayer():getResourceBalance(RESOURCE_FORGE_CORES))

    local items = forgeWindow:recursiveGetChildrenByStyleName("ForgeItem")
    for _, item in ipairs(items) do
        item:setOn(selectedItem and selectedItem:getId() == item:getId())
    end

    local selectedItemBadge = forgeWindow:recursiveGetChildById('selectedItemBadge')
    if selectedItem then
        selectedItemBadge:setVisible(true)
        selectedItemBadge:setImageClip({
            x = (selectedItem:getTier()) * 9,
            y = 0,
            width = 10,
            height = 9
        })
    else
        selectedItemBadge:setVisible(false)
    end

    local successRateValueLabel = forgeWindow:recursiveGetChildById('successRateValueLabel')
    successRateValueLabel:setText(useCore and '100%' or '50%')
    successRateValueLabel:setColor(useCore and 'green' or 'red')

    local fusionButton = forgeWindow:recursiveGetChildById('fusionButton')
    if selectedItem and g_game.getLocalPlayer() and g_game.getLocalPlayer():getTotalMoney()  then
        fusionButton:enable()
    else
        fusionButton:disable()
    end
end

function show()
    useCore = false
    selectedItem = nil
    print(string.format('Total cores for player: %d', g_game.getLocalPlayer():getResourceBalance(RESOURCE_FORGE_CORES)))

    forgeWindow:show()
    forgeWindow:focus()
    forgeWindow:grabMouse()
    forgeWindow:grabKeyboard()
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
    self:setOn(not self:isOn())
end

function handleItemClick(self)
    selectedItem = self:getItem()
    local itemSprites = forgeWindow:recursiveGetChildrenByStyleName('ForgeItemSprite')
    for _, itemSprite in ipairs(itemSprites) do
        itemSprite:setOn(false)
    end
    self:setOn(true)
    drawForge()
end

function handleFusionClick()
    g_game.forgeFusionItem(selectedItem, useCore)
    hide()
end

function handleCoreClick()
    useCore = not useCore
    drawForge()
end

function getTotalCores()
    return g_game.getLocalPlayer():getResourceBalance(RESOURCE_FORGE_CORES)
end