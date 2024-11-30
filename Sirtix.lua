local UILib     = loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()
local Window    = UILib.new("Sirtix", "Sirtix User", "sirtixexecutor.netlify.app")
local Category1 = Window:Category("Local", "http://www.roblox.com/asset/?id=90807912793699")
local Category2 = Window:Category("Visuals", "http://www.roblox.com/asset/?id=129042018463449")
local Category3 = Window:Category("Players", "http://www.roblox.com/asset/?id=82427272158061")

local Category4 = Window:Category("Client", "http://www.roblox.com/asset/?id=120274788136096")





local SubButton1 = Category1:Button("Movement / Health", "http://www.roblox.com/asset/?id=133661615272033")
local SubButton2 = Category1:Button("Aim", "http://www.roblox.com/asset/?id=112912070436617")

local SubButton3   = Category1:Button("Abilities", "http://www.roblox.com/asset/?id=102267831321394")
local SubButtonCOS = Category4:Button("Cosmetic", "http://www.roblox.com/asset/?id=131333025717870")

local SubButton4 = Category2:Button("ESP", "http://www.roblox.com/asset/?id=120129574453255")
local SubButton5 = Category2:Button("Vision", "http://www.roblox.com/asset/?id=117033186682085")

local SectionCHAMS    = SubButton4:Section("Chams", "Left")
local SectionTRACERS  = SubButton4:Section("Tracers", "Right")
local SectionSKELETON = SubButton4:Section("Skeletons", "Left")
local SectionBOX      = SubButton4:Section("Boxes", "Left")
local SectionNAMES    = SubButton4:Section("Names", "Right")
local SectionMISC     = SubButton4:Section("Misc", "Left")

local SectionFOV    = SubButton5:Section("Field Of View", "Left")
local SectionENVI   = SubButton5:Section("Environment", "Right")
local SectionCAMERA = SubButton5:Section("Camera Effects", "Left")

local SubButton6  = Category3:Button("IMPORTANT", "http://www.roblox.com/asset/?id=79791826459299")
local SubButton7  = Category3:Button("Movement", "http://www.roblox.com/asset/?id=123652566388954")
local SubButton11 = Category3:Button("Stalking", "http://www.roblox.com/asset/?id=134899469314390")
local SubButton12 = Category3:Button("Client", "http://www.roblox.com/asset/?id=120274788136096")

local SectionChat = SubButton12:Section("COMING SOON", "Left")

local SubButton8 = Category4:Button("Powers", "http://www.roblox.com/asset/?id=102267831321394")

local SubButton9  = Category4:Button("NSFW", "http://www.roblox.com/asset/?id=79791826459299")
local SubButton10 = Category4:Button("Network", "http://www.roblox.com/asset/?id=130949219774215")

local SectionDRUGS  = SubButton9:Section("Drugs", "Left")
local SectionSEXUAL = SubButton9:Section("Sexual", "Right")

local tool = nil
local isHolding = false
local holdTime = 0
local blurSpeed = 15
local maxBlur = 10

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = game.Workspace.CurrentCamera

-- Skapa BlurEffect
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = camera

-- Ljud när du börjar hålla in
local inhaleSound = nil
-- Ljud när röken kommer ut
local exhaleSound = nil

-- Rökpartiklar
local smoke = nil

-- Funktion för att uppdatera blur
local function updateBlur()
    while isHolding do
        if blur.Size < maxBlur then
            blur.Size = blur.Size + blurSpeed * game:GetService("RunService").Heartbeat:Wait()
        end
        holdTime = holdTime + game:GetService("RunService").Heartbeat:Wait()
    end
    while not isHolding and blur.Size > 0 do
        blur.Size = blur.Size - blurSpeed * game:GetService("RunService").Heartbeat:Wait()
    end
end

-- Funktion för att hantera rökfade
local function activateSmoke()
    -- Spela ljudet för röken
    exhaleSound:Play()

    -- Baserat på hur länge knappen hölls in
    local intensity = math.clamp(holdTime, 0.5, 3)
    smoke.Rate = intensity * 10
    smoke.Size = NumberSequence.new(0.5 * intensity, 2 * intensity)
    smoke.Speed = NumberRange.new(1, 2)

    -- För att ge röken en mer framåtriktad rörelse
    local head = character:WaitForChild("Head")
    local lookVector = head.CFrame.LookVector

    smoke.VelocityInheritance = 0
    smoke.Acceleration = lookVector * 2

    -- Fade in och out
    task.spawn(function()
        wait(0.5)
        smoke.Rate = 0
    end)
end

-- Skapa verktyget och sätt upp all logik
local function createTool()
    if tool then return end  -- Om verktyget redan finns, gör inget
    tool                = Instance.new("Tool")
    tool.Name           = "Vape"
    tool.RequiresHandle = false
    tool.Parent         = player.Backpack

    -- När verktyget aktiveras (hålls in)
    tool.Activated:Connect(function()
        if isHolding then return end
        isHolding = true
        holdTime = 0

        inhaleSound:Play()
        updateBlur()
    end)

    -- När verktyget deaktiveras (släpps)
    tool.Deactivated:Connect(function()
        if not isHolding then return end
        isHolding = false
        updateBlur()
        activateSmoke()
    end)
end

-- Ta bort verktyget om det finns
local function removeTool()
    if tool then
        tool:Destroy()
        tool = nil
    end
end

-- Skapa rökpartiklar (denna funktion skapar rök varje gång spelaren dör eller verktyget aktiveras)
local function createSmokeEmitter()
    smoke = Instance.new("ParticleEmitter")
    smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
    smoke.Rate = 0
    smoke.Lifetime = NumberRange.new(1, 2)
    smoke.Size = NumberSequence.new(0.5, 2)
    smoke.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    smoke.Speed = NumberRange.new(2, 5)
    smoke.VelocitySpread = 1
    smoke.Parent = character:WaitForChild("Head")
end

-- Funktion för att skapa ljud
local function createSounds()
    -- Ljud när du börjar hålla in
    inhaleSound = Instance.new("Sound")
    inhaleSound.SoundId = "rbxassetid://9114872888"
    inhaleSound.Volume = 1
    inhaleSound.Looped = false
    inhaleSound.Parent = character:WaitForChild("Head")

    -- Ljud när röken kommer ut
    exhaleSound = Instance.new("Sound")
    exhaleSound.SoundId = "rbxassetid://9113586144"
    exhaleSound.Volume = 1
    exhaleSound.Looped = false
    exhaleSound.Parent = character:WaitForChild("Head")
end

-- Hantera spelarens död och återskapa verktyget och rökpartiklar
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    -- Ta bort gamla objekt om de finns
    if smoke then
        smoke:Destroy()
    end
    if inhaleSound then
        inhaleSound:Destroy()
    end
    if exhaleSound then
        exhaleSound:Destroy()
    end

    -- Skapa nya objekt
    createSmokeEmitter()
    createSounds()

    -- Skapa verktyget om toggeln är aktiv
    if tool then
        createTool()
    end
end)

-- Toggle för att aktivera/deaktiviera verktyget
SectionDRUGS:Toggle({
    Title       = "Vape",
    Description = "You need to die once",
    Default     = false
}, function(value)
    if value then
        createTool()  -- Lägg till verktyget om toggeln är på
    else
        removeTool()  -- Ta bort verktyget om toggeln är av
    end
end)

local player = game.Players.LocalPlayer
local removedClothes = {}

-- Funktion för att ta bort kläder (Shirt och Pants)
local function removeClothes(character)
    -- Ta bort alla Shirt och Pants
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") then
            table.insert(removedClothes, item) -- Spara borttagna kläder
            item:Destroy() -- Ta bort klädesplaggen
        end
    end
end

-- Funktion för att återställa kläder
local function restoreClothes(character)
    for _, item in ipairs(removedClothes) do
        -- Återställ klädesplagg som togs bort (om det är en Shirt eller Pants)
        if item:IsA("Shirt") then
            local newShirt = Instance.new("Shirt")
            newShirt.ShirtTemplate = item.ShirtTemplate
            newShirt.Parent = character
        elseif item:IsA("Pants") then
            local newPants = Instance.new("Pants")
            newPants.PantsTemplate = item.PantsTemplate
            newPants.Parent = character
        end
    end
end

-- Funktion som körs när spelarens karaktär återuppstår
local function onCharacterAdded(character)
    -- Återställ kläder direkt om togglen är på
    if SectionDRUGS:Get() then
        removeClothes(character)  -- Om togglen är på när karaktären återuppstår, ta bort kläder direkt
    else
        restoreClothes(character)  -- Annars återställ kläder
    end
end

-- När karaktären ändras (spelarens död eller ny karaktär)
player.CharacterAdded:Connect(onCharacterAdded)

-- Toggle för att ta bort eller återställa kläder
SectionSEXUAL:Toggle({
    Title       = "Naked",
    Description = ":3",
    Default     = false
}, function(value)
    if player.Character then
        if value then
            removeClothes(player.Character) -- Ta bort kläder om togglen är på
        else
            restoreClothes(player.Character) -- Återställ kläder om togglen är av
        end
    end
end)





local SectionWalking = SubButton1:Section("Walking", "Left")
local SectionJumping = SubButton1:Section("Jumping", "Right")
local SectionBody    = SubButton1:Section("Body", "Left")
local SectionCamMove = SubButton1:Section("Camera", "Left")
local SectionGravity = SubButton1:Section("Gravity", "Right")

local SectionHealthCS = SubButton1:Section("Health", "Right")


local SectionFlying    = SubButton3:Section("Flying", "Left")
local SectionSpinB     = SubButton3:Section("Spin Bot", "Right")
local SectionClipping  = SubButton3:Section("Clipping", "Right")
local SectionTP        = SubButton3:Section("Teleporting", "Right")
local SectionFun       = SubButton3:Section("Fun", "Left")
local SectionChatSpam  = SubButton3:Section("Chat Spammer", "Left")
local SectionSlingshot = SubButton3:Section("Slingshot", "Right")


local SectionCamLock = SubButton2:Section("COMING SOON", "Left")

local pigvicval = ""

local SectionIMPPLAYER = SubButton6:Section("Player", "Left")


local SectionLooking = SubButton11:Section("Looking", "Left")

SectionLooking:Toggle({
    Title       = "Spectate",
    Description = "Spectate them",
    Default     = false
}, function(state)
    -- Kontrollera att pigvicval är en giltig sträng
    if not pigvicval or typeof(pigvicval) ~= "string" or pigvicval == "" then
        warn("Invalid or empty input for pigvicval.")
        return
    end

    -- Hitta spelaren baserat på del av namnet
    local playerToSpectate = nil
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name and string.find(string.lower(player.Name), string.lower(pigvicval)) then
            playerToSpectate = player
            break
        end
    end

    -- Kontrollera om spelaren hittades
    if playerToSpectate then
        local character = playerToSpectate.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                local currentCamera = workspace.CurrentCamera

                if state then
                    -- Spectate spelaren
                    currentCamera.CameraSubject = humanoid
                    currentCamera.CameraType = Enum.CameraType.Custom
                    print("Spectating " .. playerToSpectate.Name)
                else
                    -- Återställ kameran till LocalPlayer
                    local localPlayer = game.Players.LocalPlayer
                    if localPlayer and localPlayer.Character then
                        local localPlayerHumanoid = localPlayer.Character:FindFirstChild("Humanoid")
                        if localPlayerHumanoid then
                            currentCamera.CameraSubject = localPlayerHumanoid
                            currentCamera.CameraType = Enum.CameraType.Custom
                            print("Stopped spectating.")
                        else
                            warn("LocalPlayer's humanoid not found!")
                        end
                    else
                        warn("LocalPlayer's character not found!")
                    end
                end
            else
                warn("No humanoid found for player: " .. playerToSpectate.Name)
            end
        else
            warn("No character found for player: " .. playerToSpectate.Name)
        end
    else
        warn("No player found with partial name: " .. pigvicval)
    end
end)




