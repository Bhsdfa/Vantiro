Rem Made by Bhsdfa!
Rem Thanks to miojo157 (with player sprites and logo), Zachary Spriggs (with controller xinput support) and Delsus (with the french translation).
Rem File creation date: 27-Aug-24 (1:02 PM BRT)
Rem Last update date: 10-Feb-25 (1:24:30 AM BRT)
Rem Apps used: TILED e QB64pe
Rem TILED: https://www.mapeditor.org/    -=-    QB64pe: https://qb64phoenix.com/
Rem Version of file: 1.1v07b
Rem Vantiro.bas:

Rem Weapon suggestion to add:
Rem fire guns:
Rem AK-47,  .45 Schofield,  RPG

Rem Throwables:
Rem Molotov,  Snowball

Rem Melee:
Rem Baseball bat,  Knife,  Axe,


'THIS BUILD IS MADE FOR LINUX, WINDOWS WILL NOT BE GUARANTEED TO WORK.
IHaveGoodPC = 1
Dim Shared Missing
Missing = LoadImage("assets/missing.png", 32)
_DisplayOrder _Hardware , _Software
Const LEFT_BUMPER = 256: Const RIGHT_BUMPER = 512: Const D_UP = 1: Const D_RIGHT = 8: Const D_DOWN = 2: Const D_LEFT = 4: Const X_BUTTON = 16384: Const Y_BUTTON = -32768: Const B_BUTTON = 8192: Const A_BUTTON = 4096: Const BACK = 32: Const L_STICK = 64: Const R_STICK = 128: Const LEFT_THUMB_DEADZONE = 7849: Const RIGHT_THUMB_DEADZONE = 8689: Const TRIGGER_THRESHOLD = 30: Const ABSOLUTE_POSITIVE = 32767: Const ABSOLUTE_NEGATIVE = -32767: Const MOTOR_FULL = 65535: Const BATTERY_TYPE_DISCONNECTED = 0: Const BATTERY_TYPE_WIRED = 1: Const BATTERY_TYPE_ALKALINE = 2: Const BATTERY_TYPE_NIMH = 3: Const BATTERY_TYPE_UNKNOWN = &HFF: Const BATTERY_LEVEL_EMPTY = 0: Const BATTERY_LEVEL_LOW = 1: Const BATTERY_LEVEL_MEDIUM = 2: Const BATTERY_LEVEL_FULL = 3: Const BATTERY_DEVTYPE_GAMEPAD = &H00: Const ERROR_DEVICE_NOT_CONNECTED = 1167: Const ERROR_SUCCESS = 0
Type XINPUT_GAMEPAD
    wButtons As Integer
    bLeftTrigger As _Unsigned _Byte
    bRightTrigger As _Unsigned _Byte
    sThumbLX As Integer
    sThumbLY As Integer
    sThumbRX As Integer
    sThumbRY As Integer
End Type
Type XINPUT_VIBRATION
    wLeftMotorSpeed As Integer
    wRightMotorSpeed As Integer
End Type
Type XINPUT_STATE
    dwPacketNumber As Long
    Gamepad As XINPUT_GAMEPAD
End Type
Type XINPUT_BATTERY_INFORMATION
    BatteryType As _Unsigned _Byte
    BatteryLevel As _Unsigned _Byte
End Type
'w Declare Dynamic Library "Xinput1_4"
'w    Function XInputGetState& (ByVal dwUserIndex As _Unsigned Long, ByVal pState As _Offset)
'w    Function XInputSetState& (ByVal dwUserIndex As _Unsigned Long, ByVal pVibration As _Offset)
'w    Function XInputGetBatteryInformation& (ByVal dwUserIndex As _Unsigned Long, ByVal devType As _Byte, ByVal pBatteryInformation As _Offset)
'w End Declare
Dim Shared XInputControllerTest As Long: Dim Shared UpBT As Long: Dim Shared DownBT As Long: Dim Shared RightBT As Long: Dim Shared LeftBT As Long: Dim Shared LBumperBT As Long: Dim Shared RBumperBT As Long: Dim Shared BackBT As Long: Dim Shared StartBT As Long: Dim Shared YBT As Long: Dim Shared XBT As Long: Dim Shared BBT As Long: Dim Shared ABT As Long: Dim Shared LeftStickY As Long: Dim Shared LeftStickYLB As Long: Dim Shared LeftStickX As Long: Dim Shared LeftStickXLB As Long: Dim Shared RightStickY As Long: Dim Shared RightStickYLB As Long: Dim Shared RightStickX As Long: Dim Shared RightStickXLB As Long: Dim Shared LeftStickBT As Long: Dim Shared RightStickBT As Long: Dim Shared BatteryLevelLB As Long: Dim Shared Battery As Long: Dim Shared LeftMotorBT As Long: Dim Shared RightMotorBT As Long: Dim Shared LMotorIntensityTB As Long: Dim Shared RMotorIntensityTB As Long: Dim Shared LeftTrigVal As Long: Dim Shared RightTrigVal As Long: Dim Shared LeftTrigger As Long: Dim Shared RightTrigger As Long: Dim Shared gamepadstate As XINPUT_STATE: Dim Shared vibrate As XINPUT_VIBRATION: Dim Shared stopvibe As XINPUT_VIBRATION
stopvibe.wLeftMotorSpeed = 0: stopvibe.wRightMotorSpeed = 0
Dim Shared stickvibe As XINPUT_VIBRATION: Dim Shared vibe As Long: Dim Shared batteryinfo As XINPUT_BATTERY_INFORMATION

'$Dynamic
$Resize:On
Icon = LoadImage("assets/Vantiro-1.1v07b/vantirologo.png", 32)
_Icon Icon, Icon
_Title "Vantiro"
MenuTransitionImage = _NewImage(32, 32, 32)
Const PI = 3.14159265359: Const PIDIV180 = PI / 180
Randomize Timer
Dim Shared MainScreen: Dim Shared SecondScreen
MainScreen = _NewImage(1230, 662, 32): SecondScreen = _NewImage(1230, 662, 32)
Screen MainScreen
Type Mouse
    x As Long: y As Long
    x1 As Long: y1 As Long: x2 As Long: y2 As Long
    xbz As Double: ybz As Double: xaz As Double: yaz As Double
    click As Integer: click2 As Integer: click3 As Integer
    scroll As Integer
End Type
Dim Shared Mouse As Mouse
Type Config
    'Visual
    Hud_SmoothingY As Double
    Hud_SmoothingX As Double
    Hud_Size As Double
    Hud_Side As String
    Hud_Fade As Double
    Hud_XMYMDivide As Double
    Hud_SelectedColor As Long
    Hud_UnSelectedColor As Long
    Hud_Distselmult As Double
    Hud_Distselfall As Double
    Hud_SelRed As Integer
    Hud_SelGreen As Integer
    Hud_SelBlue As Integer
    Hud_UnSelRed As Integer
    Hud_UnSelGreen As Integer
    Hud_UnSelBlue As Integer
    Map_Lighting As Integer

    'Player
    Player_MaxHealth As Double
    Player_Size As Double
    Player_MaxSpeed As Double
    Player_Accel As Double
    Player_Accuracy As Double
    Player_HealthPerBlood As Double
    Player_DamageMultiplier As Double
    Gun_Pistol_MaxAmmo As Integer
    Gun_Shotgun_MaxAmmo As Integer
    Gun_SMG_MaxAmmo As Integer
    Gun_Grenade_MaxAmmo As Integer
    Gun_Flame_MaxAmmo As Integer

    'Waves
    Wave_End As Integer
    Wave_ZombieMultiplier As Double
    Wave_TimeLimit As Long
    Wave_ZombieRandom As Integer

    'Zombie
    Zombie_OldAI As Integer
    Zombie_DefMaxSpeed As Double
    Zombie_DefSize As Double
    Zombie_DefTickRate As Integer
    Zombie_DefMaxDamage As Double
    Zombie_DefMinDamage As Double
    Zombie_DefMaxHealth As Double
    Zombie_DefMinHealth As Double

    'Limits
    ParticlesMax As Integer
    ZombiesMax As Integer
    FireMax As Integer
    BiohazardFluidMax As Integer
End Type
Dim Shared Config As Config
'# Hud settings.
Config.Hud_SmoothingY = 10 ' (Def: 10)
Config.Hud_SmoothingX = 10 ' (Def: 10)
Config.Hud_Distselfall = 4 ' (Def: 4)
Config.Hud_Distselmult = 5 ' (Def: 5)
Config.Hud_Size = 35 ' (Def: 35)
Config.Hud_Side = "Down" ' (Def: Down)
Config.Hud_Fade = 50 ' (Def: 50)
Config.Hud_XMYMDivide = 1.075 ' (Def: 1.1)
Config.Hud_SelectedColor = -1 ' (Def: -1)
Config.Hud_UnSelectedColor = -8355712 ' (Def: -8355712)
Config.Map_Lighting = 1 ' (Def: 1)
'# Player settings.
Config.Player_MaxSpeed = 70 ' (Def: 70)
Config.Player_Accel = 3 ' (Def: 3)
Config.Player_Size = 25 ' (Def: 25)
Config.Player_MaxHealth = 101 ' (Def: 101)
Config.Player_HealthPerBlood = 0.11 ' (Def: 0.11)
Config.Player_DamageMultiplier = 1 ' (Def: 1)
'# Waves settings.
Config.Wave_End = 11 ' (Def: 11)
Config.Wave_ZombieMultiplier = 7 ' (Def: 7)
Config.Wave_ZombieRandom = 22 ' (Def: 22)
Config.Wave_TimeLimit = -1 ' (Def: -1)
'# Zombie settings. (Mainly Health is used)
Config.Zombie_OldAI = 1 ' (Def: 1)
Config.Zombie_DefMaxSpeed = 820 ' (Def: 820)
Config.Zombie_DefSize = 26 ' (Def: 26)
Config.Zombie_DefTickRate = 15 ' (Def: 15)
Config.Zombie_DefMaxDamage = 10 ' (Def: 10)
Config.Zombie_DefMinDamage = 4 ' (Def: 4)
Config.Zombie_DefMaxHealth = 100 ' (Def: 100)
Config.Zombie_DefMinHealth = 70 ' (Def: 70)
'# Limit settings.
Config.ParticlesMax = 600 ' (Def: 600)
Config.ZombiesMax = 190 ' (Def: 190)
Config.FireMax = 128 ' (Def: 128)
Config.BiohazardFluidMax = 32 ' (Def: 32)


Config.Hud_SelRed = _Red32(Config.Hud_SelectedColor)
Config.Hud_SelGreen = _Green32(Config.Hud_SelectedColor)
Config.Hud_SelBlue = _Blue32(Config.Hud_SelectedColor)

Config.Hud_UnSelRed = _Red32(Config.Hud_UnSelectedColor)
Config.Hud_UnSelGreen = _Green32(Config.Hud_UnSelectedColor)
Config.Hud_UnSelBlue = _Blue32(Config.Hud_UnSelectedColor)


Dim line$
If _FileExists("assets/Vantiro-1.1v07b/config.ini") Then
    LoadConfigs
Else
    Beep
    Print "Error: (assets/Vantiro-1.1v07b/config.ini) not found, generating file."
    _Display
    _Delay 2
    SaveConfig
End If

Type Map
    tileset As String
    MaxWidth As _Unsigned Integer
    MaxHeight As _Unsigned Integer
    Layers As _Unsigned Integer
    TileSize As _Unsigned Integer
    TileSizeZoom As Double
    TileSizeHalf As Double
    TileShadowSize As Double
    Title As String
    TextureSize As _Unsigned Integer
    Triggers As Integer
End Type
Dim Shared Map As Map

Type Entity
    x As Double
    y As Double
    x1 As Long
    y1 As Long
    x2 As Long
    y2 As Long
    target As String ' Can be: Player and Point
    AIstate As String ' can be: Chase, ChasePoint, Idle, Roaming and Retreat
    pointfollow As Integer
    oldpointfollow As Integer
    pointtries As Double
    targetx As Double
    targety As Double
    size As Double
    sizeFirst As Double
    xm As Double
    ym As Double
    rotation As Double
    health As Double
    Healthfirst As Double
    damage As Double
    attacking As Integer
    attackcooldown As Integer
    tick As Integer
    active As Integer
    DistanceFromPlayer As Integer
    weight As Double
    maxspeed As Integer
    speeding As Double
    knockback As Double
    onfire As Integer
    special As String
    SpecialDelay As Double
    DamageCooldown As Double
    DamageTaken As Double
End Type
Type DefEntity
    maxspeed As Double
    maxhealth As Integer
    minhealth As Integer
    maxdelay As Integer
    mindelay As Integer
    tickrate As Integer
    mindamage As Integer
    maxdamage As Integer
    size As Integer
End Type
Dim Shared ZombieMax As Long
PlayerSkin = 1
Dim Shared PlayerSprite(4)
Dim Shared PlayerHand(4)
PlayerSprite(1) = LoadImage("assets/Vantiro-1.1v07b/player/player1.png", 33)
PlayerHand(1) = LoadImage("assets/Vantiro-1.1v07b/player/hand1.png", 33)
PlayerSprite(2) = LoadImage("assets/Vantiro-1.1v07b/player/player2.png", 33)
PlayerHand(2) = LoadImage("assets/Vantiro-1.1v07b/player/hand1.png", 33)
PlayerSprite(3) = LoadImage("assets/Vantiro-1.1v07b/player/player3.png", 33)
PlayerHand(3) = LoadImage("assets/Vantiro-1.1v07b/player/hand3.png", 33)
PlayerSprite(4) = LoadImage("assets/Vantiro-1.1v07b/player/player4.png", 33)
PlayerHand(4) = LoadImage("assets/Vantiro-1.1v07b/player/hand4.png", 33)
BloodDrop = LoadImage("assets/Vantiro-1.1v07b/Blooddrop.png", 32)
Dim Shared PlayerDamage
Dim Shared PlayerDeath
PlayerDamage = _SndOpen("assets/Vantiro-1.1v07b/player/sounds/au.wav")
PlayerDeath = _SndOpen("assets/Vantiro-1.1v07b/player/sounds/ua.wav")
FlameThrowerSound = _SndOpen("assets/Vantiro-1.1v07b/sounds/interior_fire01_stereo.wav")

Dim Shared ZombieWalk(4)
ZombieWalk(1) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/headless_1.wav")
ZombieWalk(2) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/headless_2.wav")
ZombieWalk(3) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/headless_3.wav")
ZombieWalk(4) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/headless_4.wav")

Dim Shared ZombieShot(16)
ZombieShot(1) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_01.wav")
ZombieShot(2) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_02.wav")
ZombieShot(3) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_03.wav")
ZombieShot(4) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_04.wav")
ZombieShot(5) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_05.wav")
ZombieShot(6) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_06.wav")
ZombieShot(7) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_07.wav")
ZombieShot(8) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_08.wav")
ZombieShot(9) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_09.wav")
ZombieShot(10) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_10.wav")
ZombieShot(11) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_11.wav")
ZombieShot(12) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_12.wav")
ZombieShot(13) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_13.wav")
ZombieShot(14) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_14.wav")
ZombieShot(15) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_15.wav")
ZombieShot(16) = _SndOpen("assets/Vantiro-1.1v07b/mobs/sounds/shot/been_shot_16.wav")

ZombieMax = Config.ZombiesMax
Dim Shared Zombie(ZombieMax) As Entity
Dim Shared DefZombie As DefEntity
DefZombie.maxspeed = Config.Zombie_DefMaxSpeed
DefZombie.size = Config.Zombie_DefSize
DefZombie.tickrate = Config.Zombie_DefTickRate
DefZombie.maxdamage = Config.Zombie_DefMaxDamage
DefZombie.mindamage = Config.Zombie_DefMinDamage
DefZombie.maxhealth = Config.Zombie_DefMaxHealth
DefZombie.minhealth = Config.Zombie_DefMinHealth

Type Player
    x As Double
    y As Double
    xb As Double
    yb As Double
    x1 As Long
    x2 As Long
    y1 As Long
    y2 As Long
    size As Integer
    xm As Double
    ym As Double
    Rotation As Double
    TouchX As Integer
    TouchY As Integer
    Health As Double
    DamageToTake As Integer
    DamageCooldown As Integer
    Armor As Double
    shooting As Double
    weapon1id As Integer
    weapon2id As Integer
End Type
Dim Shared Player As Player
Type PlayerMembers
    x As Double
    y As Double
    xo As Double
    yo As Double
    xbe As Double
    ybe As Double
    angle As Double
    xvector As Double
    yvector As Double
    mode As Double
    visible As Double
    speed As Double
    angleanim As Double
    distanim As Double
End Type
Dim Shared PlayerMember(2) As PlayerMembers
Type Raycast
    x As Double
    y As Double
    angle As Double
    damage As Double
    knockback As Double
    owner As Integer
End Type
Dim Shared Ray As Raycast
Dim Shared RayM(3) As Raycast
Type Tiles
    ID As Long
    solid As Integer
    toplayer As Integer
    animationframe As Integer
    rend_spritex As Long
    rend_spritey As Long
    alight As Integer
    dlight As Integer
    associated As Integer
    x1t As Integer
    x2t As Integer
    y1t As Integer
    y2t As Integer
    fragile As Integer
    transparent As Integer
End Type
Type Weapon
    x As Double
    y As Double
    xm As Double
    ym As Double
    visible As Integer
    cangrab As Integer
    rotation As Double
    wtype As Integer
    shooting As Integer
End Type
Dim Shared GunDisplay As Weapon
Type Menu
    x1d As Double
    x2d As Double
    y1d As Double
    y2d As Double
    x1 As Long
    x2 As Long
    y1 As Long
    y2 As Long
    Colors As Long
    red As Integer
    green As Integer
    blue As Integer
    text As String
    textsize As Integer
    hex As String
    style As Integer
    clicktogo As String
    extra As Integer
    extra2 As Integer
    extra3 As Integer
    visual As Integer
    visual2 As String
    d_hover As Integer
    d_clicked As Integer
    OffsetY As Double
    OffsetX As Double
End Type
Type Hud
    x1 As Long
    x2 As Long
    y1 As Long
    y2 As Long
    x As Double
    xp As Double
    yp As Double
    y As Double
    xm As Double
    ym As Double
    offsetx As Double
    xbe As Double
    ybe As Double
    rotation As Double
    rotationbe As Double
    rotationoffset As Double
    stringered As Long
    size As Long
    textsize As Integer
End Type
Type Trigger
    x1 As Double
    y1 As Double
    x2 As Double
    y2 As Double
    sizex As Double
    sizey As Double
    class As String
    val1 As Double
    val2 As Double
    val3 As Double
    val4 As Double
    text As String
    textspeed As Double
    triggername As String
    needclick As Integer
End Type
Type MapLoader
    MapExist As Integer
    FileName As String
    HasImage As Integer
    ImageID As Integer
End Type
Dim MapLoader(1) As MapLoader
Dim MapLoaderImage(1)
Type GunAtt
    sprite As Long
    NameIMG As Long
    DamageMin As Double
    DamageMax As Double
    Sprayangle As Double
    RoundSize As _Unsigned Integer
    MaxRounds As _Unsigned Long
    Recoil As Double
    TimeToFire As Double
End Type
Dim Shared GunAttribute(20) As GunAtt

Dim Shared SelectedHudID, LastSelectedHudID


VantiroTitulo = LoadImage("assets/Vantiro-1.1v07b/Vantiro.png", 33)
Background1 = LoadImage("assets/Vantiro-1.1v07b/Background.png", 33)
HudWeaponMax = 16
Dim Shared Hud(HudWeaponMax) As Hud
Dim Shared Hud2(32) As Hud

For i = 1 To 32
    Hud2(i).x = _Width / 2
    Hud2(i).y = _Height
Next

For i = 1 To HudWeaponMax
    Hud(i).x = _Width / 2
    Hud(i).y = _Height
Next
Dim Shared rendcamerax1, rendcamerax2, rendcameray1, rendcameray2

Dim Shared DebugHud(12) As Menu
Dim Shared Minimap As Hud
Dim Shared MenuMax
MenuMax = 64
Dim Shared Menu(MenuMax) As Menu
Dim Shared MenuAnim As Menu
For i = 1 To MenuMax
    Menu(i).x1 = 0: Menu(i).x2 = 0: Menu(i).y1 = 0: Menu(i).y2 = 0: Menu(i).Colors = 0: Menu(i).red = 0: Menu(i).green = 0: Menu(i).blue = 0
    Menu(i).text = " "
    Menu(i).textsize = -1
    Menu(i).hex = ""
    Menu(i).style = 0
    Menu(i).clicktogo = ""
    Menu(i).extra = 0
    Menu(i).d_hover = 0
    Menu(i).d_clicked = 0
Next
Dim Shared Colors As Long
Begsfont$ = "assets/begs world/mouse.ttf"
Dim Shared BegsFontSizes(1024)
Dim Shared MenusImages(128)
For i = 1 To 1024
    BegsFontSizes(i) = _LoadFont(Begsfont$, i, "")
Next
CanLeave = 0
ToLoad$ = "menu": ToLoad2$ = "menu"
GoSub load
_Dest MainScreen
Do
    _Limit 75
    Cls
    GoSub MenuSystem
    _SetAlpha 0, _RGB32(0, 0, 0), MainScreen
    _Display
Loop While quit = 0
Input "Select a map", Map$
'Map$ = "forest"

MinimapTxtSize = 16
MinimapTxtSize2 = 1 / MinimapTxtSize


MapLoaded = LoadMapSettings(Map$)
Dim Shared Trigger(Map.Triggers) As Trigger

MinimapIMGsft = _NewImage(Map.MaxWidth * MinimapTxtSize, Map.MaxHeight * MinimapTxtSize, 32)
MinimapIMG = _CopyImage(MinimapIMGsft, 33)


Dim Shared Tile(Map.MaxWidth + 20, Map.MaxHeight + 20, 3) As Tiles
MapLoaded = LoadMap(Map$)
Dim Shared LastPart As Integer, Tileset, TilesetSoft


Tileset = LoadImage("assets/Vantiro-1.1v07b/" + _Trim$(Map.tileset) + ".png", 33)
TilesetSoft = LoadImage("assets/Vantiro-1.1v07b/" + _Trim$(Map.tileset) + ".png", 32)


E_KeyIcon = LoadImage("assets/Vantiro-1.1v07b/items/ekeyicon.png", 33)
Dim Shared Guns_Hammer, Guns_Pistol, Guns_Shotgun, Guns_SMG, Guns_Flame, Guns_Grenade, Guns_Chainsaw
Guns_Hammer = LoadImage("assets/Vantiro-1.1v07b/items/hammer.png", 33)
Guns_Pistol = LoadImage("assets/Vantiro-1.1v07b/items/pistol.png", 33)
Guns_Shotgun = LoadImage("assets/Vantiro-1.1v07b/items/shotgun.png", 33)
Guns_SMG = LoadImage("assets/Vantiro-1.1v07b/items/smg.png", 33)
Guns_Flame = LoadImage("assets/Vantiro-1.1v07b/items/flamethrower.png", 33)
Guns_Grenade = LoadImage("assets/Vantiro-1.1v07b/items/grenade.png", 33)
Guns_Chainsaw = CreateImageText(Guns_Chainsaw, "Chainsaw", 25)
HudSelected = LoadImage("assets/Vantiro-1.1v07b/Selected.png", 33)
HudNotSelected = LoadImage("assets/Vantiro-1.1v07b/NotSelected.png", 33)
HudNoAmmo = LoadImage("assets/Vantiro-1.1v07b/NoAmmo.png", 33)
Dim Shared Zombie, ZombieRunner, ZombieSlower, ZombieBomber, ZombieBiohazard, ZombieBrute, ZombieFire
Zombie = LoadImage("assets/Vantiro-1.1v07b/mobs/zombie.png", 33)
ZombieRunner = LoadImage("assets/Vantiro-1.1v07b/mobs/fastzombie.png", 33)
ZombieSlower = LoadImage("assets/Vantiro-1.1v07b/mobs/slowzombie.png", 33)
ZombieBomber = LoadImage("assets/Vantiro-1.1v07b/mobs/bomberzombie.png", 33)
ZombieBiohazard = LoadImage("assets/Vantiro-1.1v07b/mobs/zombie.png", 33) ' GIVE ME IMAGE
ZombieBrute = LoadImage("assets/Vantiro-1.1v07b/mobs/zombie.png", 33) 'GIVE ME IMAGE
ZombieFire = LoadImage("assets/Vantiro-1.1v07b/mobs/firezombie.png", 33)

Dim Shared ZombieSpawner(7)
ZombieSpawner(1) = Zombie
ZombieSpawner(2) = ZombieSlower
ZombieSpawner(3) = ZombieRunner
ZombieSpawner(4) = ZombieBomber
ZombieSpawner(5) = ZombieBiohazard
ZombieSpawner(6) = ZombieBrute
ZombieSpawner(7) = ZombieFire

Dim Shared ShellShotgunAmmo, PistolShellAmmo, GasCanAmmo
ShellShotgunAmmo = LoadImage("assets/Vantiro-1.1v07b/items/shotgunammo.png", 33)
PistolShellAmmo = LoadImage("assets/Vantiro-1.1v07b/items/pistolammo.png", 33)
GasCanAmmo = LoadImage("assets/Vantiro-1.1v07b/items/gascan.png", 33)


'Particles
Dim Shared WallShot, GlassShard, BloodsplatGreen, BloodsplatRed, Gib_Skull, Gib_Bone, Bloodsplat, Bloodonground
WallShot = LoadImage("assets/Vantiro-1.1v07b/items/wallshot.png", 33)
GlassShard = LoadImage("assets/Vantiro-1.1v07b/items/glassshard.png", 33)
BloodsplatGreen = LoadImage("assets/Vantiro-1.1v07b/items/bloodsplatgreen.png", 33)
BloodsplatRed = LoadImage("assets/Vantiro-1.1v07b/items/bloodsplatred.png", 33)
Gib_Skull = LoadImage("assets/Vantiro-1.1v07b/items/skull.png", 33)
Gib_Bone = LoadImage("assets/Vantiro-1.1v07b/items/bone.png", 33)
Bloodonground = LoadImage("assets/Vantiro-1.1v07b/items/bloodonground.png", 33)

Guns_Sound_PistolShot = _SndOpen("assets/Vantiro-1.1v07b/sounds/pistolshot.wav")
Guns_Sound_ShotgunShot = _SndOpen("assets/Vantiro-1.1v07b/sounds/shotgunshot.wav")


Dim Shared FireParticles(3)
FireParticle = LoadImage("assets/Vantiro-1.1v07b/items/fire1.png", 33)
FireParticles(1) = LoadImage("assets/Vantiro-1.1v07b/items/fire1.png", 33)
FireParticles(2) = LoadImage("assets/Vantiro-1.1v07b/items/fire2.png", 33)
FireParticles(3) = LoadImage("assets/Vantiro-1.1v07b/items/fire3.png", 33)

Dim SMGSounds(3)
SMGSounds(1) = _SndOpen("assets/Vantiro-1.1v07b/sounds/hks1.wav")
SMGSounds(2) = _SndOpen("assets/Vantiro-1.1v07b/sounds/hks2.wav")
SMGSounds(3) = _SndOpen("assets/Vantiro-1.1v07b/sounds/hks3.wav")

Dim ShellSounds(3)
ShellSounds(1) = _SndOpen("assets/Vantiro-1.1v07b/sounds/sshell1.wav")
ShellSounds(2) = _SndOpen("assets/Vantiro-1.1v07b/sounds/sshell2.wav")
ShellSounds(3) = _SndOpen("assets/Vantiro-1.1v07b/sounds/sshell3.wav")
Dim PistolShellSounds(3)
PistolShellSounds(1) = _SndOpen("assets/Vantiro-1.1v07b/sounds/pl_shell1.wav")
PistolShellSounds(2) = _SndOpen("assets/Vantiro-1.1v07b/sounds/pl_shell2.wav")
PistolShellSounds(3) = _SndOpen("assets/Vantiro-1.1v07b/sounds/pl_shell3.wav")

Dim BloodSounds(6)
BloodSounds(1) = _SndOpen("assets/Vantiro-1.1v07b/sounds/flesh1.wav"): BloodSounds(2) = _SndOpen("assets/Vantiro-1.1v07b/sounds/flesh2.wav"): BloodSounds(3) = _SndOpen("assets/Vantiro-1.1v07b/sounds/flesh3.wav"): BloodSounds(4) = _SndOpen("assets/Vantiro-1.1v07b/sounds/flesh5.wav"): BloodSounds(5) = _SndOpen("assets/Vantiro-1.1v07b/sounds/flesh6.wav"): BloodSounds(6) = _SndOpen("assets/Vantiro-1.1v07b/sounds/flesh7.wav")
Dim Shared GlassShadder(3)
GlassShadder(1) = _SndOpen("assets/Vantiro-1.1v07b/sounds/bustglass1.wav"): GlassShadder(2) = _SndOpen("assets/Vantiro-1.1v07b/sounds/bustglass2.wav"): GlassShadder(3) = _SndOpen("assets/Vantiro-1.1v07b/sounds/bustglass3.wav")
Dim GlassSound(4)
GlassSound(1) = _SndOpen("assets/Vantiro-1.1v07b/sounds/glass1.wav"): GlassSound(2) = _SndOpen("assets/Vantiro-1.1v07b/sounds/glass2.wav"): GlassSound(3) = _SndOpen("assets/Vantiro-1.1v07b/sounds/glass3.wav"): GlassSound(4) = _SndOpen("assets/Vantiro-1.1v07b/sounds/glass4.wav")

HudImageHealth = _NewImage(128, 128, 32)
Hud_Health_Icon = LoadImage("assets/Vantiro-1.1v07b/BloodIcon.png", 32)
Hud_Health_Fluid = LoadImage("assets/Vantiro-1.1v07b/BloodHealth.png", 32)

SND_Explosion = _SndOpen("assets/Vantiro-1.1v07b/sounds/explode.mp3")
Particle_Shotgun_Shell = LoadImage("assets/Vantiro-1.1v07b/items/shotgunshell.png", 33)
Particle_Pistol_Shell = LoadImage("assets/Vantiro-1.1v07b/items/pistolshell.png", 33)
Particle_Smoke = LoadImage("assets/Vantiro-1.1v07b/items/smoke.png", 33)
Particle_Explosion = LoadImage("assets/Vantiro-1.1v07b/items/explosion.png", 33)
Dim Shared CameraX As Double, CameraY As Double
Dim Shared CameraXM As Double, CameraYM As Double

Type Particle
    x As Double
    y As Double
    z As Double
    txt As Integer
    xm As Double
    ym As Double
    zm As Double
    froozen As Integer
    rotation As Double
    rotationspeed As Double
    visible As Integer
    partid As String
    playwhatsound As String
    BloodColor As String
    special As Integer
    distancefromplayer As Integer
End Type
Dim Shared GrenadeMax, FireMax

FireMax = Config.FireMax
GrenadeMax = 16
Dim Shared BloodPart(32) As Particle
Dim Shared ParticlesMax, BloodMax, LastBlood
ParticlesMax = Config.ParticlesMax
Dim Shared Grenade(GrenadeMax) As Particle
Dim Shared Fire(FireMax) As Particle
Dim Shared Part(ParticlesMax) As Particle

Dim Shared PlayerHealth, PlayerInteract, ShootDelay, GunForce

Dim Shared FlameAmmoMax, SMGAmmoMax, ShotgunAmmoMax, GrenadeAmmoMax
FlameAmmoMax = 300: SMGAmmoMax = 550: ShotgunAmmoMax = 80: GrenadeAmmoMax = 10


