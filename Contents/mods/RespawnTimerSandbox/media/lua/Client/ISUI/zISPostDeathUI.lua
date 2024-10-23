local originalCreateChildren = ISPostDeathUI.createChildren
function ISPostDeathUI:createChildren()
    originalCreateChildren(self)
    self.buttonRespawn:setEnable(false)
    self.buttonRespawn:setTitle(getText("IGUI_PostDeath_RespawnIn").."...")

    -- Initialize timer variables
    self.timerStart = getTimestamp()
    
    local option = getSandboxOptions():getOptionByName("RespawnTimer.SetTimer")
    if option and option:getValue() then
        self.timerDuration = tonumber(option:getValue()) or 5
    else
        self.timerDuration = 5 -- Default value
    end
end


local originalPrerender = ISPostDeathUI.prerender
function ISPostDeathUI:prerender()
	originalPrerender(self)
    
    -- Ensure the respawn button is visible
    self.buttonRespawn:setVisible(true)

    -- Check if the timer has expired
    local timeElapsed = getTimestamp() - (self.timerStart or 0)
    local timeRemaining = math.max(0, (self.timerDuration or 0) - timeElapsed)
    local allowRespawnTimerExpired = timeElapsed >= (self.timerDuration or 0)
    
    -- Update the timer label
    local minutes = math.floor(timeRemaining / 60)
    local seconds = timeRemaining % 60
    local timerText = string.format(getText("IGUI_PostDeath_RespawnIn") .. ": %02d:%02d", minutes, seconds)
    self.buttonRespawn:setTitle(timerText)
    
    -- Set the visibility of the respawn button
    if allowRespawnTimerExpired or isAdmin() then
        self.buttonRespawn:setEnable(true)
        self.buttonRespawn:setTitle(getText("IGUI_PostDeath_Respawn"))
    end
end