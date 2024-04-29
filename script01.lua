-- Script para criar um GUI no Roblox com funcionalidades avançadas

-- Função para atualizar a lista de jogadores
local function atualizarLista(jogadores, pagina, listaJogadoresGui)
    listaJogadoresGui:ClearAllChildren()
    for i = 1, 20 do
        local indice = (pagina - 1) * 20 + i
        local jogador = jogadores[indice]
        if jogador then
            local PlayerFrame = Instance.new("Frame")
            local PlayerImage = Instance.new("ImageLabel")
            local PlayerName = Instance.new("TextButton")

            -- Configurações do Frame do jogador
            PlayerFrame.Parent = listaJogadoresGui
            PlayerFrame.Size = UDim2.new(1, 0, 0, 50)
            PlayerFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            PlayerFrame.BorderSizePixel = 0

            -- Configurações da Imagem do jogador
            PlayerImage.Parent = PlayerFrame
            PlayerImage.Size = UDim2.new(0, 40, 0, 40)
            PlayerImage.Position = UDim2.new(0, 5, 0.5, -20)
            PlayerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. jogador.UserId .. "&w=150&h=150"
            PlayerImage.ClipsDescendants = true
            PlayerImage.BackgroundTransparency = 1
            PlayerImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
            PlayerImage.ImageTransparency = 0.1

            -- Configurações do Nome do jogador
            PlayerName.Parent = PlayerFrame
            PlayerName.Text = jogador.DisplayName
            PlayerName.Size = UDim2.new(0, 200, 1, 0)
            PlayerName.Position = UDim2.new(0, 50, 0, 0)
            PlayerName.BackgroundTransparency = 1
            PlayerName.TextColor3 = Color3.fromRGB(0, 0, 0)

            -- Evento de clique para enviar pedido de amizade
            PlayerName.MouseButton1Click:Connect(function()
                game.Players.LocalPlayer:RequestFriendship(jogador)
            end)
        end
    end
end

-- Obtenha todos os jogadores e defina a página inicial
local jogadores = game.Players:GetPlayers()
local paginaAtual = 1

-- Crie o GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local listaJogadoresGui = Instance.new("ScrollingFrame")
local NextPageButton = Instance.new("TextButton")
local PreviousPageButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local DraggableArea = Instance.new("Frame")

-- Defina as propriedades do Frame
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 300)
Frame.Position = UDim2.new(0.5, -150, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Draggable = true
Frame.ClipsDescendants = true
Frame.CornerRadius = UDim.new(0, 8)

-- Defina as propriedades do DraggableArea
DraggableArea.Parent = Frame
DraggableArea.Size = UDim2.new(1, 0, 0, 30)
DraggableArea.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DraggableArea.Active = true -- Permite mover o Frame

-- Defina as propriedades do listaJogadoresGui
listaJogadoresGui.Parent = Frame
listaJogadoresGui.Size = UDim2.new(0, 280, 0, 240)
listaJogadoresGui.Position = UDim2.new(0, 10, 0, 40)
listaJogadoresGui.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
listaJogadoresGui.ScrollBarThickness = 6

-- Defina as propriedades do NextPageButton
NextPageButton.Parent = Frame
NextPageButton.Text = ">"
NextPageButton.Size = UDim2.new(0, 30, 0, 30)
NextPageButton.Position = UDim2.new(0, 260, 0, 260)
NextPageButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- Defina as propriedades do PreviousPageButton
PreviousPageButton.Parent = Frame
PreviousPageButton.Text = "<"
PreviousPageButton.Size = UDim2.new(0, 30, 0, 30)
PreviousPageButton.Position = UDim2.new(0, 10, 0, 260)
PreviousPageButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- Defina as propriedades do MinimizeButton
MinimizeButton.Parent = DraggableArea
MinimizeButton.Text = "_"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- Adicione o ScreenGui ao jogador local
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Conecte a função ao evento de clique do NextPageButton
NextPageButton.MouseButton1Click:Connect(function()
    paginaAtual = paginaAtual + 1
    if paginaAtual > #jogadores / 20 then
        paginaAtual = 1
    end
    atualizarLista(jogadores, paginaAtual, listaJogadoresGui)
end)

-- Conecte a função ao evento de clique do PreviousPageButton
PreviousPageButton.MouseButton1Click:Connect(function()
    paginaAtual = paginaAtual - 1
    if paginaAtual < 1 then
        paginaAtual = math.ceil(#jogadores / 20)
    end
    atualizarLista(jogadores, paginaAtual, listaJogadoresGui)
end)

-- Conecte a função ao evento de clique do MinimizeButton
MinimizeButton.MouseButton1Click:Connect(function()
    if Frame.Size == UDim2.new(0, 300, 0, 300) then
        Frame.Size = UDim2.new(0, 300, 0, 30)
        listaJogadoresGui.Visible = false
        NextPageButton.Visible = false
        PreviousPageButton.Visible = false
    else
        Frame.Size = UDim2.new(0, 300, 0, 300)
        listaJogadoresGui.Visible = true
        NextPageButton.Visible = true
        PreviousPageButton.Visible = true
    end
end)

-- Atualize a lista automaticamente quando novos jogadores entrarem
game.Players.PlayerAdded:Connect(function()
    jogadores = game.Players:GetPlayers()
    atualizarLista(jogadores, paginaAtual, listaJogadoresGui)
end)