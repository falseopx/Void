local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Concepts0/Void/experimental/vapelib.lua"))()

--#region Functions
local ws = game:GetService("Workspace")
local reps = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")

local plr = players.LocalPlayer
local cam = ws.CurrentCamera

local walkSpeed = 16
local jumpPower = 50

function AntiAFK()
    local client = game:GetService("VirtualUser")

    plr.Idled:Connect(function()
        client:Button2Down(Vector2.new(0,0),cam.CFrame)
        wait(1)
        client:Button2Up(Vector2.new(0,0),cam.CFrame)
    end)
end

function Speed(toggled)
    local speedToggled = toggled

    spawn(function() 
        while speedToggled do
            plr.Character.Humanoid.WalkSpeed = walkSpeed

            if not speedToggled then break end

            wait()
        end
    end)

    if not speedToggled then plr.Chracter.Humanoid.WalkSpeed = 16 end
end

function SuperJump(toggled)
    local jumpToggled = toggled

    spawn(function() 
        while jumpToggled do
            plr.Character.Humanoid.JumpPower = jumpPower

            if not jumpToggled then break end
            wait()
        end
    end)

    if not jumpToggled then plr.Character.Humanoid.JumpPower = 50 end
end

function Tracers(toggled)
    local tracersToggled = toggled

    for _,v in pairs(players:GetPlayers()) do
        if v.Name ~= plr.Name then
            local tracer = Drawing.new("Line")
    
            rs.Heartbeat:Connect(function()
                if v.Character ~= nil and v.Character.HumanoidRootPart ~= nil then
                    local pos, size = v.Character.HumanoidRootPart.CFrame, v.Character.HumanoidRootPart.Size * 1
                    local vector, onScreen = cam:WorldToViewportPoint(pos * CFrame.new(0, -size.Y, 0).p)
                    
                    tracer.Thickness = 2
                    tracer.Transparency = 1
                    tracer.Color = Color3.fromRGB(255,255,255)

                    tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

                    if onScreen == true then
                        tracer.To = Vector2.new(vector.X, vector.Y)
                        
                        tracer.Visible = tracersToggled
                    else tracer.Visible = false end
                else tracer.Visible = false end
            end)

            players.PlayerRemoving:Connect(function()
                tracer.Visible = false
            end)
        end
    end

    players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(v)
            if v.Name ~= plr.Name then
                local tracer = Drawing.new("Line")
        
                rs.Heartbeat:Connect(function()
                    if v.Character ~= nil and v.Character.HumanoidRootPart ~= nil then
                        local pos, size = v.Character.HumanoidRootPart.CFrame, v.Character.HumanoidRootPart.Size * 1
                        local vector, onScreen = cam:WorldToViewportPoint(pos * CFrame.new(0, -size.Y, 0).p)
                        
                        tracer.Thickness = 2
                        tracer.Transparency = 1
                        tracer.Color = Color3.fromRGB(255,255,255)
    
                        tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    
                        if onScreen == true then
                            tracer.To = Vector2.new(vector.X, vector.Y)
                            
                            tracer.Visible = tracersToggled
                        else tracer.Visible = false end
                    else tracer.Visible = false end
                end)
    
                players.PlayerRemoving:Connect(function()
                    tracer.Visible = false
                end)
            end
        end)
    end)
end

