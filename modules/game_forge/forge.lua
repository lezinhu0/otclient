forgeWindow = nil

function init()
    forgeWindow = g_ui.displayUI('forge')
    forgeWindow:hide()

    connect(g_game, {
        onOpenForge = show,
        onGameEnd = destroyWindows
    })
end

function terminate()
    destroyWindows()
    disconnect(g_game, {
        onOpenForge = show,
        onGameEnd = destroyWindows
    })
    Keybind.delete("Windows", "Close forge window")
end

function hide()
    forgeWindow:hide()
end

function clearItems()
    local forgeItems = forgeWindow:recursiveGetChildrenByStyleName('ForgeItem')
    for _, forgeItem in ipairs(forgeItems) do
        forgeItem:destroy()    
    end
end

function show(forgeItems)
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


        function forgeItem.onClick(widget)
            
        end
    end
    forgeWindow:show()
end

function destroyWindows()
    if forgeWindow then
        forgeWindow:destroy()
        forgeWindow = nil
    end
end

function handleButtonClick(self)
    local buttons = forgeWindow:recursiveGetChildrenByStyleName("SectionButton")
    for _, button in ipairs(buttons) do
        button:setOn(false)
    end
    self:setOn(not self:isOn())
end

function handleItemClick(self)
    print(self:getItem():getId())
end