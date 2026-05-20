local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local coreGui = game:GetService("CoreGui") or game.CoreGui

local NotifyModule = {}

local RandomGuiName = HttpService:GenerateGUID(false)

local NotifContainer = (function()
	if getgenv and getgenv().LudminNotifInstance then
		local old = getgenv().LudminNotifInstance
		local ok, container = pcall(function()
			return old and old.Parent and old:FindFirstChild("NotifContainer")
		end)
		if ok and container then 
			return container 
		end
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = RandomGuiName
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 9999
	
	local success = pcall(function() screenGui.Parent = coreGui end)
	if not success then screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

	if getgenv then
		getgenv().LudminNotifInstance = screenGui
	end

	local container = Instance.new("Frame", screenGui)
	container.Name = "NotifContainer"
	container.Size = UDim2.new(0, 260, 1, -20)
	container.Position = UDim2.new(1, -270, 0, 10)
	container.BackgroundTransparency = 1

	local listLayout = Instance.new("UIListLayout", container)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	listLayout.Padding = UDim.new(0, 8)

	return container
end)()

local TypeColors = {
	info = Color3.fromRGB(0, 140, 255),
	success = Color3.fromRGB(10, 215, 95),
	warn = Color3.fromRGB(255, 175, 0),
	error = Color3.fromRGB(255, 70, 70)
}

