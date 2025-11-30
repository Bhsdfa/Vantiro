Rem Made by Bhsdfa!
Rem Thanks to miojo157 (with player sprites and logo).
Rem File creation date: 27-Aug-24 (1:02 PM BRT)
Rem Apps used: TILED e QB64pe
Rem TILED: https://www.mapeditor.org/    -=-    QB64pe: https://qb64phoenix.com/
Const GameVersion = "1.1v09b": Const IsBetaVersion = 1
Rem Vantiro.bas:

$Let DEBUGOUTPUT = -1
$If DEBUGOUTPUT Then
    $Console
    _Console On
    _ConsoleTitle "Debug log."
    _Echo ("INFO - Current Game version: " + GameVersion)
$End If

Rem Monsters to add:
Rem Archville (basically from doom II)

Rem Weapon suggestion to add:
Rem fire guns:
Rem AK-47,  .45 Schofield,  RPG

Rem Throwables:
Rem Molotov,  Snowball

Rem Melee:
Rem Baseball bat,  Knife,  Axe,
Dim Shared ShowLight

'GAME IS PROGRAMMED WINDOWS FIRST HAND, ERRORS ON LINUX MIGHT TAKE LONGER TO BE FIXED.
Dim Shared MainScreen: Dim Shared SecondScreen
MainScreen = _NewImage(1230, 662, 32): SecondScreen = _NewImage(1230, 662, 32)
Screen MainScreen
Const PI = 3.14159265359: Const PIDIV180 = PI / 180
_DisplayOrder _Hardware , _Software
'$Dynamic
$Checking:On
$Resize:On


Dim Shared AssetPath As String
Dim Shared AssetPack As String
AssetPath = "assets/Vantiro-1.1v09b/Resources/"
AssetPack = "Default"

Const IHaveGoodPC = 1

Dim Shared MissingTexture
MissingTexture = _LoadImage("assets/MissingTexture.png")


Dim Shared MissingSound
MissingSound = _SndOpen("MissingAudio.wav")
Icon = LoadImage(1, "Gui/VantiroLogo.png", 32)
_Icon Icon, Icon
_Title "Vantiro"

Randomize Timer
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
    Hud_SelectedColor As _Unsigned Long
    Hud_UnSelectedColor As _Unsigned Long
    Hud_Distselmult As Double
    Hud_Distselfall As Double
    Hud_SelRed As Integer
    Hud_SelGreen As Integer
    Hud_SelBlue As Integer
    Hud_UnSelRed As Integer
    Hud_UnSelGreen As Integer
    Hud_UnSelBlue As Integer
    Map_Lighting As _Byte
    'Player
    Player_MaxHealth As Double
    Player_Size As Double
    Player_MaxSpeed As Double
    Player_Accel As Double
    Player_Accuracy As Double
    Player_HealthPerBlood As Double
    Player_DamageMultiplier As Double
    'Waves
    Wave_End As Integer
    Wave_ZombieMultiplier As Double
    Wave_TimeLimit As Long
    Wave_ZombieRandom As Integer
    'Zombie
    'Limits
    ParticlesMax As _Unsigned Integer
    EnemiesMax As _Unsigned Integer
    FireMax As _Unsigned Integer
End Type
Dim Shared Config As Config
'Default Configs:
LoadDefaultConfigs
LoadConfig.INI
Type Controls
    XMove As Double
    YMove As Double
    Interact1 As _Byte
    Interact2 As _Byte
    Shoot As _Byte
    Aim As _Byte
    Reload As _Byte
    DropItem As _Byte
End Type
Dim Shared Joy As Controls
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
Type Entity
    X As Double
    Y As Double
    X1 As _Unsigned Long
    Y1 As _Unsigned Long
    X2 As _Unsigned Long
    Y2 As _Unsigned Long
    XM As Double
    YM As Double
    Size As Double
    Rotation As Double
    Exist As _Byte

    'Properties
    Weight As Integer
    Health As Double
    Damage As Double
    D_Speed As Double
    Speed As Double
    DamageTaken As Double
    Sprite As _Unsigned Long
    Class As String
    ClassType As String
    EntName As String
    Smart As _Byte
    BreakBlocks As _Byte

    PathID As _Unsigned Integer
    Tick As _Unsigned _Byte
    AIstate As String ' can be: Chase, ChasePoint, Idle, Roaming and Retreat
    PointFollow As _Unsigned Integer
    PointAttempt As _Unsigned Integer
    TargetX As _Unsigned Long
    TargetY As _Unsigned Long
End Type

Type Player
    x As Double
    y As Double
    xb As Double
    yb As Double
    x1 As _Unsigned Long
    x2 As _Unsigned Long
    y1 As _Unsigned Long
    y2 As _Unsigned Long
    size As _Unsigned Integer
    xm As Double
    ym As Double
    Rotation As Double
    TouchX As Integer
    TouchY As Integer
    Health As Double
    DamageToTake As Integer
    DamageCooldown As Integer
    shooting As Double
End Type
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
    animation As String
    extra As Double
    extra2 As Double
    speed As Double
    angleanim As Double
    distanim As Double
    autoBE As _Byte
    speedDiv As Double
End Type
Type ArmAnim
    angleAnim As Double
    distAnim As Double
    ItemRot As Double
End Type
Type Raycast
    x As Double
    y As Double
    angle As Double
    damage As Double
    knockback As Double
    owner As Integer
End Type
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
Type Item
    exist As _Byte
    x As Double
    y As Double
    xm As Double
    ym As Double
    visible As _Byte
    cangrab As _Byte
    canuse As _Byte
    rotation As Double
    Image As Long
    ImageSize As Double
    ItemName As String
    InternalID As _Unsigned Long
    ItemType As String
    Extra1 As Double
    Extra2 As Double
    Extra3 As Double
    InSlot As _Unsigned Integer
    held As _Byte
    HandsNeeded As _Unsigned _Byte
    PickupV As _Byte
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
Type WeaponsLoaded
    Exists As _Byte
    InternalName As String
    VisualName As String
    UsesAmmo As _Unsigned Integer
    ShotsPerFire As _Unsigned Integer
    MagSize As Integer
    MagLimit As Integer
    BulletSpritePath As String
    BulletSprite As Long
    AmmoSpritePath As String
    AmmoSprite As Long
    ReloadTime As Double
    TimeBetweenShots As Double
    GunSprite As Long
    Spray As Double
    Recoil As Double
    JammingChance As Long
    ImageSize As Double
    HandsNeeded As _Unsigned _Byte
End Type
Type Particle
    x As Double
    y As Double
    z As Double
    txt As Integer
    xm As Double
    ym As Double
    zm As Double
    Rotation As Double
    RotationSpeed As Double
    PartID As String
    Size As Double
    Exist As _Unsigned Long
    DoLogic As _Unsigned Integer
    SpriteHandle As _Unsigned Long
    SoundHandle As _Unsigned Long
    CanGrab As _Byte
    WhenCollect As String
    DistPlayer As Integer
End Type
Type PlayerAnims
    Current As String
    Frame As _Unsigned Long
    LastFrame As _Unsigned Long
End Type
Type Waypoint
    Exist As _Byte
    Dist As _Unsigned Long
    Connections As Integer
    X As Double
    Y As Double
    Free As _Byte
    Calculated As _Byte
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
Type ZombieTypeList
    Size As _Unsigned Integer
    SizeRND As _Unsigned Integer
    Weight As _Unsigned Integer
    WeightRND As _Unsigned Integer
    Health As Long
    HealthRND As _Unsigned Integer
    Speed As Double
    SpeedRND As _Unsigned Integer
    Damage As Double
    DamageRND As _Unsigned Integer
    CanBreakBlocks As _Unsigned _Byte
    Smart As _Unsigned _Byte
    CanSpawnWith As String
End Type



Dim Shared LastItemID As _Unsigned Integer: LastItemID = 1
Dim Shared HudWeaponMax As _Unsigned Integer: HudWeaponMax = 16
Dim Shared SelectedHudID As _Unsigned Integer, LastSelectedHudID As _Unsigned Integer
Dim Shared rendcamerax1 As Long, rendcamerax2 As Long, rendcameray1 As Long, rendcameray2 As Long
Dim Shared HudImageHealth As Long: HudImageHealth = _NewImage(128, 128, 32)
Dim Shared LastWeaponID As _Unsigned Integer
Dim Shared LastPart As _Unsigned Integer
Dim Shared TileSet As Long
Dim Shared TileSetSoft As Long
Dim Shared CameraX As Double, CameraY As Double
Dim Shared CameraXM As Double, CameraYM As Double
Dim Shared GrenadeMax As _Unsigned Integer, FireMax As _Unsigned Integer
Dim Shared HUD_PlayerHealth, PlayerInteract, ShootDelay
Dim Shared HUD_BloodParticle As _Unsigned Integer
Dim Shared LastDynLight: LastDynLight = 0
Dim Shared StaticLightMax: StaticLightMax = 1
Dim Shared DynamicLightMax: DynamicLightMax = 80
Dim Shared BloodPickUpRadius As _Unsigned Long: BloodPickUpRadius = 800
Dim Shared GameMode As _Unsigned _Byte: GameMode = 0 '0 - Survival, 1 - Sandbox,
Dim Shared GameVersionImage As Long
Dim Shared Debug As _Byte
Dim Shared Debug_Noclip As _Byte
Dim Shared Debug_HideUI As _Byte
Dim Shared DefaultFont As Long
Dim Shared FontSized(1024) As _Unsigned Long
Dim Shared From0To101Images(101) As Long
Dim Shared WaveNumberImage As Long
Dim Shared InfectedNumberImage As Long
Dim Shared WaypointMax: WaypointMax = 1024
Dim Shared AIPath(512, WaypointMax) As _Unsigned Integer
Dim Shared WaypointJoints(WaypointMax, 16) As Integer


Dim Shared PlayerMember(2) As PlayerMembers
Dim Shared Player As Player
Dim Shared PlHands(3) As Long
Dim Shared Ray As Raycast
Dim Shared RayM(3) As Raycast
Dim Shared Item(32) As Item
Dim Shared Hud(16) As Hud
Dim Shared Hud2(32) As Hud
Dim Shared Mobs(Config.EnemiesMax) As Entity
Dim Shared Weapons(15) As WeaponsLoaded
Dim Shared Trigger(Map.Triggers) As Trigger
Dim Shared Map As Map
Dim Shared PL_Anim As PlayerAnims
Dim Shared Grenade(8) As Particle
Dim Shared Fire(Config.FireMax) As Particle
Dim Shared HUD_BloodParticle(32) As Particle
Dim Shared Part(Config.ParticlesMax) As Particle
Dim Shared StaticLight(StaticLightMax) As LightSource
Dim Shared DynamicLight(DynamicLightMax) As LightSource
Dim Shared Waypoint(WaypointMax) As Waypoint
Dim Shared WayDebug As Entity
Dim Shared ZoTypeList(16) As ZombieTypeList
PlayerSkin = 1

'----------------------------------------------------
'-               Setting up variables.              -
'----------------------------------------------------
For i = 1 To 32
    Hud2(i).x = _Width / 2: Hud2(i).y = _Height
Next
For i = 1 To HudWeaponMax
    Hud(i).x = _Width / 2: Hud(i).y = _Height
Next

LoadWeapons

For i = 1 To WaypointMax
    Waypoint(i).Connections = 0
    For i2 = 1 To 16
        WaypointJoints(i, i2) = -1
    Next
Next

Dim Shadowgradientold As Long
Shadowgradientold = _NewImage(256, 4, 32): _Dest Shadowgradientold: x = 0
For i = 255 To 0 Step -1: Line (x, 0)-(x, 4), _RGBA32(0, 0, 0, i): x = x + 1: Next
Dim Shared Shadowgradient As _Unsigned Long
Shadowgradient = _CopyImage(Shadowgradientold, 33): _FreeImage Shadowgradientold

For i = 1 To 2
    PlayerMember(i).autoBE = -1: PlayerMember(i).speedDiv = 1
Next



'Asset Time!
'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================
'------------------------------------------
'-                 SOUNDS                 -
'------------------------------------------
Dim Shared SND_ZombieShot(16) As _Unsigned Long
Dim Shared SND_ZombieWalk(4) As _Unsigned Long
Dim Shared SND_Explosion As _Unsigned Long
Dim Shared SND_GunFire(64, 4) As _Unsigned Long
Dim Shared SND_GunReload(64, 4) As _Unsigned Long
Dim Shared SND_GunShells(64, 4) As _Unsigned Long
Dim Shared SND_Blood(6) As _Unsigned Long
Dim Shared SND_GlassBreak(3) As _Unsigned Long
Dim Shared SND_GlassShard(4) As _Unsigned Long
Dim Shared SND_PlayerDamage As _Unsigned Long
Dim Shared SND_PlayerDeath As _Unsigned Long
Dim Shared SND_FlameThrower As _Unsigned Long
'------------------------------------------
'-                 IMAGES                 -
'------------------------------------------
'Entities
Dim Shared SPR_Player(16) As Long
Dim Shared SPR_PlayerHand(16) As Long
Dim Shared SPR_Zombie As Long
Dim Shared SPR_ZombieFast As Long
Dim Shared SPR_ZombieSlow As Long
Dim Shared SPR_ZombieFire As Long
Dim Shared SPR_ZombieBomb As Long
Dim Shared SPR_ZombieBrute As Long
Dim Shared PlayerSprite(4) As Long
Dim Shared PlayerHand(4) As Long
'GUI
Dim Shared GUI_VantiroTitle As Long
Dim Shared GUI_Background As Long
Dim Shared GUI_HudSelected As Long
Dim Shared GUI_HudNotSelected As Long
Dim Shared GUI_HudNoAmmo As Long
Dim Shared GUI_HealthOverlay As Long
Dim Shared GUI_HealthBackground As Long
'Particles
Dim Shared PAR_Interact As Long
Dim Shared PAR_BulletHole As Long
Dim Shared PAR_GlassShard As Long
Dim Shared PAR_BloodGreen As Long
Dim Shared PAR_BloodRed As Long
Dim Shared PAR_GibSkull As Long
Dim Shared PAR_GibBone As Long
Dim Shared PAR_Fire As Long
Dim Shared PAR_Smoke As Long
Dim Shared PAR_Explosion As Long
Dim Shared PAR_BloodDrop As Long
LoadAssets

'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================



_Font FontSized(20)
GameVersionImage = CreateImageText(GameVersionImage, "Vantiro " + GameVersion, 30)
'Input "Select a map", Map$
Map$ = "cave"
MapLoaded = LoadMapSettings(Map$)
LoadWaypoints
Dim Shared Tile(Map.MaxWidth + 20, Map.MaxHeight + 20, 3) As Tiles
ReDim Shared AIPath(512, WaypointMax) As _Unsigned Integer
'REDIM SHARED WaypointJoints(WaypointMax, 16) AS INTEGER


MapLoaded = LoadMap(Map$)
CloseIMG TileSet: TileSet = LoadImage(1, "Tilesets/" + _Trim$(Map.tileset) + ".png", 33)
CloseIMG TileSetSoft: TileSetSoft = LoadImage(1, "Tilesets/" + _Trim$(Map.tileset) + ".png", 32)


GoSub RestartEverything
Dim Shared PlayerSkin2
PlayerSkin2 = PlayerSkin


Timer On
lastwaypoint = 0
Dim Shared numberimage(10000)
For i = 0 To 9999
    numberimage(i) = CreateImageText(numberimage(i), Str$(i), 40)
Next
numberimage(10000) = CreateImageText(numberimage(i), "9999+", 40)
'Create shadow gradiant.

DynamicLight(1).strength = 100
DynamicLight(1).duration = -1
DynamicLight(1).detail = "High"
DynamicLight(1).exist = -1


