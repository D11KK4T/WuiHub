--[[
    ██╗    ██╗██╗   ██╗██╗██╗  ██╗██╗   ██╗██████╗ 
    ██║    ██║██║   ██║██║██║  ██║██║   ██║██╔══██╗
    ██║ █╗ ██║██║   ██║██║███████║██║   ██║██████╔╝
    ██║███╗██║██║   ██║██║██╔══██║██║   ██║██╔══██╗
    ╚███╔███╔╝╚██████╔╝██║██║  ██║╚██████╔╝██████╔╝
     ╚══╝╚══╝  ╚═════╝ ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    WuiHub v2.0
    Developer  : Wui
    GitHub     : https://github.com/D11KK4T/WuiHub
    
    Kullanım   : loadstring(game:HttpGet("https://raw.githubusercontent.com/D11KK4T/WuiHub/main/WuiHub.lua"))()
]]

-- ==================== VERSİYON KONTROLÜ ====================
local WUIHUB_VERSION = "2.0"
local WUIHUB_AUTHOR  = "Wui"
local WUIHUB_GITHUB  = "https://github.com/D11KK4T/WuiHub"

-- Executor uyumluluk kontrolü
local function checkExecutor()
    if not game or not game:GetService then
        error("[WuiHub] Geçersiz ortam!")
    end
    -- request / http_request / syn.request desteği
    if not (request or http_request or (syn and syn.request) or (http and http.request)) then
        warn("[WuiHub] Uyarı: HTTP request fonksiyonu bulunamadı. Webhook çalışmayabilir.")
    end
end
pcall(checkExecutor)

-- ==================== SCRIPT BAŞLANGIÇ ====================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local character, humanoid, rootPart
local function updateCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end
updateCharacter()
player.CharacterAdded:Connect(updateCharacter)

local keyVerified = false

-- ==================== DİL SİSTEMİ ====================
local currentLang = "TR"
local langs = {
    TR = {
        title="⚡ WuiHub", about="HAKKINDA", connections="BAĞLANTILAR",
        discord="🎮 Discord'a Katıl", freekey="🔑 Ücretsiz Key Al", premium="⭐ Premium Al",
        noclip_off="👻 Noclip: KAPALI", noclip_on="👻 Noclip: AÇIK",
        speed="HIZ", speed_off="KAPALI", speed_on="AÇIK",
        superjump_off="🦘 SuperJump: KAPALI", superjump_on="🦘 SuperJump: AÇIK",
        fly_off="🕊️ Fly: KAPALI", fly_on="🕊️ Fly: AÇIK",
        fly_hint="W/A/S/D + Space(yüksel) + Ctrl(alçal)",
        fly_speed="FLY HIZI",
        tp_section="PET SIM 99 - AŞAMA TELEPORT",
        tp_info="📌 = Sabit koordinat  |  🔍 = Otomatik tarama",
        stages="AŞAMALAR", tools="KONUM ARAÇLARI",
        print_pos="📍 Mevcut Konumu Yazdır", printed="✓ Konsola Yazdırıldı!",
        scan_spawn="🔍 Tüm SpawnLocation'ları Tara", scanning="⏳ Taranıyor...",
        found="✓ %d SpawnLocation Bulundu",
        misc_section="PERFORMANS",
        fps_boost="🚀 FPS Boost: KAPALI", fps_boost_on="🚀 FPS Boost: AÇIK",
        low_detail="🎨 Düşük Detay: KAPALI", low_detail_on="🎨 Düşük Detay: AÇIK",
        hide_players="👥 Oyuncuları Gizle: KAPALI", hide_players_on="👥 Oyuncuları Gizle: AÇIK",
        hide_shadows="🌑 Gölgeleri Kaldır: KAPALI", hide_shadows_on="🌑 Gölgeleri Kaldır: AÇIK",
        hide_particles="✨ Efektleri Kaldır: KAPALI", hide_particles_on="✨ Efektleri Kaldır: AÇIK",
        max_fps="🖥️ Max FPS Kilidi: KAPALI", max_fps_on="🖥️ Max FPS Kilidi: AÇIK",
        settings_section="AYARLAR", toggle_key="Hub Açma Tuşu",
        opacity_label="Hub Saydamlığı", webhook_label="Discord Webhook URL",
        webhook_btn="📤 Webhook Gönder", webhook_sent="✓ Gönderildi!", webhook_fail="✗ Hata!",
        key_placeholder="🔑 Key girin...", key_wrong="❌ Yanlış key!", verify="✅ Doğrula",
        free_btn="🆓 FREE", about_text="WuiHub\nVersiyon: 2.0\nGeliştirici: Wui",
        farm_section="AUTO FARM",
        farm_start="🏆 Auto Kazanma: KAPALI", farm_stop="🏆 Auto Kazanma: AÇIK",
        farm_stage="Hedef Aşama",
        farm_method="Yöntem",
        farm_tp="Işınla (Hızlı)", farm_walk="Yürüyerek (Güvenli)",
        farm_status="Durum: Bekleniyor",
        farm_delay="Döngü Gecikmesi (sn)",
    },
    EN = {
        title="⚡ WuiHub", about="ABOUT", connections="LINKS",
        discord="🎮 Join Discord", freekey="🔑 Get Free Key", premium="⭐ Get Premium",
        noclip_off="👻 Noclip: OFF", noclip_on="👻 Noclip: ON",
        speed="SPEED", speed_off="OFF", speed_on="ON",
        superjump_off="🦘 SuperJump: OFF", superjump_on="🦘 SuperJump: ON",
        fly_off="🕊️ Fly: OFF", fly_on="🕊️ Fly: ON",
        fly_hint="W/A/S/D + Space(up) + Ctrl(down)",
        fly_speed="FLY SPEED",
        tp_section="PET SIM 99 - STAGE TELEPORT",
        tp_info="📌 = Fixed coords  |  🔍 = Auto scan",
        stages="STAGES", tools="LOCATION TOOLS",
        print_pos="📍 Print Current Position", printed="✓ Printed to Console!",
        scan_spawn="🔍 Scan All SpawnLocations", scanning="⏳ Scanning...",
        found="✓ %d SpawnLocations Found",
        misc_section="PERFORMANCE",
        fps_boost="🚀 FPS Boost: OFF", fps_boost_on="🚀 FPS Boost: ON",
        low_detail="🎨 Low Detail: OFF", low_detail_on="🎨 Low Detail: ON",
        hide_players="👥 Hide Players: OFF", hide_players_on="👥 Hide Players: ON",
        hide_shadows="🌑 Remove Shadows: OFF", hide_shadows_on="🌑 Remove Shadows: ON",
        hide_particles="✨ Remove Effects: OFF", hide_particles_on="✨ Remove Effects: ON",
        max_fps="🖥️ Max FPS Lock: OFF", max_fps_on="🖥️ Max FPS Lock: ON",
        settings_section="SETTINGS", toggle_key="Hub Toggle Key",
        opacity_label="Hub Opacity", webhook_label="Discord Webhook URL",
        webhook_btn="📤 Send Webhook", webhook_sent="✓ Sent!", webhook_fail="✗ Error!",
        key_placeholder="🔑 Enter key...", key_wrong="❌ Wrong key!", verify="✅ Verify",
        free_btn="🆓 FREE", about_text="WuiHub\nVersion: 2.0\nDeveloper: Wui",
        farm_section="AUTO FARM",
        farm_start="🏆 Auto Win: OFF", farm_stop="🏆 Auto Win: ON",
        farm_stage="Target Stage",
        farm_method="Method",
        farm_tp="Teleport (Fast)", farm_walk="Walk (Safe)",
        farm_status="Status: Waiting",
        farm_delay="Loop Delay (s)",
    },
    RU = {
        title="⚡ WuiHub", about="О ПРОГРАММЕ", connections="ССЫЛКИ",
        discord="🎮 Войти в Discord", freekey="🔑 Получить ключ", premium="⭐ Получить Premium",
        noclip_off="👻 Noclip: ВЫКЛ", noclip_on="👻 Noclip: ВКЛ",
        speed="СКОРОСТЬ", speed_off="ВЫКЛ", speed_on="ВКЛ",
        superjump_off="🦘 СуперПрыжок: ВЫКЛ", superjump_on="🦘 СуперПрыжок: ВКЛ",
        fly_off="🕊️ Полёт: ВЫКЛ", fly_on="🕊️ Полёт: ВКЛ",
        fly_hint="W/A/S/D + Space(вверх) + Ctrl(вниз)",
        fly_speed="СКОРОСТЬ ПОЛЁТА",
        tp_section="PET SIM 99 - ТЕЛЕПОРТ",
        tp_info="📌 = Координата  |  🔍 = Авто поиск",
        stages="ЭТАПЫ", tools="ИНСТРУМЕНТЫ",
        print_pos="📍 Вывести позицию", printed="✓ Выведено в консоль!",
        scan_spawn="🔍 Сканировать SpawnLocation", scanning="⏳ Сканирование...",
        found="✓ %d SpawnLocation найдено",
        misc_section="ПРОИЗВОДИТЕЛЬНОСТЬ",
        fps_boost="🚀 Ускор. FPS: ВЫКЛ", fps_boost_on="🚀 Ускор. FPS: ВКЛ",
        low_detail="🎨 Низкий Детализм: ВЫКЛ", low_detail_on="🎨 Низкий Детализм: ВКЛ",
        hide_players="👥 Скрыть игроков: ВЫКЛ", hide_players_on="👥 Скрыть игроков: ВКЛ",
        hide_shadows="🌑 Убрать тени: ВЫКЛ", hide_shadows_on="🌑 Убрать тени: ВКЛ",
        hide_particles="✨ Убрать эффекты: ВЫКЛ", hide_particles_on="✨ Убрать эффекты: ВКЛ",
        max_fps="🖥️ Лимит FPS: ВЫКЛ", max_fps_on="🖥️ Лимит FPS: ВКЛ",
        settings_section="НАСТРОЙКИ", toggle_key="Клавиша открытия Hub",
        opacity_label="Прозрачность Hub", webhook_label="Discord Webhook URL",
        webhook_btn="📤 Отправить Webhook", webhook_sent="✓ Отправлено!", webhook_fail="✗ Ошибка!",
        key_placeholder="🔑 Введите ключ...", key_wrong="❌ Неверный ключ!", verify="✅ Подтвердить",
        free_btn="🆓 БЕСПЛАТНО", about_text="WuiHub\nВерсия: 2.0\nРазработчик: Wui",
        farm_section="АВТО ФАРМ",
        farm_start="🏆 Авто Победа: ВЫКЛ", farm_stop="🏆 Авто Победа: ВКЛ",
        farm_stage="Целевой Этап",
        farm_method="Метод",
        farm_tp="Телепорт (Быстро)", farm_walk="Ходьба (Безопасно)",
        farm_status="Статус: Ожидание",
        farm_delay="Задержка цикла (с)",
    },
}
local function t(k) return langs[currentLang][k] or langs["TR"][k] or k end