SectionMISC:Button({
    Title       = "Radar",
    ButtonName  = "Radar",
    Description = "Remove with END",
    }, function(value)
    --- Drawing Player Radar
--- Made by topit

_G.RadarSettings = {
    --- Radar settings
    RADAR_LINES = true; -- Displays distance rings + cardinal lines 
    RADAR_LINE_DISTANCE = 50; -- The distance between each distance ring
    RADAR_SCALE = 1; -- Controls how "zoomed in" the radar display is 
    RADAR_RADIUS = 125; -- The size of the radar itself
    RADAR_ROTATION = true; -- Toggles radar rotation. Looks kinda trippy when disabled
    SMOOTH_ROT = true; -- Toggles smooth radar rotation
    SMOOTH_ROT_AMNT = 30; -- Lower number is smoother, higher number is snappier 
    CARDINAL_DISPLAY = true; -- Displays the four cardinal directions (north east south west) around the radar
    
    --- Marker settings
    DISPLAY_OFFSCREEN = true; -- Displays offscreen / off-radar markers
    DISPLAY_TEAMMATES = true; -- Displays markers that belong to your teammates
    DISPLAY_TEAM_COLORS = true; -- Displays your teammates markers with either a custom color (change Team_Marker) or with that teams TeamColor (enable USE_TEAM_COLORS) 
    DISPLAY_FRIEND_COLORS = true; -- Displays your friends markers with a custom color (Friend_Marker). This takes priority over DISPLAY_TEAM_COLORS and DISPLAY_RGB
    DISPLAY_RGB_COLORS = false; -- Displays each marker with an RGB cycle. Takes priority over DISPLAY_TEAM_COLORS, but not DISPLAY_FRIEND_COLORS
    MARKER_SCALE_BASE = 1.25; -- Base scale that gets applied to markers
    MARKER_SCALE_MAX = 1.25; -- The largest scale that a marker can be
    MARKER_SCALE_MIN = 0.75; -- The smallest scale that a marker can be
    MARKER_FALLOFF = true; -- Affects the markers' scale depending on how far away the player is - bypasses SCALE_MIN and SCALE_MAX
    MARKER_FALLOFF_AMNT = 125; -- How close someone has to be for falloff to start affecting them 
    OFFSCREEN_TRANSPARENCY = 0.3; -- Transparency of offscreen markers
    USE_FALLBACK = false; -- Enables an emergency "fallback mode" for StreamingEnabled games
    USE_QUADS = true; -- Displays radar markers as arrows instead of dots 
    USE_TEAM_COLORS = false; -- Uses a team's TeamColor for marker colors
    VISIBLITY_CHECK = false; -- Makes markers that are not visible slightly transparent 
    
    --- Theme
    RADAR_THEME = {
        Outline = Color3.fromRGB(35, 35, 45); -- Radar outline
        Background = Color3.fromRGB(25, 25, 35); -- Radar background
        DragHandle = Color3.fromRGB(50, 50, 255); -- Drag handle 
        
        Cardinal_Lines = Color3.fromRGB(110, 110, 120); -- Color of the horizontal and vertical lines
        Distance_Lines = Color3.fromRGB(65, 65, 75); -- Color of the distance rings
        
        Generic_Marker = Color3.fromRGB(255, 25, 115); -- Color of a player marker without a team
        Local_Marker = Color3.fromRGB(115, 25, 255); -- Color of your marker, regardless of team
        Team_Marker = Color3.fromRGB(25, 115, 255); -- Color of your teammates markers. Used when DISPLAY_TEAM_COLORS is disabled
        Friend_Marker = Color3.fromRGB(25, 255, 115); -- Color of your friends markers. Used when DISPLAY_FRIEND_COLORS is enabled 
    };
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/stuff/main/PlayerRadar/source.lua'))()
end)






-- Textbox för att skriva spelarens partiala namn
SectionIMPPLAYER:Textbox({
    Title       = "Player User",
    Description = "Can be partial",
    Default     = "",
}, function(value)
    local playerNameInput = value -- Uppdatera den skrivna texten i textboxen
    pigvicval             = value
    -- Kolla om vi hittar en spelare baserat på partialt namn
    local foundPlayer = nil
    for _, player in pairs(game.Players:GetPlayers()) do
        if string.lower(player.Name):find(string.lower(playerNameInput)) then
            foundPlayer = player
            break -- Stoppa när vi hittar den första matchen
        end
    end

    -- Om en spelare hittas, skapa en Roblox notifiering
    if foundPlayer then
        -- Skapa en notifiering med spelarens användarnamn och DisplayName
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Player Found!",
            Text = "Username: " .. foundPlayer.Name .. "\nDisplay Name: " .. (foundPlayer.DisplayName or "None") .. "\nStatus: " .. (foundPlayer.Character and "In Game" or "Offline"),
            Icon = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. foundPlayer.UserId .. "&width=150&height=150&format=png",  -- Spelarens avatar
            Duration = 5  -- Längd på notifikationen
        })
    else
        -- Om ingen spelare hittas, visa en standardnotis
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Player Not Found",
            Text = "No player found with that name.",
            Duration = 3  -- Längd på notifikationen
        })
    end
end)


local SectionTELEPORT = SubButton7:Section("Teleport", "Left")

SectionTELEPORT:Button({
    Title       = "Teleport",
    ButtonName  = "Teleport",
    Description = "Teleport to player",
    }, function(value)
    local partialUsername = pigvicval

-- Get the local player
local player = game.Players.LocalPlayer

-- Wait for the character to load
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Function to teleport to the target player's position
local function teleportToPlayer(partialName)
    -- Find the target player with the partial username
    local targetPlayer = nil
    for _, p in pairs(game.Players:GetPlayers()) do
        if string.sub(p.Name, 1, string.len(partialName)):lower() == partialName:lower() then
            targetPlayer = p
            break
        end
    end
    
    if targetPlayer then
        -- Get the target player's character and HumanoidRootPart
        local targetCharacter = targetPlayer.Character
        if targetCharacter then
            local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
            if targetHumanoidRootPart then
                -- Teleport the local player to the target player's position
                humanoidRootPart.CFrame = targetHumanoidRootPart.CFrame
                print("Teleported to " .. targetPlayer.Name)
            else
                print(targetPlayer.Name .. " does not have a HumanoidRootPart.")
            end
        else
            print(targetPlayer.Name .. " does not have a character.")
        end
    else
        print("Player with partial username '" .. partialName .. "' not found.")
    end
end

-- Call the function to teleport
teleportToPlayer(partialUsername)
end)


SectionTELEPORT:Button({
    Title       = "Sneak Teleport",
    ButtonName  = "Teleport",
    Description = "Teleport 10 studs behind",
    }, function(value)
    local partialUsername = pigvicval

-- Get the local player
local player = game.Players.LocalPlayer

-- Wait for the character to load
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Function to teleport to the target player's position
local function teleportToPlayer(partialName)
    -- Find the target player with the partial username
    local targetPlayer = nil
    for _, p in pairs(game.Players:GetPlayers()) do
        if string.sub(p.Name, 1, string.len(partialName)):lower() == partialName:lower() then
            targetPlayer = p
            break
        end
    end
    
    if targetPlayer then
        -- Get the target player's character and HumanoidRootPart
        local targetCharacter = targetPlayer.Character
        if targetCharacter then
            local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
            if targetHumanoidRootPart then
                -- Calculate the position 10 meters behind the target player
                local behindPosition = targetHumanoidRootPart.CFrame * CFrame.new(0, 0, 50)
                -- Teleport the local player to the calculated position
                humanoidRootPart.CFrame = CFrame.new(behindPosition.Position)
                print("Teleported to 10 meters behind " .. targetPlayer.Name)
            else
                print(targetPlayer.Name .. " does not have a HumanoidRootPart.")
            end
        else
            print(targetPlayer.Name .. " does not have a character.")
        end
    else
        print("Player with partial username '" .. partialName .. "' not found.")
    end
end

-- Call the function to teleport
teleportToPlayer(partialUsername)
end)


local SectionPFUN = SubButton7:Section("Fun", "Right")

SectionPFUN:Toggle({
    Title       = "Piggy Back",
    Description = "",
    Default     = false
    }, function(state)
    if (state) == true then
        game.Players.LocalPlayer.Character.Humanoid.Sit = true
-- Execute this in your executor to start following
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local targetPlayerPartialName = pigvicval  -- Replace with the partial name of the player to follow
local followDistance = 2  -- Distance above the target player
local behindDistance = 1.5  -- Distance behind the target player

-- Function to find target player by partial name
local function findTargetPlayer(partialName)
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if string.match(string.lower(targetPlayer.Name), string.lower(partialName)) then
            return targetPlayer
        end
    end
    return nil
end

-- Create variables to hold BodyPosition and BodyGyro instances
local bodyPosition
local bodyGyro

local function followTarget()
    local targetPlayer = findTargetPlayer(targetPlayerPartialName)
    if targetPlayer then
        local targetCharacter = targetPlayer.Character
        if targetCharacter then
            local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local character = player.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        -- Create or update BodyPosition and BodyGyro
                        if not bodyPosition then
                            bodyPosition = rootPart:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition", rootPart)
                            bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                            bodyPosition.P = 20000  -- Increase proportional gain for faster response
                            bodyPosition.D = 1000   -- Increase derivative gain for smoother response
                        end
                        if not bodyGyro then
                            bodyGyro = rootPart:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro", rootPart)
                            bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
                            bodyGyro.P = 20000      -- Increase proportional gain for faster response
                            bodyGyro.D = 1000       -- Increase derivative gain for smoother response
                        end

                        -- Calculate target position and orientation
                        local targetPosition = targetRoot.Position + targetRoot.CFrame.LookVector * -behindDistance + Vector3.new(0, followDistance, 0)
                        local targetOrientation = CFrame.new(targetRoot.Position, targetRoot.Position + targetRoot.CFrame.LookVector)

                        -- Update BodyPosition and BodyGyro
                        bodyPosition.Position = targetPosition
                        bodyGyro.CFrame = targetOrientation
                    end
                end
            end
        end
    end
end

-- Connect the followTarget function to RenderStepped
local followConnection
followConnection = RunService.RenderStepped:Connect(followTarget)

-- Store the connection in a global variable to access it in the stop script
getgenv().followConnection = followConnection



        
        else
game.Players.LocalPlayer.Character.Humanoid.Sit = false
-- Execute this in your executor to stop following
local RunService = game:GetService("RunService")

local function stopFollowing()
    -- Access the stored connection and disconnect it
    if getgenv().followConnection then
        getgenv().followConnection:Disconnect()
        getgenv().followConnection = nil
    end

    -- Remove BodyPosition and BodyGyro to reset character physics
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local bodyPosition = rootPart:FindFirstChild("BodyPosition")
            local bodyGyro = rootPart:FindFirstChild("BodyGyro")
            if bodyPosition then bodyPosition:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end
    end
end

stopFollowing()




        end
end)

local orbrad = 5

SectionPFUN:Toggle({
    Title       = "Orbit",
    Description = "",
    Default     = false
    }, function(state)
    if (state) == true then
-- Execute this in your executor to start orbiting around the player
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local targetPlayerPartialName = pigvicval  -- Replace with the partial name of the player to orbit around
local orbitRadius = orbrad  -- Radius of the orbit circle
local orbitHeight = 3  -- Height above the target player

-- Function to find target player by partial name
local function findTargetPlayer(partialName)
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if string.match(string.lower(targetPlayer.Name), string.lower(partialName)) then
            return targetPlayer
        end
    end
    return nil
end

-- Create variables to hold BodyPosition and BodyGyro instances
local bodyPosition
local bodyGyro

local function orbitTarget()
    local targetPlayer = findTargetPlayer(targetPlayerPartialName)
    if targetPlayer then
        local targetCharacter = targetPlayer.Character
        if targetCharacter then
            local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local character = player.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        -- Create or update BodyPosition and BodyGyro
                        orbitRadius = orbrad
                        if not bodyPosition then
                            bodyPosition = rootPart:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition", rootPart)
                            bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                            bodyPosition.P = 20000  -- Increase proportional gain for faster response
                            bodyPosition.D = 1000   -- Increase derivative gain for smoother response
                        end
                        if not bodyGyro then
                            bodyGyro = rootPart:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro", rootPart)
                            bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
                            bodyGyro.P = 20000      -- Increase proportional gain for faster response
                            bodyGyro.D = 1000       -- Increase derivative gain for smoother response
                        end

                        -- Calculate orbit position relative to the target
                        local offset = Vector3.new(math.cos(tick() * 2) * orbitRadius, orbitHeight, math.sin(tick() * 2) * orbitRadius)
                        local targetPosition = targetRoot.Position + offset

                        -- Update BodyPosition and BodyGyro
                        orbitRadius = orbrad
                        bodyPosition.Position = targetPosition
                        bodyGyro.CFrame = CFrame.lookAt(targetPosition, targetRoot.Position)
                    end
                end
            end
        end
    end
end

-- Connect the orbitTarget function to RenderStepped
local orbitConnection
orbitConnection = RunService.RenderStepped:Connect(orbitTarget)

-- Store the connection in a global variable to access it in the stop script
getgenv().orbitConnection = orbitConnection

        else
-- Execute this in your executor to stop following
local RunService = game:GetService("RunService")

local function stopFollowing()
    -- Access the stored connection and disconnect it
    if getgenv().followConnection then
        getgenv().followConnection:Disconnect()
        getgenv().followConnection = nil
    end

    -- Remove BodyPosition and BodyGyro to reset character physics
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local bodyPosition = rootPart:FindFirstChild("BodyPosition")
            local bodyGyro = rootPart:FindFirstChild("BodyGyro")
            if bodyPosition then bodyPosition:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end
    end
end

stopFollowing()
        end
end)

SectionPFUN:Slider({
    Title       = "Radius",
    Description = "Orbit radius",
    Default     = 1,
    Min         = 1,
    Max         = 50
    }, function(Value)
    orbrad = (Value)
end)