GoSub RestartEverything
PlayerSkin2 = PlayerSkin
ZombieAIchoose = Config.Zombie_OldAI
Dim Shared vib, gr, da
Dim flimit: flimit = 62
Sandbox = 1
Timer On
Type Graph
    x As Double
    xb As Long
    yb As Long
    y As Double
    x1 As Long
    x2 As Long
    y1 As Long
    y2 As Long
    xsize As Long
    ysize As Long
    value As Double
    average As Double
    buildup As Double
    amountbuildup As Long
    myname As String
    image As Long
End Type
Dim Shared GraphValues(8, 257) As Double
Dim Shared Graph(8) As Graph
Type Waypoint
    exist As _Byte
    playerdist As Integer
    realdist As _Unsigned Long
    connections As Integer
    x As Double
    y As Double
    free As _Byte
End Type
Type LightSource
    exist As _Byte
    x As Double
    y As Double
    detail As String
    lighttype As String
    angle As Double
    fol As Double
    strength As Double 'Amount of light.
    strength2 As Double 'rendered light
    randomflick As Integer 'flickering, makes it not static, 0 = static
    duration As Long 'Duration in frames.
End Type
Dim Shared LastDynLight: LastDynLight = 0
Dim Shared StaticLightMax: StaticLightMax = 1
Dim Shared DynamicLightMax: DynamicLightMax = 80
Dim Shared StaticLight(StaticLightMax) As LightSource
Dim Shared DynamicLight(DynamicLightMax) As LightSource

Dim Shared WaypointMax
WaypointMax = 120

Dim Shared Waypoint(WaypointMax) As Waypoint
Dim Shared WaypointJoints(WaypointMax, 16)
'Setting up graphs
For g = 1 To 7
    Graph(g).x1 = 40: Graph(g).x2 = 296: Graph(g).y1 = (g * 50) - 50: Graph(g).y2 = (g * 50)
    Graph(g).xsize = Int(Graph(g).x2 - Graph(g).x1): Graph(g).ysize = Int(Graph(g).y2 - Graph(g).y1)
    Graph(g).x = Int((Graph(g).x1 + Graph(g).x2) / 2): Graph(g).y = Int((Graph(g).y1 + Graph(g).y2) / 2)
    Graph(g).xb = Graph(g).x: Graph(g).yb = Graph(g).y: Graph(g).value = 0
Next
Graph(1).myname = "Map Rend. - ": Graph(2).myname = "Zombie AI - ": Graph(3).myname = "Zombie Rend. - ": Graph(4).myname = "Fire Logic - ": Graph(5).myname = "Particle Logic - ": Graph(6).myname = "Graph Rend. - ": Graph(7).myname = "Light Rend. - ":
Dim ProceedCheck As Double: Dim MapFPS As Double: Dim ZombieAIFPS As Double: Dim ZombieRenderFPS As Double: Dim FireFPS As Double: Dim GraphFPS As Double
For i = 1 To 7
    Graph(i).image = CreateImageText(Graph(i).image, Graph(i).myname, 30)
Next
GraphFPS = 0.1: GraphEnabled = 0

'Create numbers to display waypoints, can be used for other stuff too.
For i = 1 To WaypointMax
    Waypoint(i).connections = 0
    For i2 = 1 To 16
        WaypointJoints(i, i2) = -1
    Next
Next
lastwaypoint = 0
Dim Shared numberimage(3000)
For i = 0 To 3000
    numberimage(i) = CreateImageText(numberimage(i), Str$(i), 40)
Next
'Create shadow gradiant.
Shadowgradientold = _NewImage(256, 4, 32): _Dest Shadowgradientold: x = 0
For i = 255 To 0 Step -1
    Line (x, 0)-(x, 4), _RGBA32(0, 0, 0, i): x = x + 1
Next
Shadowgradient = _CopyImage(Shadowgradientold, 33): _FreeImage Shadowgradientold

'Create Weapons









DynamicLight(1).exist = -1
DynamicLight(1).strength = 100
DynamicLight(1).duration = -1
DynamicLight(1).detail = "High"
_Dest MainScreen
LoadingText = CreateImageText(LoadingText, "Loading...", 60)
If Config.Map_Lighting = 1 Then GoSub BakeLights
_ScreenMove _Middle


Do
    'w st = XInputGetState(0, _Offset(gamepadstate))
    LastHealth = Player.Health
    If FlameAmmo > FlameAmmoMax Then FlameAmmo = FlameAmmoMax
    If SMGAmmo > SMGAmmoMax Then SMGAmmo = SMGAmmoMax
    If ShotgunAmmo > ShotgunAmmoMax Then ShotgunAmmo = ShotgunAmmoMax
    If GrenadeAmmo > GrenadeAmmoMax Then GrenadeAmmo = GrenadeAmmoMax
    Mouse.scroll = 0
    _KeyClear
    Do While _MouseInput
        Mouse.x = _MouseX: Mouse.y = _MouseY
        Mouse.click = _MouseButton(1): Mouse.click2 = _MouseButton(2): Mouse.click3 = _MouseButton(3)
        UsedMouse = 1
        If _MouseWheel <> 0 Then Mouse.scroll = _MouseWheel
    Loop
    If _KeyDown(113) Then Mouse.click = -1
    If _KeyDown(45) Then Mouse.scroll = -1
    If _KeyDown(61) Then Mouse.scroll = 1
    If (gamepadstate.Gamepad.wButtons And A_BUTTON) Then UsingE = -1
    If _KeyDown(101) Then UsingE = -1
    PlayerInteract = 0
    If PlayerInteract = 0 And UsingE And PlayerInteractPre = 0 Then PlayerInteract = 1
    PlayerInteractPre = UsingE
    UsingE = 0

    If _KeyDown(15104) And delay = 0 And Debug = 1 Then HideUI = HideUI + 1: delay = 20: If HideUI = 2 Then HideUI = 0
    If _KeyDown(17408) And delay = 0 And Debug = 1 Then NoAI = NoAI + 1: delay = 20: If NoAI = 2 Then NoAI = 0
    If _KeyDown(118) And delay = 0 And Debug = 1 Then Noclip = Noclip + 1: delay = 20: If Noclip = 2 Then Noclip = 0
    If _KeyDown(106) And delay = 0 And Debug = 1 Then
        delay = 30
        For i = 1 To ZombieMax
            Zombie(i).health = -1
        Next
    End If
    If Player.Health > Config.Player_MaxHealth Then Player.Health = Player.Health - 0.05
    If Player.Health < -1 Then Player.Health = -1

    _Limit flimit
    Cls
    _SetAlpha 0, _RGB32(0, 0, 0), MainScreen
    ff% = ff% + 1
    If Timer - start! >= 1 Then fps% = ff%: ff% = 0: start! = Timer
    If delay > 0 Then delay = delay - 1
    If ShootDelay > 0 Then ShootDelay = ShootDelay - 1

    If _KeyDown(114) And Debug = 1 Then Player.Health = 100: PlayerCantMove = 0: DeathTimer = 0

    ProceedCheck = Timer(.001)
    GoSub ParticleLogic
    ParticleFPS = Timer(.001) - ProceedCheck

    HandsCode
    If PlayerCantMove = 0 Then PlayerMovement
    GoSub GrenadeLogic

    ProceedCheck = Timer(.001)
    If ZombieAIchoose = 1 And NoAI = 0 Then GoSub OldZombieAI
    ZombieAIFPS = Timer(.001) - ProceedCheck
    ProceedCheck = Timer(.001)
    RenderMobs
    ZombieRenderFPS = Timer(.001) - ProceedCheck

    GoSub RenderPlayer
    Player.shooting = 0
    vib = vib + 1: If vib = Int(flimit * .4) Then
        StopVibrate: vib = 1
    End If
    gr = gr + 1: If gr = flimit Then
        StopVibrate: gr = gr + 1
    End If
    da = da + 1: If da = Int(flimit * .4) Then
        StopVibrate: da = 1
    End If
    GunCode

    ProceedCheck = Timer(.001)
    GoSub Fire
    FireFPS = Timer(.001) - ProceedCheck

    RenderTopLayer
    GoSub TriggerPlayer
    ProceedCheck = Timer(.001)
    If Config.Map_Lighting = 1 Then GoSub Lighting
    LightingFPS = Timer(.001) - ProceedCheck

    If Freecam = 0 Then
        CameraX = (Player.x / Map.TileSize) - (_Width / (Map.TileSize * 2))
        CameraY = (Player.y / Map.TileSize) - (_Height / (Map.TileSize * 2))
        CameraX = CameraX + CameraXM / 100
        CameraY = CameraY + CameraYM / 100
    End If
    CameraXM = CameraXM / 1.1
    CameraYM = CameraYM / 1.1

    If _KeyDown(15616) And delay = 0 Then Debug = Debug + 1: delay = 20: If Debug = 2 Then Debug = 0
    If Debug = 1 And delay = 0 Then
        If _KeyDown(15360) Then ZombieAIchoose = ZombieAIchoose + 1: delay = 20: If ZombieAIchoose = 2 Then ZombieAIchoose = 0
        If _KeyDown(102) Then Freecam = Freecam + 1: delay = 20: If Freecam = 2 Then Freecam = 0
        If _KeyDown(8) Then GraphEnabled = GraphEnabled + 1: delay = 10: If GraphEnabled = 2 Then GraphEnabled = 0
        If _KeyDown(231) Then
            For i = 1 To ZombieMax
                Zombie(i).pointfollow = 3
            Next
        End If
        GoSub WaypointDebug
        Print "way1: "; way1
        Print "way2: "; way2
        Print "wayconnect: "; wayconnect
    End If
    If way1 <> 0 And way2 = 0 Then Line (ETSX(Waypoint(way1).x), ETSY(Waypoint(way1).y))-((CameraX / Map.TileSize) + Mouse.x, (CameraY / Map.TileSize) + Mouse.y), _RGBA32(255, 255, 128, 200)
    If _KeyDown(18176) Then delay = 60: Beep: LoadConfigs

    'Pause related
    PauseKeyold = PauseKey
    PauseKey = _KeyDown(27)
    If PauseKeyold = 0 And PauseKey = -1 Then
        Paused = 1:
        For i = 1 To 7
            Hud2(i).x = -Config.Hud_Size * 3
            Hud2(i).y = _Height / 2
        Next
        GoSub PauseMenu
    End If
    If Freecam = 1 Then
        If _KeyDown(19200) Then CameraX = CameraX - 0.15
        If _KeyDown(19712) Then CameraX = CameraX + 0.15
        If _KeyDown(18432) Then CameraY = CameraY - 0.15
        If _KeyDown(20480) Then CameraY = CameraY + 0.15
    End If
    Player.Health = Player.Health - (Player.DamageToTake * Config.Player_DamageMultiplier): Player.DamageToTake = 0
    If Player.Health <= 0 And DeathTimer = 0 Then DeathTimer = 1
    If DeathTimer > 0 Then GoSub PlayerDeath
    If gamepadstate.Gamepad.wButtons And LEFT_BUMPER And LastLeftBumper = 0 Then Mouse.scroll = -1
    If gamepadstate.Gamepad.wButtons And RIGHT_BUMPER And LastRightBumper = 0 Then Mouse.scroll = 1
    LastLeftBumper = gamepadstate.Gamepad.wButtons And LEFT_BUMPER
    LastRightBumper = gamepadstate.Gamepad.wButtons And RIGHT_BUMPER

    gamepadstate.Gamepad.wButtons = 0
    If Mouse.scroll = -1 And PlayerCantMove = 0 Then HudChange = 1: WantSlot = 0
    If Mouse.scroll = 1 And PlayerCantMove = 0 Then HudChange = -1: WantSlot = 0

    If Debug = 1 Then
        For z = 1 To ZombieMax
            If Zombie(z).active = 1 Then
                Line (ETSX(Waypoint(Zombie(z).pointfollow).x), ETSY(Waypoint(Zombie(z).pointfollow).y))-(ETSX(Zombie(z).x), ETSY(Zombie(z).y)), _RGB32(0, 128, 255)
            End If
        Next

        For i = 1 To WaypointMax
            If Waypoint(i).exist Then
                If Waypoint(i).realdist < 3000 And Waypoint(i).playerdist >= 0 Then _PutImage (ETSX(Waypoint(i).x - Map.TileSize / 2.5), ETSY(Waypoint(i).y - Map.TileSize / 2.5)), numberimage(Waypoint(i).realdist)
                If Waypoint(i).free = -1 Then Line (ETSX(Waypoint(i).x - Map.TileSize / 2.5), ETSY(Waypoint(i).y - Map.TileSize / 2.5))-(ETSX(Waypoint(i).x + Map.TileSize / 2.5), ETSY(Waypoint(i).y + Map.TileSize / 2.5)), _RGBA32(0, 255, 0, 128), BF
                If Waypoint(i).free = 0 Then Line (ETSX(Waypoint(i).x - Map.TileSize / 2.5), ETSY(Waypoint(i).y - Map.TileSize / 2.5))-(ETSX(Waypoint(i).x + Map.TileSize / 2.5), ETSY(Waypoint(i).y + Map.TileSize / 2.5)), _RGBA32(255, 0, 0, 128), BF
                For i2 = 1 To Waypoint(i).connections
                    Line (ETSX(Waypoint(i).x), ETSY(Waypoint(i).y))-(ETSX(Waypoint(WaypointJoints(i, i2)).x), ETSY(Waypoint(WaypointJoints(i, i2)).y)), _RGBA32(255, 255, 128, 200)
                Next
            End If
        Next
    End If
    If WaveWait > 0 Then GoSub WaveChange
    GoSub DrawHud
    _PutImage (HudXCenter - 8, HudYCenter - 8)-(HudXCenter + 8, HudYCenter + 8), PlayerHand(PlayerSkin2)
    'If HideUI = 0 Then GoSub MiniMapCode
    If WaveBudget = 0 Then GoSub WaveChange
    If Wave = Config.Wave_End Then GoSub TurningDay
    If Sandbox = 1 Then GoSub Sandbox
    GoSub HealthHud
    If HideUI = 0 Then _PutImage (_Width - 128, _Height - 128)-(_Width, _Height), HudImageHealth
    If Debug = 1 Then
        XCalc = WTS(Fix(Player.x / Map.TileSize), CameraX)
        YCalc = WTS(Fix(Player.y / Map.TileSize), CameraY)
        Line (XCalc, YCalc)-(XCalc + Map.TileSize, YCalc + Map.TileSize), _RGBA32(255, 255, 255, 150), BF
    End If
    'Graph stuff
    ProceedCheck = Timer(.001)
    If GraphEnabled = 1 Then GoSub GraphRender
    GraphFPS = Timer(.001) - ProceedCheck
    Print "Fps: "; fps%

    If _KeyDown(121) And delay = 0 Then DynamicLight(1).strength = DynamicLight(1).strength + 20: delay = 5
    If _KeyDown(117) And delay = 0 Then DynamicLight(1).strength = DynamicLight(1).strength - 20: delay = 5
    Print "LightStrength"; DynamicLight(1).strength
    _Display

    ProceedCheck = Timer(.001)
    RenderLayers
    MapFPS = Timer(.001) - ProceedCheck

    If _WindowHasFocus Then GoSub ResizeScreen
Loop

BakeLights:
lightsfound = 0
Tiless = Map.MaxWidth * Map.MaxHeight * 2
_PutImage ((_Width / 2) - (_Width(LoadingText) / 2), (_Height / 2) - _Height(LoadingText)), LoadingText
LoadingSize = (_Width - (_Width / 6)) - (_Width / 6)

For z = 1 To 2
    For x = 0 To Map.MaxWidth
        For y = 0 To Map.MaxHeight
            TilesDone = TilesDone + 1
            Frames = Frames + 1
            If Frames = 100 Then LoadingProgress = CalculatePercentage(Tiless, TilesDone): Frames = 0: GoSub LoadingBar
            Select Case Tile(x, y, z).ID
                Case 5
                    StaticLight(1).x = x * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = y * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 250
                    CalcLightingStatic StaticLight(1)
                Case 6
                    StaticLight(1).x = x * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = y * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 200
                    CalcLightingStatic StaticLight(1)

                Case 34
                    StaticLight(1).x = x * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = y * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CalcLightingStatic StaticLight(1)

                Case 35
                    StaticLight(1).x = x * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = y * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CalcLightingStatic StaticLight(1)

                Case 36
                    StaticLight(1).x = x * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = y * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CalcLightingStatic StaticLight(1)

                Case 37
                    StaticLight(1).x = x * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = y * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CalcLightingStatic StaticLight(1)
                Case 38
                    StaticLight(1).x = x * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = y * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CalcLightingStatic StaticLight(1)




            End Select
        Next
    Next
Next
_FreeImage LoadingText
Return

LoadingBar:

Line (_Width / 6, (_Height / 2) + _Height(LoadingText))-((_Width / 6) + LoadingSize, (_Height / 2) + _Height(LoadingText) + 80), _RGB32(64, 64, 64), BF
Line (_Width / 6, (_Height / 2) + _Height(LoadingText))-((_Width / 6) + ((LoadingSize / 100) * LoadingProgress), (_Height / 2) + _Height(LoadingText) + 80), _RGB32(255, 255, 255), BF

_Display
Return


WaypointDebug:
If _KeyDown(16384) And delay = 0 Then ' " ' " key, saves waypoints.
    delay = 30
    Open ("assets/Vantiro-1.1v07b/maps/" + Map$ + ".waypoints") For Output As #3
    Write #3, lastwaypoint
    For i = 1 To WaypointMax

        Write #3, i, Waypoint(i).x, Waypoint(i).y, Waypoint(i).exist, Waypoint(i).connections, WaypointJoints(i, 1), WaypointJoints(i, 2), WaypointJoints(i, 3), WaypointJoints(i, 4), WaypointJoints(i, 5), WaypointJoints(i, 6), WaypointJoints(i, 7), WaypointJoints(i, 8), WaypointJoints(i, 9), WaypointJoints(i, 10), WaypointJoints(i, 11), WaypointJoints(i, 12), WaypointJoints(i, 13), WaypointJoints(i, 14), WaypointJoints(i, 15), WaypointJoints(i, 16)
    Next
    Close #3
End If

If _KeyDown(16640) And delay = 0 Then ' " ' " key, saves waypoints.
    delay = 30
    Open ("assets/Vantiro-1.1v07b/maps/" + Map$ + ".waypoints") For Input As #3
    Input #3, lastwaypoint
    For i = 1 To WaypointMax

        Input #3, i, Waypoint(i).x, Waypoint(i).y, Waypoint(i).exist, Waypoint(i).connections, WaypointJoints(i, 1), WaypointJoints(i, 2), WaypointJoints(i, 3), WaypointJoints(i, 4), WaypointJoints(i, 5), WaypointJoints(i, 6), WaypointJoints(i, 7), WaypointJoints(i, 8), WaypointJoints(i, 9), WaypointJoints(i, 10), WaypointJoints(i, 11), WaypointJoints(i, 12), WaypointJoints(i, 13), WaypointJoints(i, 14), WaypointJoints(i, 15), WaypointJoints(i, 16)
    Next
    Close #3
End If
If _KeyDown(61) And delay = 0 And lastwaypoint < WaypointMax Then
    delay = 20
    lastwaypoint = lastwaypoint + 1
    Waypoint(lastwaypoint).x = ((Fix(Player.x / Map.TileSize)) * Map.TileSize) + Map.TileSize / 2
    Waypoint(lastwaypoint).y = ((Fix(Player.y / Map.TileSize)) * Map.TileSize) + Map.TileSize / 2
    Waypoint(lastwaypoint).exist = -1

End If
If _KeyDown(42) And delay = 0 Then delay = 10: WaypointsPlayerDist

If _KeyDown(20992) And delay = 0 Then 'INSERT KEY.
    delay = 10
    For i = 1 To WaypointMax
        If Distance((CameraX * Map.TileSize) + Mouse.x, (CameraY * Map.TileSize) + Mouse.y, Waypoint(i).x, Waypoint(i).y) < Map.TileSize / 1.5 Then
            If way1 <> 0 Then way2 = i
            If way1 = 0 Then way1 = i
            If way1 <> 0 And way2 <> 0 Then
                For o = 1 To 16
                    If WaypointJoints(way1, o) = -1 Then WaypointJoints(way1, o) = way2: Exit For
                Next
                For o = 1 To 16
                    If WaypointJoints(way2, o) = -1 Then WaypointJoints(way2, o) = way1: Exit For
                Next

                Waypoint(way1).connections = Waypoint(way1).connections + 1
                Waypoint(way2).connections = Waypoint(way2).connections + 1
                way1 = 0
                way2 = 0
            End If
            Exit For
        End If
    Next
End If
Return

Lighting:
For i = 1 To DynamicLightMax
    If DynamicLight(i).exist Then
        LogicLightingDyn DynamicLight(i)
        If IHaveGoodPC = 0 Then
            CalcLightingDynLow DynamicLight(i)
        Else
            If DynamicLight(i).detail = "High" Then CalcLightingDynHigh DynamicLight(i)
            If DynamicLight(i).detail = "Low" Then CalcLightingDynLow DynamicLight(i)
        End If

        'Line (ETSX(DynamicLight(i).x - 5), ETSY(DynamicLight(i).y - 5))-(ETSX(DynamicLight(i).x + 5), ETSY(DynamicLight(i).y + 5)), _RGB32(128, 255, 255), BF
    End If
Next
'render
For x = rendcamerax1 To rendcamerax2 'Map.MaxWidth
    For y = rendcameray1 To rendcameray2 'Map.MaxHeight

        XCalc = WTS(x, CameraX)
        YCalc = WTS(y, CameraY)
        XCalc2 = XCalc + Map.TileSize
        YCalc2 = YCalc + Map.TileSize


        light = Tile(x, y, 0).dlight + (Tile(x, y, 0).alight - Int(Rnd * 5))
        Tile(x, y, 0).dlight = 0

        _PutImage (XCalc, YCalc)-(XCalc2, YCalc2), Shadowgradient, 0, (light / (Tile(x, y, 0).toplayer / 2), 0)-(light / (Tile(x, y, 0).toplayer / 2), 1)
    Next
Next


Return


NewZombieAI:
For i = 1 To ZombieMax
    If Zombie(i).active = 1 Then
        Select Case Zombie(i).AIstate
            Case "Chase"

            Case "CasePoint"
                ZombieAIChasePoint Zombie(i)
            Case "Idle"

            Case "Roaming"

            Case "Retreat"

        End Select
    End If
Next

Return

GraphRender:

If Mouse.click3 = 0 Then SelectedGraph = 0
If SelectedGraph = 0 Then
    For H = 7 To 1 Step -1
        If GraphCollide(Mouse, Graph(H)) And Mouse.click3 Then
            SelectedGraph = H
            Exit For
        End If
    Next
End If
If SelectedGraph <> 0 Then
    Graph(SelectedGraph).xb = Int(Mouse.x)
    Graph(SelectedGraph).yb = Int(Mouse.y)
    a = SelectedGraph

End If

Line (Mouse.x - 5, Mouse.y - 5)-(Mouse.x + 5, Mouse.y + 5), _RGB32(255, 0, 0), BF

Graph(1).value = MapFPS
Graph(2).value = ZombieAIFPS
Graph(3).value = ZombieRenderFPS
Graph(4).value = FireFPS
Graph(5).value = ParticleFPS
Graph(6).value = GraphFPS
Graph(7).value = LightingFPS
For a = 1 To 7
    For B = 1 To 7
        If a <> B Then
            If GraphsCollide(Graph(a), Graph(B)) Then
                If Graph(a).x1 + (Graph(a).xsize / 4.9) > Graph(B).x2 Then Graph(a).xb = Graph(B).xb + (Graph(a).xsize / 2 + Graph(B).xsize / 2) + 5
                If Graph(a).x2 - (Graph(a).xsize / 4.9) < Graph(B).x1 Then Graph(a).xb = Graph(B).xb - (Graph(a).xsize / 2 + Graph(B).xsize / 2) - 5
                If Graph(a).y1 + (Graph(a).ysize / 2.9) > Graph(B).y2 Then Graph(a).yb = Graph(B).yb + (Graph(a).ysize / 2 + Graph(B).ysize / 2) + 5
                If Graph(a).y2 - (Graph(a).ysize / 2.9) < Graph(B).y1 Then Graph(a).yb = Graph(B).yb - (Graph(a).ysize / 2 + Graph(B).ysize / 2) - 5


                If Graph(a).x + (Graph(a).xsize / 2.6) > Graph(B).x Then
                    If Graph(a).x - (Graph(a).xsize / 2.6) < Graph(B).x Then
                        If Graph(a).y + (Graph(a).ysize / 2.6) > Graph(B).y Then
                            If Graph(a).y - (Graph(a).ysize / 2.6) < Graph(B).y Then
                                Graph(a).xb = Graph(a).xb + Int(Rnd * 20) - 10
                                Graph(a).yb = Graph(a).yb + Int(Rnd * 20) - 10
                            End If
                        End If
                    End If
                End If
            End If
        End If
    Next

    Graph(a).x = Graph(a).x + ((Graph(a).xb - Graph(a).x) / 5)
    Graph(a).y = Graph(a).y + ((Graph(a).yb - Graph(a).y) / 5)
    Graph(a).x1 = Int(Graph(a).x - (Graph(a).xsize / 2)): Graph(a).x2 = Int(Graph(a).x + (Graph(a).xsize / 2)): Graph(a).y1 = Int(Graph(a).y - (Graph(a).ysize / 2)): Graph(a).y2 = Int(Graph(a).y + (Graph(a).ysize / 2))
    If Graph(a).x1 < 0 Then Graph(a).xb = Int(Graph(a).xsize / 2) + 8
    If Graph(a).y1 < 0 Then Graph(a).yb = Int(Graph(a).ysize / 2) + 8
    If Graph(a).x2 > _Width Then Graph(a).xb = _Width - Fix(Graph(a).xsize / 2) - 8
    If Graph(a).y2 > _Height Then Graph(a).yb = _Height - Fix(Graph(a).ysize / 2) - 8

    For B = 1 To 256
        GraphValues(a, B - 1) = GraphValues(a, B)
    Next
    GraphValues(a, 256) = Abs(Graph(a).value)

Next
For a = 1 To 7
    Line (Graph(a).x1, Graph(a).y1 + 1)-(Graph(a).x2, Graph(a).y2), _RGB32(75, 75, 75), BF

    For B = 1 To 256
        percent = CalculatePercentage(100, GraphValues(a, B) * 1000)
        pc = Fix(percent * 25.5)
        pc2 = Abs(pc - 255)
        Line (Graph(a).x1 + B, Graph(a).y2 - (percent * (Graph(a).ysize / 50)))-(Graph(a).x1 + B, Graph(a).y2), _RGB32(pc, pc2, 64), BF
    Next
    _PutImage (Graph(a).x1, Graph(a).y1), Graph(a).image
Next
Return

PauseMenu:
ResumeImageText = CreateImageText(ResumeImageText, "Resume", Config.Hud_Size)
MainMenuImageText = CreateImageText(MainMenuImageText, "Main Menu", Config.Hud_Size)
OptionsImageText = CreateImageText(OptionsImageText, "Options", Config.Hud_Size)
ScoreImageText = CreateImageText(ScoreImageText, "Score", Config.Hud_Size)
QuitImageText = CreateImageText(QuitImageText, "Quit", Config.Hud_Size)

Do
    Cls
    _Limit 60
    Mouse.scroll = 0
    Do While _MouseInput
        Mouse.x = _MouseX
        Mouse.y = _MouseY
        Mouse.click = _MouseButton(1)
        Mouse.click2 = _MouseButton(2)
        Mouse.click3 = _MouseButton(3)
        UsedMouse = 1
        If _MouseWheel <> 0 Then Mouse.scroll = _MouseWheel
    Loop
    RenderLayers
    RenderMobs
    GoSub RenderPlayer
    For i = 1 To ParticlesMax
        GoSub RenderParticle
    Next
    RenderDisplayGun
    RenderTopLayer

    Line (0, 0)-(_Width, _Height), _RGBA32(ShadeRed, 0, 0, DayAmount), BF
    For i = 1 To HudWeaponMax
        GoSub Hud1Rendering
    Next
    If HideUI = 0 Then GoSub MiniMapCode
    If HideUI = 0 Then _PutImage (_Width - 128, _Height - 128)-(_Width, _Height), HudImageHealth


    PauseKeyold = PauseKey
    PauseKey = _KeyDown(27)
    If PauseKeyold = 0 And PauseKey = -1 Then Paused = 0
    If Mouse.scroll <> 0 And delay = 0 Then
        SelectedHud3ID = SelectedHud3ID + Mouse.scroll
        delay = 3
    End If
    If delay > 0 Then delay = delay - 1
    For i = 1 To 5
        HudLogic Hud2(i), 0, i, SelectedHud3ID, LastSelectedHud3ID, "Left"
        Hud2(i).y1 = Hud2(i).y1 - (HudDown / 1.6): Hud2(i).y2 = Hud2(i).y2 - (HudDown / 1.6)

        If i = SelectedHud3ID Then
            Line (Hud2(i).x1, Hud2(i).y1)-(Hud2(i).x2, Hud2(i).y2), Config.Hud_SelectedColor, BF

            _MapTriangle (0, 0)-(16, 32)-(32, 0), HudSelected To(Hud2(i).x1, Hud2(i).y1)-(0, (_Height / 2))-(Hud2(i).x1, Hud2(i).y2)
        End If
        If i <> SelectedHud3ID Then
            Line (Hud2(i).x1, Hud2(i).y1)-(Hud2(i).x2, Hud2(i).y2), Config.Hud_UnSelectedColor, BF
            If Hud2(i).y2 > 0 Then _MapTriangle (0, 0)-(16, 32)-(32, 0), HudNotSelected To(Hud2(i).x1, Hud2(i).y1)-(0, (_Height / 2))-(Hud2(i).x1, Hud2(i).y2)
        End If

        Select Case i
            Case 1
                _PutImage (Hud2(i).x2, ((Hud2(i).y1 + Hud2(i).y2) / 2) - _Height(ResumeImageText) / 2), ResumeImageText
            Case 2
                _PutImage (Hud2(i).x2, ((Hud2(i).y1 + Hud2(i).y2) / 2) - _Height(MainMenuImageText) / 2), MainMenuImageText
            Case 3
                _PutImage (Hud2(i).x2, ((Hud2(i).y1 + Hud2(i).y2) / 2) - _Height(ScoreImageText) / 2), ScoreImageText
            Case 4
                _PutImage (Hud2(i).x2, ((Hud2(i).y1 + Hud2(i).y2) / 2) - _Height(OptionsImageText) / 2), OptionsImageText
            Case 5
                _PutImage (Hud2(i).x2, ((Hud2(i).y1 + Hud2(i).y2) / 2) - _Height(QuitImageText) / 2), QuitImageText
        End Select
        distcolor = Abs(i - SelectedHud3ID) * 20: If distcolor > 255 Then distcolor = 255
        If i <> SelectedHud3ID Then Line (Hud2(i).x1, Hud2(i).y1)-(Hud2(i).x2, Hud2(i).y2), _RGBA32(0, 0, 0, Abs(distcolor - 255)), BF

    Next
    _PutImage (0, 0), ResumeImageText

    _Display
Loop While Paused = 1
For i = 1 To 7
    Hud2(i).y = _Height + Config.Hud_Size * 3
    Hud2(i).x = _Width / 2
Next

Return