-- ==================== GUI ====================
local gui = Instance.new("ScreenGui")
gui.Name = "WUIHUB_MAIN"
gui.ResetOnSpawn = false
gui.Enabled = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- ==================== YARDIMCI ====================
local function makeCorner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end
local function makeStroke(parent, col, thick)
    local s = Instance.new("UIStroke", parent)
    s.Color = col or Color3.fromRGB(255,200,50)
    s.Thickness = thick or 1.5
    return s
end
local function makeBtn(parent, text, w, h, bg, fg)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.fromOffset(w, h)
    b.Text = text
    b.BackgroundColor3 = bg or Color3.fromRGB(35,35,55)
    b.TextColor3 = fg or Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BorderSizePixel = 0
    makeCorner(b, 6)
    return b
end
local function addToggleBtn(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,-4,0,40)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(35,35,55)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.BorderSizePixel = 0
    makeCorner(b, 8)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end
local function addSection(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1,-4,0,24)
    lbl.Text = "— " .. text .. " —"
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255,80,80)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    return lbl
end
local function makeSlider(parent, initialVal, maxVal, markers, onChanged)
    local box = Instance.new("Frame", parent)
    box.Size = UDim2.new(1,-4,0,52)
    box.BackgroundColor3 = Color3.fromRGB(25,25,40)
    box.BorderSizePixel = 0
    makeCorner(box, 8)
    local track = Instance.new("Frame", box)
    track.Size = UDim2.new(1,-16,0,12)
    track.Position = UDim2.fromOffset(8,10)
    track.BackgroundColor3 = Color3.fromRGB(40,40,60)
    track.BorderSizePixel = 0
    makeCorner(track, 6)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.fromScale(initialVal/maxVal, 1)
    fill.BackgroundColor3 = Color3.fromRGB(220,40,40)
    fill.BorderSizePixel = 0
    makeCorner(fill, 6)
    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.fromOffset(18,18)
    knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new(initialVal/maxVal,0,0.5,0)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    makeCorner(knob, 9)
    local mrow = Instance.new("Frame", box)
    mrow.Size = UDim2.new(1,-16,0,12)
    mrow.Position = UDim2.fromOffset(8,26)
    mrow.BackgroundTransparency = 1
    for _, v in ipairs(markers) do
        local m = Instance.new("TextLabel", mrow)
        m.Size = UDim2.fromOffset(28,12)
        m.AnchorPoint = Vector2.new(0.5,0)
        m.Position = UDim2.new(v/maxVal,0,0,0)
        m.Text = tostring(v)
        m.BackgroundTransparency = 1
        m.TextColor3 = Color3.fromRGB(120,120,150)
        m.Font = Enum.Font.Gotham
        m.TextSize = 8
        m.TextXAlignment = Enum.TextXAlignment.Center
    end
    local dragging = false
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.Heartbeat:Connect(function()
        if dragging then
            local mouse = UserInputService:GetMouseLocation()
            local ratio = math.clamp((mouse.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = math.max(1, math.floor(ratio * maxVal))
            fill.Size = UDim2.fromScale(ratio, 1)
            knob.Position = UDim2.new(ratio, 0, 0.5, 0)
            onChanged(val, fill, knob)
        end
    end)
    return box, fill, knob
end

-- ==================== KEY EKRANI ====================
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.fromOffset(400,250)
keyFrame.Position = UDim2.new(0.5,-200,0.5,-125)
keyFrame.BackgroundColor3 = Color3.fromRGB(14,14,22)
keyFrame.BorderSizePixel = 0
makeCorner(keyFrame, 14)
makeStroke(keyFrame, Color3.fromRGB(220,40,40), 2)

-- KEY — Logo başlık (WuiHub yazısı)
local keyLogoLbl = Instance.new("TextLabel", keyFrame)
keyLogoLbl.Size = UDim2.fromOffset(160,36)
keyLogoLbl.Position = UDim2.fromOffset(16,10)
keyLogoLbl.Text = "⚡ WuiHub"
keyLogoLbl.BackgroundTransparency = 1
keyLogoLbl.TextColor3 = Color3.fromRGB(220,40,40)
keyLogoLbl.Font = Enum.Font.GothamBold
keyLogoLbl.TextSize = 22
keyLogoLbl.TextXAlignment = Enum.TextXAlignment.Left

local closeKeyBtn = makeBtn(keyFrame,"✕",28,28,Color3.fromRGB(180,40,40))
closeKeyBtn.Position = UDim2.new(1,-33,0,10)
local hideKeyBtn = makeBtn(keyFrame,"-",28,28,Color3.fromRGB(50,50,70))
hideKeyBtn.Position = UDim2.new(1,-65,0,10)

-- WuiHub "W" logo ikonu (sol)
local wLogoBox = Instance.new("Frame", keyFrame)
wLogoBox.Size = UDim2.fromOffset(54,54)
wLogoBox.Position = UDim2.fromOffset(16,54)
wLogoBox.BackgroundColor3 = Color3.fromRGB(220,40,40)
wLogoBox.BorderSizePixel = 0
makeCorner(wLogoBox, 10)
local wLogoLbl = Instance.new("TextLabel", wLogoBox)
wLogoLbl.Size = UDim2.fromScale(1,1)
wLogoLbl.BackgroundTransparency = 1
wLogoLbl.Text = "W"
wLogoLbl.TextColor3 = Color3.new(1,1,1)
wLogoLbl.Font = Enum.Font.GothamBold
wLogoLbl.TextSize = 28

local discordKeyBtn = makeBtn(keyFrame,"Discord",60,26,Color3.fromRGB(88,101,242))
discordKeyBtn.Position = UDim2.fromOffset(16,114)
discordKeyBtn.TextSize = 10

local langLabel = Instance.new("TextLabel", keyFrame)
langLabel.Size = UDim2.fromOffset(70,16)
langLabel.Position = UDim2.fromOffset(16,148)
langLabel.Text = "Language:"
langLabel.BackgroundTransparency = 1
langLabel.TextColor3 = Color3.fromRGB(180,180,180)
langLabel.Font = Enum.Font.Gotham
langLabel.TextSize = 9

local langBtnTR = makeBtn(keyFrame,"TR",30,22,Color3.fromRGB(220,40,40),Color3.new(1,1,1))
langBtnTR.Position = UDim2.fromOffset(16,166)
local langBtnEN = makeBtn(keyFrame,"EN",30,22,Color3.fromRGB(40,40,65))
langBtnEN.Position = UDim2.fromOffset(50,166)
local langBtnRU = makeBtn(keyFrame,"RU",30,22,Color3.fromRGB(40,40,65))
langBtnRU.Position = UDim2.fromOffset(84,166)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.fromOffset(248,38)
keyBox.Position = UDim2.fromOffset(84,58)
keyBox.PlaceholderText = "🔑 Key girin..."
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(25,25,40)
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.PlaceholderColor3 = Color3.fromRGB(130,130,150)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.BorderSizePixel = 0
keyBox.ClearTextOnFocus = false
makeCorner(keyBox, 8)
makeStroke(keyBox, Color3.fromRGB(80,80,120), 1)

local freeBtn = makeBtn(keyFrame,"🆓 FREE",116,36,Color3.fromRGB(40,160,90))
freeBtn.Position = UDim2.fromOffset(84,108)

local premiumBtn = Instance.new("TextButton", keyFrame)
premiumBtn.Size = UDim2.fromOffset(116,36)
premiumBtn.Position = UDim2.fromOffset(214,108)
premiumBtn.Text = ""
premiumBtn.BackgroundColor3 = Color3.fromRGB(150,50,255)
premiumBtn.BorderSizePixel = 0
makeCorner(premiumBtn, 8)
local premGrad = Instance.new("UIGradient", premiumBtn)
premGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,80,80)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,200,50)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(80,200,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200,80,255)),
})
local premLabel = Instance.new("TextLabel", premiumBtn)
premLabel.Size = UDim2.fromScale(1,1)
premLabel.BackgroundTransparency = 1
premLabel.Text = "⭐ PREMİUM"
premLabel.TextColor3 = Color3.new(1,1,1)
premLabel.Font = Enum.Font.GothamBold
premLabel.TextSize = 12