local SectionSEX = SubButton7:Section("Sex", "Left")


local moveSpeed = 1 -- Hur snabbt du rör dig fram och tillbaka
local distanceBehind = 5 -- Max avstånd bakom målet

SectionSEX:Toggle({
    Title       = "Rape",
    Description = "",
    Default     = false
}, function(state)
    if state then
        -- Start back and forth movement
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local targetPlayerPartialName = pigvicval -- Replace with the partial name of the target player

        -- Function to find target player by partial name
        local function findTargetPlayer(partialName)
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                if string.match(string.lower(targetPlayer.Name), string.lower(partialName)) then
                    return targetPlayer
                end
            end
            return nil
        end

        -- Create variables to hold BodyPosition and BodyGyro instances
        local bodyPosition
        local bodyGyro

        -- Movement cycle control
        local movingBack = true -- Om vi rör oss bakåt
        local targetDistance = 0 -- Håller reda på avståndet vi rör oss ifrån målet

        -- Function to move back and forth
        local function moveBackAndForth()
            local targetPlayer = findTargetPlayer(targetPlayerPartialName)
            if targetPlayer then
                local targetCharacter = targetPlayer.Character
                if targetCharacter then
                    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local character = player.Character
                        if character then
                            local rootPart = character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                -- Create or update BodyPosition and BodyGyro
                                if not bodyPosition then
                                    bodyPosition = rootPart:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition", rootPart)
                                    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                                    bodyPosition.P = 20000 -- Faster response
                                    bodyPosition.D = 1000  -- Smoother movement
                                end
                                if not bodyGyro then
                                    bodyGyro = rootPart:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro", rootPart)
                                    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
                                    bodyGyro.P = 20000 -- Faster response
                                    bodyGyro.D = 1000  -- Smoother rotation
                                end

                                -- Calculate movement
                                local delta = moveSpeed / 60 -- Adjust movement based on frame rate
                                local targetLookVector = targetRoot.CFrame.LookVector
                                local targetPosition

                                if movingBack then
                                    -- Moving away from the target
                                    targetDistance = targetDistance + delta
                                    if targetDistance >= distanceBehind then
                                        targetDistance = distanceBehind
                                        movingBack = false -- Start moving forward
                                    end
                                else
                                    -- Moving toward the target
                                    targetDistance = targetDistance - delta
                                    if targetDistance <= 0 then
                                        targetDistance = 0
                                        movingBack = true -- Start moving back again
                                    end
                                end

                                -- Calculate the new position
                                targetPosition = targetRoot.Position - (targetLookVector * targetDistance)

                                -- Update BodyPosition and BodyGyro
                                bodyPosition.Position = targetPosition
                                bodyGyro.CFrame = CFrame.new(rootPart.Position, targetRoot.Position)
                            end
                        end
                    end
                end
            end
        end

        -- Connect the function to RenderStepped
        local moveConnection
        moveConnection = RunService.RenderStepped:Connect(moveBackAndForth)

        -- Store the connection globally to stop it later
        getgenv().moveConnection = moveConnection
    else
        -- Stop movement
        local function stopMoving()
            -- Access the stored connection and disconnect it
            if getgenv().moveConnection then
                getgenv().moveConnection:Disconnect()
                getgenv().moveConnection = nil
            end

            -- Remove BodyPosition and BodyGyro to reset character physics
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local bodyPosition = rootPart:FindFirstChild("BodyPosition")
                    local bodyGyro = rootPart:FindFirstChild("BodyGyro")
                    if bodyPosition then bodyPosition:Destroy() end
                    if bodyGyro then bodyGyro:Destroy() end
                end
            end
        end

        stopMoving()
    end
end)









SectionSEX:Toggle({
    Title       = "Get Raped",
    Description = "",
    Default     = false
}, function(state)
    if state then
        -- Start moving in front and sitting
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local targetPlayerPartialName = pigvicval -- Replace with the partial name of the target player

        -- Function to find target player by partial name
        local function findTargetPlayer(partialName)
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                if string.match(string.lower(targetPlayer.Name), string.lower(partialName)) then
                    return targetPlayer
                end
            end
            return nil
        end

        -- Create variables to hold BodyPosition and BodyGyro instances
        local bodyPosition
        local bodyGyro

        -- Movement cycle control
        local movingForward = true -- Om vi rör oss framåt
        local targetDistance = 0 -- Håller reda på avståndet vi rör oss ifrån målet

        -- Function to move in front of the target and sit while being rotated forward
        local function moveInFrontAndSit()
            local targetPlayer = findTargetPlayer(targetPlayerPartialName)
            if targetPlayer then
                local targetCharacter = targetPlayer.Character
                if targetCharacter then
                    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local character = player.Character
                        if character then
                            local rootPart = character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                -- Create or update BodyPosition and BodyGyro
                                if not bodyPosition then
                                    bodyPosition = rootPart:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition", rootPart)
                                    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                                    bodyPosition.P = 20000 -- Faster response
                                    bodyPosition.D = 1000  -- Smoother movement
                                end
                                if not bodyGyro then
                                    bodyGyro = rootPart:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro", rootPart)
                                    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
                                    bodyGyro.P = 20000 -- Faster response
                                    bodyGyro.D = 1000  -- Smoother rotation
                                end

                                -- Calculate movement
                                local delta = moveSpeed / 60 -- Adjust movement based on frame rate
                                local targetLookVector = targetRoot.CFrame.LookVector
                                local targetPosition

                                if movingForward then
                                    -- Moving towards the target (in front)
                                    targetDistance = targetDistance + delta
                                    if targetDistance >= distanceBehind then
                                        targetDistance = distanceBehind
                                        movingForward = false -- Start moving backward
                                    end
                                else
                                    -- Moving away from the target (moving back)
                                    targetDistance = targetDistance - delta
                                    if targetDistance <= 0 then
                                        targetDistance = 0
                                        movingForward = true -- Start moving forward again
                                    end
                                end

                                -- Calculate the new position (in front of the target)
                                targetPosition = targetRoot.Position + (targetLookVector * targetDistance)

                                -- Update BodyPosition and BodyGyro
                                bodyPosition.Position = targetPosition

                                -- Rotate the player to match the target's rotation and tilt 90 degrees forward
                                local targetRotation = targetRoot.CFrame - targetRoot.Position -- Get the rotation without position
                                local forwardRotation = targetRotation * CFrame.Angles(math.rad(-90), 0, 0) -- 90 degrees tilt forward

                                -- Update BodyGyro to match the target's rotation and tilt 90 degrees forward
                                bodyGyro.CFrame = forwardRotation

                                -- Make player sit while moving
                                local humanoid = character:FindFirstChildOfClass("Humanoid")
                                if humanoid and not humanoid.Sit then
                                    humanoid.Sit = true -- Sit down
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Connect the function to RenderStepped
        local moveConnection
        moveConnection = RunService.RenderStepped:Connect(moveInFrontAndSit)

        -- Store the connection globally to stop it later
        getgenv().moveConnection = moveConnection
    else
        -- Stop movement and sit
        local function stopMovingAndSit()
            -- Access the stored connection and disconnect it
            if getgenv().moveConnection then
                getgenv().moveConnection:Disconnect()
                getgenv().moveConnection = nil
            end

            -- Remove BodyPosition and BodyGyro to reset character physics
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local bodyPosition = rootPart:FindFirstChild("BodyPosition")
                    local bodyGyro = rootPart:FindFirstChild("BodyGyro")
                    if bodyPosition then bodyPosition:Destroy() end
                    if bodyGyro then bodyGyro:Destroy() end
                end

                -- Ensure player stands up when stopping
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Sit = false -- Stand up
                end
            end
        end

        stopMovingAndSit()
    end
end)

-- Slider for movement speed
SectionSEX:Slider({
    Title       = "Speed",
    Description = "Adjust speed",
    Default     = 10,
    Min         = 0.1,
    Max         = 50,
    Increment   = 0.1,
}, function(Value)
    moveSpeed = Value
end)

-- Slider for distance behind
SectionSEX:Slider({
    Title       = "Distance",
    Description = "Adjust how far behind",
    Default     = 5,
    Min         = 1,
    Max         = 20,
    Increment   = 1,
}, function(Value)
    distanceBehind = Value
end)

local SectionTRACKING = SubButton7:Section("Tracking", "Right")

SectionTRACKING:Toggle({
    Title       = "Copy Movement and Rotation",
    Description = "Copy both the rotation and movement of another player while staying in your position.",
    Default     = false
}, function(state)
    if state then
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local targetPlayerPartialName = pigvicval  -- Replace with the partial name of the target player
        
        -- Function to find the target player by partial name
        local function findTargetPlayer(partialName)
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                if string.match(string.lower(targetPlayer.Name), string.lower(partialName)) then
                    return targetPlayer
                end
            end
            return nil
        end
        
        local targetPlayer = findTargetPlayer(targetPlayerPartialName)
        
        if targetPlayer then
            local targetCharacter = targetPlayer.Character
            if targetCharacter then
                local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
                
                -- Variables to store the initial and previous CFrame
                local lastCFrame = targetHumanoidRootPart.CFrame
                local lastPosition = targetHumanoidRootPart.Position
                
                -- Function to copy movement and rotation
                local function copyMovementAndRotation()
                    if targetHumanoidRootPart then
                        -- Calculate the difference in position and rotation
                        local deltaCFrame = lastCFrame:inverse() * targetHumanoidRootPart.CFrame
                        local deltaPosition = targetHumanoidRootPart.Position - lastPosition
                        local deltaRotation = deltaCFrame - deltaCFrame.Position  -- Only rotation difference
                        
                        -- Apply the rotation and movement to your character's CFrame while keeping your position
                        local newCFrame = player.Character.HumanoidRootPart.CFrame * deltaRotation
                        player.Character:SetPrimaryPartCFrame(newCFrame + deltaPosition)
                        
                        -- Update lastCFrame and lastPosition for the next frame
                        lastCFrame = targetHumanoidRootPart.CFrame
                        lastPosition = targetHumanoidRootPart.Position
                    end
                end

                -- Connect to RenderStepped to continuously copy rotation and movement
                local trackingConnection
                trackingConnection = RunService.RenderStepped:Connect(copyMovementAndRotation)
                
                -- Store the connection globally to stop it later
                getgenv().trackingConnection = trackingConnection
            end
        end
    else
        -- Stop tracking and remove connection
        if getgenv().trackingConnection then
            getgenv().trackingConnection:Disconnect()
            getgenv().trackingConnection = nil
        end
    end
end)






















local defaultWalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
local defaultJumpPower = game.Players.LocalPlayer.Character.Humanoid.JumpPower

SectionWalking:Slider({
    Title       = "Walkspeed",
    Description = "",
    Default     = defaultWalkSpeed,
    Min         = 0,
    Max         = 500
    }, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)







SectionWalking:Button({
    Title       = "Reset",
    ButtonName  = "Reset",
    Description = "Reset jump power",
    }, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = defaultWalkSpeed
end)


SectionJumping:Toggle({
    Title       = "Infinite Jump",
    Description = "",
    Default     = false
    }, function(state)
    if (state) == true then
-- Infinite Jump Enable Script
_G.InfiniteJumpEnabled = true

-- Function to handle jumping
local function onJumpRequest()
    if _G.InfiniteJumpEnabled then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end

-- Bind the function to the JumpRequest event
if not _G.JumpConnection then
    _G.JumpConnection = game:GetService("UserInputService").JumpRequest:Connect(onJumpRequest)
end

print("Infinite Jump Enabled")

        else
-- Infinite Jump Disable Script
_G.InfiniteJumpEnabled = false

-- Unbind the JumpRequest event if it exists
if _G.JumpConnection then
    _G.JumpConnection:Disconnect()
    _G.JumpConnection = nil
end

print("Infinite Jump Disabled")

    end
end)


SectionJumping:Slider({
    Title       = "JumpPower",
    Description = "",
    Default     = defaultJumpPower,
    Min         = 0,
    Max         = 500
    }, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)



SectionBody:Toggle({
    Title       = "Freeze",
    Description = "Anchor yourself",
    Default     = false
}, function(state)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if state then
            -- Anchora spelarens karaktär
            player.Character.HumanoidRootPart.Anchored = true
        else
            -- Släpp ankaret
            player.Character.HumanoidRootPart.Anchored = false
        end
    end
end)

local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local camera = game.Workspace.CurrentCamera

-- Variabler för Free Cam
local isFreeCamEnabled = false
local moveSpeed = 10
local rotationSpeed = 0.05
local cameraPosition = camera.CFrame.Position
local cameraRotation = CFrame.new()
local isHoldingRMB = false

-- För att inaktivera spelarens rörelse
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local canMovePlayer = true
local canMoveCamera = true

