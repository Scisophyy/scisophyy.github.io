-- SithHub visual test UI. Run as a LocalScript in StarterPlayerScripts.
-- All controls change UI state only. No gameplay, remotes, or exploit APIs.
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
assert(player, "Run SithHub on the client")
local parent = player:WaitForChild("PlayerGui")
local previous = parent:FindFirstChild("SithHub")
if previous then previous:Destroy() end

local C = {bg = Color3.fromRGB(28,18,48), panel = Color3.fromRGB(23,0,34),
 border = Color3.fromRGB(87,32,125), text = Color3.fromRGB(172,123,201),
 accent = Color3.fromRGB(184,0,255), track = Color3.fromRGB(62,17,91)}
local function make(class, props, owner)
 local item = Instance.new(class)
 for key, value in pairs(props) do item[key] = value end
 item.Parent = owner
 return item
end
local gui = make("ScreenGui", {Name="SithHub", ResetOnSpawn=false, IgnoreGuiInset=false,
 ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=100}, parent)
local window = make("Frame", {Name="Window", Size=UDim2.fromOffset(510,550),
 Position=UDim2.fromScale(.5,.5), AnchorPoint=Vector2.new(.5,.5),
 BackgroundColor3=C.bg, BorderSizePixel=0, Active=true}, gui)
make("UIStroke", {Color=C.border, Thickness=2}, window)
local scale = make("UIScale", {Scale=1}, window)
local function fit()
 local camera = workspace.CurrentCamera
 if camera then scale.Scale=math.min(1, (camera.ViewportSize.X-24)/510, (camera.ViewportSize.Y-70)/550) end
end
fit()
local cameraConnection
local function watchCamera()
 if cameraConnection then cameraConnection:Disconnect() end
 local camera=workspace.CurrentCamera
 if camera then cameraConnection=camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit) end
 fit()
end
local connections={}
local function connect(signal, callback)
 local connection=signal:Connect(callback)
 table.insert(connections,connection)
 return connection
end
connect(workspace:GetPropertyChangedSignal("CurrentCamera"),watchCamera)
watchCamera()
local function text(owner, value, x,y,w,h,size)
 return make("TextLabel", {BackgroundTransparency=1, Position=UDim2.fromOffset(x,y),
 Size=UDim2.fromOffset(w,h), Text=value, TextColor3=C.text,
 Font=Enum.Font.Code, TextSize=size or 13, TextXAlignment=Enum.TextXAlignment.Left},owner)
end
local title=make("TextButton", {Name="DragHandle",Size=UDim2.new(1,-66,0,30),
 BackgroundColor3=C.track, BorderSizePixel=0, Text="  SithHub V1.0 | Combat  Force  Visuals",
 TextColor3=C.text, Font=Enum.Font.Code,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,
 AutoButtonColor=false},window)
local close=make("TextButton", {Position=UDim2.new(1,-32,0,0),Size=UDim2.fromOffset(32,30),
 BackgroundColor3=C.track,BorderSizePixel=0,Text="×",TextColor3=C.text,TextSize=22,
 Font=Enum.Font.Code},window)
local minimize=make("TextButton", {Position=UDim2.new(1,-66,0,0),Size=UDim2.fromOffset(34,30),
 BackgroundColor3=C.track,BorderSizePixel=0,Text="−",TextColor3=C.text,TextSize=22,
 Font=Enum.Font.Code},window)
local body=make("Frame",{Size=UDim2.new(1,0,1,-30),Position=UDim2.fromOffset(0,30),
 BackgroundTransparency=1},window)
local function section(name,x,y,w,h)
 local panel=make("Frame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),
 BackgroundColor3=C.panel,BorderSizePixel=0},body)
 make("UIStroke",{Color=C.border,Thickness=1},panel)
 local heading=text(panel," "..name.." ",12,-10,w-24,20,13)
 heading.BackgroundTransparency=0
 heading.BackgroundColor3=C.bg
 return panel
end
local function toggle(panel,label,y)
 local button=make("TextButton",{Name=label,Position=UDim2.fromOffset(8,y),
 Size=UDim2.new(1,-16,0,27),BackgroundTransparency=1,Text="",AutoButtonColor=false},panel)
 local box=make("Frame",{Position=UDim2.fromOffset(2,7),Size=UDim2.fromOffset(12,12),
 BackgroundColor3=C.track,BorderSizePixel=0},button)
 make("UIStroke",{Color=C.border,Thickness=1},box)
 local mark=text(box,"",0,-2,12,16,13)
 mark.TextColor3=C.accent
 mark.TextXAlignment=Enum.TextXAlignment.Center
 text(button,label,23,0,185,27)
 button:SetAttribute("Enabled",false)
 connect(button.Activated,function()
  local enabled=not button:GetAttribute("Enabled")
  button:SetAttribute("Enabled",enabled)
  mark.Text=enabled and "✓" or ""
  box.BackgroundColor3=enabled and Color3.fromRGB(79,18,110) or C.track
 end)