If Config.Map_Lighting = 1 Then GoSub BakeLights
_Dest MainScreen
_Font FontSized(20)
Do
    _Limit 62
    FillJoy ' Get Player Keys
    If _KeyDown(91) And delay = 0 Then ShowLight = 1: delay = 20 ' "[" Key
    DynamicLight(1).x = (CameraX * Map.TileSize) + Mouse.x: DynamicLight(1).y = (CameraY * Map.TileSize) + Mouse.y
    LastHealth = Player.Health
    _KeyClear: Mouse.scroll = 0: While _MouseInput: Wend
    Mouse.x = _MouseX: Mouse.y = _MouseY
    Mouse.click = _MouseButton(1): Mouse.click2 = _MouseButton(2): Mouse.click3 = _MouseButton(3): Mouse.scroll = _MouseWheel
    If _KeyDown(45) And delay = 0 Then Mouse.scroll = -1: delay = 2
    If _KeyDown(61) And delay = 0 Then Mouse.scroll = 1: delay = 2
    If Joy.Interact1 Then UsingE = -1
    PlayerInteract = 0
    If PlayerInteract = 0 And UsingE And PlayerInteractPre = 0 Then PlayerInteract = 1
    PlayerInteractPre = UsingE
    UsingE = 0

    If _KeyDown(15104) And delay = 0 And Debug = 1 Then Debug_HideUI = Debug_HideUI + 1: delay = 20: If Debug_HideUI = 2 Then Debug_HideUI = 0
    If _KeyDown(17408) And delay = 0 And Debug = 1 Then Debug_NoAI = Debug_NoAI + 1: delay = 20: If Debug_NoAI = 2 Then Debug_NoAI = 0
    If _KeyDown(118) And delay = 0 And Debug = 1 Then Debug_Noclip = Debug_Noclip + 1: delay = 20: If Debug_Noclip = 2 Then Debug_Noclip = 0

    If Player.Health > Config.Player_MaxHealth Then Player.Health = Player.Health - 0.05
    If Player.Health < 0 Then Player.Health = 0




    Cls
    ff% = ff% + 1
    If Timer - start! >= 1 Then fps% = ff%: ff% = 0: start! = Timer
    If delay > 0 Then delay = delay - 1
    If ShootDelay > 0 Then ShootDelay = ShootDelay - 1
    If _KeyDown(114) And Debug = 1 Then Player.Health = 100: PlayerCantMove = 0: DeathTimer = 0
    _SetAlpha 0, _RGB32(0, 0, 0), MainScreen

    ParticleLogicHandler
    ItemLogic
    HandsCode
    If PlayerCantMove = 0 Then PlayerMovement
    Player.shooting = 0
    Mob_EntityHandler
    If _KeyDown(47) Then EditAnims
    RenderGame

    GoSub TriggerPlayer

    If Freecam = 0 Then
        CameraX = (Player.x / Map.TileSize) - (_Width / (Map.TileSize * 2))
        CameraY = (Player.y / Map.TileSize) - (_Height / (Map.TileSize * 2))
        CameraX = CameraX + CameraXM / 100
        CameraY = CameraY + CameraYM / 100
    End If
    CameraXM = CameraXM / 1.1
    CameraYM = CameraYM / 1.1

    If _KeyDown(15616) And delay = 0 Then
        Debug = Debug + 1: delay = 20
        If Debug = 2 Then Debug = 0: _Console Off
        If Debug = 1 Then _Console On
    End If
    If Debug = 1 And delay = 0 Then
        If _KeyDown(15360) Then ZombieAIchoose = ZombieAIchoose + 1: delay = 20: If ZombieAIchoose = 2 Then ZombieAIchoose = 0
        If _KeyDown(102) Then Freecam = Freecam + 1: delay = 20: If Freecam = 2 Then Freecam = 0
        GoSub WaypointDebug
        Print "way1: "; way1
        Print "way2: "; way2
        Print "wayconnect: "; wayconnect
    End If
    If _KeyDown(18176) And delay = 0 Then delay = 60: Beep: LoadConfigs
    If (_KeyDown(15616) + _KeyDown(116)) = -2 And delay = 0 Then Input "What Texture to use?", AssetPack: LoadAssets: delay = 10
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


    If Mouse.scroll = -1 And PlayerCantMove = 0 Then HudChange = 1: WantSlot = 0
    If Mouse.scroll = 1 And PlayerCantMove = 0 Then HudChange = -1: WantSlot = 0


    GoSub DrawHud
    _PutImage (HudXCenter - 8, HudYCenter - 8)-(HudXCenter + 8, HudYCenter + 8), PlayerHand(PlayerSkin2)
    'If HideUI = 0 Then GoSub MiniMapCode


    If Sandbox = 1 Then GoSub Sandbox
    GoSub HealthHud
    If HideUI = 0 Then _PutImage (_Width - 128, _Height - 128)-(_Width, _Height), HudImageHealth
    If Debug = 1 Then
        XCalc = WTS(Fix(Player.x / Map.TileSize), CameraX)
        YCalc = WTS(Fix(Player.y / Map.TileSize), CameraY)
        Line (XCalc, YCalc)-(XCalc + Map.TileSize, YCalc + Map.TileSize), _RGBA32(255, 255, 255, 150), BF
    End If


    If _KeyDown(121) And delay = 0 Then DynamicLight(1).strength = DynamicLight(1).strength + 20: delay = 5
    If _KeyDown(117) And delay = 0 Then DynamicLight(1).strength = DynamicLight(1).strength - 20: delay = 5

    If IsBetaVersion = 1 Then _PutImage (_Width - _Width(GameVersionImage), 0), GameVersionImage
    Print "Fps: "; fps%

    If Debug = 1 Then
        Print "Player.x: "; Player.x
        Print "Player.y: "; Player.y
        Line (ETSX(WayDebug.X) - 16, ETSY(WayDebug.Y) - 16)-(ETSX(WayDebug.X) + 16, ETSY(WayDebug.Y) + 16), _RGBA32(255, 255, 128, 128), BF
        For w = 0 To WaypointMax
            If Waypoint(w).Calculated > 0 Then
                Line (ETSX(Waypoint(w).X) - 16, ETSY(Waypoint(w).Y) - 16)-(ETSX(Waypoint(w).X) + 16, ETSY(Waypoint(w).Y) + 16), _RGB32(0, 255, 0), B
                Line (ETSX(Waypoint(w).X) - 16, ETSY(Waypoint(w).Y) - 16)-(ETSX(Waypoint(w).X) + 16, ETSY(Waypoint(w).Y) + 16), _RGBA32(0, 255, 0, 128), BF
            Else
                Line (ETSX(Waypoint(w).X) - 16, ETSY(Waypoint(w).Y) - 16)-(ETSX(Waypoint(w).X) + 16, ETSY(Waypoint(w).Y) + 16), _RGB32(255, 0, 0), B
                Line (ETSX(Waypoint(w).X) - 16, ETSY(Waypoint(w).Y) - 16)-(ETSX(Waypoint(w).X) + 16, ETSY(Waypoint(w).Y) + 16), _RGBA32(255, 0, 0, 128), BF
            End If


            _PutImage (ETSX(Waypoint(w).X) - 16, ETSY(Waypoint(w).Y) + 16), DisplayNumber(Waypoint(w).Dist)
            _PutImage (ETSX(Waypoint(w).X) - 16, ETSY(Waypoint(w).Y) - 16)-(ETSX(Waypoint(w).X), ETSY(Waypoint(w).Y)), DisplayNumber(w)

            For i2 = 1 To Waypoint(w).Connections

                If Waypoint(WaypointJoints(w, i2)).Calculated > 2 Then
                    Line (ETSX(Waypoint(w).X), ETSY(Waypoint(w).Y))-(ETSX(Waypoint(WaypointJoints(w, i2)).X), ETSY(Waypoint(WaypointJoints(w, i2)).Y)), _RGBA32(0, 255, 0, 200)
                Else
                    Line (ETSX(Waypoint(w).X), ETSY(Waypoint(w).Y))-(ETSX(Waypoint(WaypointJoints(w, i2)).X), ETSY(Waypoint(WaypointJoints(w, i2)).Y)), _RGBA32(255, 0, 0, 200)
                End If

            Next

        Next
        'Waypoint(WaypointJoints(ID, i)).dist

        '+
        If _KeyDown(43) Then WayDebug.X = Player.x: WayDebug.Y = Player.y

        '-
        If _KeyDown(45) Then
            WayDebug.TargetX = Player.x
            WayDebug.TargetY = Player.y
            AI_Generic_FindPoints WayDebug
        End If

    End If


    If _KeyDown(108) And delay = 0 Then SpawnMob Player.x + 2, Player.y + 2, 5, 5, 32, "ZOMBIE", "NORMAL", "RandomName": delay = 10

    _Display
    If _KeyDown(39) And delay = 0 Then VantiroConsole

    If _WindowHasFocus Then GoSub ResizeScreen
Loop

BakeLights:
_Dest MainScreen
lightsfound = 0
Tiless = Map.MaxWidth * Map.MaxHeight * 2

For bakz = 1 To 2
    For bakx = 0 To Map.MaxWidth
        For baky = 0 To Map.MaxHeight
            TilesDone = TilesDone + 1
            Frames = Frames + 1
            Select Case Tile(bakx, baky, bakz).ID
                Case 5
                    StaticLight(1).x = bakx * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = baky * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 250
                    CameraX = ((bakx) - (_Width / (Map.TileSize * 2))): CameraY = ((baky) - (_Height / (Map.TileSize * 2)))
                    CalcLightingStatic StaticLight(1)

                Case 6
                    StaticLight(1).x = bakx * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = baky * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 200
                    CameraX = ((bakx) - (_Width / (Map.TileSize * 2))): CameraY = ((baky) - (_Height / (Map.TileSize * 2)))
                    CalcLightingStatic StaticLight(1)


                Case 34
                    StaticLight(1).x = bakx * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = baky * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CameraX = ((bakx) - (_Width / (Map.TileSize * 2))): CameraY = ((baky) - (_Height / (Map.TileSize * 2)))
                    CalcLightingStatic StaticLight(1)


                Case 35
                    StaticLight(1).x = bakx * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = baky * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CameraX = ((bakx) - (_Width / (Map.TileSize * 2))): CameraY = ((baky) - (_Height / (Map.TileSize * 2)))
                    CalcLightingStatic StaticLight(1)


                Case 36
                    StaticLight(1).x = bakx * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = baky * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CameraX = ((bakx) - (_Width / (Map.TileSize * 2))): CameraY = ((baky) - (_Height / (Map.TileSize * 2)))
                    CalcLightingStatic StaticLight(1)


                Case 37
                    StaticLight(1).x = bakx * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = baky * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CameraX = ((bakx) - (_Width / (Map.TileSize * 2))): CameraY = ((baky) - (_Height / (Map.TileSize * 2)))
                    CalcLightingStatic StaticLight(1)

                Case 38
                    StaticLight(1).x = bakx * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).y = baky * Map.TileSize + (Map.TileSizeHalf)
                    StaticLight(1).strength = 100
                    CameraX = ((bakx) - (_Width / (Map.TileSize * 2))): CameraY = ((baky) - (_Height / (Map.TileSize * 2)))
                    CalcLightingStatic StaticLight(1)

            End Select

        Next
    Next
Next
Return


WaypointDebug:
If _KeyDown(61) And delay = 0 And lastwaypoint < WaypointMax Then
    delay = 20
    lastwaypoint = lastwaypoint + 1
    Waypoint(lastwaypoint).X = ((Fix(Player.x / Map.TileSize)) * Map.TileSize) + Map.TileSize / 2
    Waypoint(lastwaypoint).Y = ((Fix(Player.y / Map.TileSize)) * Map.TileSize) + Map.TileSize / 2
    Waypoint(lastwaypoint).Exist = -1

End If

If _KeyDown(16640) And delay = 0 Then ' " ' " key, saves waypoints.
    delay = 30
    Open ("assets/Vantiro-1.1v09b/maps/" + Map$ + ".waypoints") For Input As #3
    Input #3, WaypointMax
    For i = 1 To WaypointMax

        Input #3, i, Waypoint(i).X, Waypoint(i).Y, Waypoint(i).Exist, Waypoint(i).Connections, WaypointJoints(i, 1), WaypointJoints(i, 2), WaypointJoints(i, 3), WaypointJoints(i, 4), WaypointJoints(i, 5), WaypointJoints(i, 6), WaypointJoints(i, 7), WaypointJoints(i, 8), WaypointJoints(i, 9), WaypointJoints(i, 10), WaypointJoints(i, 11), WaypointJoints(i, 12), WaypointJoints(i, 13), WaypointJoints(i, 14), WaypointJoints(i, 15), WaypointJoints(i, 16)
    Next
    Close #3
End If


If _KeyDown(20992) And delay = 0 Then 'INSERT KEY.
    delay = 10
    For i = 1 To WaypointMax
        If Distance((CameraX * Map.TileSize) + Mouse.x, (CameraY * Map.TileSize) + Mouse.y, Waypoint(i).X, Waypoint(i).Y) < Map.TileSize / 1.5 Then
            If way1 <> 0 Then way2 = i
            If way1 = 0 Then way1 = i
            If way1 <> 0 And way2 <> 0 Then
                For o = 1 To 16
                    If WaypointJoints(way1, o) = -1 Then WaypointJoints(way1, o) = way2: Exit For
                Next
                For o = 1 To 16
                    If WaypointJoints(way2, o) = -1 Then WaypointJoints(way2, o) = way1: Exit For
                Next

                Waypoint(way1).Connections = Waypoint(way1).Connections + 1
                Waypoint(way2).Connections = Waypoint(way2).Connections + 1
                way1 = 0
                way2 = 0
            End If
            Exit For
        End If
    Next
End If
Return

LightingBad:
For i = 1 To DynamicLightMax
    If DynamicLight(i).exist Then
        LogicLightingDyn DynamicLight(i)
        If IHaveGoodPC = 0 Then
            CalcLightingDynLow DynamicLight(i)
        Else
            Select Case DynamicLight(i).detail
                Case "High"
                    CalcLightingDynHigh DynamicLight(i)
                Case "Medium"
                    CalcLightingDynMedium DynamicLight(i)
                Case "Low"
                    CalcLightingDynLow DynamicLight(i)
            End Select
        End If
        'Line (ETSX(DynamicLight(i).x - 5), ETSY(DynamicLight(i).y - 5))-(ETSX(DynamicLight(i).x + 5), ETSY(DynamicLight(i).y + 5)), _RGB32(128, 255, 255), BF
    End If
Next
'render
For x = rendcamerax1 To rendcamerax2 'Map.MaxWidth
    For y = rendcameray1 To rendcameray2 'Map.MaxHeight

        XCalc = (WTS(x, CameraX))
        YCalc = (WTS(y, CameraY))
        XCalc2 = (XCalc + Map.TileSize)
        YCalc2 = (YCalc + Map.TileSize)


        light = Tile(x, y, 0).dlight + (Tile(x, y, 0).alight - Int(Rnd * 3))
        Tile(x, y, 0).dlight = 0

        _PutImage (XCalc, YCalc)-(XCalc2, YCalc2), Shadowgradient, 0, (light / (Tile(x, y, 0).toplayer / 2), 0)-(light / (Tile(x, y, 0).toplayer / 2), 1)
    Next
Next

