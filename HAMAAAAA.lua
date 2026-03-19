local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local throwRemote = ReplicatedStorage:WaitForChild("Fishing_RemoteThrow")
local fishingFolder = ReplicatedStorage:WaitForChild("Fishing")
local toServer = fishingFolder:WaitForChild("ToServer")
local minigameStarted = toServer:WaitForChild("MinigameStarted")
local reelFinished = toServer:WaitForChild("ReelFinished")

local sellRemote = ReplicatedStorage:WaitForChild("Economy"):WaitForChild("ToServer"):WaitForChild("SellUnder")

local sessionID = nil
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if getnamecallmethod() == "FireServer" and self == throwRemote then
        local args = {...}
        if typeof(args[2]) == "string" and #args[2] > 20 then
            sessionID = args[2]
            print("✅ Session ID captured: " .. sessionID)
        end
    end
    return oldNamecall(self, ...)
end))

getgenv().Blati = false
getgenv().ForceSecret = false
getgenv().InfiniteJump = false
getgenv().Noclip = false
getgenv().WalkSpeedValue = 16
getgenv().AutoSell = false
getgenv().SellCount = 10
getgenv().FishCaught = 0

-- ✅ CUSTOM MINIMIZE IMAGE (ganti ID ini pakai gambar lo sendiri)
getgenv().MinimizeImage = "rbxassetid://3926305904" -- <<< GANTI ID INI PAKE rbxassetid://GAMBAR_YANG_LO_MAU (upload ke Roblox dulu)

local humanoid = nil
local function getHumanoid()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        humanoid = player.Character.Humanoid
        return humanoid
    end
    return nil
end
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    getHumanoid()
end)
getHumanoid()

