local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local function notification(msg)
    return string.format("[No Render]: %s", msg)
end

-- Rendering optimization
local function no_render(character)
    character:WaitForChild("Humanoid", math.huge)
    character:WaitForChild("HumanoidRootPart", math.huge)
    print(notification("Init Character"))
    local guiToRemove = {"HandwrittenNote", "TimeEvent"}
    for _, name in pairs(guiToRemove) do
        local gui = PlayerGui:FindFirstChild(name)
        if gui then
            gui:Destroy()
        end
    end

    local leaderboards = workspace:FindFirstChild("active") and workspace.active:FindFirstChild("Leaderboards")
    if leaderboards then
        leaderboards:Destroy()
    end

    print(notification("Started NoRender"))

    local hud = PlayerGui:FindFirstChild("hud")
    if hud then
        for _, scroll in pairs(hud:GetDescendants()) do
            if scroll.Name == "scroll" then
                local container = scroll.Parent
                if container then
                    for _, child in pairs(scroll:GetChildren()) do
                        if child:IsA("ImageButton") or child:IsA("Frame") then
                            child.Visible = false
                        end
                    end

                    local function updateVisibility()
                        local shouldBeVisible = container.Visible
                        for _, child in pairs(scroll:GetChildren()) do
                            if child:IsA("ImageButton") or child:IsA("Frame") then
                                child.Visible = shouldBeVisible
                            end
                        end
                    end

                    container:GetPropertyChangedSignal("Visible"):Connect(updateVisibility)
                    updateVisibility() -- Set initial state

                    scroll.ChildAdded:Connect(function(child)
                        if child:IsA("ImageButton") or child:IsA("Frame") then
                            child.Visible = container.Visible
                        end
                    end)
                end
            end
        end
    end
end

no_render(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(no_render)