end
local combat=section("Combat",16,20,228,132)
toggle(combat,"Auto-Parry",16)
toggle(combat,"Aimlock",49)
toggle(combat,"Combo Macros",82)
local force=section("Force Powers",266,20,228,100)
toggle(force,"All Force Powers",16)
toggle(force,"Infinite Force",49)
local resources=section("Resources",16,174,228,100)
toggle(resources,"Infinite Parries",16)
toggle(resources,"Infinite Kicks",49)
local hitbox=section("Hitbox",266,142,228,132)
toggle(hitbox,"Hitbox Expander",16)
local sizeLabel=text(hitbox,"Hitbox Size: 10",10,50,210,23)
local track=make("TextButton",{Name="HitboxSize",Position=UDim2.fromOffset(10,85),
 Size=UDim2.fromOffset(208,16),BackgroundColor3=C.track,BorderSizePixel=0,Text="",
 AutoButtonColor=false,Active=true},hitbox)
make("UIStroke",{Color=C.border,Thickness=1},track)
local fill=make("Frame",{Size=UDim2.fromScale(9/49,1),BackgroundColor3=C.accent,
 BorderSizePixel=0},track)
make("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(77,14,107),C.accent)},fill)
local knob=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(9/49,.5),
 Size=UDim2.fromOffset(5,22),BackgroundColor3=C.text,BorderSizePixel=0},track)
track:SetAttribute("Value",10)
text(hitbox,"1",10,105,30,18,11)
local maximum=text(hitbox,"50",188,105,30,18,11)
maximum.TextXAlignment=Enum.TextXAlignment.Right
local notice=make("Frame",{Position=UDim2.fromOffset(16,298),Size=UDim2.fromOffset(478,78),
 BackgroundColor3=C.panel,BorderSizePixel=0},body)
make("UIStroke",{Color=C.border,Thickness=1},notice)
local message=text(notice,"Down with the System, Free Sports center.",12,10,454,58,16)
message.TextColor3=C.accent
message.TextXAlignment=Enum.TextXAlignment.Center
message.TextWrapped=true
local footer=text(body,"Private TKG Closet & Rage Cheats",16,423,478,37,23)
footer.TextColor3=C.accent
footer.TextXAlignment=Enum.TextXAlignment.Center
footer.Font=Enum.Font.RobotoCondensed
text(body,"Made by Scisophy",16,463,478,23,14).TextXAlignment=Enum.TextXAlignment.Center
text(body,"Right Shift: show / hide",16,488,478,18,11).TextXAlignment=Enum.TextXAlignment.Center

local sliding, sliderTouch=false,nil
local dragging, dragTouch, dragOrigin, windowOrigin=false,nil,nil,nil
local function updateSlider(x)
 local fraction=math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
 local value=math.floor(1+fraction*49+.5)
 fraction=(value-1)/49
 track:SetAttribute("Value",value)
 sizeLabel.Text="Hitbox Size: "..value
 fill.Size=UDim2.fromScale(fraction,1)
 knob.Position=UDim2.fromScale(fraction,.5)
end
connect(track.InputBegan,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  sliding=true
  sliderTouch=input.UserInputType==Enum.UserInputType.Touch and input or nil
  updateSlider(input.Position.X)
 end
end)
connect(title.InputBegan,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  dragging=true
  dragTouch=input.UserInputType==Enum.UserInputType.Touch and input or nil
  dragOrigin=input.Position
  windowOrigin=window.Position
 end
end)
connect(UIS.InputChanged,function(input)
 if sliding and (input==sliderTouch or (not sliderTouch and input.UserInputType==Enum.UserInputType.MouseMovement)) then
  updateSlider(input.Position.X)
 end
 if dragging and (input==dragTouch or (not dragTouch and input.UserInputType==Enum.UserInputType.MouseMovement)) then
  local delta=input.Position-dragOrigin
  window.Position=UDim2.new(windowOrigin.X.Scale,windowOrigin.X.Offset+delta.X,
   windowOrigin.Y.Scale,windowOrigin.Y.Offset+delta.Y)
 end
end)
connect(UIS.InputEnded,function(input)
 if input==sliderTouch or input.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false; sliderTouch=nil end
 if input==dragTouch or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false; dragTouch=nil end
end)
connect(UIS.InputBegan,function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.RightShift then gui.Enabled=not gui.Enabled end
end)
connect(minimize.Activated,function()
 body.Visible=not body.Visible
 window.Size=UDim2.fromOffset(510,body.Visible and 550 or 30)
 minimize.Text=body.Visible and "−" or "+"
end)
connect(close.Activated,function() gui:Destroy() end)
gui.Destroying:Connect(function()
 for _,connection in ipairs(connections) do connection:Disconnect() end
 if cameraConnection then cameraConnection:Disconnect() end
end)
