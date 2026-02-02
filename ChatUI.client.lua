--// Custom Chat UI + Overhead Bubble (LOCAL ONLY)
--// Works as a single file for GitHub raw loading.

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then return end

--========================
-- GUI SETUP
--========================
local gui = Instance.new("ScreenGui")
gui.Name = "CustomChatUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = player:WaitForChild("PlayerGui")

local inset = GuiService:GetGuiInset()

-- Toggle button
local chatButton = Instance.new("TextButton")
chatButton.Name = "ChatToggle"
chatButton.Size = UDim2.fromOffset(44, 44)
chatButton.Position = UDim2.fromOffset(10, inset.Y + 10)
chatButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
chatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
chatButton.Text = "💬"
chatButton.TextSize = 22
chatButton.BorderSizePixel = 0
chatButton.Parent = gui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = chatButton

-- Main chat frame
local chatFrame = Instance.new("Frame")
chatFrame.Name = "ChatFrame"
chatFrame.Size = UDim2.fromOffset(520, 280)
chatFrame.Position = UDim2.fromOffset(10, inset.Y + 64)
chatFrame.BackgroundColor3 = Color3.fromRGB(55, 70, 85)
chatFrame.BorderSizePixel = 0
chatFrame.Visible = false
chatFrame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = chatFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 2
frameStroke.Transparency = 0.35
frameStroke.Parent = chatFrame

-- Messages list
local messages = Instance.new("ScrollingFrame")
messages.Name = "Messages"
messages.BackgroundTransparency = 1
messages.BorderSizePixel = 0
messages.Position = UDim2.fromOffset(10, 10)
messages.Size = UDim2.new(1, -20, 1, -62)
messages.ScrollBarThickness = 6
messages.ScrollBarImageTransparency = 0.4
messages.CanvasSize = UDim2.fromOffset(0, 0)
messages.AutomaticCanvasSize = Enum.AutomaticSize.None
messages.Parent = chatFrame

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 2)
pad.PaddingRight = UDim.new(0, 2)
pad.PaddingTop = UDim.new(0, 2)
pad.PaddingBottom = UDim.new(0, 6)
pad.Parent = messages

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = messages

-- Input bar background
local inputBar = Instance.new("Frame")
inputBar.Name = "InputBar"
inputBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBar.BorderSizePixel = 0
inputBar.Position = UDim2.new(0, 10, 1, -44)
inputBar.Size = UDim2.new(1, -20, 0, 34)
inputBar.Parent = chatFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = inputBar

local inputStroke = Instance.new("UIStroke")
inputStroke.Thickness = 2
inputStroke.Transparency = 0.55
inputStroke.Parent = inputBar

-- TextBox
local box = Instance.new("TextBox")
box.Name = "ChatBox"
box.BackgroundTransparency = 1
box.BorderSizePixel = 0
box.Position = UDim2.fromOffset(12, 0)
box.Size = UDim2.new(1, -60, 1, 0)
box.PlaceholderText = "To chat click here or press / key"
box.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
box.Text = ""
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.TextSize = 16
box.Font = Enum.Font.Gotham
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.Parent = inputBar

-- Send button
local send = Instance.new("TextButton")
send.Name = "Send"
send.BackgroundTransparency = 1
send.BorderSizePixel = 0
send.Size = UDim2.fromOffset(40, 34)
send.Position = UDim2.new(1, -40, 0, 0)
send.Text = "➤"
send.TextSize = 22
send.Font = Enum.Font.GothamBold
send.TextColor3 = Color3.fromRGB(210, 210, 210)
send.Parent = inputBar

-- Toggle open/close
chatButton.MouseButton1Click:Connect(function()
	chatFrame.Visible = not chatFrame.Visible
	if chatFrame.Visible then
		box:CaptureFocus()
	end
end)

-- Slash key opens like Roblox
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Slash then
		chatFrame.Visible = true
		box:CaptureFocus()
	end
end)

--========================
-- UI MESSAGE BUBBLES
--========================
local function addUImessage(text)
	local bubble = Instance.new("Frame")
	bubble.BackgroundColor3 = Color3.fromRGB(35, 40, 48)
	bubble.BorderSizePixel = 0
	bubble.AutomaticSize = Enum.AutomaticSize.Y
	bubble.Size = UDim2.new(1, -10, 0, 0)
	bubble.Parent = messages

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 12)
	c.Parent = bubble

	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, 10)
	p.PaddingRight = UDim.new(0, 10)
	p.PaddingTop = UDim.new(0, 8)
	p.PaddingBottom = UDim.new(0, 8)
	p.Parent = bubble

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextWrapped = true
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Size = UDim2.new(1, 0, 0, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextColor3 = Color3.fromRGB(240, 240, 240)
	label.Text = player.Name .. ": " .. text
	label.Parent = bubble

	task.wait()
	messages.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
	messages.CanvasPosition = Vector2.new(0, math.max(0, messages.CanvasSize.Y.Offset - messages.AbsoluteWindowSize.Y))
end

--========================
-- OVERHEAD SPEECH BUBBLE
--========================
local function showOverhead(text)
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:WaitForChild("Head")

	-- Remove existing bubble
	local old = head:FindFirstChild("CustomBubble")
	if old then old:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CustomBubble"
	billboard.Adornee = head
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, 3.25, 0)
	billboard.MaxDistance = 70
	billboard.Size = UDim2.fromScale(5, 2)
	billboard.Parent = head

	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame.BorderSizePixel = 0
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Transparency = 0.2
	stroke.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.Parent = frame

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextWrapped = true
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Size = UDim2.new(1, 0, 0, 0)
	label.Font = Enum.Font.GothamBlack
	label.TextSize = 28
	label.TextColor3 = Color3.fromRGB(0, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Text = text
	label.Parent = frame

	task.delay(3.5, function()
		if billboard and billboard.Parent then
			billboard:Destroy()
		end
	end)
end

--========================
-- SENDING
--========================
local function sendMessage()
	local text = box.Text
	if not text or text:gsub("%s+", "") == "" then
		return
	end

	addUImessage(text)
	showOverhead(text)

	box.Text = ""
	box:CaptureFocus()
end

send.MouseButton1Click:Connect(sendMessage)

box.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		sendMessage()
	end
end)

-- Clean bubble on respawn
player.CharacterAdded:Connect(function(char)
	local head = char:WaitForChild("Head")
	local old = head:FindFirstChild("CustomBubble")
	if old then old:Destroy() end
end)