function NotifyModule:Notify(config)
	if type(config) == "string" then
		config = { title = arguments[1], body = arguments[2], type = arguments[3], duration = arguments[4] }
	end
	
	local titleText = config.title or "System"
	local bodyText = config.body or ""
	local notifType = (config.type or "info"):lower()
	local duration = config.duration or 3
	
	local accentColor = TypeColors[notifType] or TypeColors.info
	local timestamp = os.date("%X")
	local closeIconId, systemFont = "rbxassetid://110786993356448", Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

	local NotifCard = Instance.new("Frame")
	NotifCard.Name = "Notification_" .. HttpService:GenerateGUID(false):sub(1, 6)
	NotifCard.Size = UDim2.new(1, 0, 0, 0)
	NotifCard.AutomaticSize = Enum.AutomaticSize.Y
	NotifCard.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
	NotifCard.BackgroundTransparency = 1 
	NotifCard.BorderSizePixel = 0
	NotifCard.Position = UDim2.new(1, 50, 0, 0)
	NotifCard.Parent = NotifContainer

	Instance.new("UICorner", NotifCard).CornerRadius = UDim.new(0, 10)

	local notifStroke = Instance.new("UIStroke", NotifCard)
	notifStroke.Color = Color3.fromRGB(25, 25, 25)
	notifStroke.Thickness = 1
	notifStroke.Transparency = 1

	local notifPad = Instance.new("UIPadding", NotifCard)
	notifPad.PaddingTop = UDim.new(0, 12)
	notifPad.PaddingBottom = UDim.new(0, 12)
	notifPad.PaddingLeft = UDim.new(0, 12)
	notifPad.PaddingRight = UDim.new(0, 12)

	local mainLayout = Instance.new("UIListLayout", NotifCard)
	mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
	mainLayout.Padding = UDim.new(0, 6)

	local HeaderFrame = Instance.new("Frame", NotifCard)
	HeaderFrame.Name = "Header"
	HeaderFrame.Size = UDim2.new(1, 0, 0, 16)
	HeaderFrame.BackgroundTransparency = 1
	HeaderFrame.LayoutOrder = 1

	local headerLayout = Instance.new("UIListLayout", HeaderFrame)
	headerLayout.FillDirection = Enum.FillDirection.Horizontal
	headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	headerLayout.Padding = UDim.new(0, 6)

	local Bullet = Instance.new("Frame", HeaderFrame)
	Bullet.Name = "Bullet"
	Bullet.Size = UDim2.fromOffset(6, 6)
	Bullet.BackgroundColor3 = accentColor
	Bullet.BackgroundTransparency = 1
	Bullet.BorderSizePixel = 0
	Bullet.LayoutOrder = 1
	Instance.new("UICorner", Bullet).CornerRadius = UDim.new(1, 0)

	local TitleLabel = Instance.new("TextLabel", HeaderFrame)
	TitleLabel.Name = "Title"
	TitleLabel.Size = UDim2.new(1, -77, 1, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = titleText
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextTransparency = 1
	TitleLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	TitleLabel.TextSize = 13
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	TitleLabel.RichText = true
	TitleLabel.LayoutOrder = 2

	local TimeLabel = Instance.new("TextLabel", HeaderFrame)
	TimeLabel.Name = "Time"
	TimeLabel.Size = UDim2.new(0, 45, 1, 0)
	TimeLabel.BackgroundTransparency = 1
	TimeLabel.Text = timestamp
	TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TimeLabel.TextTransparency = 1
	TimeLabel.FontFace = systemFont
	TimeLabel.TextSize = 11
	TimeLabel.TextXAlignment = Enum.TextXAlignment.Right
	TimeLabel.LayoutOrder = 3
	
	local CloseBtn = Instance.new("ImageButton", HeaderFrame)
	CloseBtn.Name = "CloseBtn"
	CloseBtn.Size = UDim2.fromOffset(12, 12)
	CloseBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Image = closeIconId
	CloseBtn.ImageTransparency = 1
	CloseBtn.ScaleType = Enum.ScaleType.Fit
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.LayoutOrder = 4

	local BodyLabel = Instance.new("TextLabel", NotifCard)
	BodyLabel.Name = "Body"
	BodyLabel.Size = UDim2.new(1, 0, 0, 0)
	BodyLabel.AutomaticSize = Enum.AutomaticSize.Y
	BodyLabel.BackgroundTransparency = 1
	BodyLabel.Text = bodyText
	BodyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	BodyLabel.TextTransparency = 1
	BodyLabel.FontFace = systemFont
	BodyLabel.TextSize = 12
	BodyLabel.TextXAlignment = Enum.TextXAlignment.Left
	BodyLabel.TextWrapped = true
	BodyLabel.RichText = true
	BodyLabel.LayoutOrder = 2

	local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TweenService:Create(NotifCard, tweenInfo, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.06}):Play()
	TweenService:Create(notifStroke, tweenInfo, {Transparency = 0}):Play()
	TweenService:Create(Bullet, tweenInfo, {BackgroundTransparency = 0}):Play()
	TweenService:Create(TitleLabel, tweenInfo, {TextTransparency = 0}):Play()
	TweenService:Create(TimeLabel, tweenInfo, {TextTransparency = 0.6}):Play()
	TweenService:Create(CloseBtn, tweenInfo, {ImageTransparency = 0.6}):Play()
	TweenService:Create(BodyLabel, tweenInfo, {TextTransparency = 0.35}):Play()

	local isClosing = false
	local function DismissNotification()
		if isClosing then return end
		isClosing = true

		local closeTween = TweenService:Create(NotifCard, tweenInfo, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1})
		TweenService:Create(notifStroke, tweenInfo, {Transparency = 1}):Play()
		TweenService:Create(Bullet, tweenInfo, {BackgroundTransparency = 1}):Play()
		TweenService:Create(TitleLabel, tweenInfo, {TextTransparency = 1}):Play()
		TweenService:Create(TimeLabel, tweenInfo, {TextTransparency = 1}):Play()
		TweenService:Create(CloseBtn, tweenInfo, {ImageTransparency = 1}):Play()
		TweenService:Create(BodyLabel, tweenInfo, {TextTransparency = 1}):Play()
		
		closeTween:Play()
		closeTween.Completed:Connect(function()
			NotifCard:Destroy()
		end)
	end

	CloseBtn.MouseButton1Click:Connect(DismissNotification)
	task.delay(duration, DismissNotification)
	
	return NotifCard
end

return NotifyModule