function BloxburgAutofarm(type)
    repeat wait() until game:IsLoaded()

    local stats = rs.Stats[plr.Name]
    local dm = require(rs.Modules.DataManager)

    local function fireServer(data)
        local oldI = getfenv(dm.FireServer).i
        
        getfenv(dm.FireServer).i = function() end
        dm:FireServer(data)
        getfenv(dm.FireServer).i = oldI
    end

    local function getOrder(c)
        if not c or (c and not c:FindFirstChild("Order")) then return end

        if stats.Job.Value == "StylezHairdresser" then 
            local style = c.Order:WaitForChild("Style").Value
            local color = c.Order:WaitForChild("Color").Value

            return {style, color}
        elseif stats.Job.Value == "BloxyBurgersCashier" then
            local burger = c.Order:WaitForchild("Burger").Value
            local fries = c.Order:WaitForChild("Fries").Value
            local cola = c.Order:WaitForChild("Cola").Value

            return {burger, fries, cola}
        end
    end

    if (type == 1) then
        if (stats.Job.Value ~= "StylezHairdresser") then
            jobManager:GoToWork("StylezHairdresser")
        end
        
        repeat wait() until stats.Job.Value == "StylezHairdresser"

        ts:Create(plr.Character.HumanoidRootPart, TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(868.464783, 13.6776829, 174.983795, -0.999945581, -6.58446098e-08, -0.0104347449, -6.6522297e-08, 1, 6.45977494e-08, 0.0104347449, 6.52883756e-08, -0.999945581)}):Play()
        
        while true do
            local workstations = ws.Environment.Locations.StylezHairStudio.HairdresserWorkstations
            for _,v in next, workstations:GetChildren() do
                if (v.Occupied.Value) then
                    fireServer({Type = "FinishOrder", Workstation = v ,Order = getOrder(v.Occupied.Value)})
                end
            end

            wait()
        end
    elseif(type == 2) then
        if (stats.Job.Value ~= "BloxyBurgersCashier") then
            jobManager:GoToWork("BloxyBurgersCashier")
        end;
        
        repeat wait() until stats.Job.Value == "BloxyBurgersCashier"
        ts:Create(plr.Character.HumanoidRootPart, TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(825.076355, 13.6776829, 276.091309, 0.0133343497, -5.09454665e-08, -0.999910772, 7.34347916e-09, 1, -5.08520621e-08, 0.999910772, -6.66474698e-09, 0.0133343497)}):Play()
        
        while true do
            local workstations = ws.Environment.Locations.BloxyBurgers.CashierWorkstations;
            for _,v in next, workstations:GetChildren() do
                if (v.Occupied.Value) then
                    fireServer({Type = "FinishOrder", Workstation = v, Order = getOrder(v.Occupied.Value)})
                end
            end

            wait()
        end
    end
end
--#endregion

--#region UI
--#region Init
local window = lib:Window("Void",Color3.fromRGB(139, 80, 221),Enum.KeyCode.RightShift)

local S1, S2, S4, S5 = window:Tab("Player"), window:Tab("Server"), window:Tab("ESP"), window:Tab("Script Hub")
--#endregion

--#region Game : Bloxburg
if game.PlaceId == 185655149 then
    local S3 = window:Tab("Bloxburg")

    S3:Label("Autofarm")

    S3:Button("Bloxburg Autofarm : Hair Dressing", function()
        lib:Notification("Autofarm Started", "Hairdressing autofarm has begun.", "Ok")

        BloxburgAutofarm(1)
    end)

    S3:Button("Bloxburg Autofarm : Cashier", function()
        lib:Notification("Autofarm Started", "Cashier autofarm has begun.", "Ok")

        BloxburgAutofarm(2)
    end)
end
--#endregion

--#region Game : Nuclear Bomb Testing Facility
if game.PlaceId == 6153709 then
    local S3 = window:Tab("Nuclear Bomb Testing Facility")
    local nbtfInfiniteAmmoToggled = false

    local weaponList = {
        "UMP-9",
        "MPX",
        "Imaginary Gun",
        "M4 Carbine",
        "AK74",
        "Spy USP",
        "God Gun",
        "USP"
    }

    S3:Label("Weapons")

    -- God Gun
    S3:Button("God Gun", function()
        for _,tool in pairs(plr.Backpack:GetChildren()) do
            for _,weaponName in pairs(weaponList) do
                if tool.Name == weaponName and tool.Name ~= "God Gun" then
                    tool.Name = "God Gun"
                    tool.ToolTip = "Bring the wrath of God to your weapon. Let hell rain down on your enemies."
                    tool.Configuration.ShotCooldown.Value = 0
                    tool.Configuration.RecoilMin.Value = 0
                    tool.Configuration.RecoilMax.Value = 0
                    tool.Configuration.RecoilDecay.Value = 0
                    tool.Configuration.HitDamage.Value = 999
                    tool.Configuration.MuzzleFlashSize1.Value = 0
                    tool.Configuration.MuzzleFlashSize0.Value = 0
                    tool.Configuration.TotalRecoilMax.Value = 0
                    tool.Configuration.MaxSpread.Value = 0
                    tool.Configuration.MaxDistance.Value = 999999
                end
            end
        end

        for _,tool in pairs(plr.Character:GetChildren()) do
            for _,weaponName in pairs(weaponList) do
                if tool.Name == weaponName and tool.Name ~= "God Gun" then
                    tool.Name = "God Gun"
                    tool.ToolTip = "Bring the wrath of God to your weapon. Let hell rain down on your enemies."
                    tool.Configuration.ShotCooldown.Value = 0
                    tool.Configuration.RecoilMin.Value = 0
                    tool.Configuration.RecoilMax.Value = 0
                    tool.Configuration.RecoilDecay.Value = 0
                    tool.Configuration.HitDamage.Value = 999
                    tool.Configuration.MuzzleFlashSize1.Value = 0
                    tool.Configuration.MuzzleFlashSize0.Value = 0
                    tool.Configuration.TotalRecoilMax.Value = 0
                    tool.Configuration.MaxSpread.Value = 0
                    tool.Configuration.MaxDistance.Value = 999999
                end
            end
        end
    end)

    -- Infinite Ammo Toggle
    S3:Toggle("Infinite Ammo", function(v)
        if v then nbtfInfiniteAmmoToggled = true else nbtfInfiniteAmmoToggled = false end

        spawn(function() 
            while nbtfInfiniteAmmoToggled do 
                if nbtfInfiniteAmmoToggled then
                    for _,tool in pairs(plr.Backpack:GetChildren()) do
                        for _,weaponName in pairs(weaponList) do
                            if string.match(tool.Name, weaponName) then
                                tool.Configuration.AmmoReserves.Value = 999999
                                tool.Configuration.AmmoCapacity.Value = 999999
                                tool.CurrentAmmo.Value = 999999
                            end
                        end
                    end

                    for _,tool in pairs(plr.Character:GetChildren()) do
                        for _,weaponName in pairs(weaponList) do
                            if string.match(tool.Name, weaponName) then
                                tool.Configuration.AmmoReserves.Value = 999999
                                tool.Configuration.AmmoCapacity.Value = 999999
                                tool.CurrentAmmo.Value = 999999
                            end
                        end
                    end
                else break end

                wait()
            end      
        end)
    end)