Sandbox:
If SelectedHudID = 6 Then
    Mouse3Old = Mouse3New
    Mouse3New = Mouse.click3
    If Mouse3New = -1 And Mouse3Old = 0 Then BlockMenuToggle = BlockMenuToggle + 1: If BlockMenuToggle = 2 Then BlockMenuToggle = 0: NoSwitchHud = 0
    If BlockMenuToggle = 1 Then
        If HudDown < (Config.Hud_Size * 1.8) Then HudDown = HudDown + Abs((HudDown - (Config.Hud_Size * 1.8)) / 10)
        LastSelectedHud2ID = SelectedHud2ID
        NoSwitchHud = 1
        If Mouse.scroll <> 0 And delay = 0 Then
            SelectedHud2ID = SelectedHud2ID + Mouse.scroll
            delay = 3
        End If
        If SelectedHud2ID < 1 Then SelectedHud2ID = 1
        If SelectedHud2ID > 7 Then SelectedHud2ID = 7
        If Player.shooting = 0 And SpawningStreak > 1 And ShootDelay = 0 Then SpawningStreak = 0
        If Player.shooting = 1 And ShootDelay = 0 Then
            SpawningStreak = SpawningStreak + 2
            ShootDelay = Abs(Int(20 / ((SpawningStreak / 10) + 0.1)))

            For z = 1 To ZombieMax
                If Zombie(z).active = 0 Then
                    Zombie(z).active = 1
                    Zombie(z).x = (CameraX * Map.TileSize) + Mouse.x
                    Zombie(z).y = (CameraY * Map.TileSize) + Mouse.y
                    Select Case SelectedHud2ID
                        Case 1 ' Normal
                            Rand = Int(Rnd * 40)
                            If Rand = 25 Then
                                Zombie(z).size = Int(Rnd * (DefZombie.size - 20 + 1)) + 20 ' DefZombie.size
                            Else
                                Zombie(z).size = DefZombie.size
                            End If
                            Zombie(z).active = 1
                            Zombie(z).maxspeed = Int(Rnd * (500 - 300 + 1)) + 300
                            Zombie(z).damage = Int(Rnd * (6 - 2 + 1)) + 2
                            Zombie(z).speeding = Int(Rnd * (20 - 10 + 1)) + 10
                            Zombie(z).knockback = Int(Rnd * (8 - 5 + 1)) + 5
                            Zombie(z).special = "Normal"
                            Zombie(z).health = Int(Rnd * (DefZombie.maxhealth - DefZombie.minhealth + 1)) + DefZombie.minhealth
                            Zombie(z).weight = 0.5
                        Case 3 ' Runner
                            Zombie(z).size = Int(Rnd * (34 - 25 + 1)) + 25
                            Zombie(z).health = Int(Rnd * (Int(DefZombie.maxhealth / 1.5) - Fix(DefZombie.minhealth / 1.5) + 1)) + Fix(DefZombie.minhealth / 2)
                            Zombie(z).maxspeed = Int(Rnd * (1100 - 900 + 1)) + 900
                            Zombie(z).damage = Int(Rnd * (8 - 2 + 1)) + 2
                            Zombie(z).speeding = Int(Rnd * (45 - 30 + 1)) + 30
                            Zombie(z).knockback = Int(Rnd * (10 - 5 + 1)) + 5
                            Zombie(z).special = "Runner"
                            Zombie(z).weight = 1
                        Case 6 ' Brute
                            Zombie(z).size = Int(Rnd * (100 - 70 + 1)) + 70
                            Zombie(z).health = Int(Rnd * ((DefZombie.maxhealth + 300) - DefZombie.minhealth + 1)) + DefZombie.minhealth + (Zombie(i).size * 2)
                            Zombie(z).maxspeed = Int(Rnd * (600 - 500 + 1)) + 500
                            Zombie(z).damage = Int(Rnd * (80 - 40 + 1)) + 40
                            Zombie(z).speeding = Int(Rnd * (20 - 10 + 1)) + 10
                            Zombie(z).knockback = Int(Rnd * (50 - 30 + 1)) + 30
                            Zombie(z).special = "Brute"
                            Zombie(z).weight = 20
                        Case 2 ' Slower
                            Zombie(z).size = Int(Rnd * (34 - 25 + 1)) + 25
                            Zombie(z).health = Int(Rnd * (Int(DefZombie.maxhealth + 20) - Fix(DefZombie.minhealth) + 1)) + Fix(DefZombie.minhealth)
                            Zombie(z).damage = Int(Rnd * (30 - 20 + 1)) + 20
                            Zombie(z).maxspeed = DefZombie.maxspeed
                            Zombie(z).speeding = Int(Rnd * (7 - 4 + 1)) + 4
                            Zombie(z).weight = 2
                            Zombie(z).knockback = Int(Rnd * (10 - 5 + 1)) + 5
                            Zombie(z).special = "Slower"
                        Case 4 ' Bomber
                            Zombie(z).size = Int(Rnd * (34 - 25 + 1)) + 25
                            Zombie(z).health = Int(Rnd * (Int(DefZombie.maxhealth / 2) - Fix(DefZombie.minhealth / 2) + 1)) + Fix(DefZombie.minhealth / 2)
                            Zombie(z).maxspeed = Int(Rnd * (850 - 700 + 1)) + 700
                            Zombie(z).damage = Int(Rnd * (10 - 2 + 1)) + 2
                            Zombie(z).speeding = Int(Rnd * (30 - 20 + 1)) + 20
                            Zombie(z).knockback = Int(Rnd * (10 - 5 + 1)) + 5
                            Zombie(z).special = "Bomber"
                            Zombie(z).weight = 2
                        Case 7 ' Fire
                            Zombie(z).size = Int(Rnd * (37 - 27 + 1)) + 27
                            Zombie(z).health = Int(Rnd * (Int(DefZombie.maxhealth) - Fix(DefZombie.minhealth) + 1)) + Fix(DefZombie.minhealth)
                            Zombie(z).maxspeed = Int(Rnd * (850 - 500 + 1)) + 500
                            Zombie(z).damage = Int(Rnd * (10 - 2 + 1)) + 2
                            Zombie(z).speeding = Int(Rnd * (10 - 5 + 1)) + 5
                            Zombie(z).knockback = Int(Rnd * (10 - 5 + 1)) + 5
                            Zombie(z).special = "Fire"
                            Zombie(z).weight = 1
                        Case 5 ' Biohazard

                            Zombie(z).size = Int(Rnd * (37 - 27 + 1)) + 27
                            Zombie(z).health = Int(Rnd * (Int(DefZombie.maxhealth) - Fix(DefZombie.minhealth) + 1)) + Fix(DefZombie.minhealth)
                            Zombie(z).maxspeed = Int(Rnd * (850 - 500 + 1)) + 500
                            Zombie(z).damage = Int(Rnd * (10 - 2 + 1)) + 2
                            Zombie(z).speeding = Int(Rnd * (10 - 5 + 1)) + 5
                            Zombie(z).knockback = -Int(Rnd * (10 - 5 + 1)) + 5
                            Zombie(z).special = "Biohazard"
                            Zombie(z).weight = 2
                    End Select
                    Exit For
                End If

            Next
        End If


        For i = 1 To 7

            HudLogic Hud2(i), 0, i, SelectedHud2ID, LastSelectedHud2ID, Config.Hud_Side
            distsel = Abs(i - SelectedHud2ID)
            distcolor = 255 - (distsel * Config.Hud_Fade): If distcolor < 1 Then distcolor = 1

            Hud2(i).y1 = Hud2(i).y1 - (HudDown / 1.6): Hud2(i).y2 = Hud2(i).y2 - (HudDown / 1.6)

            If i = SelectedHud2ID Then
                Line (Hud2(i).x1, Hud2(i).y1)-(Hud2(i).x2, Hud2(i).y2), Config.Hud_SelectedColor, BF
                _MapTriangle (0, 0)-(16, 32)-(32, 0), HudSelected To(Hud2(i).x1, Hud2(i).y2)-(Hud(SelectedHudID).x, Hud(SelectedHudID).y1)-(Hud2(i).x2, Hud2(i).y2)
            End If
            If i <> SelectedHud2ID Then
                Line (Hud2(i).x1, Hud2(i).y1)-(Hud2(i).x2, Hud2(i).y2), _RGBA32(Config.Hud_UnSelRed, Config.Hud_UnSelGreen, Config.Hud_UnSelBlue, 32), BF
                If i < SelectedHud2ID And Hud2(i).y2 < _Height Then _MapTriangle (0, 0)-(16, 32)-(32, 0), HudNotSelected To(Hud2(i).x1, Hud2(i).y2)-(Hud(SelectedHudID).x1, (Hud(SelectedHudID).y1 + Hud(SelectedHudID).size / 2))-(Hud2(i).x2, Hud2(i).y2)
                If i > SelectedHud2ID And Hud2(i).y2 < _Height Then _MapTriangle (0, 0)-(16, 32)-(32, 0), HudNotSelected To(Hud2(i).x1, Hud2(i).y2)-(Hud(SelectedHudID).x2, (Hud(SelectedHudID).y1 + Hud(SelectedHudID).size / 2))-(Hud2(i).x2, Hud2(i).y2)
            End If
            ' _SetAlpha 0.5, ZombieSpawner(i)
            If i = 5 Then
                _PutImage (Hud2(i).x1 - (Hud2(i).size * 0.5), (Hud2(i).y1 + (Hud2(i).size * 0.05)))-(Hud2(i).x2 + (Hud2(i).size * 0.5), Hud2(i).y2 - (Hud2(i).size * 0.05)), ZombieSpawner(i)
            Else
                _PutImage (Hud2(i).x1 - (Hud2(i).size * 0.25), (Hud2(i).y1 + (Hud2(i).size * 0.25)))-(Hud2(i).x2 + (Hud2(i).size * 0.25), Hud2(i).y2 - (Hud2(i).size * 0.25)), ZombieSpawner(i)
            End If

        Next
    Else
        HudDown = (HudDown / 1.05)
    End If

End If
Return

DrawHud:
LastSelectedHudID = SelectedHudID
If NoSwitchHud = 0 Then
    If _KeyDown(49) Then SelectedHudID = 1
    If _KeyDown(50) Then SelectedHudID = 2
    If _KeyDown(51) Then SelectedHudID = 3
    If _KeyDown(52) Then SelectedHudID = 4
    If _KeyDown(53) Then SelectedHudID = 5
    If _KeyDown(54) Then SelectedHudID = 6
End If

If Mouse.scroll <> 0 And delay = 0 And NoSwitchHud = 0 Then
    SelectedHudID = SelectedHudID + Mouse.scroll
    delay = 3
End If
If SelectedHudID < 1 Then SelectedHudID = 1
If SelectedHudID > HudWeaponMax Then SelectedHudID = HudWeaponMax
For i = 1 To HudWeaponMax ' 6
    If i <> SelectedHudID Then
        HudLogic Hud(i), HudDown, i, SelectedHudID, LastSelectedHudID, Config.Hud_Side


        'Rendering
        GoSub Hud1Rendering
    End If
Next
i = SelectedHudID
HudLogic Hud(SelectedHudID), HudDown, SelectedHudID, SelectedHudID, LastSelectedHudID, Config.Hud_Side
GoSub Hud1Rendering
Return

Hud1Rendering:
distsel = Abs(i - SelectedHudID)

distcolor = 255 - (distsel * Config.Hud_Fade): If distcolor < 1 Then distcolor = 1
If Config.Hud_Side = "Down" Then HudXCenter = _Width / 2: HudYCenter = _Height
If Config.Hud_Side = "Up" Then HudXCenter = _Width / 2: HudYCenter = 0
If Config.Hud_Side = "Left" Then HudXCenter = 0: HudYCenter = _Height / 2
If Config.Hud_Side = "Right" Then HudXCenter = _Width: HudYCenter = _Height / 2
If i = SelectedHudID Then
    RenderHudArrow Hud(i), HudXCenter, HudYCenter, HudSelected
    Line (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), _RGBA32(Config.Hud_SelRed, Config.Hud_SelGreen, Config.Hud_SelBlue, 64), BF
    'If Hud(i).y2 < _Height And Hud(i).y1 > 0 Then _MapTriangle (0, 0)-(16, 32)-(32, 0), HudSelected To(Hud(i).x1, Hud(i).y2)-(HudXCenter, HudYCenter)-(Hud(i).x2, Hud(i).y2)


End If
If i <> SelectedHudID Then
    '_SetAlpha distcolor, _RGBA32(0, 0, 0, 1) To _RGBA32(255, 255, 255, 255), HudNotSelected
    RenderHudArrow Hud(i), HudXCenter, HudYCenter, HudNotSelected
    Line (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), _RGBA32(Config.Hud_UnSelRed, Config.Hud_UnSelGreen, Config.Hud_UnSelBlue, 32), BF

    'If Hud(i).y2 < _Height And Hud(i).y1 > 0 Then _MapTriangle (0, 0)-(16, 32)-(32, 0), HudNotSelected To(Hud(i).x1, Hud(i).y2)-(HudXCenter, HudYCenter)-(Hud(i).x2, Hud(i).y2)
End If


If i = 1 Then
    '_SetAlpha distcolor, _RGBA32(0, 0, 0, 1) To _RGBA32(255, 255, 255, 255), Guns_Pistol
    _PutImage (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), Guns_Pistol
End If
If i = 2 Then
    ' _SetAlpha distcolor, _RGBA32(0, 0, 0, 1) To _RGBA32(255, 255, 255, 255), Guns_Shotgun
    _PutImage ((Hud(i).x + Hud(i).xm) - (_Width(Guns_Shotgun) / 4), (Hud(i).y + Hud(i).ym) - (_Height(Guns_Shotgun) / 4))-(Hud(i).x + Hud(i).xm + (_Width(Guns_Shotgun) / 4), Hud(i).y + Hud(i).ym + (_Height(Guns_Shotgun) / 4)), Guns_Shotgun
    percent = CalculatePercentage(ShotgunAmmoMax, ShotgunAmmo) / 10
    pc = Fix(percent * 25.5)
    pc2 = Abs(pc - 255)
    Line (Hud(i).x1, Hud(i).y2 - (Hud(i).size / 5))-(Hud(i).x2, Hud(i).y2), _RGBA32(0, 0, 0, distcolor), BF
    Line (Hud(i).x1, Hud(i).y2 - (Hud(i).size / 5))-(Hud(i).x1 + (percent * 6.4), Hud(i).y2), _RGBA32(pc2, pc, 0, distcolor), BF

End If
If i = 3 Then
    ' _SetAlpha distcolor, _RGBA32(0, 0, 0, 1) To _RGBA32(255, 255, 255, 255), Guns_SMG
    _PutImage (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), Guns_SMG
    percent = CalculatePercentage(SMGAmmoMax, SMGAmmo) / 10
    pc = Fix(percent * 25.5)
    pc2 = Abs(pc - 255)
    Line (Hud(i).x1, Hud(i).y2 - (Hud(i).size / 5))-(Hud(i).x2, Hud(i).y2), _RGBA32(0, 0, 0, distcolor), BF
    Line (Hud(i).x1, Hud(i).y2 - (Hud(i).size / 5))-(Hud(i).x1 + (percent * 6.4), Hud(i).y2), _RGBA32(pc2, pc, 0, distcolor), BF

End If
If i = 4 Then
    ' _SetAlpha distcolor, _RGBA32(0, 0, 0, 1) To _RGBA32(255, 255, 255, 255), Guns_Grenade
    _PutImage (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), Guns_Grenade
    percent = CalculatePercentage(GrenadeAmmoMax, GrenadeAmmo) / 10
    pc = Fix(percent * 25.5)
    pc2 = Abs(pc - 255)
    Line (Hud(i).x1, Hud(i).y2 - (Hud(i).size / 5))-(Hud(i).x2, Hud(i).y2), _RGBA32(0, 0, 0, distcolor), BF
    Line (Hud(i).x1, Hud(i).y2 - (Hud(i).size / 5))-(Hud(i).x1 + (percent * 6.4), Hud(i).y2), _RGBA32(pc2, pc, 0, distcolor), BF

End If
If i = 5 Then
    ' _SetAlpha distcolor, _RGBA32(0, 0, 0, 1) To _RGBA32(255, 255, 255, 255), Guns_Flame
    _PutImage (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), Guns_Flame
    percent = CalculatePercentage(FlameAmmoMax, FlameAmmo) / 10
    pc = Fix(percent * 25.5)
    pc2 = Abs(pc - 255)
    Line (Hud(i).x1, Hud(i).y2 - (Hud(i).size / 5))-(Hud(i).x2, Hud(i).y2), _RGBA32(0, 0, 0, distcolor), BF
    Line (Hud(i).x1, Hud(i).y2 - (Hud(i).size / 5))-(Hud(i).x1 + (percent * 6.4), Hud(i).y2), _RGBA32(pc2, pc, 0, distcolor), BF
End If

If i = 6 Then
    ' _SetAlpha distcolor, _RGBA32(0, 0, 0, 1) To _RGBA32(255, 255, 255, 255), Guns_Hammer
    _PutImage (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), Guns_Hammer
End If

If i = 7 Then
    ' _SetAlpha distcolor, _RGBA32(0, 0, 0, 1) To _RGBA32(255, 255, 255, 255), Guns_Hammer
    _PutImage (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), Guns_Chainsaw
End If


'If i <> SelectedHudID Then Line (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), _RGBA32(0, 0, 0, Abs(distcolor)), BF

Return


HealthHud:
ValueDis = Abs(PlayerHealth - Player.Health)
If Player.Health > PlayerHealth Then PlayerHealth = PlayerHealth + (ValueDis / 20)
If Player.Health < PlayerHealth Then PlayerHealth = PlayerHealth - (ValueDis / 20)

If LastHealth > Player.Health Then
    For x = 1 To Fix((LastHealth - Int(Player.Health)) / 4)
        LastBloodPart = LastBloodPart + 1: If LastBloodPart > 32 Then LastBloodPart = 1
        BloodPart(LastBloodPart).x = 64 ' Int(Rnd * _Width(HeartPercent))
        BloodPart(LastBloodPart).y = _Width(HeartPercent)
        BloodPart(LastBloodPart).xm = Int(Rnd * 100) - 50
        BloodPart(LastBloodPart).ym = -(80 + Int(Rnd * 50))
        BloodPart(LastBloodPart).visible = 1
    Next
End If
If LastHealth <> PlayerHealth Then
    FontSizeUse = 60
    If Player.Health < 0 Then Player.Health = 0
    Text$ = LTrim$(Str$(Fix(PlayerHealth)) + "%")
    GoSub HudText
    HeartThx = thx
    HeartThy = thy
    If HeartPercent <> 0 Then _FreeImage HeartPercent
    HeartPercent = _CopyImage(ImgToMenu)
    _SetAlpha 64, _RGBA32(1, 1, 1, 1) To _RGBA32(255, 255, 255, 255), HeartPercent
End If
_Dest HudImageHealth
Line (0, 0)-(_Width, _Height), _RGB32(0, 0, 0), BF
For i = 1 To 32
    If BloodPart(i).visible = 1 Then
        BloodPart(i).x = BloodPart(i).x + BloodPart(i).xm / 10
        BloodPart(i).y = BloodPart(i).y + BloodPart(i).ym / 10
        If BloodPart(i).x > _Width Then BloodPart(i).x = _Width: BloodPart(i).xm = -BloodPart(i).xm
        If BloodPart(i).x < 0 Then BloodPart(i).x = 0: BloodPart(i).xm = -BloodPart(i).xm
        If BloodPart(i).ym > 0 Then RotoZoom BloodPart(i).x, BloodPart(i).y, BloodDrop, 1.5, BloodPart(i).xm / 15
        If BloodPart(i).ym < 0 Then RotoZoom BloodPart(i).x, BloodPart(i).y, BloodDrop, 1.5, 180 + BloodPart(i).xm / 15
        If BloodPart(i).y > _Width(HeartPercent) + 10 Then BloodPart(i).visible = 0
        If BloodPart(i).y < -32 Then BloodPart(i).visible = 0
    End If
Next
RotHeartDisplay = -(Player.xm / 6)
If RotHeartDisplay > 45 Then RotHearDisplay = 45
If RotHeartDisplay < -45 Then RotHearDisplay = -45
RotoZoom _Width / 2 + (Player.xm / 50), ((Abs(PlayerHealth - 100) * (_Height / 100))), Hud_Health_Fluid, 2.2, RotHeartDisplay
'_PutImage ((_Width / 2) + (_Width(HeartPercent) / 2), (_Height / 2) + (_Height(HeartPercent) / 2)), HeartPercent
_PutImage ((_Width / 2) - HeartThx / 2, (_Height / 2) - HeartThy / 2), HeartPercent
If PlayerIsOnFire > 0 Then firechoosen = (Int(Rnd * 3) + 1): _PutImage (0, 0)-(_Width, _Height), FireParticles(firechoosen)

_PutImage (0, 0)-(_Width, _Height), Hud_Health_Icon

_Dest MainScreen
_ClearColor _RGB32(0, 255, 0), HudImageHealth
If Player.Health < 60 And ShadeRed > Abs(60 - Player.Health) Then ShadeRed = ShadeRed - 1
If Player.Health < 60 And ShadeRed < Abs(60 - Player.Health) Then ShadeRed = ShadeRed + 1
If Player.Health > 60 And ShadeRed > 0 Then ShadeRed = ShadeRed - 1
Return

RestartEverything:
SizeDelayMinimap = 6
Hud(1).rotation = 200
Wave = 0
WaveWait = -5
WaveBudget = 0
FlameAmmo = 300
SMGAmmo = 150
ShotgunAmmo = 80
GrenadeAmmo = 10
'Generate Minimap Texture
'GoSub GenerateMiniMap
PlayerOnFire = 0
RayM(1).x = (_Width / 2) - (_Height / 2)
RayM(1).y = 0
RayM(2).x = (_Width / 2) + (_Height / 2)
RayM(2).y = _Height
MiniMapGoBack = 20
DayAmount = 128
Player.x = 2064 * 2
Player.y = 2064 * 2
Player.size = 25
GunDisplay.visible = 1
GunDisplay.wtype = 2
Mouse.click = 0
For i = 1 To GrenadeMax
    Grenade(i).x = 64
    Grenade(i).y = 64
    Grenade(i).z = 1
    Grenade(i).xm = 64
    Grenade(i).ym = 64
    Grenade(i).froozen = 0
    Grenade(i).rotation = 0
    Grenade(i).rotationspeed = 0
    Grenade(i).visible = 0
Next
For i = 1 To ZombieMax
    Zombie(i).active = 0
    Zombie(i).onfire = 0
Next

For i = 1 To FireMax
    Fire(i).visible = 0
    Fire(i).txt = 0
    Fire(i).xm = 0
    Fire(i).ym = 0
    Fire(i).froozen = 0
Next
RenderLayer1 = 1
RenderLayer2 = 1
RenderLayer3 = 1
delay = 10

For i = 1 To ParticlesMax
    Part(i).froozen = 0
    Part(i).visible = 0
Next
PlayerCantMove = 0
DeathTimer = 0
PlayerIsOnFire = 0
Player.Health = 105
PlayerHealth = 105
Player.DamageToTake = 0
Return

TurningDay:
If Player.Health <= 0 Then Wave = 1
If DelayUntilStart > 0 Then DelayUntilStart = DelayUntilStart - 1
If DelayUntilStart = 0 And DayAmount > 0 Then DayAmount = DayAmount / 1.005
If DayAmount < 50 And Tile(Fix(Player.x / Map.TileSize), Fix(Player.y / Map.TileSize), 1).ID = 66 Then PlayerIsOnFire = 20

If DayAmount < 1 Then DayAmount = 0
If DayAmount = 0 And Player.Health > 0 Then
    If Showtext = 1 Then WaveDisplayY = -thy * 2
    Showtext = 2
    Darkening = Darkening + 0.5
    If Darkening > 400 Then System
    Line (0, 0)-(_Width, _Height), _RGBA32(0, 0, 0, Darkening), BF

    Text$ = "Rest well."
    FontSizeUse = 70
    GoSub HudText

    dist = (Abs(WaveDisplayY - _Width / 2) / 50): WaveDisplayY = WaveDisplayY + 1 / (dist / 15)
    WaveDisplayTHX = thx: WaveDisplayTHY = thy
    _PutImage (_Width / 2 - WaveDisplayTHX / 2, WaveDisplayY - WaveDisplayTHY / 2), ImgToMenu

    Text$ = ("They will come back tomorrow...")
    FontSizeUse = 40
    GoSub HudText

    WaveDisplayTHX = thx
    _PutImage (_Width / 2 - WaveDisplayTHX / 2, WaveDisplayY + WaveDisplayTHY / 2), ImgToMenu

End If
If Showtext = 1 Then
    Text$ = "Go inside."
    FontSizeUse = 70
    GoSub HudText

    dist = (Abs(WaveDisplayY - _Width / 2) / 50): WaveDisplayY = WaveDisplayY + 1 / (dist / 15)
    WaveDisplayTHX = thx: WaveDisplayTHY = thy
    _PutImage (_Width / 2 - WaveDisplayTHX / 2, WaveDisplayY - WaveDisplayTHY / 2), ImgToMenu

    Text$ = ("The sun is coming.")
    FontSizeUse = 40
    GoSub HudText

    WaveDisplayTHX = thx
    _PutImage (_Width / 2 - WaveDisplayTHX / 2, WaveDisplayY + WaveDisplayTHY / 2), ImgToMenu
End If

Return

MiniMapCode:
RenderZombiesMinimap = 1
UpdateMiniMap = UpdateMiniMap - 1
Divider = MinimapTxtSize / Sqr(MinimapTxtSize)
If UpdateMiniMap < 0 Then GoSub GenerateMiniMap
If MiniMapGoBack > 0 Then MiniMapGoBack = MiniMapGoBack - 1
CheckMiniMapKey = 0
If CheckMiniMapKey = 0 And _KeyDown(9) = -1 And CheckMiniMapKeyPre = 0 Then CheckMiniMapKey = 1
CheckMiniMapKeyPre = _KeyDown(9)
If CheckMiniMapKey = 1 Then ToggleMinimapBig = ToggleMinimapBig + 1: If ToggleMinimapBig = 2 Then ToggleMinimapBig = 0
If MiniMapGoBack = 1 Then ToggleMinimapBig = 0: CheckMiniMapKey = 1
If ToggleMinimapBig = 1 And CheckMiniMapKey = 1 Then
    RayM(1).x = Minimap.x1: RayM(1).y = Minimap.y1
    RayM(1).damage = (_Width / 2) - (_Height / 2)
    RayM(1).knockback = 0: RayM(1).owner = 1
    RayM(2).x = Minimap.x2: RayM(2).y = Minimap.y2
    RayM(2).damage = (_Width / 2) + (_Height / 2)
    RayM(2).knockback = _Height
    RayM(2).owner = 1
    MiniMapGoBack = 360
End If
If ToggleMinimapBig = 0 And CheckMiniMapKey = 1 Then
    RayM(1).x = Minimap.x1: RayM(1).y = Minimap.y1
    RayM(1).damage = _Width - 200
    RayM(1).knockback = 0: RayM(1).owner = 1
    RayM(2).x = Minimap.x2: RayM(2).y = Minimap.y2
    RayM(2).damage = _Width
    RayM(2).knockback = 200
    RayM(2).owner = 1
    MiniMapGoBack = 0
End If
For i = 1 To 2
    If RayM(i).owner = 1 Then
        dx = RayM(i).x - RayM(i).damage: dy = RayM(i).y - RayM(i).knockback
        rotation = ATan2(dy, dx) ' Angle in radians
        RayM(i).angle = (rotation * 180 / PI) + 90
        If RayM(i).angle > 180 Then RayM(i).angle = RayM(i).angle - 179.9
        xvector = Sin(RayM(i).angle * PIDIV180): yvector = -Cos(RayM(i).angle * PIDIV180)
        RayM(i).x = RayM(i).x + xvector * (0.1 + (Distance(RayM(i).x, RayM(i).y, RayM(i).damage, RayM(i).knockback) / 5))
        RayM(i).y = RayM(i).y + yvector * (0.1 + (Distance(RayM(i).x, RayM(i).y, RayM(i).damage, RayM(i).knockback) / 5))
        If Int(RayM(i).x) = Int(RayM(i).damage) And Int(RayM(i).y) = Int(RayM(i).knockback) Then RayM(i).owner = 0
    End If
Next
Minimap.x1 = RayM(1).x
Minimap.y1 = RayM(1).y
Minimap.x2 = RayM(2).x
Minimap.y2 = RayM(2).y
If MiniMapGoBack = 0 Then MinimapSize = Int((Minimap.x2 - Minimap.x1) / SizeDelayMinimap): If SizeDelayMinimap < 6 Then SizeDelayMinimap = SizeDelayMinimap + 0.5
If MiniMapGoBack <> 0 Then MinimapSize = Int((Minimap.x2 - Minimap.x1) / SizeDelayMinimap): If SizeDelayMinimap > 2 Then SizeDelayMinimap = SizeDelayMinimap - 1
Offset = Abs((Int(Player.xm) + Int(Player.ym) / 2) / 10) + 100 + MinimapSize
_PutImage (Minimap.x1, Minimap.y1)-(Minimap.x2, Minimap.y2), MinimapIMG, , ((Player.x / Divider) - Offset, (Player.y / Divider) - Offset)-((Player.x / Divider) + Offset, (Player.y / Divider) + Offset)
Line (Minimap.x1, Minimap.y1)-(Minimap.x2, Minimap.y2), _RGBA32(0, 255, 0, UpdateMiniMap / 1.5), BF
Return

GenerateMiniMap:
UpdateMiniMap = 60
'_Dest MinimapIMG
For x = 0 To Map.MaxWidth
    For y = 0 To Map.MaxHeight
        z = 1
        xs = x * MinimapTxtSize
        ys = y * MinimapTxtSize
        If Tile(x, y, z).ID <> 0 Then _PutImage (xs, ys)-(xs + (MinimapTxtSize), ys + (MinimapTxtSize)), Tileset, MinimapIMG, (Tile(x, y, z).rend_spritex * Map.TextureSize, Tile(x, y, z).rend_spritey * Map.TextureSize)-(Tile(x, y, z).rend_spritex * Map.TextureSize + (Map.TextureSize - 1), Tile(x, y, z).rend_spritey * Map.TextureSize + (Map.TextureSize - 1))
        '        Line (xs, ys)-(xs + (MinimapTxtSize), ys + (MinimapTxtSize)), _RGBA32(0, 0, 0, 64), BF
        z = 2
        If Tile(x, y, z).ID <> 0 Then _PutImage (xs, ys)-(xs + (MinimapTxtSize), ys + (MinimapTxtSize)), Tileset, MinimapIMG, (Tile(x, y, z).rend_spritex * Map.TextureSize, Tile(x, y, z).rend_spritey * Map.TextureSize)-(Tile(x, y, z).rend_spritex * Map.TextureSize + (Map.TextureSize - 1), Tile(x, y, z).rend_spritey * Map.TextureSize + (Map.TextureSize - 1))

    Next