-- Free Cam Toggle
SectionCamMove:Toggle({
    Title       = "Free Cam",
    Description = "Move your camera freely",
    Default     = false,
}, function(state)
    isFreeCamEnabled = state

    if state then
        -- Aktivera Free Cam
        cameraPosition = camera.CFrame.Position
        cameraRotation = CFrame.new(Vector3.new(), camera.CFrame.LookVector)
        -- Om Free Cam är på, inaktivera spelarens rörelse om Player Movement är avstängt
        if canMovePlayer then
            if humanoid then humanoid.WalkSpeed = 0 humanoid.JumpPower = 0 end
        end
        runService:BindToRenderStep("FreeCam", Enum.RenderPriority.Camera.Value, updateFreeCam)
    else
        -- Inaktivera Free Cam
        runService:UnbindFromRenderStep("FreeCam")
        -- Om Free Cam är avstängt, aktivera spelarens rörelse igen
        if humanoid then humanoid.WalkSpeed = 16 humanoid.JumpPower = 50 end
    end
end)

-- Player Movement Toggle
SectionCamMove:Toggle({
    Title       = "Player Movement",
    Description = "Enable/Disable player movement (Only when Free Cam is on)",
    Default     = true,
}, function(state)
    canMovePlayer = state
    if state and isFreeCamEnabled then
        -- Återaktivera spelarens rörelse om Free Cam är på
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    elseif not state and isFreeCamEnabled then
        -- Inaktivera spelarens rörelse om Free Cam är på och toggeln är avstängd
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
    end
end)

-- Camera Movement Toggle
SectionCamMove:Toggle({
    Title       = "Camera Movement",
    Description = "Enable/Disable camera movement",
    Default     = true,
}, function(state)
    canMoveCamera = state
end)

-- Sensitivity Slider
SectionCamMove:Slider({
    Title       = "Sensitivity",
    Description = "Adjust mouse sensitivity",
    Default     = 0.005,
    Min         = 0.005,
    Max         = 0.1,
}, function(value)
    rotationSpeed = value
end)

-- Speed Slider
SectionCamMove:Slider({
    Title       = "Speed",
    Description = "Adjust movement speed",
    Default     = 40,
    Min         = 1,
    Max         = 200,
}, function(value)
    moveSpeed = value
end)

-- Lyssna efter höger musknapp
userInput.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isHoldingRMB = true
        userInput.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition -- Lås musen när RMB hålls nere
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isHoldingRMB = false
        userInput.MouseBehavior = Enum.MouseBehavior.Default -- Släpp musen när RMB släpps
    end
end)

-- Uppdatera Free Cam position och rotation
function updateFreeCam(delta)
    local moveDirection = Vector3.new(0, 0, 0)

    -- Kamerarörelse med tangentbord (om kamerarörelse är aktiverad och Free Cam är påslagen)
    if canMoveCamera and isFreeCamEnabled then
        if userInput:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + cameraRotation.LookVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - cameraRotation.LookVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - cameraRotation.RightVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + cameraRotation.RightVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end

        -- Normalisera och justera hastighet
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * moveSpeed * delta
        end

        -- Uppdatera kamerans position
        cameraPosition = cameraPosition + moveDirection
    end

    -- Kamerarotation med musen (endast när RMB hålls och kamera rotation är aktiverad)
    if isHoldingRMB and canMoveCamera then
        local mouseDelta = userInput:GetMouseDelta()
        local yawRotation = CFrame.Angles(0, -mouseDelta.X * rotationSpeed, 0)
        local pitchRotation = CFrame.Angles(-mouseDelta.Y * rotationSpeed, 0, 0)
        cameraRotation = yawRotation * cameraRotation * pitchRotation

        -- Begränsa rotation för att förhindra "roll"
        local lookVector = cameraRotation.LookVector
        cameraRotation = CFrame.new(Vector3.new(), Vector3.new(lookVector.X, lookVector.Y, lookVector.Z))
    end

    -- Ställ in kamerans nya CFrame
    camera.CFrame = CFrame.new(cameraPosition) * cameraRotation
end

-- Gravity slider
SectionGravity:Slider({
    Title       = "Gravity",
    Description = "Adjust game gravity",
    Default     = 196.2, -- Standardvärde
    Min         = 0, -- Minsta värde för gravitation
    Max         = 500, -- Största värde för gravitation
}, function(value)
    -- Uppdatera gravitationen baserat på slider-värdet
    workspace.Gravity = value
end)

-- Reset gravity button
SectionGravity:Button({
    Title       = "Reset",
    ButtonName  = "Reset",
    Description = "Reset gravity",
}, function()
    -- Sätter tillbaka gravitationen till standardvärdet 196.2
    workspace.Gravity = 196.2
end)











SectionJumping:Button({
    Title       = "Reset",
    ButtonName  = "Reset",
    Description = "Reset jump power",
    }, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = defaultJumpPower
end)

local BunnyHopEnabled = false -- Globala variabeln
local BunnyHopFrequency = 0.1 -- Standard frekvens för hoppning

-- Slidern för att justera hoppfrekvensen
SectionJumping:Slider({
    Title       = "Bhop Freq",
    Description = "Bunny hop delay",
    Default     = 0.1, -- Standardvärde
    Min         = 0.01, -- Minsta värde (frekvensen kan vara högre, så vi minskar väntetiden)
    Max         = 3, -- Största värde
}, function(value)
    BunnyHopFrequency = value -- Uppdaterar BunnyHopFrequency när användaren ändrar på slidern
end)

SectionJumping:Toggle({
    Title = "Bunny Hop",
    Description = "Automatically spams jump",
    Default = false
}, function(value)
    BunnyHopEnabled = value -- Uppdaterar variabeln för togglen

    if BunnyHopEnabled then
        -- Skapa en separat funktion för att hantera hoppningen
        spawn(function()
            while BunnyHopEnabled do
                -- Kontrollera om spelaren är i spelet och om karaktären finns
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character:FindFirstChild("Humanoid")

                    -- Om spelaren inte är i luften, hoppa
                    if humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and 
                       humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end

                -- Vänta enligt den inställda frekvensen innan nästa hopp
                wait(BunnyHopFrequency) -- Använd den justerbara frekvensen
            end
        end)
    end
end)




SectionHealthCS:Slider({
    Title       = "Health",
    Description = "Client Sided",
    Default     = 100,
    Min         = 0,
    Max         = 100
    }, function(value)
    game.Players.LocalPlayer.Character.Humanoid.Health = value
end)

SectionHealthCS:Button({
    Title       = "Force Die",
    ButtonName  = "Reset",
    Description = "",
    }, function(value)
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)



local flyspeeed = 20


SectionFlying:Toggle({
    Title       = "Flight",
    Description = "",
    Default     = false
    }, function(state)
   if (state) == true then
-- Fly Script with Camera-Aligned Movement and Stable Orientation
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local torso = character:WaitForChild("HumanoidRootPart")
local flying = false
local speed = flyspeeed
local camera = game.Workspace.CurrentCamera
local keysPressed = {}

local function startFlying()
    local bg = Instance.new("BodyGyro", torso)
    bg.MaxTorque = Vector3.new(4000, 4000, 4000)
    bg.P = 20000 -- Proportional gain to stabilize orientation
    
    local bv = Instance.new("BodyVelocity", torso)
    bv.MaxForce = Vector3.new(4000, 4000, 4000)
    bv.Velocity = Vector3.new(0, 0, 0)
    
    flying = true
    humanoid.PlatformStand = true
    
    local function updateVelocity()
    speed = flyspeeed
        local moveDirection = Vector3.new(0, 0, 0)
        local forwardDirection = camera.CFrame.lookVector
        local rightDirection = camera.CFrame.rightVector
        
        if keysPressed["W"] then
            moveDirection = forwardDirection
        elseif keysPressed["S"] then
            moveDirection = -forwardDirection
        end
        
        if keysPressed["A"] then
            moveDirection = moveDirection - rightDirection
        elseif keysPressed["D"] then
            moveDirection = moveDirection + rightDirection
        end
        
        moveDirection = moveDirection.unit * speed
        bv.Velocity = moveDirection
        
        -- Update BodyGyro to stabilize orientation
        bg.CFrame = CFrame.new(torso.Position, torso.Position + forwardDirection)
    end
    
    local function updateFlight()
    speed = flyspeeed
        while flying do
            if keysPressed["W"] or keysPressed["S"] or keysPressed["A"] or keysPressed["D"] then
                updateVelocity()
            else
                bv.Velocity = Vector3.new(0, 0, 0) -- Constant upward velocity when no movement keys are pressed
            end
            wait()
        end
        
        bv:Destroy()
        bg:Destroy()
        humanoid.PlatformStand = false
    end
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keysPressed[input.KeyCode.Name] = true
            updateVelocity()
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keysPressed[input.KeyCode.Name] = nil
            updateVelocity()
        end
    end)
    
    updateFlight()
end

startFlying()




        else
-- Unfly Script
local player = game.Players.LocalPlayer
local character = player.Character

if character then
    local torso = character:FindFirstChild("HumanoidRootPart")
    if torso then
        for _, instance in ipairs(torso:GetChildren()) do
            if instance:IsA("BodyVelocity") or instance:IsA("BodyGyro") then
                instance:Destroy()
            end
        end
        player.Character.Humanoid.PlatformStand = false
    end
end





        end
end)


SectionFlying:Slider({
    Title       = "Speed",
    Description = "Fly Speed",
    Default     = 20,
    Min         = 0,
    Max         = 150
    }, function(wsValue)
    flyspeeed = (wsValue)
end)


local spinEnabled = false
local spinPower = 100  -- Default power for spin
local bodyThrust = nil
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

SectionSpinB:Toggle({
    Title       = "Spin Bot",
    Description = "",
    Default     = false
    }, function(state)
    
    local character = player.Character or player.CharacterAdded:Wait()
   spinEnabled = state

        -- If spin is enabled, add BodyThrust to the HumanoidRootPart
        if spinEnabled then
            if character and character:FindFirstChild("HumanoidRootPart") then
                -- Ensure there is no existing BodyThrust
                if not character.HumanoidRootPart:FindFirstChild("BodyThrust") then
                    bodyThrust = Instance.new("BodyThrust")
                    bodyThrust.Parent = character.HumanoidRootPart
                    bodyThrust.Force = Vector3.new(spinPower, 0, spinPower)
                    bodyThrust.Location = character.HumanoidRootPart.Position
                end
            end
        else
            -- If spin is disabled, remove the BodyThrust
            if bodyThrust then
                bodyThrust:Destroy()
                bodyThrust = nil
            end
        end
end)


SectionSpinB:Slider({
    Title       = "Speed",
    Description = "Rotation Speed",
    Default     = 20,
    Min         = 10,
    Max         = 1500
    }, function(value)
    spinPower = value
        -- Update BodyThrust's Force dynamically if it's active
        if bodyThrust then
            bodyThrust.Force = Vector3.new(spinPower, 0, spinPower)
        end
end)
    
    
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local teleportEnabled = false
    

SectionTP:Toggle({
    Title       = "Click TP",
    Description = "",
    Default     = false
    }, function(value)
    teleportEnabled = value
end)

mouse.Button1Down:Connect(function()
    if teleportEnabled then
        -- Get the mouse hit position and teleport the HumanoidRootPart
        local mouseHit = mouse.Hit.p
        humanoidRootPart.CFrame = CFrame.new(mouseHit + Vector3.new(0, 3, 0))  -- Teleport slightly above ground
    end
end)

local noclipEnabled = false
local player = game.Players.LocalPlayer


SectionClipping:Toggle({
    Title       = "Noclip",
    Description = "",
    Default     = false
    }, function(value)
    
    local character = player.Character or player.CharacterAdded:Wait()
    noclipEnabled = value
end)

game:GetService('RunService').Stepped:Connect(function()
    if noclipEnabled and character then
        character.Head.CanCollide = false
        character.UpperTorso.CanCollide = false
        character.LowerTorso.CanCollide = false
        character.HumanoidRootPart.CanCollide = false
    elseif not noclipEnabled and character then
        -- If noclip is off, enable collisions again
        character.Head.CanCollide = true
        character.UpperTorso.CanCollide = true
        character.LowerTorso.CanCollide = true
        character.HumanoidRootPart.CanCollide = true
    end
end)

local swimming = false
local oldgrav = workspace.Gravity
local swimbeat = nil
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local swimSpeed = 50  -- Default swim speed


SectionFun:Slider({
    Title       = "Swim Speed",
    Description = "",
    Default     = 50,
    Min         = 10,
    Max         = 200
    }, function(value)
    swimSpeed = value
end)