ShowLight = 0
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
    Loop
    If _MouseWheel <> 0 Then Mouse.scroll = _MouseWheel

    RenderLayers
    RenderMobs

    RenderDisplayGun
    RenderTopLayer

    For i = 1 To HudWeaponMax
        GoSub Hud1Rendering
    Next

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

        End If


        For i = 1 To 7

            HudLogic Hud2(i), 0, i, SelectedHud2ID, LastSelectedHud2ID, Config.Hud_Side
            distsel = Abs(i - SelectedHud2ID)
            distcolor = 255 - (distsel * Config.Hud_Fade): If distcolor < 1 Then distcolor = 1

            Hud2(i).y1 = Hud2(i).y1 - (HudDown / 1.6): Hud2(i).y2 = Hud2(i).y2 - (HudDown / 1.6)

            If i = SelectedHud2ID Then
                Line (Hud2(i).x1, Hud2(i).y1)-(Hud2(i).x2, Hud2(i).y2), Config.Hud_SelectedColor, BF
                _MapTriangle (0, 0)-(16, 32)-(32, 0), GUI_HudSelected To(Hud2(i).x1, Hud2(i).y2)-(Hud(SelectedHudID).x, Hud(SelectedHudID).y1)-(Hud2(i).x2, Hud2(i).y2)
            End If
            If i <> SelectedHud2ID Then
                Line (Hud2(i).x1, Hud2(i).y1)-(Hud2(i).x2, Hud2(i).y2), _RGBA32(Config.Hud_UnSelRed, Config.Hud_UnSelGreen, Config.Hud_UnSelBlue, 32), BF
                If i < SelectedHud2ID And Hud2(i).y2 < _Height Then _MapTriangle (0, 0)-(16, 32)-(32, 0), GUI_HudNotSelected To(Hud2(i).x1, Hud2(i).y2)-(Hud(SelectedHudID).x1, (Hud(SelectedHudID).y1 + Hud(SelectedHudID).size / 2))-(Hud2(i).x2, Hud2(i).y2)
                If i > SelectedHud2ID And Hud2(i).y2 < _Height Then _MapTriangle (0, 0)-(16, 32)-(32, 0), GUI_HudNotSelected To(Hud2(i).x1, Hud2(i).y2)-(Hud(SelectedHudID).x2, (Hud(SelectedHudID).y1 + Hud(SelectedHudID).size / 2))-(Hud2(i).x2, Hud2(i).y2)
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
    RenderHudArrow Hud(i), HudXCenter, HudYCenter, GUI_HudSelected
End If
If i <> SelectedHudID Then
    RenderHudArrow Hud(i), HudXCenter, HudYCenter, GUI_HudNotSelected
End If

If i <= LastWeaponID Then _PutImage (Hud(i).x1, Hud(i).y1)-(Hud(i).x2, Hud(i).y2), Weapons(i).GunSprite
Return


HealthHud:
ValueDis = Abs(HUD_PlayerHealth - Player.Health)
If Player.Health > HUD_PlayerHealth Then HUD_PlayerHealth = HUD_PlayerHealth + (ValueDis / 20)
If Player.Health < HUD_PlayerHealth Then HUD_PlayerHealth = HUD_PlayerHealth - (ValueDis / 20)

If LastHealth > Player.Health Then
    For x = 1 To Fix((LastHealth - Int(Player.Health)) / 4)
        HUD_BloodParticle = HUD_BloodParticle + 1: If HUD_BloodParticle > 32 Then HUD_BloodParticle = 1
        HUD_BloodParticle(HUD_BloodParticle).x = 64 ' Int(Rnd * _Width(HeartPercent))
        HUD_BloodParticle(HUD_BloodParticle).y = _Width(HudImageHealth)
        HUD_BloodParticle(HUD_BloodParticle).xm = Int(Rnd * 100) - 50
        HUD_BloodParticle(HUD_BloodParticle).ym = -(80 + Int(Rnd * 50))

    Next
End If
If LastHealth <> HUD_PlayerHealth Then
    If Player.Health < 0 Then Player.Health = 0
    PHealth = Player.Health
    If PHealth > 101 Then PHealth = 101
    'IF HeartPercent <> 0 THEN _FREEIMAGE HeartPercent
    HeartPercent = From0To101Images(PHealth)
    _SetAlpha 64, _RGBA32(1, 1, 1, 1) To _RGBA32(255, 255, 255, 255), HeartPercent
End If
_Dest HudImageHealth
Line (0, 0)-(_Width, _Height), _RGB32(0, 0, 0), BF
For i = 1 To 32
    If HUD_BloodParticle(i).Exist = 1 Then
        HUD_BloodParticle(i).x = HUD_BloodParticle(i).x + HUD_BloodParticle(i).xm / 10
        HUD_BloodParticle(i).y = HUD_BloodParticle(i).y + HUD_BloodParticle(i).ym / 10
        If HUD_BloodParticle(i).x > _Width Then HUD_BloodParticle(i).x = _Width: HUD_BloodParticle(i).xm = -HUD_BloodParticle(i).xm
        If HUD_BloodParticle(i).x < 0 Then HUD_BloodParticle(i).x = 0: HUD_BloodParticle(i).xm = -HUD_BloodParticle(i).xm
        If HUD_BloodParticle(i).ym > 0 Then RotoZoom HUD_BloodParticle(i).x, HUD_BloodParticle(i).y, PAR_BloodDrop, 1.5, HUD_BloodParticle(i).xm / 15
        If HUD_BloodParticle(i).ym < 0 Then RotoZoom HUD_BloodParticle(i).x, HUD_BloodParticle(i).y, PAR_BloodDrop, 1.5, 180 + HUD_BloodParticle(i).xm / 15
        If HUD_BloodParticle(i).y > _Width(HeartPercent) + 10 Then HUD_BloodParticle(i).Exist = 0
        If HUD_BloodParticle(i).y < -32 Then HUD_BloodParticle(i).Exist = 0
    End If
Next
RotHeartDisplay = -(Player.xm / 7)
If RotHeartDisplay > 75 Then RotHearDisplay = 75
If RotHeartDisplay < -75 Then RotHearDisplay = -75
RotoZoom _Width / 2 + (Player.xm / 50), ((Abs(HUD_PlayerHealth - 100) * (_Height / 100))), GUI_HealthBackground, 2.2, RotHeartDisplay

_PutImage ((_Width / 2) - _Width(HeartPercent) / 2, (_Height / 2) - _Height(HeartPercent) / 2), HeartPercent
_PutImage (0, 0)-(_Width, _Height), GUI_HealthOverlay

_Dest MainScreen
_ClearColor _RGB32(0, 255, 0), HudImageHealth
Return

RestartEverything:
SizeDelayMinimap = 6
Hud(1).rotation = 200
Wave = 0
WaveWait = 80
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
Mouse.click = 0
For i = 1 To GrenadeMax
    Grenade(i).x = 64
    Grenade(i).y = 64
    Grenade(i).z = 1
    Grenade(i).xm = 64
    Grenade(i).ym = 64
    Grenade(i).DoLogic = 0
    Grenade(i).Rotation = 0
    Grenade(i).RotationSpeed = 0
    Grenade(i).Exist = 0
Next

For i = 1 To FireMax
    Fire(i).Exist = 0
    Fire(i).txt = 0
    Fire(i).xm = 0
    Fire(i).ym = 0
    Fire(i).DoLogic = 0
Next
RenderLayer1 = 1
RenderLayer2 = 1
RenderLayer3 = 1
delay = 10

For i = 1 To Config.ParticlesMax
    Part(i).Exist = 0
    Part(i).DoLogic = 0
Next
PlayerCantMove = 0
DeathTimer = 0
PlayerIsOnFire = 0
Player.Health = 105
PlayerHealth = 105
Player.DamageToTake = 0

For i = 1 To 2
    PlayerMember(i).x = Player.x
    PlayerMember(i).y = Player.y
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



Sub WaveHandler

    WaveNumberImage = CreateImageText(WaveNumberImage, ("Wave: ") + Str$(Wave), 70)
    InfectedNumberImage = CreateImageText(InfectedNumberImage, (_Trim$(Str$(WaveBudget)) + " Infected coming..."), 40)


End Sub

Sub WaveAdvance



End Sub


Sub EditAnims
    Dim Arm1x As Double
    Dim Arm1y As Double
    Dim Arm2x As Double
    Dim Arm2y As Double
    Dim ArmLeftOrigin As Double
    Dim ArmRightOrigin As Double
    Player.Rotation = 0
    ArmLeftOrigin = Player.Rotation + 90
    ArmRightOrigin = Player.Rotation - 90
    Arm1x = Sin(ArmLeftOrigin * PIDIV180)
    Arm1y = -Cos(ArmLeftOrigin * PIDIV180)
    Arm2x = Sin(ArmRightOrigin * PIDIV180)
    Arm2y = -Cos(ArmRightOrigin * PIDIV180)

    Arm1x = Player.x + Arm1x * 32
    Arm1y = Player.y + Arm1y * 32
    Arm2x = Player.x + Arm2x * 32
    Arm2y = Player.y + Arm2y * 32
    DNoclip = Noclip
    Noclip = 1
    Do
        Cls: _Limit 30
        If _KeyDown(27) Then Exit Do
        While _MouseInput: Wend
        Mouse.x = _MouseX: Mouse.y = _MouseY
        Mouse.click = _MouseButton(1): Mouse.click2 = _MouseButton(2): Mouse.click3 = _MouseButton(3): Mouse.scroll = _MouseWheel
        _SetAlpha 0, _RGB32(0, 0, 0), MainScreen
        For o = 1 To 3
            If PlHands(o) > 0 Then
                PlayerHoldingItem Item(PlHands(o)), o
            End If
        Next


        Print "A - Previous Frame   |   D - Next Frame"

        If Mouse.click Then
            PlayerMember(1).distanim = Distance(ETSX(Arm1x), ETSY(Arm1y), Mouse.x, Mouse.y)
            dx = ETSX(Arm1x) - Mouse.x
            dy = ETSY(Arm1y) - Mouse.y
            PlayerMember(1).angleanim = ATan2(dy, dx) ' Angle in radians
            PlayerMember(1).angleanim = (PlayerMember(1).angleanim * 180 / PI) + 90
            If PlayerMember(1).angleanim >= 180 Then PlayerMember(1).angleanim = PlayerMember(1).angleanim - 179.9
            PlayerMember(1).angleanim = PlayerMember(1).angleanim - Player.Rotation
        End If
        If Mouse.click2 Then
            PlayerMember(2).distanim = Distance(ETSX(Arm2x), ETSY(Arm2y), Mouse.x, Mouse.y)
            dx = ETSX(Arm2x) - Mouse.x
            dy = ETSY(Arm2y) - Mouse.y
            PlayerMember(2).angleanim = ATan2(dy, dx) ' Angle in radians
            PlayerMember(2).angleanim = (PlayerMember(2).angleanim * 180 / PI) + 90
            If PlayerMember(2).angleanim >= 180 Then PlayerMember(2).angleanim = PlayerMember(2).angleanim - 179.9
            PlayerMember(2).angleanim = PlayerMember(2).angleanim - Player.Rotation
        End If
        If _KeyDown(114) Or _KeyDown(75) Then
            dx = ETSX(Player.x) - Mouse.x
            dy = ETSY(Player.y) - Mouse.y
            Player.Rotation = ATan2(dy, dx) ' Angle in radians
            Player.Rotation = (Player.Rotation * 180 / PI) + 90
            If Player.Rotation >= 180 Then Player.Rotation = Player.Rotation - 179.9
        End If

        HandsCode

        ZRender_PlayerHand
        RenderItems
        ZRender_Player
        _Display
    Loop

    Noclip = DNoclip

End Sub


Sub HandsCode
    Dim ArmLeftOrigin As Double
    Dim ArmRightOrigin As Double
    Dim RotationDifference As Double
    Dim Angleadded As Double

    ArmLeftOrigin = Player.Rotation + 90
    ArmRightOrigin = Player.Rotation - 90
    PlayerMember(1).xo = Sin(ArmLeftOrigin * PIDIV180)
    PlayerMember(1).yo = -Cos(ArmLeftOrigin * PIDIV180)
    PlayerMember(2).xo = Sin(ArmRightOrigin * PIDIV180)
    PlayerMember(2).yo = -Cos(ArmRightOrigin * PIDIV180)
    PlayerMember(1).xo = Player.x + PlayerMember(1).xo * 32
    PlayerMember(1).yo = Player.y + PlayerMember(1).yo * 32
    PlayerMember(2).xo = Player.x + PlayerMember(2).xo * 32
    PlayerMember(2).yo = Player.y + PlayerMember(2).yo * 32
    RotationDifference = Abs(Player.Rotation - PlayerRotOld)
    If RotationDifference > 90 Then RotationDifference = 180 - RotationDifference
    For i = 1 To 2
        If PlayerMember(i).speedDiv > 0 Then PlayerMember(i).speedDiv = PlayerMember(i).speedDiv - 1
        ' LINE (ETSX(Player.x), ETSY(Player.y))-(ETSX(PlayerMember(i).x), ETSY(PlayerMember(i).y)), _RGB32(255, 255, 255)
        Angleadded = PlayerMember(i).angleanim + Player.Rotation
        ArmsAnims PlayerMember(i), i
        If PlayerMember(i).autoBE = -1 Then
            PlayerMember(i).xbe = PlayerMember(i).xo + Sin((Angleadded) * PIDIV180) * PlayerMember(i).distanim
            PlayerMember(i).ybe = PlayerMember(i).yo + -Cos((Angleadded) * PIDIV180) * PlayerMember(i).distanim
        End If
        dx = (PlayerMember(i).x - PlayerMember(i).xbe): dy = (PlayerMember(i).y - PlayerMember(i).ybe)
        PlayerMember(i).angle = ATan2(dy, dx) ' Angle in radians
        PlayerMember(i).angle = (PlayerMember(i).angle * 180 / PI) + 90
        If PlayerMember(i).angle >= 180 Then PlayerMember(i).angle = PlayerMember(i).angle - 179.9
        PlayerMember(i).xvector = Sin(PlayerMember(i).angle * PIDIV180)
        PlayerMember(i).yvector = -Cos(PlayerMember(i).angle * PIDIV180)
        PlayerMember(i).speed = Distance(PlayerMember(i).x, PlayerMember(i).y, PlayerMember(i).xbe, PlayerMember(i).ybe) / 9
        If PlayerMember(i).autoBE = -1 Then PlayerMember(i).x = PlayerMember(i).x - (Player.xm / 10): PlayerMember(i).y = PlayerMember(i).y - (Player.ym / 10)
        PlayerMember(i).x = PlayerMember(i).x + (PlayerMember(i).xvector * PlayerMember(i).speed) / (PlayerMember(i).speedDiv + 1)
        PlayerMember(i).y = PlayerMember(i).y + (PlayerMember(i).yvector * PlayerMember(i).speed) / (PlayerMember(i).speedDiv + 1)
        If Noclip = 0 Then HandCollision PlayerMember(i)
        '      IF Distance(PlayerMember(i).x, PlayerMember(i).y, PlayerMember(i).xbe, PlayerMember(i).ybe) > 200 THEN PlayerMember(i).x = Player.x: PlayerMember(i).y = Player.y
    Next
End Sub


