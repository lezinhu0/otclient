local resultWindow = nil

function showForgeResult(result)
    if not resultWindow then
        resultWindow = g_ui.displayUI('forge_result_window')
    end

    scheduleEvent(
        function()
            resultWindow:destroy()
            resultWindow = nil
            modules.game_forge.show()
        end,
        3000
    )
end