SectionFun:Toggle({
    Title       = "Swim",
    Description = "",
    Default     = false
    }, function(boolean)
    if boolean then
            -- Start simning
            if not swimming and player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") then
                oldgrav = workspace.Gravity
                workspace.Gravity = 0  -- Sätt gravitationen till 0 för att simma i luften

                local swimDied = function()
                    workspace.Gravity = oldgrav
                    swimming = false
                end

                local Humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                local gravReset = Humanoid.Died:Connect(swimDied)

                -- Förhindra spelaren från att använda andra humanoidstatyer under simning
                local enums = Enum.HumanoidStateType:GetEnumItems()
                table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
                for i, v in pairs(enums) do
                    Humanoid:SetStateEnabled(v, false)
                end

                -- Sätt humanoiden i simningstillstånd
                Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)

                -- Starta simningens "heartbeat" för att hantera spelarens rörelse
                swimbeat = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local humanoidRootPart = player.Character.HumanoidRootPart
                        local moveDirection = Vector3.new(0, 0, 0)

                        -- Om spelaren trycker på tangentbordstangenter (WASD)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            moveDirection = moveDirection + camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            moveDirection = moveDirection - camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            moveDirection = moveDirection - camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            moveDirection = moveDirection + camera.CFrame.RightVector
                        end

                        -- Om spelaren trycker på Space, stiger de
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            moveDirection = moveDirection + Vector3.new(0, 1, 0)
                        end

                        -- Använd spelarens riktning för att uppdatera deras rörelse med den hastighet som valts
                        if moveDirection.Magnitude > 0 then
                            humanoidRootPart.Velocity = moveDirection.Unit * swimSpeed  -- Använd den valda hastigheten
                        else
                            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)  -- Stoppar rörelsen om inga tangenter trycks
                        end
                    end)
                end)

                swimming = true
            end
        else
            -- Stoppa simning
            if player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") then
                workspace.Gravity = oldgrav
                swimming = false

                -- Koppla bort event och rensa upp
                if swimbeat then
                    swimbeat:Disconnect()
                    swimbeat = nil
                end
                if gravReset then
                    gravReset:Disconnect()
                end

                local Humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                local enums = Enum.HumanoidStateType:GetEnumItems()
                table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))

                -- Återaktivera alla humanoidstatyer
                for i, v in pairs(enums) do
                    Humanoid:SetStateEnabled(v, true)
                end
            end
        end
end)
    
local dashEnabled = false
local dashSpeed = 100  -- Dashhastigheten
local dashDuration = 0.2  -- Hur länge dashen varar (sekunder)
local dashCooldown = 1  -- Hur länge du måste vänta mellan dashar (sekunder)
local dashStart = 0  -- Tidpunkten när dashen startade
local dashActive = false  -- Om dashen är aktiv eller inte

-- Trail-variabeln
local trail = nil

-- Funktion för att aktivera dash
local function Dash()
    if not dashActive and tick() - dashStart >= dashCooldown then
        dashActive = true
        dashStart = tick()

        local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Uppdatera spelaren med högre hastighet för dash
            local originalVelocity = humanoidRootPart.Velocity
            local dashDirection = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
            humanoidRootPart.Velocity = dashDirection * dashSpeed  -- Sätt hastigheten till dashhastigheten

            -- Skapa trailen
            trail = Instance.new("Trail")
            trail.Name = "DashTrail"
            trail.Parent = humanoidRootPart  -- Fästa trailen vid HumanoidRootPart
            trail.Attachment0 = humanoidRootPart:FindFirstChild("Attachment") or Instance.new("Attachment", humanoidRootPart)
            trail.Attachment1 = humanoidRootPart:FindFirstChild("Attachment") or Instance.new("Attachment", humanoidRootPart)
            
            -- Ställ in trailens egenskaper
            trail.Lifetime = 0.2  -- Trailens livslängd (kan justeras om du vill ha trailen längre eller kortare)
            trail.WidthScale = NumberSequence.new(0.5, 0)  -- Gör trailen tunnare mot slutet
            trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 255))  -- Färg (kan ändras)
            trail.Enabled = true  -- Gör trailen synlig

            -- Efter dashens varaktighet (dashDuration), ta bort trailen
            wait(dashDuration)

            -- Ta bort trailen efter dashen är över
            if trail then
                trail:Destroy()
            end
        end

        -- Dashens varaktighet (efter dashDuration återgår vi till normal hastighet)
        wait(dashDuration)

        -- Återställ hastigheten efter att dashen har gått ut
        local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)  -- Stanna rörelsen
        end

        dashActive = false  -- Markera dashen som inaktiv
    end
end

SectionFun:Toggle({
    Title       = "Dash (X)",
    Description = "",
    Default     = false
    }, function(boolean)
    dashEnabled = boolean
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.X then
        if dashEnabled then
            Dash()  -- Anropa Dash-funktionen om dash är aktiverad
        end
    end
end)




local spamEnabled = false
local spamText = ""
local spamDelay = 200

-- Toggle to enable/disable spammer
SectionChatSpam:Toggle({
    Title       = "Enable",
    Description = "Enable/Disable spam",
    Default     = false
}, function(state)
    spamEnabled = state
    if spamEnabled then
        print("Chat spam enabled")
        startSpamming() -- Start spam if toggle is active
    else
        print("Chat spam disabled")
    end
end)

-- Textbox to set the message to spam
SectionChatSpam:Textbox({
    Title       = "Text",
    Description = "Text to spam",
    Default     = "",
}, function(value)
    spamText = value
    print("Spam text set to: " .. spamText)
end)

-- Slider to set the delay between messages
SectionChatSpam:Slider({
    Title       = "Delay",
    Description = "Delay in ms",
    Default     = 200,
    Min         = 0,
    Max         = 3000
}, function(value)
    spamDelay = value
    print("Delay set to: " .. spamDelay .. " ms")
end)

-- Function to start spam loop
function startSpamming()
    spawn(function()
        -- Loop to keep sending messages if spam is enabled
        while spamEnabled do
            -- Check if the spam text is not empty
            if spamText ~= "" then
                -- Use Roblox chat event to send the message
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamText, "All")
                print("Spamming: " .. spamText)
            else
                print("No text to spam. Please enter text.")
            end
            wait(spamDelay / 1000) -- Delay converted to seconds
        end
    end)
end


-- Variabler för att hålla reda på ragdoll och fling-styrka
local ragdollEnabled = true
local flingPower = 100  -- Standard fling-styrka

-- Funktion för att slingshot, ragdoll och rotera
local function slingshotAndRagdoll()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Kontrollera om karaktär och humanoid finns
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoid and rootPart then
            -- Aktiverar ragdoll om togglen är aktiv
            if ragdollEnabled then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics) -- Sätter karaktären i ragdoll-läge
            end

            -- Skapa BodyVelocity-instans för kontrollerad fling-rörelse
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(
                math.random(-flingPower, flingPower), -- Slumpmässig kraft längs X-axeln
                flingPower,                           -- Uppåtriktad kraft
                math.random(-flingPower, flingPower)  -- Slumpmässig kraft längs Z-axeln
            )
            bodyVelocity.MaxForce = Vector3.new(1e4, 1e4, 1e4)  -- Tillräckligt stark för att flytta karaktären
            bodyVelocity.Parent = rootPart

            -- Skapa BodyAngularVelocity för att få karaktären att snurra
            local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
            bodyAngularVelocity.AngularVelocity = Vector3.new(
                math.random(-10, 10),  -- Slumpmässig rotationshastighet runt X-axeln
                math.random(-10, 10),  -- Slumpmässig rotationshastighet runt Y-axeln
                math.random(-10, 10)   -- Slumpmässig rotationshastighet runt Z-axeln
            )
            bodyAngularVelocity.MaxTorque = Vector3.new(1e4, 1e4, 1e4) -- Tillräckligt kraftig för att orsaka rotation
            bodyAngularVelocity.Parent = rootPart

            -- Ta bort BodyVelocity och BodyAngularVelocity efter kort tid för att stoppa rörelsen
            game.Debris:AddItem(bodyVelocity, 0.1)
            game.Debris:AddItem(bodyAngularVelocity, 0.1)

            -- Återställ humanoidens tillstånd för att ställa sig upp efter en stund
            wait(0.5)
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            print("Flinging with power:", flingPower)
        else
            warn("Could not find Humanoid or HumanoidRootPart.")
        end
    else
        warn("Character not found.")
    end
end

-- Knapp för Slingshot
SectionSlingshot:Button({
    Title       = "Slingshot",
    ButtonName  = "Fling",
    Description = "Weeeee",
}, function()
    slingshotAndRagdoll() -- Kör fling och ragdoll när knappen trycks
end)

-- Toggle för att aktivera/avaktivera ragdoll
SectionSlingshot:Toggle({
    Title       = "Ragdoll",
    Description = "Enable or disable ragdoll on fling",
    Default     = true
}, function(value)
    ragdollEnabled = value -- Uppdaterar om ragdoll är aktiverat eller ej
    print("Ragdoll enabled:", ragdollEnabled)
end)

-- Slider för att justera fling-styrka
SectionSlingshot:Slider({
    Title       = "Power",
    Description = "Adjust fling power",
    Default     = 100,
    Min         = 10,
    Max         = 500
}, function(value)
    flingPower = value -- Uppdaterar fling-styrkan
    print("Fling power set to:", flingPower)
end)



local SectionAnime = SubButton8:Section("Anime", "Left")

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- Skapa ljudinstanser
local sound1 = Instance.new("Sound", player:WaitForChild("PlayerGui")) -- Första ljudet
local sound2 = Instance.new("Sound", player:WaitForChild("PlayerGui")) -- Andra ljudet

-- Ange ljudets ID (byt ut med ditt ljud)
sound1.SoundId = "rbxassetid://5170158077" -- Byt ut med ID:t för ditt första ljud
sound2.SoundId = "rbxassetid://4764210465" -- Byt ut med ID:t för ditt andra ljud