-- ✅ GANTI KE LINORIA (LEBIH KEREN! Modern dark theme, smooth animation, premium look)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local Window = Library:CreateWindow({
    Title = 'HamzHub',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('MAIN'),
    Player = Window:AddTab('PLAYER'),
    Teleport = Window:AddTab('TELEPORT'),
}

local blatiLoop
local function startBlati()
    if blatiLoop then return end
    blatiLoop = task.spawn(function()
        while getgenv().Blati do
            if sessionID and humanoid then
                throwRemote:FireServer(0, sessionID)
                task.wait(0.00001)
                minigameStarted:FireServer(sessionID)
                task.wait(0.00001)
                local successArgs = {
                    ["duration"] = math.random(7.5, 12.5),
                    ["result"] = "SUCCESS",
                    ["insideRatio"] = 0.8 + (math.random(3, 18) / 100),
                    ["catchType"] = "SECRET",
                    ["isSecret"] = true
                }
                reelFinished:FireServer(successArgs, sessionID)
                getgenv().FishCaught = (getgenv().FishCaught or 0) + 1
                task.wait(0.00001)
            else
                task.wait(0.00001)
            end
        end
    end)
end

local MainGroup = Tabs.Main:AddLeftGroupbox('Fishing Features')

MainGroup:AddToggle('BlatiFlag', {
    Text = 'BLATI (Instant Fishing)',
    Default = false,
    Callback = function(Value)
        getgenv().Blati = Value
        if Value then
            startBlati()
            local args = {"bd4238ec-6bbc-4523-8c63-a17356e1f130"}
            game:GetService("ReplicatedStorage"):WaitForChild("FishUI"):WaitForChild("ToServer"):WaitForChild("ToggleFavorite"):FireServer(unpack(args))
        else
            if blatiLoop then task.cancel(blatiLoop) blatiLoop = nil end
        end
    end,
})

local forceSecretLoop
local function startForceSecret()
    if forceSecretLoop then return end
    forceSecretLoop = task.spawn(function()
        while getgenv().ForceSecret do
            if sessionID and humanoid then
                throwRemote:FireServer(0, sessionID)
                task.wait(0.00001)
                minigameStarted:FireServer(sessionID)
                task.wait(0.00001)
                local successArgs = {
                    ["duration"] = math.random(7.5, 12.5),
                    ["result"] = "SUCCESS",
                    ["insideRatio"] = 0.8 + (math.random(3, 18) / 100),
                    ["catchType"] = "SECRET",
                    ["isSecret"] = true
                }
                reelFinished:FireServer(successArgs, sessionID)
                getgenv().FishCaught = (getgenv().FishCaught or 0) + 1
                task.wait(0.00001)
            else
                task.wait(0.00001)
            end
        end
    end)
end

MainGroup:AddToggle('ForceSecretFlag', {
    Text = 'FORCE SECRET (Instant Fishing Secret)',
    Default = false,
    Callback = function(Value)
        getgenv().ForceSecret = Value
        if Value then
            startForceSecret()
            local args = {"bd4238ec-6bbc-4523-8c63-a17356e1f130"}
            game:GetService("ReplicatedStorage"):WaitForChild("FishUI"):WaitForChild("ToServer"):WaitForChild("ToggleFavorite"):FireServer(unpack(args))
        else
            if forceSecretLoop then task.cancel(forceSecretLoop) forceSecretLoop = nil end
        end
    end,
})

local jumpConnection
local PlayerGroup = Tabs.Player:AddLeftGroupbox('Player Features')

PlayerGroup:AddToggle('InfJumpFlag', {
    Text = 'Infinite Jump',
    Default = false,
    Callback = function(Value)
        getgenv().InfiniteJump = Value
        if Value then
            if not jumpConnection then
                jumpConnection = UserInputService.JumpRequest:Connect(function()
                    if getgenv().InfiniteJump and humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        end
    end,
})

local noclipConnection
PlayerGroup:AddToggle('NoclipFlag', {
    Text = 'Noclip',
    Default = false,
    Callback = function(Value)
        getgenv().Noclip = Value
        if Value then
            if not noclipConnection then
                noclipConnection = RunService.Stepped:Connect(function()
                    if getgenv().Noclip and player.Character then
                        for _, v in pairs(player.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end)
            end
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
                if player.Character then
                    for _, v in pairs(player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = true end
                    end
                end
            end
        end
    end,
})

PlayerGroup:AddInput('WalkSpeedFlag', {
    Text = 'WalkSpeed',
    Default = '16',
    Placeholder = '16',
    Numeric = false,
    Finished = false,
    Callback = function(Text)
        local value = tonumber(Text)
        if value and humanoid then
            getgenv().WalkSpeedValue = value
            humanoid.WalkSpeed = value
        end
    end,
})

PlayerGroup:AddInput('SellCountFlag', {
    Text = 'Sell by count (fish)',
    Default = '10',
    Placeholder = '10',
    Numeric = false,
    Finished = false,
    Callback = function(Text)
        local val = tonumber(Text)
        if val and val >= 1 and val <= 200 then
            getgenv().SellCount = val
        end
    end,
})

local autoSellLoop
local function startAutoSell()
    if autoSellLoop then return end
    autoSellLoop = task.spawn(function()
        while getgenv().AutoSell do
            if getgenv().FishCaught >= getgenv().SellCount then
                if sellRemote then
                    sellRemote:FireServer(1000)
                end
                getgenv().FishCaught = 0
            end
            task.wait(1)
        end
    end)
end

PlayerGroup:AddToggle('AutoSellFlag', {
    Text = 'AUTO SELL',
    Default = false,
    Callback = function(Value)
        getgenv().AutoSell = Value
        if Value then
            startAutoSell()
        else
            if autoSellLoop then task.cancel(autoSellLoop) autoSellLoop = nil end
        end
    end,
})

local TeleportGroup = Tabs.Teleport:AddLeftGroupbox('TELEPORT PULAU')

TeleportGroup:AddButton({
    Text = 'Pulau Kinyis',
    Func = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(81.8612061, 1006.87341, -818.234985, 0.485841095, -3.1988499e-08, -0.87404716, 9.73005925e-08, 1, 1.74866148e-08, 0.87404716, -9.35410185e-08, 0.485841095)
            sessionID = nil
            task.wait(0.5)
            local backpackTool = player.Backpack:FindFirstChildOfClass("Tool")
            if backpackTool then
                backpackTool.Parent = player.Character
            end
        end
    end,
})

TeleportGroup:AddButton({
    Text = 'Pulau Raja Ampat',
    Func = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-1845.45935, 1006.62732, -1579.06555, 0.925677121, -1.99983274e-09, 0.378314495, 9.79888726e-10, 1, 2.88852808e-09, -0.378314495, -2.30313835e-09, 0.925677121)
            sessionID = nil
            task.wait(0.5)
            local backpackTool = player.Backpack:FindFirstChildOfClass("Tool")
            if backpackTool then
                backpackTool.Parent = player.Character
            end
        end
    end,
})

TeleportGroup:AddButton({
    Text = 'Pulau Wakatobi',
    Func = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-1399.88684, 1021.17017, 1497.85059, -0.327202201, -4.10665884e-08, 0.944954336, 7.90609747e-08, 1, 7.08346519e-08, -0.944954336, 9.78862644e-08, -0.327202201)
            sessionID = nil
            task.wait(0.5)
            local backpackTool = player.Backpack:FindFirstChildOfClass("Tool")
            if backpackTool then
                backpackTool.Parent = player.Character
            end
        end
    end,
})

TeleportGroup:AddButton({
    Text = 'Pulau Bali',
    Func = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(989.347717, 1034.922, 1607.38538, 0.00405485556, 4.51565931e-08, 0.999991775, -1.46329642e-08, 1, -4.50976287e-08, -0.999991775, -1.4449979e-08, 0.00405485556)
            sessionID = nil
            task.wait(0.5)
            local backpackTool = player.Backpack:FindFirstChildOfClass("Tool")
            if backpackTool then
                backpackTool.Parent = player.Character
            end
        end
    end,
})

TeleportGroup:AddButton({
    Text = 'Pulau natuna',
    Func = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(2240.65332, 995.997681, -94.5214081, 0.267383486, 2.81976913e-08, -0.963590205, 1.64388858e-08, 1, 3.38247297e-08, 0.963590205, -2.48845229e-08, 0.267383486)
            sessionID = nil
            task.wait(0.5)
            local backpackTool = player.Backpack:FindFirstChildOfClass("Tool")
            if backpackTool then
                backpackTool.Parent = player.Character
            end
        end
    end,
})

TeleportGroup:AddButton({
    Text = 'Pulau Banda',
    Func = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-349.488678, 1000.69397, 178.114243, 0.996432185, 6.81453258e-08, 0.0843971372, -6.44756852e-08, 1, -4.6206285e-08, -0.0843971372, 4.05998684e-08, 0.996432185)
            sessionID = nil
            task.wait(0.5)
            local backpackTool = player.Backpack:FindFirstChildOfClass("Tool")
            if backpackTool then
                backpackTool.Parent = player.Character
            end
        end
    end,
})

player.CharacterAdded:Connect(function()
    task.wait(1)
    if humanoid then
        humanoid.WalkSpeed = getgenv().WalkSpeedValue
    end
end)

local VirtualUser = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local function setupRodEquip(char)
    if not char then return end
    char.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") and (getgenv().Blati or getgenv().ForceSecret) then
            task.wait(0.05)
            local backpackTool = player.Backpack:FindFirstChildOfClass("Tool")
            if backpackTool then
                backpackTool.Parent = char
            end
        end
    end)