local verifyBtn = makeBtn(keyFrame,"✅ Doğrula",248,36,Color3.fromRGB(220,40,40),Color3.new(1,1,1))
verifyBtn.Position = UDim2.fromOffset(84,156)

local rot = 0
RunService.Heartbeat:Connect(function() rot=(rot+1)%360; premGrad.Rotation=rot end)

-- ==================== DİL SİSTEMİ ====================
local hubTitleLabel, infoLblRef, flyInfoRef, speedLabelRef, flySpeedLabelRef
local toggleKeyLabelRef, opacityLabelRef, webhookLabelRef, webhookBtnRef
local printPosBtnRef, scanSpawnBtnRef, farmStatusLbl

local langBtns = {TR=langBtnTR, EN=langBtnEN, RU=langBtnRU}
local function refreshLangBtns()
    for code, btn in pairs(langBtns) do
        if code == currentLang then
            btn.BackgroundColor3 = Color3.fromRGB(220,40,40)
            btn.TextColor3 = Color3.new(1,1,1)
        else
            btn.BackgroundColor3 = Color3.fromRGB(40,40,65)
            btn.TextColor3 = Color3.new(1,1,1)
        end
    end
    keyBox.PlaceholderText = t("key_placeholder")
    verifyBtn.Text = t("verify")
    freeBtn.Text = t("free_btn")
    if hubTitleLabel then hubTitleLabel.Text = t("title") end
    if infoLblRef then infoLblRef.Text = t("about_text") end
    if flyInfoRef then flyInfoRef.Text = t("fly_hint") end
    if webhookBtnRef then webhookBtnRef.Text = t("webhook_btn") end
    if printPosBtnRef then printPosBtnRef.Text = t("print_pos") end
    if scanSpawnBtnRef then scanSpawnBtnRef.Text = t("scan_spawn") end
end

for code, btn in pairs(langBtns) do
    btn.MouseButton1Click:Connect(function() currentLang=code; refreshLangBtns() end)
end

-- ==================== T (W) LOGO FLOAT ====================
local tLogoFloat = Instance.new("TextButton", gui)
tLogoFloat.Size = UDim2.fromOffset(50,50)
tLogoFloat.Position = UDim2.fromOffset(10,10)
tLogoFloat.Text = "W"
tLogoFloat.BackgroundColor3 = Color3.fromRGB(220,40,40)
tLogoFloat.TextColor3 = Color3.new(1,1,1)
tLogoFloat.Font = Enum.Font.GothamBold
tLogoFloat.TextSize = 24
tLogoFloat.BorderSizePixel = 0
tLogoFloat.Visible = false
makeCorner(tLogoFloat, 10)

-- ==================== ANA HUB ====================
local MIN_W, MIN_H, MAX_W, MAX_H = 240, 320, 700, 800

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(340,480)
frame.Position = UDim2.new(0.5,-170,0.5,-240)
frame.BackgroundColor3 = Color3.fromRGB(14,14,22)
frame.Visible = false
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
makeCorner(frame, 12)
local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(220,40,40)
frameStroke.Thickness = 2

-- Sürükleme
local isDragging, dragStart, frameStart = false, nil, nil
local titleBarDrag = Instance.new("Frame", frame)
titleBarDrag.Size = UDim2.new(1,-18,0,44)
titleBarDrag.BackgroundTransparency = 1
titleBarDrag.ZIndex = 2
titleBarDrag.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging=true; dragStart=inp.Position; frameStart=frame.Position
    end
end)
titleBarDrag.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then isDragging=false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if isDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - dragStart
        frame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset+d.X,
                                    frameStart.Y.Scale, frameStart.Y.Offset+d.Y)
    end
end)

-- Resize
local resizeHandle = Instance.new("TextButton", frame)
resizeHandle.Size = UDim2.fromOffset(20,20)
resizeHandle.Position = UDim2.new(1,-20,1,-20)
resizeHandle.Text = "⇲"
resizeHandle.BackgroundColor3 = Color3.fromRGB(220,40,40)
resizeHandle.TextColor3 = Color3.new(1,1,1)
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.TextSize = 12
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 10
makeCorner(resizeHandle, 5)

local isResizing, resizeStart, startSize = false, nil, nil
resizeHandle.MouseButton1Down:Connect(function()
    isResizing=true; resizeStart=UserInputService:GetMouseLocation(); startSize=frame.AbsoluteSize
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then isResizing=false end
end)
RunService.Heartbeat:Connect(function()
    if isResizing and resizeStart then
        local m = UserInputService:GetMouseLocation()
        frame.Size = UDim2.fromOffset(
            math.clamp(startSize.X+(m.X-resizeStart.X), MIN_W, MAX_W),
            math.clamp(startSize.Y+(m.Y-resizeStart.Y), MIN_H, MAX_H))
    end
end)

-- ==================== SOL PANEL ====================
local leftPanel = Instance.new("Frame", frame)
leftPanel.Size = UDim2.new(0,60,1,0)
leftPanel.BackgroundColor3 = Color3.fromRGB(10,10,18)
leftPanel.BorderSizePixel = 0
makeCorner(leftPanel, 12)
local lpFill = Instance.new("Frame", leftPanel)
lpFill.Size = UDim2.new(0,12,1,0)
lpFill.Position = UDim2.new(1,-12,0,0)
lpFill.BackgroundColor3 = Color3.fromRGB(10,10,18)
lpFill.BorderSizePixel = 0

-- Sol panel: WuiHub "W" logosu
local leftLogoBox = Instance.new("Frame", leftPanel)
leftLogoBox.Size = UDim2.fromOffset(44,44)
leftLogoBox.Position = UDim2.fromOffset(8,10)
leftLogoBox.BackgroundColor3 = Color3.fromRGB(220,40,40)
leftLogoBox.BorderSizePixel = 0
makeCorner(leftLogoBox, 8)
-- Üst üçgen (kırmızı)
local leftLogoW = Instance.new("TextLabel", leftLogoBox)
leftLogoW.Size = UDim2.fromScale(1,1)
leftLogoW.BackgroundTransparency = 1
leftLogoW.Text = "W"
leftLogoW.TextColor3 = Color3.new(1,1,1)
leftLogoW.Font = Enum.Font.GothamBold
leftLogoW.TextSize = 22
-- Kırmızı çizgi (altına)
local leftLogoDivider = Instance.new("Frame", leftPanel)
leftLogoDivider.Size = UDim2.fromOffset(44,2)
leftLogoDivider.Position = UDim2.fromOffset(8,56)
leftLogoDivider.BackgroundColor3 = Color3.fromRGB(220,40,40)
leftLogoDivider.BackgroundTransparency = 0.5
leftLogoDivider.BorderSizePixel = 0
makeCorner(leftLogoDivider, 1)

local function createTabBtn(icon, label, yOffset)
    local btn = Instance.new("TextButton", leftPanel)
    btn.Size = UDim2.fromOffset(44,44)
    btn.Position = UDim2.fromOffset(8,yOffset)
    btn.Text = icon
    btn.BackgroundColor3 = Color3.fromRGB(30,30,48)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BorderSizePixel = 0
    makeCorner(btn, 8)
    local tip = Instance.new("TextLabel", btn)
    tip.Size = UDim2.fromOffset(80,24)
    tip.Position = UDim2.fromOffset(48,10)
    tip.Text = label
    tip.BackgroundColor3 = Color3.fromRGB(25,25,42)
    tip.TextColor3 = Color3.new(1,1,1)
    tip.Font = Enum.Font.Gotham
    tip.TextSize = 11
    tip.BorderSizePixel = 0
    tip.Visible = false
    tip.ZIndex = 20
    makeCorner(tip, 4)
    makeStroke(tip, Color3.fromRGB(220,40,40), 1)
    btn.MouseEnter:Connect(function() tip.Visible=true end)
    btn.MouseLeave:Connect(function() tip.Visible=false end)
    return btn