Sub PlayerMovement
    PlayerLogic
    Dim dx As Double
    Dim dy As Double
    If Mouse.click2 Then
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
    If Player.Rotation > 180 Then Player.Rotation = Player.Rotation - 180
    If Int(Player.Rotation) > -7 And Int(Player.Rotation) < 1 And Mouse.y > _Height / 2 Then Player.Rotation = 180
    'If Int(Player.Rotation) = -2 And Mouse.y > _Height / 2 Then Player.Rotation = 180
    If Player.TouchX = 0 Then
        If Joy.XMove > 0 Then Player.xm = Player.xm - Config.Player_Accel: hadmovex = 1
        If Joy.XMove < 0 Then Player.xm = Player.xm + Config.Player_Accel: hadmovex = 1
    End If
    If Player.TouchY = 0 Then

        If Joy.YMove < 0 Then Player.ym = Player.ym + Config.Player_Accel: hadmovey = 1
        If Joy.YMove > 0 Then Player.ym = Player.ym - Config.Player_Accel: hadmovey = 1
    End If
    If Player.TouchX > 0 Then Player.TouchX = Player.TouchX - 1
    If Player.TouchX < 0 Then Player.TouchX = Player.TouchX + 1
    If Player.TouchY > 0 Then Player.TouchY = Player.TouchY - 1
    If Player.TouchY < 0 Then Player.TouchY = Player.TouchY + 1

    If Player.xm < -Config.Player_MaxSpeed Then Player.xm = -Config.Player_MaxSpeed
    If Player.xm > Config.Player_MaxSpeed Then Player.xm = Config.Player_MaxSpeed
    If Player.ym < -Config.Player_MaxSpeed Then Player.ym = -Config.Player_MaxSpeed
    If Player.ym > Config.Player_MaxSpeed Then Player.ym = Config.Player_MaxSpeed

    Player.y = Player.y - (Player.ym / 10)
    Player.x = Player.x - (Player.xm / 10)


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

                If Tile(x, y, z).ID <> 0 Then _PutImage (XCalc, YCalc)-(XCalc + (Map.TileSize), YCalc + (Map.TileSize)), TileSet, 0, (Tile(x, y, z).x1t, Tile(x, y, z).y1t)-(Tile(x, y, z).x2t, Tile(x, y, z).y2t)
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
            If Tile(x, y, z).ID <> 0 Then _PutImage (XCalc, YCalc)-(XCalc + Map.TileSize, YCalc + Map.TileSize), TileSet, 0, (Tile(x, y, z).rend_spritex * Map.TextureSize, Tile(x, y, z).rend_spritey * Map.TextureSize)-(Tile(x, y, z).rend_spritex * Map.TextureSize + (Map.TextureSize - 1), Tile(x, y, z).rend_spritey * Map.TextureSize + (Map.TextureSize - 1))
        Next
    Next
End Sub



Sub RenderMobs
    For i = 1 To Config.EnemiesMax
        'If Debug = 1 Then Line (ETSX(Zombie(i).x1), ETSY(Zombie(i).y1))-(ETSX(Zombie(i).x2), ETSY(Zombie(i).y2)), _RGB32(255, 0, 255), BF
        If Mobs(i).Exist Then RotoZoomSized ETSX(Mobs(i).X), ETSY(Mobs(i).Y), Mobs(i).Sprite, Mobs(i).Size, Mobs(i).Rotation
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
    For o = 1 To 5
        Part(LastPart).x = x
        Part(LastPart).y = y
        Part(LastPart).z = 4
        Part(LastPart).xm = Int(Rnd * 512) - 256
        Part(LastPart).ym = Int(Rnd * 512) - 256
        Part(LastPart).zm = 8 + Int(Rnd * 10)
        Part(LastPart).PartID = "Smoke"
        Part(LastPart).Rotation = Int(Rnd * 360) - 180
        Part(LastPart).RotationSpeed = Int(Rnd * 128) - 64
        LastPart = LastPart + 1: If LastPart > Config.ParticlesMax Then LastPart = 0
    Next

    Part(LastPart).x = x
    Part(LastPart).y = y
    Part(LastPart).z = 1
    Part(LastPart).xm = Int(Rnd * 8) - 4
    Part(LastPart).ym = Int(Rnd * 8) - 4
    Part(LastPart).zm = 20 + Int(Size / 40)
    Part(LastPart).PartID = "Explosion"
    Part(LastPart).Rotation = Int(Rnd * 360) - 180
    Part(LastPart).RotationSpeed = Int(Rnd * 128) - 64
    LastPart = LastPart + 1: If LastPart > Config.ParticlesMax Then LastPart = 0

    Part(LastPart).x = x
    Part(LastPart).y = y
    Part(LastPart).z = 25
    Part(LastPart).xm = Int(Rnd * 8) - 4
    Part(LastPart).ym = Int(Rnd * 8) - 4
    Part(LastPart).zm = 10
    Part(LastPart).PartID = "Smoke"
    Part(LastPart).Rotation = Int(Rnd * 360) - 180
    Part(LastPart).RotationSpeed = Int(Rnd * 100) - 50
    LastPart = LastPart + 1: If LastPart > Config.ParticlesMax Then LastPart = 0



    dist = Distance(x, y, Player.x, Player.y)
    If dist < Size Then
        'Player.DamageToTake = Int(strength / (dist / 30))
        PlayerTakeDamage Player, x, y, Int(strength / (dist / 30)), Int(dist / 10)
    End If



End Sub

Function CreateImageText (Handle As Long, text As String, textsize As Integer)
    If Handle <> 0 Then _FreeImage Handle
    If text = "" Then text = " "
    _Font FontSized(textsize)
    thx = _PrintWidth(text)
    thy = _FontHeight(FontSized(textsize))
    Handleb = _NewImage(thx * 3, thy * 3, 32)
    _Dest Handleb
    _ClearColor _RGB32(0, 0, 0): _PrintMode _KeepBackground: _Font FontSized(textsize - 1): Print text + " "
    Handle = _NewImage(thx, thy, 32)
    _Dest MainScreen
    _PutImage (0, 0), Handleb, Handle
    _Font FontSized(20)
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


    Loop While quit < 4
    raycastingsimple = 1
End Function


Function IsInView (x As Double, y As Double, x2 As Double, y2 As Double, hitbox As Double, stepsize As Double, tolerance As Integer)
    IsInView = 0
    Dim Xvecsize As Double
    Dim Yvecsize As Double

    dx = x - x2: dy = y - y2
    Rotation = ATan2(dy, dx) ' Angle in radians
    Rotation = (Rotation * 180 / PI) + 90
    If Rotation > 180 Then Rotation = Rotation - 179.9
    Dim xvector As Double: Dim yvector As Double
    Ray.x = x: Ray.y = y
    amountsonwall = 0
    Xvecsize = xvector * stepsize
    Yvecsize = yvector * stepsize

    Do
        ' Line (0, 0)-(_Width, _Height), _RGBA(0, 0, 0, 4), BF
        '  oldrayx = Ray.x: oldrayy = Ray.y
        Ray.x = Ray.x + Xvecsize
        Ray.y = Ray.y + Yvecsize
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
    Dim Xvecsize As Double
    Dim Yvecsize As Double
    inittol = tolerance
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
    Xvecsize = xvector * stepsize
    Yvecsize = yvector * stepsize
    Do
        oldrayx = Ray.x: oldrayy = Ray.y
        Ray.x = Ray.x + Xvecsize
        Ray.y = Ray.y + Yvecsize
        If Not CheckIfBounds(Ray.x / Map.TileSize, Ray.y / Map.TileSize) Then Exit Function
        If ShowLight = 1 Then
            Line (ETSX(oldrayx), ETSY(oldrayy))-(ETSX(Ray.x), ETSY(Ray.y)), _RGBA32(255, 0, 0, 200)

        End If

        tx = Fix((Ray.x) / Map.TileSize): ty = Fix((Ray.y) / Map.TileSize)

        If CheckIfBounds(tx, ty) Then If Tile(tx, ty, 2).ID <> 0 And Tile(tx, ty, 2).transparent = 0 Then

                amountsonwall = amountsonwall + 5
                tolerance = tolerance - 1
                ShadowView = amountsonwall * 2
                If tolerance <= 0 Then ShadowView = amountsonwall * inittol: Exit Do
            End If
        End If
        If Ray.x + 1 >= x2 - hitbox Then If Ray.x - 1 <= x2 + hitbox Then If Ray.y + 1 >= y2 - hitbox Then If Ray.y - 1 <= y2 + hitbox Then Exit Do
    Loop

End Function

Function CheckIfBounds (x As Long, y As Long)
    CheckIfBounds = 0
    If x > 0 Then If y > 0 Then
            If x < Map.MaxWidth Then If y < Map.MaxHeight Then CheckIfBounds = -1
        End If
    End If
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


Sub raycasting (x As Double, y As Double, angle As Double, damage As Double, owner As Double, distallow As Long, bloodchance As Integer)
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
                    For o = 1 To 6
                        SpawnParticle Ray.x, Ray.y, 2, Int(Rnd * 128) - 64, Int(Rnd * 128) - 64, 60 + Int(Rnd * 120), 0, 0, Int(Rnd * 360) - 180, Int(Rnd * 30) - 15, "GLASSSHARD"
                    Next
                    If Tile(tx, ty, 2).ID = 56 Then _SndPlayCopy SND_GlassBreak(Int(1 + Rnd * 3)), 0.4
                    Tile(tx, ty, 2).ID = 0
                    Tile(tx, ty, 2).solid = 0
                    'Tile(tx, ty, 2).rend_spritex = 0
                    'Tile(tx, ty, 2).rend_spritey = 0
                End If
                If Tile(tx, ty, 2).fragile = 0 Then
                    If damage > 0 Then SpawnParticle Ray.x, Ray.y, 2, 0, 0, 8 + Int(Rnd * 12), 0, 0, Int(Rnd * 360) - 180, Int(Rnd * 10) - 5, "BULLETHOLE"
                    Exit Do
                End If
            End If
            steps2 = 0

        End If
    Loop While quit < 7


End Sub


Function Distance (x1, y1, x2, y2)
    Distance = Sqr(((x1 - x2) ^ 2) + ((y1 - y2) ^ 2))
End Function

Function DistanceLow (x1, y1, x2, y2)
    DistanceLow = Abs(x1 - x2) + Abs(y1 - y2)
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
    If Player.Health > 0 Then
        _SndPlay SND_PlayerDamage
    End If
End Sub

