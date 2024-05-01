local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local GuiLib = require(script.Parent.Parent.GuiLib)

local Window = GuiLib.CreateWindow("Player List")
Window.Size = UDim2.new(0.5, 0, 0.5, 0)
Window.Position = UDim2.new(0.5, 0, 0.5, 0)
Window.Draggable = true
Window.Title = "Player List"

local PlayersPerPage = 10
local CurrentPage = 1
local TotalPages = math.ceil(Players.NumPlayers / PlayersPerPage)

local function UpdatePlayerList()
    local PlayerList = Window:FindFirstChild("PlayerList")
    if PlayerList then
        PlayerList.Parent = nil
    end

    PlayerList = Instance.new("Frame")
    PlayerList.Name = "PlayerList"
    PlayerList.Size = UDim2.new(1, 0, 1, 0)
    PlayerList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PlayerList.BorderSizePixel = 0
    PlayerList.Parent = Window

    local PlayersOnPage = {}

    for i, player in ipairs(Players:GetPlayers()) do
        if i > (CurrentPage - 1) * PlayersPerPage and i <= CurrentPage * PlayersPerPage then
            local PlayerFrame = Instance.new("Frame")
            PlayerFrame.Name = "PlayerFrame"
            PlayerFrame.Size = UDim2.new(1, 0, 0, 100)
            PlayerFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            PlayerFrame.BorderSizePixel = 0
            PlayerFrame.Parent = PlayerList

            local PlayerImage = Instance.new("ImageLabel")
            PlayerImage.Name = "PlayerImage"
            PlayerImage.Size = UDim2.new(0.2, 0, 1, 0)
            PlayerImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            PlayerImage.BorderSizePixel = 0
            PlayerImage.Image = player.Avatar:FindFirstChild("Headshot").Image
            PlayerImage.ImageTransparency = 0.5
            PlayerImage.Parent = PlayerFrame

            local PlayerDisplayName = Instance.new("TextLabel")
            PlayerDisplayName.Name = "PlayerDisplayName"
            PlayerDisplayName.Size = UDim2.new(0.8, 0, 1, 0)
            PlayerDisplayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            PlayerDisplayName.BorderSizePixel = 0
            PlayerDisplayName.Font = Enum.Font.SourceSans
            PlayerDisplayName.Text = player.DisplayName
            PlayerDisplayName.TextColor3 = Color3.fromRGB(0, 0, 0)
            PlayerDisplayName.TextSize = 14
            PlayerDisplayName.Parent = PlayerFrame

            local SendFriendRequestButton = Instance.new("TextButton")
            SendFriendRequestButton.Name = "SendFriendRequestButton"
            SendFriendRequestButton.Size = UDim2.new(0.8, 0, 0, 30)
            SendFriendRequestButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
            SendFriendRequestButton.BorderSizePixel = 0
            SendFriendRequestButton.Font = Enum.Font.SourceSans
            SendFriendRequestButton.Text = "Send Friend Request"
            SendFriendRequestButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            SendFriendRequestButton.TextSize = 14
            SendFriendRequestButton.Parent = PlayerFrame
            SendFriendRequestButton.MouseButton1Click:Connect(function()
                player.FriendRequestSent:Connect(function()
                    SendFriendRequestButton.Text = "Friend Request Sent"
                    SendFriendRequestButton.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
                end)
                player:SendFriendRequest()
            end)
        end
    end

    local Pagination = Instance.new("Frame")
    Pagination.Name = "Pagination"
    Pagination.Size = UDim2.new(1, 0, 0, 30)
    Pagination.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Pagination.BorderSizePixel = 0
    Pagination.Parent = Window

    local PreviousPageButton = Instance.new("TextButton")
    PreviousPageButton.Name = "PreviousPageButton"
    PreviousPageButton.Size = UDim2.new(0, 50, 0, 30)
    PreviousPageButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    PreviousPageButton.BorderSizePixel = 0
    PreviousPageButton.Font = Enum.Font.SourceSans
    PreviousPageButton.Text = "<"
    PreviousPageButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    PreviousPageButton.TextSize= 14
    PreviousPageButton.Parent = Pagination
    PreviousPageButton.MouseButton1Click:Connect(function()
        if CurrentPage > 1 then
            CurrentPage = CurrentPage - 1
            UpdatePlayerList()
        end
    end)

    local PageLabel = Instance.new("TextLabel")
    PageLabel.Name = "PageLabel"
    PageLabel.Size = UDim2.new(0, 50, 0, 30)
    PageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PageLabel.BorderSizePixel = 0
    PageLabel.Font = Enum.Font.SourceSans
    PageLabel.Text = "Page " .. CurrentPage .. " of " .. TotalPages
    PageLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    PageLabel.TextSize = 14
    PageLabel.Parent = Pagination

    local NextPageButton = Instance.new("TextButton")
    NextPageButton.Name = "NextPageButton"
    NextPageButton.Size = UDim2.new(0, 50, 0, 30)
    NextPageButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    NextPageButton.BorderSizePixel = 0
    NextPageButton.Font = Enum.Font.SourceSans
    NextPageButton.Text = ">"
    NextPageButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    NextPageButton.TextSize = 14
    NextPageButton.Parent = Pagination
    NextPageButton.MouseButton1Click:Connect(function()
        if CurrentPage < TotalPages then
            CurrentPage = CurrentPage + 1
            UpdatePlayerList()
        end
    end)

    Window.Parent = game.CoreGui
end

RunService.Heartbeat:Connect(function()
    UpdatePlayerList()
end)