end

-- ==================== İÇERİK ALANI ====================
local contentArea = Instance.new("Frame", frame)
contentArea.Size = UDim2.new(1,-64,1,0)
contentArea.Position = UDim2.fromOffset(62,0)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true  -- taşmayı engelle!

hubTitleLabel = Instance.new("TextLabel", contentArea)
hubTitleLabel.Size = UDim2.new(1,-75,0,40)
hubTitleLabel.Position = UDim2.fromOffset(4,4)
hubTitleLabel.Text = t("title")
hubTitleLabel.BackgroundTransparency = 1
hubTitleLabel.TextColor3 = Color3.fromRGB(220,40,40)
hubTitleLabel.Font = Enum.Font.GothamBold
hubTitleLabel.TextSize = 18
hubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local hubCloseBtn = makeBtn(contentArea,"✕",28,28,Color3.fromRGB(180,40,40))
hubCloseBtn.Position = UDim2.new(1,-32,0,6)
local hubHideBtn = makeBtn(contentArea,"-",28,28,Color3.fromRGB(50,50,70))
hubHideBtn.Position = UDim2.new(1,-64,0,6)

local divider = Instance.new("Frame", contentArea)
divider.Size = UDim2.new(1,-8,0,1)
divider.Position = UDim2.fromOffset(4,44)
divider.BackgroundColor3 = Color3.fromRGB(220,40,40)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0

-- Design by -Wui (rengarenk)
local designLabel = Instance.new("TextLabel", frame)
designLabel.Size = UDim2.fromOffset(160,18)
designLabel.Position = UDim2.new(1,-165,1,-22)
designLabel.Text = "Design by -Wui"
designLabel.BackgroundTransparency = 1
designLabel.Font = Enum.Font.GothamBold
designLabel.TextSize = 11
designLabel.ZIndex = 5
local rwColors = {
    Color3.fromRGB(255,80,80), Color3.fromRGB(255,140,40),
    Color3.fromRGB(255,220,50), Color3.fromRGB(80,220,80),
    Color3.fromRGB(60,180,255), Color3.fromRGB(160,80,255), Color3.fromRGB(255,80,200)
}
local rwIdx, rwTimer = 1, 0
RunService.Heartbeat:Connect(function(dt)
    rwTimer+=dt
    if rwTimer>=0.1 then rwTimer=0; rwIdx=(rwIdx%#rwColors)+1; designLabel.TextColor3=rwColors[rwIdx] end
end)

-- ==================== SCROLL FACTORY ====================
local function createScrollFrame()
    local sf = Instance.new("ScrollingFrame", contentArea)
    sf.Size = UDim2.new(1,-8,1,-52)
    sf.Position = UDim2.fromOffset(4,50)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = Color3.fromRGB(220,40,40)
    sf.Visible = false
    sf.CanvasSize = UDim2.fromOffset(0,0)
    local layout = Instance.new("UIListLayout", sf)
    layout.Padding = UDim.new(0,6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sf.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y+12)
    end)
    return sf
end

-- ==================== GENEL ====================
local genelFrame = createScrollFrame()
addSection(genelFrame, t("about"))
infoLblRef = Instance.new("TextLabel", genelFrame)
infoLblRef.Size = UDim2.new(1,-4,0,60)
infoLblRef.Text = t("about_text")
infoLblRef.BackgroundColor3 = Color3.fromRGB(20,20,36)
infoLblRef.TextColor3 = Color3.fromRGB(200,200,220)
infoLblRef.Font = Enum.Font.Gotham
infoLblRef.TextSize = 12
infoLblRef.BorderSizePixel = 0
makeCorner(infoLblRef, 8)
makeStroke(infoLblRef, Color3.fromRGB(220,40,40), 1)

addSection(genelFrame, t("connections"))
addToggleBtn(genelFrame, t("discord"), function() end)
addToggleBtn(genelFrame, t("freekey"), function() end)
addToggleBtn(genelFrame, t("premium"), function() end)

-- ==================== PLAYER ====================
local playerFrame = createScrollFrame()
addSection(playerFrame, "NOCLIP")
local noclipEnabled, noclipConn = false, nil
local function setNoclip(state)
    noclipEnabled = state
    if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
    if noclipEnabled then
        noclipConn = RunService.Stepped:Connect(function()
            if character then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide=false end
                end
            end
        end)
    else
        if character then
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide=true end
            end
        end
    end
end
player.CharacterAdded:Connect(function(char)
    character=char; humanoid=char:WaitForChild("Humanoid"); rootPart=char:WaitForChild("HumanoidRootPart")
    if noclipEnabled then setNoclip(true) end
end)
addToggleBtn(playerFrame, t("noclip_off"), function(b)
    noclipEnabled = not noclipEnabled
    setNoclip(noclipEnabled)
    b.Text = noclipEnabled and t("noclip_on") or t("noclip_off")
    b.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50,120,50) or Color3.fromRGB(35,35,55)
end)

addSection(playerFrame, t("speed"))
local speedActive = false
local currentSpeed = 50
local DEFAULT_WALK = 16
local speedToggleRow = Instance.new("Frame", playerFrame)
speedToggleRow.Size = UDim2.new(1,-4,0,36)
speedToggleRow.BackgroundColor3 = Color3.fromRGB(25,25,40)
speedToggleRow.BorderSizePixel = 0
makeCorner(speedToggleRow, 8)
local speedToggleBtn = makeBtn(speedToggleRow,"✗",32,28,Color3.fromRGB(180,40,40))
speedToggleBtn.Position = UDim2.fromOffset(4,4)
speedLabelRef = Instance.new("TextLabel", speedToggleRow)
speedLabelRef.Size = UDim2.new(1,-44,1,0)
speedLabelRef.Position = UDim2.fromOffset(40,0)
speedLabelRef.Text = "⚡ Speed: "..t("speed_off").."  |  50"
speedLabelRef.BackgroundTransparency = 1
speedLabelRef.TextColor3 = Color3.new(1,1,1)
speedLabelRef.Font = Enum.Font.Gotham
speedLabelRef.TextSize = 12
speedLabelRef.TextXAlignment = Enum.TextXAlignment.Left
local function applySpeed()
    if humanoid then humanoid.WalkSpeed = speedActive and currentSpeed or DEFAULT_WALK end
end
makeSlider(playerFrame, currentSpeed, 500, {0,100,200,300,400,500}, function(val)
    currentSpeed = val
    speedLabelRef.Text = "⚡ Speed: "..(speedActive and t("speed_on") or t("speed_off")).."  |  "..val
    applySpeed()
end)
speedToggleBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedToggleBtn.Text = speedActive and "✓" or "✗"
    speedToggleBtn.BackgroundColor3 = speedActive and Color3.fromRGB(50,150,50) or Color3.fromRGB(180,40,40)
    speedLabelRef.Text = "⚡ Speed: "..(speedActive and t("speed_on") or t("speed_off")).."  |  "..currentSpeed
    applySpeed()
end)
RunService.Heartbeat:Connect(function()
    if speedActive and humanoid and humanoid.WalkSpeed ~= currentSpeed then
        humanoid.WalkSpeed = currentSpeed
    end
end)
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    humanoid = char:WaitForChild("Humanoid")
    if speedActive then humanoid.WalkSpeed = currentSpeed end
end)

addSection(playerFrame, "SUPER JUMP")
local jumpEnabled, jumpConn = false, nil
addToggleBtn(playerFrame, t("superjump_off"), function(b)
    jumpEnabled = not jumpEnabled
    if jumpConn then jumpConn:Disconnect(); jumpConn=nil end
    if jumpEnabled then
        jumpConn = RunService.Heartbeat:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) and rootPart then
                local vel = rootPart.AssemblyLinearVelocity
                rootPart.AssemblyLinearVelocity = Vector3.new(vel.X, math.min(vel.Y+130,220), vel.Z)
            end
        end)
    end
    b.Text = jumpEnabled and t("superjump_on") or t("superjump_off")
    b.BackgroundColor3 = jumpEnabled and Color3.fromRGB(50,120,50) or Color3.fromRGB(35,35,55)
end)

addSection(playerFrame, "FLY")
local flyEnabled, flyConn = false, nil
local bodyVelocity, bodyGyro = nil, nil
local flyBtn
local currentFlySpeed = 60
local function startFly()
    if not rootPart then return end
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bodyGyro.P = 9e4
    bodyGyro.Parent = rootPart
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
    bodyVelocity.Parent = rootPart
    flyConn = RunService.Heartbeat:Connect(function()
        if not rootPart or not bodyVelocity or not bodyGyro then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        bodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit*currentFlySpeed or Vector3.zero
        bodyGyro.CFrame = cam.CFrame
    end)
    if humanoid then humanoid.PlatformStand = true end
