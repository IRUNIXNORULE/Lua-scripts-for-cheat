local MuhammadHub = {}  -- Allah Is God!
getgenv().acceleration = 20

_G.AutoAttackBall = true
_G.AutoFARMCOW = true

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local OriginalCameraSubject = Workspace.CurrentCamera.CameraSubject

local function TrackBall(ball)
local trackTask = task.spawn(function()
while task.wait() do
    if not _G.AutoFARMCOW then
        Workspace.CurrentCamera.CameraSubject = OriginalCameraSubject
        break
        end

        local offset = Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
        HumanoidRootPart.CFrame = ball.CFrame * CFrame.new(offset)

        if Character and Character:FindFirstChild("Highlight") then
            local velocityMagnitude = ball.Velocity.Magnitude
            HumanoidRootPart.CFrame = ball.CFrame * CFrame.new(0, 0, velocityMagnitude * -0.5)
            ReplicatedStorage.Remote.ParryButtonPress:Fire()
            end
            end
            end)

ball.Destroying:Connect(function()
task.cancel(trackTask)
end)
end

Workspace.Balls.ChildAdded:Connect(function(ball)
if ball:IsA("BasePart") then
    TrackBall(ball)
    end
    end)

Workspace.Balls.ChildAdded:Connect(function(ball)
if not _G.AutoAttackBall then return end
    if not (ball:IsA("BasePart") and ball:GetAttribute("realBall") == true) then return end

        local BallBeforePosition = ball.Position
        local CallTick = tick()

        ball:GetPropertyChangedSignal("Position"):Connect(function()
        if Character and Character:FindFirstChild("Highlight") then
            local Distance = (ball.Position - Workspace.CurrentCamera.Focus.Position).Magnitude
            end
            end)
        end)