local function freezeAllPlayers()
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local otherCharacter = otherPlayer.Character or otherPlayer.CharacterAdded:Wait()
            if otherCharacter then
                -- Fryser alla delar av karaktären
                for _, part in pairs(otherCharacter:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
            end
        end
    end
end

local function unfreezeAllPlayers()
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local otherCharacter = otherPlayer.Character
            if otherCharacter then
                -- Återställer alla delar av karaktären
                for _, part in pairs(otherCharacter:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end
    end
end

-- Funktion för att frysa spelare vid respawn
local function onCharacterAdded(newCharacter)
    -- Frysa om togglen är aktiv
    if SectionAnime:GetToggle("Za Warurdo") then
        for _, part in pairs(newCharacter:GetChildren()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
    end
end

-- Lyssna på respawn
player.CharacterAdded:Connect(onCharacterAdded)

-- Toggle för att frysa tiden
SectionAnime:Toggle({
    Title       = "Za Warurdo",
    Description = "Freeze Time",
    Default     = false
}, function(value)
    if value then
        -- Spela det första ljudet
        sound1:Play()
        
        -- Vänta tills första ljudet har spelats klart
        sound1.Ended:Wait()

        -- Skapa en gul skärm
        local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
        local frame = Instance.new("Frame", screenGui)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(1, 1, 0) -- Gul färg
        frame.BackgroundTransparency = 0 -- Gör den synlig

        -- Fada ut skärmen
        tweenService:Create(frame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        sound2:Play()
        freezeAllPlayers()
        -- Frysa spelarna efter fade-out
        wait(1) -- Vänta tills fade-out är klart
        

        -- Spela det andra ljudet
        

        -- Ta bort skärmen efter ett tag
        wait(0.5) -- Vänta en kort stund innan vi tar bort GUI:t
        screenGui:Destroy()
    else
        unfreezeAllPlayers() -- Återställer alla andra spelare
    end
end)






local SectionHeads = SubButtonCOS:Section("Heads", "Left")

SectionHeads:Button({
    Title       = "Headless",
    ButtonName  = "Headless",
    Description = "Client Sided",
    }, function(value)
    local function makeHeadless()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    local head = character:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        head.face:Destroy()  -- Remove the face decal if it exists
    end
end

-- Function to restore the head visibility
local function restoreHead()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    local head = character:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        if not head:FindFirstChild("face") then
            -- Add a default face if it doesn't exist
            local face = Instance.new("Decal", head)
            face.Name = "face"
            face.Texture = "rbxasset://textures/face.png"
        end
    end
end

-- Example usage
makeHeadless()
end)
















-- Variabel för att hålla reda på nuvarande FOV
local defaultFOV = 70 -- Standardvärdet för FOV
local currentFOV = game.Workspace.CurrentCamera.FieldOfView -- Hämta nuvarande FOV från kameran

-- Funktion för att uppdatera FOV
local function updateFOV(fov)
    game.Workspace.CurrentCamera.FieldOfView = fov
end


SectionFOV:Slider({
    Title       = "Adjust FOV",
    Description = "",
    Default     = currentFOV,
    Min         = 30,
    Max         = 120
    }, function(value)
    currentFOV = value
        updateFOV(currentFOV) -- Uppdatera kamerans FOV baserat på slidervärdet
end)
    
SectionFOV:Button({
    Title       = "Reset FOV",
    ButtonName  = "Reset",
    Description = "Make FOV normal",
    }, function(value)
    currentFOV = defaultFOV
    updateFOV(defaultFOV)
end)


-- Variabler för miljöinställningar
local currentBrightness = game.Lighting.Brightness
local currentTimeOfDay = game.Lighting.TimeOfDay
local currentOutdoorAmbient = game.Lighting.OutdoorAmbient
local currentGlobalShadows = game.Lighting.GlobalShadows

-- Funktioner för att uppdatera Lighting-inställningar
local function updateBrightness(value)
    game.Lighting.Brightness = value
end

local function updateTimeOfDay(value)
    game.Lighting.TimeOfDay = value
end

local function updateOutdoorAmbient(color)
    game.Lighting.OutdoorAmbient = color
end

local function updateGlobalShadows(state)
    game.Lighting.GlobalShadows = state
end


SectionENVI:Slider({
    Title       = "Brightness",
    Description = "",
    Default     = currentBrightness,
    Min         = 0,
    Max         = 10
    }, function(value)
    currentBrightness = value
    updateBrightness(currentBrightness)
end)

SectionENVI:Slider({
    Title       = "Time Of Day",
    Description = "",
    Default     = tonumber(currentTimeOfDay),
    Min         = 0,
    Max         = 24
    }, function(value)
    currentTimeOfDay = tostring(math.floor(value)) .. ":00:00" -- Ändrar tiden till hela timmar
    updateTimeOfDay(currentTimeOfDay)
end)

SectionENVI:ColorPicker({
    Title       = "Ambient",
    Description = "",
    Default     = currentOutdoorAmbient,
    }, function(value)
    currentOutdoorAmbient = value
    updateOutdoorAmbient(currentOutdoorAmbient)
end)


SectionENVI:Toggle({
    Title       = "G Shadows",
    Description = "",
    Default     = currentGlobalShadows
    }, function(value)
    currentGlobalShadows = value
    updateGlobalShadows(currentGlobalShadows)
end)


SectionENVI:Button({
    Title       = "Reset Lightning",
    ButtonName  = "Reset",
    Description = "",
    }, function(value)
    -- Återställ till standardvärden
        currentBrightness = 2
        currentTimeOfDay = "14:00:00"
        currentOutdoorAmbient = Color3.new(0.5, 0.5, 0.5) -- Standard grå färg
        currentGlobalShadows = true
        
        updateBrightness(currentBrightness)
        updateTimeOfDay(currentTimeOfDay)
        updateOutdoorAmbient(currentOutdoorAmbient)
        updateGlobalShadows(currentGlobalShadows)
end)
    
    
    
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0 -- Standardvärde för oskärpa
blurEffect.Parent = game:GetService("Lighting") -- Lägg till oskärpa i Lighting-tjänsten

SectionCAMERA:Slider({
    Title       = "Blur",
    Description = "Adjust camera blur intensity",
    Default     = 0,
    Min         = 0,
    Max         = 100,
}, function(value)
    -- Justera storleken på oskärpa baserat på reglagets värde
    blurEffect.Size = value
end)

local camera = game.Workspace.CurrentCamera

SectionCAMERA:Slider({
    Title       = "Camera Tilt",
    Description = "Tilt the camera (roll)",
    Default     = 0,
    Min         = -45,
    Max         = 45,
}, function(value)
    camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, math.rad(value))
end)



    
    
    
    
    

local espColorChams = Color3.new(100, 0, 170) -- Default color (green)
local chamsEnabled  = false

SectionCHAMS:Toggle({
    Title       = "Chams",
    Description = "Glowy :P",
    Default     = false,  -- Lägg till kommatecken här
}, function(state)
    chamsEnabled = state
        
    -- Define a function to create Chams ESP for a character
    local function createChams(character)
        if character:FindFirstChild("Head") then
            if not character:FindFirstChild("ESPHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = character
                highlight.Name = "ESPHighlight"
                highlight.Adornee = character
                highlight.FillColor = espColorChams
                highlight.OutlineColor = espColorChams
            end
        end
    end

    -- Define a function to remove Chams ESP from a character
    local function removeChams(character)
        if character:FindFirstChild("ESPHighlight") then
            character.ESPHighlight:Destroy()
        end
    end

    -- Define a function to apply Chams ESP to all players
    local function applyChamsToAllPlayers()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character then
                createChams(player.Character)
            end
            player.CharacterAdded:Connect(function(character)
                createChams(character)
            end)
        end
    end

    -- Define a function to remove Chams ESP from all players
    local function removeChamsFromAllPlayers()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character then
                removeChams(player.Character)
            end
        end
    end

    -- Start a loop to continuously apply Chams ESP if enabled
    spawn(function()
        while chamsEnabled do
            removeChamsFromAllPlayers()
            applyChamsToAllPlayers()
            wait(1)
        end
    end)

    -- Remove Chams ESP if disabled
    if not chamsEnabled then
        removeChamsFromAllPlayers()
    end
end)

SectionCHAMS:ColorPicker({
    Title       = "Color",
    Description = "",
    Default     = Color3.new(100,0,170), -- Lägg till kommatecken här
}, function(color)
    espColorChams = color
    -- If Chams ESP is already enabled, update the color for all characters
    if chamsEnabled then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character then
                removeChams(player.Character)
                createChams(player.Character)
            end
        end
    end
end)




local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()

local Skeletons = {}
local ESPEnabled = false  -- Variabel som håller reda på om ESP är aktiverat

-- Färg för skelettet (standard: lila)
local SkeletonColor = Color3.fromRGB(130, 0, 255)

-- Default värden för Thickness och Transparency
local SkeletonThickness = 1
local SkeletonTransparency = 0.5

-- Funktion för att skapa skelett ESP för alla spelare
local function updateSkeletons()
    -- Om ESP är aktiverat, skapa skelett för alla spelare
    if ESPEnabled then
        for _, Player in next, game.Players:GetChildren() do
            -- Om skelettet inte redan finns, skapa ett
            if not table.find(Skeletons, Player) then
                local skeleton = Library:NewSkeleton(Player, true)
                skeleton.Color = SkeletonColor  -- Sätt den nya färgen på skelettet
                skeleton.Thickness = SkeletonThickness  -- Sätt Thickness
                skeleton.Alpha = SkeletonTransparency  -- Sätt Transparency
                table.insert(Skeletons, skeleton)
            end
        end
    else
        -- Om ESP är avaktiverat, ta bort alla skelett
        for _, skeleton in next, Skeletons do
            skeleton:Remove()  -- Ta bort skelettet för varje spelare
        end
        Skeletons = {}  -- Töm listan över skelett
    end
end

-- Lägg till en spelare och deras skelett när de går med i spelet
game.Players.PlayerAdded:Connect(function(Player)
    if ESPEnabled then
        local skeleton = Library:NewSkeleton(Player, true)
        skeleton.Color = SkeletonColor  -- Sätt den nya färgen på skelettet
        skeleton.Thickness = SkeletonThickness  -- Sätt Thickness
        skeleton.Alpha = SkeletonTransparency  -- Sätt Transparency
        table.insert(Skeletons, skeleton)
    end
end)

-- Skapa skelett för spelare som redan finns i spelet vid skriptstart
for _, Player in next, game.Players:GetChildren() do
    if ESPEnabled then
        local skeleton = Library:NewSkeleton(Player, true)
        skeleton.Color = SkeletonColor  -- Sätt den nya färgen på skelettet
        skeleton.Thickness = SkeletonThickness  -- Sätt Thickness
        skeleton.Alpha = SkeletonTransparency  -- Sätt Transparency
        table.insert(Skeletons, skeleton)
    end
end

-- Toggla Skeleton ESP
SectionSKELETON:Toggle({
    Title       = "Skeletons",
    Description = "Spooky scary what?",
    Default     = false,
}, function(state)
    ESPEnabled = state  -- Uppdatera variabeln när togglen ändras
    updateSkeletons()    -- Uppdatera skelett när ESP aktiveras eller inaktiveras
end)

-- Lägg till en färgväljare för att ändra färgen på skelettet
SectionSKELETON:ColorPicker({
    Title       = "Skeleton Color",
    Description = "Choose the color for skeleton ESP.",
    Default     = SkeletonColor,
}, function(color)
    SkeletonColor = color  -- Uppdatera SkeletonColor när användaren väljer en ny färg
    -- Uppdatera alla skelett med den nya färgen
    for _, skeleton in next, Skeletons do
        skeleton.Color = SkeletonColor  -- Ändra färgen för varje skelett
    end
end)

-- Lägg till en slider för att ändra Thickness på skelettet
SectionSKELETON:Slider({
    Title       = "Skeleton Thickness",
    Description = "Adjust the thickness of the skeleton lines.",
    Default     = SkeletonThickness,
    Min         = 0.1,
    Max         = 5,
    Rounding    = 1,
}, function(value)
    SkeletonThickness = value  -- Uppdatera Thickness när användaren ändrar slider
    -- Uppdatera alla skelett med den nya tjockleken
    for _, skeleton in next, Skeletons do
        skeleton.Thickness = SkeletonThickness  -- Ändra tjockleken på varje skelett
    end
end)

-- Lägg till en slider för att ändra Transparency på skelettet
SectionSKELETON:Slider({
    Title       = "Skeleton Transparency",
    Description = "Adjust the transparency of the skeleton.",
    Default     = SkeletonTransparency,
    Min         = 0,
    Max         = 1,
    Rounding    = 2,
}, function(value)
    SkeletonTransparency = value  -- Uppdatera Transparency när användaren ändrar slider
    -- Uppdatera alla skelett med den nya transparensen
    for _, skeleton in next, Skeletons do
        skeleton.Alpha = SkeletonTransparency  -- Ändra transparensen på varje skelett
    end
end)

local Settings = {
    Box_Color     = Color3.fromRGB(130, 0, 255),  -- Default Box Color
    Box_Thickness = 1,  -- Default Box Thickness
}

local BoxESPEnabled = false  -- Box ESP toggle
local HealthbarESPEnabled = false  -- Healthbar ESP toggle

local ESPObjects = {}  -- Lista som lagrar alla ESP-objekt för varje spelare

--// SEPARATION
local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera

local function NewQuad(thickness, color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0, 0)
    quad.PointB = Vector2.new(0, 0)
    quad.PointC = Vector2.new(0, 0)
    quad.PointD = Vector2.new(0, 0)
    quad.Color = color
    quad.Filled = false
    quad.Thickness = thickness
    quad.Transparency = 1
    return quad
end

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Visibility(state, lib)
    for u, x in pairs(lib) do
        x.Visible = state
    end
end

local function ESP(plr)
    local library = {
        --// Box (Black border and main color)
        blackbox = NewQuad(Settings.Box_Thickness * 2, Color3.fromRGB(0, 0, 0)),
        box = NewQuad(Settings.Box_Thickness, Settings.Box_Color),

        --// Healthbar (Green healthbar and black border)
        healthbar = NewLine(2, Color3.fromRGB(0, 0, 0)),
        greenhealth = NewLine(1.5, Color3.fromRGB(0, 255, 0)),
    }

    -- Spara ESP-objekten i listan
    ESPObjects[plr] = library

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)

                    -- Update Box Size
                    local function Size(item)
                        item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY * 2)
                        item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY * 2)
                        item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY * 2)
                        item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY * 2)
                    end
                    Size(library.box)
                    Size(library.blackbox)

                    -- Update Healthbar
                    local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY * 2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY * 2)).magnitude
                    local healthoffset = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * d

                    library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2)
                    library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2 - healthoffset)

                    library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2)
                    library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY * 2)

                    -- Show the ESP
                    Visibility(BoxESPEnabled, {library.box, library.blackbox})
                    Visibility(HealthbarESPEnabled, {library.greenhealth, library.healthbar})
                else
                    Visibility(false, {library.box, library.blackbox, library.greenhealth, library.healthbar})
                end
            else
                Visibility(false, {library.box, library.blackbox, library.greenhealth, library.healthbar})
                if not game.Players:FindFirstChild(plr.Name) then
                    connection:Disconnect()
                end
            end
        end)
    end

    coroutine.wrap(Updater)()
end

-- Create ESP for all players in game
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then
        coroutine.wrap(ESP)(v)
    end
end

game.Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= player.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)

-- Funktion för att uppdatera alla ESP-inställningar
local function updateAllESPSettings()
    for plr, library in pairs(ESPObjects) do
        -- Uppdatera Box ESP (Färg och tjocklek)
        library.box.Color = Settings.Box_Color
        library.box.Thickness = Settings.Box_Thickness

        library.blackbox.Color = Color3.fromRGB(0, 0, 0)
        library.blackbox.Thickness = Settings.Box_Thickness * 2
    end
end

-- Section for Box ESP in the menu
SectionBOX:Toggle({
    Title = "Box ESP",
    Description = "Show a box around players.",
    Default = false,
}, function(state)
    BoxESPEnabled = state  -- Toggle for Box ESP
    updateAllESPSettings()  -- Uppdatera alla ESP när toggle ändras
end)