end

if player.Character then
    setupRodEquip(player.Character)
end
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if humanoid then
        humanoid.WalkSpeed = getgenv().WalkSpeedValue
    end
    setupRodEquip(char)
end)

-- ✅ UI MINIMIZE CUSTOM (tombol floating yang gambarnya bisa diubah)
task.spawn(function()
    task.wait(2) -- tunggu Linoria full load
    local minimizeGui = Instance.new("ScreenGui")
    minimizeGui.Name = "HamzMinimizeUI"
    minimizeGui.ResetOnSpawn = false
    minimizeGui.Parent = player.PlayerGui

    local minimizeBtn = Instance.new("ImageButton")
    minimizeBtn.Size = UDim2.fromOffset(55, 55)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 20)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Image = getgenv().MinimizeImage
    minimizeBtn.Parent = minimizeGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = minimizeBtn

    local isHidden = false
    minimizeBtn.MouseButton1Click:Connect(function()
        local coreGui = game:GetService("CoreGui")
        local linoriaScreen = nil
        for _, v in ipairs(coreGui:GetChildren()) do
            if v:IsA("ScreenGui") and v:FindFirstChild("Main") then
                linoriaScreen = v
                break
            end
        end
        if linoriaScreen then
            isHidden = not isHidden
            linoriaScreen.Enabled = not isHidden
            print("🖼️ HamzHub GUI " .. (isHidden and "DIMINIMIZE" or "DITAMPILKAN"))
        end
    end)
end)

print("🎉 HAMZHUB GUI KEREN udah muncul bro! Tab MAIN & PLAYER siap. Cast manual 1x dulu biar Blati nyala. Gas polll 🔥")
