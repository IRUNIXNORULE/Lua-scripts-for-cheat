---- Auto Fishing (FreeOpenSource) ----

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local playerstats = ReplicatedStorage:FindFirstChild("playerstats")
local myStats = playerstats and playerstats:FindFirstChild(LocalPlayer.Name)

local AutoFishing = {}
AutoFishing.LastTicked = tick()
AutoFishing.BobberTicked = tick()
AutoFishing.ShakeTicked = tick()
AutoFishing.DebugTime = 2.5

function AutoFishing.GetCurrentRod()
    if not myStats then return nil end
    local Rod = myStats:FindFirstChild("Stats"):FindFirstChild("rod")
    return Rod and Rod.Value or nil
end

function AutoFishing.GetReelFinished()
    return ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("reelfinished")
end

function AutoFishing.Key(keys)
    VirtualInputManager:SendKeyEvent(true, keys, false, LocalPlayer.PlayerGui)
    VirtualInputManager:SendKeyEvent(false, keys, false, LocalPlayer.PlayerGui)
end

function AutoFishing.UINavigation(button)
    if not button then return end
    GuiService.SelectedObject = button
    AutoFishing.Key(Enum.KeyCode.Return)
end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local playerstats = ReplicatedStorage:FindFirstChild("playerstats")
local myStats = playerstats and playerstats:FindFirstChild(LocalPlayer.Name)

local AutoFishing = {}
AutoFishing.LastTicked = tick()
AutoFishing.BobberTicked = tick()
AutoFishing.ShakeTicked = tick()
AutoFishing.DebugTime = 2.5

function AutoFishing.GetCurrentRod()
    if not myStats then return nil end
    local Rod = myStats:FindFirstChild("Stats"):FindFirstChild("rod")
    return Rod and Rod.Value or nil
end

function AutoFishing.GetReelFinished()
    return ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("reelfinished")
end

function AutoFishing.Key(keys)
    VirtualInputManager:SendKeyEvent(true, keys, false, LocalPlayer.PlayerGui)
    VirtualInputManager:SendKeyEvent(false, keys, false, LocalPlayer.PlayerGui)
end

function AutoFishing.UINavigation(button)
    if not button then return end
    GuiService.SelectedObject = button
    AutoFishing.Key(Enum.KeyCode.Return)
end

local function FreeAutoCast()
    local rod = nil
    for _, item in pairs(LocalPlayer.Character:GetChildren()) do
        if item:IsA("Tool") and item.Name:match("Rod") and item:FindFirstChild("events") and item.events:FindFirstChild("cast") then
            rod = item
            break
        end
    end

    if rod then
        rod.events.cast:FireServer(100, 1)
    end
end

local function FreeAutoReel()
    local AfterShakedone = ReplicatedStorage:FindFirstChild("events")
    if AfterShakedone and AfterShakedone:FindFirstChild("reelfinished") then
        AfterShakedone.reelfinished:FireServer(100, true)
    end
end

-- Alt loop --
while task.wait(0.05) do
    local Rods = AutoFishing.GetCurrentRod()
    local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")

    if Rods and typeof(Rods) == "string" then
        local CharacterRod = LocalPlayer.Character:FindFirstChild(Rods)

        if CharacterRod then
            local Events = CharacterRod:FindFirstChild("events")

            -- Auto Shake
            if LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                local safezone = LocalPlayer.PlayerGui.shakeui:FindFirstChild("safezone")
                if safezone then
                    local button = safezone:FindFirstChild("button")
                    if button then
                        AutoFishing.ShakeTicked = tick()
                        AutoFishing.BobberTicked = tick()
                        AutoFishing.UINavigation(button)
                        button.Name = button.Name .. "_"
                    elseif (tick() - AutoFishing.ShakeTicked) > AutoFishing.DebugTime then
                        Humanoid:UnequipTools()
                    end
                end
            elseif LocalPlayer.PlayerGui:FindFirstChild("reel") then
                local Reel = AutoFishing.GetReelFinished()
                if Reel then Reel:FireServer(100, true) end
            elseif not CharacterRod:FindFirstChild("bobber") and (tick() - AutoFishing.ShakeTicked) > 1 then
                if (tick() - AutoFishing.LastTicked) > 0.5 then
                    Events.reset:FireServer()
                    Events.cast:FireServer(100, 1)
                    AutoFishing.LastTicked = tick()
                    AutoFishing.BobberTicked = tick()
                    AutoFishing.ShakeTicked = tick()
                end
            elseif CharacterRod:FindFirstChild("bobber") and not LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                if (tick() - AutoFishing.BobberTicked) > AutoFishing.DebugTime then
                    Humanoid:UnequipTools()
                end
            end
        else
            if LocalPlayer.Backpack:FindFirstChild(Rods) then
                Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(Rods))
            end
        end
    end

    ---- Loop ----
    FreeAutoCast()
    task.wait(0.7)
    FreeAutoReel()
    FreeAutoReel()
end
local function KansxyAutoCast()
    local rod = nil
    for _, item in pairs(LocalPlayer.Character:GetChildren()) do
        if item:IsA("Tool") and item.Name:match("Rod") and item:FindFirstChild("events") and item.events:FindFirstChild("cast") then
            rod = item
            break
        end
    end

    if rod then
        rod.events.cast:FireServer(100, 1)
    end
end

local function KansxyAutoReel()
    local AfterShakedone = ReplicatedStorage:FindFirstChild("events")
    if AfterShakedone and AfterShakedone:FindFirstChild("reelfinished") then
        AfterShakedone.reelfinished:FireServer(100, true)
    end
end

---- Alt loop ----
while task.wait(0.05) do
    local Rods = AutoFishing.GetCurrentRod()
    local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")

    if Rods and typeof(Rods) == "string" then
        local CharacterRod = LocalPlayer.Character:FindFirstChild(Rods)

        if CharacterRod then
            local Events = CharacterRod:FindFirstChild("events")

            ---- Auto Shaker ----
            if LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                local safezone = LocalPlayer.PlayerGui.shakeui:FindFirstChild("safezone")
                if safezone then
                    local button = safezone:FindFirstChild("button")
                    if button then
                        AutoFishing.ShakeTicked = tick()
                        AutoFishing.BobberTicked = tick()
                        AutoFishing.UINavigation(button)
                        button.Name = button.Name .. "_"
                    elseif (tick() - AutoFishing.ShakeTicked) > AutoFishing.DebugTime then
                        Humanoid:UnequipTools()
                    end
                end
                ---- Auto Reel + Bobber ----
            elseif LocalPlayer.PlayerGui:FindFirstChild("reel") then
                local Reel = AutoFishing.GetReelFinished()
                if Reel then Reel:FireServer(100, true) end
            elseif not CharacterRod:FindFirstChild("bobber") and (tick() - AutoFishing.ShakeTicked) > 1 then
                if (tick() - AutoFishing.LastTicked) > 0.5 then
                    Events.reset:FireServer()
                    Events.cast:FireServer(100, 1)
                    AutoFishing.LastTicked = tick()
                    AutoFishing.BobberTicked = tick()
                    AutoFishing.ShakeTicked = tick()
                end
            elseif CharacterRod:FindFirstChild("bobber") and not LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                if (tick() - AutoFishing.BobberTicked) > AutoFishing.DebugTime then
                    Humanoid:UnequipTools()
                end
            end
        else
            if LocalPlayer.Backpack:FindFirstChild(Rods) then
                Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(Rods))
            end
        end
    end

    ---- Loop ----
    KansxyAutoCast()
    task.wait(0.7)
    KansxyAutoReel()
    KansxyAutoReel()
end