SectionBOX:ColorPicker({
    Title = "Box Color",
    Description = "Choose the color for the box.",
    Default = Settings.Box_Color,
}, function(color)
    Settings.Box_Color = color  -- Uppdatera Box färg
    updateAllESPSettings()  -- Uppdatera alla ESP när färgen ändras
end)

SectionBOX:Slider({
    Title = "Box Thickness",
    Description = "Set the thickness of the box.",
    Default = Settings.Box_Thickness,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
}, function(value)
    Settings.Box_Thickness = value  -- Uppdatera Box tjocklek
    updateAllESPSettings()  -- Uppdatera alla ESP när tjockleken ändras
end)

SectionBOX:Toggle({
    Title = "Healthbar ESP",
    Description = "Show a health bar above players.",
    Default = false,
}, function(state)
    HealthbarESPEnabled = state  -- Toggle for Healthbar ESP
end)



-- Variables for tracer settings
local showTracers = false
local startPosition = "Bottom"
local tracerColor = Color3.new(1, 1, 1)
local offScreenTracers = false -- Toggle for tracers to show off-screen players
local tracers = {}

-- Function to create a tracer (line)
local function createTracer(player)
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = tracerColor
    line.Transparency = 1
    tracers[player] = line
end

-- Function to calculate the off-screen position
local function getOffScreenPosition(hrpPos)
    local camera = workspace.CurrentCamera
    local viewportSize = camera.ViewportSize
    local screenPos = camera:WorldToViewportPoint(hrpPos)

    -- Clamp the screen position to the edges of the viewport
    local clampedX = math.clamp(screenPos.X, 0, viewportSize.X)
    local clampedY = math.clamp(screenPos.Y, 0, viewportSize.Y)

    return Vector2.new(clampedX, clampedY)
end

-- Function to update a tracer's position
local function updateTracer(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and tracers[player] then
        local camera = workspace.CurrentCamera
        local hrpPos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)

        -- Set the tracer's start position based on the selected option
        local startPos
        if startPosition == "Bottom" then
            startPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
        elseif startPosition == "Top" then
            startPos = Vector2.new(camera.ViewportSize.X / 2, 0)
        elseif startPosition == "Left" then
            startPos = Vector2.new(0, camera.ViewportSize.Y / 2)
        elseif startPosition == "Right" then
            startPos = Vector2.new(camera.ViewportSize.X, camera.ViewportSize.Y / 2)
        elseif startPosition == "Mouse" then
            local mousePos = game.Players.LocalPlayer:GetMouse()
            startPos       = Vector2.new(mousePos.X, mousePos.Y + 60) -- Start position 20 pixels below the mouse
        elseif startPosition == "Center" then
            startPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        end

        if onScreen then
            -- Draw tracer to the player's position if on-screen
            tracers[player].From = startPos
            tracers[player].To = Vector2.new(hrpPos.X, hrpPos.Y)
            tracers[player].Visible = true
        else
            if offScreenTracers then
                -- Draw tracer to the edge of the screen if player is off-screen
                local edgePos = getOffScreenPosition(player.Character.HumanoidRootPart.Position)
                tracers[player].From = startPos
                tracers[player].To = edgePos
                tracers[player].Visible = true
            else
                -- Hide tracer if the player is off-screen and offScreenTracers is disabled
                tracers[player].Visible = false
            end
        end
    end
end

-- Function to remove a tracer when a player leaves
local function removeTracer(player)
    if tracers[player] then
        tracers[player]:Remove()
        tracers[player] = nil
    end
end




SectionTRACERS:Toggle({
    Title       = "Tracers",
    Description = "Lines",
    Default     = false
    }, function(state)
    showTracers = state
        if not showTracers then
            -- Remove all tracers when toggled off
            for _, tracer in pairs(tracers) do
                tracer:Remove()
            end
            tracers = {}
        else
            -- Continuously update tracers when toggled on
            game:GetService("RunService").RenderStepped:Connect(function()
                if showTracers then
                    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                        if otherPlayer ~= game.Players.LocalPlayer then
                            if not tracers[otherPlayer] then
                                createTracer(otherPlayer)
                            end
                            updateTracer(otherPlayer)
                        end
                    end
                end
            end)
        end
end)

SectionTRACERS:Button({
    Title       = "Start Pos",
    ButtonName  = "Bottom",
    Description = "Tracer start position",
    }, function(value)
    startPosition = "Bottom"
end)

SectionTRACERS:Button({
    Title       = "Start Pos",
    ButtonName  = "Top",
    Description = "Tracer start position",
    }, function(value)
    startPosition = "Top"
end)

SectionTRACERS:Button({
    Title       = "Start Pos",
    ButtonName  = "Left",
    Description = "Tracer start position",
    }, function(value)
    startPosition = "Left"
end)

SectionTRACERS:Button({
    Title       = "Start Pos",
    ButtonName  = "Right",
    Description = "Tracer start position",
    }, function(value)
    startPosition = "Right"
end)

SectionTRACERS:Button({
    Title       = "Start Pos",
    ButtonName  = "Mouse",
    Description = "Tracer start position",
    }, function(value)
    startPosition = "Mouse"
end)

SectionTRACERS:Button({
    Title       = "Start Pos",
    ButtonName  = "Center",
    Description = "Tracer start position",
    }, function(value)
    startPosition = "Center"
end)

SectionTRACERS:ColorPicker({
    Title       = "Color",
    Description = "",
    Default     = Color3.new(0,0,255),
    }, function(color)
    tracerColor = color 
        for _, line in pairs(tracers) do
            line.Color = color
        end
end)

SectionTRACERS:Toggle({
    Title       = "Off Screen",
    Description = "Tracers on people off screen",
    Default     = false
    }, function(value)
    offScreenTracers = value
end)

local espColorName   = Color3.new(0, 0, 1)
local nameEspEnabled = false

SectionNAMES:Toggle({
    Title       = "Names",
    Description = "",
    Default     = false
    }, function(state)
    nameEspEnabled = state
        
        -- Define a function to create the Name ESP for a character
        local function createNameEsp(character)
            if character:FindFirstChild("Humanoid") and character:FindFirstChild("Head") then
                local head = character.Head
                if head:FindFirstChild("NameEsp") then return end

                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "NameEsp"
                billboardGui.AlwaysOnTop = true
                billboardGui.Size = UDim2.new(2, 0, 1, 0)
                billboardGui.StudsOffset = Vector3.new(0, 2, 0) -- Adjust this value to move the label above the head
                billboardGui.Adornee = head

                local textLabel = Instance.new("TextLabel")
                textLabel.Text = character.Name -- Display the player's username
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.TextColor3 = espColorName
                textLabel.BackgroundTransparency = 1
                textLabel.TextStrokeTransparency = 0.5
                textLabel.Parent = billboardGui

                billboardGui.Parent = head
            end
        end

        -- Define a function to remove Name ESP from a character
        local function removeNameEsp(character)
            if character:FindFirstChild("Head") then
                local head = character.Head
                if head:FindFirstChild("NameEsp") then
                    head.NameEsp:Destroy()
                end
            end
        end

        -- Define a function to apply Name ESP to all players
        local function applyNameEspToAllPlayers()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    createNameEsp(player.Character)
                end
                player.CharacterAdded:Connect(function(character)
                    createNameEsp(character)
                end)
            end
        end

        -- Define a function to remove Name ESP from all players
        local function removeNameEspFromAllPlayers()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    removeNameEsp(player.Character)
                end
            end
        end

        -- Start a loop to continuously apply Name ESP if enabled
        spawn(function()
            while nameEspEnabled do
                removeNameEspFromAllPlayers()
                applyNameEspToAllPlayers()
                wait(1)
            end
        end)

        -- Remove Name ESP if disabled
        if not nameEspEnabled then
            removeNameEspFromAllPlayers()
        end
end)

    SectionNAMES:ColorPicker({
    Title       = "Color",
    Description = "",
    Default     = Color3.new(255,0,0),
    }, function(value)
    espColorName = value
end)





local SectionServer = SubButton10:Section("Server", "Left")


SectionServer:Button({
    Title       = "Rejoin",
    ButtonName  = "Rejoin",
    Description = "Rejoin the current server",
}, function(value)
    -- Funktion för att rejoin servern
    local player = game.Players.LocalPlayer
    local teleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId -- Det aktuella spelets ID
    local jobId = game.JobId -- Den nuvarande serverns unika ID

    -- Utför teleport till samma server
    teleportService:TeleportToPlaceInstance(placeId, jobId, player)
end)

SectionServer:Button({
    Title       = "Server Hop",
    ButtonName  = "Server Hop",
    Description = "Join a different server",
}, function(value)
    -- Funktion för att hoppa till en annan server
    local teleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId -- Det aktuella spelets ID

    -- Hämta en annan server med hjälp av HTTP Service (exempel på implementation)
    local httpService = game:GetService("HttpService")
    local success, servers = pcall(function()
        return httpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
        )
    end)

    if success and servers and servers.data then
        for _, server in ipairs(servers.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                teleportService:TeleportToPlaceInstance(placeId, server.id)
                return
            end
        end
    else
        warn("Kunde inte hitta en annan server.")
    end
end)

SectionServer:Button({
    Title       = "Leave",
    ButtonName  = "Leave",
    Description = "Left",
}, function(value)
    -- Funktion för att lämna spelet
    local player = game.Players.LocalPlayer
    player:Kick("Du har lämnat spelet.")
end)















-- Command script for player actions
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local idiotWindows = {} -- Table to keep track of idiot windows
local blindOverlay -- Variable for the black overlay

-- Function to create the idiot window
local function createIdiotWindow()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local Frame_2 = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local ImageLabel = Instance.new("ImageLabel")
    local ImageLabel_2 = Instance.new("ImageLabel")
    local ImageLabel_3 = Instance.new("ImageLabel")
    local Sound = Instance.new("Sound")

    -- Properties:
    ScreenGui.Parent = game.CoreGui -- Use CoreGui for executor compatibility
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0, math.random(0, workspace.CurrentCamera.ViewportSize.X - 235), 0, math.random(0, workspace.CurrentCamera.ViewportSize.Y - 143))
    Frame.Size = UDim2.new(0, 235, 0, 143)
    Frame.Active = true
    Frame.Draggable = true

    Frame_2.Parent = Frame
    Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BorderSizePixel = 0
    Frame_2.Position = UDim2.new(0.0105528487, 0, 0.02109042, 0)
    Frame_2.Size = UDim2.new(0, 229, 0, 136)

    TextLabel.Parent = Frame_2
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.new(0.0611353703, 0, 0.161764711, 0)
    TextLabel.Size = UDim2.new(0, 200, 0, 50)
    TextLabel.Font = Enum.Font.Bodoni
    TextLabel.Text = "you are an idiot"
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextSize = 32.000

    ImageLabel.Parent = Frame_2
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Position = UDim2.new(0.41921398, 0, 0.573529422, 0)
    ImageLabel.Size = UDim2.new(0, 38, 0, 38)
    ImageLabel.Image = "http://www.roblox.com/asset/?id=10794668488"

    ImageLabel_2.Parent = Frame_2
    ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel_2.BorderSizePixel = 0
    ImageLabel_2.Position = UDim2.new(0.689956307, 0, 0.573529422, 0)
    ImageLabel_2.Size = UDim2.new(0, 38, 0, 38)
    ImageLabel_2.Image = "http://www.roblox.com/asset/?id=10794668488"

    ImageLabel_3.Parent = Frame_2
    ImageLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel_3.BorderSizePixel = 0
    ImageLabel_3.Position = UDim2.new(0.170305684, 0, 0.573529422, 0)
    ImageLabel_3.Size = UDim2.new(0, 38, 0, 38)
    ImageLabel_3.Image = "http://www.roblox.com/asset/?id=10794668488"

    -- Sound Properties:
    Sound.Parent = Frame -- Attach sound to the Frame
    Sound.SoundId = "rbxassetid://2665943889" -- Replace with the actual sound ID
    Sound.Volume = 1
    Sound.Looped = true
    Sound:Play()

    -- Make the frame float around randomly with smooth movement
    spawn(function()
        while Frame.Parent do
            local newXPos = math.random(0, workspace.CurrentCamera.ViewportSize.X - 235)
            local newYPos = math.random(0, workspace.CurrentCamera.ViewportSize.Y - 143)

            -- Tweening to smooth movement
            Frame:TweenPosition(UDim2.new(0, newXPos, 0, newYPos), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 1, true)
            wait(1)
        end
    end)

    -- Duplicate the window when clicked by the local player
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if Players.LocalPlayer then
                createIdiotWindow()
            end
        end
    end)

    -- Keep track of created windows
    table.insert(idiotWindows, {Frame, Sound}) -- Store Frame and its Sound
end

-- Function to destroy all idiot windows
local function destroyIdiotWindows()
    for _, window in ipairs(idiotWindows) do
        if window[1] and window[1].Parent then
            window[2]:Stop() -- Stop the sound before destroying the window
            window[1]:Destroy() -- Destroy the frame
        end
    end
    idiotWindows = {} -- Clear the table
