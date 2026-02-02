--// UNIVERSAL CHAT SCRIPT (SERVER + CLIENT)
--// Put the SAME script in:
--// 1) ServerScriptService
--// 2) StarterPlayerScripts

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--==============================
-- SERVER SIDE
--==============================
if RunService:IsServer() then
	-- RemoteEvent
	local event = ReplicatedStorage:FindFirstChild("OverheadChatEvent")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "OverheadChatEvent"
		event.Parent = ReplicatedStorage
	end

	event.OnServerEvent:Connect(function(player, text)
		if type(text) ~= "string" or text == "" then return end

		local char = player.Character
		if not char then return end
		local head = char:FindFirstChild("Head")
		if not head then return end

		-- Remove old bubble
		local old = head:FindFirstChild("ServerBubble")
		if old then old:Destroy() end

		local billboard = Instance.new("BillboardGui")
		billboard.Name = "ServerBubble"
		billboard.Adornee = head
		billboard.Size = UDim2.fromScale(5, 2)
		billboard.StudsOffset = Vector3.new(0, 3.2, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = head

		local frame = Instance.new("Frame")
		frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame.BorderSizePixel = 0
		frame.AutomaticSize = Enum.AutomaticSize.Y
		frame.Size = UDim2.new(1, 0, 0, 0)
		frame.Parent = billboard

		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 12)
		pad.PaddingRight = UDim.new(0, 12)
		pad.PaddingTop = UDim.new(0, 8)
		pad.PaddingBottom = UDim.new(0, 8)
		pad.Parent = frame

		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.TextWrapped = true
		label.AutomaticSize = Enum.AutomaticSize.Y
		label.Size = UDim2.new(1, 0, 0, 0)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 26
		label.TextColor3 = Color3.fromRGB(0, 0, 0)
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.Text = text
		label.Parent = frame

		task.delay(4, function()
			if billboard then billboard:Destroy() end
		end)
	end)

	return
end

--==============================
-- CLIENT SIDE
--==============================
local player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local event = ReplicatedStorage:WaitForChild("OverheadChatEvent")

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "ChatUI"
gui.Parent = player:WaitForChild("PlayerGui")

local inset = GuiService:GetGuiInset()

local box = Instance.new("TextBox")
box.Size = UDim2.fromOffset(300, 40)
box.Position = UDim2.fromOffset(10, inset.Y + 10)
box.PlaceholderText = "Type message and press Enter"
box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.ClearTextOnFocus = false
box.Parent = gui

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)

box.FocusLost:Connect(function(enter)
	if enter and box.Text ~= "" then
		event:FireServer(box.Text)
		box.Text = ""
	end
end)

