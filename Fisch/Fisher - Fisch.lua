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

local fishingState = "idle"
local reelCount = 0
local lastReelTime = 0

while task.wait(0.05) do
    local currentTime = tick()
    local Rods = AutoFishing.GetCurrentRod()
    local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")

    if Rods and typeof(Rods) == "string" then
        local CharacterRod = LocalPlayer.Character:FindFirstChild(Rods)

        if fishingState == "idle" then
            if not CharacterRod then
                if LocalPlayer.Backpack:FindFirstChild(Rods) then
                    Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(Rods))
                end
            else
                local Events = CharacterRod:FindFirstChild("events")
                if Events then
                    Events.reset:FireServer()
                    Events.cast:FireServer(100, 1)
                    fishingState = "casting"
                    AutoFishing.LastTicked = currentTime
                    AutoFishing.BobberTicked = currentTime
                    AutoFishing.ShakeTicked = currentTime
                end
            end
        elseif fishingState == "casting" then
            if CharacterRod and CharacterRod:FindFirstChild("bobber") then
                fishingState = "waitingForBite"
            elseif (currentTime - AutoFishing.BobberTicked) > AutoFishing.DebugTime then
                Humanoid:UnequipTools()
                fishingState = "idle"
            end
        elseif fishingState == "waitingForBite" then
            if LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                local safezone = LocalPlayer.PlayerGui.shakeui:FindFirstChild("safezone")
                if safezone then
                    local button = safezone:FindFirstChild("button")
                    if button then
                        AutoFishing.UINavigation(button)
                        button.Name = button.Name .. "_"
                        fishingState = "shaking"
                    end
                end
            elseif (currentTime - AutoFishing.ShakeTicked) > AutoFishing.DebugTime then
                Humanoid:UnequipTools()
                fishingState = "idle"
            end
        elseif fishingState == "shaking" then
            if not LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                fishingState = "reeling"
                reelCount = 2  -- Set to reel twice
                lastReelTime = 0
            end
        elseif fishingState == "reeling" then
            if reelCount > 0 then
                if currentTime - lastReelTime > 0.1 then  -- 0.1-second delay between reels
                    local Reel = AutoFishing.GetReelFinished()
                    if Reel then
                        Reel:FireServer(100, true)
                    end
                    reelCount = reelCount - 1
                    lastReelTime = currentTime
                end
            else
                fishingState = "idle"  -- Reset to start over
            end
        end
    end
end
