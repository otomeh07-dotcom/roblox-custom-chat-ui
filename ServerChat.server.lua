--// ServerChat.server.lua
--// Creates overhead bubbles that EVERYONE can see

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- RemoteEvent
local event = ReplicatedStorage:FindFirstChild("OverheadChatEvent")
if not event then
	event = Instance.new("RemoteEvent")
	event.Name = "OverheadChatEvent"
	event.Parent = ReplicatedStorage
end

event.OnServerEvent:Connect(function(player, text)
	if typeof(text) ~= "string" or text:match("^%s*$") then
		return
	end

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
	billboard.StudsOffset = Vector3.new(0, 3.3, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 80
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
	label.Font = Enum.Font.GothamBlack
	label.TextSize = 26
	label.TextColor3 = Color3.fromRGB(0, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.Text = text
	label.Parent = frame

	task.delay(4, function()
		if billboard then
			billboard:Destroy()
		end
	end)
end)
