-- Colin (Delta, method 3 default, lower Y)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

task.wait(1)

local gui = Instance.new("ScreenGui")
gui.Name = "ColinStopTimerSafe"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = pg

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(270, 260)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local function label(txt, y, h)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, h or 22)
    l.Position = UDim2.new(0, 10, 0, y)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(255,255,255)
    l.TextSize = 14
    l.TextWrapped = true
    l.Parent = frame
    return l
end

label("Секунды (напр. 7.1234)", 8, 22)

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -20, 0, 44)
box.Position = UDim2.new(0, 10, 0, 32)
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
box.TextColor3 = Color3.fromRGB(255,255,255)
box.TextSize = 22
box.Text = "7.1234"
box.ClearTextOnFocus = false
box.Parent = frame

-- Позиция по Y: 0.5 = центр, больше = ниже
local yFactor = 0.72

local methodBtn = Instance.new("TextButton")
methodBtn.Size = UDim2.new(1, -20, 0, 34)
methodBtn.Position = UDim2.new(0, 10, 0, 82)
methodBtn.BackgroundColor3 = Color3.fromRGB(50,50,80)
methodBtn.TextColor3 = Color3.fromRGB(255,255,255)
methodBtn.TextSize = 15
methodBtn.Parent = frame

local names = { "1 (ClickButton1)", "2 (Button1Down/Up)", "3 (VIM mouse)" }
local method = 3
methodBtn.Text = "Метод: " .. names[method]

methodBtn.MouseButton1Click:Connect(function()
    method = method % 3 + 1
    methodBtn.Text = "Метод: " .. names[method]
end)

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, -20, 0, 44)
startBtn.Position = UDim2.new(0, 10, 0, 122)
startBtn.BackgroundColor3 = Color3.fromRGB(30, 140, 30)
startBtn.Text = "Start"
startBtn.TextColor3 = Color3.fromRGB(255,255,255)
startBtn.TextSize = 20
startBtn.Parent = frame

local status = label("", 172, 78)

local function clickMethod1(pos)
    local VU = game:GetService("VirtualUser")
    VU:CaptureController()
    VU:ClickButton1(pos)
end

local function clickMethod2(pos)
    local VU = game:GetService("VirtualUser")
    VU:CaptureController()
    VU:Button1Down(pos)
    task.wait(0.05)
    VU:Button1Up(pos)
end

local function clickMethod3(pos)
    local VIM = game:GetService("VirtualInputManager")
    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
end

local methods = { clickMethod1, clickMethod2, clickMethod3 }

startBtn.MouseButton1Click:Connect(function()
    local val = tonumber(box.Text)
    if not val or val < 0 then
        status.Text = "Введи число, напр. 7.1234"
        return
    end
    status.Text = "Ждем " .. tostring(val) .. " с..."
    task.wait(val)

    local cam = workspace.CurrentCamera
    local vp = cam.ViewportSize
    local pos = Vector2.new(vp.X / 2, vp.Y * yFactor)

    gui.Enabled = false
    task.wait(0.1)

    local fn = methods[method]
    local ok, err = pcall(fn, pos)

    task.wait(0.15)
    gui.Enabled = true

    if ok then
        status.Text = "Клик: " .. names[method] .. " @ " .. math.floor(pos.Y)
    else
        status.Text = "Ошибка " .. names[method] .. ": " .. tostring(err)
    end
end)