end
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity=nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro=nil end
    if humanoid then humanoid.PlatformStand = false end
end
flyBtn = addToggleBtn(playerFrame, t("fly_off"), function(b)
    flyEnabled = not flyEnabled
    if flyEnabled then startFly() else stopFly() end
    b.Text = flyEnabled and t("fly_on") or t("fly_off")
    b.BackgroundColor3 = flyEnabled and Color3.fromRGB(50,120,50) or Color3.fromRGB(35,35,55)
end)
flyInfoRef = Instance.new("TextLabel", playerFrame)
flyInfoRef.Size = UDim2.new(1,-4,0,22)
flyInfoRef.Text = t("fly_hint")
flyInfoRef.BackgroundTransparency = 1
flyInfoRef.TextColor3 = Color3.fromRGB(130,130,160)
flyInfoRef.Font = Enum.Font.Gotham
flyInfoRef.TextSize = 10
flyInfoRef.TextWrapped = true

addSection(playerFrame, t("fly_speed"))
local flySpeedToggleRow = Instance.new("Frame", playerFrame)
flySpeedToggleRow.Size = UDim2.new(1,-4,0,36)
flySpeedToggleRow.BackgroundColor3 = Color3.fromRGB(25,25,40)
flySpeedToggleRow.BorderSizePixel = 0
makeCorner(flySpeedToggleRow, 8)
flySpeedLabelRef = Instance.new("TextLabel", flySpeedToggleRow)
flySpeedLabelRef.Size = UDim2.new(1,-8,1,0)
flySpeedLabelRef.Position = UDim2.fromOffset(8,0)
flySpeedLabelRef.Text = "🕊️ Fly Hızı: 60"
flySpeedLabelRef.BackgroundTransparency = 1
flySpeedLabelRef.TextColor3 = Color3.new(1,1,1)
flySpeedLabelRef.Font = Enum.Font.Gotham
flySpeedLabelRef.TextSize = 12
flySpeedLabelRef.TextXAlignment = Enum.TextXAlignment.Left
makeSlider(playerFrame, currentFlySpeed, 500, {0,100,200,300,400,500}, function(val)
    currentFlySpeed = val
    flySpeedLabelRef.Text = "🕊️ Fly Hızı: " .. val
end)
player.CharacterAdded:Connect(function()
    if flyEnabled then
        task.wait(0.5); stopFly(); flyEnabled=false
        flyBtn.Text=t("fly_off"); flyBtn.BackgroundColor3=Color3.fromRGB(35,35,55)
    end
end)

-- ==================== PS99 ====================
local ps99Frame = createScrollFrame()
addSection(ps99Frame, t("tp_section"))
local infoBox = Instance.new("TextLabel", ps99Frame)
infoBox.Size = UDim2.new(1,-4,0,28)
infoBox.Text = t("tp_info")
infoBox.BackgroundColor3 = Color3.fromRGB(18,28,45)
infoBox.TextColor3 = Color3.fromRGB(120,180,255)
infoBox.Font = Enum.Font.Gotham
infoBox.TextSize = 10
infoBox.BorderSizePixel = 0
infoBox.TextWrapped = true
makeCorner(infoBox, 6)
addSection(ps99Frame, t("stages"))

local stageData = {
    {num=1,  name="⭐ 1",  pos=Vector3.new(2.3,     10.3,  1.7)},
    {num=2,  name="🌿 2",  pos=Vector3.new(2.1,     6.2,   281.5)},
    {num=3,  name="❄️ 3",  pos=Vector3.new(2.1,     6.2,   506.5)},
    {num=4,  name="🔥 4",  pos=Vector3.new(4.1,     77.0,  775.0)},
    {num=5,  name="🌊 5",  pos=Vector3.new(2.1,     74.7,  1107.7)},
    {num=6,  name="⚡ 6",  pos=Vector3.new(2.1,     74.7,  1411.7)},
    {num=7,  name="🌙 7",  pos=Vector3.new(-538.8,  52.1,  1467.4)},
    {num=8,  name="☁️ 8",  pos=Vector3.new(-1010.9, 54.4,  1467.9)},
    {num=9,  name="🌋 9",  pos=Vector3.new(-1122.8, 294.1, 1467.4)},
    {num=10, name="💎 10", pos=Vector3.new(-2970.7, 296.4, 1469.1)},
    {num=11, name="🌌 11", pos=Vector3.new(-3933.0, 296.4, 1466.0)},
    {num=12, name="🏰 12", pos=Vector3.new(-4366.2, 470.9, 1531.0)},
    {num=13, name="🐉 13", pos=Vector3.new(-5337.8, 470.5, 1476.9)},
    {num=14, name="👑 14", pos=Vector3.new(-6813.5, 527.1, 1491.6)},
    {num=15, name="🔱 15", pos=Vector3.new(-8356.5, 489.9, 1491.3)},
}

for _, stage in ipairs(stageData) do
    local stagePos = stage.pos
    local row = Instance.new("Frame", ps99Frame)
    row.Size = UDim2.new(1,-4,0,44)
    row.BackgroundColor3 = Color3.fromRGB(20,20,36)
    row.BorderSizePixel = 0
    makeCorner(row, 8)
    local colorBar = Instance.new("Frame", row)
    colorBar.Size = UDim2.fromOffset(4,44)
    colorBar.BackgroundColor3 = Color3.fromHSV((stage.num-1)/15, 0.7, 1)
    colorBar.BorderSizePixel = 0
    makeCorner(colorBar, 4)
    local stageLbl = Instance.new("TextLabel", row)
    stageLbl.Size = UDim2.new(1,-110,1,0)
    stageLbl.Position = UDim2.fromOffset(10,0)
    stageLbl.Text = stage.name
    stageLbl.BackgroundTransparency = 1
    stageLbl.TextColor3 = Color3.new(1,1,1)
    stageLbl.Font = Enum.Font.GothamBold
    stageLbl.TextSize = 13
    stageLbl.TextXAlignment = Enum.TextXAlignment.Left
    local coordBadge = Instance.new("TextLabel", row)
    coordBadge.Size = UDim2.fromOffset(22,16)
    coordBadge.Position = UDim2.new(1,-100,0.5,-8)
    coordBadge.Text = "📌"
    coordBadge.BackgroundColor3 = Color3.fromRGB(160,110,15)
    coordBadge.TextColor3 = Color3.new(1,1,1)
    coordBadge.Font = Enum.Font.GothamBold
    coordBadge.TextSize = 9
    coordBadge.BorderSizePixel = 0
    makeCorner(coordBadge, 4)
    local statusDot = Instance.new("TextLabel", row)
    statusDot.Size = UDim2.fromOffset(14,14)
    statusDot.Position = UDim2.new(1,-76,0.5,-7)
    statusDot.Text = "?"
    statusDot.BackgroundColor3 = Color3.fromRGB(60,60,90)
    statusDot.TextColor3 = Color3.new(1,1,1)
    statusDot.Font = Enum.Font.GothamBold
    statusDot.TextSize = 9
    statusDot.BorderSizePixel = 0
    makeCorner(statusDot, 7)
    local tpBtn = makeBtn(row,"🚀 TP",56,30,Color3.fromRGB(220,40,40))
    tpBtn.Position = UDim2.new(1,-62,0,7)
    tpBtn.TextSize = 12
    tpBtn.MouseButton1Click:Connect(function()
        if not rootPart then return end
        tpBtn.Text = "⏳"
        tpBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)
        rootPart.CFrame = CFrame.new(stagePos + Vector3.new(0,3,0))
        statusDot.BackgroundColor3 = Color3.fromRGB(50,180,50)
        statusDot.Text = "✓"
        tpBtn.Text = "✓ TP"
        tpBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
        task.delay(2, function()
            tpBtn.Text = "🚀 TP"
            tpBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
        end)
    end)
end

addSection(ps99Frame, t("tools"))
printPosBtnRef = addToggleBtn(ps99Frame, t("print_pos"), function(b)
    if rootPart then
        local p = rootPart.Position
        print(string.format("[WuiHub] Konum: Vector3.new(%.1f, %.1f, %.1f)", p.X, p.Y, p.Z))
        b.Text = t("printed")
        b.BackgroundColor3 = Color3.fromRGB(50,150,50)
        task.delay(2, function() b.Text=t("print_pos"); b.BackgroundColor3=Color3.fromRGB(35,35,55) end)
    end
end)
scanSpawnBtnRef = addToggleBtn(ps99Frame, t("scan_spawn"), function(b)
    b.Text = t("scanning")
    task.delay(0.1, function()
        local count = 0
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("SpawnLocation") then
                print(string.format("[WuiHub] SpawnLocation: %s | Pos: %.1f, %.1f, %.1f",
                    obj:GetFullName(), obj.Position.X, obj.Position.Y, obj.Position.Z))
                count += 1
            end
        end
        b.Text = string.format(t("found"), count)
        b.BackgroundColor3 = Color3.fromRGB(50,150,50)
        task.delay(2.5, function() b.Text=t("scan_spawn"); b.BackgroundColor3=Color3.fromRGB(35,35,55) end)
    end)
end)