Next
If RenderZombiesMinimap = 1 Then
    For i = 1 To ZombieMax
        If Zombie(i).active = 1 Then
            If Zombie(i).special = "Runner" Then RotoZoomHard Zombie(i).x / Divider, Zombie(i).y / Divider, ZombieRunner, (Zombie(i).size / MinimapTxtSize) * (MinimapTxtSize2), Zombie(i).rotation, MinimapIMG ' _RGB32(255, 0, 255), BF
            If Zombie(i).special = "Brute" Then RotoZoomHard Zombie(i).x / Divider, Zombie(i).y / Divider, ZombieBrute, (Zombie(i).size / MinimapTxtSize) * (MinimapTxtSize2), Zombie(i).rotation, MinimapIMG 'Line (Zombie(i).x1 / 8, Zombie(i).y1 / 8)-(Zombie(i).x2 / 8, Zombie(i).y2 / 8), _RGB32(255, 0, 0), BF
            If Zombie(i).special = "Slower" Then RotoZoomHard Zombie(i).x / Divider, Zombie(i).y / Divider, ZombieSlower, (Zombie(i).size / MinimapTxtSize) * (MinimapTxtSize2), Zombie(i).rotation, MinimapIMG 'Line (Zombie(i).x1 / 8, Zombie(i).y1 / 8)-(Zombie(i).x2 / 8, Zombie(i).y2 / 8), _RGB32(64, 0, 64), BF
            If Zombie(i).special = "Bomber" Then RotoZoomHard Zombie(i).x / Divider, Zombie(i).y / Divider, ZombieBomber, (Zombie(i).size / MinimapTxtSize) * (MinimapTxtSize2), Zombie(i).rotation, MinimapIMG 'Line (Zombie(i).x1 / 8, Zombie(i).y1 / 8)-(Zombie(i).x2 / 8, Zombie(i).y2 / 8), _RGB32(128, 128, 128), BF
            If Zombie(i).special = "Fire" Then RotoZoomHard Zombie(i).x / Divider, Zombie(i).y / Divider, ZombieFire, (Zombie(i).size / MinimapTxtSize) * (MinimapTxtSize2), Zombie(i).rotation, MinimapIMG 'Line (Zombie(i).x1 / 8, Zombie(i).y1 / 8)-(Zombie(i).x2 / 8, Zombie(i).y2 / 8), _RGB32(255, 128, 0), BF
            If Zombie(i).special = "Biohazard" Then RotoZoomHard Zombie(i).x / Divider, Zombie(i).y / Divider, ZombieBiohazard, (Zombie(i).size / MinimapTxtSize) * (MinimapTxtSize2), Zombie(i).rotation, MinimapIMG 'Line (Zombie(i).x1 / 8, Zombie(i).y1 / 8)-(Zombie(i).x2 / 8, Zombie(i).y2 / 8), _RGB32(0, 255, 0), BF
            If Zombie(i).special = "Normal" Then RotoZoomHard Zombie(i).x / Divider, Zombie(i).y / Divider, Zombie, (Zombie(i).size / MinimapTxtSize) * (MinimapTxtSize2), Zombie(i).rotation, MinimapIMG 'Line (Zombie(i).x1 / 8, Zombie(i).y1 / 8)-(Zombie(i).x2 / 8, Zombie(i).y2 / 8), _RGB32(28, 125, 46), BF
        End If
    Next
End If
'Line (Player.x1 / MinimapTxtSize, Player.y1 / MinimapTxtSize)-(Player.x2 / MinimapTxtSize, Player.y2 / MinimapTxtSize), _RGB32(255, 255, 255), BF
'If Debug = 1 Then
'    For w = 1 To WaypointMax
'        Line ((Waypoint(w).x - Map.TileSize / 2.5) / MinimapTxtSize, (Waypoint(w).y - Map.TileSize / 2.5) / MinimapTxtSize)-((Waypoint(w).x + Map.TileSize / 2.5) / MinimapTxtSize, (Waypoint(w).y + Map.TileSize / 2.5) / MinimapTxtSize), _RGBA(255, 255, 255, 128), BF
'        For i2 = 1 To Waypoint(w).connections
'            Line (Waypoint(w).x / MinimapTxtSize, Waypoint(w).y / MinimapTxtSize)-(Waypoint(WaypointJoints(w, i2)).x / MinimapTxtSize, Waypoint(WaypointJoints(w, i2)).y / MinimapTxtSize), _RGBA32(255, 255, 128, 200)
'        Next
'    Next
'End If
_Dest MainScreen
Return

Fire:
If FireTick = 0 Then FireTick = 3
FireTick = FireTick - 1
For i = 1 To FireMax
    If Fire(i).visible > 0 Then
        If Fire(i).visible > 10 Then CreateDynamicLight Fire(i).x, Fire(i).y, Fire(i).visible * 3, 2, "Low", "Normal", 0, 0
        Fire(i).distancefromplayer = Distance(Fire(i).x, Fire(i).y, Player.x, Player.y)
        If Fire(i).froozen > Fire(i).visible Then Fire(i).visible = Fire(i).visible + 1: If Fire(i).froozen = Fire(i).visible Then Fire(i).froozen = 0
        Fire(i).x = Fire(i).x + (Fire(i).xm / 12)
        Fire(i).y = Fire(i).y + (Fire(i).ym / 12)
        Fire(i).xm = Fire(i).xm / 1.02
        Fire(i).ym = Fire(i).ym / 1.02
        '    RotoZoom ETSX(Fire(i).x), ETSY(Fire(i).y), FireParticle(Int(Rnd * 3) + 1), 0.1 + (Fire(i).visible / 10), Int(Rnd * 10) - 5
        Size = 0.1 + Fire(i).visible

        If Fire(i).txt = 0 And FireTick = 0 Then
            For z = 1 To ZombieMax
                If Zombie(z).active = 1 Then If Distance(Fire(i).x, Fire(i).y, Zombie(z).x, Zombie(z).y) < (Size * 3) Then Zombie(z).onfire = Fire(i).visible * 5: Fire(i).visible = Fix(Fire(i).visible / 2)
            Next
        End If
        If Int(Rnd * 3) = 1 Then Fire(i).visible = Fire(i).visible - 1
        If Fire(i).visible > 10 And Fire(i).txt <> 4 And Fire(i).distancefromplayer < Int(Size * 1.5) Then PlayerIsOnFire = 6 * Fire(i).visible
        If Fire(i).visible > 20 And Fix(Fire(i).visible / 1.5) > 5 And Int(Rnd * 15) = 7 Then
            FireLast = FireLast + 1: If FireLast > FireMax Then FireLast = 1
            Fire(FireLast).txt = Fire(i).txt
            Fire(i).visible = Fire(i).visible - 10
            Fire(FireLast).froozen = Fix(Fire(i).visible * 0.9)
            Fire(FireLast).visible = 3
            Fire(FireLast).x = Fire(i).x + (Int(Rnd * 30) - 15) * 2
            Fire(FireLast).y = Fire(i).y + (Int(Rnd * 30) - 15) * 2
            For k = 1 To FireMax
                If k <> FireLast And FireLast <> i Then
                    If Distance(Fire(FireLast).x, Fire(FireLast).y, Fire(k).x, Fire(k).y) < (Size * 2) Then Fire(FireLast).visible = 1: FireLast = FireLast - 1: Exit For
                End If
            Next
        End If
        If Fire(i).visible < 0 Then
            Fire(i).txt = 0
            Fire(i).xm = 0
            Fire(i).ym = 0
            Fire(i).froozen = 0
        End If
        If Fire(i).distancefromplayer < _Width Then _PutImage (ETSX(Fire(i).x) - Size, ETSY(Fire(i).y) - Size)-(ETSX(Fire(i).x) + Size, ETSY(Fire(i).y) + Size), FireParticle
    End If

Next
Return






ResizeScreen:
If ResizeDelay > 0 Then ResizeDelay = ResizeDelay - 1
If _Resize And ResizeDelay = 0 And _WindowHasFocus Then
    Cls
    Screen SecondScreen
    _FreeImage MainScreen
    ScreenSizeX = _ResizeWidth
    ScreenSizeY = _ResizeHeight
    If ScreenSizeX < 128 Then ScreenSizeX = 128
    If ScreenSizeY < 128 Then ScreenSizeY = 128
    MainScreen = _NewImage(ScreenSizeX, ScreenSizeY, 32)
    Screen MainScreen

    ResizeDelay = 5
End If
Return

TriggerPlayer:
For i = 1 To Map.Triggers
    If TriggerPlayerCollide(Player, Trigger(i)) Then
        Select Case Trigger(i).class
            Case "TP"
                Player.x = Trigger(i).val1 * 2
                Player.y = Trigger(i).val2 * 2
            Case "DoorUse"
                If PlayerInteract = 1 Then
                    DoorX = Fix(((Trigger(i).x2 + Trigger(i).x1) / 2) / Map.TileSize)
                    DoorY = Fix(((Trigger(i).y2 + Trigger(i).y1) / 2) / Map.TileSize)
                    Trigger(i).val3 = Trigger(i).val3 + 1: If Trigger(i).val3 > 1 Then Trigger(i).val3 = 0
                    If Trigger(i).val3 = 0 Then Tile(DoorX, DoorY, 2).ID = Trigger(i).val1: Tile(DoorX, DoorY, 2).solid = 1
                    If Trigger(i).val3 = 1 Then Tile(DoorX, DoorY, 2).ID = Trigger(i).val2: Tile(DoorX, DoorY, 2).solid = 0
                    IDTOTEXTURE = Tile(DoorX, DoorY, 2).ID: Tile(DoorX, DoorY, 2).rend_spritey = 0
                    Do
                        If IDTOTEXTURE > 16 Then Tile(DoorX, DoorY, 2).rend_spritey = Tile(DoorX, DoorY, 2).rend_spritey + 1: IDTOTEXTURE = IDTOTEXTURE - 16
                        Tile(DoorX, DoorY, 2).rend_spritex = IDTOTEXTURE
                    Loop While IDTOTEXTURE > 16
                End If
        End Select
    End If
Next
Return


PlayerDeath:
If DeathTimer = 1 Then _SndPlay PlayerDeath
If DeathTimer < 1000 Then DeathTimer = DeathTimer + 3
If Int(Rnd * 6) + 1 = 3 And DeathTimer < 400 Then SpawnBloodParticle Player.x - 20 + Int(Rnd * 21), Player.y - 20 + Int(Rnd * 21), -180 + Int(Rnd * 361), 20, "red": Part(LastPart).xm = Int(Rnd * 500) - 250: Part(LastPart).ym = Int(Rnd * 500) - 250: Part(LastPart).zm = Int(Part(LastPart).zm / 4)
DayAmount = DayAmount + 1
PlayerCantMove = 1
If DayAmount > 480 Then GoSub RestartEverything
Return

WaveChange:

Randomize Timer
If WaveWait = 0 Then
    WaveWait = 600: WaveDisplayY = -thy: Wave = Wave + 1: WaveBudget = (Wave * Config.Wave_ZombieMultiplier) + Int(Rnd * 22)
    If WaveBudget > ZombieMax Then WaveBudget = ZombieMax
End If
If Wave = Config.Wave_End Then WaveWait = -9999999: DelayUntilStart = 1200: Showtext = 1: WaveDisplayY = -thy * 2: GoTo EndWaveCode
If WaveWait = 1 Then
    DayAmount = DayAmount - 1
    For i = 1 To WaveBudget
        CreateZombie:
        Special = 0
        If Int(Rnd * 3) + 1 = 1 Then Special = 1
        If Special = 1 Then SpecialType = Int(Rnd * 6) + 1

        If Special <> 1 Then
            Rand = Int(Rnd * 60)
            If Rand = 25 Then
                Zombie(i).size = Int(Rnd * (DefZombie.size - 20 + 1)) + 20 ' DefZombie.size
            Else
                Zombie(i).size = DefZombie.size
            End If
            Zombie(i).active = 1
            Zombie(i).maxspeed = Int(Rnd * (500 - 300 + 1)) + 300
            Zombie(i).damage = Int(Rnd * (6 - 2 + 1)) + 2
            Zombie(i).speeding = Int(Rnd * (20 - 10 + 1)) + 10
            Zombie(i).knockback = Int(Rnd * (8 - 5 + 1)) + 5
            Zombie(i).special = "Normal"
            Zombie(i).health = Int(Rnd * (DefZombie.maxhealth - DefZombie.minhealth + 1)) + DefZombie.minhealth
            Zombie(i).weight = 0.5
        End If
        If Special = 1 Then
            Zombie(i).active = 1
            Select Case SpecialType
                Case 1 ' Runner
                    Rand = Int(Rnd * 20120)
                    Zombie(i).size = Int(Rnd * (34 - 25 + 1)) + 25
                    Zombie(i).health = Int(Rnd * (Int(DefZombie.maxhealth / 1.5) - Fix(DefZombie.minhealth / 1.5) + 1)) + Fix(DefZombie.minhealth / 2)
                    Zombie(i).maxspeed = Int(Rnd * (1100 - 900 + 1)) + 900
                    Zombie(i).damage = Int(Rnd * (8 - 2 + 1)) + 2
                    Zombie(i).speeding = Int(Rnd * (45 - 30 + 1)) + 30
                    Zombie(i).knockback = Int(Rnd * (10 - 5 + 1)) + 5
                    Zombie(i).special = "Runner"
                    Zombie(i).weight = 1
                Case 2 ' Brute
                    Rand = Int(Rnd * 8)
                    If Rand = 3 Then GoTo CreateZombie
                    Zombie(i).size = Int(Rnd * (100 - 70 + 1)) + 70
                    Zombie(i).health = Int(Rnd * ((DefZombie.maxhealth + 300) - DefZombie.minhealth + 1)) + DefZombie.minhealth + (Zombie(i).size * 2)
                    Zombie(i).maxspeed = Int(Rnd * (600 - 500 + 1)) + 500
                    Zombie(i).damage = Int(Rnd * (80 - 40 + 1)) + 40
                    Zombie(i).speeding = Int(Rnd * (20 - 10 + 1)) + 10
                    Zombie(i).knockback = Int(Rnd * (50 - 30 + 1)) + 30
                    Zombie(i).special = "Brute"
                    Zombie(i).weight = 20
                Case 3 ' Slower
                    Zombie(i).size = Int(Rnd * (34 - 25 + 1)) + 25
                    Zombie(i).health = Int(Rnd * (Int(DefZombie.maxhealth + 20) - Fix(DefZombie.minhealth) + 1)) + Fix(DefZombie.minhealth)
                    Zombie(i).damage = Int(Rnd * (30 - 20 + 1)) + 20
                    Zombie(i).maxspeed = DefZombie.maxspeed
                    Zombie(i).speeding = Int(Rnd * (7 - 4 + 1)) + 4
                    Zombie(i).weight = 2
                    Zombie(i).knockback = Int(Rnd * (10 - 5 + 1)) + 5
                    Zombie(i).special = "Slower"
                Case 4 ' Bomber
                    Rand = Int(Rnd * 12)
                    If Rand = 7 Then GoTo CreateZombie

                    Zombie(i).size = Int(Rnd * (34 - 25 + 1)) + 25
                    Zombie(i).health = Int(Rnd * (Int(DefZombie.maxhealth / 2) - Fix(DefZombie.minhealth / 2) + 1)) + Fix(DefZombie.minhealth / 2)
                    Zombie(i).maxspeed = Int(Rnd * (850 - 700 + 1)) + 700
                    Zombie(i).damage = Int(Rnd * (10 - 2 + 1)) + 2
                    Zombie(i).speeding = Int(Rnd * (30 - 20 + 1)) + 20
                    Zombie(i).knockback = Int(Rnd * (10 - 5 + 1)) + 5
                    Zombie(i).special = "Bomber"
                    Zombie(i).weight = 2
                Case 5 ' Fire
                    Rand = Int(Rnd * 28)
                    If Rand = 13 Then GoTo CreateZombie

                    Zombie(i).size = Int(Rnd * (37 - 27 + 1)) + 27
                    Zombie(i).health = Int(Rnd * (Int(DefZombie.maxhealth) - Fix(DefZombie.minhealth) + 1)) + Fix(DefZombie.minhealth)
                    Zombie(i).maxspeed = Int(Rnd * (850 - 500 + 1)) + 500
                    Zombie(i).damage = Int(Rnd * (10 - 2 + 1)) + 2
                    Zombie(i).speeding = Int(Rnd * (10 - 5 + 1)) + 5
                    Zombie(i).knockback = Int(Rnd * (10 - 5 + 1)) + 5
                    Zombie(i).special = "Fire"
                    Zombie(i).weight = 1
                Case 6 ' Biohazard
                    Rand = Int(Rnd * 200)
                    Zombie(i).size = Int(Rnd * (37 - 27 + 1)) + 27
                    Zombie(i).health = Int(Rnd * (Int(DefZombie.maxhealth) - Fix(DefZombie.minhealth) + 1)) + Fix(DefZombie.minhealth)
                    Zombie(i).maxspeed = Int(Rnd * (850 - 500 + 1)) + 500
                    Zombie(i).damage = Int(Rnd * (10 - 2 + 1)) + 2
                    Zombie(i).speeding = Int(Rnd * (10 - 5 + 1)) + 5
                    Zombie(i).knockback = -Int(Rnd * (10 - 5 + 1)) + 5
                    Zombie(i).special = "Biohazard"
                    Zombie(i).weight = 2
            End Select
        End If
        Zombie(i).x = 4 + Int(Rnd * (Map.MaxWidth - 8))
        Zombie(i).y = 4 + Int(Rnd * (Map.MaxHeight - 8))
        If Tile(Fix(Zombie(i).x), Fix(Zombie(i).y), 2).solid = 1 Then GoTo CreateZombie
        Zombie(i).x = Zombie(i).x * Map.TileSize
        Zombie(i).y = Zombie(i).y * Map.TileSize
        Zombie(i).Healthfirst = Zombie(i).health
        Zombie(i).sizeFirst = Zombie(i).size
    Next
End If
If WaveWait > 0 Then WaveWait = WaveWait - 1
Text$ = "Wave: " + Str$(Wave)
FontSizeUse = 70
GoSub HudText
dist = (Abs(WaveDisplayY - _Width / 2) / 50): WaveDisplayY = WaveDisplayY + 1 / (dist / 15)
WaveDisplayTHX = thx: WaveDisplayTHY = thy
_PutImage (_Width / 2 - WaveDisplayTHX / 2, WaveDisplayY - WaveDisplayTHY / 2), ImgToMenu
Text$ = (_Trim$(Str$(WaveBudget)) + " Infecteds coming...")
FontSizeUse = 40
GoSub HudText
WaveDisplayTHX = thx
_PutImage (_Width / 2 - WaveDisplayTHX / 2, WaveDisplayY + WaveDisplayTHY / 2), ImgToMenu
EndWaveCode:
Return



HudText:
_Font BegsFontSizes(FontSizeUse)
thx = _PrintWidth(Text$)
thy = _FontHeight(BegsFontSizes(FontSizeUse))
If ImgToMenu <> 0 Then _FreeImage ImgToMenu
ImgToMenu = _NewImage(thx * 3, thy * 3, 32)
_Dest ImgToMenu
_ClearColor _RGB32(0, 0, 0): _PrintMode _KeepBackground: _Font BegsFontSizes(FontSizeUse): Print Text$
_Dest MainScreen
_Font BegsFontSizes(20)
Return





GrenadeLogic:
For i = 1 To GrenadeMax
    If Grenade(i).visible = 0 Then GoTo EndOfGrenadeLogic
    Grenade(i).x = Grenade(i).x + (Grenade(i).xm / 10)
    Grenade(i).y = Grenade(i).y + (Grenade(i).ym / 10)
    Grenade(i).z = Grenade(i).z + (Grenade(i).zm / 10)
    If Grenade(i).z > 0 Then Grenade(i).zm = Grenade(i).zm - 2
    If Grenade(i).z < 0 And Grenade(i).zm < 0 Then
        _SndPlayCopy ShellSounds(Int(1 + Rnd * 3)), 0.25
        Grenade(i).zm = Int(Grenade(i).zm * -0.5)
        Grenade(i).xm = Int(Grenade(i).xm / 2): Grenade(i).ym = Int(Grenade(i).ym / 2)
    End If
    If Grenade(i).froozen = -1 Then
        Randomize Timer
        x1 = Fix(Grenade(i).x / Map.TileSize) - 3
        x2 = Fix(Grenade(i).x / Map.TileSize) + 3
        y1 = Fix(Grenade(i).y / Map.TileSize) - 3
        y2 = Fix(Grenade(i).y / Map.TileSize) + 3
        If x1 < 0 Then x1 = 0
        If y1 < 0 Then y1 = 0
        If x2 > Map.MaxWidth Then x2 = Map.MaxWidth
        If y2 > Map.MaxHeight Then y2 = Map.MaxHeight

        For x = x1 To x2
            For y = y1 To y2
                If Tile(x, y, 2).fragile = 1 Then
                    For o = 1 To 5
                        Part(LastPart).x = x * Map.TileSize + Int(Rnd * Map.TileSize): Part(LastPart).y = y * Map.TileSize + Int(Rnd * Map.TileSize): Part(LastPart).z = 2: Part(LastPart).xm = Int(Rnd * 128) - 64: Part(LastPart).ym = Int(Rnd * 128) - 64: Part(LastPart).zm = 2 + Int(Rnd * 7)
                        Part(LastPart).froozen = -30: Part(LastPart).visible = 1600: Part(LastPart).partid = "GlassShard": Part(LastPart).playwhatsound = "Glass"
                        Part(LastPart).rotation = Int(Rnd * 360) - 180: Part(LastPart).rotationspeed = Int(Rnd * 60) - 30: LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0
                    Next
                    If Tile(x, y, 2).ID = 56 Then _SndPlayCopy GlassShadder(Int(1 + Rnd * 3)), 0.4
                    Tile(x, y, 2).ID = 0
                    Tile(x, y, 2).solid = 0
                    Tile(x, y, 2).rend_spritex = 0
                    Tile(x, y, 2).rend_spritey = 0
                End If

            Next
        Next
        For k = 1 To 15
            FireLast = FireLast + 1: If FireLast > FireMax Then FireLast = 1
            Fire(FireLast).txt = 0
            Fire(FireLast).froozen = 40
            Fire(FireLast).visible = 20
            Fire(FireLast).x = Grenade(i).x + (Int(Rnd * 30) - 15) * 2
            Fire(FireLast).y = Grenade(i).y + (Int(Rnd * 30) - 15) * 2
            Fire(FireLast).xm = Int(Rnd * 200) - 100
            Fire(FireLast).ym = Int(Rnd * 200) - 100
        Next
        Grenade(i).visible = 0
        Grenade(i).froozen = 0
        Explosion Grenade(i).x, Grenade(i).y, 100, 350
        Circle (ETSX(Grenade(i).x), ETSY(Grenade(i).y)), 200, _RGB32(255, 255, 255)
        _SndPlay SND_Explosion
    End If
    If Grenade(i).froozen < 0 Then Grenade(i).froozen = Grenade(i).froozen + 1
    If Fix(Grenade(i).z) <= 0 Then Grenade(i).z = 0
    If Grenade(i).xm > 0 Then Grenade(i).xm = Grenade(i).xm - 1
    If Grenade(i).ym > 0 Then Grenade(i).ym = Grenade(i).ym - 1
    If Grenade(i).xm < 0 Then Grenade(i).xm = Grenade(i).xm + 1
    If Grenade(i).ym < 0 Then Grenade(i).ym = Grenade(i).ym + 1
    If Tile(Fix((Grenade(i).x + 8) / Map.TileSize), Fix(Grenade(i).y / Map.TileSize), 2).solid = 1 Then Grenade(i).xm = Grenade(i).xm * -1.1: Grenade(i).ym = 0
    If Tile(Fix((Grenade(i).x - 8) / Map.TileSize), Fix(Grenade(i).y / Map.TileSize), 2).solid = 1 Then Grenade(i).xm = Grenade(i).xm * -1.1: Grenade(i).ym = 0
    If Tile(Fix(Grenade(i).x / Map.TileSize), Fix((Grenade(i).y + 8) / Map.TileSize), 2).solid = 1 Then Grenade(i).xm = 0: Grenade(i).ym = Grenade(i).ym * -1.1
    If Tile(Fix(Grenade(i).x / Map.TileSize), Fix((Grenade(i).y - 8) / Map.TileSize), 2).solid = 1 Then Grenade(i).xm = 0: Grenade(i).ym = Grenade(i).ym * -1.1
    Grenade(i).rotation = Grenade(i).rotation + Grenade(i).rotationspeed
    If Grenade(i).rotationspeed > 0 Then Grenade(i).rotationspeed = Grenade(i).rotationspeed - 1
    If Grenade(i).rotationspeed < 0 Then Grenade(i).rotationspeed = Grenade(i).rotationspeed + 1
    RotoZoom ETSX(Grenade(i).x), ETSY(Grenade(i).y), Guns_Grenade, .6 + (Grenade(i).z / 50), Grenade(i).rotation + 90
    EndOfGrenadeLogic:
Next
Return







ParticleLogic:
For i = 1 To ParticlesMax
    If Part(i).visible = 0 Then GoTo EndOfParticleLogic
    Part(i).distancefromplayer = Distance(Player.x, Player.y, Part(i).x, Part(i).y)
    If Part(i).distancefromplayer > _Width Then GoTo EndOfParticleLogic
    If Part(i).playwhatsound = "Blood" And Part(i).froozen = 0 Then
        dist = Part(i).distancefromplayer
        If dist > 900 Then Part(i).visible = Part(i).visible - 1
        If dist < 600 And Player.Health > 0 Then

            If dist < 30 And Part(i).partid = "BloodSplat" Then
                LastBloodPart = LastBloodPart + 1: If LastBloodPart > 32 Then LastBloodPart = 1
                BloodPart(LastBloodPart).x = 64 ' Int(Rnd * _Width(HeartPercent))
                BloodPart(LastBloodPart).y = -8
                BloodPart(LastBloodPart).xm = Int(Rnd * 100) - 50
                BloodPart(LastBloodPart).ym = 80 + Int(Rnd * 50)
                BloodPart(LastBloodPart).visible = 1
                Part(i).visible = 0: Part(i).xm = 0: Part(i).ym = 0: Part(i).playwhatsound = "": Player.Health = Player.Health + Config.Player_HealthPerBlood: GoTo EndOfParticleLogic
            End If
            If dist < 25 And Part(i).partid = "PistolAmmo" Then SMGAmmo = SMGAmmo + 50: Part(i).playwhatsound = "": Part(i).visible = 0: Part(i).xm = 0: Part(i).ym = 0: GoTo EndOfParticleLogic
            If dist < 25 And Part(i).partid = "ShotgunAmmo" Then ShotgunAmmo = ShotgunAmmo + 12: Part(i).playwhatsound = "": Part(i).visible = 0: Part(i).xm = 0: Part(i).ym = 0: GoTo EndOfParticleLogic
            If dist < 25 And Part(i).partid = "GasAmmo" Then FlameAmmo = FlameAmmo + 50: Part(i).playwhatsound = "": Part(i).visible = 0: Part(i).xm = 0: Part(i).ym = 0: GoTo EndOfParticleLogic
            If dist < 25 And Part(i).partid = "GrenadeAmmo" Then GrenadeAmmo = GrenadeAmmo + 1: Part(i).playwhatsound = "": Part(i).visible = 0: Part(i).xm = 0: Part(i).ym = 0: GoTo EndOfParticleLogic
            dx = Player.x - Part(i).x: dy = Player.y - Part(i).y
            Part(i).rotation = ATan2(dy, dx) ' Angle in radians
            Part(i).rotation = (Part(i).rotation * 180 / PI) + 90
            If Part(i).rotation > 180 Then Part(i).rotation = Part(i).rotation - 179.9
            Part(i).xm = Part(i).xm / 1.03
            Part(i).ym = Part(i).ym / 1.03
            Part(i).xm = Part(i).xm + -Sin(Part(i).rotation * PIDIV180) * 9 / (dist / 150)
            Part(i).ym = Part(i).ym + Cos(Part(i).rotation * PIDIV180) * 9 / (dist / 150)
            Part(i).x = Part(i).x + (Part(i).xm / 10)
            Part(i).y = Part(i).y + (Part(i).ym / 10)
            Part(i).z = 3 / (dist / 70)
            If Part(i).z > 15 Then Part(i).z = 15
        End If
    End If

    If Part(i).froozen <> 0 Then
        Part(i).x = Part(i).x + (Part(i).xm / 10)
        Part(i).y = Part(i).y + (Part(i).ym / 10)
        Part(i).z = Part(i).z + (Part(i).zm / 10)
        If Part(i).z > 0 Then Part(i).zm = Part(i).zm - 1
        If Part(i).z < 0 And Part(i).zm < 0 Then
            If Part(i).playwhatsound = "ShotgunShell" Then
                _SndPlayCopy ShellSounds(Int(1 + Rnd * 3)), 0.2
                Part(i).zm = Int(Part(i).zm * -0.9)
                Part(i).xm = Int(Part(i).xm / 2): Part(i).ym = Int(Part(i).ym / 2)
                Part(i).froozen = -200
            End If

            If Part(i).playwhatsound = "PistolShell" Then
                pistsndold = pistsnd
                pistsnd = Int(1 + Rnd * 3)
                If pistsnd = pistsndold Then pistsnd = Int(1 + Rnd * 3)
                _SndPlayCopy PistolShellSounds(pistsnd), 0.25
                Part(i).zm = Int(Part(i).zm * -0.9)
                Part(i).xm = Int(Part(i).xm / 2): Part(i).ym = Int(Part(i).ym / 2)
                Part(i).froozen = -200
            End If

            If Part(i).playwhatsound = "Blood" Then
                _SndPlayCopy BloodSounds(Int(1 + Rnd * 6)), 0.1
                Part(i).zm = Int(Part(i).zm * -0.7)
                Part(i).xm = Int(Part(i).xm / 1.4): Part(i).ym = Int(Part(i).ym / 1.4)
                Part(i).froozen = -200
            End If

            If Part(i).playwhatsound = "Glass" Then
                _SndPlayCopy GlassSound(Int(1 + Rnd * 4)), 0.2
                Part(i).zm = Int(Part(i).zm * -0.9)
                Part(i).xm = Int(Part(i).xm / 2): Part(i).ym = Int(Part(i).ym / 2)
                Part(i).froozen = -200
            End If
        End If
        If Part(i).froozen < 0 Then Part(i).froozen = Part(i).froozen + 1
        If Fix(Part(i).z) <= 0 Then Part(i).z = 0
        If Part(i).xm > 0 Then Part(i).xm = Part(i).xm - 1
        If Part(i).ym > 0 Then Part(i).ym = Part(i).ym - 1
        If Part(i).xm < 0 Then Part(i).xm = Part(i).xm + 1
        If Part(i).ym < 0 Then Part(i).ym = Part(i).ym + 1

        x = Fix(Part(i).x / Map.TileSize)
        y = Fix(Part(i).y / Map.TileSize)
        If x < 0 Then x = 0
        If y < 0 Then y = 0
        If x > Map.MaxWidth Then x = Map.MaxWidth
        If y > Map.MaxHeight Then y = Map.MaxHeight

        If Tile(x, y, 2).solid = 1 Then Part(i).xm = 0: Part(i).ym = 0
        Part(i).rotation = Part(i).rotation + Part(i).rotationspeed
        If Part(i).rotationspeed > 0 Then Part(i).rotationspeed = Part(i).rotationspeed - 1
        If Part(i).rotationspeed < 0 Then Part(i).rotationspeed = Part(i).rotationspeed + 1
    End If
    If Not Part(i).playwhatsound = "Blood" Then Part(i).visible = Part(i).visible - 1
    '_PutImage (ETSX(Part(i).x), ETSY(Part(i).y)), Particle_Shotgun_Shell

    GoSub RenderParticle


    EndOfParticleLogic:
Next
Return
RenderParticle:
If Part(i).visible > 0 Then
    If Part(i).partid = "PistolShell" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), Particle_Pistol_Shell, 0.3 + (Part(i).z / 4), Part(i).rotation
    If Part(i).partid = "ShotgunShell" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), Particle_Shotgun_Shell, 0.3 + (Part(i).z / 4), Part(i).rotation
    If Part(i).partid = "WallShot" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), WallShot, 0.8 + (Part(i).z / 4), Part(i).rotation
    If Part(i).partid = "Smoke" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), Particle_Smoke, 0.05 + (Part(i).z / 4), Part(i).rotation
    If Part(i).partid = "Explosion" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), Particle_Explosion, 0.1 + (Part(i).z / 4), Part(i).rotation
    If Part(i).partid = "BloodSplat" Then
        If Part(i).BloodColor = "green" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), BloodsplatGreen, 1 + (Part(i).z / 4), Part(i).rotation
        If Part(i).BloodColor = "red" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), BloodsplatRed, 1 + (Part(i).z / 4), Part(i).rotation

    End If
    If Part(i).partid = "GlassShard" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), GlassShard, 1 + (Part(i).z / 2), Part(i).rotation
    If Part(i).partid = "GibSkull" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), Gib_Skull, 2 + (Part(i).z / 3), Part(i).rotation
    If Part(i).partid = "GibBone" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), Gib_Bone, 2 + (Part(i).z / 3), Part(i).rotation
    If Part(i).partid = "PistolAmmo" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), PistolShellAmmo, 1 + (Part(i).z / 3), Part(i).rotation
    If Part(i).partid = "GrenadeAmmo" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), Guns_Grenade, 1 + (Part(i).z / 3), Part(i).rotation
    If Part(i).partid = "ShotgunAmmo" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), ShellShotgunAmmo, 1 + (Part(i).z / 3), Part(i).rotation
    If Part(i).partid = "GasAmmo" Then RotoZoom ETSX(Part(i).x), ETSY(Part(i).y), GasCanAmmo, 1 + (Part(i).z / 3), Part(i).rotation
End If
Return

RenderPlayer:

If Debug = 1 Then Line (ETSX(Player.x1), ETSY(Player.y1))-(ETSX(Player.x2), ETSY(Player.y2)), _RGB32(P * 120, 255, 255), BF
RotoZoom ETSX(Player.x), ETSY(Player.y), PlayerSprite(PlayerSkin2), 0.25, Player.Rotation
For i = 1 To 2
    _PutImage (PlayerMember(i).x - 8 - CameraX * Map.TileSize, PlayerMember(i).y - 8 - CameraY * Map.TileSize)-(PlayerMember(i).x + 8 - CameraX * Map.TileSize, PlayerMember(i).y + 8 - CameraY * Map.TileSize), PlayerHand(PlayerSkin2)
Next

Return










MenuSystem:
Do
    Mouse.x = _MouseX
    Mouse.y = _MouseY
    Mouse.click = _MouseButton(1)
Loop While _MouseInput
MenuClicking = 0
If MenuClicking = 0 And Mouse.click = 0 And MenuClickingPre = 1 Then MenuClicking = 1
MenuClickingPre = -Mouse.click
If LastToUse < 0 Then LastToUse = 0
If Mouse.click = 0 Then LastToUse = LastToUse * -1
If delay > 0 Then delay = delay - 1
Mouse.x1 = Mouse.x - 1: Mouse.x2 = Mouse.x + 1: Mouse.y1 = Mouse.y - 1: Mouse.y2 = Mouse.y + 1
DontRepeatFor = 0
If ResizeDelay2 > 0 Then ResizeDelay2 = ResizeDelay2 - 1
If _Resize Then GoSub ScreenAdjustForSize
'MenuAnimCode:

For i = 1 To 3
    If RayM(i).owner = 1 Then

        dx = RayM(i).x - RayM(i).damage: dy = RayM(i).y - RayM(i).knockback
        rotation = ATan2(dy, dx) ' Angle in radians
        RayM(i).angle = (rotation * 180 / PI) + 90
        If RayM(i).angle > 180 Then RayM(i).angle = RayM(i).angle - 179.9
        xvector = Sin(RayM(i).angle * PIDIV180): yvector = -Cos(RayM(i).angle * PIDIV180)

        RayM(i).x = RayM(i).x + xvector * (1 + (Distance(RayM(i).x, RayM(i).y, RayM(i).damage, RayM(i).knockback) / 5))
        RayM(i).y = RayM(i).y + yvector * (1 + (Distance(RayM(i).x, RayM(i).y, RayM(i).damage, RayM(i).knockback) / 5))
    End If
Next

For i = lasti To 1 Step -1
    If DontRepeatFor = 1 Or CantClickAnymoreOnHud = 1 Then Exit For
    If LastToUse > 0 Then DontRepeatFor = 1: i = LastToUse
    If Menu(i).d_hover > 32 Then Menu(i).d_hover = Menu(i).d_hover - 2
    If MenuAnim.extra < 29 And UICollide(Mouse, Menu(i)) Or LastToUse > 0 Then

        menx = Int((Menu(i).x1 + Menu(i).x2) / 2)
        meny = Int((Menu(i).y1 + Menu(i).y2) / 2)
        dx = menx - Mouse.x
        dy = meny - Mouse.y
        rotation = ATan2(dy, dx) ' Angle in radians
        TempAngle = (rotation * 180 / PI) + 90
        If TempAngle > 180 Then TempAngle = TempAngle - 179.5
        Menu(i).OffsetX = Sin(TempAngle * PIDIV180) * (Distance(menx, meny, Mouse.x, Mouse.y) / 17): Menu(i).OffsetY = -Cos(TempAngle * PIDIV180) * (Distance(menx, meny, Mouse.x, Mouse.y) / 17)



        For o = 1 To 5
            If Menu(i).d_hover < 32 Then Menu(i).d_hover = Menu(i).d_hover + 1
        Next
        DontRepeatFor = 1
        If Mouse.click = -1 And delay = 0 Then
            _KeyClear
            GoSub MenuButtonStyle
            clicked = i
        End If
        If MenuClicking = 1 And Menu(i).clicktogo <> "" Then
            RayM(1).x = Menu(i).x1 + Menu(i).OffsetX
            RayM(1).y = Menu(i).y1 + Menu(i).OffsetY
            RayM(1).damage = 0
            RayM(1).knockback = 0
            RayM(1).owner = 1
            RayM(2).x = Menu(i).x2 + Menu(i).OffsetX
            RayM(2).y = Menu(i).y2 + Menu(i).OffsetY
            RayM(2).damage = _Width
            RayM(2).knockback = _Height
            RayM(2).owner = 1
            RayM(3).x = ((Menu(i).x1 + Menu(i).x2) / 2) + Menu(i).OffsetX
            RayM(3).y = ((Menu(i).y1 + Menu(i).y2) / 2) + Menu(i).OffsetY
            RayM(3).damage = Fix(_Width / 2)
            RayM(3).knockback = Fix(_Height / 2)
            RayM(3).owner = 1
            MenuClickedID = i
            MenuTransitionImage = _CopyImage(MenusImages(MenuClickedID))
            MenuAnim.red = Int(Menu(i).red / 1.03)
            MenuAnim.green = Int(Menu(i).green / 1.03)
            MenuAnim.blue = Int(Menu(i).blue / 1.03)
            MenuAnim.extra = 255
            CanChangeMenu = 0

            If Menu(i).clicktogo <> "" Then
                ToLoad$ = Menu(i).clicktogo
            End If
        End If
    End If
Next

For i = 1 To lasti
    If Menu(i).style = 3 And Menu(i).d_clicked = 2 Then GoSub InputStyleKeyGet
Next

GoSub PreRenderMenuWhatClicked

If CanChangeMenu = 1 Then
    If Loaded$ <> ToLoad$ Then GoSub load
    CanChangeMenu = 0


End If

'Drawing Routine:
For i = 1 To lasti
    For o = 1 To 3
        If Menu(i).d_hover < 0 Then Menu(i).d_hover = Menu(i).d_hover + 1
    Next
    If Menu(i).d_hover >= 4 Then Menu(i).d_hover = Menu(i).d_hover - 4
    If Menu(i).text <> "No Draw" Then Line ((Menu(i).x1 - Menu(i).d_hover / 4) - 16, (Menu(i).y1 - Menu(i).d_hover / 4) + 16)-((Menu(i).x2 + Menu(i).d_hover / 4) - 16, (Menu(i).y2 + Menu(i).d_hover / 4) + 16), _RGBA32(0, 0, 0, 100), BF
Next
For i = 1 To lasti


    If Menu(i).text <> "No Draw" Then Line ((Menu(i).x1 + Menu(i).OffsetX) - Menu(i).d_hover / 4, (Menu(i).y1 + Menu(i).OffsetY) - Menu(i).d_hover / 4)-((Menu(i).x2 + Menu(i).OffsetX) + Menu(i).d_hover / 4, (Menu(i).y2 + Menu(i).OffsetY) + Menu(i).d_hover / 4), _RGB32(Menu(i).red, Menu(i).green, Menu(i).blue), BF
    If Menu(i).style = 1 Then If Menu(i).text <> "W Bh" Then If Menu(i).text <> "No Draw" Or Menu(i).textsize < 2 Then _PutImage (((Menu(i).x1 + Menu(i).OffsetX) / 2 + (Menu(i).x2 + Menu(i).OffsetX) / 2) - _Width(MenusImages(i)) / 2 - Menu(i).d_hover / 4, ((Menu(i).y1 + Menu(i).OffsetY) / 2 + (Menu(i).y2 + Menu(i).OffsetY) / 2) - _Height(MenusImages(i)) / 2 - Menu(i).d_hover / 4)-(((Menu(i).x1 + Menu(i).OffsetX) / 2 + (Menu(i).x2 + Menu(i).OffsetX) / 2) + _Width(MenusImages(i)) / 2 + Menu(i).d_hover / 4, ((Menu(i).y1 + Menu(i).OffsetY) / 2 + (Menu(i).y2 + Menu(i).OffsetY) / 2) + _Height(MenusImages(i)) / 2 + Menu(i).d_hover / 4), MenusImages(i)
    If Menu(i).style = 2 Then
        _PutImage (((Menu(i).x1 + Menu(i).OffsetX) / 2 + (Menu(i).x2 + Menu(i).OffsetX) / 2) - _Width(MenusImages(i)) / 2 - Menu(i).d_hover / 4, ((Menu(i).y1 + Menu(i).OffsetY) / 2 + (Menu(i).y2 + Menu(i).OffsetY) / 2) - _Height(MenusImages(i)) / 2 - Menu(i).d_hover / 4)-(((Menu(i).x1 + Menu(i).OffsetX) / 2 + (Menu(i).x2 + Menu(i).OffsetX) / 2) + _Width(MenusImages(i)) / 2 + Menu(i).d_hover / 4, ((Menu(i).y1 + Menu(i).OffsetY) / 2 + (Menu(i).y2 + Menu(i).OffsetY) / 2) + _Height(MenusImages(i)) / 2 + Menu(i).d_hover / 4), MenusImages(i)
        Line ((Menu(i).x1 + Menu(i).OffsetX) + CalculatePercentage(((Menu(i).x2 + Menu(i).OffsetX) - (Menu(i).x1 + Menu(i).OffsetX)), 5) - Menu(i).d_hover / 8, (Menu(i).y1 + Menu(i).OffsetY) + CalculatePercentage(((Menu(i).y2 + Menu(i).OffsetY) - (Menu(i).y1 + Menu(i).OffsetY)), 48) - Menu(i).d_hover / 8)-((Menu(i).x2 + Menu(i).OffsetX) - CalculatePercentage(((Menu(i).x2 + Menu(i).OffsetX) - (Menu(i).x1 + Menu(i).OffsetX)), 5) + Menu(i).d_hover / 8, (Menu(i).y2 + Menu(i).OffsetY) - CalculatePercentage(((Menu(i).y2 + Menu(i).OffsetY) - (Menu(i).y1 + Menu(i).OffsetY)), 48) + Menu(i).d_hover / 8), _RGBA32(0, 0, 0, 128), BF
        Line ((Menu(i).x1 + Menu(i).OffsetX) + Menu(i).visual - CalculatePercentage(((Menu(i).x2 + Menu(i).OffsetX) - (Menu(i).x1 + Menu(i).OffsetX)), 2), (Menu(i).y1 + Menu(i).OffsetY) + CalculatePercentage(((Menu(i).y2 + Menu(i).OffsetY) - (Menu(i).y1 + Menu(i).OffsetY)), 5))-((Menu(i).x1 + Menu(i).OffsetX) + Menu(i).visual + CalculatePercentage(((Menu(i).x2 + Menu(i).OffsetX) - (Menu(i).x1 + Menu(i).OffsetX)), 2), (Menu(i).y2 + Menu(i).OffsetY) - CalculatePercentage(((Menu(i).y2 + Menu(i).OffsetY) - (Menu(i).y1 + Menu(i).OffsetY)), 5)), _RGBA32(0, 255, 0, 128), BF
    End If

    If Menu(i).style = 3 Then If Menu(i).text <> "W Bh" Or Menu(i).text <> "No Draw" Or Menu(i).textsize < 2 Then _PutImage ((Menu(i).x1 / 2 + Menu(i).x2 / 2) - _Width(MenusImages(i)) / 2 - Menu(i).d_hover / 4, (Menu(i).y1 / 2 + Menu(i).y2 / 2) - _Height(MenusImages(i)) / 2 - Menu(i).d_hover / 4)-((Menu(i).x1 / 2 + Menu(i).x2 / 2) + _Width(MenusImages(i)) / 2 + Menu(i).d_hover / 4, (Menu(i).y1 / 2 + Menu(i).y2 / 2) + _Height(MenusImages(i)) / 2 + Menu(i).d_hover / 4), MenusImages(i)

    Menu(i).OffsetX = Menu(i).OffsetX / 1.06
    Menu(i).OffsetY = Menu(i).OffsetY / 1.06
Next
'Loop While CanLeave = 0
For i = 1 To 32
    If Menu(i).extra3 <> 0 And Menu(i).d_hover <> 0 Then
    End If
Next


GoSub PostRenderMenuWhatClicked
If MenuAnim.extra > 0 Then

    MenuAnim.x1 = RayM(1).x
    MenuAnim.y1 = RayM(1).y
    MenuAnim.x2 = RayM(2).x
    MenuAnim.y2 = RayM(2).y


    If Fix(MenuAnim.x1) <= 0 Then If Fix(MenuAnim.y1) <= 0 Then RayM(1).owner = 0
    If Int(MenuAnim.x2) >= _Width Then If Int(MenuAnim.y2) >= _Height Then RayM(2).owner = 0


    Line (MenuAnim.x1, MenuAnim.y1)-(MenuAnim.x2, MenuAnim.y2), _RGBA32(MenuAnim.red, MenuAnim.green, MenuAnim.blue, MenuAnim.extra), BF
    '_SetAlpha Fix(MenuAnim.extra), MenusImages(MenuClickedID)
    'If Menu(MenuClickedID).text <> "W Bh" Or Menu(MenuClickedID).textsize < 2 Then _PutImage (RayM(3).x - _Width(MenusImages(MenuClickedID)) / 2, RayM(3).y - _Height(MenusImages(MenuClickedID)) / 2)-(RayM(3).x + _Width(MenusImages(MenuClickedID)) / 2, RayM(3).y + _Height(MenusImages(MenuClickedID)) / 2), MenusImages(MenuClickedID)
    _SetAlpha Fix(MenuAnim.extra), _RGBA32(1, 1, 1, 1) To _RGB32(255, 255, 255, 255), MenuTransitionImage

    If Menu(MenuClickedID).text <> "W Bh" Or Menu(MenuClickedID).textsize < 2 Then _PutImage (RayM(3).x - _Width(MenuTransitionImage) / 2, RayM(3).y - _Height(MenuTransitionImage) / 2)-(RayM(3).x + _Width(MenuTransitionImage) / 2, RayM(3).y + _Height(MenuTransitionImage) / 2), MenuTransitionImage

    If RayM(1).x <= 1 Then
        If RayM(1).y <= 1 Then
            If RayM(2).x >= _Width - 1 Then
                If RayM(2).y >= _Height - 1 Then
                    RayM(1).x = RayM(1).damage: RayM(2).x = RayM(2).damage
                    RayM(1).y = RayM(1).knockback: RayM(2).y = RayM(2).knockback
                    RayM(1).owner = 0: RayM(2).owner = 0: RayM(3).owner = 0
                    MenuAnim.extra = (MenuAnim.extra / 1.05) - 0.5
                    CanChangeMenu = 1
                End If
            End If
        End If
    End If

End If
_SetAlpha 255, _RGBA32(1, 1, 1, 1) To _RGB32(255, 255, 255, 255), MenuTransitionImage
Return

ScreenAdjustForSize:
If ResizeDelay2 = 0 Then
    Cls
    Screen SecondScreen
    _FreeImage MainScreen
    sizexx = _ResizeWidth
    sizeyy = _ResizeHeight
    If sizexx < 128 Then sizexx = 128
    If sizeyy < 128 Then sizeyy = 128
    MainScreen = _NewImage(sizexx, sizeyy, 32)
    Screen MainScreen
    For i = 1 To lasti
        GoSub redosize
        GoSub redotexts
    Next
    ResizeDelay2 = 5
End If
Return

MenuButtonStyle:
If Menu(i).style = 1 Then
    LastToUse = i
    Menu(i).d_hover = 50
    Menu(i).d_clicked = 1
End If
If Menu(i).style = 2 Then
    LastToUse = i
    Menu(i).d_hover = 50
    Menu(i).extra3 = ((Mouse.x - Menu(i).x1) * 100) / (Menu(i).x2 - Menu(i).x1)
    If Mouse.x < Menu(i).x1 Then Menu(i).extra3 = 0
    If Mouse.x > Menu(i).x2 Then Menu(i).extra3 = 100
    Menu(i).visual = CalculatePercentage((Menu(i).x2 - Menu(i).x1), Menu(i).extra3)
    Menu(i).extra3 = Menu(i).extra3 * (Menu(i).extra2 / 100)
    Menu(i).text = RTrim$(LTrim$(Str$(Menu(i).extra3)))
    GoSub redotexts
End If
If Menu(i).style = 3 Then
    Menu(i).d_clicked = 2
    CantClickAnymoreOnHud = 1
End If
Return

InputStyleKeyGet:
key$ = InKey$
keyhit = _KeyHit
If keyhit = 8 Then
    key$ = ""
    If Len(Menu(i).text) > 0 Then Menu(i).text = Mid$(Menu(i).text, 0, Len(Menu(i).text))
    _Dest MainScreen
    GoSub redotexts
End If
If keyhit = 13 Then
    key$ = ""
    CantClickAnymoreOnHud = 0: Menu(i).d_clicked = 0: key$ = ""
    Menu(i).text = LTrim$(RTrim$(Menu(i).text))
End If
If key$ <> "" And Len(Menu(i).text) < Menu(i).extra2 Then
    Menu(i).text = Menu(i).text + key$
    GoSub redotexts
End If
If key$ <> "" And Len(Menu(i).text) >= Menu(i).extra2 Then
    _NotifyPopup "Begs World", ("Text Limit for this box is " + LTrim$(RTrim$(Str$(Menu(i).extra2)))) + ".", "info"
End If
_Dest MainScreen
Return


PostRenderMenuWhatClicked:
Select Case Loaded$
    Case "mapselector": GoSub MapSelect
End Select
Return


MapSelect:
For i = 1 To MapsFound



Next
Return

LoadAllMaps:
Dim findfile As String: findfile = _Files$("assets/Vantiro-1.1v07b/maps/*.map")
i = 0
ImagesFound = 0
Do While Len(findfile) > 0
    i = i + 1

    ReDim _Preserve MapLoader(i) As MapLoader
    Print findfile
    ImageAlternative$ = _Trim$(Mid$(findfile, 0, InStr(0, findfile, ".")) + ".png")
    MapLoader(i).FileName = Mid$(findfile, 0, InStr(0, findfile, "."))


    If _FileExists("assets/Vantiro-1.1v07b/maps/" + ImageAlternative$) Then
        Print findfile + " Has an icon!"
        MapLoader(i).HasImage = 1
        ImagesFound = ImagesFound + 1
        MapsFound = MapsFound + 1
        ReDim _Preserve MapLoaderImage(ImagesFound)
        ' MapLoaderImage(ImagesFound) = loadimage("assets/Vantiro-1.1v07b/maps/" + ImageAlternative$)
        _PutImage (512, 128), MapLoaderImage(i)

    Else
        Print findfile + " Doesn't have an icon."
        MapLoader(i).HasImage = 0
    End If
    findfile = _Files$
Loop

Return




PreRenderMenuWhatClicked:
webpage$ = "https://www.qb64phoenix.com/"
Select Case Loaded$
    Case "menu": GoSub Menu
    Case "choosedificulty": GoSub Difficulty
End Select
For i = 1 To lasti
    Menu(i).d_clicked = 0
Next
Return



Menu:
_PutImage (0, 0)-(_Width, _Height), Background1
menx = ((Menu(1).x2 + Menu(1).x1) / 2) + Menu(1).OffsetX
meny = ((Menu(1).y2 + Menu(1).y1) / 2) + Menu(1).OffsetY
_PutImage (menx - _Width(VantiroTitulo) / 2, meny - _Height(VantiroTitulo) / 2)-(menx + _Width(VantiroTitulo) / 2, meny + _Height(VantiroTitulo) / 2), VantiroTitulo
menx = ((Menu(4).x2 + Menu(4).x1) / 2) + Menu(4).OffsetX
meny = ((Menu(4).y2 + Menu(4).y1) / 2) + Menu(4).OffsetY
SkinRot = SkinRot / 1.005
SkinRot = SkinRot + RotateSkinSpeed
RotateSkinSpeed = RotateSkinSpeed / 1.05

RotoZoom menx, meny, PlayerSprite(PlayerSkin), 0.7, SkinRot
If Menu(5).d_clicked = 1 Then
    Beep
    System
End If
If Menu(3).d_clicked = 1 Then
    'GoSub LoadAllMaps
    quit = 1
End If
If Menu(4).d_clicked = 1 And delay = 0 Then
    delay = 10
    RotateSkinSpeed = Int(Rnd * 100) - 50
    _SndPlay PlayerDamage
End If
If Menu(6).d_clicked = 1 And delay = 0 Then
    delay = 20
    PlayerSkin = PlayerSkin - 1
    If PlayerSkin < 1 Then PlayerSkin = 1
    Menu(7).text = ("(" + Str$(PlayerSkin) + "/4)")
    i = 7
    GoSub redotexts
End If

If Menu(8).d_clicked = 1 And delay = 0 Then
    delay = 20
    PlayerSkin = PlayerSkin + 1
    If PlayerSkin > 4 Then PlayerSkin = 4
    Menu(7).text = ("(" + Str$(PlayerSkin) + "/4)")
    i = 7
    GoSub redotexts
End If
Return

Difficulty:
If Menu(2).d_clicked = 1 Then
    GameDificulty = 0.5
    quit = 6
End If

If Menu(3).d_clicked = 1 Then
    GameDificulty = 1
    quit = 6
End If

If Menu(4).d_clicked = 1 Then
    GameDificulty = 2
    quit = 6
End If
Return

RedoSlider:
Menu(i).visual = (Menu(i).extra3 * 100) / (Menu(i).x2 - Menu(i).x1)
Menu(i).text = RTrim$(LTrim$(Str$(Menu(i).extra3)))
GoSub redotexts
Return

WarningWebsite:
If Menu(5).d_clicked = 1 Then ToLoad$ = ToLoad2$: GoSub load
If Menu(6).d_clicked = 1 Then Shell _Hide _DontWait webpage$: ToLoad$ = ToLoad2$: GoSub load
Return
PlayerSettings:
If Menu(17).d_clicked Then
    username$ = Menu(4).text
    Open "assets/begs world/settings/PlayerSettings.bhconfig" For Output As #1
    Print #1, Menu(4).text
    Close #1
End If
Return


load:
If ToLoad$ = "Back$" Then ToLoad$ = ToLoad2$
_Dest MainScreen
If Not _FileExists("assets/Vantiro-1.1v07b/menu/" + RTrim$(LTrim$(ToLoad$)) + ".bhmenu") Then
    Beep
    FileMissing$ = ToLoad$
    FileMissingtype$ = "Menu file"
    ToLoad$ = "warningfilemissing"
End If
Open ("assets/Vantiro-1.1v07b/menu/" + RTrim$(LTrim$(ToLoad$)) + ".bhmenu") For Input As #1
Input #1, lasti
For i = 1 To lasti
    Input #1, i, Menu(i).x1d, Menu(i).y1d, Menu(i).x2d, Menu(i).y2d, Menu(i).Colors, Menu(i).text, Menu(i).textsize, Menu(i).style, Menu(i).clicktogo, Menu(i).extra, Menu(i).extra2
    GoSub redosize
    Menu(i).textsize = Menu(i).y2 - Menu(i).y1
    Menu(i).red = _Red32(Menu(i).Colors)
    Menu(i).green = _Green32(Menu(i).Colors)
    Menu(i).blue = _Blue32(Menu(i).Colors)
    Menu(i).OffsetX = 0
    Menu(i).OffsetY = 0
    GoSub LoadingExtraSignatures
    If Not Menu(i).text = "W Bh" Then GoSub redotexts
Next
Close #1
delay = 60
ToLoad2$ = Loaded$
Loaded$ = ToLoad$
Mouse.click = 0
For i = 1 To MenuMax
    Menu(i).d_clicked = 0
    Menu(i).d_hover = 0
Next

Return
LoadingExtraSignatures:
If Menu(i).text = "webpage$" Then Menu(i).text = webpage$
If Menu(i).text = "$username$" Then Menu(i).text = username$
If Menu(i).text = "$WhatMissingType$" Then Menu(i).text = (FileMissingtype$ + " Not found!")
If Menu(i).text = "$WhatMissing$" Then Menu(i).text = (FileMissing$ + " Is missing!")
Return

redotexts:
If Menu(i).text = "" Then Menu(i).text = " "
If ImgToMenu <> 0 Then _FreeImage ImgToMenu
'If MenusImages(i) <> 0 Then _FreeImage MenusImages(i)
If Menu(i).textsize = -1 Then Menu(i).textsize = Menu(i).y2 - Menu(i).y1
_Font BegsFontSizes(Menu(i).textsize)
thx = _PrintWidth(Menu(i).text)
thy = _FontHeight(BegsFontSizes(Menu(i).textsize))
ImgToMenu = _NewImage(thx * 3, thy * 3, 32)
_Dest ImgToMenu
_ClearColor _RGB32(0, 0, 0): _PrintMode _KeepBackground: _Font BegsFontSizes(Menu(i).textsize - 1): Print Menu(i).text + " "
If MenusImages(i) <> 0 Then _FreeImage MenusImages(i)
MenusImages(i) = _NewImage(thx, thy, 32)
_Dest MainScreen
_PutImage (0, 0), ImgToMenu, MenusImages(i)
_Font BegsFontSizes(20)
Return