end
--#endregion

--#region Game : Jailbreak
-- nothing yet bruh
--#endregion

--#region Player
S1:Label("General")

S1:Button("Anti-AFK Kick", function()
    AntiAFK()
end)

S1:Label("Movement")

S1:Toggle("Speed",false,function(v) Speed(v) end)
S1:Slider("Speed Amount",16,150,16,function(v) walkSpeed = v end)

S1:Toggle("Super Jump",false,function(v) SuperJump(v) end)
S1:Slider("Jump Power",50,1000,50,function(v) jumpPower = v end)
--#endregion

--#region Server
S2:Button("Rejoin Server", function() game:GetService("TeleportService"):Teleport(game.PlaceId, plr) end)
--#endregion

--#region ESP
S4:Toggle("Tracers",false,function(v) Tracers(v) end)
--#endregion

--#region Script Hub
S5:Label("Essential")
S5:Button("Simple Spy",function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Concepts0/Void/experimental/scripts/simplespy.lua"))() end)
S5:Button("Dark Dev V4",function() loadstring(game:HttpGetAsync("https://pastebin.com/raw/iuQPQq4M"))() end) 
S5:Label("Hubs")
S5:Button("Solaris",function() loadstring(game:HttpGet('https://solarishub.dev/script.lua',true))() end)
S5:Button("Domain Hub",function() loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftworks/Domain/main/source'),true))() end)
S5:Label("Jailbreak")
S5:Button("Autorob",function() loadstring(game:HttpGet("https://raw.githubusercontent.com/wawsdasdacx/ohascriptnrrewading/main/jbsaxcriptidk1"))() end)
S5:Label("Lumber Tycoon 2")
S5:Button("Ancestor",function() loadstring(game:HttpGetAsync'https://ancestordevelopment.wtf/Ancestor')('Ancestor V3 Winning :D') end)
S5:Button("Dirt",function() loadstring(game:HttpGet("https://dirtgui.xyz/Lt2.lua",true))() end)
S5:Button("Bark",function() loadstring(game:HttpGetAsync'https://cdn.applebee1558.com/bark/bark.lua')('bark > blood :)') end)
S5:Label("Apocalypse Rising")
S5:Button("Tripp",function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Concepts0/Void/experimental/scripts/tripp.lua"))() end)
S5:Label("Bedwars")
S5:Button("Vape",function() loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))() end)
S5:Label("Clone Tycoon 2")
S5:Button("Script",function() task.spawn(loadstring(game:HttpGet("https://paste.ee/r/N0fo7/0")),[[also if it doesn't load look in the console for some warns / errors]]) end)
S5:Label("Simulators")
S5:Button("Mining Simulator",function() loadstring(game:HttpGet(("https://raw.githubusercontent.com/GuentherHade/Roblox/main/Obfuscated.lua"),true))() end)
S5:Button("Pet Simulator X",function() loadstring(game:HttpGet("https://pastebin.com/raw/95HthyJq"))() end)
S5:Label("Phantom Forces")
S5:Button("ehub.fun",function() loadstring(game:HttpGet("https://ehub.fun/raw/script.lua"))() end)
S5:Label("Prison Life")
S5:Button("Admin Commands",function() loadstring(game:HttpGet(('https://raw.githubusercontent.com/XTheMasterX/Scripts/Main/PrisonLife'),true))() end)
--#endregion
--#endregion
