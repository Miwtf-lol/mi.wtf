--// Mi.wtf Ultimate FINAL

getgenv().Miwtf = {
    Enabled = false,
    Delay = 0.2,
    ParryType = "Normal"
}

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- SAVE / LOAD
local ConfigFile = "miwtf.json"

local function Save()
    if writefile then
        writefile(ConfigFile, HttpService:JSONEncode(Miwtf))
    end
end

local function Load()
    if isfile and isfile(ConfigFile) then
        local data = HttpService:JSONDecode(readfile(ConfigFile))
        for i,v in pairs(data) do
            Miwtf[i] = v
        end
    end
end

Load()

-- BLUR
Instance.new("BlurEffect", game.Lighting).Size = 18

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- MAIN
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,600,0,350)
Frame.Position = UDim2.new(0.5,-300,0.5,-175)
Frame.BackgroundTransparency = 0.3
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Thickness = 2

-- RGB GLOW
task.spawn(function()
    while true do
        for i=0,1,0.01 do
            Stroke.Color = Color3.fromHSV(i,1,1)
            task.wait()
        end
    end
end)

-- MINI UI
local Mini = Instance.new("Frame", ScreenGui)
Mini.Size = UDim2.new(0,150,0,50)
Mini.Position = UDim2.new(0.5,-75,0.8,0)
Mini.BackgroundTransparency = 0.2
Mini.BackgroundColor3 = Color3.fromRGB(20,20,20)
Mini.Visible = false
Instance.new("UICorner", Mini).CornerRadius = UDim.new(0,14)

local glow = Instance.new("UIStroke", Mini)
glow.Thickness = 6
glow.Transparency = 0.8

local icon = Instance.new("ImageLabel", Mini)
icon.Size = UDim2.new(0,30,0,30)
icon.Position = UDim2.new(0,10,0.5,-15)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://115496332067390"

local txt = Instance.new("TextLabel", Mini)
txt.Size = UDim2.new(1,-50,1,0)
txt.Position = UDim2.new(0,45,0,0)
txt.BackgroundTransparency = 1
txt.Text = "Mi.wtf"
txt.TextScaled = true

Mini.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        Frame.Visible = true
        Mini.Visible = false
    end
end)

-- MOBILE BUTTON
local Mobile = Instance.new("TextButton", ScreenGui)
Mobile.Size = UDim2.new(0,60,0,60)
Mobile.Position = UDim2.new(0.8,0,0.6,0)
Mobile.Text = "M"
Mobile.Visible = UIS.TouchEnabled

Mobile.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- CARD
local Card = Instance.new("Frame", Frame)
Card.Size = UDim2.new(0,200,0,200)
Card.Position = UDim2.new(0,20,0,20)
Card.BackgroundTransparency = 0.2
Card.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", Card)

-- TITLE
local Title = Instance.new("TextLabel", Card)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "Auto Parry"
Title.BackgroundTransparency = 1

-- TOGGLE
local Toggle = Instance.new("TextButton", Card)
Toggle.Size = UDim2.new(0,160,0,30)
Toggle.Position = UDim2.new(0,20,0,50)
Toggle.Text = "Auto Parry OFF"

Toggle.MouseButton1Click:Connect(function()
    Miwtf.Enabled = not Miwtf.Enabled
    Toggle.Text = "Auto Parry "..(Miwtf.Enabled and "ON" or "OFF")
    Save()
end)

-- SLIDER
local Slider = Instance.new("Frame", Card)
Slider.Size = UDim2.new(0,160,0,6)
Slider.Position = UDim2.new(0,20,0,100)

local Fill = Instance.new("Frame", Slider)
Fill.Size = UDim2.new(Miwtf.Delay,0,1,0)
Fill.BackgroundColor3 = Color3.fromRGB(255,105,180)

local drag = false

Slider.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
        Save()
    end
end)

UIS.InputChanged:Connect(function(i)
    if drag then
        local pos = (i.Position.X - Slider.AbsolutePosition.X)/Slider.AbsoluteSize.X
        pos = math.clamp(pos,0,1)
        Fill.Size = UDim2.new(pos,0,1,0)
        Miwtf.Delay = pos
    end
end)

-- DROPDOWN
local Drop = Instance.new("TextButton", Card)
Drop.Size = UDim2.new(0,160,0,30)
Drop.Position = UDim2.new(0,20,0,130)

local opts = {"Normal","Legit","Camera"}

Drop.Text = "Type: "..Miwtf.ParryType

Drop.MouseButton1Click:Connect(function()
    local i = table.find(opts, Miwtf.ParryType) or 1
    i = i % #opts + 1
    Miwtf.ParryType = opts[i]
    Drop.Text = "Type: "..Miwtf.ParryType
    Save()
end)

-- HIDE
local Hide = Instance.new("TextButton", Frame)
Hide.Size = UDim2.new(0,100,0,30)
Hide.Position = UDim2.new(1,-110,0,10)
Hide.Text = "Hide"

Hide.MouseButton1Click:Connect(function()
    Frame.Visible = false
    Mini.Visible = true
end)

-- DRAG UI
local dragging, start, pos

Frame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        start = i.Position
        pos = Frame.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging then
        local delta = i.Position - start
        Frame.Position = UDim2.new(
            pos.X.Scale,
            pos.X.Offset + delta.X,
            pos.Y.Scale,
            pos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- AUTO PARRY LOOP
task.spawn(function()
    while true do
        task.wait(3)
        if Miwtf.Enabled then
            print("⚡ READY")
            task.wait(Miwtf.Delay)
            print("🛡 PARRY", Miwtf.ParryType)
        end
    end
end)