redosize:
Menu(i).x1 = Menu(i).x1d * _Width / 2
Menu(i).x2 = Menu(i).x2d * _Width / 2
Menu(i).y1 = Menu(i).y1d * _Height / 2
Menu(i).y2 = Menu(i).y2d * _Height / 2
If Menu(i).x1d < 0 Then Menu(i).x1 = Menu(i).x1 * -1
If Menu(i).x2d < 0 Then Menu(i).x2 = Menu(i).x2 * -1
If Menu(i).y1d < 0 Then Menu(i).y1 = Menu(i).y1 * -1
If Menu(i).y2d < 0 Then Menu(i).y2 = Menu(i).y2 * -1
Return
OldZombieAI:
For i = 1 To ZombieMax
    If Zombie(i).active = 1 Then
        If Zombie(i).special <> "" And Zombie(i).DistanceFromPlayer < 900 Then
            If Zombie(i).special = "Runner" Then If Zombie(i).tick > 0 Then Zombie(i).tick = Zombie(i).tick - 1
            If Zombie(i).special = "Fire" Then
                If Zombie(i).DistanceFromPlayer < 450 And Int(Rnd * 10) = 4 Then
                    FireLast = FireLast + 1: If FireLast > FireMax Then FireLast = 1
                    Fire(FireLast).visible = 40: Fire(FireLast).froozen = 800
                    Fire(FireLast).x = Zombie(i).x + (Int(Rnd * 8) - 4): Fire(FireLast).y = Zombie(i).y + (Int(Rnd * 8) - 4)
                    Fire(FireLast).txt = 1: speed = (90 + Int(Rnd * 80))
                    angle = Zombie(i).rotation + Int(Rnd * 10) - 5: Fire(FireLast).xm = Sin(angle * PIDIV180) * speed
                    Fire(FireLast).ym = -Cos(angle * PIDIV180) * speed
                End If
                If Int(Rnd * 40) = 23 Then
                    FireLast = FireLast + 1: If FireLast > FireMax Then FireLast = 1
                    Fire(FireLast).x = Zombie(i).x + (Int(Rnd * 30) - 15) * 2
                    Fire(FireLast).txt = 1
                    Fire(FireLast).y = Zombie(i).y + (Int(Rnd * 30) - 15) * 2
                    If Distance(Fire(FireLast).x, Fire(FireLast).y, Player.x, Player.y) > 80 Then
                        Fire(FireLast).xm = Int(Rnd * 100) - 50: Fire(FireLast).ym = Int(Rnd * 100) - 50
                        If Int(Rnd * 100) = 54 Then
                            Fire(FireLast).froozen = 500 + Int(Rnd * 250): Fire(FireLast).visible = 10
                        Else
                            Fire(FireLast).froozen = 70 + Int(Rnd * 120): Fire(FireLast).visible = 10
                        End If
                    End If
                End If
            End If
            If Zombie(i).special = "Bomber" Then
                If Zombie(i).DistanceFromPlayer < 500 And Zombie(i).DistanceFromPlayer > 6 Then
                    Zombie(i).SpecialDelay = Zombie(i).SpecialDelay + 1
                    If Zombie(i).SpecialDelay < 120 Then
                        Zombie(i).size = Zombie(i).size * 1.001: If Zombie(i).sizeFirst + 20 < Zombie(i).size Then Zombie(i).size = Zombie(i).sizeFirst + 20
                    End If
                    If Zombie(i).SpecialDelay > 120 Then
                        Zombie(i).size = Zombie(i).size * 1.05: If Zombie(i).size > 120 Then Zombie(i).size = 120
                        Zombie(i).health = (Zombie(i).health / 1.1) - 0.1
                    End If
                Else
                    If Zombie(i).SpecialDelay > 0 Then Zombie(i).SpecialDelay = Zombie(i).SpecialDelay - 1
                    dif = Zombie(i).sizeFirst - Zombie(i).size
                    Zombie(i).size = Zombie(i).size + (dif / 10)
                    dif = Zombie(i).Healthfirst - Zombie(i).health
                    Zombie(i).health = Zombie(i).health + (dif / 10)
                End If
            End If
        End If
        'Burn
        If Zombie(i).special <> "Fire" Then
            If Zombie(i).onfire > 0 Then
                Zombie(i).onfire = Zombie(i).onfire - 1
                If Int(Rnd * 6) = 2 Then
                    Zombie(i).health = Zombie(i).health - 2
                    FireLast = FireLast + 1: If FireLast > FireMax Then FireLast = 1
                    Fire(FireLast).visible = 6
                    Fire(FireLast).froozen = 20
                    Fire(FireLast).txt = 0
                    Fire(FireLast).x = Zombie(i).x + (Int(Rnd * 30) - 15) * 2
                    Fire(FireLast).y = Zombie(i).y + (Int(Rnd * 30) - 15) * 2
                    Fire(FireLast).xm = (Zombie(i).xm / 10) + (Int(Rnd * 30) - 15) * 2
                    Fire(FireLast).ym = (Zombie(i).ym / 10) + (Int(Rnd * 30) - 15) * 2
                End If
            End If
        End If

        If Zombie(i).DamageTaken > 0 Then
            For S = 1 To Int(Zombie(i).DamageTaken / 4)
                SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, Steps, "green"
            Next
            Zombie(i).health = Zombie(i).health - Zombie(i).DamageTaken: Zombie(i).DamageTaken = 0
        End If

        If Zombie(i).tick > 0 Then Zombie(i).tick = Zombie(i).tick - 1
        Zombie(i).x = Zombie(i).x + Zombie(i).xm / 100: Zombie(i).y = Zombie(i).y + Zombie(i).ym / 100
        Zombie(i).x1 = Zombie(i).x - Zombie(i).size: Zombie(i).x2 = Zombie(i).x + Zombie(i).size: Zombie(i).y1 = Zombie(i).y - Zombie(i).size: Zombie(i).y2 = Zombie(i).y + Zombie(i).size

        Zombie(i).xm = Zombie(i).xm + Fix(Sin(Zombie(i).rotation * PIDIV180) * Zombie(i).speeding)
        Zombie(i).ym = Zombie(i).ym + Fix(-Cos(Zombie(i).rotation * PIDIV180) * Zombie(i).speeding)
        If Zombie(i).xm > Zombie(i).maxspeed Then Zombie(i).xm = Zombie(i).maxspeed
        If Zombie(i).ym > Zombie(i).maxspeed Then Zombie(i).ym = Zombie(i).maxspeed
        If Zombie(i).xm < -Zombie(i).maxspeed Then Zombie(i).xm = -Zombie(i).maxspeed
        If Zombie(i).ym < -Zombie(i).maxspeed Then Zombie(i).ym = -Zombie(i).maxspeed
        Zombie(i).xm = Zombie(i).xm / (1.010 + (Zombie(i).speeding / 2000))
        Zombie(i).ym = Zombie(i).ym / (1.010 + (Zombie(i).speeding / 2000))
        If CollisionWithWallsEntity(Zombie(i)) Then
        End If
        If Zombie(i).tick = 0 Then
            If Int(Rnd * 60) = 27 And Zombie(i).DistanceFromPlayer < 400 Then _SndPlayCopy ZombieWalk(Int(Rnd * 4) + 1), 0.08

            o = 1: Do
                o = o + 1
                If i <> o And Zombie(o).active = 1 Then
                    dist = Distance(Zombie(i).x, Zombie(i).y, Zombie(o).x, Zombie(o).y)
                    If dist < Zombie(i).size Then
                        dx = Zombie(i).x - Zombie(o).x: dy = Zombie(i).y - Zombie(o).y
                        RotDist = ATan2(dy, dx) ' Angle in radians
                        RotDist = (RotDist * 180 / PI) + 90
                        If RotDist > 180 Then RotDist = RotDist - 179.9
                        Zombie(i).xm = Zombie(i).xm - Fix(Sin(RotDist * PIDIV180) * 200)
                        Zombie(i).ym = Zombie(i).ym - Fix(-Cos(RotDist * PIDIV180) * 200)

                    End If
                End If

            Loop While o <> ZombieMax

            Zombie(i).tick = DefZombie.tickrate + (Int(Rnd * 20) - 10)
            ZombieAIChasePoint Zombie(i)
            '  dx = Zombie(i).x - Player.x: dy = Zombie(i).y - Player.y
            '  Zombie(i).rotation = ATan2(dy, dx) ' Angle in radians
            '  Zombie(i).rotation = (Zombie(i).rotation * 180 / PI) + 90 + (-20 + Int(Rnd * 40))
            '  If Zombie(i).rotation > 180 Then Zombie(i).rotation = Zombie(i).rotation - 179.9
            Zombie(i).DistanceFromPlayer = Int(Distance(Zombie(i).x, Zombie(i).y, Player.x, Player.y))
            If Zombie(i).DistanceFromPlayer < (Zombie(i).size * 1.8) Then
                If Zombie(i).attacking = 0 Then Zombie(i).attacking = Int(Zombie(i).knockback / 3)
                If Zombie(i).attacking = Int(Zombie(i).knockback / 3) Then
                    Zombie(i).xm = Zombie(i).xm / 15
                    Zombie(i).ym = Zombie(i).ym / 15
                    Player.DamageToTake = Int(Rnd * (DefZombie.maxdamage - DefZombie.mindamage + 1)) + DefZombie.mindamage
                    PlayerTakeDamage Player, Zombie(i).x, Zombie(i).y, Player.DamageToTake, Zombie(i).knockback
                    Player.DamageToTake = 0
                End If
            End If
            If Zombie(i).attacking > 0 Then Zombie(i).attacking = Zombie(i).attacking - 1
        End If
        If Zombie(i).health <= 0 Then
            Zombie(i).SpecialDelay = 0 '     ------------------- Ammo Dropping --------------------
            If Zombie(i).special = "Fire" Then SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 5, "GasAmmo"
            If Zombie(i).special = "Bomber" Then SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 5, "GrenadeAmmo"
            If Int(Rnd * 2) + 1 = 2 Then
                If Zombie(i).special = "Normal" Then
                    Rand = Int(Rnd * 2) + 1
                    If Rand = 1 Then
                        SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 5, "ShotgunAmmo"
                    Else
                        For y = 1 To Int(Rnd * 2) + 1
                            SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 5, "PistolAmmo"
                        Next
                    End If
                End If

            End If
            If Zombie(i).special = "Brute" Then
                Rand = Int(Rnd * 4)
                For B = 1 To Rand
                    SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 7, "ShotgunAmmo"
                    SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 7, "PistolAmmo"
                    If Int(Rnd * 4) = 2 Then SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 5, "GrenadeAmmo"
                Next
            End If
            If Zombie(i).special = "Bomber" Then
                Explosion Zombie(i).x, Zombie(i).y, 80, 320: _SndPlay SND_Explosion
                For B = 1 To 50
                    SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, Int(Rnd * 70), "green"
                Next
            End If
            If Zombie(i).health <= -30 Then SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 5, "GibSkull"
            Zombie(i).active = 0
            Zombie(i).onfire = 0
            WaveBudget = WaveBudget - 1
            For o = 1 To 10
                SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, Steps, "green"
                If Zombie(i).health <= -30 And Int(Rnd * 3) = 2 Then SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 5, "GibBone"
                If Zombie(i).health >= -30 And Int(Rnd * 8) = 2 Then SpawnBloodParticle Zombie(i).x, Zombie(i).y, Int(Rnd * 360) - 180, 5, "GibBone"
            Next
        End If
        If Zombie(i).x < 0 Or Zombie(i).y < 0 Then
            Zombie(i).x = 100: Zombie(i).y = 100: Zombie(i).ym = 0: Zombie(i).xm = 0
            Zombie(i).health = 0

            Beep: Print "Zombie(" + Str$(i) + ") Out of bounds!!!!!!!!!!!!!!!!"
            _Display
            Beep: Beep
            _Delay 0.6
        End If
    End If

Next
Print "Using Old Zombie AI!"
Return

Sub GunCode
    GunSin = Sin(GunDisplay.rotation * PIDIV180)
    GunCos = -Cos(GunDisplay.rotation * PIDIV180)

    DynamicLight(1).x = Player.x + (GunSin * 100): DynamicLight(1).y = Player.y + (GunCos * 100)
    If WeaponHeat > 0 Then WeaponHeat = WeaponHeat - 1
    If WeaponHeat > 45 Then WeaponHeat = 45
    LoadFromWeaponSlot
    For i = 1 To 1
        o = -1
        If GunDisplay.visible = 1 Then
            o = o + 1
            GunDisplay.x = ((PlayerMember(i + o).x + PlayerMember(i * 2).x) / 2) 'Player.x + (Sin(Player.Rotation * PIDIV180) * 38)
            GunDisplay.y = ((PlayerMember(i + o).y + PlayerMember(i * 2).y) / 2) 'Player.y + (-Cos(Player.Rotation * PIDIV180) * 38)
            GunDisplay.x = GunDisplay.x + GunDisplay.xm
            GunDisplay.y = GunDisplay.y + GunDisplay.ym
            GunDisplay.xm = Int(GunDisplay.xm / 2)
            GunDisplay.ym = Int(GunDisplay.ym / 2)
            If Player.shooting = 0 Then
                FlameSoundPlaying = 0
            End If
            _SndStop FlameThrowerSound
            ShootingCode

            If Player.shooting = 1 Then
                CreateDynamicLight GunDisplay.x + GunSin * 80, GunDisplay.y + GunCos * 80, 250, 4, "High", "Spot", GunDisplay.rotation, 90
                GunDisplay.xm = -Int(GunSin * (GunForce / 4))
                GunDisplay.ym = -Int(GunCos * (GunForce / 4))
                Player.xm = Player.xm + Fix(GunSin * (GunForce))
                Player.ym = Player.ym + Fix(GunCos * (GunForce))

                For H = 1 To 2
                    PlayerMember(H).x = PlayerMember(H).x - (Sin(((GunDisplay.rotation + (Rnd * 40) - 20)) * PIDIV180) * (GunForce / 1.5))
                    PlayerMember(H).y = PlayerMember(H).y - (-Cos(((GunDisplay.rotation + (Rnd * 40) - 20)) * PIDIV180) * (GunForce / 1.5))
                Next
                If Aiming = 0 Then
                    CameraXM = CameraXM + -Int(GunSin * GunForce): CameraYM = CameraYM + -Int(GunCos * GunForce)
                Else
                    CameraXM = CameraXM + -Int(GunSin * (GunForce / 2)): CameraYM = CameraYM + -Int(GunCos * (GunForce / 2))
                End If
                For i = 1 To HudWeaponMax
                    dist = Abs(i - SelectedHudID) + 1
                    Hud(i).xm = Hud(i).xm - Int(GunSin * GunForce) / (dist / 1.15)
                    Hud(i).ym = Hud(i).ym - Int(GunCos * GunForce) / (dist / 1.15)
                Next
            End If

            dx = Player.x - GunDisplay.x: dy = Player.y - GunDisplay.y
            GunDisplay.rotation = ATan2(dy, dx) ' Angle in radians
            GunDisplay.rotation = (GunDisplay.rotation * 180 / PI) + 90
            If GunDisplay.rotation > 180 Then GunDisplay.rotation = GunDisplay.rotation - 180
            'GunDisplay.rotation = Player.Rotation + 90
            If Debug = 1 Then Line (ETSX(GunDisplay.x - 16), ETSY(GunDisplay.y - 16))-(ETSX(GunDisplay.x + 16), ETSY(GunDisplay.y + 16)), _RGBA32(255, 255, 255, 75), BF
            RenderDisplayGun
        End If
    Next
    If raycastingsimple(GunDisplay.x, GunDisplay.y, GunDisplay.rotation, 256) Then
    End If
    Line (ETSX(GunDisplay.x), ETSY(GunDisplay.y))-(ETSX(Ray.x), ETSY(Ray.y)), _RGB32(255, 0, 0)
    Line (ETSX(Ray.x) - 2, ETSY(Ray.y) - 2)-(ETSX(Ray.x) + 2, ETSY(Ray.y) + 2), _RGBA32(255, 0, 0, 128), BF
End Sub

Sub ShootingCode
    If (Mouse.click Or gamepadstate.Gamepad.bRightTrigger > 0) And ShootDelay = 0 And PlayerCantMove = 0 Then
        Player.shooting = 1
        If GunDisplay.wtype = 1 And SMGAmmo = 0 Then
            Player.shooting = 0

        End If
        If GunDisplay.wtype = 2 And ShotgunAmmo = 0 Then
            Player.shooting = 0

        End If
        If GunDisplay.wtype = 3 And SMGAmmo = 0 Then
            Player.shooting = 0

        End If
        If GunDisplay.wtype = 4 And GrenadeAmmo = 0 Then
            Player.shooting = 0

        End If
        If GunDisplay.wtype = 5 And FlameAmmo = 0 Then
            Player.shooting = 0
            _SndStop FlameThrowerSound
        End If


        If GunDisplay.wtype = 1 Then
            _SndPlayCopy Guns_Sound_PistolShot, 0.3: If raycasting(GunDisplay.x, GunDisplay.y, GunDisplay.rotation + (Int(Rnd * 3) - 1), 14, 1, 2000, 6) Then Beep
            StartVibrate Int(65535 / 2)
            vib = 1
            Line (ETSX(GunDisplay.x), ETSY(GunDisplay.y))-(ETSX(Ray.x), ETSY(Ray.y)), _RGB32(255, 0, 0)
            ShootDelay = 14: GunForce = 6
            Part(LastPart).x = GunDisplay.x: Part(LastPart).y = GunDisplay.y: Part(LastPart).z = 2 + Int(Rnd * 2)
            Part(LastPart).xm = Int(Rnd * 80) - 40
            Part(LastPart).ym = Int(Rnd * 80) - 40
            Part(LastPart).zm = 2 + Int(Rnd * 4)
            Part(LastPart).froozen = 12: Part(LastPart).visible = 800
            Part(LastPart).partid = "PistolShell": Part(LastPart).playwhatsound = "PistolShell"
            Part(LastPart).rotation = Int(Rnd * 360) - 180
            Part(LastPart).rotationspeed = Int(Rnd * 60) - 30
            LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0
        End If

        If GunDisplay.wtype = 2 And ShotgunAmmo > 0 Then
            _SndPlayCopy Guns_Sound_ShotgunShot, 0.3: GunForce = 40
            StartVibrate 65535
            vib = 1
            ShotgunAmmo = ShotgunAmmo - 1
            For S = 1 To 5
                If raycasting(GunDisplay.x, GunDisplay.y, GunDisplay.rotation - (Int(Rnd * 20) - 10), 10, 1, 2000, 5) Then Beep
                Line (ETSX(GunDisplay.x), ETSY(GunDisplay.y))-(ETSX(Ray.x), ETSY(Ray.y)), _RGB32(255, 0, 0)
            Next
            ShootDelay = 50
            Part(LastPart).x = GunDisplay.x: Part(LastPart).y = GunDisplay.y: Part(LastPart).z = 3 + Int(Rnd * 2)
            Part(LastPart).xm = Int(Rnd * 120) - 60: Part(LastPart).ym = Int(Rnd * 120) - 60: Part(LastPart).zm = 2 + Int(Rnd * 4)
            Part(LastPart).froozen = 12: Part(LastPart).visible = 800
            Part(LastPart).partid = "ShotgunShell": Part(LastPart).playwhatsound = "ShotgunShell"
            Part(LastPart).rotation = Int(Rnd * 360) - 180
            Part(LastPart).rotationspeed = Int(Rnd * 60) - 30
            LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0
        End If

        If GunDisplay.wtype = 3 And SMGAmmo > 0 Then
            _SndPlayCopy SMGSounds(1 + Int(Rnd * 3)), 0.125
            StartVibrate Int(65535 / 4)
            vib = 1
            SMGAmmo = SMGAmmo - 1: GunForce = 10
            WeaponHeat = WeaponHeat + 4
            If raycasting(GunDisplay.x, GunDisplay.y, GunDisplay.rotation + ((Int(Rnd * Int(WeaponHeat / 2)) - Int(WeaponHeat / 4)) + Int(Rnd * 10) - 5), 6 + Int(Rnd * 6), 1, 2000, 9) Then Beep

            Line (ETSX(GunDisplay.x), ETSY(GunDisplay.y))-(ETSX(Ray.x), ETSY(Ray.y)), _RGB32(255, 0, 0): ShootDelay = 6
            Part(LastPart).x = GunDisplay.x: Part(LastPart).y = GunDisplay.y: Part(LastPart).z = 2 + Int(Rnd * 2)
            Part(LastPart).xm = Int(Rnd * 120) - 60: Part(LastPart).ym = Int(Rnd * 120) - 60: Part(LastPart).zm = 1 + Int(Rnd * 5)
            Part(LastPart).froozen = 12: Part(LastPart).visible = 800
            Part(LastPart).partid = "PistolShell": Part(LastPart).playwhatsound = "PistolShell"
            Part(LastPart).rotation = Int(Rnd * 360) - 180
            Part(LastPart).rotationspeed = Int(Rnd * 60) - 30
            LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0
        End If


        If GunDisplay.wtype = 4 And GrenadeAmmo > 0 Then
            GrenadeAmmo = GrenadeAmmo - 1
            ShootDelay = 30
            GunForce = -35
            'LastGrenade = LastGrenade + 1
            LastGrenade = LastGrenade + 1: If LastGrenade > GrenadeMax Then LastGrenade = 1
            Grenade(LastGrenade).x = GunDisplay.x
            Grenade(LastGrenade).y = GunDisplay.y
            Grenade(LastGrenade).z = 15
            Force = Distance(Mouse.x, Mouse.y, _Width / 2, _Height / 2) / 3: If Force > 200 Then Force = 200
            Grenade(LastGrenade).xm = Sin(GunDisplay.rotation * PIDIV180) * Force
            Grenade(LastGrenade).ym = -Cos(GunDisplay.rotation * PIDIV180) * Force
            Grenade(LastGrenade).zm = 15 + Int(Rnd * 20)
            Grenade(LastGrenade).rotation = -5 + Int(Rnd * 10)
            Grenade(LastGrenade).rotationspeed = -30 + Int(Rnd * 15)
            Grenade(LastGrenade).visible = 1
            Grenade(LastGrenade).froozen = -160
        End If

        If GunDisplay.wtype = 5 And FlameAmmo > 0 Then
            If FlameSoundPlaying = 0 Then _SndVol FlameThrowerSound, 0.09: _SndLoop FlameThrowerSound
            StartVibrate Int(65535 / 4)
            vib = 1
            FlameSoundPlaying = 1
            FlameAmmo = FlameAmmo - 1
            ShootDelay = 2
            GunForce = 3
            FireLast = FireLast + 1: If FireLast > FireMax Then FireLast = 1
            Fire(FireLast).visible = 2
            Fire(FireLast).froozen = 50
            Fire(FireLast).txt = 0
            Fire(FireLast).x = GunDisplay.x + (Int(Rnd * 8) - 4)
            Fire(FireLast).y = GunDisplay.y + (Int(Rnd * 8) - 4)

            speed = (60 + Int(Rnd * 50))
            angle = GunDisplay.rotation + Int(Rnd * 40) - 20
            Fire(FireLast).xm = Sin(angle * PIDIV180) * speed
            Fire(FireLast).ym = -Cos(angle * PIDIV180) * speed
        End If

        If GunDisplay.wtype = 6 Then
            StartVibrate Int(65535 / 4)
            GunForce = 1.2
        End If

        If GunDisplay.wtype = 7 Then
            StartVibrate Int(65535 / 4)
            GunForce = 2
            ShootDelay = 8
            If raycasting(GunDisplay.x, GunDisplay.y, GunDisplay.rotation, 23, 1, 40, 0) Then Beep
            Line (Ray.x - 3, Ray.y - 3)-(Ray.x + 3, Ray.y + 3), _RGB32(255, 128, 255), BF


        End If




    End If
End Sub

Sub LoadFromWeaponSlot
    If SelectedHudID = 1 Then
        GunDisplay.wtype = 1
        PlayerMember(1).angleanim = -36: PlayerMember(1).distanim = 40
        PlayerMember(2).angleanim = 36: PlayerMember(2).distanim = 40

    End If

    If SelectedHudID = 2 Then
        GunDisplay.wtype = 2
        PlayerMember(1).angleanim = -29: PlayerMember(1).distanim = 67
        PlayerMember(2).angleanim = 50: PlayerMember(2).distanim = 42
    End If
    If SelectedHudID = 3 Then
        GunDisplay.wtype = 3
        PlayerMember(1).angleanim = -29: PlayerMember(1).distanim = 67
        PlayerMember(2).angleanim = 50: PlayerMember(2).distanim = 42
    End If

    If SelectedHudID = 4 Then
        GunDisplay.wtype = 4
        PlayerMember(1).angleanim = -29: PlayerMember(1).distanim = 67
        PlayerMember(2).angleanim = 50: PlayerMember(2).distanim = 42
    End If

    If SelectedHudID = 5 Then
        GunDisplay.wtype = 5
        PlayerMember(1).angleanim = -29: PlayerMember(1).distanim = 67
        PlayerMember(2).angleanim = 50: PlayerMember(2).distanim = 42
    End If

    If SelectedHudID = 6 Then
        GunDisplay.wtype = 6
        PlayerMember(1).angleanim = -29: PlayerMember(1).distanim = 67
        PlayerMember(2).angleanim = 50: PlayerMember(2).distanim = 42
    End If

    If SelectedHudID = 7 Then
        GunDisplay.wtype = 7
        PlayerMember(1).angleanim = -29: PlayerMember(1).distanim = 67
        PlayerMember(2).angleanim = 50: PlayerMember(2).distanim = 42
    End If

End Sub


Sub HandsCode
    ArmLeftOrigin = Player.Rotation + 90
    ArmRightOrigin = Player.Rotation - 90
    PlayerMember(1).xo = Sin(ArmLeftOrigin * PIDIV180)
    PlayerMember(1).yo = -Cos(ArmLeftOrigin * PIDIV180)
    PlayerMember(2).xo = Sin(ArmRightOrigin * PIDIV180)
    PlayerMember(2).yo = -Cos(ArmRightOrigin * PIDIV180)
    xo1 = Player.x + PlayerMember(1).xo * 32
    yo1 = Player.y + PlayerMember(1).yo * 32
    xo2 = Player.x + PlayerMember(2).xo * 32
    yo2 = Player.y + PlayerMember(2).yo * 32
    PlayerMember(1).xo = Player.x + PlayerMember(1).xo * 32
    PlayerMember(1).yo = Player.y + PlayerMember(1).yo * 32
    PlayerMember(2).xo = Player.x + PlayerMember(2).xo * 32
    PlayerMember(2).yo = Player.y + PlayerMember(2).yo * 32
    RotationDifference = Abs(Player.Rotation - PlayerRotOld)
    If RotationDifference > 90 Then RotationDifference = 180 - RotationDifference
    For i = 1 To 2
        Angleadded = PlayerMember(i).angleanim + Player.Rotation
        PlayerMember(i).xbe = PlayerMember(i).xo + Sin((Angleadded) * PIDIV180) * PlayerMember(i).distanim
        PlayerMember(i).ybe = PlayerMember(i).yo + -Cos((Angleadded) * PIDIV180) * PlayerMember(i).distanim
        dx = (PlayerMember(i).x - PlayerMember(i).xbe): dy = (PlayerMember(i).y - PlayerMember(i).ybe)
        PlayerMember(i).angle = ATan2(dy, dx) ' Angle in radians
        PlayerMember(i).angle = (PlayerMember(i).angle * 180 / PI) + 90
        If PlayerMember(i).angle >= 180 Then PlayerMember(i).angle = PlayerMember(i).angle - 179.9
        PlayerMember(i).xvector = Sin(PlayerMember(i).angle * PIDIV180)
        PlayerMember(i).yvector = -Cos(PlayerMember(i).angle * PIDIV180)
        PlayerMember(i).speed = Distance(PlayerMember(i).x, PlayerMember(i).y, PlayerMember(i).xbe, PlayerMember(i).ybe) / 9
        PlayerMember(i).x = PlayerMember(i).x - (Player.xm / 10)
        PlayerMember(i).y = PlayerMember(i).y - (Player.ym / 10)
        PlayerMember(i).x = PlayerMember(i).x + PlayerMember(i).xvector * PlayerMember(i).speed
        PlayerMember(i).y = PlayerMember(i).y + PlayerMember(i).yvector * PlayerMember(i).speed
        If Distance(PlayerMember(i).x, PlayerMember(i).y, PlayerMember(i).xbe, PlayerMember(i).ybe) > 200 Then PlayerMember(i).x = Player.x: PlayerMember(i).y = Player.y
    Next
End Sub


Sub PlayerMovement
    Dim dx As Double
    Dim dy As Double
    If Mouse.click2 Or gamepadstate.Gamepad.bLeftTrigger > 0 Then
        Aiming = 1
        If Fix(AimingTime) = 0 Then AimingTime = 15
        AimingTime = AimingTime * 1.1
        If AimingTime > 600 Then AimingTime = 600
        CameraXM = CameraXM + (Sin(GunDisplay.rotation * PIDIV180) * (10 + (AimingTime / 20)))
        CameraYM = CameraYM + (-Cos(GunDisplay.rotation * PIDIV180) * (10 + (AimingTime / 20)))
        Player.xm = Int(Player.xm / 1.1)
        Player.ym = Int(Player.ym / 1.1)
    Else
        AimingTime = 0
    End If
    Player.xb = Player.x
    Player.yb = Player.y
    PlayerRotOld = Player.Rotation
    dx = ETSX(Player.x) - Mouse.x
    dy = ETSY(Player.y) - Mouse.y
    Player.Rotation = ATan2(dy, dx) ' Angle in radians
    Player.Rotation = (Player.Rotation * 180 / PI) + 90
    If PlayerIsOnFire > 0 Then
        PlayerIsOnFire = PlayerIsOnFire - 1
        If Int(Rnd * 6) = 2 Then
            Player.Health = Player.Health - 0.25
            If DayAmount < 50 Then Player.Health = Player.Health - 0.5
            FireLast = FireLast + 1: If FireLast > FireMax Then FireLast = 1
            Fire(FireLast).visible = 2
            Fire(FireLast).froozen = 14
            Fire(FireLast).x = Player.x + (Int(Rnd * 30) - 15) * 2
            Fire(FireLast).y = Player.y + (Int(Rnd * 30) - 15) * 2
            Fire(FireLast).txt = 4
            Fire(FireLast).xm = (-Player.xm) + (Int(Rnd * 30) - 15) * 2
            Fire(FireLast).ym = (-Player.ym) + (Int(Rnd * 30) - 15) * 2
        End If
    End If
    If Player.Rotation > 180 Then Player.Rotation = Player.Rotation - 180
    If Int(Player.Rotation) > -7 And Int(Player.Rotation) < 1 And Mouse.y > _Height / 2 Then Player.Rotation = 180
    'If Int(Player.Rotation) = -2 And Mouse.y > _Height / 2 Then Player.Rotation = 180
    If Player.TouchX = 0 Then
        If st = ERROR_SUCCESS Then
            lx = gamepadstate.Gamepad.sThumbLX
            ly = gamepadstate.Gamepad.sThumbLY
            magnitude = Sqr(Abs(lx * lx + ly * ly))
            If magnitude > 7850 Then
                If lx > 0 Then Player.xm = Player.xm - Config.Player_Accel: hadmovex = 1
                If lx < 0 Then Player.xm = Player.xm + Config.Player_Accel: hadmovex = 1
            End If
        End If
        If _KeyDown(100) Then Player.xm = Player.xm - Config.Player_Accel: hadmovex = 1
        If _KeyDown(97) Then Player.xm = Player.xm + Config.Player_Accel: hadmovex = 1
    End If
    If Player.TouchY = 0 Then
        If st = ERROR_SUCCESS Then
            lx = gamepadstate.Gamepad.sThumbLX
            ly = gamepadstate.Gamepad.sThumbLY
            magnitude = Sqr(Abs(lx * lx + ly * ly))
            If magnitude > 7850 Then
                If ly > 0 Then Player.ym = Player.ym + Config.Player_Accel: hadmovey = 1
                If ly < 0 Then Player.ym = Player.ym - Config.Player_Accel: hadmovey = 1
            End If
        End If
        If _KeyDown(119) Then Player.ym = Player.ym + Config.Player_Accel: hadmovey = 1
        If _KeyDown(115) Then Player.ym = Player.ym - Config.Player_Accel: hadmovey = 1
    End If
    If Player.TouchX > 0 Then Player.TouchX = Player.TouchX - 1
    If Player.TouchX < 0 Then Player.TouchX = Player.TouchX + 1
    If Player.TouchY > 0 Then Player.TouchY = Player.TouchY - 1
    If Player.TouchY < 0 Then Player.TouchY = Player.TouchY + 1

    If Player.xm < -Config.Player_MaxSpeed Then Player.xm = -Config.Player_MaxSpeed
    If Player.xm > Config.Player_MaxSpeed Then Player.xm = Config.Player_MaxSpeed
    If Player.ym < -Config.Player_MaxSpeed Then Player.ym = -Config.Player_MaxSpeed
    If Player.ym > Config.Player_MaxSpeed Then Player.ym = Config.Player_MaxSpeed
    Player.y = Player.y - Player.ym / 10: Player.x = Player.x - Player.xm / 10
    For i = 1 To 3
        If Player.xm < 0 And hadmovex = 0 Then Player.xm = Player.xm + 1
        If Player.xm > 0 And hadmovex = 0 Then Player.xm = Player.xm - 1
        If Player.ym < 0 And hadmovey = 0 Then Player.ym = Player.ym + 1
        If Player.ym > 0 And hadmovey = 0 Then Player.ym = Player.ym - 1
    Next
    hadmovex = 0
    hadmovey = 0
    If Player.y > Map.MaxHeight * Map.TileSize Then Player.y = Map.MaxHeight * Map.TileSize
    If Player.y < Map.TileSize Then Player.y = Map.TileSize
    If Player.x > Map.MaxWidth * Map.TileSize Then Player.x = Map.MaxWidth * Map.TileSize
    If Player.x < Map.TileSize Then Player.x = Map.TileSize

    MakeHitBoxPlayer Player
    If Noclip = 0 Then If CollisionWithWallsPlayer(Player) Then donebetween = 1
End Sub


Sub RenderLayers
    rendcamerax1 = Fix(Fix(CameraX * Map.TileSize) / Map.TileSize) - 1
    rendcamerax2 = Fix(Fix(CameraX * Map.TileSize) / Map.TileSize) + Int(_Width / Map.TileSize) + 1
    rendcameray1 = Fix(Fix(CameraY * Map.TileSize) / Map.TileSize)
    rendcameray2 = Fix(Fix(CameraY * Map.TileSize) / Map.TileSize) + Int(_Height / Map.TileSize) + 1
    If rendcamerax1 < 0 Then rendcamerax1 = 0
    If rendcameray1 < 0 Then rendcameray1 = 0
    If rendcamerax2 > Map.MaxWidth Then rendcamerax2 = Map.MaxWidth
    If rendcameray2 > Map.MaxHeight Then rendcameray2 = Map.MaxHeight

    For z = 1 To 2
        For x = rendcamerax1 To rendcamerax2 'Map.MaxWidth
            For y = rendcameray1 To rendcameray2 'Map.MaxHeight
                XCalc = WTS(x, CameraX)
                YCalc = WTS(y, CameraY)

                If Tile(x, y, z).ID <> 0 Then _PutImage (XCalc, YCalc)-(XCalc + (Map.TileSize), YCalc + (Map.TileSize)), Tileset, 0, (Tile(x, y, z).x1t, Tile(x, y, z).y1t)-(Tile(x, y, z).x2t, Tile(x, y, z).y2t)
            Next
        Next
    Next
End Sub

Sub RenderTopLayer
    For x = rendcamerax1 To rendcamerax2 'Map.MaxWidth
        For y = rendcameray1 To rendcameray2 'Map.MaxHeight
            z = 3
            XCalc = WTS(x - 1, CameraX)
            YCalc = WTS(y, CameraY)
            If Tile(x, y, z).ID <> 0 Then _PutImage (XCalc, YCalc)-(XCalc + Map.TileSize, YCalc + Map.TileSize), Tileset, 0, (Tile(x, y, z).rend_spritex * Map.TextureSize, Tile(x, y, z).rend_spritey * Map.TextureSize)-(Tile(x, y, z).rend_spritex * Map.TextureSize + (Map.TextureSize - 1), Tile(x, y, z).rend_spritey * Map.TextureSize + (Map.TextureSize - 1))
        Next
    Next
End Sub



