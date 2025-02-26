---- best No render for low fps user - mid ----

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer.PlayerGui
local data_listener = {}

local function notification(msg)
    return string.format("[No Render]: %s", msg)
end

local function no_render(character)
    data_listener = {};

    character:WaitForChild("Humanoid", math.huge)
    character:WaitForChild("HumanoidRootPart", math.huge)

    print(notification("Init Character"));

    local cache = {"HandwrittenNote", "TimeEvent", ""};

    if workspace.active:FindFirstChild("Leaderboards") then 
        workspace.active:FindFirstChild("Leaderboards"):Destroy();
    end; 

    for i,v in pairs(cache) do 

        local links = PlayerGui:FindFirstChild(tostring(v));

        if links then
    
            links:Destroy();
    
        end
    end;

    print(notification("Started NoRender"));

    local hud = PlayerGui:FindFirstChild("hud")

    if hud then
        for _, v in pairs(hud:GetDescendants()) do
            if v.Name == "scroll" then
                local father = v.Parent
                local father2 = v.Parent.Parent;

                if father and father2 then
                    if not data_listener[v] then

                        data_listener[v] = {
                            loaded = false;
                        };

                        for _, fucker in pairs(v:GetChildren()) do
                            if fucker.ClassName == "ImageButton" or fucker.ClassName == "Frame" then
                                fucker.Parent = nil;
                                table.insert(data_listener[v], fucker);
                            end
                        end


                        v.ChildAdded:Connect(function(fucker)
                            task.wait();
                            if fucker.ClassName == "ImageButton" or fucker.ClassName == "Frame" then
                                if not table.find(data_listener[v], fucker) then 
                                    --fucker.Parent = nil;
                                    table.insert(data_listener[v], fucker);
                                end; 
                            end
                        end);

                    end

                    pcall(function()

                        father:GetPropertyChangedSignal("Visible"):Connect(function()

                            if father.Visible then 
                                data_listener[v].loaded = true;

                                if data_listener[v] then
                                    for _, x in pairs(data_listener[v]) do
                                        if x then 
                                            x.Parent = v;
                                        end; 
                                    end
                                end
                            else 
                                data_listener[v].loaded = false;

                                if data_listener[v] then
                                    for _, x in pairs(data_listener[v]) do
                                        if x then 
                                            x.Parent = nil;
                                        end; 
                                    end
                                end
                            end; 
    
                        end)
    
                        father2:GetPropertyChangedSignal("Visible"):Connect(function()
    
                            if father2.Visible then 
                                data_listener[v].loaded = true;

                                if data_listener[v] then
                                    for _, x in pairs(data_listener[v]) do
                                        if x then 
                                            x.Parent = v;
                                        end; 
                                    end
                                end
                            else 
                                data_listener[v].loaded = false;

                                if data_listener[v] then
                                    for _, x in pairs(data_listener[v]) do
                                        if x then 
                                            x.Parent = nil;
                                        end; 
                                    end
                                end
                            end; 
    
                        end)
                    
                    end);

                end
            end
        end
    end
end

no_render(LocalPlayer.Character);
LocalPlayer.CharacterAdded:Connect(no_render);