-- ==================== FARM SEKMESİ ====================
local farmFrame = createScrollFrame()
addSection(farmFrame, t("farm_section"))

-- Bilgi kutusu
local farmInfoBox = Instance.new("TextLabel", farmFrame)
farmInfoBox.Size = UDim2.new(1,-4,0,44)
farmInfoBox.Text = "🏆 Kupa bloğunu otomatik bulur ve karakteri oraya götürür. Yürüme modu anti-ban için daha güvenlidir."
farmInfoBox.BackgroundColor3 = Color3.fromRGB(18,28,18)
farmInfoBox.TextColor3 = Color3.fromRGB(120,220,120)
farmInfoBox.Font = Enum.Font.Gotham
farmInfoBox.TextSize = 10
farmInfoBox.BorderSizePixel = 0
farmInfoBox.TextWrapped = true
makeCorner(farmInfoBox, 6)
makeStroke(farmInfoBox, Color3.fromRGB(50,180,50), 1)

-- Durum etiketi
addSection(farmFrame, "DURUM")
farmStatusLbl = Instance.new("TextLabel", farmFrame)
farmStatusLbl.Size = UDim2.new(1,-4,0,36)
farmStatusLbl.Text = "⏸️ " .. t("farm_status")
farmStatusLbl.BackgroundColor3 = Color3.fromRGB(20,20,36)
farmStatusLbl.TextColor3 = Color3.fromRGB(180,180,220)
farmStatusLbl.Font = Enum.Font.GothamBold
farmStatusLbl.TextSize = 12
farmStatusLbl.BorderSizePixel = 0
makeCorner(farmStatusLbl, 8)

-- Hedef aşama seçici
addSection(farmFrame, t("farm_stage"))
local stageNames = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"}
local selectedFarmStage = 1
local farmStageLbl = Instance.new("TextLabel", farmFrame)
farmStageLbl.Size = UDim2.new(1,-4,0,30)
farmStageLbl.Text = "📍 Seçili: Aşama " .. selectedFarmStage
farmStageLbl.BackgroundColor3 = Color3.fromRGB(20,20,36)
farmStageLbl.TextColor3 = Color3.fromRGB(255,200,80)
farmStageLbl.Font = Enum.Font.GothamBold
farmStageLbl.TextSize = 13
farmStageLbl.BorderSizePixel = 0
makeCorner(farmStageLbl, 8)

-- Aşama buton satırları (3'lü)
local stageRowData = {{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}}
for _, row in ipairs(stageRowData) do
    local rowFrame = Instance.new("Frame", farmFrame)
    rowFrame.Size = UDim2.new(1,-4,0,36)
    rowFrame.BackgroundTransparency = 1
    local rowLayout = Instance.new("UIListLayout", rowFrame)
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0,4)
    for _, stageNum in ipairs(row) do
        local sBtn = Instance.new("TextButton", rowFrame)
        sBtn.Size = UDim2.new(0.333,-3,1,0)
        sBtn.Text = stageData[stageNum].name
        sBtn.BackgroundColor3 = Color3.fromRGB(35,35,55)
        sBtn.TextColor3 = Color3.new(1,1,1)
        sBtn.Font = Enum.Font.GothamBold
        sBtn.TextSize = 12
        sBtn.BorderSizePixel = 0
        makeCorner(sBtn, 6)
        sBtn.MouseButton1Click:Connect(function()
            selectedFarmStage = stageNum
            farmStageLbl.Text = "📍 Seçili: " .. stageData[stageNum].name
        end)
    end
end

-- Yöntem seçimi
addSection(farmFrame, t("farm_method"))
local farmMethodRow = Instance.new("Frame", farmFrame)
farmMethodRow.Size = UDim2.new(1,-4,0,36)
farmMethodRow.BackgroundTransparency = 1
local farmMethodLayout = Instance.new("UIListLayout", farmMethodRow)
farmMethodLayout.FillDirection = Enum.FillDirection.Horizontal
farmMethodLayout.Padding = UDim.new(0,4)

local useTeleport = true
local farmTpBtn = makeBtn(farmMethodRow, "⚡ " .. t("farm_tp"), 0, 36, Color3.fromRGB(220,40,40))
farmTpBtn.Size = UDim2.new(0.5,-2,1,0)
local farmWalkBtn = makeBtn(farmMethodRow, "🚶 " .. t("farm_walk"), 0, 36, Color3.fromRGB(35,35,55))
farmWalkBtn.Size = UDim2.new(0.5,-2,1,0)

farmTpBtn.MouseButton1Click:Connect(function()
    useTeleport = true
    farmTpBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    farmWalkBtn.BackgroundColor3 = Color3.fromRGB(35,35,55)
end)
farmWalkBtn.MouseButton1Click:Connect(function()
    useTeleport = false
    farmWalkBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
    farmTpBtn.BackgroundColor3 = Color3.fromRGB(35,35,55)
end)

-- Döngü gecikmesi slider
addSection(farmFrame, t("farm_delay"))
local farmDelayBox = Instance.new("Frame", farmFrame)
farmDelayBox.Size = UDim2.new(1,-4,0,36)
farmDelayBox.BackgroundColor3 = Color3.fromRGB(20,20,36)
farmDelayBox.BorderSizePixel = 0
makeCorner(farmDelayBox, 8)
local farmDelayLbl = Instance.new("TextLabel", farmDelayBox)
farmDelayLbl.Size = UDim2.new(1,0,1,0)
farmDelayLbl.Text = "⏱️ Gecikme: 2.0 sn"
farmDelayLbl.BackgroundTransparency = 1
farmDelayLbl.TextColor3 = Color3.new(1,1,1)
farmDelayLbl.Font = Enum.Font.Gotham
farmDelayLbl.TextSize = 12
local farmDelay = 2.0
makeSlider(farmFrame, 20, 100, {0,25,50,75,100}, function(val)
    farmDelay = val / 10
    farmDelayLbl.Text = "⏱️ Gecikme: " .. string.format("%.1f", farmDelay) .. " sn"
end)

-- ==================== AUTO FARM ANA FONKSİYON ====================
local farmRunning = false
local farmThread = nil

-- Kupa / kazanma bloğunu akıllıca bul
local function findTrophyBlock(stagePos)
    -- PS99'da trophy/kazanma bloklarını bulmak için çeşitli isimler denenir
    local searchNames = {"Trophy","Win","Finish","Goal","Complete","End","Reward","Kupa","🏆","Stage"..selectedFarmStage}
    local closest = nil
    local closestDist = math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local objName = obj.Name:lower()
            for _, kw in ipairs({"trophy","win","finish","goal","complete","reward","kupa"}) do
                if objName:find(kw) then
                    local objPos = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:GetModelCFrame().Position) or obj.Position
                    local dist = (objPos - stagePos).Magnitude
                    if dist < closestDist and dist < 300 then
                        closestDist = dist
                        closest = obj
                    end
                end
            end
        end
    end
    return closest
end

-- Karakteri hedefe doğru yürüt (Humanoid:MoveTo)
local function walkToPosition(targetPos)
    if not humanoid or not rootPart then return end
    local arrived = false
    humanoid:MoveTo(targetPos)
    local conn
    conn = humanoid.MoveToFinished:Connect(function(reached)
        arrived = true
        conn:Disconnect()
    end)
    -- Max 8 saniye bekle
    local t0 = tick()
    while not arrived and (tick()-t0) < 8 do
        task.wait(0.1)
    end
    if conn then conn:Disconnect() end
end