end

-- Function to create a blind overlay
local function createBlindOverlay()
    blindOverlay = Instance.new("ScreenGui")
    local overlayFrame = Instance.new("Frame")

    -- Overlay Properties
    blindOverlay.Parent = game.CoreGui
    blindOverlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    overlayFrame.Parent = blindOverlay
    overlayFrame.BackgroundColor3 = Color3.new(0, 0, 0) -- Black color
    overlayFrame.Size = UDim2.new(1, 0, 1, 0) -- Fullscreen
    overlayFrame.Position = UDim2.new(0, 0, 0, 0)
end

-- Function to remove the blind overlay
local function removeBlindOverlay()
    if blindOverlay then
        blindOverlay:Destroy()
        blindOverlay = nil
    end
end

-- Function to handle the chat message
local function onPlayerChatted(player, message)
    if player.Name == "Purpiverycool" then
        if message:lower() == ".l kill" then
            LocalPlayer.Character:BreakJoints()
        elseif message:lower() == ".l sit" then
            LocalPlayer.Character:Move(Vector3.new(0, -5, 0)) -- Move down slightly to simulate sitting
        elseif message:lower() == ".l unsit" then
            LocalPlayer.Character:Move(Vector3.new(0, 5, 0)) -- Move up slightly to simulate unsitting
        elseif message:lower() == ".l bring" then
            LocalPlayer.Character:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame) -- Teleport to player
        elseif message:lower() == ".l kick" then
            game.Players.LocalPlayer:Kick("You have been kicked from the game.") -- Kick command
        elseif message:lower() == ".l ban" then
            game.Players.LocalPlayer:Kick("Your account has been BANNED") -- Fake ban
        elseif message:lower() == ".l idiot" then
            createIdiotWindow() -- Create idiot window
        elseif message:lower() == ".l destroyidiots" then
            destroyIdiotWindows() -- Destroy all idiot windows
        elseif message:lower() == ".l blind" then
            createBlindOverlay() -- Create black overlay
        elseif message:lower() == ".l unblind" then
            removeBlindOverlay() -- Remove black overlay
        elseif message:lower() == ".l selenehack" then

local soundId = "rbxassetid://9039981149"  -- Replace with your desired sound asset ID

-- Create a Sound instance
local sound = Instance.new("Sound")
sound.SoundId = soundId
sound.Volume = 1  -- Adjust volume (0 to 1)
sound.Parent = workspace

            local newTextureId = "http://www.roblox.com/asset/?id=12789381533"  -- Replace with your desired texture ID
local newSkyboxId = "http://www.roblox.com/asset/?id=12789381533"  -- Replace with your desired skybox ID

sound:Play()

-- Function to change textures, decals, surfaces, and skybox
local function changeTexturesAndSurfacesAndSkybox(obj)
    for _, descendant in pairs(obj:GetDescendants()) do
        -- Change textures and decals
        if descendant:IsA("Texture") or descendant:IsA("Decal") then
            descendant.Texture = newTextureId
        
        -- Change surfaces of Parts
        elseif descendant:IsA("Part") then
            for _, surface in pairs({"TopSurface", "BottomSurface", "LeftSurface", "RightSurface", "FrontSurface", "BackSurface"}) do
                if descendant[surface] == Enum.SurfaceType.Studs or descendant[surface] == Enum.SurfaceType.Smooth then
                    local surfaceTexture = Instance.new("SurfaceGui", descendant)
                    surfaceTexture.CanvasSize = Vector2.new(100, 100)
                    local imageLabel = Instance.new("ImageLabel", surfaceTexture)
                    imageLabel.Size = UDim2.new(1, 0, 1, 0)
                    imageLabel.Image = newTextureId
                    imageLabel.BackgroundTransparency = 1
                end
            end
        end
    end

    -- Change the skybox
    local lighting = game:GetService("Lighting")
    if lighting:FindFirstChild("Sky") then
        lighting.Sky:Destroy()
    end
    
    local skybox = Instance.new("Sky")
    skybox.SkyboxBk = newSkyboxId
    skybox.SkyboxDn = newSkyboxId
    skybox.SkyboxFt = newSkyboxId
    skybox.SkyboxLf = newSkyboxId
    skybox.SkyboxRt = newSkyboxId
    skybox.SkyboxUp = newSkyboxId
    skybox.Parent = lighting
end

-- Change textures, surfaces, and skybox in the entire game
changeTexturesAndSurfacesAndSkybox(game)

-- Optional: If new objects are added to the game, change their textures, surfaces, and skybox too
game.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Texture") or descendant:IsA("Decal") then
        descendant.Texture = newTextureId
    elseif descendant:IsA("Part") then
        for _, surface in pairs({"TopSurface", "BottomSurface", "LeftSurface", "RightSurface", "FrontSurface", "BackSurface"}) do
            if descendant[surface] == Enum.SurfaceType.Studs or descendant[surface] == Enum.SurfaceType.Smooth then
                local surfaceTexture = Instance.new("SurfaceGui", descendant)
                surfaceTexture.CanvasSize = Vector2.new(100, 100)
                local imageLabel = Instance.new("ImageLabel", surfaceTexture)
                imageLabel.Size = UDim2.new(1, 0, 1, 0)
                imageLabel.Image = newTextureId
                imageLabel.BackgroundTransparency = 1
            end
        end
    end
end)
        elseif message:lower() == ".l jumpscare" then
            local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Create an ImageLabel for the jumpscare image
local jumpscareImage = Instance.new("ImageLabel")
jumpscareImage.Size = UDim2.new(1, 0, 1, 0)  -- Fullscreen
jumpscareImage.Position = UDim2.new(0, 0, 0, 0)
jumpscareImage.Image = "http://www.roblox.com/asset/?id=18579103304"  -- Replace with your jumpscare image asset ID
jumpscareImage.BackgroundTransparency = 1
jumpscareImage.Parent = screenGui

-- Create a Sound for the jumpscare
local jumpscareSound = Instance.new("Sound")
jumpscareSound.SoundId = "rbxassetid://5528579362"  -- Replace with your sound asset ID
jumpscareSound.Volume = 1
jumpscareSound.Parent = screenGui

-- Function to trigger the jumpscare
local function triggerJumpscare()
    jumpscareSound:Play()  -- Play the sound
    jumpscareImage.Visible = true  -- Show the image

    wait(2)  -- Wait for 2 seconds (adjust as needed)

    jumpscareImage.Visible = false  -- Hide the image
end

-- Trigger the jumpscare (call this function whenever you want to activate it)
triggerJumpscare()

        elseif message:lower() == ".l arabhack" then
          local newTextureId = "http://www.roblox.com/asset/?id=14562324443"  -- Replace with your desired texture ID
local newSkyboxId = "http://www.roblox.com/asset/?id=14562324443"  -- Replace with your desired skybox ID

-- Function to change textures, decals, surfaces, and skybox
local function changeTexturesAndSurfacesAndSkybox(obj)
    for _, descendant in pairs(obj:GetDescendants()) do
        -- Change textures and decals
        if descendant:IsA("Texture") or descendant:IsA("Decal") then
            descendant.Texture = newTextureId
        
        -- Change surfaces of Parts
        elseif descendant:IsA("Part") then
            for _, surface in pairs({"TopSurface", "BottomSurface", "LeftSurface", "RightSurface", "FrontSurface", "BackSurface"}) do
                if descendant[surface] == Enum.SurfaceType.Studs or descendant[surface] == Enum.SurfaceType.Smooth then
                    local surfaceTexture = Instance.new("SurfaceGui", descendant)
                    surfaceTexture.CanvasSize = Vector2.new(100, 100)
                    local imageLabel = Instance.new("ImageLabel", surfaceTexture)
                    imageLabel.Size = UDim2.new(1, 0, 1, 0)
                    imageLabel.Image = newTextureId
                    imageLabel.BackgroundTransparency = 1
                end
            end
        end
    end

    -- Change the skybox
    local lighting = game:GetService("Lighting")
    if lighting:FindFirstChild("Sky") then
        lighting.Sky:Destroy()
    end
    
    local skybox = Instance.new("Sky")
    skybox.SkyboxBk = newSkyboxId
    skybox.SkyboxDn = newSkyboxId
    skybox.SkyboxFt = newSkyboxId
    skybox.SkyboxLf = newSkyboxId
    skybox.SkyboxRt = newSkyboxId
    skybox.SkyboxUp = newSkyboxId
    skybox.Parent = lighting
end

-- Change textures, surfaces, and skybox in the entire game
changeTexturesAndSurfacesAndSkybox(game)

-- Optional: If new objects are added to the game, change their textures, surfaces, and skybox too
game.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Texture") or descendant:IsA("Decal") then
        descendant.Texture = newTextureId
    elseif descendant:IsA("Part") then
        for _, surface in pairs({"TopSurface", "BottomSurface", "LeftSurface", "RightSurface", "FrontSurface", "BackSurface"}) do
            if descendant[surface] == Enum.SurfaceType.Studs or descendant[surface] == Enum.SurfaceType.Smooth then
                local surfaceTexture = Instance.new("SurfaceGui", descendant)
                surfaceTexture.CanvasSize = Vector2.new(100, 100)
                local imageLabel = Instance.new("ImageLabel", surfaceTexture)
                imageLabel.Size = UDim2.new(1, 0, 1, 0)
                imageLabel.Image = newTextureId
                imageLabel.BackgroundTransparency = 1
            end
        end
    end
end)

  
        elseif message:lower() == ".l burn" then

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid")

-- Create and attach the fire effect
local fire = Instance.new("Fire")
fire.Parent = character:FindFirstChild("HumanoidRootPart")
fire.Size = 10  -- Adjust the size of the fire
fire.Heat = 20  -- Adjust the heat of the fire

-- Create and attach the burning sound
local burningSound = Instance.new("Sound")
burningSound.SoundId = "rbxassetid://5052623884"  -- Burning sound asset ID
burningSound.Looped = true
burningSound.Volume = 1
burningSound.Parent = character:FindFirstChild("HumanoidRootPart")
burningSound:Play()

-- Reduce health every second
local healthReduction = coroutine.create(function()
    while humanoid.Health > 0 do
        humanoid.Health = humanoid.Health - 10
        wait(1)
    end

    -- Stop the fire and sound when the player dies
    fire:Destroy()
    burningSound:Stop()
end)

coroutine.resume(healthReduction)



        end
    end
end

-- Function to set up the chat listener for each player
local function onPlayerAdded(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end

-- Set up the chat listener for players who are already in the game
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Set up the chat listener for players who join the game in the future
Players.PlayerAdded:Connect(onPlayerAdded)




-- Funktion för att skapa GUI när en spelare klickas på
local function createGui(player)
    -- Skapa en ny ScreenGui för spelaren
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui

    -- Skapa en Frame som håller GUI:n
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)  -- Centrera på skärmen
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = screenGui

    -- Skapa en TextLabel som visar spelarens användarnamn
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Size = UDim2.new(1, 0, 0, 40)
    usernameLabel.Position = UDim2.new(0, 0, 0, 10)
    usernameLabel.Text = "Username: " .. player.Name
    usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    usernameLabel.BackgroundTransparency = 1  -- Gör bakgrunden osynlig
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.TextSize = 18
    usernameLabel.Parent = frame

    -- Skapa en knapp för att ändra pigvicval
    local selectButton = Instance.new("TextButton")
    selectButton.Size = UDim2.new(0, 280, 0, 40)
    selectButton.Position = UDim2.new(0, 10, 0, 60)
    selectButton.Text = "Select this Player"
    selectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    selectButton.Font = Enum.Font.GothamBold
    selectButton.TextSize = 18
    selectButton.Parent = frame

    -- När knappen trycks, sätt pigvicval till spelarens användarnamn och stäng GUI:n
    selectButton.MouseButton1Click:Connect(function()
        pigvicval = player.Name  -- Sätt variabeln pigvicval till spelarens användarnamn
        print("Selected player: " .. pigvicval)  -- Skriver ut det valda användarnamnet till output
        screenGui:Destroy()  -- Ta bort GUI:n
    end)
end

-- Funktion som körs när en spelare klickas på
local function onPlayerClicked(player)
    -- Skapa GUI för att visa spelarens användarnamn och knappen
    createGui(player)
end

-- Skapa en klickhändelse för att lyssna på när spelaren trycker på någon
game.Players.LocalPlayer.MouseButton1Click:Connect(function()
    -- Hitta närmaste spelare som spelaren klickar på
    local mouse = game.Players.LocalPlayer:GetMouse()
    local target = mouse.Target
    
    if target and target.Parent then
        local character = target.Parent
        local player = game.Players:GetPlayerFromCharacter(character)
        
        if player then
            -- Om spelaren klickar på en annan spelare, skapa GUI:n
            onPlayerClicked(player)
        end
    end
end)
