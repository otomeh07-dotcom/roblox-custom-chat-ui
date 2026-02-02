--// ClientChat.client.lua
--// UI + sends messages to server

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local event = ReplicatedStorage:WaitForChild("OverheadChatEvent")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CustomChatUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local inset = GuiService:GetGuiInset()

local box = Instance.new("TextBox")
box.Size = UDim2.fromOffset(360, 40)
box.Position = UDim2.fromOffset(10, inset.Y + 10)
box.PlaceholderText = "Type message and press Enter"
box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.TextSize = 16
box.ClearTextOnFocus = false
box.Parent = gui

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)

-- Slash key opens
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Slash then
		box:CaptureFocus()
	end
end)

box.FocusLost:Connect(function(enterPressed)
	if enterPressed and box.Text ~= "" then
		event:FireServer(box.Text)
		box.Text = ""
	end
end)