local function runFarm()
    local stageInfo = stageData[selectedFarmStage]
    if not stageInfo then return end
    local stagePos = stageInfo.pos
    farmStatusLbl.Text = "🔄 Aşama " .. selectedFarmStage .. " - Gidiliyor..."
    farmStatusLbl.TextColor3 = Color3.fromRGB(255,200,80)

    -- Adım 1: Aşamaya ışınla / git
    if useTeleport then
        if rootPart then
            rootPart.CFrame = CFrame.new(stagePos + Vector3.new(0,4,0))
        end
    else
        walkToPosition(stagePos + Vector3.new(0,2,0))
    end
    task.wait(0.8)

    -- Adım 2: Trophy bloğunu ara
    farmStatusLbl.Text = "🔍 Kupa bloğu aranıyor..."
    local trophyBlock = findTrophyBlock(stagePos)

    if trophyBlock then
        local trophyPos
        if trophyBlock:IsA("Model") then
            trophyPos = trophyBlock.PrimaryPart and trophyBlock.PrimaryPart.Position or trophyBlock:GetModelCFrame().Position
        else
            trophyPos = trophyBlock.Position
        end
        farmStatusLbl.Text = "🏆 Kupa bulundu! Gidiliyor..."
        farmStatusLbl.TextColor3 = Color3.fromRGB(120,255,120)
        if useTeleport then
            if rootPart then
                rootPart.CFrame = CFrame.new(trophyPos + Vector3.new(0,3,0))
            end
        else
            walkToPosition(trophyPos + Vector3.new(0,2,0))
        end
        task.wait(0.5)
        farmStatusLbl.Text = "✅ Kupa alındı! Bekleniyor..."
        farmStatusLbl.TextColor3 = Color3.fromRGB(80,220,80)
    else
        -- Trophy bulunamazsa yürüyerek etrafı dolaş (stage çevresinde spiral)
        farmStatusLbl.Text = "🔄 Etraf taranıyor..."
        farmStatusLbl.TextColor3 = Color3.fromRGB(255,160,40)
        local offsets = {
            Vector3.new(5,2,0), Vector3.new(-5,2,0), Vector3.new(0,2,5), Vector3.new(0,2,-5),
            Vector3.new(8,2,8), Vector3.new(-8,2,8), Vector3.new(8,2,-8),
        }
        for _, off in ipairs(offsets) do
            if not farmRunning then break end
            local targetPos = stagePos + off
            if useTeleport then
                if rootPart then rootPart.CFrame = CFrame.new(targetPos) end
                task.wait(0.3)
            else
                walkToPosition(targetPos)
            end
        end
        farmStatusLbl.Text = "⚠️ Kupa bulunamadı, tekrar deneniyor"
        farmStatusLbl.TextColor3 = Color3.fromRGB(255,120,50)
    end
end

-- ==================== AUTO FARM BAŞLAT/DURDUR ====================
addSection(farmFrame, "AUTO STAGE FARM")
addToggleBtn(farmFrame, "🏆 " .. t("farm_start"), function(b)
    farmRunning = not farmRunning
    if farmRunning then
        b.Text = "⏹️ " .. t("farm_stop")
        b.BackgroundColor3 = Color3.fromRGB(180,40,40)
        farmStatusLbl.Text = "▶️ Başlatıldı!"
        farmThread = task.spawn(function()
            while farmRunning do
                local ok, err = pcall(runFarm)
                if not ok then
                    farmStatusLbl.Text = "❌ Hata: " .. tostring(err):sub(1,30)
                    farmStatusLbl.TextColor3 = Color3.fromRGB(255,80,80)
                end
                if farmRunning then
                    task.wait(farmDelay)
                end
            end
        end)
    else
        b.Text = "🏆 " .. t("farm_start")
        b.BackgroundColor3 = Color3.fromRGB(35,35,55)
        farmRunning = false
        if humanoid then humanoid:MoveTo(rootPart and rootPart.Position or Vector3.zero) end
        farmStatusLbl.Text = "⏸️ Durduruldu"
        farmStatusLbl.TextColor3 = Color3.fromRGB(180,180,220)
    end
end)