Sub RenderMobs
    For i = 1 To ZombieMax
        If Zombie(i).active = 1 And Zombie(i).DistanceFromPlayer < _Width Then
            Select Case Zombie(i).special
                Case "Runner"
                    'If Debug = 1 Then Line (ETSX(Zombie(i).x1), ETSY(Zombie(i).y1))-(ETSX(Zombie(i).x2), ETSY(Zombie(i).y2)), _RGB32(255, 0, 255), BF
                    RotoZoom ETSX(Zombie(i).x), ETSY(Zombie(i).y), ZombieRunner, Zombie(i).size / 90, Zombie(i).rotation
                Case "Brute"
                    '  If Debug = 1 Then Line (ETSX(Zombie(i).x1), ETSY(Zombie(i).y1))-(ETSX(Zombie(i).x2), ETSY(Zombie(i).y2)), _RGB32(255, 0, 0), BF
                    RotoZoom ETSX(Zombie(i).x), ETSY(Zombie(i).y), ZombieBrute, Zombie(i).size / 90, Zombie(i).rotation
                Case "Slower"
                    '  If Debug = 1 Then Line (ETSX(Zombie(i).x1), ETSY(Zombie(i).y1))-(ETSX(Zombie(i).x2), ETSY(Zombie(i).y2)), _RGB32(64, 0, 64), BF
                    RotoZoom ETSX(Zombie(i).x), ETSY(Zombie(i).y), ZombieSlower, Zombie(i).size / 90, Zombie(i).rotation
                Case "Bomber"
                    ' If Debug = 1 Then Line (ETSX(Zombie(i).x1), ETSY(Zombie(i).y1))-(ETSX(Zombie(i).x2), ETSY(Zombie(i).y2)), _RGB32(128, 128, 128), BF
                    RotoZoom ETSX(Zombie(i).x), ETSY(Zombie(i).y), ZombieBomber, Zombie(i).size / 90, Zombie(i).rotation
                Case "Fire"
                    ' If Debug = 1 Then Line (ETSX(Zombie(i).x1), ETSY(Zombie(i).y1))-(ETSX(Zombie(i).x2), ETSY(Zombie(i).y2)), _RGB32(255, 128, 0), BF
                    RotoZoom ETSX(Zombie(i).x), ETSY(Zombie(i).y), ZombieFire, Zombie(i).size / 90, Zombie(i).rotation
                Case "Biohazard"
                    '  If Debug = 1 Then Line (ETSX(Zombie(i).x1), ETSY(Zombie(i).y1))-(ETSX(Zombie(i).x2), ETSY(Zombie(i).y2)), _RGB32(0, 255, 0), BF
                    RotoZoom ETSX(Zombie(i).x), ETSY(Zombie(i).y), ZombieBiohazard, Zombie(i).size / 90, Zombie(i).rotation

                Case "Normal"
                    '   If Debug = 1 Then Line (ETSX(Zombie(i).x1), ETSY(Zombie(i).y1))-(ETSX(Zombie(i).x2), ETSY(Zombie(i).y2)), _RGB32(255, 255, 128), BF
                    RotoZoom ETSX(Zombie(i).x), ETSY(Zombie(i).y), Zombie, Zombie(i).size / 90, Zombie(i).rotation
            End Select
        End If
    Next
End Sub

Sub RenderDisplayGun
    If GunDisplay.wtype = 1 Then RotoZoom ETSX(GunDisplay.x), ETSY(GunDisplay.y), Guns_Pistol, .3, GunDisplay.rotation + 90
    If GunDisplay.wtype = 2 Then RotoZoom ETSX(GunDisplay.x), ETSY(GunDisplay.y), Guns_Shotgun, .45, GunDisplay.rotation + 90
    If GunDisplay.wtype = 3 Then RotoZoom ETSX(GunDisplay.x), ETSY(GunDisplay.y), Guns_SMG, .5, GunDisplay.rotation + 90
    If GunDisplay.wtype = 4 Then RotoZoom ETSX(GunDisplay.x), ETSY(GunDisplay.y), Guns_Grenade, .6, GunDisplay.rotation + 90
    If GunDisplay.wtype = 5 Then RotoZoom ETSX(GunDisplay.x), ETSY(GunDisplay.y), Guns_Flame, .6, GunDisplay.rotation + 90
    If GunDisplay.wtype = 6 Then RotoZoom ETSX(GunDisplay.x), ETSY(GunDisplay.y), Guns_Hammer, .6, GunDisplay.rotation + 90
    If GunDisplay.wtype = 7 Then RotoZoom ETSX(GunDisplay.x), ETSY(GunDisplay.y), Guns_Chainsaw, .6, GunDisplay.rotation + 90
End Sub


Sub Explosion (x As Double, y As Double, strength As Double, Size As Double)
    StartVibrate 65535
    gr = 1
    For o = 1 To 5
        Part(LastPart).x = x
        Part(LastPart).y = y
        Part(LastPart).z = 4
        Part(LastPart).xm = Int(Rnd * 512) - 256
        Part(LastPart).ym = Int(Rnd * 512) - 256
        Part(LastPart).zm = 8 + Int(Rnd * 10)
        Part(LastPart).froozen = -90
        Part(LastPart).visible = 30
        Part(LastPart).partid = "Smoke"
        Part(LastPart).playwhatsound = "None"
        Part(LastPart).rotation = Int(Rnd * 360) - 180
        Part(LastPart).rotationspeed = Int(Rnd * 128) - 64
        LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0
    Next

    Part(LastPart).x = x
    Part(LastPart).y = y
    Part(LastPart).z = 1
    Part(LastPart).xm = Int(Rnd * 8) - 4
    Part(LastPart).ym = Int(Rnd * 8) - 4
    Part(LastPart).zm = 20 + Int(Size / 40)
    Part(LastPart).froozen = -64
    Part(LastPart).visible = 5
    Part(LastPart).partid = "Explosion"
    Part(LastPart).playwhatsound = "None"
    Part(LastPart).rotation = Int(Rnd * 360) - 180
    Part(LastPart).rotationspeed = Int(Rnd * 128) - 64
    LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0

    Part(LastPart).x = x
    Part(LastPart).y = y
    Part(LastPart).z = 25
    Part(LastPart).xm = Int(Rnd * 8) - 4
    Part(LastPart).ym = Int(Rnd * 8) - 4
    Part(LastPart).zm = 10
    Part(LastPart).froozen = -200
    Part(LastPart).visible = 90
    Part(LastPart).partid = "Smoke"
    Part(LastPart).playwhatsound = "None"
    Part(LastPart).rotation = Int(Rnd * 360) - 180
    Part(LastPart).rotationspeed = Int(Rnd * 100) - 50
    LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0


    For i = 1 To ZombieMax
        If Zombie(i).health > 0 Then
            dist = Distance(x, y, Zombie(i).x, Zombie(i).y)
            If dist < Size Then
                Zombie(i).DamageTaken = Int(strength / (dist / 50))
            End If
        End If
    Next


    dist = Distance(x, y, Player.x, Player.y)
    If dist < Size Then
        'Player.DamageToTake = Int(strength / (dist / 30))
        PlayerTakeDamage Player, x, y, Int(strength / (dist / 30)), Int(dist / 10)
    End If



End Sub

Function CreateImageText (Handle As Long, text As String, textsize As Integer)
    If Handle <> 0 Then _FreeImage Handle
    If text = "" Then text = " "
    _Font BegsFontSizes(textsize)
    thx = _PrintWidth(text)
    thy = _FontHeight(BegsFontSizes(textsize))
    Handleb = _NewImage(thx * 3, thy * 3, 32)
    _Dest Handleb
    _ClearColor _RGB32(0, 0, 0): _PrintMode _KeepBackground: _Font BegsFontSizes(textsize - 1): Print text + " "
    Handle = _NewImage(thx, thy, 32)
    _Dest MainScreen
    _PutImage (0, 0), Handleb, Handle
    _Font BegsFontSizes(20)
    If Handleb <> 0 Then _FreeImage Handleb
    CreateImageText = Handle
End Function

Function raycastingsimple (x As Double, y As Double, angle As Double, limit As Integer)

    Dim xvector As Double: Dim yvector As Double
    xvector = Sin(angle * PIDIV180): yvector = -Cos(angle * PIDIV180)
    Ray.x = x: Ray.y = y
    Do
        limit = limit - 1
        Ray.x = Ray.x + xvector * 6: Ray.y = Ray.y + yvector * 6
        If limit = 0 Then Exit Do
        tx = Fix((Ray.x) / Map.TileSize): ty = Fix((Ray.y) / Map.TileSize): If Tile(tx, ty, 2).transparent = 0 Then Exit Do

        For i = 1 To ZombieMax
            If Zombie(i).active = 1 Then
                If RayCollideEntity(Ray, Zombie(i)) Then Exit Do
            End If
        Next

    Loop While quit < 4
    raycastingsimple = 1
End Function


Function IsInView (x As Double, y As Double, x2 As Double, y2 As Double, hitbox As Double, stepsize As Double, tolerance As Integer)
    IsInView = 0

    dx = x - x2: dy = y - y2
    Rotation = ATan2(dy, dx) ' Angle in radians
    Rotation = (Rotation * 180 / PI) + 90
    If Rotation > 180 Then Rotation = Rotation - 179.9
    Dim xvector As Double: Dim yvector As Double
    Ray.x = x: Ray.y = y
    amountsonwall = 0
    Do
        ' Line (0, 0)-(_Width, _Height), _RGBA(0, 0, 0, 4), BF
        '  oldrayx = Ray.x: oldrayy = Ray.y
        xvector = Sin(Rotation * PIDIV180): yvector = -Cos(Rotation * PIDIV180)
        Ray.x = Ray.x + xvector * stepsize: Ray.y = Ray.y + yvector * stepsize
        tx = Fix((Ray.x) / Map.TileSize): ty = Fix((Ray.y) / Map.TileSize): If Tile(tx, ty, 2).ID <> 0 Then
            amountsonwall = amountsonwall - 1
            tolerance = tolerance - 1
            IsInView = amountsonwall
            If tolerance <= 0 Then Exit Do
        End If
        ' Line (ETSX(x2 - hitbox), ETSY(y2 - hitbox))-(ETSX(x2 + hitbox), ETSY(y2 + hitbox)), _RGB(128, 0, 0), BF
        '  Line (ETSX(oldrayx), ETSY(oldrayy))-(ETSX(Ray.x), ETSY(Ray.y)), _RGB(255, 128, 0)
        '  Line (ETSX(Ray.x - 1), ETSY(Ray.y - 1))-(ETSX(Ray.x + 1), ETSY(Ray.y + 1)), _RGB(255, 255, 255), BF

        '   _Display
        ' _Delay 0.001

        If Ray.x + 1 >= x2 - hitbox Then
            If Ray.x - 1 <= x2 + hitbox Then
                If Ray.y + 1 >= y2 - hitbox Then
                    If Ray.y - 1 <= y2 + hitbox Then
                        IsInView = -1
                        Exit Do
                    End If
                End If
            End If
        End If
    Loop

End Function

Function ShadowView (x As Double, y As Double, x2 As Double, y2 As Double, hitbox As Double, stepsize As Double, tolerance As Integer, entangle As Double, fol As Double)
    ShadowView = 0

    dx = x - x2: dy = y - y2
    Rotation = ATan2(dy, dx) ' Angle in radians
    Rotation = (Rotation * 180 / PI) + 90
    If Rotation > 180 Then Rotation = Rotation - 179.9

    If fol <> -1 Then
    End If

    Dim xvector As Double: Dim yvector As Double
    Ray.x = x: Ray.y = y
    amountsonwall = 0
    xvector = Sin(Rotation * PIDIV180): yvector = -Cos(Rotation * PIDIV180)
    Do
        Ray.x = Ray.x + xvector * stepsize: Ray.y = Ray.y + yvector * stepsize
        tx = Fix((Ray.x) / Map.TileSize): ty = Fix((Ray.y) / Map.TileSize): If Tile(tx, ty, 2).ID <> 0 Then
            amountsonwall = amountsonwall + 1
            tolerance = tolerance - 1
            ShadowView = amountsonwall
            If tolerance <= 0 Then Exit Do
        End If

        If Ray.x + 1 >= x2 - hitbox Then If Ray.x - 1 <= x2 + hitbox Then If Ray.y + 1 >= y2 - hitbox Then If Ray.y - 1 <= y2 + hitbox Then Exit Do
    Loop

End Function

Function IsBetween% (X As Single, A As Single, B As Single)
    If A <= B Then
        ' If A <= B, check if X is between A and B
        IsBetween% = (X >= A) And (X <= B)
    Else
        ' If A > B, check if X is in the wrap-around segment
        IsBetween% = (X >= A) Or (X <= B)
    End If
End Function


Function raycasting (x As Double, y As Double, angle As Double, damage As Double, owner As Double, distallow As Long, bloodchance As Integer)
    Dim xvector As Double: Dim yvector As Double
    xvector = Sin(angle * PIDIV180): yvector = -Cos(angle * PIDIV180)
    Ray.x = x: Ray.y = y: Ray.owner = owner
    quit = 0
    Do
        distallow = distallow - 1
        If distallow = 0 Then Exit Do
        Steps = Steps + 1
        steps2 = steps2 + 1
        Ray.x = Ray.x + xvector * 2: Ray.y = Ray.y + yvector * 2
        If steps2 = 5 Then
            tx = Fix((Ray.x) / Map.TileSize): ty = Fix((Ray.y) / Map.TileSize): If Tile(tx, ty, 2).solid = 1 Then
                quit = quit + 2
                If Tile(tx, ty, 2).fragile = 1 And damage > 5 Then
                    For o = 1 To 5
                        Part(LastPart).x = Ray.x
                        Part(LastPart).y = Ray.y
                        Part(LastPart).z = 2
                        Part(LastPart).xm = Int(Rnd * 128) - 64
                        Part(LastPart).ym = Int(Rnd * 128) - 64
                        Part(LastPart).zm = 2 + Int(Rnd * 7)
                        Part(LastPart).froozen = -20
                        Part(LastPart).visible = 900
                        Part(LastPart).partid = "GlassShard"
                        Part(LastPart).playwhatsound = "Glass"
                        Part(LastPart).rotation = Int(Rnd * 360) - 180
                        Part(LastPart).rotationspeed = Int(Rnd * 60) - 30
                        LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0
                    Next
                    If Tile(tx, ty, 2).ID = 56 Then _SndPlayCopy GlassShadder(Int(1 + Rnd * 3)), 0.4
                    Tile(tx, ty, 2).ID = 0
                    Tile(tx, ty, 2).solid = 0
                    'Tile(tx, ty, 2).rend_spritex = 0
                    'Tile(tx, ty, 2).rend_spritey = 0
                End If
                If Tile(tx, ty, 2).fragile = 0 Then
                    If damage > 0 Then
                        Part(LastPart).x = Ray.x
                        Part(LastPart).y = Ray.y
                        Part(LastPart).z = 2
                        Part(LastPart).xm = 0
                        Part(LastPart).ym = 0
                        Part(LastPart).zm = 2 + Int(Rnd * 3)
                        Part(LastPart).froozen = -20
                        Part(LastPart).visible = 800
                        Part(LastPart).partid = "WallShot"
                        Part(LastPart).playwhatsound = "Wall"
                        Part(LastPart).rotation = Int(Rnd * 360) - 180
                        Part(LastPart).rotationspeed = Int(Rnd * 60) - 30
                        LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0
                    End If
                    Exit Do
                End If
            End If
            steps2 = 0
            For i = 1 To ZombieMax
                If Zombie(i).active = 1 Then
                    If RayCollideEntity(Ray, Zombie(i)) Then
                        If damage > 0 Then
                            If Int(Rnd * 20) = 11 Then _SndPlayCopy ZombieShot(Int(Rnd * 16) + 1), 0.2
                            If Zombie(i).DamageTaken = 0 Then EntityTakeDamage Zombie(i), Ray.x, Ray.y, damage
                            changeofblood = Int(Rnd * bloodchance)
                            If changeofblood > damage Then SpawnBloodParticle Ray.x, Ray.y, angle, Steps, "green"
                            If GunDisplay.wtype = 2 Then quit = quit + 1: If damage > 0 Then damage = damage - 1
                            If GunDisplay.wtype <> 2 Then quit = 99999
                        End If
                    End If
                End If

            Next

        End If
    Loop While quit < 7

    For i = 1 To ZombieMax
        If Zombie(i).active = 1 Then
            Zombie(i).health = Zombie(i).health - Zombie(i).DamageTaken: Zombie(i).DamageTaken = 0
        End If
    Next

End Function



Sub SpawnBloodParticle (x As Double, y As Double, angle As Double, Steps As Long, BloodType As String)
    LastPart = LastPart + 1: If LastPart > ParticlesMax Then LastPart = 0
    Part(LastPart).x = x
    Part(LastPart).y = y
    Part(LastPart).z = 2 + Int(Rnd * 12)
    rand = 20 + Int(Rnd * 100)
    Part(LastPart).xm = Int(Sin((angle + Int(Rnd * 40) - 20) * PIDIV180) * (rand))
    Part(LastPart).ym = Int(-Cos((angle + Int(Rnd * 40) - 20) * PIDIV180) * (rand))
    Part(LastPart).zm = (2 + Int(Rnd * 14))
    Part(LastPart).froozen = -70
    Part(LastPart).visible = 2000

    Part(LastPart).BloodColor = BloodType
    Part(LastPart).partid = "BloodSplat"
    If BloodType = "green" Then Part(LastPart).froozen = -20
    Part(LastPart).playwhatsound = "Blood"
    If Part(LastPart).BloodColor = "GibSkull" Then Part(LastPart).partid = BloodType: Part(LastPart).playwhatsound = "Bone"
    If Part(LastPart).BloodColor = "GibBone" Then Part(LastPart).partid = BloodType: Part(LastPart).playwhatsound = "Bone"
    If Part(LastPart).BloodColor = "PistolAmmo" Then Part(LastPart).partid = BloodType: Part(LastPart).playwhatsound = "Blood"
    If Part(LastPart).BloodColor = "ShotgunAmmo" Then Part(LastPart).partid = BloodType: Part(LastPart).playwhatsound = "Blood"
    If Part(LastPart).BloodColor = "GasAmmo" Then Part(LastPart).partid = BloodType: Part(LastPart).playwhatsound = "Blood"
    If Part(LastPart).BloodColor = "GrenadeAmmo" Then Part(LastPart).partid = BloodType: Part(LastPart).playwhatsound = "Blood"

    Part(LastPart).rotation = Int(Rnd * 360) - 180
    Part(LastPart).rotationspeed = Int(Rnd * 60) - 30

End Sub


Function Distance (x1, y1, x2, y2)
    Distance = 0
    Dist = Sqr(((x1 - x2) ^ 2) + ((y1 - y2) ^ 2))
    Distance = Dist
End Function
Sub PlayerTakeDamage (Player As Player, X, Y, Damage, Knockback)
    dx = Player.x - X: dy = Player.y - Y
    Rotation = ATan2(dy, dx) ' Angle in radians
    Rotation = (Rotation * 180 / PI) + 90
    If Rotation > 180 Then Rotation = Rotation - 180
    xvector = Sin(Rotation * PIDIV180)
    yvector = -Cos(Rotation * PIDIV180)
    Player.Health = Player.Health - (Damage * Config.Player_DamageMultiplier)
    Player.xm = Player.xm / 5
    Player.ym = Player.ym / 5
    Player.ym = Int(Player.ym + yvector * (Damage * Knockback))
    Player.xm = Int(Player.xm + xvector * (Damage * Knockback))
    SpawnBloodParticle Player.x - Player.size + Int(Rnd * Player.size * 2), Player.y - Player.size + Int(Rnd * Player.size * 2), Rotation + 180, 2, "red"
    If Player.Health > 0 Then
        _SndPlay PlayerDamage
        da = 1
        StartVibrate Int(65535 / 2)
    End If
End Sub
Sub EntityTakeDamage (Player As Entity, X, Y, Damage)
    dx = Player.x - X: dy = Player.y - Y
    Rotation = ATan2(dy, dx) ' Angle in radians
    Rotation = (Rotation * 180 / PI) + 90
    If Rotation > 180 Then Rotation = Rotation - 179.9
    xvector = Sin(Rotation * PIDIV180)
    yvector = -Cos(Rotation * PIDIV180)
    Player.ym = Int(Player.ym - ((yvector * (Damage * 35) / Player.weight)))
    Player.xm = Int(Player.xm - ((xvector * (Damage * 35) / Player.weight)))
    If (Player.health * 10) < Damage Then gib = 1
    Player.DamageTaken = Abs(Damage)
    If gib = 0 And Player.health - Damage < 0 Then Player.health = 0
End Sub



Sub MakeHitBoxPlayer (Player As Player)
    Player.x1 = Player.x - Player.size: Player.x2 = Player.x + Player.size: Player.y1 = Player.y - Player.size: Player.y2 = Player.y + Player.size
End Sub

