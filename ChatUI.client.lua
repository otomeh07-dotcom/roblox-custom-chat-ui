-- Simple Roblox Chat UI Demo
-- Black bubble, white text, auto-sizing
-- Place as a LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local player = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "CustomChatUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Get Roblox top-left inset
local inset = GuiService:GetGuiInset()

-- Chat toggle button
local chatButton = Instance.new("TextButton")
chatButton.Size = UDim2.fromOffset(40, 40)
chatButton.Position = UDim2.fromOffset(10, inset.Y + 10)
chatButton.Text = "💬"
chatButton.TextSize = 20
chatButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
chatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
chatButton.BorderSizePixel = 0
chatButton.Parent = gui

Instance.new("UICorner", chatButton).CornerRadius = UDim.new(1, 0)

-- Chat frame
local chatFrame = Instance.new("Frame")
chatFrame.Size = UDim2.fromOffset(320, 260)
chatFrame.Position = UDim2.fromOffset(10, inset.Y + 60)
chatFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
chatFrame.BorderSizePixel = 0
chatFrame.Visible = false
chatFrame.Parent = gui

Instance.new("UICorner", chatFrame).CornerRadius = UDim.new(0, 10)

-- Messages scrolling frame
local messages = Instance.new("ScrollingFrame")
messages.Size = UDim2.new(1, -10, 1, -50)
messages.Position = UDim2.fromOffset(5, 5)
messages.CanvasSize = UDim2.new(0, 0, 0, 0)
messages.ScrollBarImageTransparency = 0.3
messages.AutomaticCanvasSize = Enum.AutomaticSize.None
messages.Parent = chatFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = messages

-- Text box
local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -10, 0, 32)
box.Position = UDim2.new(0, 5, 1, -37)
box.PlaceholderText = "Type a message..."
box.Text = ""
box.TextSize = 14
box.ClearTextOnFocus = false
box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.BorderSizePixel = 0
box.Parent = chatFrame

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

-- Toggle chat
chatButton.MouseButton1Click:Connect(function()
	chatFrame.Visible = not chatFrame.Visible
end)

-- Create message bubble
local function addMessage(text)
	local bubble = Instance.new("Frame")
	bubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bubble.BorderSizePixel = 0
	bubble.AutomaticSize = Enum.AutomaticSize.Y
	bubble.Size = UDim2.new(0, 240, 0, 0)
	bubble.Parent = messages

	Instance.new("UICorner", bubble).CornerRadius = UDim.new(0, 12)

	local label = Instance.new("TextLabel")
	label.TextWrapped = true
	label.TextXAlignment = Left
	label.TextYAlignment = Top
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Size = UDim2.new(1, -12, 0, 0)
	label.Position = UDim2.fromOffset(6, 6)
	label.Text = text
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.Parent = bubble

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Wait()
	messages.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
	messages.CanvasPosition = Vector2.new(0, math.max(0, messages.CanvasSize.Y.Offset - messages.AbsoluteWindowSize.Y))
end

-- Send message
box.FocusLost:Connect(function(enter)
	if enter and box.Text ~= "" then
		addMessage(box.Text)
		box.Text = ""
	end
end)
