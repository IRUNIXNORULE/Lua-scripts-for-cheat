-- Auto Cast
local function autoCast()
    local player = game:GetService("Players").LocalPlayer
    local rod = nil
    for _, item in pairs(player.Character:GetChildren()) do
        if item:IsA("Tool") and item.Name:match("Rod") and item:FindFirstChild("events") and item.events:FindFirstChild("cast") then
            rod = item
            break
        end
    end
---- Rod Found ----
    if rod then
        local args = {
            [1] = 100,
            [2] = 1
        }
        rod.events.cast:FireServer(unpack(args))
    end
end

-- Auto Finish Reel
local function autoReel()
    local events = game:GetService("ReplicatedStorage"):FindFirstChild("events")
    if events and events:FindFirstChild("reelfinished ") then
        local args = {
            [1] = 100,
            [2] = true
        }
        events:FindFirstChild("reelfinished "):FireServer(unpack(args))
    end
end

while task.wait(1) do
    autoCast()
    task.wait(0.5)
    autoReel()
end