Sub EntityTakeDamage (Ent As Entity, X, Y, Damage)
    dx = Ent.X - X: dy = Ent.Y - Y
    Rotation = ATan2(dy, dx) ' Angle in radians
    Rotation = (Rotation * 180 / PI) + 90
    If Rotation > 180 Then Rotation = Rotation - 179.9
    xvector = Sin(Rotation * PIDIV180)
    yvector = -Cos(Rotation * PIDIV180)
    Ent.YM = Int(Ent.YM - ((yvector * (Damage * 35) / Ent.Weight)))
    Ent.XM = Int(Ent.XM - ((xvector * (Damage * 35) / Ent.Weight)))
    If (Ent.Health * 10) < Damage Then gib = 1
    Ent.DamageTaken = Abs(Damage)
    If gib = 0 And Ent.Health - Damage < 0 Then Ent.Health = 0
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
    PY1 = Ent.Y1 + Ent.YM / 100: PY2 = Ent.Y2 + Ent.YM / 100: PX1 = Ent.X1 + Ent.XM / 100: PX2 = Ent.X2 + Ent.XM / 100
    tx1 = Fix((PX1 - 1) / Map.TileSize): ty1 = Fix((PY1 + 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.XM < 0 Then Ent.X = Ent.X - Ent.XM / 100: Ent.XM = 5
    tx1 = Fix((PX1 - 1) / Map.TileSize): ty1 = Fix((PY2 - 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.XM < 0 Then Ent.X = Ent.X - Ent.XM / 100: Ent.XM = 5
    tx1 = Fix((PX2 + 1) / Map.TileSize): ty1 = Fix((PY1 + 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.XM > 0 Then Ent.X = Ent.X - Ent.XM / 100: Ent.XM = -5
    tx1 = Fix((PX2 + 1) / Map.TileSize): ty1 = Fix((PY2 - 10) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.XM > 0 Then Ent.X = Ent.X - Ent.XM / 100: Ent.XM = -5
    tx1 = Fix((PX1 + 10) / Map.TileSize): ty1 = Fix((PY1 - 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.YM < 0 Then Ent.Y = Ent.Y - Ent.YM / 100: Ent.YM = 5
    tx1 = Fix((PX1 + 10) / Map.TileSize): ty1 = Fix((PY2 + 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.YM > 0 Then Ent.Y = Ent.Y - Ent.YM / 100: Ent.YM = -5
    tx1 = Fix((PX2 - 10) / Map.TileSize): ty1 = Fix((PY1 - 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.YM < 0 Then Ent.Y = Ent.Y - Ent.YM / 100: Ent.YM = 5
    tx1 = Fix((PX2 - 10) / Map.TileSize): ty1 = Fix((PY2 + 1) / Map.TileSize)
    If Tile(tx1, ty1, 2).solid = 1 Then If Ent.YM > 0 Then Ent.Y = Ent.Y - Ent.YM / 100: Ent.YM = -5
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
    ETSX = e - (CameraX) * Map.TileSize
End Function
Function ETSY (e)
    ETSY = e - (CameraY) * Map.TileSize
End Function


Function WTS (w, Camera)
    WTS = (w - Camera) * Map.TileSize
End Function

Function STWX (s)
    STWX = (s + CameraX) / Map.TileSize
End Function
Function STWY (s)
    STWY = (s + CameraY) / Map.TileSize
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

Sub RotoZoomSized (X As Long, Y As Long, Image As Long, Sc1 As Single, Rotation As Single)
    Dim px(3) As Double: Dim py(3) As Double
    W& = _Width(Image&): H& = _Height(Image&): M# = (W& / H&)

    px(0) = -(Sc1) / 2: py(0) = -((Sc1)) / 2 / M#
    px(1) = -(Sc1) / 2: py(1) = ((Sc1)) / 2 / M#

    px(2) = (Sc1) / 2: py(2) = ((Sc1)) / 2 / M#
    px(3) = (Sc1) / 2: py(3) = -((Sc1)) / 2 / M#

    sinr! = Sin(-Rotation / 57.2957795131): cosr! = Cos(-Rotation / 57.2957795131)
    For i& = 0 To 3
        x2& = (px(i&) * cosr! + sinr! * py(i&)) + X
        y2& = (py(i&) * cosr! - px(i&) * sinr!) + Y
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
    Map.Title = MapName
    Open ("assets/Vantiro-1.1v09b/maps/" + MapName + ".map") For Input As #1
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
    If Rect1.x >= rect2.X1 Then
        If Rect1.x <= rect2.X2 Then
            If Rect1.y >= rect2.Y1 Then
                If Rect1.y <= rect2.Y2 Then
                    RayCollideEntity = -1
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

Sub LoadConfigs
    Dim trash$
    Open ("assets/Vantiro-1.1v09b/config.ini") For Input As #4
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
    Config.ParticlesMax = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.EnemiesMax = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Input #4, line$: InsEqual = InStr(1, line$, "=") + 1: InsApo = InStr(1, line$, "'") - 1
    Config.FireMax = Val(_Trim$((Mid$(line$, InsEqual, InsApo - InsEqual))))

    Close #4
    Config.Hud_SelRed = _Red32(Config.Hud_SelectedColor)
    Config.Hud_SelGreen = _Green32(Config.Hud_SelectedColor)
    Config.Hud_SelBlue = _Blue32(Config.Hud_SelectedColor)

    Config.Hud_UnSelRed = _Red32(Config.Hud_UnSelectedColor)
    Config.Hud_UnSelGreen = _Green32(Config.Hud_UnSelectedColor)
    Config.Hud_UnSelBlue = _Blue32(Config.Hud_UnSelectedColor)

End Sub

Sub SaveConfig
    Open ("assets/Vantiro-1.1v09b/config.ini") For Output As #4
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
    Print #4, "'# Limit settings."
    Print #4, "Config.ParticlesMax = " + _Trim$(Str$(Config.ParticlesMax)) + " ' (Def: 600)"
    Print #4, "Config.EnemiesMax = " + _Trim$(Str$(Config.EnemiesMax)) + " ' (Def: 190)"
    Print #4, "Config.FireMax = " + _Trim$(Str$(Config.FireMax)) + " ' (Def: 128)"
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
                newlight = newlight - (df)
            End If
            If Tile(x, y, 0).dlight < newlight Then Tile(x, y, 0).dlight = newlight
            If Tile(x, y, 0).dlight < 0 Then Tile(x, y, 0).dlight = 0
            If Tile(x, y, 0).dlight > 255 Then Tile(x, y, 0).dlight = 255
        Next
    Next


End Sub

Sub CalcLightingDynMedium (Light As LightSource)
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
            '  If dist > 255 Then dist = 255
            '    If dist > Light.strength * 5 Then Exit Sub
            newlight = ((Light.strength + (Int(Rnd * 8) - 4)) - dist)
            If newlight > 255 Then newlight = 255

            Isview = ShadowView(Light.x - 9, Light.y, (x * Map.TileSize) + (Map.TileSizeHalf) + 8, (y * Map.TileSize) + (Map.TileSizeHalf), Map.TileSizeHalf, 25, 5, Light.angle, Light.fol)
            If Isview <> -1 Then newlight = (newlight - (Isview * 7))

            If Tile(x, y, 0).dlight < newlight Then Tile(x, y, 0).dlight = newlight
            If Tile(x, y, 0).dlight < 0 Then Tile(x, y, 0).dlight = 0
            If Tile(x, y, 0).dlight > 255 Then Tile(x, y, 0).dlight = 255

            If ShowLight = 1 Then
                _Delay 0.01
                Line (WTS(x, CameraX), WTS(y, CameraY))-(WTS(x, CameraX) + Map.TileSize, WTS(y, CameraY) + Map.TileSize), _RGBA32(255, 255, 255, Tile(x, y, 0).dlight / 1.5), BF
                Line (ETSX(Light.x - 7), ETSY(Light.y))-(ETSX(Ray.x), ETSY(Ray.y)), _RGBA32(255, 0, 0, 255)
                _Display

            End If

        Next

    Next
    If ShowLight = 1 Then _Delay 0.25
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
            ' If dist > 255 Then Exit Sub ' dist = 255
            newlight = ((Light.strength + (Int(Rnd * 4) - 2)) - dist)
            If newlight > 255 Then newlight = 255


            Isview = ShadowView(Light.x - 7, Light.y, (x * Map.TileSize) + (Map.TileSizeHalf) + 8, (y * Map.TileSize) + (Map.TileSizeHalf), Map.TileSizeHalf, 5, 30, Light.angle, Light.fol)
            If Isview <> -1 Then newlight = (newlight - (Isview * 2))


            If Tile(x, y, 0).dlight < newlight Then Tile(x, y, 0).dlight = newlight
            If Tile(x, y, 0).dlight < 0 Then Tile(x, y, 0).dlight = 0
            If Tile(x, y, 0).dlight > 255 Then Tile(x, y, 0).dlight = 255

            If ShowLight = 1 Then
                _Delay 0.01
                Line (WTS(x, CameraX), WTS(y, CameraY))-(WTS(x, CameraX) + Map.TileSize, WTS(y, CameraY) + Map.TileSize), _RGBA32(255, 255, 255, Tile(x, y, 0).dlight / 1.5), BF
                Line (ETSX(Light.x - 7), ETSY(Light.y))-(ETSX(Ray.x), ETSY(Ray.y)), _RGBA32(255, 0, 0, 255)
                _Display

            End If
        Next
    Next
    If ShowLight = 1 Then _Delay 0.25
End Sub

Sub Lighting
    For i = 1 To 1 'DynamicLightMax
        If DynamicLight(i).exist Then
            LogicLightingDyn DynamicLight(i)
            If IHaveGoodPC = 0 Then
                CalcLightingDynLow DynamicLight(i)
            Else
                Select Case DynamicLight(i).detail
                    Case "High"
                        CalcLightingDynHigh DynamicLight(i)
                    Case "Medium"
                        CalcLightingDynMedium DynamicLight(i)
                    Case "Low"
                        CalcLightingDynLow DynamicLight(i)
                End Select
            End If
            'Line (ETSX(DynamicLight(i).x - 5), ETSY(DynamicLight(i).y - 5))-(ETSX(DynamicLight(i).x + 5), ETSY(DynamicLight(i).y + 5)), _RGB32(128, 255, 255), BF
        End If
    Next
    'render

    For x = rendcamerax1 To rendcamerax2 'Map.MaxWidth
        For y = rendcameray1 To rendcameray2 'Map.MaxHeight

            XCalc = (WTS(x, CameraX))
            YCalc = (WTS(y, CameraY))
            XCalc2 = (XCalc + Map.TileSize)
            YCalc2 = (YCalc + Map.TileSize)


            light = Tile(x, y, 0).dlight + (Tile(x, y, 0).alight - Int(Rnd * 3))
            Tile(x, y, 0).dlight = 0

            _PutImage (XCalc, YCalc)-(XCalc2, YCalc2), Shadowgradient, MainImage, (light / (Tile(x, y, 0).toplayer / 2), 0)-(light / (Tile(x, y, 0).toplayer / 2), 1)
        Next
    Next

    ShowLight = 0

End Sub

Sub CalcLightingStatic (Light As LightSource)
    sizeoflight = Fix(Light.strength / 23)
    'IF sizeoflight > 20 THEN sizeoflight = 20
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
            If Tile(x, y, 0).alight = 255 Then GoTo endofnext
            dist = Int(Distance((x * Map.TileSize) + (Map.TileSizeHalf), (y * Map.TileSize) + (Map.TileSizeHalf), Light.x, Light.y)) - (Light.strength + (Int(Rnd * 8) - 4))
            If dist > 255 Then dist = 255 ': EXIT SUB
            newlight = ((Light.strength + (Int(Rnd * 8) - 4)) - dist)
            If newlight > 255 Then newlight = 255
            Isview = ShadowView(Light.x - 5, Light.y, (x * Map.TileSize) + (Map.TileSizeHalf) + 5, (y * Map.TileSize) + (Map.TileSizeHalf), Map.TileSize / 2, 9, 12, Light.angle, Light.fol)
            If Isview <> -1 Then newlight = (newlight - (Isview * 3))

            If Tile(x, y, 0).alight < newlight Then Tile(x, y, 0).alight = newlight
            If Tile(x, y, 0).alight < 0 Then Tile(x, y, 0).alight = 0
            If Tile(x, y, 0).alight > 255 Then Tile(x, y, 0).alight = 255

            'Code to debug light:
            '   TilSize = Map.TileSize: Map.TileSize = Map.TileSize / 2: CameraX = FIX((xmin + xmax) / 2) - (_WIDTH / (Map.TileSize * 2)): CameraY = FIX((ymin + ymax) / 2) - (_HEIGHT / (Map.TileSize * 2)): CLS: _SETALPHA 0, _RGB32(0, 0, 0), MainScreen: RenderLayers: RenderTopLayer: Lighting: LINE (WTS(FIX((xmin + xmax) / 2), CameraX), WTS(FIX((ymin + ymax) / 2), CameraY))-(WTS(x, CameraX), WTS(y, CameraY)), _RGB32(255, 0, 0): _DISPLAY: Map.TileSize = TilSize

            endofnext:

        Next
    Next



End Sub

Sub RenderLighting
    For x9 = rendcamerax1 To rendcamerax2 'Map.MaxWidth
        For y9 = rendcameray1 To rendcameray2 'Map.MaxHeight

            XCalc = (WTS(x9, CameraX))
            YCalc = (WTS(y9, CameraY))
            XCalc2 = (XCalc + Map.TileSize)
            YCalc2 = (YCalc + Map.TileSize)


            light = Tile(x9, y9, 0).dlight + (Tile(x9, y9, 0).alight - Int(Rnd * 3))
            Tile(x9, y9, 0).dlight = 0

            _PutImage (XCalc, YCalc)-(XCalc2, YCalc2), Shadowgradient, 0, (light / (Tile(x9, y9, 0).toplayer / 2), 0)-(light / (Tile(x9, y9, 0).toplayer / 2), 1)
        Next
    Next
    ShowLight = 0
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


Function LoadImage (autopath As _Byte, BPath As String, Mode As Integer)
    Dim Path As String
    If autopath = 1 Then
        Path = AssetPath + AssetPack + "/Textures/" + BPath
    Else
        Path = BPath
    End If


    If _FileExists(Path) Then
        LoadImage = _LoadImage(Path, Mode)
        $If DEBUGOUTPUT Then
            _Echo ("INFO - F(LoadImage): Image loaded: " + BPath)
        $End If

    Else
        LoadImage = MissingTexture
        $If DEBUGOUTPUT Then
            _Echo ("MERROR - F(LoadImage): Image not found! ")
        $End If
    End If
End Function

Function SNDOPEN (autopath As _Byte, BPath As String)

    Dim Path As String
    If autopath = 1 Then
        Path = AssetPath + AssetPack + "/Sounds/" + BPath
    Else
        Path = BPath
    End If
    SNDOPEN = MissingAudio
    If _FileExists(Path) Then
        SNDOPEN = _SndOpen(Path)
        $If DEBUGOUTPUT Then
            _Echo ("INFO - F(SNDOPEN): Sound loaded: " + BPath)
        $End If

    Else
        SNDOPEN = MissingAudio
        $If DEBUGOUTPUT Then
            _Echo ("MERROR - F(SNDOPEN): Sound not found!")
        $End If

    End If
End Function

Sub LoadWeapons
    $If DEBUGOUTPUT Then
        _Echo ("INFO - S(LoadWeapons): Start loading...")
    $End If

    Cls
    LastWeaponID = 1
    Open ("assets/Vantiro-1.1v09b/guns/active.gun") For Input As #9
    Line Input #9, trash$
    Do
        Line Input #9, Gun$
        $If DEBUGOUTPUT Then
            _Echo ("INFO - S(LoadWeapons): Found: " + Gun$)
        $End If
        If _Trim$(Gun$) <> "# End Of File." Then
            LoadWeapon LastWeaponID, Gun$
            LastWeaponID = LastWeaponID + 1
        Else
            LastWeaponID = LastWeaponID - 1
            Exit Do
        End If
    Loop
    Close #9
    For i = 1 To LastWeaponID
        Weapons(i).BulletSprite = LoadImage(0, ("assets/Vantiro-1.1v09b/guns/sprites/" + Weapons(i).BulletSpritePath + ".png"), 33)
        Weapons(i).GunSprite = LoadImage(0, ("assets/Vantiro-1.1v09b/guns/sprites/" + Weapons(i).InternalName + ".png"), 33)
        Weapons(i).AmmoSprite = LoadImage(0, ("assets/Vantiro-1.1v09b/guns/sprites/" + Weapons(i).AmmoSpritePath + ".png"), 33)
    Next
End Sub

Sub LoadWeapon (ID As Long, Gun As String)
    Cls
    If _FileExists("assets/Vantiro-1.1v09b/guns/" + _Trim$(Gun) + ".gun") Then
        Weapons(ID).Exists = -1
        Open ("assets/Vantiro-1.1v09b/guns/" + _Trim$(Gun) + ".gun") For Input As #10
        Weapons(ID).InternalName = _Trim$(Gun)
        Do
            Line Input #10, Liner$
            If _Trim$(Liner$) = "# End Of File." Then Exit Do
            start = InStr(0, Liner$, " =") + 3

            ends = InStr(0, Liner$, " '")
            bytes = Abs(start - ends)
            Var$ = _Trim$(Left$(Liner$, start - 3))
            Select Case Var$
                Case "Name"
                    Weapons(ID).VisualName = _Trim$(Mid$(Liner$, start + 1, bytes - 2))
                Case "ImageSize"
                    Weapons(ID).ImageSize = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "HandsNeeded"
                    Weapons(ID).HandsNeeded = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "UsesAmmo"
                    Weapons(ID).UsesAmmo = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "ShotsPerFire"
                    Weapons(ID).ShotsPerFire = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "MagSize"
                    Weapons(ID).MagSize = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "MagLimit"
                    Weapons(ID).MagLimit = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "BulletSprite"
                    Weapons(ID).BulletSpritePath = (_Trim$(Mid$(Liner$, start + 1, bytes - 2)))
                Case "AmmoSprite"
                    Weapons(ID).AmmoSpritePath = (_Trim$(Mid$(Liner$, start + 1, bytes - 2)))
                Case "ReloadTime"
                    Weapons(ID).ReloadTime = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "TimeBetweenShots"
                    Weapons(ID).TimeBetweenShots = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "Spray"
                    Weapons(ID).Spray = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "Recoil"
                    Weapons(ID).Recoil = Val(_Trim$(Mid$(Liner$, start, bytes)))
                Case "JammingChance"
                    Weapons(ID).JammingChance = Val(_Trim$(Mid$(Liner$, start, bytes)))
            End Select


        Loop
        Close #10
        $If DEBUGOUTPUT Then
            _Echo ("INFO - S(LoadWeapon): Following stats:")
            _Echo ("{")
            _Echo ("    VisualName: " + Weapons(ID).VisualName)
            _Echo ("    ImageSize: " + Str$(Weapons(ID).ImageSize))
            _Echo ("    HandsNeeded: " + Str$(Weapons(ID).HandsNeeded))
            _Echo ("    UsesAmmo: " + Str$(Weapons(ID).UsesAmmo))
            _Echo ("    ShotsPerFire: " + Str$(Weapons(ID).ShotsPerFire))
            _Echo ("    MagSize: " + Str$(Weapons(ID).MagSize))
            _Echo ("    MagLimit: " + Str$(Weapons(ID).MagLimit))
            _Echo ("    BulletSpritePath: " + Weapons(ID).BulletSpritePath)
            _Echo ("    AmmoSprite: " + Weapons(ID).AmmoSpritePath)
            _Echo ("    ReloadTime" + Str$(Weapons(ID).ReloadTime))
            _Echo ("    TimeBetweenShots: " + Str$(Weapons(ID).TimeBetweenShots))
            _Echo ("    Spray: " + Str$(Weapons(ID).Spray))
            _Echo ("    Raw Spray: " + _Trim$(Mid$(Liner$, start, bytes)))
            _Echo ("    Recoil: " + Str$(Weapons(ID).Recoil))
            _Echo ("    JammingChance: " + Str$(Weapons(ID).JammingChance))
            _Echo ("}")
        $End If

    Else
        $If DEBUGOUTPUT Then
            _Echo ("WARN - S(LoadWeapon): " + _Trim$(Gun) + ".gun not found.")
        $End If
    End If
End Sub

Sub SpawnItem (IType As String, IName As String, Extra1 As Double, Extra2 As Double)
    ValidType = 0
    Select Case IType
        Case "Weapon"
            ValidType = 1
        Case "Usable"
            ValidType = 1
        Case "Gib"
            ValidType = 1
    End Select

    If ValidType = 1 Then
        Select Case IType
            Case "Weapon"
                For i = 0 To LastWeaponID
                    If Weapons(i).Exists = -1 Then
                        If Weapons(i).InternalName = IName Then
                            LastItemID = LastItemID + 1
                            Item(LastItemID).exist = -1
                            Item(LastItemID).canuse = -1
                            Item(LastItemID).Image = Weapons(i).GunSprite
                            Item(LastItemID).ItemName = IName
                            Item(LastItemID).ItemType = IType
                            Item(LastItemID).x = Player.x
                            Item(LastItemID).Extra1 = 200
                            Item(LastItemID).Extra2 = 200
                            Item(LastItemID).InternalID = i
                            Item(LastItemID).y = Player.y
                            Item(LastItemID).ImageSize = Weapons(i).ImageSize
                            Item(LastItemID).HandsNeeded = Weapons(i).HandsNeeded
                        End If
                    End If
                Next

            Case "Usable"


            Case "Gib"
        End Select



    Else
        $If DEBUGOUTPUT Then
            _Echo ("WARN - S(SpawnItem): Type '" + _Trim$(IType) + "' isn't a valid type.")
        $End If
    End If

End Sub

Sub VantiroConsole
    Delay = 20
    _AutoDisplay
    _KeyClear
    Print "Spawn type:"
    Print "z - Zombie"
    Print "i - Item "
    Input spawntype$

    If UCase$(spawntype$) = "I" Then
        Print "Available Names:"
        For i = 0 To LastWeaponID
            If Weapons(i).Exists = -1 Then
                Print " - "; Weapons(i).InternalName
            End If
        Next
        Input "Name", Namer$
        SpawnItem "Weapon", Namer$, 0, 0
    End If

    _Display
End Sub


Sub ItemLogic
    For i = 1 To 32
        If Item(i).ItemType = "Weapon" And Item(i).Extra3 > 0 Then Item(i).Extra3 = Item(i).Extra3 - 1
        Item(i).x = Item(i).x + Item(i).xm / 10
        Item(i).y = Item(i).y + Item(i).ym / 10
        For o = 1 To 3
            If Item(i).xm > 0 Then Item(i).xm = Item(i).xm - 1
            If Item(i).xm < 0 Then Item(i).xm = Item(i).xm + 1
            If Item(i).ym > 0 Then Item(i).ym = Item(i).ym - 1
            If Item(i).ym < 0 Then Item(i).ym = Item(i).ym + 1
        Next
    Next
End Sub

Sub RenderItems
    For i = 1 To 32

        If Item(i).exist = -1 Then
            RotoZoomSized ETSX(Item(i).x), ETSY(Item(i).y), Item(i).Image, Item(i).ImageSize, Item(i).rotation + 90
        End If
    Next
End Sub

Sub PlayerLogic
    'Check for nearby Items
    LowestDist = 99999
    LowestID = 0
    For i = 0 To 32
        If Item(i).exist = -1 And Item(i).held = 0 Then
            Dist = Distance(Item(i).x, Item(i).y, Player.x, Player.y)
            If Dist < Player.size * 7 Then

                If Joy.Interact2 = -1 Then
                    If Dist < LowestDist Then LowestDist = Dist: LowestID = i
                End If
                Item(i).PickupV = CheckIfPlayerCanGrab(Item(i))
                If Item(i).PickupV = -1 Then _PutImage (ETSX(Item(i).x) - 16, ETSY(Item(i).y) - 16)-(ETSX(Item(i).x) + 16, ETSY(Item(i).y) + 16), PAR_Interact
            End If
        End If
    Next
    If Joy.Interact2 = -1 Then PlayerGrabItem Item(LowestID), LowestID

    'Drop Items
    If Joy.DropItem = -1 Then
        For o = 3 To 1 Step -1
            If PlHands(o) <> 0 Then
                PlayerDropItem o
                Exit For
            End If
        Next
    End If
    'Hold Item

    For o = 1 To 3
        If PlHands(o) > 0 Then
            PlayerHoldingItem Item(PlHands(o)), o
            If Mouse.click = -1 Then CheckUseItem o
            Print ("Item(" + Str$(PlHands(o)) + ").extra1: " + Str$(Item(PlHands(o)).Extra1))
            Print ("Item(" + Str$(PlHands(o)) + ").extra2: " + Str$(Item(PlHands(o)).Extra2))
            Print ("Item(" + Str$(PlHands(o)) + ").extra3: " + Str$(Item(PlHands(o)).Extra3))
        End If

    Next


End Sub

Sub PlayerHoldingItem (It As Item, hands As _Unsigned _Byte)
    If hands < 3 Then
        It.x = PlayerMember(hands).x: It.y = PlayerMember(hands).y
        'It.x = PlayerMember(hands).x: It.y = PlayerMember(hands).y
    Else
        It.x = (PlayerMember(1).x + PlayerMember(2).x) / 2: It.y = (PlayerMember(1).y + PlayerMember(2).y) / 2
        'It.x = PlayerMember().x: It.y = PlayerMember(hands).y

    End If
    dx = ETSX(It.x) - Mouse.x: dy = ETSY(It.y) - Mouse.y
    It.rotation = ATan2(dy, dx) ' Angle in radians
    It.rotation = (It.rotation * 180 / PI) + 90
    If It.rotation > 180 Then It.rotation = It.rotation - 179.99

End Sub

Function CheckIfPlayerCanGrab (it As Item)
    CheckIfPlayerCanGrab = 0
    If it.HandsNeeded = 1 Then
        For o = 1 To 2
            If PlHands(o) = 0 And PlHands(3) = 0 Then CheckIfPlayerCanGrab = -1
        Next

    End If
    If it.HandsNeeded = 2 Then If PlHands(1) = 0 And PlHands(2) = 0 And PlHands(3) = 0 Then CheckIfPlayerCanGrab = -1

End Function

Sub PlayerGrabItem (It As Item, id As _Unsigned Integer)
    If It.HandsNeeded = 1 Then
        For o = 1 To 2
            If PlHands(o) = 0 And PlHands(3) = 0 Then
                PlayerMember(o).extra = id
                PlHands(o) = -1
                It.held = -1
                PlayerMember(o).autoBE = 0
                PlayerMember(o).speedDiv = 2
                PlayerMember(o).xbe = It.x: PlayerMember(o).ybe = It.y: PlayerMember(o).animation = "Grabbing"
                Exit For
            End If
        Next
    End If
    If It.HandsNeeded = 2 Then
        If PlHands(1) = 0 And PlHands(2) = 0 And PlHands(3) = 0 Then
            For o = 1 To 2
                PlayerMember(o).extra = id
                PlHands(3) = -1
                It.held = -1
                PlayerMember(o).autoBE = 0
                PlayerMember(o).speedDiv = 2
                PlayerMember(o).xbe = It.x: PlayerMember(o).ybe = It.y: PlayerMember(o).animation = "Grabbing"
            Next
        End If
    End If
End Sub

Sub ArmsAnims (Arm As PlayerMembers, armid As Integer)
    Dim DistPl As _Unsigned Long
    Dim Dist As _Unsigned Long
    'Arm.x = Arm.x + INT(RND * 2) - 1
    'Arm.y = Arm.y + INT(RND * 2) - 1
    Select Case Arm.animation
        Case "Grabbing"
            DistPl = Distance(Arm.x, Arm.y, Player.x, Player.y)
            Dist = Distance(Arm.x, Arm.y, Arm.xbe, Arm.ybe)
            Arm.xbe = Item(Arm.extra).x: Arm.ybe = Item(Arm.extra).y
            If DistPl > Player.size * 4.5 Then
                Arm.speedDiv = Arm.speedDiv + 2
                If Arm.speedDiv > 80 Then
                    Arm.animation = "Idle": Arm.autoBE = -1: Item(Arm.extra).held = 0: Arm.extra = 0: Arm.speedDiv = 2
                    PlHands(armid) = 0
                ElseIf DistPl > Player.size * 8 Then
                    Arm.animation = "Idle": Arm.autoBE = -1: Item(Arm.extra).held = 0: Arm.extra = 0: Arm.speedDiv = 2
                    PlHands(armid) = 0


                End If
            ElseIf Arm.speedDiv > 5 Then Arm.speedDiv = Arm.speedDiv - 3
            End If


            If Dist < 16 Then
                Arm.animation = "Idle"
                Arm.autoBE = -1
                If Item(Arm.extra).HandsNeeded = 1 Then PlHands(armid) = Arm.extra
                If Item(Arm.extra).HandsNeeded = 2 Then PlHands(3) = Arm.extra: PlHands(1) = 0: PlHands(2) = 0

                Arm.extra = 0
                Arm.speedDiv = 5
            End If



    End Select
End Sub




Sub HandCollision (Arm As PlayerMembers)
    oldx = Arm.x
    oldy = Arm.y
    If CheckTileID(Arm.x + 8, Arm.y, 2) <> 0 Then Arm.x = (Fix((Arm.x + 8) / Map.TileSize) * Map.TileSize) - 8: If Arm.speedDiv < (oldx - Arm.x) * 8 Then Arm.speedDiv = Arm.speedDiv + 2
    If CheckTileID(Arm.x - 8, Arm.y, 2) <> 0 Then Arm.x = (Fix((Arm.x - 8) / Map.TileSize) * Map.TileSize) + Map.TileSize + 8: If Arm.speedDiv < (oldx - Arm.x) * 8 Then Arm.speedDiv = Arm.speedDiv + 2
    If CheckTileID(Arm.x, Arm.y + 8, 2) <> 0 Then Arm.y = (Fix((Arm.y + 8) / Map.TileSize) * Map.TileSize) - 8: If Arm.speedDiv < (oldy - Arm.y) * 8 Then Arm.speedDiv = Arm.speedDiv + 2
    If CheckTileID(Arm.x, Arm.y - 8, 2) <> 0 Then Arm.y = (Fix((Arm.y - 8) / Map.TileSize) * Map.TileSize) + Map.TileSize + 8: If Arm.speedDiv < (oldy - Arm.y) * 8 Then Arm.speedDiv = Arm.speedDiv + 2
    $If DEBUGOUTPUT Then
        If Distance(Arm.x, Arm.y, Player.x, Player.y) > 500 Then _Echo ("WARN - S(HandCollision): Hands out of player bounds.")
    $End If

End Sub

Function CheckTileID (x As Double, y As Double, layer As _Unsigned _Byte)
    CheckTileID = 0
    tx = Fix((x) / Map.TileSize)
    ty = Fix((y) / Map.TileSize)
    CheckTileID = Tile(tx, ty, layer).ID
End Function


Sub CheckUseItem (Hand As Integer)
    id = PlHands(Hand)
    If Item(id).canuse = -1 Then
        Select Case Item(id).ItemType

            Case "Weapon"
                UseWeaponItem Item(id)

        End Select
    End If


End Sub

Sub UseWeaponItem (It As Item)

    ID = It.InternalID
    If It.Extra3 > 0 Then Exit Sub
    If Weapons(ID).Exists Then
        If It.Extra1 >= Weapons(ID).ShotsPerFire Then
            It.Extra1 = It.Extra1 - Weapons(ID).ShotsPerFire
            For b = 1 To Weapons(ID).ShotsPerFire
                spray = It.rotation + Int(Rnd * Weapons(ID).Spray) - (Weapons(ID).Spray / 2)
                BulletSpawn It.x, It.y, spray, 6, 2
                'It.xm = INT((SIN(rot * PIDIV180) * force) * 10) + xm
                'It.ym = INT((-COS(rot * PIDIV180) * force) * 10) + ym
                'SUB SpawnParticle (X AS DOUBLE, Y AS DOUBLE, Z AS DOUBLE, XM AS DOUBLE, YM AS DOUBLE, ZM AS DOUBLE, Size AS DOUBLE,Time as _unsigned integer, Rotation AS DOUBLE, RotationSpeed AS DOUBLE, PType AS STRING)
                Px = It.x + Int(Rnd * 10) - 5: Py = It.y + Int(Rnd * 10) - 5: Pz = 10
                Pxm = -Sin(spray * PIDIV180) * (Int(Rnd * 30) - 15)
                Pym = Cos(spray * PIDIV180) * (Int(Rnd * 30) - 15)
                SpawnParticle Px, Py, Pz, Pxm, Pym, 20, 16, 50, Int(Rnd * 360) - 180, 12, "SMOKE"
                It.Extra3 = Weapons(ID).TimeBetweenShots

            Next

        Else
            'reload proceedure
            If It.Extra2 > 0 Then
                It.Extra2 = It.Extra2 - 1
                It.Extra1 = Weapons(ID).MagSize
            Else
                'Fail Fire
            End If

        End If
    End If
End Sub

Sub BulletSpawn (X As Double, Y As Double, rot As Double, damage As Double, penetration As Double)
    raycasting X, Y, rot, damage, 1, 500, 99999
    Line (ETSX(X), ETSY(Y))-(ETSX(Ray.x), ETSY(Ray.y)), _RGB32(255, 0, 0)
End Sub

Sub PlayerDropItem (Hand As _Unsigned _Byte)
    Dim ID As Long
    ID = -1
    If PlHands(Hand) > 0 Then
        ID = PlHands(Hand)
        Item(PlHands(Hand)).held = 0
        PlHands(Hand) = 0

    End If

    If ID <> -1 Then ThrowItem Item(ID), Player.x, Player.y, -Player.xm, -Player.ym, Player.Rotation + (Int(Rnd * 40) - 20), 10
End Sub

Sub ThrowItem (It As Item, x As _Unsigned Long, y As _Unsigned Long, xm As Double, ym As Double, rot As Double, force As Double)
    It.x = x
    It.y = y
    It.xm = (Sin(rot * PIDIV180) * force) * 10 + xm
    It.ym = (-Cos(rot * PIDIV180) * force) * 10 + ym
    It.rotation = It.rotation + (Int(Rnd * 360) - 180) 'rot + INT(RND * 180)
    If It.rotation > 180 Then It.rotation = It.rotation - 179.9
    If It.rotation < -180 Then It.rotation = It.rotation + 179.9
End Sub

Sub FillJoy
    X = 0
    Y = 0
    Inte = 0
    Inte2 = 0

    ' IF _KEYDOWN(97) OR _KEYDOWN(65) OR _KEYDOWN(19200) AND X = 0 THEN X = X - 1 'A
    ' IF _KEYDOWN(100) OR _KEYDOWN(68) OR _KEYDOWN(19712) AND X = 0 THEN X = X + 1 'D


    ' IF _KEYDOWN(119) OR _KEYDOWN(87) OR _KEYDOWN(18432) AND Y = 0 THEN Y = Y - 1 'W
    ' IF _KEYDOWN(115) OR _KEYDOWN(83) OR _KEYDOWN(20480) AND Y = 0 THEN Y = Y + 1 'S
    Joy.YMove = Y
    Joy.XMove = X

    If _KeyDown(119) Then Joy.YMove = -1
    If _KeyDown(115) Then Joy.YMove = 1
    If _KeyDown(97) Then Joy.XMove = -1
    If _KeyDown(100) Then Joy.XMove = 1

    ' IF _KEYDOWN(101) OR _KEYDOWN(69) THEN Inte = -1
    Joy.Interact1 = _KeyDown(101)
    'IF _KEYDOWN(102) OR _KEYDOWN(70) THEN Inte2 = -1

    If Joy.Interact2 <> -2 Then Joy.Interact2 = Joy.Interact2 + _KeyDown(102)
    If Not _KeyDown(102) Then Joy.Interact2 = 0

    If Joy.DropItem <> -2 Then Joy.DropItem = Joy.DropItem + _KeyDown(113)
    If Not _KeyDown(113) Then Joy.DropItem = 0


End Sub

Sub ZRender_Player
    RotoZoom ETSX(Player.x), ETSY(Player.y), PlayerSprite(PlayerSkin2), 0.25, Player.Rotation
End Sub
Sub ZRender_PlayerHand
    For i = 1 To 2
        _PutImage (ETSX(PlayerMember(i).x) - 8, ETSY(PlayerMember(i).y) - 8)-(ETSX(PlayerMember(i).x) + 8, ETSY(PlayerMember(i).y) + 8), PlayerHand(PlayerSkin2)
    Next
End Sub

Sub ParticleLogic (Part As Particle)
    Part.DistPlayer = Distance(Player.x, Player.y, Part.x, Part.y)
    Part.Exist = Part.Exist - 1: If Part.Exist = 0 Then KillParticle Part
    Dim DistXGrab As _Unsigned Long
    Dim DistYGrab As _Unsigned Long

    ' -=-  Particle Physics  -=-
    If Fix(Part.z) <= 0 Then Part(i).z = 0
    Part.x = Part.x + (Part.xm / 10)
    Part.y = Part.y + (Part.ym / 10)
    Part.z = Part.z + (Part.zm / 10)
    Part.Rotation = Part.Rotation + Part.RotationSpeed
    Part.RotationSpeed = Part.RotationSpeed / 1.1
    If Part.z >= 0.5 Then Part.zm = Part.zm - 5

    Part.xm = Part.xm / 1.01
    Part.ym = Part.ym / 1.01


    If Part.z <= 0 Then Part.zm = Part.zm * -.4: Part.z = 0: Part.xm = (Part.xm / 1.7): Part.ym = (Part.ym / 1.7)
    If Fix(Part.z) = 0 Then Part.xm = (Part.xm / 2): Part.ym = (Part.ym / 2)


    '  -=-  PlayerCanGrab  -=-
    If Part.CanGrab And Part.DistPlayer < BloodPickUpRadius Then
        DistXGrab = ETSX(Part.x)
        DistYGrab = ETSY(Part.y)
        If DistXGrab < _Width And DistYGrab < _Height Then
            dx = Player.x - Part.x: dy = Player.y - Part.y
            Part.Rotation = ATan2(dy, dx) ' Angle in radians
            Part.Rotation = (Part.Rotation * 180 / PI) + 90
            If Part.Rotation > 180 Then Part.Rotation = Part.Rotation - 179.9
            Part.xm = Part.xm + -Sin(Part.Rotation * PIDIV180) * 5 / (Part.DistPlayer / (BloodPickUpRadius * 2))
            Part.ym = Part.ym + Cos(Part.Rotation * PIDIV180) * 5 / (Part.DistPlayer / (BloodPickUpRadius * 2))
            Part.z = 8 / (Part.DistPlayer / 70)
            If Part.z > 18 Then Part.z = 18
            If Part.DistPlayer < (Player.size * 1.5) Then PlayerPickUpParticle Part: KillParticle Part
        End If
    End If

End Sub
Sub PlayerPickUpParticle (Part As Particle)
    If Part.WhenCollect = "" Then Exit Sub
    Dim CommandsDone As _Byte
    Dim s_start As _Unsigned Integer
    Dim s_end As _Unsigned Integer
    Dim Commands As String
    Dim Value As String
    Do
        s_start = InStr(s_end, Part.WhenCollect, "{") + 1
        s_end = InStr(s_start, Part.WhenCollect, "}")
        s_com = InStr(s_start, Part.WhenCollect, ":")
        CommandsDone = 0
        '{SetHealth:20},{AddHealth:40}
        Commands = Mid$(Part.WhenCollect, s_start, s_com - s_start)
        Value = Mid$(Part.WhenCollect, s_com + 1, s_end - (s_com - 1))
        Select Case Commands
            Case "AddHealth"
                Player.Health = Player.Health + Val(Value)
                CommandsDone = 1
            Case "SetHealth"
                Player.Health = Val(Value)
                CommandsDone = 1
            Case "AmmoType"
                Dim AmmoType As String
                AmmoType = Value
                CommandsDone = 1
            Case "AddAmmo"
                CommandsDone = 1

        End Select
        $If DEBUGOUTPUT Then
            If CommandsDone = 0 Then _Echo ("WARN - S(PlayerPickUpParticle): Unknown command: '" + Commands + "'")
        $End If


    Loop While s_start <> 1

End Sub

Sub SpawnParticle (X As Double, Y As Double, Z As Double, XM As Double, YM As Double, ZM As Double, Size As Double, Time As _Unsigned Integer, Rotation As Double, RotationSpeed As Double, PType As String)

    LastPart = LastPart + 1
    If LastPart > Config.ParticlesMax Then LastPart = 0
    Part(LastPart).DoLogic = 0
    Part(LastPart).Exist = 0
    Part(LastPart).CanGrab = 0
    Part(LastPart).SpriteHandle = 0


    Part(LastPart).x = X
    Part(LastPart).y = Y
    Part(LastPart).z = Z
    Part(LastPart).xm = XM
    Part(LastPart).ym = YM
    Part(LastPart).zm = ZM
    Part(LastPart).Rotation = Rotation
    Part(LastPart).RotationSpeed = RotationSpeed
    Part(LastPart).PartID = PType

    Select Case UCase$(PType)
        Case "RED_BLOOD"
            Part(LastPart).CanGrab = -1
            Part(LastPart).DoLogic = 40
            Part(LastPart).Exist = 1400
            Part(LastPart).SpriteHandle = PAR_BloodRed
            Part(LastPart).Size = 24
            Part(LastPart).WhenCollect = "{AddHealth:1}"

        Case "GREEN_BLOOD"
            Part(LastPart).CanGrab = -1
            Part(LastPart).DoLogic = 40
            Part(LastPart).Exist = 1000
            Part(LastPart).SpriteHandle = PAR_BloodGreen
            Part(LastPart).Size = 24
            Part(LastPart).WhenCollect = "{AddHealth:0.5}"

        Case "FIRE"

        Case "GLASSSHARD"
            Part(LastPart).Exist = 1100
            Part(LastPart).Size = 30
            Part(LastPart).SpriteHandle = PAR_GlassShard

        Case "BULLETHOLE"
            Part(LastPart).Exist = 2000
            Part(LastPart).Size = 18
            Part(LastPart).SpriteHandle = PAR_BulletHole

        Case "SMOKE"
            Part(LastPart).Exist = 320
            Part(LastPart).DoLogic = 330
            Part(LastPart).SpriteHandle = PAR_Smoke
            Part(LastPart).Size = 80

        Case "EXPLOSION"
            Part(LastPart).Exist = 320
            Part(LastPart).DoLogic = 15
            Part(LastPart).SpriteHandle = PAR_Explosion
            Part(LastPart).Size = 128
    End Select
    If Size <> 0 Then Part(LastPart).Size = Size
    If Time <> 0 Then Part(LastPart).Exist = Time
    $If DEBUGOUTPUT Then
        If Part(LastPart).Exist = 0 Then _Echo ("WARN - S(SpawnParticle): Unknown particle: '" + UCase$(PType) + "'")
    $End If



End Sub

Sub KillParticle (Part As Particle)
    Part.DoLogic = 0
    Part.Exist = 0
    Part.CanGrab = 0
    Part.SpriteHandle = 0
    Part.Size = 16
    Part.x = 0
    Part.y = 0
    Part.z = 0
    Part.xm = 0
    Part.ym = 0
    Part.zm = 0
    Part.Rotation = 0
    Part.RotationSpeed = 0
    Part.PartID = ""
    Part.SpriteHandle = MissingTexture
End Sub

Sub ParticleLogicHandler
    For i = 1 To Config.ParticlesMax
        If Part(i).Exist > 0 Then
            ParticleLogic Part(i)
        End If
    Next
End Sub

Sub RenderGame
    RenderLayers
    For i = 1 To Config.ParticlesMax: If Part(i).Exist > 0 And Part(i).z < 5 Then RenderParticles Part(i)
    Next
    ZRender_Player
    ZRender_PlayerHand
    RenderItems

    RenderMobs
    'Particles
    For i = 1 To Config.ParticlesMax: If Part(i).Exist > 0 And Part(i).z >= 5 Then RenderParticles Part(i)
    Next
    RenderTopLayer
    If Config.Map_Lighting Then Lighting
    If Debug = 1 Then
        Print "LastPart: "; LastPart
    End If
End Sub

Sub RenderParticles (Part As Particle)
    FadeOut = 1
    If Part.Exist <= 20 Then FadeOut = Part.Exist / 20
    RotoZoomSized ETSX(Part.x), ETSY(Part.y), Part.SpriteHandle, (Part.Size + (Part.z / 2)) * FadeOut, Part.Rotation
    If Debug = 1 Then Line (ETSX(Player.x), ETSY(Player.y))-(ETSX(Part.x), ETSY(Part.y)), _RGB32(255, 255, 0)
End Sub
Sub CloseSND (Handle As _Unsigned Long)
    If Handle <> 0 Then _SndClose Handle
End Sub

Sub CloseIMG (Handle As _Unsigned Long)
    If Handle <> 0 Then _FreeImage Handle 'Problem before line 804
End Sub

Sub LoadAssets
    'Sounds:
    CloseSND SND_Explosion: SND_Explosion = SNDOPEN(1, "Particles/Explosion.mp3")
    CloseSND SND_Blood(1): SND_Blood(1) = SNDOPEN(1, "Particles/Flesh1.wav")
    CloseSND SND_Blood(2): SND_Blood(2) = SNDOPEN(1, "Particles/Flesh2.wav")
    CloseSND SND_Blood(3): SND_Blood(3) = SNDOPEN(1, "Particles/Flesh3.wav")
    CloseSND SND_Blood(4): SND_Blood(4) = SNDOPEN(1, "Particles/Flesh4.wav")
    CloseSND SND_Blood(5): SND_Blood(5) = SNDOPEN(1, "Particles/Flesh5.wav")
    CloseSND SND_Blood(6): SND_Blood(6) = SNDOPEN(1, "Particles/Flesh6.wav")
    CloseSND SND_GlassBreak(1): SND_GlassBreak(1) = SNDOPEN(1, "Particles/BreakGlass1.wav")
    CloseSND SND_GlassBreak(2): SND_GlassBreak(2) = SNDOPEN(1, "Particles/BreakGlass2.wav")
    CloseSND SND_GlassBreak(3): SND_GlassBreak(3) = SNDOPEN(1, "Particles/BreakGlass3.wav")
    CloseSND SND_GlassShard(1): SND_GlassShard(1) = SNDOPEN(1, "Particles/Glass1.wav")
    CloseSND SND_GlassShard(2): SND_GlassShard(2) = SNDOPEN(1, "Particles/Glass2.wav")
    CloseSND SND_GlassShard(3): SND_GlassShard(3) = SNDOPEN(1, "Particles/Glass3.wav")
    CloseSND SND_GlassShard(4): SND_GlassShard(4) = SNDOPEN(1, "Particles/Glass4.wav")
    For i = 1 To 4: CloseSND SND_ZombieWalk(i): SND_ZombieWalk(i) = SNDOPEN(1, ("Entities/Zombies/Ambient" + _Trim$(Str$(i)) + ".wav")): Next
    For i = 1 To 16: CloseSND SND_ZombieShot(i): SND_ZombieShot(i) = SNDOPEN(1, ("Entities/Zombies/Shot/Shot" + _Trim$(Str$(i)) + ".wav")): Next
    CloseSND SND_PlayerDamage: SND_PlayerDamage = SNDOPEN(1, "Player/Au.wav")
    CloseSND SND_PlayerDeath: SND_PlayerDeath = SNDOPEN(1, "Player/Ua.wav")
    CloseSND SND_FlameThrower: SND_FlameThrower = SNDOPEN(1, "Guns/FlameThrower.wav")

    'Entities:
    CloseIMG SPR_Zombie: SPR_Zombie = LoadImage(1, "Entities/Enemies/Normal.png", 33)
    CloseIMG SPR_ZombieFast: SPR_ZombieFast = LoadImage(1, "Entities/Enemies/Fast.png", 33)
    CloseIMG SPR_ZombieSlow: SPR_ZombieSlow = LoadImage(1, "Entities/Enemies/Slow.png", 33)
    CloseIMG SPR_ZombieBomb: SPR_ZombieBomb = LoadImage(1, "Entities/Enemies/Bomber.png", 33)
    CloseIMG SPR_ZombieFire: SPR_ZombieFire = LoadImage(1, "Entities/Enemies/Fire.png", 33)
    CloseIMG SPR_ZombieBrute: SPR_ZombieBrute = LoadImage(1, "Entities/Enemies/Normal.png", 33) 'GIVE ME IMAGE
    CloseIMG PlayerSprite(1): PlayerSprite(1) = LoadImage(1, "Entities/Player/player1.png", 33)
    CloseIMG PlayerHand(1): PlayerHand(1) = LoadImage(1, "Entities/Player/hand1.png", 33)
    CloseIMG PlayerSprite(2): PlayerSprite(2) = LoadImage(1, "Entities/Player/player2.png", 33)
    CloseIMG PlayerHand(2): PlayerHand(2) = LoadImage(1, "Entities/Player/hand1.png", 33)
    CloseIMG PlayerSprite(3): PlayerSprite(3) = LoadImage(1, "Entities/Player/player3.png", 33)
    CloseIMG PlayerHand(3): PlayerHand(3) = LoadImage(1, "Entities/Player/hand3.png", 33)
    CloseIMG PlayerSprite(4): PlayerSprite(4) = LoadImage(1, "Entities/Player/player4.png", 33)
    CloseIMG PlayerHand(4): PlayerHand(4) = LoadImage(1, "Entities/Player//hand4.png", 33)

    'GUI:
    CloseIMG GUI_VantiroTitle: GUI_VantiroTitle = LoadImage(1, "Gui/Vantiro.png", 33)
    CloseIMG GUI_Background: GUI_Background = LoadImage(1, "Gui/Background.png", 33)
    CloseIMG GUI_HudSelected: GUI_HudSelected = LoadImage(1, "Gui/Selected.png", 33)
    CloseIMG GUI_HudNotSelected: GUI_HudNotSelected = LoadImage(1, "Gui/NotSelected.png", 33)
    CloseIMG GUI_HudNoAmmo: GUI_HudNoAmmo = LoadImage(1, "Gui/NoAmmo.png", 33)
    CloseIMG GUI_HealthOverlay: GUI_HealthOverlay = LoadImage(1, "Gui/HealthOverlay.png", 32)
    CloseIMG GUI_HealthBackground: GUI_HealthBackground = LoadImage(1, "Gui/HealthBackground.png", 32)

    'Particles:
    CloseIMG PAR_Interact: PAR_Interact = LoadImage(1, "Particles/EKeyIcon.png", 33)
    CloseIMG PAR_BulletHole: PAR_BulletHole = LoadImage(1, "Particles/BulletHole.png", 33)
    CloseIMG PAR_GlassShard: PAR_GlassShard = LoadImage(1, "Particles/GlassShard.png", 33)
    CloseIMG PAR_BloodGreen: PAR_BloodGreen = LoadImage(1, "Particles/BloodGreen.png", 33)
    CloseIMG PAR_BloodRed: PAR_BloodRed = LoadImage(1, "Particles/BloodRed.png", 33)
    CloseIMG PAR_GibSkull: PAR_GibSkull = LoadImage(1, "Particles/Skull.png", 33)
    CloseIMG PAR_GibBone: PAR_GibBone = LoadImage(1, "Particles/Bone.png", 33)
    CloseIMG PAR_Fire: PAR_Fire = LoadImage(1, "Particles/Fire.png", 33)
    CloseIMG PAR_Smoke: PAR_Smoke = LoadImage(1, "Particles/Smoke.png", 33)
    CloseIMG PAR_Explosion: PAR_Explosion = LoadImage(1, "Particles/Explosion.png", 33)
    CloseIMG PAR_BloodDrop: PAR_BloodDrop = LoadImage(1, "Particles/BloodDrop.png", 32)

    CloseIMG TileSet: TileSet = LoadImage(1, "Tilesets/" + _Trim$(Map.tileset) + ".png", 33)
    CloseIMG TileSetSoft: TileSetSoft = LoadImage(1, "Tilesets/" + _Trim$(Map.tileset) + ".png", 32)

    For i = 1 To 1024
        If FontSized(i) <> 0 Then _FreeFont FontSized(i)
        FontSized(i) = _LoadFont((AssetPath + AssetPack + "/Font.ttf"), i, "")
    Next

    For i = 0 To 100
        From0To101Images(i) = CreateImageText(From0To101Images(i), _Trim$(Str$(i)), 60)
    Next
    From0To101Images(101) = CreateImageText(From0To101Images(101), "100+", 60)

End Sub

Sub LoadDefaultConfigs
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
    '# Limit settings.
    Config.ParticlesMax = 600 ' (Def: 600)
    Config.EnemiesMax = 255 ' (Def: 255)
    Config.FireMax = 128 ' (Def: 128)

    Config.Hud_SelRed = _Red32(Config.Hud_SelectedColor)
    Config.Hud_SelGreen = _Green32(Config.Hud_SelectedColor)
    Config.Hud_SelBlue = _Blue32(Config.Hud_SelectedColor)
    Config.Hud_UnSelRed = _Red32(Config.Hud_UnSelectedColor)
    Config.Hud_UnSelGreen = _Green32(Config.Hud_UnSelectedColor)
    Config.Hud_UnSelBlue = _Blue32(Config.Hud_UnSelectedColor)
    $If DEBUGOUTPUT Then
        _Echo ("INFO - S(LoadDefaultConfigs): Loaded internal configs.")
    $End If

End Sub

Sub LoadConfig.INI
    If _FileExists("assets/Vantiro-1.1v09b/config.ini") Then
        LoadConfigs
        $If DEBUGOUTPUT Then
            _Echo ("INFO - S(LoadConfig.INI): Loaded succesfully. ")
        $End If

    Else
        $If DEBUGOUTPUT Then
            _Echo ("WARN - S(LoadConfig.INI): {assets/Vantiro-1.1v09b/config.ini} not found, generating file based off internal configs.")
        $End If
        SaveConfig
    End If
End Sub

Sub Mob_EntityHandler
    For z = 0 To Config.EnemiesMax
        If Mobs(z).Exist Then
            Mobs(z).X1 = Mobs(z).X - Mobs(z).Size: Mobs(z).X2 = Mobs(z).X + Mobs(z).Size: Mobs(z).Y1 = Mobs(z).Y - Mobs(z).Size: Mobs(z).Y2 = Mobs(z).Y + Mobs(z).Size
            If Mobs(z).Class = "ZOMBIE" Then AI_Zombie Mobs(z)
        End If
    Next
End Sub

'AIPath(512, 256) AS _UNSIGNED INTEGER
Sub AI_Zombie (Zombie As Entity)
    Zombie.Tick = Zombie.Tick - 1


    If Zombie.Tick > 0 Then Exit Sub
    Zombie.Tick = 7 + Int(Rnd * 8)

    Select Case Zombie.AIstate
        Case "Walk2Point" ' Go towards a point

        Case "Run2Point" ' Go towards a point, fast

        Case "BreakSight" ' Run from target, aiming to break sight

        Case "Idle" ' Stop moving until provoked

        Case "IdleTillSight" ' Stop moving until seen

        Case "Roam" ' Will go to a near Waypoint

        Case "Creep" 'Will face the player from a distance on a corner, until near

        Case "": Zombie.AIstate = "IdleTillSight"
    End Select

    Zombie.XM = Zombie.XM + Fix(Sin(Zombie.Rotation * PIDIV180) * Zombie.Speed)
    Zombie.YM = Zombie.YM + Fix(-Cos(Zombie.Rotation * PIDIV180) * Zombie.Speed)

    dx = Zombie.X - Zombie.TargetX: dy = Zombie.Y - Zombie.TargetY
    Zombie.Rotation = ATan2(dy, dx) ' Angle in radians
    Zombie.Rotation = (Zombie.Rotation * 180 / PI) + 90 + (-20 + Int(Rnd * 40))
    If Zombie.Rotation > 180 Then Zombie.Rotation = Zombie.Rotation - 179.9

End Sub

Sub AI_Generic_FindPoints (Ent As Entity)
    'Clear PathID
    AI_Generic_DeletePoints Ent
    'Find new PathID
    Dim FoundID As _Unsigned Integer
    For i = 1 To 512
        If AIPath(i, 0) = 0 Then FoundID = i
    Next
    AI_Generic_FillPoints Ent, Ent.TargetX, Ent.TargetY, FoundID

End Sub
'/Spawn Enemy = = Zombie_Fast {XM:[1],YM:[1],Size:[16],Name:["Dirt"]}
'= is gonna be player/trigger coordinate.

Sub SpawnEntity (EntType As String, X As Double, Y As Double, EntName As String, Text As String)
    Dim Namer As String
    Dim Size As Double
    XM = Val(GetBit$(Text, "XM:", "]"))
    YM = Val(GetBit$(Text, "YM:", "]"))
    Namer = GetBit$(Text, "Name:", "]")
    Size = Val(GetBit$(Text, "Size:", "]"))
    Select Case UCase$(EntType)
        Case "ITEM"



        Case "ENEMY"



        Case "FRIEND"



    End Select


End Sub

Sub SpawnMob (X As Double, Y As Double, XM As Double, YM As Double, Size As Double, Class As String, ClassType As String, EntName As String)
    Dim ID As Long
    ID = -1
    For i = 0 To Config.EnemiesMax
        If Mobs(i).Exist = 0 Then ID = i: Exit For
    Next
    If ID = -1 Then
        $If DEBUGOUTPUT Then
            _Echo ("WARN - S(SpawnMob): Couldn't spawn entity, limit reached!")
        $End If
        Exit Sub
    End If
    Mobs(ID).X = X
    Mobs(ID).Y = Y
    Mobs(ID).XM = XM
    Mobs(ID).YM = YM
    Mobs(ID).Size = Size
    Mobs(ID).Class = Class
    Mobs(ID).ClassType = ClassType
    Mobs(ID).EntName = EntName
    Mobs(ID).Exist = 1
    Dim Separator As _Unsigned Integer
    $If DEBUGOUTPUT Then
        _Echo ("INFO - S(SpawnMob): Class: " + Class + " | ClassType: " + ClassType + " X: " + Str$(X) + " Y: " + Str$(Y))
    $End If

    Select Case Class
        Case "ZOMBIE"
            SpawnZombieClass Mobs(ID)
    End Select
End Sub

Sub SpawnZombieClass (Mob As Entity)
    Select Case Mob.ClassType
        Case "NORMAL"
            Mob.Size = 70 + ((Rnd * 16) - 8)
            Mob.Weight = 1.5 + ((Rnd * 10) - 5)
            Mob.Health = 50 + ((Rnd * 20) - 10)
            Mob.Speed = 3.8 + ((Rnd * 4) - 2)
            Mob.Damage = 3.6 + ((Rnd * 2))
            Mob.BreakBlocks = 0
            Mob.Smart = 1
            Mob.Sprite = SPR_Zombie
        Case "SLOW"
            Mob.Size = 70 + (Rnd * 16)
            Mob.Weight = 3
            Mob.Health = 60 + (Rnd * 10)
            Mob.Speed = 1.7 + (Rnd * 2)
            Mob.Damage = 1.8 + (Rnd * 5)
            Mob.BreakBlocks = 0
            Mob.Smart = 1
            Mob.Sprite = SPR_ZombieSlow
        Case "BRUTE"
            Mob.Size = 110 + (Rnd * 16)
            Mob.Weight = 10
            Mob.Health = 90 + (Rnd * 30)
            Mob.Speed = 1.8 + (Rnd * 2)
            Mob.Damage = 15 + (Rnd * 10)
            Mob.BreakBlocks = 1
            Mob.Smart = 1
            Mob.Sprite = SPR_Zombie
        Case ""
            ' Mob.Size =
            ' Mob.Weight  =
            ' Mob.Health =
            ' mOB.Speed =
            ' mOB.damage =
            ' mOB.BreakBlocks =
            ' mOB.smart =

        Case ""
            ' Mob.Size =
            ' Mob.Weight  =
            ' Mob.Health =
            ' mOB.Speed =
            ' mOB.damage =
            ' mOB.BreakBlocks =
            ' mOB.smart =



    End Select
End Sub
'DIM SHARED SPR_Zombie AS LONG
'DIM SHARED SPR_ZombieFast AS LONG
'DIM SHARED SPR_ZombieSlow AS LONG
'DIM SHARED SPR_ZombieFire AS LONG
'DIM SHARED SPR_ZombieBomb AS LONG
'DIM SHARED SPR_ZombieBrute AS LONG


Function GetBit$ (Text As String, SStart As String, SEnd As String)
    Dim Length As _Unsigned Integer
    size = Len(SStart)

    ' Length = SEnd - SStart
    'GetBit$ = MID$(Text, SStart, Length)
End Function

Sub AI_Generic_DeletePoints (Ent As Entity)
    Dim ClearLastID As _Unsigned Integer
    ClearLastID = AIPath(Ent.PathID, 0)
    For i = 0 To ClearLastID
        AIPath(Ent.PathID, i) = 0
    Next
    Ent.PathID = 0
End Sub

Function NearestWaypoint (X As Double, y As Double)
    Dim LowestDist As _Unsigned Long: LowestDist = 4294967294
    Dim ClosestID As _Unsigned Integer
    Dim Dist As _Unsigned Long
    For w = 0 To WaypointMax
        Dist = DistanceLow(Waypoint(w).X, Waypoint(w).Y, X, y)
        If Dist < LowestDist Then LowestDist = Dist: ClosestID = w
    Next
    NearestWaypoint = ClosestID
End Function

Sub AI_Generic_FillPoints (Ent As Entity, PointX As Double, PointY As Double, ClearID As _Unsigned Integer)
    Ent.PathID = ClearID
    Dim LowestDist As _Unsigned Long: LowestDist = 4294967294
    Dim ClosestID As _Unsigned Integer
    Dim LowestDist2 As _Unsigned Long: LowestDist2 = 4294967294
    Dim ClosestID2 As _Unsigned Integer

    'Find closest to POINT, we'll start from there.
    For w = 0 To WaypointMax
        Waypoint(w).Calculated = 0: Waypoint(w).Dist = 4294967294
        Dist = DistanceLow(Waypoint(w).X, Waypoint(w).Y, PointX, PointY)
        If Dist < LowestDist Then LowestDist = Dist: ClosestID = w
    Next
    'Find closest to ENTITY, we'll end from there.
    For w = 0 To WaypointMax
        Dist2 = DistanceLow(Waypoint(w).X, Waypoint(w).Y, Ent.X, Ent.Y)
        If Dist2 < LowestDist2 Then LowestDist2 = Dist2: ClosestID2 = w
    Next

    $If DEBUGOUTPUT Then
        Dim DOIterations As _Unsigned Long
        Dim FORIterations As _Unsigned Long
    $End If

    'Calc dist all
    Dim ToRun(WaypointMax) As _Unsigned Integer
    Dim Index As _Unsigned Integer
    Dim ArraySize As _Unsigned Integer
    Dim ID As _Unsigned Integer
    ID = ClosestID
    Waypoint(ID).Calculated = 1
    Waypoint(ID).Dist = 1
    Do
        $If DEBUGOUTPUT Then
            DOIterations = DOIterations + 1
        $End If

        For i = 1 To Waypoint(ID).Connections
            $If DEBUGOUTPUT Then
                FORIterations = FORIterations + 1
            $End If

            If Waypoint(WaypointJoints(ID, i)).Calculated = 0 Then
                ArraySize = ArraySize + 1
                ToRun(ArraySize) = WaypointJoints(ID, i)
                Waypoint(WaypointJoints(ID, i)).Dist = Waypoint(ID).Dist + (DistanceLow(Waypoint(WaypointJoints(ID, i)).X, Waypoint(WaypointJoints(ID, i)).Y, Waypoint(ID).X, Waypoint(ID).Y) / 15)
                Waypoint(WaypointJoints(ID, i)).Calculated = 1
                If WaypointJoints(ID, i) = ClosestID2 Then Exit Do
            End If
        Next

        ID = ToRun(Index): Index = Index + 1: If Index > WaypointMax Then Exit Do
        If ToRun(ArraySize) = ClosestID2 Then Exit Do

    Loop
    $If DEBUGOUTPUT Then
        _Echo ("INFO - S(AI_Generic_FillPoints): Generated path, cost: DO -" + Str$(DOIterations) + ". FOR - " + Str$(FORIterations))
    $End If

    Dim EID As _Unsigned Integer
    ID = ClosestID2
    Waypoint(ID).Calculated = 1
    Do
        o = o + 1
        LowestDist = 4294967294
        For i = 1 To Waypoint(ID).Connections
            If Waypoint(WaypointJoints(ID, i)).Calculated = 1 Then
                If Waypoint(WaypointJoints(ID, i)).Dist <= LowestDist Then LowestDist = Waypoint(WaypointJoints(ID, i)).Dist: EID = (WaypointJoints(ID, i))
                Waypoint(WaypointJoints(ID, i)).Calculated = 2
            End If
        Next
        ID = EID
        AIPath(Ent.PathID, o) = ID
        If ID = ClosestID Then Exit Do
    Loop
    AIPath(Ent.PathID, 0) = o
    $If DEBUGOUTPUT Then
        text$ = "AIPATH: ("
        For i = 1 To o
            text$ = text$ + (", " + Str$(AIPath(Ent.PathID, i)))
        Next
        text$ = text$ + ")"
        _Echo (text$)
    $End If
End Sub

Sub LoadWaypoints
    Dim File As String
    File = ("assets/Vantiro-1.1v09b/maps/" + _Trim$(Map.Title) + ".waypoints")
    If _FileExists(File) Then
        Open File For Input As #3
        Input #3, WaypointMax
        For i = 1 To WaypointMax
            Input #3, trash, Waypoint(i).X, Waypoint(i).Y, Waypoint(i).Exist, Waypoint(i).Connections, WaypointJoints(i, 1), WaypointJoints(i, 2), WaypointJoints(i, 3), WaypointJoints(i, 4), WaypointJoints(i, 5), WaypointJoints(i, 6), WaypointJoints(i, 7), WaypointJoints(i, 8), WaypointJoints(i, 9), WaypointJoints(i, 10), WaypointJoints(i, 11), WaypointJoints(i, 12), WaypointJoints(i, 13), WaypointJoints(i, 14), WaypointJoints(i, 15), WaypointJoints(i, 16)
        Next
        Close #3
        $If DEBUGOUTPUT Then
            _Echo ("INFO - S(LoadWaypoints): Loaded!")
        $End If

    Else
        $If DEBUGOUTPUT Then
            _Echo ("WARN - S(LoadWaypoints): Waypoints not found.")
        $End If

    End If
End Sub

Sub SaveWaypoints
    Open ("assets/Vantiro-1.1v09b/maps/" + _Trim$(Map.Title) + ".waypoints") For Output As #3
    Write #3, WaypointMax
    For i = 1 To WaypointMax
        Write #3, i, Waypoint(i).X, Waypoint(i).Y, Waypoint(i).Exist, Waypoint(i).Connections, WaypointJoints(i, 1), WaypointJoints(i, 2), WaypointJoints(i, 3), WaypointJoints(i, 4), WaypointJoints(i, 5), WaypointJoints(i, 6), WaypointJoints(i, 7), WaypointJoints(i, 8), WaypointJoints(i, 9), WaypointJoints(i, 10), WaypointJoints(i, 11), WaypointJoints(i, 12), WaypointJoints(i, 13), WaypointJoints(i, 14), WaypointJoints(i, 15), WaypointJoints(i, 16)
    Next
    Close #3
    $If DEBUGOUTPUT Then
        _Echo ("INFO - S(SaveWaypoints): Saved file.")
    $End If

End Sub

Function DisplayNumber (Number As _Unsigned Long)
    If Number > 10000 Then Number = 10000
    DisplayNumber = numberimage(Number)
End Function