Function CollisionWithWallsPlayer (Player As Player)
    CollisionWithWallsPlayer = 0
    PY1 = Player.y1 - Player.ym / 10: PY2 = Player.y2 - Player.ym / 10: PX1 = Player.x1 - Player.xm / 10: PX2 = Player.x2 - Player.xm / 10
    tx1 = Fix((PX1 - 1) / Map.TileSize): ty1 = Fix((PY1 + 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Player.xm > 0 Then Player.x = Player.x + Player.xm / 10: Player.xm = -0: Player.TouchX = 3
    tx1 = Fix((PX1 - 1) / Map.TileSize): ty1 = Fix((PY2 - 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Player.xm > 0 Then Player.x = Player.x + Player.xm / 10: Player.xm = -0: Player.TouchX = 3
    tx1 = Fix((PX2 + 1) / Map.TileSize): ty1 = Fix((PY1 + 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Player.xm < 0 Then Player.x = Player.x + Player.xm / 10: Player.xm = 0: Player.TouchX = 3
    tx1 = Fix((PX2 + 1) / Map.TileSize): ty1 = Fix((PY2 - 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Player.xm < 0 Then Player.x = Player.x + Player.xm / 10: Player.xm = 0: Player.TouchX = 3
    tx1 = Fix((PX1 + 10) / Map.TileSize): ty1 = Fix((PY1 - 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Player.ym > 0 Then Player.y = Player.y + Player.ym / 10: Player.ym = -0: Player.TouchY = 3
    tx1 = Fix((PX1 + 10) / Map.TileSize): ty1 = Fix((PY2 + 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Player.ym < 0 Then Player.y = Player.y + Player.ym / 10: Player.ym = 0: Player.TouchY = 3
    tx1 = Fix((PX2 - 10) / Map.TileSize): ty1 = Fix((PY1 - 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Player.ym > 0 Then Player.y = Player.y + Player.ym / 10: Player.ym = -0: Player.TouchY = 3
    tx1 = Fix((PX2 - 10) / Map.TileSize): ty1 = Fix((PY2 + 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Player.ym < 0 Then Player.y = Player.y + Player.ym / 10: Player.ym = 0: Player.TouchY = 3
    CollisionWithWallsPlayer = -1
End Function

Function CollisionWithWallsEntity (Ent As Entity)
    CollisionWithWallsEntity = 0
    PY1 = Ent.y1 + Ent.ym / 100: PY2 = Ent.y2 + Ent.ym / 100: PX1 = Ent.x1 + Ent.xm / 100: PX2 = Ent.x2 + Ent.xm / 100
    tx1 = Fix((PX1 - 1) / Map.TileSize): ty1 = Fix((PY1 + 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.xm < 0 Then Ent.x = Ent.x - Ent.xm / 100: Ent.xm = 5
    tx1 = Fix((PX1 - 1) / Map.TileSize): ty1 = Fix((PY2 - 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.xm < 0 Then Ent.x = Ent.x - Ent.xm / 100: Ent.xm = 5
    tx1 = Fix((PX2 + 1) / Map.TileSize): ty1 = Fix((PY1 + 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.xm > 0 Then Ent.x = Ent.x - Ent.xm / 100: Ent.xm = -5
    tx1 = Fix((PX2 + 1) / Map.TileSize): ty1 = Fix((PY2 - 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.xm > 0 Then Ent.x = Ent.x - Ent.xm / 100: Ent.xm = -5
    tx1 = Fix((PX1 + 10) / Map.TileSize): ty1 = Fix((PY1 - 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.ym < 0 Then Ent.y = Ent.y - Ent.ym / 100: Ent.ym = 5
    tx1 = Fix((PX1 + 10) / Map.TileSize): ty1 = Fix((PY2 + 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.ym > 0 Then Ent.y = Ent.y - Ent.ym / 100: Ent.ym = -5
    tx1 = Fix((PX2 - 10) / Map.TileSize): ty1 = Fix((PY1 - 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.ym < 0 Then Ent.y = Ent.y - Ent.ym / 100: Ent.ym = 5
    tx1 = Fix((PX2 - 10) / Map.TileSize): ty1 = Fix((PY2 + 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.ym > 0 Then Ent.y = Ent.y - Ent.ym / 100: Ent.ym = -5
    CollisionWithWallsEntity = -1
End Function



Sub Angle2Vector (Angle!, xv!, yv!)
    xv! = Sin(Angle! * PIDIV180)
    yv! = -Cos(Angle! * PIDIV180)
End Sub

Function CalculatePercentage (Number As Double, Percentage As Double)
    Dim Result As Double
    'Result = (Percentage / 100) * Number
    Result = (Percentage / Number) * 100
    CalculatePercentage = Result
End Function
Function ATan2 (y As Single, x As Single)
    Dim AtanResult As Single
    If x = 0 Then
        If y > 0 Then
            AtanResult = PI / 2
        ElseIf y < 0 Then
            AtanResult = -PI / 2
        Else
            AtanResult = 0
        End If
    Else
        AtanResult = Atn(y / x)
        If x < 0 Then
            If y >= 0 Then AtanResult = AtanResult + PI
        Else AtanResult = AtanResult - PI
        End If
    End If
    ATan2 = AtanResult
End Function

Function ETSX (e)
    S = e - (CameraX) * Map.TileSize
    ETSX = Int(S)
End Function
Function ETSY (e)
    S = e - (CameraY) * Map.TileSize
    ETSY = Int(S)
End Function


Function WTS (w, Camera)
    S = (w - Camera) * Map.TileSize
    WTS = S
End Function

Function STW (s, m, Camera)
    w = ((s / m) + Camera)
    STW = w
End Function

Sub RotoZoom (X As Long, Y As Long, Image As Long, Scale As Single, Rotation As Single)
    Dim px(3) As Single: Dim py(3) As Single
    W& = _Width(Image&): H& = _Height(Image&)
    px(0) = -W& / 2: py(0) = -H& / 2: px(1) = -W& / 2: py(1) = H& / 2
    px(2) = W& / 2: py(2) = H& / 2: px(3) = W& / 2: py(3) = -H& / 2
    sinr! = Sin(-Rotation / 57.2957795131): cosr! = Cos(-Rotation / 57.2957795131)
    For i& = 0 To 3
        x2& = (px(i&) * cosr! + sinr! * py(i&)) * Scale + X: y2& = (py(i&) * cosr! - px(i&) * sinr!) * Scale + Y
        px(i&) = x2&: py(i&) = y2&
    Next
    _MapTriangle (0, 0)-(0, H& - 1)-(W& - 1, H& - 1), Image& To(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
    _MapTriangle (0, 0)-(W& - 1, 0)-(W& - 1, H& - 1), Image& To(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
End Sub

Sub RotoZoomHard (X As Long, Y As Long, Image As Long, Scale As Single, Rotation As Single, Dest As Long)
    Dim px(3) As Single: Dim py(3) As Single
    W& = _Width(Image&): H& = _Height(Image&)
    px(0) = -W& / 2: py(0) = -H& / 2: px(1) = -W& / 2: py(1) = H& / 2
    px(2) = W& / 2: py(2) = H& / 2: px(3) = W& / 2: py(3) = -H& / 2
    sinr! = Sin(-Rotation / 57.2957795131): cosr! = Cos(-Rotation / 57.2957795131)
    For i& = 0 To 3
        x2& = (px(i&) * cosr! + sinr! * py(i&)) * Scale + X: y2& = (py(i&) * cosr! - px(i&) * sinr!) * Scale + Y
        px(i&) = x2&: py(i&) = y2&
    Next
    _MapTriangle (0, 0)-(0, H& - 1)-(W& - 1, H& - 1), Image& To(px(0), py(0))-(px(1), py(1))-(px(2), py(2)), Dest
    _MapTriangle (0, 0)-(W& - 1, 0)-(W& - 1, H& - 1), Image& To(px(0), py(0))-(px(3), py(3))-(px(2), py(2)), Dest
End Sub


Function LoadMapSettings (MapName As String)
    LoadMapSettings = 0
    Open ("assets/Vantiro-1.1v07b/maps/" + MapName + ".map") For Input As #1
    Input #1, trash$ 'Tileset Image
    Input #1, Map.tileset
    Input #1, trash$ 'Layers header
    Input #1, Map.Layers
    Input #1, trash$ 'Max Width for map
    Input #1, Map.MaxWidth
    Input #1, trash$ 'Max Height for map
    Input #1, Map.MaxHeight
    Input #1, trash$ 'Tile size per tile
    Input #1, Map.TileSize
    Input #1, trash$ 'Triggers on the map
    Input #1, Map.Triggers
    Input #1, trash$ 'Tile texture size
    Input #1, Map.TextureSize
    Input #1, currentlayer
    'Close #1
    LoadMapSettings = -1
    Map.TileSize = Map.TileSize * 4
    Map.TileSizeHalf = Map.TileSize / 2
    Map.TileShadowSize = Map.TileSize / 2
End Function


Function LoadMap (MapName As String)
    LoadMap = 0
    limit = Map.MaxHeight * Map.MaxWidth * Map.Layers
    For z = 1 To Map.Layers
        For y = 0 To Map.MaxHeight
            For x = 0 To Map.MaxWidth
                ' If x <> Map.MaxWidth Then 'error happens because of the , at each line in the map file. the program interprets the line break as a "" string. please fix
                'lmao, wont fix
                Input #1, Tile(x, y, z).ID
                If Tile(x, y, z).ID = -404 Then NVM = 1
                If NVM = 1 Then Exit For
                If z = 2 And Tile(x, y, z).ID <> 0 Then Tile(x, y, z).solid = 1
                If Tile(x, y, z).ID = 0 Then Tile(x, y, z).transparent = 1
                IDTOTEXTURE = Tile(x, y, z).ID
                If Tile(x, y, z).ID = 56 Then Tile(x, y, z).fragile = 1: Tile(x, y, z).transparent = 1
                Do
                    If IDTOTEXTURE > 16 Then
                        Tile(x, y, z).rend_spritey = Tile(x, y, z).rend_spritey + 1
                        IDTOTEXTURE = IDTOTEXTURE - 16
                    End If
                    Tile(x, y, z).rend_spritex = IDTOTEXTURE - 1
                Loop While IDTOTEXTURE > 16
                Tile(x, y, z).x1t = Tile(x, y, z).rend_spritex * Map.TextureSize
                Tile(x, y, z).y1t = Tile(x, y, z).rend_spritey * Map.TextureSize
                Tile(x, y, z).x2t = Tile(x, y, z).rend_spritex * Map.TextureSize + (Map.TextureSize - 1)
                Tile(x, y, z).y2t = Tile(x, y, z).rend_spritey * Map.TextureSize + (Map.TextureSize - 1)


            Next
            If NVM = 1 Then Exit For
        Next
        If NVM = 1 Then Exit For
        If NVM = 0 Then If z <> Map.Layers - 1 Then Input #1, trash$
    Next
    If Map.Triggers > 0 Then
        Input #1, trash$
        Input #1, trash$
        Input #1, trash$
        Input #1, trash$
        For r = 1 To Map.Triggers
            Input #1, Line$
            poss = InStr(Line$, "name=") + 6
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).triggername = Mid$(Line$, poss, endpos - poss)

            poss = InStr(Line$, "x=") + 3
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).x1 = Val(Mid$(Line$, poss, endpos - poss)) * 2

            poss = InStr(Line$, "y=") + 3
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).y1 = Val(Mid$(Line$, poss, endpos - poss)) * 2

            poss = InStr(Line$, "width=") + 7
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).sizex = Val(Mid$(Line$, poss, endpos - poss)) * 2

            poss = InStr(Line$, "height=") + 8
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).sizey = Val(Mid$(Line$, poss, endpos - poss)) * 2

            Trigger(r).x2 = Trigger(r).x1 + Trigger(r).sizex
            Trigger(r).y2 = Trigger(r).y1 + Trigger(r).sizey
            Input #1, trash$

            Input #1, Line$
            poss = InStr(Line$, "value=") + 7
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).class = Mid$(Line$, poss, endpos - poss)

            Input #1, Line$
            poss = InStr(Line$, "value=") + 7
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).val1 = Val(Mid$(Line$, poss, endpos - poss))

            Input #1, Line$
            poss = InStr(Line$, "value=") + 7
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).val2 = Val(Mid$(Line$, poss, endpos - poss))

            Input #1, Line$
            poss = InStr(Line$, "value=") + 7
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).val3 = Val(Mid$(Line$, poss, endpos - poss))

            Input #1, Line$
            poss = InStr(Line$, "value=") + 7
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).val4 = Val(Mid$(Line$, poss, endpos - poss))

            Input #1, Line$
            poss = InStr(Line$, "value=") + 7
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).needclick = Val(Mid$(Line$, poss, endpos - poss))

            Input #1, Line$
            poss = InStr(Line$, "value=") + 7
            endpos = InStr(poss, Line$, Chr$(34))
            Trigger(r).text = Mid$(Line$, poss, endpos - poss)
            Input #1, trash$
            Input #1, trash$
        Next
    End If
    Close #1

    'Optimize

    For x = 0 To Map.MaxWidth
        For y = 0 To Map.MaxHeight
            If Tile(x, y, 2).ID <> 0 Then Tile(x, y, 1).ID = 0
            Tile(x, y, 0).toplayer = 1
            If Tile(x, y, 1).ID <> 0 Then Tile(x, y, 0).toplayer = 2
            If Tile(x, y, 2).ID <> 0 Then Tile(x, y, 0).toplayer = 3
            If Tile(x, y, 3).ID <> 0 Then Tile(x, y, 0).toplayer = 4

        Next
    Next




    LoadMap = -1
End Function

Function RayCollideEntity (Rect1 As Raycast, rect2 As Entity)
    RayCollideEntity = 0
    If Rect1.x >= rect2.x1 Then
        If Rect1.x <= rect2.x2 Then
            If Rect1.y >= rect2.y1 Then
                If Rect1.y <= rect2.y2 Then
                    RayCollideEntity = -1
                End If
            End If
        End If
    End If
End Function
Function UICollide (Rect1 As Mouse, Rect2 As Menu)
    UICollide = 0
    If Rect1.x2 >= Rect2.x1 + Rect2.OffsetX Then
        If Rect1.x1 <= Rect2.x2 + Rect2.OffsetX Then
            If Rect1.y2 >= Rect2.y1 + Rect2.OffsetY Then
                If Rect1.y1 <= Rect2.y2 + Rect2.OffsetY Then
                    UICollide = -1
                End If
            End If
        End If
    End If
End Function

Function GraphCollide (Rect1 As Mouse, Rect2 As Graph)
    GraphCollide = 0
    If Rect1.x >= Rect2.x1 Then
        If Rect1.x <= Rect2.x2 Then
            If Rect1.y >= Rect2.y1 Then
                If Rect1.y <= Rect2.y2 Then
                    GraphCollide = -1
                End If
            End If
        End If
    End If
End Function

Function GraphsCollide (Rect1 As Graph, Rect2 As Graph)
    GraphsCollide = 0
    If Rect1.x2 >= Rect2.x1 Then
        If Rect1.x1 <= Rect2.x2 Then
            If Rect1.y2 >= Rect2.y1 Then
                If Rect1.y1 <= Rect2.y2 Then
                    GraphsCollide = -1
                End If
            End If
        End If
    End If
End Function


Function TriggerPlayerCollide (Rect1 As Player, Rect2 As Trigger)
    TriggerPlayerCollide = 0
    If Rect1.x2 >= Rect2.x1 Then
        If Rect1.x1 <= Rect2.x2 Then
            If Rect1.y2 >= Rect2.y1 Then
                If Rect1.y1 <= Rect2.y2 Then
                    TriggerPlayerCollide = -1
                End If
            End If
        End If
    End If
End Function
Sub StopVibrate
    'w vibe = XInputSetState(0, _Offset(stopvibe))
End Sub
Sub StartVibrate (motorspeed As _Unsigned Integer)
    'w vibrate.wLeftMotorSpeed = motorspeed
    'w vibrate.wRightMotorSpeed = motorspeed
    'w vibe = XInputSetState(0, _Offset(vibrate))
End Sub
Sub LoadConfigs
    Dim trash$
    Open ("assets/Vantiro-1.1v07b/config.ini") For Input As #4
    Input #4, version
    Input #4, trash$

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_SmoothingY = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_SmoothingX = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_Distselfall = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_Distselmult = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_Size = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_Side = (_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_Fade = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_XMYMDivide = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_SelectedColor = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Hud_UnSelectedColor = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, trash$

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Map_Lighting = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, trash$

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Player_MaxSpeed = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Player_Accel = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Player_Size = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Player_MaxHealth = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Player_HealthPerBlood = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Player_DamageMultiplier = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, trash$

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Wave_End = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Wave_ZombieMultiplier = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Wave_ZombieRandom = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Wave_TimeLimit = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, trash$

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Zombie_OldAI = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Zombie_DefMaxSpeed = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Zombie_DefSize = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Zombie_DefTickRate = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Zombie_DefMaxDamage = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Zombie_DefMinDamage = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Zombie_DefMaxHealth = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.Zombie_DefMinHealth = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, trash$

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.ParticlesMax = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.ZombiesMax = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.FireMax = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.BiohazardFluidMax = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))
    Close #4
    Config.Hud_SelRed = _Red32(Config.Hud_SelectedColor)
    Config.Hud_SelGreen = _Green32(Config.Hud_SelectedColor)
    Config.Hud_SelBlue = _Blue32(Config.Hud_SelectedColor)

    Config.Hud_UnSelRed = _Red32(Config.Hud_UnSelectedColor)
    Config.Hud_UnSelGreen = _Green32(Config.Hud_UnSelectedColor)
    Config.Hud_UnSelBlue = _Blue32(Config.Hud_UnSelectedColor)

End Sub

Sub SaveConfig
    Open ("assets/Vantiro-1.1v07b/config.ini") For Output As #4
    Print #4, "'# Hud settings."
    Print #4, "Config.Hud_SmoothingY = " + _Trim$(Str$(Config.Hud_SmoothingY)) + " ' (Def: 10)"
    Print #4, "Config.Hud_SmoothingX = " + _Trim$(Str$(Config.Hud_SmoothingX)) + " ' (Def: 10)"
    Print #4, "Config.Hud_Distselfall = " + _Trim$(Str$(Config.Hud_Distselfall)) + " ' (Def: 4)"
    Print #4, "Config.Hud_Distselmult = " + _Trim$(Str$(Config.Hud_Distselmult)) + " ' (Def: 5)"
    Print #4, "Config.Hud_Size = " + _Trim$(Str$(Config.Hud_Size)) + " ' (Def: 35)"
    Print #4, "Config.Hud_Side = " + _Trim$((Config.Hud_Side)) + " ' (Def: Down)"
    Print #4, "Config.Hud_Fade = " + _Trim$(Str$(Config.Hud_Fade)) + " ' (Def: 50)"
    Print #4, "Config.Hud_XMYMDivide = " + _Trim$(Str$(Config.Hud_XMYMDivide)) + " ' (Def: 1.075)"
    Print #4, "Config.Hud_SelectedColor = " + _Trim$(Str$(Config.Hud_SelectedColor)) + " ' (Def: -1)"
    Print #4, "Config.Hud_UnSelectedColor = " + _Trim$(Str$(Config.Hud_UnSelectedColor)) + " ' (Def: -8355712)"
    Print #4, "'# Map settings."
    Print #4, "Config.Map_Lighting = " + _Trim$(Str$(Config.Map_Lighting)) + " ' (Def: 1)"
    Print #4, "'# Player settings."
    Print #4, "Config.Player_MaxSpeed = " + _Trim$(Str$(Config.Player_MaxSpeed)) + " ' (Def: 70)"
    Print #4, "Config.Player_Accel = " + _Trim$(Str$(Config.Player_Accel)) + " ' (Def: 3)"
    Print #4, "Config.Player_Size = " + _Trim$(Str$(Config.Player_Size)) + " ' (Def: 25) "
    Print #4, "Config.Player_MaxHealth = " + _Trim$(Str$(Config.Player_MaxHealth)) + " ' (Def: 101)"
    Print #4, "Config.Player_HealthPerBlood = " + _Trim$(Str$(Config.Player_HealthPerBlood)) + " ' (Def: 0.11)"
    Print #4, "Config.Player_DamageMultiplier = " + _Trim$(Str$(Config.Player_DamageMultiplier)) + " ' (Def: 1)"
    Print #4, "'# Waves settings."
    Print #4, "Config.Wave_End = " + _Trim$(Str$(Config.Wave_End)) + " ' (Def: 11)"
    Print #4, "Config.Wave_ZombieMultiplier = " + _Trim$(Str$(Config.Wave_ZombieMultiplier)) + " ' (Def: 7)"
    Print #4, "Config.Wave_ZombieRandom = " + _Trim$(Str$(Config.Wave_ZombieRandom)) + " ' (Def: 22)"
    Print #4, "Config.Wave_TimeLimit = " + _Trim$(Str$(Config.Wave_TimeLimit)) + " ' (Def: -1)"
    Print #4, "'# Zombie settings. (Mainly Health is used)"
    Print #4, "Config.Zombie_OldAI = " + _Trim$(Str$(Config.Zombie_OldAI)) + " ' (Def: 1)"
    Print #4, "Config.Zombie_DefMaxSpeed = " + _Trim$(Str$(Config.Zombie_DefMaxSpeed)) + " ' (Def: 820)"
    Print #4, "Config.Zombie_DefSize = " + _Trim$(Str$(Config.Zombie_DefSize)) + " ' (Def: 26)"
    Print #4, "Config.Zombie_DefTickRate = " + _Trim$(Str$(Config.Zombie_DefTickRate)) + " ' (Def: 15)"
    Print #4, "Config.Zombie_DefMaxDamage = " + _Trim$(Str$(Config.Zombie_DefMaxDamage)) + " ' (Def: 10)"
    Print #4, "Config.Zombie_DefMinDamage = " + _Trim$(Str$(Config.Zombie_DefMinDamage)) + " ' (Def: 4)"
    Print #4, "Config.Zombie_DefMaxHealth = " + _Trim$(Str$(Config.Zombie_DefMaxHealth)) + " ' (Def: 100)"
    Print #4, "Config.Zombie_DefMinHealth = " + _Trim$(Str$(Config.Zombie_DefMinHealth)) + " ' (Def: 70)"
    Print #4, "'# Limit settings."
    Print #4, "Config.ParticlesMax = " + _Trim$(Str$(Config.ParticlesMax)) + " ' (Def: 600)"
    Print #4, "Config.ZombiesMax = " + _Trim$(Str$(Config.ZombiesMax)) + " ' (Def: 190)"
    Print #4, "Config.FireMax = " + _Trim$(Str$(Config.FireMax)) + " ' (Def: 128)"
    Print #4, "Config.BiohazardFluidMax = " + _Trim$(Str$(Config.BiohazardFluidMax)) + " ' (Def: 32)"
    Close #4
End Sub

Sub HudLogic (Hud As Hud, HudDown As Double, i As Integer, Selected As Integer, LastSelected As Integer, Side As String)
    Hud.size = Config.Hud_Size
    distsel = Abs(i - Selected)
    Select Case Side
        Case "Down"
            Hud.yp = _Height - Hud.size * 1.9 + ((distsel ^ Config.Hud_Distselfall) + (distsel * Config.Hud_Distselmult))
            Hud.xp = (_Width / 2) + (i - Selected) * Hud.size * 2.5
        Case "Left"
            Hud.yp = (_Height / 2) + ((i - Selected) * Hud.size * 2.8)
            Hud.xp = Hud.size * 1.9 - ((distsel ^ Config.Hud_Distselfall) + (distsel * Config.Hud_Distselmult))
        Case "Up"
            Hud.yp = Hud.size * 1.9 - ((distsel ^ Config.Hud_Distselfall) + (distsel * Config.Hud_Distselmult))
            Hud.xp = (_Width / 2) + (i - Selected) * Hud.size * 2.5
        Case "Right"
            Hud.yp = (_Height / 2) + ((i - Selected) * Hud.size * 2.8)
            Hud.xp = _Width - Hud.size * 1.9 + ((distsel ^ Config.Hud_Distselfall) + (distsel * Config.Hud_Distselmult))

    End Select
    Hud.x = Hud.x + ((Hud.xp - Hud.x) / Config.Hud_SmoothingX)
    Hud.y = Hud.y + ((Hud.yp - Hud.y) / Config.Hud_SmoothingY)
    If Hud.y > _Height + (Hud.size * 8) Then Hud.y = _Height + (Hud.size * 8)
    If Hud.x > _Width + (Hud.size * 8) Then Hud.x = _Width + (Hud.size * 8)
    If Hud.y < -(Hud.size * 8) Then Hud.y = -(Hud.size * 8)
    If Hud.x < -(Hud.size * 8) Then Hud.x = -(Hud.size * 8)
    Hud.x1 = Hud.x - Hud.size + Hud.xm
    Hud.x2 = Hud.x + Hud.size + Hud.xm
    Hud.y1 = Hud.y - Hud.size + Hud.ym + HudDown
    Hud.y2 = Hud.y + Hud.size + Hud.ym + HudDown
    Hud.xm = Hud.xm / Config.Hud_XMYMDivide
    Hud.ym = Hud.ym / Config.Hud_XMYMDivide
End Sub

Sub RenderHudArrow (Hud As Hud, CenterX, CenterY, ImgHandle)
    CenterX2 = CenterX
    CenterY2 = CenterY
    If CenterX2 < Hud.x1 Then CenterX2 = Hud.x1
    If CenterX2 > Hud.x2 Then CenterX2 = Hud.x2
    If CenterY2 < Hud.y1 Then CenterY2 = Hud.y1
    If CenterY2 > Hud.y2 Then CenterY2 = Hud.y2
    dx = Hud.x - CenterX2: dy = Hud.y - CenterY2
    Rotation = ATan2(dy, dx)
    Rotation = (Rotation * 180 / PI) + 90
    xv1 = CenterX2 + Sin((Rotation - 80) * PIDIV180) * Hud.size * 2
    yv1 = CenterY2 - Cos((Rotation - 80) * PIDIV180) * Hud.size * 2
    xv2 = CenterX2 + Sin((Rotation + 80) * PIDIV180) * Hud.size * 2
    yv2 = CenterY2 - Cos((Rotation + 80) * PIDIV180) * Hud.size * 2
    If xv1 < Hud.x1 Then xv1 = Hud.x1
    If xv1 > Hud.x2 Then xv1 = Hud.x2
    If yv1 < Hud.y1 Then yv1 = Hud.y1
    If yv1 > Hud.y2 Then yv1 = Hud.y2
    If xv2 < Hud.x1 Then xv2 = Hud.x1
    If xv2 > Hud.x2 Then xv2 = Hud.x2
    If yv2 < Hud.y1 Then yv2 = Hud.y1
    If yv2 > Hud.y2 Then yv2 = Hud.y2

    _MapTriangle (0, 0)-(16, 32)-(32, 0), ImgHandle To(xv1, yv1)-(CenterX, CenterY)-(CenterX2, CenterY2)
    _MapTriangle (0, 0)-(16, 32)-(32, 0), ImgHandle To(xv2, yv2)-(CenterX, CenterY)-(CenterX2, CenterY2)
End Sub


Sub ZombieAIChasePoint (Zombie As Entity)

    'If Zombie.pointfollow = 0 Then
    '    For i = 1 To 30
    '        dist = Distance(Waypoint(i).x, Waypoint(i).y, Zombie.x, Zombie.y)
    '        If dist < lowestdist Then lowestdist = dist: lowesti = i
    '
    '    Next
    '    Zombie.pointfollow = lowesti
    'End If

    Zombie.pointtries = Zombie.pointtries + 1
    If Zombie.pointtries > 40 Then
        Zombie.pointtries = 0
        lowdist = 999999
        For w = 1 To WaypointMax
            If Waypoint(w).free = -1 Then
                '    dist = Distance(Waypoint(w).x, Waypoint(w).y, Zombie.x, Zombie.y)
                '    If dist < lowdist Then lowdist = dist: Zombie.pointfollow = w
                If Distance(Waypoint(w).x, Waypoint(w).y, Zombie.x, Zombie.y) < Map.TileSize * 10 Then
                    'Print "IN DISTANCE!"
                    '_Display
                    '_Delay 0.06
                    If IsInView(Zombie.x, Zombie.y, Waypoint(w).x, Waypoint(w).y, Map.TileSizeHalf, 15, 0) = -1 Then
                        '    Print "IN VIEW!"
                        '    _Display
                        '    _Delay 1
                        dist = Distance(Waypoint(w).x, Waypoint(w).y, Zombie.x, Zombie.y)
                        If dist < lowdist Then lowdist = dist: Zombie.pointfollow = w
                    End If
                End If
            End If
        Next
    End If
    If Distance(Zombie.x, Zombie.y, Waypoint(Zombie.pointfollow).x, Waypoint(Zombie.pointfollow).y) < Map.TileSize * 1.3 Then
        Zombie.xm = Zombie.xm / 2
        Zombie.ym = Zombie.ym / 2
        Zombie.pointtries = 0
        If Waypoint(Zombie.pointfollow).playerdist Then
            For o = 1 To 16
                If Waypoint(WaypointJoints(Zombie.pointfollow, o)).free = -1 Then
                    If Waypoint(WaypointJoints(Zombie.pointfollow, o)).realdist < Waypoint(Zombie.pointfollow).realdist Then
                        Zombie.pointfollow = WaypointJoints(Zombie.pointfollow, o): Exit For
                    End If
                End If


            Next


        End If
    End If
    ' Zombie.x = Zombie.x + (Sin(Zombie.rotation * PIDIV180))
    ' Zombie.y = Zombie.y - (Cos(Zombie.rotation * PIDIV180))
    'Zombie.xm = (Sin(Zombie.rotation * PIDIV180))
    'Zombie.ym = (-Cos(Zombie.rotation * PIDIV180))


    dx = Zombie.x - Waypoint(Zombie.pointfollow).x: dy = Zombie.y - Waypoint(Zombie.pointfollow).y
    Zombie.rotation = ATan2(dy, dx) ' Angle in radians
    Zombie.rotation = (Zombie.rotation * 180 / PI) + 90 + (-20 + Int(Rnd * 40))
    If Zombie.rotation > 180 Then Zombie.rotation = Zombie.rotation - 179.9



End Sub

Sub WaypointsPlayerDist '(Waypoint As Waypoint)
    lowestdist = 9999999

    For i = 1 To WaypointMax
        Waypoint(i).free = -1
        If Tile(Fix(Waypoint(i).x / Map.TileSize), Fix(Waypoint(i).y / Map.TileSize), 2).ID <> 0 Then Waypoint(i).free = 0

        Waypoint(i).realdist = 99999999999
        Waypoint(i).playerdist = -1
        dist = Distance(Waypoint(i).x, Waypoint(i).y, Player.x, Player.y)
        If dist < lowestdist Then lowestdist = dist: lowesti = i
    Next
    Waypoint(lowesti).playerdist = 0
    Waypoint(lowesti).realdist = Fix(Distance(Waypoint(lowesti).x, Waypoint(lowesti).y, Player.x, Player.y) / 20)
    For z = 1 To zombiesmax
        Zombie(z).pointfollow = lowesti
    Next
    loopist = 0
    Do
        added = 0
        loopist = loopist + 1
        For i = 1 To WaypointMax
            If Waypoint(i).playerdist <> -1 Then

                For o = 1 To Waypoint(i).connections
                    If Waypoint(WaypointJoints(i, o)).free = -1 Then
                        If Waypoint(WaypointJoints(i, o)).playerdist > Waypoint(i).playerdist Then Waypoint(WaypointJoints(i, o)).playerdist = Waypoint(i).playerdist + 1: added = added + 1
                        If Waypoint(WaypointJoints(i, o)).playerdist = -1 Then Waypoint(WaypointJoints(i, o)).playerdist = Waypoint(i).playerdist + 1: added = added + 1

                        'If Waypoint(WaypointJoints(i, o)).playerdist = -1 Then Waypoint(WaypointJoints(i, o)).playerdist = Waypoint(i).playerdist + 1: added = added + 1
                        If Waypoint(WaypointJoints(i, o)).realdist > Waypoint(i).realdist Then Waypoint(WaypointJoints(i, o)).realdist = Waypoint(i).realdist + Fix(Distance(Waypoint(i).x, Waypoint(i).y, Waypoint(WaypointJoints(i, o)).x, Waypoint(WaypointJoints(i, o)).y) / 20) ': added = added + 1 ': Waypoint(WaypointJoints(i, o)).realdist =
                        If Waypoint(WaypointJoints(i, o)).realdist = 0 Then Waypoint(WaypointJoints(i, o)).realdist = Waypoint(i).realdist + Fix(Distance(Waypoint(i).x, Waypoint(i).y, Waypoint(WaypointJoints(i, o)).x, Waypoint(WaypointJoints(i, o)).y) / 20) ': added = added + 1
                    End If
                Next
            End If
        Next
        If added = 0 Then Exit Do
    Loop While loopist < WaypointMax

    For i = 1 To WaypointMax
        If Waypoint(i).playerdist = -1 Then Waypoint(i).free = 0
    Next
End Sub

Sub CalcLightingDynLow (Light As LightSource)
    sizeoflight = Fix(Light.strength / 25)
    If sizeoflight > 10 Then sizeoflight = 10
    xmin = Fix(Light.x / Map.TileSize) - sizeoflight
    xmax = Fix(Light.x / Map.TileSize) + sizeoflight
    ymin = Fix(Light.y / Map.TileSize) - sizeoflight
    ymax = Fix(Light.y / Map.TileSize) + sizeoflight
    If xmin < 0 Then xmin = 0
    If ymin < 0 Then ymin = 0
    If xmin > Map.MaxWidth Then xmax = Map.MaxWidth
    If ymax > Map.MaxWidth Then ymax = Map.MaxHeight
    For x = xmin To xmax
        For y = ymin To ymax
            dist = Int(Distance((x * Map.TileSize) + (Map.TileSizeHalf), (y * Map.TileSize) + (Map.TileSizeHalf), Light.x, Light.y)) - (Light.strength + (Int(Rnd * 8) - 4))
            newlight = ((Light.strength + (Int(Rnd * 8) - 4)) - dist)
            If Tile(x, y, 2).ID <> 0 Then
                df = Abs(newlight - 255)
                newlight = newlight - (df * 2)
            End If
            If Tile(x, y, 0).dlight < newlight Then Tile(x, y, 0).dlight = newlight
            If Tile(x, y, 0).dlight < 0 Then Tile(x, y, 0).dlight = 0
            If Tile(x, y, 0).dlight > 255 Then Tile(x, y, 0).dlight = 255
        Next
    Next


End Sub

Sub CalcLightingDynNormal (Light As LightSource)
    xmin = Fix(Fix(CameraX * Map.TileSize) / Map.TileSize) - 1
    xmax = Fix(Fix(CameraX * Map.TileSize) / Map.TileSize) + Int(_Width / Map.TileSize) + 1
    ymin = Fix(Fix(CameraY * Map.TileSize) / Map.TileSize)
    ymax = Fix(Fix(CameraY * Map.TileSize) / Map.TileSize) + Int(_Height / Map.TileSize) + 1

    If xmin < 0 Then xmin = 0
    If ymin < 0 Then ymin = 0
    If xmin > Map.MaxWidth Then xmax = Map.MaxWidth
    If ymax > Map.MaxWidth Then ymax = Map.MaxHeight

    For x = xmin To xmax
        For y = ymin To ymax

            dist = Int(Distance((x * Map.TileSize) + (Map.TileSizeHalf), (y * Map.TileSize) + (Map.TileSizeHalf), Light.x, Light.y)) - (Light.strength + (Int(Rnd * 8) - 4))
            If dist > 255 Then dist = 255
            newlight = ((Light.strength + (Int(Rnd * 8) - 4)) - dist)
            If newlight > 255 Then newlight = 255

            Isview = ShadowView(Light.x - 9, Light.y, (x * Map.TileSize) + (Map.TileSizeHalf) + 8, (y * Map.TileSize) + (Map.TileSizeHalf), Map.TileSizeHalf, 15, 70, Light.angle, Light.fol)
            If Isview <> -1 Then newlight = (newlight - (Isview * 15))

            If Tile(x, y, 0).dlight < newlight Then Tile(x, y, 0).dlight = newlight
            If Tile(x, y, 0).dlight < 0 Then Tile(x, y, 0).dlight = 0
            If Tile(x, y, 0).dlight > 255 Then Tile(x, y, 0).dlight = 255


        Next

    Next

End Sub
Sub CalcLightingDynHigh (Light As LightSource)
    xmin = Fix(Fix(CameraX * Map.TileSize) / Map.TileSize) - 1
    xmax = Fix(Fix(CameraX * Map.TileSize) / Map.TileSize) + Int(_Width / Map.TileSize) + 1
    ymin = Fix(Fix(CameraY * Map.TileSize) / Map.TileSize)
    ymax = Fix(Fix(CameraY * Map.TileSize) / Map.TileSize) + Int(_Height / Map.TileSize) + 1

    'xmin = Fix(Light.x / Map.TileSize) - 8
    'xmax = Fix(Light.x / Map.TileSize) + 8
    'ymin = Fix(Light.y / Map.TileSize) - 8
    'ymax = Fix(Light.y / Map.TileSize) + 8
    If xmin < 0 Then xmin = 0
    If ymin < 0 Then ymin = 0
    If xmin > Map.MaxWidth Then xmax = Map.MaxWidth
    If ymax > Map.MaxWidth Then ymax = Map.MaxHeight

    For x = xmin To xmax
        For y = ymin To ymax

            dist = Int(Distance((x * Map.TileSize) + (Map.TileSizeHalf), (y * Map.TileSize) + (Map.TileSizeHalf), Light.x, Light.y)) - (Light.strength + (Int(Rnd * 8) - 4))
            If dist > 255 Then dist = 255
            newlight = ((Light.strength + (Int(Rnd * 4) - 2)) - dist)
            If newlight > 255 Then newlight = 255


            Isview = ShadowView(Light.x - 7, Light.y, (x * Map.TileSize) + (Map.TileSizeHalf) + 8, (y * Map.TileSize) + (Map.TileSizeHalf), Map.TileSizeHalf, 10, 70, Light.angle, Light.fol)
            If Isview <> -1 Then newlight = (newlight - (Isview * 25))


            If Tile(x, y, 0).dlight < newlight Then Tile(x, y, 0).dlight = newlight
            If Tile(x, y, 0).dlight < 0 Then Tile(x, y, 0).dlight = 0
            If Tile(x, y, 0).dlight > 255 Then Tile(x, y, 0).dlight = 255
        Next
    Next

End Sub

Sub CalcLightingStatic (Light As LightSource)
    sizeoflight = Fix(Light.strength / 20)
    If sizeoflight > 20 Then sizeoflight = 20

    xmin = Fix(Light.x / Map.TileShadowSize) - sizeoflight
    xmax = Fix(Light.x / Map.TileShadowSize) + sizeoflight
    ymin = Fix(Light.y / Map.TileShadowSize) - sizeoflight
    ymax = Fix(Light.y / Map.TileShadowSize) + sizeoflight
    If xmin < 0 Then xmin = 0
    If ymin < 0 Then ymin = 0
    If xmin > Map.MaxWidth Then xmax = Map.MaxWidth
    If ymax > Map.MaxWidth Then ymax = Map.MaxHeight

    For x = xmin To xmax
        For y = ymin To ymax
            dist = Int(Distance((x * Map.TileShadowSize) + (Map.TileShadowSize / 2), (y * Map.TileShadowSize) + (Map.TileShadowSize / 2), Light.x, Light.y)) - (Light.strength + (Int(Rnd * 8) - 4))
            If dist > 255 Then dist = 255
            newlight = ((Light.strength + (Int(Rnd * 8) - 4)) - dist)
            If newlight > 255 Then newlight = 255
            Isview = ShadowView(Light.x - 5, Light.y, (x * Map.TileShadowSize) + (Map.TileShadowSize / 2) + 5, (y * Map.TileShadowSize) + (Map.TileShadowSize / 2), Map.TileShadowSize / 4, 5, 100, Light.angle, Light.fol)
            If Isview <> -1 Then newlight = (newlight - (Isview * 6))

            If Tile(x, y, 0).alight < newlight Then Tile(x, y, 0).alight = newlight
            If Tile(x, y, 0).alight < 0 Then Tile(x, y, 0).alight = 0
            If Tile(x, y, 0).alight > 255 Then Tile(x, y, 0).alight = 255
        Next
    Next

End Sub




Sub LogicLightingDyn (Light As LightSource)
    Light.strength2 = Light.strength
    If Light.duration < 5 And Light.duration > 0 Then Light.strength2 = Light.strength2 / (5 - Light.duration)
    If Light.duration > 0 Then Light.duration = Light.duration - 1
    If Light.duration = 0 Then Light.exist = 0: Light.strength = 0


End Sub

Sub CreateDynamicLight (x As Double, y As Double, strength As Integer, duration As Integer, detail As String, ltype As String, extra1 As Double, extra2 As Double)
    For l = 1 To DynamicLightMax
        If DynamicLight(l).exist = 0 Then Exit For
        If l = DynamicLightMax Then Exit Sub
    Next
    LastDynLight = LastDynLight + 1: If LastDynLight = DynamicLightMax Then LastDynLight = 0
    DynamicLight(l).x = x
    DynamicLight(l).y = y
    DynamicLight(l).detail = detail
    DynamicLight(l).strength = strength
    DynamicLight(l).strength2 = strength
    DynamicLight(l).duration = duration
    DynamicLight(l).exist = -1
    DynamicLight(l).lighttype = ltype
    Select Case ltype
        Case "Spot"
            DynamicLight(l).fol = extra1
            DynamicLight(l).angle = extra2

        Case "Normal"
            DynamicLight(l).fol = -1
            DynamicLight(l).angle = 0
    End Select
End Sub


Function LoadImage (Path As String, Mode As Integer)
    LoadImage = Missing
    If _FileExists(Path) Then
        LoadImage = _LoadImage(Path, Mode)
    Else
        Cls
        For i = 1 To 2 + Int(Rnd * 20)
            _PutImage (Int(Rnd * _Width), Int(Rnd * _Height))-(Int(Rnd * _Width), Int(Rnd * _Height)), Missing
        Next
        Print "Error: Image not found."
        Print "Description: Image is missing, replacing with 'Missing.png' for now."
        Print ("Path: " + Path)
        _Display: Beep: _Delay 0.1
    End If
End Function