-- ==================== MISC ====================
local miscFrame = createScrollFrame()
addSection(miscFrame, t("misc_section"))
local fpsBoostOn = false
local origLighting = {}
addToggleBtn(miscFrame, t("fps_boost"), function(b)
    fpsBoostOn = not fpsBoostOn
    local lighting = game:GetService("Lighting")
    if fpsBoostOn then
        origLighting.GlobalShadows = lighting.GlobalShadows
        origLighting.Brightness = lighting.Brightness
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 1
        for _, v in ipairs(lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end
    else
        lighting.GlobalShadows = origLighting.GlobalShadows ~= nil and origLighting.GlobalShadows or true
        lighting.Brightness = origLighting.Brightness or 1
        for _, v in ipairs(lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = true
            end
        end
    end
    b.Text = fpsBoostOn and t("fps_boost_on") or t("fps_boost")
    b.BackgroundColor3 = fpsBoostOn and Color3.fromRGB(50,120,50) or Color3.fromRGB(35,35,55)
end)
local lowDetailOn = false
addToggleBtn(miscFrame, t("low_detail"), function(b)
    lowDetailOn = not lowDetailOn
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = lowDetailOn and 1 or 0 end
    end
    b.Text = lowDetailOn and t("low_detail_on") or t("low_detail")
    b.BackgroundColor3 = lowDetailOn and Color3.fromRGB(50,120,50) or Color3.fromRGB(35,35,55)
end)
local hidePlayersOn = false
addToggleBtn(miscFrame, t("hide_players"), function(b)
    hidePlayersOn = not hidePlayersOn
    for _, p2 in ipairs(Players:GetPlayers()) do
        if p2 ~= player and p2.Character then
            for _, v in ipairs(p2.Character:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Decal") then
                    v.LocalTransparencyModifier = hidePlayersOn and 1 or 0
                end
            end
        end
    end
    b.Text = hidePlayersOn and t("hide_players_on") or t("hide_players")
    b.BackgroundColor3 = hidePlayersOn and Color3.fromRGB(50,120,50) or Color3.fromRGB(35,35,55)
end)
local hideShadowsOn = false
addToggleBtn(miscFrame, t("hide_shadows"), function(b)
    hideShadowsOn = not hideShadowsOn
    game:GetService("Lighting").GlobalShadows = not hideShadowsOn
    b.Text = hideShadowsOn and t("hide_shadows_on") or t("hide_shadows")
    b.BackgroundColor3 = hideShadowsOn and Color3.fromRGB(50,120,50) or Color3.fromRGB(35,35,55)
end)
local hideParticlesOn = false
addToggleBtn(miscFrame, t("hide_particles"), function(b)
    hideParticlesOn = not hideParticlesOn
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = not hideParticlesOn
        end
    end
    b.Text = hideParticlesOn and t("hide_particles_on") or t("hide_particles")
    b.BackgroundColor3 = hideParticlesOn and Color3.fromRGB(50,120,50) or Color3.fromRGB(35,35,55)
end)
local maxFpsOn = false
addToggleBtn(miscFrame, t("max_fps"), function(b)
    maxFpsOn = not maxFpsOn
    settings().RenderQuality = maxFpsOn and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
    b.Text = maxFpsOn and t("max_fps_on") or t("max_fps")
    b.BackgroundColor3 = maxFpsOn and Color3.fromRGB(50,120,50) or Color3.fromRGB(35,35,55)
end)

-- ==================== AYARLAR ====================
local settingsFrame = createScrollFrame()
addSection(settingsFrame, t("settings_section"))
local currentToggleKey = Enum.KeyCode.RightShift
local listeningForKey = false
local keyRowFrame = Instance.new("Frame", settingsFrame)
keyRowFrame.Size = UDim2.new(1,-4,0,52)
keyRowFrame.BackgroundColor3 = Color3.fromRGB(20,20,36)
keyRowFrame.BorderSizePixel = 0
makeCorner(keyRowFrame, 8)
toggleKeyLabelRef = Instance.new("TextLabel", keyRowFrame)
toggleKeyLabelRef.Size = UDim2.new(1,0,0,22)
toggleKeyLabelRef.Position = UDim2.fromOffset(8,4)
toggleKeyLabelRef.Text = t("toggle_key")
toggleKeyLabelRef.BackgroundTransparency = 1
toggleKeyLabelRef.TextColor3 = Color3.fromRGB(200,200,220)
toggleKeyLabelRef.Font = Enum.Font.GothamBold
toggleKeyLabelRef.TextSize = 11
toggleKeyLabelRef.TextXAlignment = Enum.TextXAlignment.Left
local keyDisplayBtn = makeBtn(keyRowFrame, "RightShift", 140, 24, Color3.fromRGB(40,40,65))
keyDisplayBtn.Position = UDim2.fromOffset(8,26)
keyDisplayBtn.TextSize = 11
keyDisplayBtn.MouseButton1Click:Connect(function()
    if listeningForKey then return end
    listeningForKey = true
    keyDisplayBtn.Text = "[ tuşa bas... ]"
    keyDisplayBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    keyDisplayBtn.TextColor3 = Color3.new(1,1,1)
    local conn
    conn = UserInputService.InputBegan:Connect(function(inp, gpe)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            currentToggleKey = inp.KeyCode
            keyDisplayBtn.Text = inp.KeyCode.Name
            keyDisplayBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
            keyDisplayBtn.TextColor3 = Color3.new(1,1,1)
            listeningForKey = false
            conn:Disconnect()
        end
    end)
end)
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if not listeningForKey and inp.KeyCode == currentToggleKey then
        if frame.Visible or keyFrame.Visible then
            frame.Visible=false; keyFrame.Visible=false; tLogoFloat.Visible=true
        else
            tLogoFloat.Visible=false
            if keyVerified then frame.Visible=true else keyFrame.Visible=true end
        end
    end
end)
local opacityRowFrame = Instance.new("Frame", settingsFrame)
opacityRowFrame.Size = UDim2.new(1,-4,0,52)
opacityRowFrame.BackgroundColor3 = Color3.fromRGB(20,20,36)
opacityRowFrame.BorderSizePixel = 0
makeCorner(opacityRowFrame, 8)
opacityLabelRef = Instance.new("TextLabel", opacityRowFrame)
opacityLabelRef.Size = UDim2.new(1,0,0,22)
opacityLabelRef.Position = UDim2.fromOffset(8,4)
opacityLabelRef.Text = t("opacity_label") .. " — 100%"
opacityLabelRef.BackgroundTransparency = 1
opacityLabelRef.TextColor3 = Color3.fromRGB(200,200,220)
opacityLabelRef.Font = Enum.Font.GothamBold
opacityLabelRef.TextSize = 11
opacityLabelRef.TextXAlignment = Enum.TextXAlignment.Left
local opTrack = Instance.new("Frame", opacityRowFrame)
opTrack.Size = UDim2.new(1,-16,0,12)
opTrack.Position = UDim2.fromOffset(8,32)
opTrack.BackgroundColor3 = Color3.fromRGB(40,40,60)
opTrack.BorderSizePixel = 0
makeCorner(opTrack, 6)
local opFill = Instance.new("Frame", opTrack)
opFill.Size = UDim2.fromScale(1,1)
opFill.BackgroundColor3 = Color3.fromRGB(220,40,40)
opFill.BorderSizePixel = 0
makeCorner(opFill, 6)
local opKnob = Instance.new("Frame", opTrack)
opKnob.Size = UDim2.fromOffset(18,18)
opKnob.AnchorPoint = Vector2.new(0.5,0.5)
opKnob.Position = UDim2.new(1,0,0.5,0)
opKnob.BackgroundColor3 = Color3.new(1,1,1)
opKnob.BorderSizePixel = 0
opKnob.ZIndex = 3
makeCorner(opKnob, 9)
local opDragging = false
opTrack.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then opDragging=true end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then opDragging=false end
end)
RunService.Heartbeat:Connect(function()
    if opDragging then
        local mouse = UserInputService:GetMouseLocation()
        local ratio = math.clamp((mouse.X-opTrack.AbsolutePosition.X)/opTrack.AbsoluteSize.X, 0.1, 1)
        opFill.Size = UDim2.fromScale(ratio,1)
        opKnob.Position = UDim2.new(ratio,0,0.5,0)
        frame.BackgroundTransparency = 1-ratio
        leftPanel.BackgroundTransparency = 1-ratio
        opacityLabelRef.Text = t("opacity_label") .. " — " .. math.floor(ratio*100) .. "%"
    end
end)

local webhookRowFrame = Instance.new("Frame", settingsFrame)
webhookRowFrame.Size = UDim2.new(1,-4,0,90)
webhookRowFrame.BackgroundColor3 = Color3.fromRGB(20,20,36)
webhookRowFrame.BorderSizePixel = 0
makeCorner(webhookRowFrame, 8)
webhookLabelRef = Instance.new("TextLabel", webhookRowFrame)
webhookLabelRef.Size = UDim2.new(1,0,0,20)
webhookLabelRef.Position = UDim2.fromOffset(8,4)
webhookLabelRef.Text = t("webhook_label")
webhookLabelRef.BackgroundTransparency = 1
webhookLabelRef.TextColor3 = Color3.fromRGB(200,200,220)
webhookLabelRef.Font = Enum.Font.GothamBold
webhookLabelRef.TextSize = 11
webhookLabelRef.TextXAlignment = Enum.TextXAlignment.Left
local webhookBox = Instance.new("TextBox", webhookRowFrame)
webhookBox.Size = UDim2.new(1,-16,0,28)
webhookBox.Position = UDim2.fromOffset(8,26)
webhookBox.PlaceholderText = "https://discord.com/api/webhooks/..."
webhookBox.Text = ""
webhookBox.BackgroundColor3 = Color3.fromRGB(25,25,40)
webhookBox.TextColor3 = Color3.new(1,1,1)
webhookBox.PlaceholderColor3 = Color3.fromRGB(100,100,130)
webhookBox.Font = Enum.Font.Gotham
webhookBox.TextSize = 10
webhookBox.BorderSizePixel = 0
webhookBox.ClearTextOnFocus = false
makeCorner(webhookBox, 6)
webhookBtnRef = makeBtn(webhookRowFrame, t("webhook_btn"), 140, 26, Color3.fromRGB(88,101,242))
webhookBtnRef.Position = UDim2.fromOffset(8,58)
webhookBtnRef.TextSize = 11
webhookBtnRef.MouseButton1Click:Connect(function()
    local url = webhookBox.Text
    if url=="" or not url:find("discord.com/api/webhooks") then
        webhookBtnRef.Text = "✗ Geçersiz URL"
        webhookBtnRef.BackgroundColor3 = Color3.fromRGB(150,40,40)
        task.delay(2, function() webhookBtnRef.Text=t("webhook_btn"); webhookBtnRef.BackgroundColor3=Color3.fromRGB(88,101,242) end)
        return
    end
    local ok = pcall(function()
        local body = HttpService:JSONEncode({
            embeds = {{
                title = "WuiHub",
                description = string.format("**Oyuncu:** %s\n**UserID:** %d\n**PlaceID:** %d",
                    player.Name, player.UserId, game.PlaceId),
                color = 14418432,
                footer = { text = "WuiHub v2 by Wui" }
            }}
        })
        request({Url=url, Method="POST", Headers={["Content-Type"]="application/json"}, Body=body})
    end)
    webhookBtnRef.Text = ok and t("webhook_sent") or t("webhook_fail")
    webhookBtnRef.BackgroundColor3 = ok and Color3.fromRGB(50,150,50) or Color3.fromRGB(150,40,40)
    task.delay(2.5, function() webhookBtnRef.Text=t("webhook_btn"); webhookBtnRef.BackgroundColor3=Color3.fromRGB(88,101,242) end)
end)

-- ==================== SEKME BUTONLARI ====================
local genelTabBtn    = createTabBtn("🏠","Genel",62)
local playerTabBtn   = createTabBtn("🎮","Player",112)
local ps99TabBtn     = createTabBtn("🐾","PS99",162)
local farmTabBtn     = createTabBtn("🌾","Farm",212)
local miscTabBtn     = createTabBtn("⚙️","Misc",262)
local settingsTabBtn = createTabBtn("🔧","Ayarlar",312)

local allTabs = {
    {frame=genelFrame,    btn=genelTabBtn},
    {frame=playerFrame,   btn=playerTabBtn},
    {frame=ps99Frame,     btn=ps99TabBtn},
    {frame=farmFrame,     btn=farmTabBtn},
    {frame=miscFrame,     btn=miscTabBtn},
    {frame=settingsFrame, btn=settingsTabBtn},
}
local function switchTab(target, activeBtn)
    for _, tab in ipairs(allTabs) do
        tab.frame.Visible = false
        tab.btn.BackgroundColor3 = Color3.fromRGB(30,30,48)
        tab.btn.TextColor3 = Color3.new(1,1,1)
    end
    target.Visible = true
    activeBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    activeBtn.TextColor3 = Color3.new(1,1,1)
end

genelTabBtn.MouseButton1Click:Connect(function()    switchTab(genelFrame,    genelTabBtn)    end)
playerTabBtn.MouseButton1Click:Connect(function()   switchTab(playerFrame,   playerTabBtn)   end)
ps99TabBtn.MouseButton1Click:Connect(function()     switchTab(ps99Frame,     ps99TabBtn)     end)
farmTabBtn.MouseButton1Click:Connect(function()     switchTab(farmFrame,     farmTabBtn)     end)
miscTabBtn.MouseButton1Click:Connect(function()     switchTab(miscFrame,     miscTabBtn)     end)
settingsTabBtn.MouseButton1Click:Connect(function() switchTab(settingsFrame, settingsTabBtn) end)

-- ==================== KEY ====================
local CORRECT_KEY = "TOROS2024"
verifyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == CORRECT_KEY then
        keyVerified = true
        keyFrame.Visible = false
        frame.Visible = true
        switchTab(genelFrame, genelTabBtn)
    else
        keyBox.Text = ""
        keyBox.PlaceholderText = t("key_wrong")
    end
end)

-- ==================== GİZLE / AÇ ====================
local function hideGui()
    keyFrame.Visible=false; frame.Visible=false; tLogoFloat.Visible=true
end
local function showGui()
    tLogoFloat.Visible=false
    if keyVerified then frame.Visible=true; switchTab(genelFrame,genelTabBtn)
    else keyFrame.Visible=true end
end
closeKeyBtn.MouseButton1Click:Connect(hideGui)
hideKeyBtn.MouseButton1Click:Connect(hideGui)
hubCloseBtn.MouseButton1Click:Connect(hideGui)
hubHideBtn.MouseButton1Click:Connect(hideGui)
tLogoFloat.MouseButton1Click:Connect(showGui)
freeBtn.MouseButton1Click:Connect(function() end)
premiumBtn.MouseButton1Click:Connect(function() end)
discordKeyBtn.MouseButton1Click:Connect(function() end)

refreshLangBtns()