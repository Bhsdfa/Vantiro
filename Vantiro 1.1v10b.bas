REM Made by Bhsdfa!
REM Thanks to miojo157 (with player sprites and logo).
REM File creation date: 27-Aug-24 (1:02 PM BRT)
REM Apps used: QB64pe and TILED
REM TILED: https://www.mapeditor.org/    -=-    QB64pe: https://qb64phoenix.com/
CONST GameVersion = "1.1v10b": CONST IsBetaVersion = 1
REM Vantiro.bas:

$LET DEBUGOUTPUT = 1
$IF DEBUGOUTPUT THEN
   $CONSOLE
   _CONSOLE ON
   _CONSOLETITLE "Debug log."
   Echo ("INFO - Current Game version: " + GameVersion)
$END IF

REM Monsters to add:
REM Archville (basically from doom II)

REM Weapon suggestion to add:
REM fire guns:
REM AK-47,  RPG

REM Throwables:
REM Molotov,  Snowball

REM Melee:
REM Baseball bat,  Knife,  Axe,


DIM SHARED MainScreen: DIM SHARED SecondScreen
MainScreen = _NEWIMAGE(1230, 662, 32): SecondScreen = _NEWIMAGE(32, 32, 32)
SCREEN MainScreen
CONST PI = 3.14159265359: CONST PIDIV180 = PI / 180
CONST NormalTPS = 20
_DISPLAYORDER _HARDWARE , _SOFTWARE
'$DYNAMIC
$CHECKING:ON
$RESIZE:ON


DIM SHARED AssetPath AS STRING
DIM SHARED AssetPack AS STRING
DIM SHARED VantiroPath AS STRING
VantiroPath = "assets/Vantiro-" + GameVersion
AssetPath = VantiroPath + "/Resources/"
AssetPack = "Default"

CONST IHaveGoodPC = 1

$EMBED:'assets/MissingTexture.png','TXTMissing'
DIM SHARED MissingTexture
MissingTexture = _LOADIMAGE(_EMBEDDED$("TXTMissing"), 32, "memory")

$EMBED:'assets/MissingAudio.wav','SNDMissing'
DIM SHARED MissingSound
MissingSound = _SNDOPEN(_EMBEDDED$("SNDMissing"), "memory")
Icon = LoadImage(1, "Gui/VantiroLogo.png", 32)
_ICON Icon, Icon
_TITLE ("Vantiro - " + GameVersion)


TYPE position
   X AS DOUBLE
   Y AS DOUBLE
   Z AS DOUBLE

   Xb AS DOUBLE
   Yb AS DOUBLE
   Zb AS DOUBLE

   Xv AS DOUBLE
   Yv AS DOUBLE
   Zv AS DOUBLE

   VecX AS DOUBLE
   VecY AS DOUBLE
   VecXb AS DOUBLE
   VecYb AS DOUBLE

   rot AS DOUBLE
   rotb AS DOUBLE
   rotv AS DOUBLE

   size AS DOUBLE
   x1 AS _UNSIGNED LONG
   x2 AS _UNSIGNED LONG
   y1 AS _UNSIGNED LONG
   y2 AS _UNSIGNED LONG
   x1v AS _UNSIGNED LONG
   x2v AS _UNSIGNED LONG
   y1v AS _UNSIGNED LONG
   y2v AS _UNSIGNED LONG

   XM AS DOUBLE
   YM AS DOUBLE
   ZM AS DOUBLE
END TYPE
TYPE Mouse
   pos AS position
   x1 AS LONG: y1 AS LONG: x2 AS LONG: y2 AS LONG
   xbz AS DOUBLE: ybz AS DOUBLE: xaz AS DOUBLE: yaz AS DOUBLE
   click AS INTEGER: click2 AS INTEGER: click3 AS INTEGER
   scroll AS INTEGER
END TYPE
DIM SHARED Mouse AS Mouse

TYPE Config
   'Visual
   Hud_SmoothingY AS DOUBLE
   Hud_SmoothingX AS DOUBLE
   Hud_Size AS DOUBLE
   Hud_Side AS STRING
   Hud_Fade AS DOUBLE
   Hud_XMYMDivide AS DOUBLE
   Hud_SelectedColor AS _UNSIGNED LONG
   Hud_UnSelectedColor AS _UNSIGNED LONG
   Hud_Distselmult AS DOUBLE
   Hud_Distselfall AS DOUBLE
   Hud_SelRed AS INTEGER
   Hud_SelGreen AS INTEGER
   Hud_SelBlue AS INTEGER
   Hud_UnSelRed AS INTEGER
   Hud_UnSelGreen AS INTEGER
   Hud_UnSelBlue AS INTEGER
   'Game
   Game_Lighting AS _BYTE
   Game_Interpolation AS _BYTE
   Game_Cheats AS _BYTE
   'Player
   Player_MaxHealth AS DOUBLE
   Player_Size AS DOUBLE
   Player_MaxSpeed AS DOUBLE
   Player_Accel AS DOUBLE
   Player_Accuracy AS DOUBLE
   Player_HealthPerBlood AS DOUBLE
   Player_DamageMultiplier AS DOUBLE
   'Waves
   Wave_End AS INTEGER
   Wave_ZombieMultiplier AS DOUBLE
   Wave_TimeLimit AS LONG
   Wave_ZombieRandom AS INTEGER
   'Zombie
   'Limits
   ParticlesMax AS _UNSIGNED INTEGER
   EnemiesMax AS _UNSIGNED INTEGER
   FireMax AS _UNSIGNED INTEGER
END TYPE
DIM SHARED Config AS Config
'Default Configs:
LoadDefaultConfigs
LoadConfig.INI
TYPE Controls
   XMove AS DOUBLE
   YMove AS DOUBLE
   XVec AS DOUBLE
   YVec AS DOUBLE

   Interact1 AS _BYTE
   Interact2 AS _BYTE
   Shoot AS _BYTE
   Aim AS _BYTE
   Reload AS _BYTE
   DropItem AS _UNSIGNED _BYTE
END TYPE
DIM SHARED Joy AS Controls

TYPE JoypadType
   A AS INTEGER
   B AS INTEGER
   X AS INTEGER
   Y AS INTEGER
   L AS INTEGER
   R AS INTEGER
   L2 AS INTEGER
   R2 AS INTEGER
   BT AS DOUBLE
   START AS INTEGER
   SELECTJOY AS INTEGER
   HORIZONTAL AS DOUBLE
   VERTICAL AS DOUBLE
   HORIZONTAL2 AS DOUBLE
   VERTICAL2 AS DOUBLE
   HORIZONTAL3 AS DOUBLE
   VERTICAL3 AS DOUBLE

END TYPE
DIM SHARED Joypad AS JoypadType
DIM SHARED ControllerJoy
DIM SHARED InputDevicesNum AS _UNSIGNED INTEGER

InputDevicesNum = _DEVICES 'MUST be read in order for other 2 device functions to work!
FOR i% = 1 TO InputDevicesNum
   PRINT _DEVICE$(i%)
   IF INSTR(0, _DEVICE$(i%), "CONTROLLER") THEN ControllerJoy = i%
NEXT i%
Echo ("ControllerJoy is now " + STR$(ControllerJoy))

TYPE Map
   Tileset AS STRING
   MaxWidth AS _UNSIGNED INTEGER
   MaxHeight AS _UNSIGNED INTEGER
   Layers AS _UNSIGNED INTEGER
   TileSize AS _UNSIGNED INTEGER
   TileSizeZoom AS DOUBLE
   TileSizeHalf AS DOUBLE
   AmbientLight AS _UNSIGNED INTEGER
   Title AS STRING
   TextureSize AS _UNSIGNED INTEGER
   Triggers AS INTEGER
   DisplayName AS STRING
   Weather AS _UNSIGNED _BYTE
END TYPE
TYPE Entity
   pos AS position
   xb AS DOUBLE
   yb AS DOUBLE
   X1 AS _UNSIGNED LONG
   Y1 AS _UNSIGNED LONG
   X2 AS _UNSIGNED LONG
   Y2 AS _UNSIGNED LONG
   XM AS DOUBLE
   YM AS DOUBLE
   Exist AS _BYTE

   'Properties
   Weight AS INTEGER
   Health AS DOUBLE
   Damage AS DOUBLE
   Speed AS DOUBLE
   BreakBlocks AS _BYTE
   MaxSpeed AS DOUBLE
   DoKnockback AS DOUBLE
   Smart AS _BYTE
   DoAI AS _BYTE
   Collision AS _BYTE

   DamageTaken AS DOUBLE
   Sprite AS LONG
   Class AS STRING
   ClassType AS STRING
   EntName AS STRING
   Shooting AS _BYTE
   TouchX AS INTEGER
   touchY AS INTEGER

   Group AS _UNSIGNED _BYTE
   PathID AS _UNSIGNED INTEGER

   Tick AS _BYTE
   AIstate AS STRING ' can be: Chase, ChasePoint, Idle, Roaming and Retreat
   PointMove AS _BYTE
   PointFollow AS _UNSIGNED INTEGER

   TargetX AS _UNSIGNED LONG
   TargetY AS _UNSIGNED LONG
   TargetID AS LONG
END TYPE
TYPE PlayerMembers
   pos AS position
   xo AS DOUBLE
   yo AS DOUBLE
   xbe AS DOUBLE
   ybe AS DOUBLE
   angle AS DOUBLE
   xvector AS DOUBLE
   yvector AS DOUBLE
   animation AS STRING
   extra AS DOUBLE
   extra2 AS DOUBLE
   speed AS DOUBLE
   angleanim AS DOUBLE
   distanim AS DOUBLE
   autoBE AS _BYTE
   speedDiv AS DOUBLE
END TYPE
TYPE ArmAnim
   angleAnim AS DOUBLE
   distAnim AS DOUBLE
   ItemRot AS DOUBLE
END TYPE
TYPE Raycast
   pos AS position
   xvector AS DOUBLE
   yvector AS DOUBLE
   angle AS DOUBLE
   damage AS DOUBLE
   knockback AS DOUBLE
   owner AS INTEGER
END TYPE
TYPE TileProperties
   Health AS INTEGER
   Fragile AS _BYTE
   OnDeath AS STRING
   CanBurn AS _BYTE
   Solid AS _BYTE
   BlastResistant AS _BYTE
   Transparent AS _BYTE
   BulletCanPass AS _BYTE
   LightLevel AS _UNSIGNED INTEGER
   Animated AS _BYTE
   DamageOnStep AS _UNSIGNED INTEGER
   IsFluid AS _BYTE
   SetFire AS _BYTE
END TYPE

TYPE Tiles
   ID AS LONG
   toplayer AS INTEGER
   animationframe AS INTEGER
   alight AS INTEGER
   dlight AS INTEGER
   prop AS TileProperties

END TYPE
TYPE Item
   exist AS _BYTE
   pos AS position
   xm AS DOUBLE
   ym AS DOUBLE
   visible AS _BYTE
   cangrab AS _BYTE
   canuse AS _BYTE
   Image AS LONG
   ImageSize AS DOUBLE
   ItemName AS STRING
   InternalID AS _UNSIGNED LONG
   ItemType AS STRING
   Extra1 AS DOUBLE
   Extra2 AS DOUBLE
   Extra3 AS DOUBLE
   InSlot AS _UNSIGNED INTEGER
   held AS _UNSIGNED _BYTE
   HandsNeeded AS _UNSIGNED _BYTE
   PickupV AS _BYTE
END TYPE
TYPE Hud
   pos AS position
   XP AS DOUBLE
   YP AS DOUBLE
   ItemSprite AS LONG
   ItemID AS _UNSIGNED INTEGER
   Selected AS _BYTE
   Size AS DOUBLE
   Spacing AS DOUBLE
END TYPE
TYPE Trigger
   x1 AS DOUBLE
   y1 AS DOUBLE
   x2 AS DOUBLE
   y2 AS DOUBLE
   sizex AS DOUBLE
   sizey AS DOUBLE
   class AS STRING
   val1 AS DOUBLE
   val2 AS DOUBLE
   val3 AS DOUBLE
   val4 AS DOUBLE
   text AS STRING
   textspeed AS DOUBLE
   triggername AS STRING
   needclick AS INTEGER
END TYPE
TYPE WeaponsLoaded
   Exists AS _BYTE
   InternalName AS STRING
   VisualName AS STRING
   UsesAmmo AS _UNSIGNED INTEGER
   ShotsPerFire AS _UNSIGNED INTEGER
   Damage AS INTEGER
   MagSize AS INTEGER
   MagLimit AS INTEGER
   BulletSpritePath AS STRING
   BulletSprite AS LONG
   AmmoSpritePath AS STRING
   AmmoSprite AS LONG
   ReloadTime AS DOUBLE
   SoundPath AS STRING
   SoundHandle AS LONG
   TimeBetweenShots AS DOUBLE
   GunSprite AS LONG
   Spray AS DOUBLE
   Recoil AS DOUBLE
   JammingChance AS LONG
   ImageSize AS DOUBLE
   HandsNeeded AS _UNSIGNED _BYTE
END TYPE
TYPE Particle
   pos AS position
   txt AS INTEGER
   Gravity AS DOUBLE
   RotationSpeed AS DOUBLE
   PartID AS STRING
   FixToTile AS _BYTE
   Exist AS _UNSIGNED LONG
   DoLogic AS _UNSIGNED INTEGER
   DoPhysics AS _BYTE
   SpriteHandle AS LONG
   SoundHandle AS _UNSIGNED LONG
   CanGrab AS _BYTE
   WhenCollect AS STRING
   DistPlayer AS INTEGER
END TYPE
TYPE PlayerAnims
   Current AS STRING
   Frame AS _UNSIGNED LONG
   LastFrame AS _UNSIGNED LONG
END TYPE
TYPE Waypoint
   Exist AS _BYTE
   Dist AS _UNSIGNED LONG
   Connections AS INTEGER
   pos AS position
   Free AS _BYTE
   Calculated AS _BYTE
END TYPE
TYPE BulletTrace
   pos AS position
   FrameLife AS _UNSIGNED INTEGER
END TYPE
TYPE LightSource
   exist AS _BYTE
   pos AS position
   Detail AS STRING
   LightType AS _BYTE
   Duration AS LONG
   Fov AS DOUBLE
   strength AS _UNSIGNED INTEGER
   Size AS _UNSIGNED INTEGER
   DistFall AS DOUBLE
   EntID AS _UNSIGNED INTEGER
END TYPE
TYPE ZombieTypeList
   Size AS _UNSIGNED INTEGER
   SizeRND AS _UNSIGNED INTEGER
   Weight AS _UNSIGNED INTEGER
   WeightRND AS _UNSIGNED INTEGER
   Health AS LONG
   HealthRND AS _UNSIGNED INTEGER
   Speed AS DOUBLE
   SpeedRND AS _UNSIGNED INTEGER
   Damage AS DOUBLE
   DamageRND AS _UNSIGNED INTEGER
   CanBreakBlocks AS _UNSIGNED _BYTE
   Smart AS _UNSIGNED _BYTE
   CanSpawnWith AS STRING
END TYPE


CONST BulletTracersMax = 1024
DIM SHARED LastItemID AS _UNSIGNED INTEGER: LastItemID = 1
DIM SHARED HudWeaponMax AS _UNSIGNED INTEGER: HudWeaponMax = 16
DIM SHARED rendcamerax1 AS LONG, rendcamerax2 AS LONG, rendcameray1 AS LONG, rendcameray2 AS LONG
DIM SHARED HudImageHealth AS LONG: HudImageHealth = _NEWIMAGE(128, 128, 32)
DIM SHARED LastWeaponID AS _UNSIGNED INTEGER
DIM SHARED LastPart AS _UNSIGNED INTEGER
DIM SHARED TileSet AS LONG
DIM SHARED TileSetSoft AS LONG
DIM SHARED CameraX AS DOUBLE, CameraY AS DOUBLE
DIM SHARED CameraXM AS DOUBLE, CameraYM AS DOUBLE
DIM SHARED HUD_PlayerHealth, PlayerInteract, ShootDelay
DIM SHARED HUD_BloodParticle AS _UNSIGNED INTEGER
DIM SHARED LastDynLight: LastDynLight = 0
DIM SHARED TimeTick AS DOUBLE
DIM SHARED StaticLightMax: StaticLightMax = 1
DIM SHARED DynamicLightMax: DynamicLightMax = 80
DIM SHARED BloodPickUpRadius AS _UNSIGNED LONG: BloodPickUpRadius = 800
DIM SHARED GameMode AS _UNSIGNED _BYTE: GameMode = 0 '0 - Survival, 1 - Sandbox,
DIM SHARED GameVersionImage AS LONG
DIM SHARED Debug AS _BYTE
DIM SHARED Debug_Noclip AS _BYTE
DIM SHARED Debug_HideUI AS _BYTE
DIM SHARED Debug_FreeCam AS _BYTE
DIM SHARED Debug_DoAI AS _BYTE: Debug_DoAI = 1
DIM SHARED ChatState AS _BYTE
DIM SHARED FontSized(512) AS _UNSIGNED LONG
DIM SHARED From0To101Images(101) AS LONG
DIM SHARED WaveNumberImage AS LONG
DIM SHARED InfectedNumberImage AS LONG
DIM SHARED WaypointMax: WaypointMax = 1024
DIM SHARED AIPath(512, WaypointMax) AS _UNSIGNED INTEGER
DIM SHARED WaypointJoints(WaypointMax, 16) AS INTEGER
DIM SHARED PlayerID AS LONG: PlayerID = -1
DIM SHARED AIGroupHate(8, 8) AS _UNSIGNED INTEGER
DIM SHARED ResizeDelay AS _UNSIGNED INTEGER
DIM SHARED LastWaypoint AS _UNSIGNED INTEGER
DIM SHARED Way1 AS _UNSIGNED INTEGER
DIM SHARED Way2 AS _UNSIGNED INTEGER
DIM SHARED Delay AS _UNSIGNED INTEGER
DIM SHARED SUBOutUINT AS _UNSIGNED INTEGER
DIM SHARED TPS AS _UNSIGNED INTEGER
DIM SHARED OldTPS AS _UNSIGNED INTEGER
DIM SHARED Tickrate AS DOUBLE
DIM SHARED RNGSeed AS DOUBLE
DIM SHARED SValL(32) AS LONG
DIM SHARED ChatHistory(65) AS STRING
DIM SHARED ChatEditX AS _UNSIGNED INTEGER
DIM SHARED ChatEditY AS _UNSIGNED INTEGER
DIM SHARED Textures(512) AS LONG
DIM SHARED ChatHandle AS LONG
DIM SHARED CurTickTime AS DOUBLE
DIM SHARED ControllerInput AS _BYTE



DIM SHARED PlayerMember(2) AS PlayerMembers
DIM SHARED TileProp(512) AS TileProperties
DIM SHARED PlHands(3) AS LONG
DIM SHARED Ray AS Raycast
DIM SHARED RayM(3) AS Raycast
DIM SHARED Item(32) AS Item
DIM SHARED Hud(16) AS Hud
DIM SHARED Mobs(Config.EnemiesMax) AS Entity
DIM SHARED Weapons(15) AS WeaponsLoaded
DIM SHARED Trigger(Map.Triggers) AS Trigger
DIM SHARED Map AS Map
DIM SHARED PL_Anim AS PlayerAnims
DIM SHARED Grenade(8) AS Particle
DIM SHARED Fire(Config.FireMax) AS Particle
DIM SHARED HUD_BloodParticle(32) AS Particle
DIM SHARED Part(Config.ParticlesMax) AS Particle
DIM SHARED StaticLight(StaticLightMax) AS LightSource
DIM SHARED DynamicLight(DynamicLightMax) AS LightSource
DIM SHARED Waypoint(WaypointMax) AS Waypoint
DIM SHARED WayDebug AS Entity
DIM SHARED BulletTrace(BulletTracersMax) AS BulletTrace
PlayerSkin = 1
'----------------------------------------------------
'-               Setting up variables.              -
'----------------------------------------------------
LoadHateType
LoadWeapons
FOR i = 1 TO WaypointMax
   Waypoint(i).Connections = 0
   FOR i2 = 1 TO 16
      WaypointJoints(i, i2) = -1
   NEXT
NEXT
DIM Shadowgradientold AS LONG
Shadowgradientold = _NEWIMAGE(256, 4, 32): _DEST Shadowgradientold: x = 0
FOR i = 255 TO 0 STEP -1: LINE (x, 0)-(x, 4), _RGBA32(0, 0, 0, i): x = x + 1: NEXT
DIM SHARED Shadowgradient AS _UNSIGNED LONG
Shadowgradient = _COPYIMAGE(Shadowgradientold, 33): _FREEIMAGE Shadowgradientold
FOR i = 1 TO 2
   PlayerMember(i).autoBE = -1: PlayerMember(i).speedDiv = 1
NEXT



'Asset Time!
'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================
'------------------------------------------
'-                 SOUNDS                 -
'------------------------------------------
DIM SHARED SND_ZombieShot(16) AS _UNSIGNED LONG
DIM SHARED SND_ZombieWalk(4) AS _UNSIGNED LONG
DIM SHARED SND_Explosion AS _UNSIGNED LONG
DIM SHARED SND_GunFire(64, 4) AS _UNSIGNED LONG
DIM SHARED SND_GunReload(64, 4) AS _UNSIGNED LONG
DIM SHARED SND_GunShells(64, 4) AS _UNSIGNED LONG
DIM SHARED SND_Blood(6) AS _UNSIGNED LONG
DIM SHARED SND_GlassBreak(3) AS _UNSIGNED LONG
DIM SHARED SND_GlassShard(4) AS _UNSIGNED LONG
DIM SHARED SND_PlayerDamage AS _UNSIGNED LONG
DIM SHARED SND_PlayerDeath AS _UNSIGNED LONG
DIM SHARED SND_FlameThrower AS _UNSIGNED LONG
'------------------------------------------
'-                 IMAGES                 -
'------------------------------------------
'Entities
DIM SHARED SPR_Player(16) AS LONG
DIM SHARED SPR_PlayerHand(16) AS LONG
DIM SHARED SPR_Zombie AS LONG
DIM SHARED SPR_ZombieFast AS LONG
DIM SHARED SPR_ZombieSlow AS LONG
DIM SHARED SPR_ZombieFire AS LONG
DIM SHARED SPR_ZombieBomb AS LONG
DIM SHARED SPR_ZombieBrute AS LONG
DIM SHARED PlayerSprite(4) AS LONG
DIM SHARED PlayerHand(4) AS LONG
'GUI
DIM SHARED GUI_VantiroTitle AS LONG
DIM SHARED GUI_Background AS LONG
DIM SHARED GUI_HudSelected AS LONG
DIM SHARED GUI_HudNotSelected AS LONG
DIM SHARED GUI_HudNoAmmo AS LONG
DIM SHARED GUI_HealthOverlay AS LONG
DIM SHARED GUI_HealthBackground AS LONG
'Particles
DIM SHARED PAR_Interact AS LONG
DIM SHARED PAR_BulletTracer AS LONG
DIM SHARED PAR_BulletHole AS LONG
DIM SHARED PAR_GlassShard AS LONG
DIM SHARED PAR_BloodGreen AS LONG
DIM SHARED PAR_BloodRed AS LONG
DIM SHARED PAR_GibSkull AS LONG
DIM SHARED PAR_GibBone AS LONG
DIM SHARED PAR_Fire AS LONG
DIM SHARED PAR_Smoke AS LONG
DIM SHARED PAR_Explosion AS LONG
DIM SHARED PAR_BloodDrop AS LONG

LoadAssets
'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================
'=============================================================================================================================================================

DIM SHARED Tile(800, 800, 3) AS Tiles
_FONT FontSized(20)
GameVersionImage = CreateImageText(GameVersionImage, "Vantiro " + GameVersion, 20)
INPUT "Select a map", Map$
MapLoaded = LoadMap(Map$)
LoadWaypoints
REDIM SHARED AIPath(512, WaypointMax) AS _UNSIGNED INTEGER

GenerateTexturesFromTileSet
ResetGame
DIM SHARED PlayerSkin2
PlayerSkin2 = PlayerSkin
TIMER ON

'Create shadow gradiant.

_DEST MainScreen
_FONT FontSized(15)
'Sets tickrate
SetupTPS 20
RNGSeed = TIMER
RANDOMIZE RNGSeed
_KEYCLEAR
'ExecCommand ("/spawnmob;x,y,zombie,fast")
'ExecCommand ("/spawnitem;x,y,weapon,smg")


DO
   _LIMIT 65
   IF ChatState = 0 THEN FillJoy ' Get Player Keys
   Mouse.scroll = 0: WHILE _MOUSEINPUT: WEND
   Mouse.pos.X = _MOUSEX: Mouse.pos.Y = _MOUSEY
   Mouse.click = _MOUSEBUTTON(1): Mouse.click2 = _MOUSEBUTTON(2): Mouse.click3 = _MOUSEBUTTON(3): Mouse.scroll = _MOUSEWHEEL
   CLS , 0
   ff% = ff% + 1
   IF TIMER - start! >= 1 THEN fps% = ff%: ff% = 0: start! = TIMER
   IF Delay > 0 THEN Delay = Delay - 1
   CurTickTime = TIMER(0.001)
   IF Debug THEN DebugHandler
   IF _KEYDOWN(116) AND ChatState = 0 THEN OpenChat

   IF Debug_FreeCam = 0 THEN
      CameraX = (Mobs(PlayerID).pos.Xv / Map.TileSize) - (_WIDTH / (Map.TileSize * 2))
      CameraY = (Mobs(PlayerID).pos.Yv / Map.TileSize) - (_HEIGHT / (Map.TileSize * 2))
      CameraX = CameraX + CameraXM / 100
      CameraY = CameraY + CameraYM / 100
   END IF
   CameraXM = CameraXM / 1.1
   CameraYM = CameraYM / 1.1

   IF _KEYDOWN(15616) AND Delay = 0 THEN Debug = Debug + 1: Delay = 20: IF Debug = 2 THEN Debug = 0
   IF _KEYDOWN(18176) AND Delay = 0 THEN Delay = 60: LoadConfigs
   RenderGame

   IF ChatState = 1 THEN Chat
   IF IsBetaVersion = 1 THEN _PUTIMAGE (_WIDTH - (_WIDTH(GameVersionImage)), 0), GameVersionImage
   PRINT fps%
   _DISPLAY
   IF _WINDOWHASFOCUS THEN ResizeScreen
LOOP


SUB Chat
   DIM KeyP AS STRING
   KeyP = INKEY$
   IF LEN(KeyP) > 1 THEN KeyD$ = RIGHT$(KeyP, 1): KeyP = ""
   IF _KEYDOWN(27) THEN CloseChat: EXIT SUB
   IF NOT _KEYDOWN(100306) THEN
      IF KeyD$ = "H" AND ChatEditY < 63 THEN ChatEditY = ChatEditY + 1 ' Up Arrow
      IF KeyD$ = "P" AND ChatEditY > 1 THEN ChatEditY = ChatEditY - 1 ' Down Arrow
      IF KeyD$ = "K" AND ChatEditX > 0 THEN ChatEditX = ChatEditX - 1 ' Left Arrow
      IF KeyD$ = "M" THEN ChatEditX = ChatEditX + 1: IF ChatEditX > LEN(ChatHistory(0)) THEN ChatEditX = LEN(ChatHistory(0)) ' Right Arrow
      IF KeyD$ = "G" THEN ChatEditX = 0 ' Home
      IF KeyD$ = "O" THEN ChatEditX = LEN(ChatHistory(0)) ' End


   END IF
   IF KeyD$ = "H" OR KeyD$ = "P" THEN ChatHistory(0) = ChatHistory(ChatEditY): ChatEditX = LEN(ChatHistory(0))

   'Paste
   IF _KEYDOWN(100304) AND KeyD$ = "R" THEN

      ChatHistory(0) = LEFT$(ChatHistory(0), ChatEditX) + _CLIPBOARD$ + RIGHT$(ChatHistory(0), LEN(ChatHistory(0)) - ChatEditX)

      ChatEditX = ChatEditX + LEN(_CLIPBOARD$)
   END IF


   'Enter Key
   IF KeyP = CHR$(13) THEN
      FOR i = 64 TO 1 STEP -1
         ChatHistory(i) = ChatHistory(i - 1)
      NEXT

      CloseChat
      IF LEFT$(ChatHistory(0), 1) = "/" THEN ExecCommand (LTRIM$(ChatHistory(0)))
      EXIT SUB
   END IF
   'Backspace
   IF KeyP = CHR$(8) THEN
      KeyP = ""
      DeleteLetterBackspace ChatEditX
   END IF
   'Delete
   IF KeyD$ = CHR$(83) THEN
      KeyP = ""
      DeleteLetterDelete ChatEditX
   END IF

   IF KeyP <> "" THEN WriteInChat KeyP
   'Render
   FOR i = 0 TO 64
      _UPRINTSTRING (5, (_HEIGHT - 20) - (i * 16)), ChatHistory(i), , , FontSized(15), MainScreen
   NEXT

   LINE (5 + (ChatEditX * _FONTWIDTH(FontSized(15))), (_HEIGHT - 20))-(6 + (ChatEditX * _FONTWIDTH(FontSized(15))), (_HEIGHT - 5)), _RGB32(255, 128, 0), BF
END SUB

SUB WriteInChat (text AS STRING)
   ChatHistory(0) = LEFT$(ChatHistory(0), ChatEditX) + text + RIGHT$(ChatHistory(0), LEN(ChatHistory(0)) - ChatEditX)
   ChatEditX = ChatEditX + 1
END SUB
SUB DeleteLetterBackspace (Xcur AS _UNSIGNED LONG)
   IF Xcur > 0 THEN
      ChatHistory(0) = LEFT$(ChatHistory(0), Xcur - 1) + RIGHT$(ChatHistory(0), (LEN(ChatHistory(0)) - Xcur))
      ChatEditX = ChatEditX - 1
   END IF
END SUB
SUB DeleteLetterDelete (Xcur AS _UNSIGNED LONG)
   IF Xcur > 0 THEN
      ChatHistory(0) = LEFT$(ChatHistory(0), Xcur) + RIGHT$(ChatHistory(0), (LEN(ChatHistory(0)) - (Xcur + 1)))
   END IF
END SUB


SUB OpenChat
   ChatState = 1
   _KEYCLEAR
   OldTPS = TPS
   SetupTPS 1

END SUB
SUB CloseChat
   ChatHistory(0) = ""
   ChatState = 0
   ChatEditX = 0
   ChatEditY = 0
   _KEYCLEAR
   SetupTPS OldTPS
END SUB

SUB ExecCommand (Text AS STRING)

   Text = Text + ",]"
   DIM Executor AS STRING
   DIM Args(15) AS STRING
   DIM StartOfArgs AS SINGLE
   DIM EndOfArgs AS SINGLE
   DIM Freeze AS _UNSIGNED INTEGER: Freeze = 1
   DIM ArgI AS _UNSIGNED INTEGER
   StartOfArgs = INSTR(1, Text, ";")
   EndOfArgs = INSTR(1, Text, "]")
   IF StartOfArgs = 0 THEN StartOfArgs = LEN(Text) + 1
   Executor = UCASE$(LEFT$(Text, StartOfArgs - 1))
   StartArg = StartOfArgs + 1


   DO
      Freeze = Freeze + 1: IF Freeze = 0 THEN Echo ("WARN - F(ExecCommand): Freeze prevented! Command: '" + Text + "'")
      EndArg = INSTR(StartArg + 1, Text, ",")
      Args(ArgI) = _TRIM$(MID$(Text, StartArg, EndArg - StartArg))
      StartArg = EndArg + 1

      Args(ArgI) = ConvertValSubs$(Args(ArgI))

      IF EndArg <> 0 THEN ArgI = ArgI + 1
      IF EndArg > EndOfArgs THEN EXIT DO
   LOOP WHILE EndArg <> 0

   Echo ("INFO - F(ExecCommand): { '" + Executor + "': ")
   FOR o = 0 TO ArgI
      Echo ("   Args(" + LTRIM$(STR$(o)) + ") = " + Args(o))
   NEXT
   Echo "}"



   SELECT CASE Executor
      CASE "/NOCLIP"
         IF Args(0) <> "" THEN
            Debug_Noclip = VAL(Args(0))
         ELSE: Debug_Noclip = Debug_Noclip + 1: IF Debug_Noclip = 2 THEN Debug_Noclip = 0
         END IF
      CASE "/FREECAM"
         IF Args(0) <> "" THEN
            Debug_FreeCam = VAL(Args(0))
         ELSE: Debug_FreeCam = Debug_FreeCam + 1: IF Debug_FreeCam = 2 THEN Debug_FreeCam = 0
         END IF
      CASE "/SPAWNMOB"
         SpawnMob VAL(Args(0)), VAL(Args(1)), 0, 0, 0, Args(2), Args(3), ""
      CASE "/TELEPORT"
         Teleport Mobs(PlayerID).pos, VAL(Args(0)), VAL(Args(1))
      CASE "/TELEPORTENT"
         Teleport Mobs(VAL(Args(0))).pos, VAL(Args(1)), VAL(Args(2))
      CASE "/SPAWNITEM"
         SpawnItem VAL(Args(0)), VAL(Args(1)), Args(2), Args(3)
      CASE "/SETTPS"
         SetupTPS INT(VAL(Args(0)))
      CASE "/LOADTEXTURES"
      CASE "/GAMERULES"
         ComGameRules Args()
      CASE "/KILLENT"
         KillEntity Mobs(VAL(Args(0)))
   END SELECT

END SUB


SUB ComGameRules (Args() AS STRING)
   SELECT CASE UCASE$(Args(0))
      CASE "TILESIZE"
         Map.TileSize = VAL(Args(1))
      CASE "MAXWIDTH"
         Map.MaxWidth = VAL(Args(1))
      CASE "MAXHEIGHT"
         Map.MaxHeight = VAL(Args(1))
      CASE "LIGHTING"
         Config.Game_Lighting = VAL(Args(1))
      CASE "INTERPOLATION"
         Config.Game_Interpolation = VAL(Args(1))
      CASE "DOMAPSCRIPTS"
   END SELECT
END SUB


FUNCTION ConvertValSubs$ (Text AS STRING)
   Result$ = Text
   SELECT CASE Text
      CASE "x"
         Result$ = STR$(Mobs(PlayerID).pos.X)
      CASE "y"
         Result$ = STR$(Mobs(PlayerID).pos.Y)
      CASE "id"
         Result$ = STR$(PlayerID)

   END SELECT
   ConvertValSubs$ = _TRIM$(Result$)
END FUNCTION

SUB Teleport (Ent AS position, X AS DOUBLE, Y AS DOUBLE)
   Ent.X = X
   Ent.Y = Y
   Ent.Xb = X
   Ent.Yb = Y

END SUB

SUB SetupTPS (NewTPS AS _UNSIGNED INTEGER)
   TPS = NewTPS
   Tickrate = 1 / TPS
   TIMER OFF
   TIMER ON
   TimeTick = TIMER(.001)
   ON TIMER(Tickrate) TickSub
END SUB

SUB TickSub
   FOR i = 0 TO 16 'BulletTracers Life
      IF BulletTrace(i).FrameLife > 0 THEN BulletTrace(i).FrameLife = BulletTrace(i).FrameLife - 1
   NEXT
   'Keyboard input
   IF NOT _KEYDOWN(101) THEN Joy.Interact1 = 0
   IF NOT _KEYDOWN(102) THEN Joy.Interact2 = 0
   IF NOT _KEYDOWN(113) THEN Joy.DropItem = 0

   'Logic Subs

   Mob_EntityHandler
   ItemLogic
   Player1Handler Mobs(PlayerID)
   TriggerPlayer
   ParticleLogicHandler


   NewHud
   TimeTick = TIMER(.001)
   'Special Cases
   'DynamicLight(1).pos.X = Mobs(PlayerID).pos.X + Mouse.pos.X
   'DynamicLight(1).pos.X = (CameraX * Map.TileSize) + Mouse.pos.X
   'DynamicLight(1).pos.Y = (CameraY * Map.TileSize) + Mouse.pos.Y
   LightingLogic
   'Input unbuffer
   IF Joy.Interact1 = 1 THEN Joy.Interact1 = Joy.Interact1 + 1
   IF Joy.Interact2 = 1 THEN Joy.Interact2 = Joy.Interact2 + 1
   IF Joy.DropItem = 1 THEN Joy.DropItem = Joy.DropItem + 1


END SUB

SUB CopyCoords (Ent1 AS position, Ent2 AS position)
   Ent1.X = Ent2.X
   Ent1.Y = Ent2.Y
   Ent1.rot = Ent2.rot
END SUB



SUB NewHud
   FOR i = 0 TO 4
      Hud(i).Size = 25
      Hud(i).Spacing = 5
      Size = 0
      FOR o = i TO 0 STEP -1
         Size = Size + Hud(o).Size + Hud(o).Spacing
      NEXT
      Hud(i).XP = Size + (Hud(i).Size / 2)
      Hud(i).YP = _HEIGHT - (Hud(i).Size + (Hud(i).Spacing))
      GetBPos Hud(i).pos
      Hud(i).pos.X = Hud(i).XP 'Hud(i).pos.X - ((Hud(i).pos.X - Hud(i).XP) / 5)
      Hud(i).pos.Y = Hud(i).YP 'Hud(i).pos.Y - ((Hud(i).pos.Y - Hud(i).YP) / 5)
   NEXT
END SUB

SUB NewHudRenderer
   FOR i = 0 TO 4
      Interpolate Hud(i).pos
      LINE (Hud(i).pos.Xv - Hud(i).Size, Hud(i).pos.Yv - Hud(i).Size)-(Hud(i).pos.Xv + Hud(i).Size, Hud(i).pos.Yv + Hud(i).Size), _RGB32(255, 255, 255), BF
   NEXT
END SUB



SUB WaypointDebug
   IF _KEYDOWN(61) AND Delay = 0 AND LastWaypoint < WaypointMax THEN
      Delay = 20
      LastWaypoint = LastWaypoint + 1
      Waypoint(LastWaypoint).pos.X = ((FIX(Mobs(PlayerID).pos.X / Map.TileSize)) * Map.TileSize) + Map.TileSize / 2
      Waypoint(LastWaypoint).pos.Y = ((FIX(Mobs(PlayerID).pos.Y / Map.TileSize)) * Map.TileSize) + Map.TileSize / 2
      Waypoint(LastWaypoint).Exist = -1

   END IF

   IF _KEYDOWN(16640) AND Delay = 0 THEN ' " ' " key, saves waypoints.
      Delay = 30
      OPEN (VantiroPath + "/Maps/" + Map.Title + ".waypoints") FOR INPUT AS #3
      INPUT #3, WaypointMax
      FOR i = 1 TO WaypointMax

         INPUT #3, i, Waypoint(i).pos.X, Waypoint(i).pos.Y, Waypoint(i).Exist, Waypoint(i).Connections, WaypointJoints(i, 1), WaypointJoints(i, 2), WaypointJoints(i, 3), WaypointJoints(i, 4), WaypointJoints(i, 5), WaypointJoints(i, 6), WaypointJoints(i, 7), WaypointJoints(i, 8), WaypointJoints(i, 9), WaypointJoints(i, 10), WaypointJoints(i, 11), WaypointJoints(i, 12), WaypointJoints(i, 13), WaypointJoints(i, 14), WaypointJoints(i, 15), WaypointJoints(i, 16)
      NEXT
      CLOSE #3
   END IF


   IF _KEYDOWN(20992) AND Delay = 0 THEN 'INSERT KEY.
      Delay = 10
      FOR i = 1 TO WaypointMax
         IF Distance((CameraX * Map.TileSize) + Mouse.pos.X, (CameraY * Map.TileSize) + Mouse.pos.Y, Waypoint(i).pos.X, Waypoint(i).pos.Y) < Map.TileSize / 1.5 THEN
            IF Way1 <> 0 THEN Way2 = i
            IF Way1 = 0 THEN Way1 = i
            IF Way1 <> 0 AND Way2 <> 0 THEN
               FOR o = 1 TO 16
                  IF WaypointJoints(Way1, o) = -1 THEN WaypointJoints(Way1, o) = Way2: EXIT FOR
               NEXT
               FOR o = 1 TO 16
                  IF WaypointJoints(Way2, o) = -1 THEN WaypointJoints(Way2, o) = Way1: EXIT FOR
               NEXT
               Waypoint(Way1).Connections = Waypoint(Way1).Connections + 1
               Waypoint(Way2).Connections = Waypoint(Way2).Connections + 1
               Way1 = 0
               Way2 = 0
            END IF
            EXIT FOR
         END IF
      NEXT
   END IF


   FOR w = 0 TO WaypointMax
      IF Waypoint(w).Calculated > 0 THEN
         LINE (ETSX(Waypoint(w).pos.X) - 16, ETSY(Waypoint(w).pos.Y) - 16)-(ETSX(Waypoint(w).pos.X) + 16, ETSY(Waypoint(w).pos.Y) + 16), _RGB32(0, 255, 0), B
         LINE (ETSX(Waypoint(w).pos.X) - 16, ETSY(Waypoint(w).pos.Y) - 16)-(ETSX(Waypoint(w).pos.X) + 16, ETSY(Waypoint(w).pos.Y) + 16), _RGBA32(0, 255, 0, 128), BF
      ELSE
         LINE (ETSX(Waypoint(w).pos.X) - 16, ETSY(Waypoint(w).pos.Y) - 16)-(ETSX(Waypoint(w).pos.X) + 16, ETSY(Waypoint(w).pos.Y) + 16), _RGB32(255, 0, 0), B
         LINE (ETSX(Waypoint(w).pos.X) - 16, ETSY(Waypoint(w).pos.Y) - 16)-(ETSX(Waypoint(w).pos.X) + 16, ETSY(Waypoint(w).pos.Y) + 16), _RGBA32(255, 0, 0, 128), BF
      END IF
      FOR i2 = 1 TO Waypoint(w).Connections

         IF Waypoint(WaypointJoints(w, i2)).Calculated > 2 THEN
            LINE (ETSX(Waypoint(w).pos.X), ETSY(Waypoint(w).pos.Y))-(ETSX(Waypoint(WaypointJoints(w, i2)).pos.X), ETSY(Waypoint(WaypointJoints(w, i2)).pos.Y)), _RGBA32(0, 255, 0, 200)
         ELSE
            LINE (ETSX(Waypoint(w).pos.X), ETSY(Waypoint(w).pos.Y))-(ETSX(Waypoint(WaypointJoints(w, i2)).pos.X), ETSY(Waypoint(WaypointJoints(w, i2)).pos.Y)), _RGBA32(255, 0, 0, 200)
         END IF
      NEXT
   NEXT
END SUB

SUB DebugHandler
   IF Debug_FreeCam = 1 AND ChatState = 0 THEN
      IF _KEYDOWN(19200) THEN CameraX = CameraX - 0.2
      IF _KEYDOWN(19712) THEN CameraX = CameraX + 0.2
      IF _KEYDOWN(18432) THEN CameraY = CameraY - 0.2
      IF _KEYDOWN(20480) THEN CameraY = CameraY + 0.2
   END IF
   WaypointDebug
END SUB



SUB ResizeScreen
   IF ResizeDelay > 0 THEN ResizeDelay = ResizeDelay - 1
   IF _RESIZE AND ResizeDelay = 0 AND _WINDOWHASFOCUS THEN
      SCREEN SecondScreen
      CLS
      _FREEIMAGE MainScreen
      ScreenSizeX = _RESIZEWIDTH
      ScreenSizeY = _RESIZEHEIGHT
      IF ScreenSizeX < 800 THEN ScreenSizeX = 800
      IF ScreenSizeY < 600 THEN ScreenSizeY = 600
      MainScreen = _NEWIMAGE(ScreenSizeX, ScreenSizeY, 32)
      SCREEN MainScreen
      ResizeDelay = 3
   END IF
END SUB

SUB TriggerPlayer
   FOR i = 1 TO Map.Triggers
      IF TriggerEntityCollide(Mobs(PlayerID), Trigger(i)) THEN
         SELECT CASE Trigger(i).class
            CASE "TP"
               Mobs(PlayerID).pos.X = Trigger(i).val1 * 2
               Mobs(PlayerID).pos.Y = Trigger(i).val2 * 2
         END SELECT
      END IF
   NEXT
END SUB


SUB EditAnims
   DIM Arm1x AS DOUBLE
   DIM Arm1y AS DOUBLE
   DIM Arm2x AS DOUBLE
   DIM Arm2y AS DOUBLE
   DIM ArmLeftOrigin AS DOUBLE
   DIM ArmRightOrigin AS DOUBLE
   Mobs(PlayerID).pos.rot = 0
   ArmLeftOrigin = Mobs(PlayerID).pos.rot + 90
   ArmRightOrigin = Mobs(PlayerID).pos.rot - 90
   Arm1x = SIN(ArmLeftOrigin * PIDIV180)
   Arm1y = -COS(ArmLeftOrigin * PIDIV180)
   Arm2x = SIN(ArmRightOrigin * PIDIV180)
   Arm2y = -COS(ArmRightOrigin * PIDIV180)
   Arm1x = Mobs(PlayerID).pos.X + Arm1x * 32
   Arm1y = Mobs(PlayerID).pos.Y + Arm1y * 32
   Arm2x = Mobs(PlayerID).pos.X + Arm2x * 32
   Arm2y = Mobs(PlayerID).pos.Y + Arm2y * 32
   DNoclip = Debug_Noclip
   Debug_Noclip = 1
   DO
      IF _KEYDOWN(27) THEN EXIT DO
      WHILE _MOUSEINPUT: WEND
      Mouse.pos.X = _MOUSEX: Mouse.pos.Y = _MOUSEY
      Mouse.click = _MOUSEBUTTON(1): Mouse.click2 = _MOUSEBUTTON(2): Mouse.click3 = _MOUSEBUTTON(3): Mouse.scroll = _MOUSEWHEEL
      _SETALPHA 0, _RGB32(0, 0, 0), MainScreen
      FOR o = 1 TO 3
         IF PlHands(o) > 0 THEN
            PlayerHoldingItem Item(PlHands(o)), o
         END IF
      NEXT

      IF Mouse.click THEN
         PlayerMember(1).distanim = Distance(ETSX(Arm1x), ETSY(Arm1y), Mouse.pos.X, Mouse.pos.Y)
         dx = ETSX(Arm1x) - Mouse.pos.X
         dy = ETSY(Arm1y) - Mouse.pos.Y
         PlayerMember(1).angleanim = ATan2(dy, dx) ' Angle in radians
         PlayerMember(1).angleanim = (PlayerMember(1).angleanim * 180 / PI) + 90
         IF PlayerMember(1).angleanim >= 180 THEN PlayerMember(1).angleanim = PlayerMember(1).angleanim - 179.9
         PlayerMember(1).angleanim = PlayerMember(1).angleanim - Mobs(PlayerID).pos.rot
      END IF
      IF Mouse.click2 THEN
         PlayerMember(2).distanim = Distance(ETSX(Arm2x), ETSY(Arm2y), Mouse.pos.X, Mouse.pos.Y)
         dx = ETSX(Arm2x) - Mouse.pos.X
         dy = ETSY(Arm2y) - Mouse.pos.Y
         PlayerMember(2).angleanim = ATan2(dy, dx) ' Angle in radians
         PlayerMember(2).angleanim = (PlayerMember(2).angleanim * 180 / PI) + 90
         IF PlayerMember(2).angleanim >= 180 THEN PlayerMember(2).angleanim = PlayerMember(2).angleanim - 179.9
         PlayerMember(2).angleanim = PlayerMember(2).angleanim - Mobs(PlayerID).pos.rot
      END IF
      IF _KEYDOWN(114) OR _KEYDOWN(75) THEN
         dx = ETSX(Mobs(PlayerID).pos.X) - Mouse.pos.X
         dy = ETSY(Mobs(PlayerID).pos.Y) - Mouse.pos.Y
         Mobs(PlayerID).pos.rot = ATan2(dy, dx) ' Angle in radians
         Mobs(PlayerID).pos.rot = (Mobs(PlayerID).pos.rot * 180 / PI) + 90
         IF Mobs(PlayerID).pos.rot >= 180 THEN Mobs(PlayerID).pos.rot = Mobs(PlayerID).pos.rot - 179.9
      END IF

      HandsCode

      ZRender_PlayerHand
      RenderItems
      '  ZRender_Player
      _DISPLAY
   LOOP
   Debug_Noclip = DNoclip

END SUB


SUB HandsCode
   SUBOutUINT = 0
   PlayerMember(1).angleanim = -29: PlayerMember(1).distanim = 67
   PlayerMember(2).angleanim = 50: PlayerMember(2).distanim = 42

   DIM ArmLeftOrigin AS DOUBLE
   DIM ArmRightOrigin AS DOUBLE
   DIM RotationDifference AS DOUBLE
   DIM Angleadded AS DOUBLE
   ArmLeftOrigin = Mobs(PlayerID).pos.rot + 90: ArmRightOrigin = Mobs(PlayerID).pos.rot - 90
   PlayerMember(1).xo = SIN(ArmLeftOrigin * PIDIV180)
   PlayerMember(1).yo = -COS(ArmLeftOrigin * PIDIV180)
   PlayerMember(2).xo = SIN(ArmRightOrigin * PIDIV180)
   PlayerMember(2).yo = -COS(ArmRightOrigin * PIDIV180)
   PlayerMember(1).xo = Mobs(PlayerID).pos.X + PlayerMember(1).xo * 32
   PlayerMember(1).yo = Mobs(PlayerID).pos.Y + PlayerMember(1).yo * 32
   PlayerMember(2).xo = Mobs(PlayerID).pos.X + PlayerMember(2).xo * 32
   PlayerMember(2).yo = Mobs(PlayerID).pos.Y + PlayerMember(2).yo * 32
   RotationDifference = ABS(Mobs(PlayerID).pos.rot - PlayerRotOld)
   IF RotationDifference > 90 THEN RotationDifference = 180 - RotationDifference
   FOR i = 1 TO 2
      GetBPos PlayerMember(i).pos
      IF PlayerMember(i).speedDiv > 0 THEN PlayerMember(i).speedDiv = PlayerMember(i).speedDiv - 1
      ' LINE (ETSX(mobs(PlayerID).pos.x), ETSY(mobs(PlayerID).pos.y))-(ETSX(PlayerMember(i).pos.x), ETSY(PlayerMember(i).pos.y)), _RGB32(255, 255, 255)
      Angleadded = PlayerMember(i).angleanim + Mobs(PlayerID).pos.rot
      ArmsAnims PlayerMember(i), i
      IF PlayerMember(i).autoBE = -1 THEN
         PlayerMember(i).xbe = PlayerMember(i).xo + SIN((Angleadded) * PIDIV180) * PlayerMember(i).distanim
         PlayerMember(i).ybe = PlayerMember(i).yo + -COS((Angleadded) * PIDIV180) * PlayerMember(i).distanim
      END IF
      dx = (PlayerMember(i).pos.X - PlayerMember(i).xbe): dy = (PlayerMember(i).pos.Y - PlayerMember(i).ybe)
      PlayerMember(i).angle = ATan2(dy, dx) ' Angle in radians
      PlayerMember(i).angle = (PlayerMember(i).angle * 180 / PI) + 90
      IF PlayerMember(i).angle >= 180 THEN PlayerMember(i).angle = PlayerMember(i).angle - 179.9
      PlayerMember(i).xvector = SIN(PlayerMember(i).angle * PIDIV180)
      PlayerMember(i).yvector = -COS(PlayerMember(i).angle * PIDIV180)
      PlayerMember(i).speed = DistanceLow(PlayerMember(i).pos.X, PlayerMember(i).pos.Y, PlayerMember(i).xbe, PlayerMember(i).ybe) / 3
      IF PlayerMember(i).autoBE = -1 THEN PlayerMember(i).pos.X = PlayerMember(i).pos.X - (Mobs(PlayerID).pos.XM / 4): PlayerMember(i).pos.Y = PlayerMember(i).pos.Y - (Mobs(PlayerID).pos.YM / 4)
      IF Debug_Noclip = 0 THEN DoHitbox PlayerMember(i).pos: CollisionWithWallsEntity PlayerMember(i).pos
      PlayerMember(i).pos.X = PlayerMember(i).pos.X + (PlayerMember(i).xvector * PlayerMember(i).speed)
      PlayerMember(i).pos.Y = PlayerMember(i).pos.Y + (PlayerMember(i).yvector * PlayerMember(i).speed)

   NEXT
END SUB
SUB DoHitbox (Ent AS position)
   Ent.x1 = Ent.X - Ent.size
   Ent.x2 = Ent.X + Ent.size
   Ent.y1 = Ent.Y - Ent.size
   Ent.y2 = Ent.Y + Ent.size
END SUB

SUB PlayerMovement (Ent AS Entity)
   DIM dx AS DOUBLE
   DIM dy AS DOUBLE
   IF Mouse.click2 AND ControllerInput = 0 THEN
      Aiming = 1
      IF FIX(AimingTime) = 0 THEN AimingTime = 15
      AimingTime = AimingTime * 1.1
      IF AimingTime > 800 THEN AimingTime = 800
      CameraXM = CameraXM + (SIN(Ent.pos.rot * PIDIV180) * (10 + (AimingTime / 10)))
      CameraYM = CameraYM + (-COS(Ent.pos.rot * PIDIV180) * (10 + (AimingTime / 10)))
      Ent.pos.XM = Ent.pos.XM / 1.05
      Ent.pos.YM = Ent.pos.YM / 1.05
   ELSE
      AimingTime = 0
   END IF
   GetBPos Ent.pos
   PlayerRotOld = Ent.pos.rot
   IF ControllerInput = 0 THEN
      Ent.pos.VecX = ETSX(Ent.pos.X) - Mouse.pos.X
      Ent.pos.VecY = ETSY(Ent.pos.Y) - Mouse.pos.Y
   ELSE
      Ent.pos.VecX = -Joy.XVec
      Ent.pos.VecY = -Joy.YVec
   END IF
   Ent.pos.rot = ATan2(Ent.pos.VecY, Ent.pos.VecX) ' Angle in radians
   Ent.pos.rot = (Ent.pos.rot * 180 / PI) + 90
   IF Ent.pos.rot > 180 THEN Ent.pos.rot = Ent.pos.rot - 180
   IF INT(Ent.pos.rot) > -7 AND INT(Ent.pos.rot) < 1 AND Mouse.pos.Y > _HEIGHT / 2 THEN Ent.pos.rot = 180
   IF Ent.TouchX = 0 THEN Ent.pos.XM = Ent.pos.XM - (Ent.Speed * Joy.XMove): hadmovex = Joy.XMove
   IF Ent.touchY = 0 THEN Ent.pos.YM = Ent.pos.YM - (Ent.Speed * Joy.YMove): hadmovey = Joy.YMove
   IF Ent.TouchX > 0 THEN Ent.TouchX = Ent.TouchX - 1
   IF Ent.touchY > 0 THEN Ent.touchY = Ent.touchY - 1
   IF Ent.pos.XM < -Config.Player_MaxSpeed THEN Ent.pos.XM = -Config.Player_MaxSpeed
   IF Ent.pos.XM > Config.Player_MaxSpeed THEN Ent.pos.XM = Config.Player_MaxSpeed
   IF Ent.pos.YM < -Config.Player_MaxSpeed THEN Ent.pos.YM = -Config.Player_MaxSpeed
   IF Ent.pos.YM > Config.Player_MaxSpeed THEN Ent.pos.YM = Config.Player_MaxSpeed
   Ent.pos.Y = Ent.pos.Y - (Ent.pos.YM / 4)
   Ent.pos.X = Ent.pos.X - (Ent.pos.XM / 4)
   IF hadmovex = 0 THEN Ent.pos.XM = Approach0(Ent.pos.XM, Config.Player_Accel)
   IF hadmovey = 0 THEN Ent.pos.YM = Approach0(Ent.pos.YM, Config.Player_Accel)
   IF Ent.pos.Y > Map.MaxHeight * Map.TileSize THEN Ent.pos.Y = Map.MaxHeight * Map.TileSize
   IF Ent.pos.Y < Map.TileSize THEN Ent.pos.Y = Map.TileSize
   IF Ent.pos.X > Map.MaxWidth * Map.TileSize THEN Ent.pos.X = Map.MaxWidth * Map.TileSize
   IF Ent.pos.X < Map.TileSize THEN Ent.pos.X = Map.TileSize
   MakeHitboxEntity Ent
   IF Debug_Noclip = 0 THEN CollisionWithWallsEntity Mobs(PlayerID).pos
END SUB

SUB MakeHitboxEntity (Ent AS Entity)
   Ent.pos.x1 = Ent.pos.X - Ent.pos.size
   Ent.pos.x2 = Ent.pos.X + Ent.pos.size
   Ent.pos.y1 = Ent.pos.Y - Ent.pos.size
   Ent.pos.y2 = Ent.pos.Y + Ent.pos.size
END SUB

SUB RenderBottomLayer
   rendcamerax1 = FIX(FIX(CameraX * Map.TileSize) / Map.TileSize) - 1
   rendcamerax2 = FIX(FIX(CameraX * Map.TileSize) / Map.TileSize) + INT(_WIDTH / Map.TileSize) + 1
   rendcameray1 = FIX(FIX(CameraY * Map.TileSize) / Map.TileSize)
   rendcameray2 = FIX(FIX(CameraY * Map.TileSize) / Map.TileSize) + INT(_HEIGHT / Map.TileSize) + 1
   IF rendcamerax1 < 0 THEN rendcamerax1 = 0
   IF rendcameray1 < 0 THEN rendcameray1 = 0
   IF rendcamerax2 > Map.MaxWidth THEN rendcamerax2 = Map.MaxWidth
   IF rendcameray2 > Map.MaxHeight THEN rendcameray2 = Map.MaxHeight
   FOR x = rendcamerax1 TO rendcamerax2 'Map.MaxWidth
      FOR y = rendcameray1 TO rendcameray2 'Map.MaxHeight
         XCalc = WTS(x, CameraX)
         YCalc = WTS(y, CameraY)
         IF Tile(x, y, 1).ID <> 0 THEN _PUTIMAGE (XCalc, YCalc)-(XCalc + (Map.TileSize), YCalc + (Map.TileSize)), Textures(Tile(x, y, 1).ID), 0
      NEXT
   NEXT
END SUB
SUB RenderSecondLayer
   FOR x = rendcamerax1 TO rendcamerax2 'Map.MaxWidth
      FOR y = rendcameray1 TO rendcameray2 'Map.MaxHeight
         XCalc = WTS(x, CameraX)
         YCalc = WTS(y, CameraY)
         IF Tile(x, y, 2).ID <> 0 THEN _PUTIMAGE (XCalc, YCalc)-(XCalc + (Map.TileSize), YCalc + (Map.TileSize)), Textures(Tile(x, y, 2).ID), 0
      NEXT
   NEXT
END SUB

SUB RenderTopLayer
   FOR x = rendcamerax1 TO rendcamerax2 'Map.MaxWidth
      FOR y = rendcameray1 TO rendcameray2 'Map.MaxHeight
         XCalc = WTS(x, CameraX)
         YCalc = WTS(y, CameraY)
         IF Tile(x, y, 3).ID <> 0 THEN _PUTIMAGE (XCalc, YCalc)-(XCalc + (Map.TileSize), YCalc + (Map.TileSize)), Textures(Tile(x, y, 3).ID), 0
      NEXT
   NEXT
END SUB



SUB RenderMobs
   FOR i = 1 TO Config.EnemiesMax
      IF Mobs(i).Exist THEN
         RotoZoomSized ETSX(Mobs(i).pos.Xv), ETSY(Mobs(i).pos.Yv), Mobs(i).Sprite, Mobs(i).pos.size, Mobs(i).pos.rotv
         Interpolate Mobs(i).pos
      END IF
   NEXT
END SUB



SUB Explosion (x AS DOUBLE, y AS DOUBLE, strength AS DOUBLE, Size AS DOUBLE)
   FOR o = 1 TO 5
      Part(LastPart).pos.X = x
      Part(LastPart).pos.Y = y
      Part(LastPart).pos.Z = 4
      Part(LastPart).pos.XM = INT(RND * 512) - 256
      Part(LastPart).pos.YM = INT(RND * 512) - 256
      Part(LastPart).pos.ZM = 8 + INT(RND * 10)
      Part(LastPart).PartID = "Smoke"
      Part(LastPart).pos.rot = INT(RND * 360) - 180
      Part(LastPart).RotationSpeed = INT(RND * 128) - 64
      LastPart = LastPart + 1: IF LastPart > Config.ParticlesMax THEN LastPart = 0
   NEXT
   Part(LastPart).pos.X = x
   Part(LastPart).pos.Y = y
   Part(LastPart).pos.Z = 1
   Part(LastPart).pos.XM = INT(RND * 8) - 4
   Part(LastPart).pos.YM = INT(RND * 8) - 4
   Part(LastPart).pos.ZM = 20 + INT(Size / 40)
   Part(LastPart).PartID = "Explosion"
   Part(LastPart).pos.rot = INT(RND * 360) - 180
   Part(LastPart).RotationSpeed = INT(RND * 128) - 64
   LastPart = LastPart + 1: IF LastPart > Config.ParticlesMax THEN LastPart = 0

   Part(LastPart).pos.X = x
   Part(LastPart).pos.Y = y
   Part(LastPart).pos.Z = 25
   Part(LastPart).pos.XM = INT(RND * 8) - 4
   Part(LastPart).pos.YM = INT(RND * 8) - 4
   Part(LastPart).pos.ZM = 10
   Part(LastPart).PartID = "Smoke"
   Part(LastPart).pos.rot = INT(RND * 360) - 180
   Part(LastPart).RotationSpeed = INT(RND * 100) - 50
   LastPart = LastPart + 1: IF LastPart > Config.ParticlesMax THEN LastPart = 0
END SUB

FUNCTION CreateImageText (Handle AS LONG, text AS STRING, textsize AS INTEGER)
   IF Handle <> 0 THEN _FREEIMAGE Handle
   IF text = "" THEN text = " "
   _FONT FontSized(textsize)
   thx = _PRINTWIDTH(text)
   thy = _FONTHEIGHT(FontSized(textsize))
   Handleb = _NEWIMAGE(thx * 3, thy * 3, 32)
   _DEST Handleb
   _CLEARCOLOR _RGB32(0, 0, 0): _PRINTMODE _KEEPBACKGROUND: _FONT FontSized(textsize - 1): PRINT text + " "
   Handle32 = _NEWIMAGE(thx, thy, 32)
   _PUTIMAGE (0, 0), Handleb, Handle32
   Handle = _COPYIMAGE(Handle32, 33)
   _FREEIMAGE Handle32
   _DEST MainScreen
   '_PUTIMAGE (0, 0), Handleb, Handle
   _FONT FontSized(15)
   IF Handleb <> 0 THEN _FREEIMAGE Handleb
   CreateImageText = Handle
END FUNCTION

FUNCTION raycastingsimple (x AS DOUBLE, y AS DOUBLE, angle AS DOUBLE, limit AS INTEGER)
   DIM xvector AS DOUBLE: DIM yvector AS DOUBLE
   xvector = SIN(angle * PIDIV180): yvector = -COS(angle * PIDIV180)
   Ray.pos.X = x: Ray.pos.Y = y
   DO
      limit = limit - 1
      Ray.pos.X = Ray.pos.X + xvector * 6: Ray.pos.Y = Ray.pos.Y + yvector * 6
      IF limit = 0 THEN EXIT DO
      tx = FIX((Ray.pos.X) / Map.TileSize): ty = FIX((Ray.pos.Y) / Map.TileSize): IF Tile(tx, ty, 2).prop.Transparent = 0 THEN EXIT DO
   LOOP WHILE quit < 4
   raycastingsimple = 1
END FUNCTION


SUB DDA (x AS DOUBLE, y AS DOUBLE, angle AS DOUBLE)
   DIM dx AS DOUBLE, dy AS DOUBLE
   DIM stepX AS INTEGER, stepY AS INTEGER
   DIM tileX AS INTEGER, tileY AS INTEGER
   DIM sideDistX AS DOUBLE, sideDistY AS DOUBLE
   DIM deltaDistX AS DOUBLE, deltaDistY AS DOUBLE
   DIM perpWallDist AS DOUBLE
   DIM hit AS INTEGER
   DIM mapX AS DOUBLE, mapY AS DOUBLE
   DIM RaySide AS DOUBLE
   mapX = x / Map.TileSize
   mapY = y / Map.TileSize
   dx = SIN(angle * PIDIV180)
   dy = -COS(angle * PIDIV180)
   tileX = INT(mapX)
   tileY = INT(mapY)
   deltaDistX = ABS(1 / dx)
   deltaDistY = ABS(1 / dy)
   IF dx < 0 THEN
      stepX = -1: sideDistX = (mapX - tileX) * deltaDistX
   ELSE
      stepX = 1: sideDistX = (tileX + 1.0 - mapX) * deltaDistX
   END IF
   IF dy < 0 THEN
      stepY = -1: sideDistY = (mapY - tileY) * deltaDistY
   ELSE
      stepY = 1: sideDistY = (tileY + 1.0 - mapY) * deltaDistY
   END IF
   hit = 0: perpWallDist = 0
   WHILE hit = 0
      IF sideDistX < sideDistY THEN
         sideDistX = sideDistX + deltaDistX
         tileX = tileX + stepX: RaySide = 0
      ELSE
         sideDistY = sideDistY + deltaDistY
         tileY = tileY + stepY: RaySide = 1
      END IF
      IF tileX >= 0 AND tileX <= UBOUND(Tile, 1) AND tileY >= 0 AND tileY <= UBOUND(Tile, 2) THEN ' Bounds check.
         IF Tile(tileX, tileY, 2).prop.Solid THEN 'If solid, hit.
            hit = 1
         END IF
      ELSE 'Not in bounds.
         hit = 2
      END IF
      IF RaySide = 0 THEN
         perpWallDist = (tileX - mapX + (1 - stepX) / 2) / dx
      ELSE
         perpWallDist = (tileY - mapY + (1 - stepY) / 2) / dy
      END IF
   WEND
   Ray.pos.X = x + perpWallDist * dx * Map.TileSize
   Ray.pos.Y = y + perpWallDist * dy * Map.TileSize
END SUB


FUNCTION DDATarget (x AS DOUBLE, y AS DOUBLE, x2 AS DOUBLE, y2 AS DOUBLE)
   DIM dx AS DOUBLE, dy AS DOUBLE
   DIM stepX AS _BYTE, stepY AS _BYTE
   DIM tileX AS _UNSIGNED INTEGER, tileY AS _UNSIGNED INTEGER
   DIM sideDistX AS DOUBLE, sideDistY AS DOUBLE
   DIM deltaDistX AS DOUBLE, deltaDistY AS DOUBLE
   DIM perpWallDist AS DOUBLE
   DIM hit AS INTEGER
   DIM mapX AS DOUBLE, mapY AS DOUBLE
   DIM RaySide AS DOUBLE
   DIM TargetX AS LONG, TargetY AS LONG
   DIM BlocksHit AS DOUBLE
   dx = x - x2
   dy = y - y2
   angle = ATan2(dy, dx) ' Angle in radians
   angle = (angle * 180 / PI) + 90
   IF angle > 180 THEN angle = angle - 179.9
   TargetX = FIX(x2 / Map.TileSize)
   TargetY = FIX(y2 / Map.TileSize)
   mapX = x / Map.TileSize
   mapY = y / Map.TileSize
   dx = SIN(angle * PIDIV180)
   dy = -COS(angle * PIDIV180)
   tileX = FIX(mapX)
   tileY = FIX(mapY)
   deltaDistX = ABS(1 / dx)
   deltaDistY = ABS(1 / dy)
   IF dx < 0 THEN
      stepX = -1: sideDistX = (mapX - tileX) * deltaDistX
   ELSE
      stepX = 1: sideDistX = (tileX + 1.0 - mapX) * deltaDistX
   END IF
   IF dy < 0 THEN
      stepY = -1: sideDistY = (mapY - tileY) * deltaDistY
   ELSE
      stepY = 1: sideDistY = (tileY + 1.0 - mapY) * deltaDistY
   END IF
   hit = 0: perpWallDist = 0
   BlocksHit = 1
   WHILE hit = 0
      IF sideDistX < sideDistY THEN
         sideDistX = sideDistX + deltaDistX
         tileX = tileX + stepX: RaySide = 0
      ELSE
         sideDistY = sideDistY + deltaDistY
         tileY = tileY + stepY: RaySide = 1
      END IF
      IF tileX >= 0 AND tileX <= UBOUND(Tile, 1) AND tileY >= 0 AND tileY <= UBOUND(Tile, 2) THEN ' Bounds check.
         IF tileX = TargetX AND tileY = TargetY THEN
            DDATarget = BlocksHit
            hit = 1
         END IF
         IF Tile(tileX, tileY, 2).prop.Solid AND Tile(tileX, tileY, 2).prop.Transparent = 0 THEN
            BlocksHit = (BlocksHit ^ 2) + 0.5
         END IF
      ELSE 'Not in bounds.
         hit = 2
      END IF
      IF RaySide = 0 THEN
         perpWallDist = (tileX - mapX + (1 - stepX) / 2) / dx
      ELSE
         perpWallDist = (tileY - mapY + (1 - stepY) / 2) / dy
      END IF
   WEND
   DDATarget = BlocksHit
   Ray.pos.X = x + perpWallDist * dx * Map.TileSize
   Ray.pos.Y = y + perpWallDist * dy * Map.TileSize
END FUNCTION


FUNCTION IsInFOV (entityAngle AS DOUBLE, targetAngle AS DOUBLE, fovDegrees AS DOUBLE)
   ' Normalize angles to be between -180 and 180
   entityAngle = entityAngle - 360 * INT((entityAngle + 180) / 360)
   targetAngle = targetAngle - 360 * INT((targetAngle + 180) / 360)
   ' Calculate the angular difference (shortest path)
   DIM diff AS DOUBLE
   diff = ABS(entityAngle - targetAngle)
   ' Take the shortest angular distance (wrap around 360 degrees)
   IF diff > 180 THEN
      diff = 360 - diff
   END IF
   ' Check if within FOV (half on each side of entity angle)
   IF diff <= fovDegrees / 2 THEN
      IsInFOV = 1 ' True
   ELSE
      IsInFOV = -diff ' False
   END IF
END FUNCTION

FUNCTION IsInView (x AS DOUBLE, y AS DOUBLE, x2 AS DOUBLE, y2 AS DOUBLE, hitbox AS DOUBLE, stepsize AS DOUBLE, tolerance AS INTEGER)
   IsInView = 0
   DIM Xvecsize AS DOUBLE
   DIM Yvecsize AS DOUBLE
   dx = x - x2: dy = y - y2
   Rotation = ATan2(dy, dx) ' Angle in radians
   Rotation = (Rotation * 180 / PI) + 90
   IF Rotation > 180 THEN Rotation = Rotation - 179.9
   DIM xvector AS DOUBLE: DIM yvector AS DOUBLE
   Ray.pos.X = x: Ray.pos.Y = y
   amountsonwall = 0
   Xvecsize = xvector * stepsize
   Yvecsize = yvector * stepsize
   DO
      ' Line (0, 0)-(_Width, _Height), _RGBA(0, 0, 0, 4), BF
      '  oldrayx = Ray.pos.x: oldrayy = Ray.y
      Ray.pos.X = Ray.pos.X + Xvecsize
      Ray.pos.Y = Ray.pos.Y + Yvecsize
      tx = FIX((Ray.pos.X) / Map.TileSize): ty = FIX((Ray.pos.Y) / Map.TileSize): IF Tile(tx, ty, 2).ID <> 0 THEN
         amountsonwall = amountsonwall - 1
         tolerance = tolerance - 1
         IsInView = amountsonwall
         IF tolerance <= 0 THEN EXIT DO
      END IF

      IF Ray.pos.X + 1 >= x2 - hitbox THEN
         IF Ray.pos.X - 1 <= x2 + hitbox THEN
            IF Ray.pos.Y + 1 >= y2 - hitbox THEN
               IF Ray.pos.Y - 1 <= y2 + hitbox THEN
                  IsInView = -1
                  EXIT DO
               END IF
            END IF
         END IF
      END IF
   LOOP
END FUNCTION

FUNCTION ShadowView (x AS DOUBLE, y AS DOUBLE, x2 AS DOUBLE, y2 AS DOUBLE, hitbox AS DOUBLE, stepsize AS DOUBLE, tolerance AS INTEGER, entangle AS DOUBLE, fol AS DOUBLE)
   ShadowView = 0
   DIM Xvecsize AS DOUBLE
   DIM Yvecsize AS DOUBLE
   inittol = tolerance
   dx = x - x2: dy = y - y2
   Rotation = ATan2(dy, dx) ' Angle in radians
   Rotation = (Rotation * 180 / PI) + 90
   IF Rotation > 180 THEN Rotation = Rotation - 179.9

   DIM xvector AS DOUBLE: DIM yvector AS DOUBLE
   Ray.pos.X = x: Ray.pos.Y = y
   amountsonwall = 0
   xvector = SIN(Rotation * PIDIV180): yvector = -COS(Rotation * PIDIV180)
   Xvecsize = xvector * stepsize
   Yvecsize = yvector * stepsize
   DO
      oldrayx = Ray.pos.X: oldrayy = Ray.pos.Y
      Ray.pos.X = Ray.pos.X + Xvecsize
      Ray.pos.Y = Ray.pos.Y + Yvecsize
      IF NOT CheckIfBounds(Ray.pos.X / Map.TileSize, Ray.pos.Y / Map.TileSize) THEN EXIT FUNCTION
      tx = FIX((Ray.pos.X) / Map.TileSize): ty = FIX((Ray.pos.Y) / Map.TileSize)

      IF CheckIfBounds(tx, ty) THEN IF Tile(tx, ty, 2).ID <> 0 AND Tile(tx, ty, 2).prop.Transparent = 0 THEN

            amountsonwall = amountsonwall + 5
            tolerance = tolerance - 1
            ShadowView = amountsonwall * 2
            IF tolerance <= 0 THEN ShadowView = amountsonwall * inittol: EXIT DO
         END IF
      END IF
      IF Ray.pos.X + 1 >= x2 - hitbox THEN IF Ray.pos.X - 1 <= x2 + hitbox THEN IF Ray.pos.Y + 1 >= y2 - hitbox THEN IF Ray.pos.Y - 1 <= y2 + hitbox THEN EXIT DO
   LOOP
END FUNCTION

FUNCTION CheckIfBounds (x AS LONG, y AS LONG)
   CheckIfBounds = 0
   IF x > 0 THEN IF y > 0 THEN
         IF x < Map.MaxWidth THEN IF y < Map.MaxHeight THEN CheckIfBounds = -1
      END IF
   END IF
END FUNCTION

FUNCTION IsBetween% (X AS SINGLE, A AS SINGLE, B AS SINGLE)
   IF A <= B THEN
      ' If A <= B, check if X is between A and B
      IsBetween% = (X >= A) AND (X <= B)
   ELSE
      ' If A > B, check if X is in the wrap-around segment
      IsBetween% = (X >= A) OR (X <= B)
   END IF
END FUNCTION


SUB BulletRay (x AS DOUBLE, y AS DOUBLE, angle AS DOUBLE, damage AS DOUBLE)
   DIM xvector AS DOUBLE: DIM yvector AS DOUBLE
   DIM TileX AS _UNSIGNED LONG
   DIM TileY AS _UNSIGNED LONG
   xvector = SIN(angle * PIDIV180) * 6: yvector = -COS(angle * PIDIV180) * 6
   Ray.pos.X = x: Ray.pos.Y = y: Ray.owner = owner
   DO
      Ray.pos.X = Ray.pos.X + xvector: Ray.pos.Y = Ray.pos.Y + yvector
      TileX = FIX(Ray.pos.X / Map.TileSize)
      TileY = FIX(Ray.pos.Y / Map.TileSize)
      IF Tile(TileX, TileY, 2).prop.Solid THEN
         IF Tile(TileX, TileY, 2).prop.Fragile = 0 THEN
            IF Tile(TileX, TileY, 2).prop.Health >= 0 THEN
               Tile(TileX, TileY, 2).prop.Health = Tile(TileX, TileY, 2).prop.Health - damage
               IF Tile(TileX, TileY, 2).prop.Health < 0 THEN TileBreak TileX, TileY, 2
            END IF
            EXIT DO
         ELSE
            TileBreak TileX, TileY, 2
         END IF
      END IF
      FOR e = 0 TO Config.EnemiesMax
         IF DistanceLow(Ray.pos.X, Ray.pos.Y, Mobs(e).pos.X, Mobs(e).pos.Y) < Mobs(e).pos.size THEN
            EntityTakeDamage Mobs(e), Ray.pos.X, Ray.pos.Y, damage
            EXIT DO
         END IF
      NEXT
   LOOP
END SUB
SUB TileBreak (X AS _UNSIGNED LONG, Y AS _UNSIGNED LONG, Z AS _UNSIGNED LONG)
   FOR i = 1 TO 5
      SpawnParticleSimple (X * Map.TileSize) + TSR, (Y * Map.TileSize) + TSR, "BLOCKBREAK", RNDND(32), RNDND(36)
   NEXT
   Tile(X, Y, Z).ID = 0
   Tile(X, Y, Z).prop.Solid = 0
END SUB
FUNCTION TSR
   TSR = (RND * Map.TileSize)
END FUNCTION
FUNCTION RNDN (Value AS _UNSIGNED INTEGER)
   RNDN = INT(RND * (Value * 2)) - Value
END FUNCTION
FUNCTION RNDND (Value AS _UNSIGNED INTEGER)
   RNDND = (RND * (Value * 2)) - Value
END FUNCTION

FUNCTION Distance (x1, y1, x2, y2)
   Distance = SQR(((x1 - x2) ^ 2) + ((y1 - y2) ^ 2))
END FUNCTION

FUNCTION DistanceLow (x1, y1, x2, y2)
   DistanceLow = ABS(x1 - x2) + ABS(y1 - y2)
END FUNCTION


SUB EntityTakeDamage (Ent AS Entity, X, Y, Damage)
   DIM Rotation AS DOUBLE
   dx = Ent.pos.X - X: dy = Ent.pos.Y - Y
   Rotation = ATan2(dy, dx) ' Angle in radians
   Rotation = (Rotation * 180 / PI) + 90
   IF Rotation > 180 THEN Rotation = Rotation - 179.9
   xvector = SIN(Rotation * PIDIV180)
   yvector = -COS(Rotation * PIDIV180)
   AddY = yvector * (Damage * 2)
   AddX = xvector * (Damage * 2)
   Ent.pos.YM = Ent.pos.YM - (AddY / Ent.Weight)
   Ent.pos.XM = Ent.pos.XM - (AddX / Ent.Weight)
   Ent.DamageTaken = ABS(Damage)
   SELECT CASE Ent.Class
      CASE "ZOMBIE"
         FOR i = 1 TO INT(Damage / 3)
            SpawnParticleSimple Ent.pos.X + RNDN(Ent.pos.size / 4), Ent.pos.Y + RNDN(Ent.pos.size / 4), "GREEN_BLOOD", AddY, AddX
         NEXT
   END SELECT
END SUB

SUB CollisionWithWallsEntity (Ent AS position)
   DIM Rotation AS DOUBLE
   DIM X AS _UNSIGNED LONG
   DIM Y AS _UNSIGNED LONG
   DIM Dist AS DOUBLE
   FOR X = FIX(Ent.x1 / Map.TileSize) TO FIX(Ent.x2 / Map.TileSize)
      FOR Y = FIX(Ent.y1 / Map.TileSize) TO FIX(Ent.y2 / Map.TileSize)
         IF Tile(X, Y, 2).prop.Solid THEN
            X1 = X * Map.TileSize: Y1 = Y * Map.TileSize
            X2 = (X + 1) * Map.TileSize: Y2 = (Y + 1) * Map.TileSize
            XP = Ent.X
            YP = Ent.Y
            IF XP > X2 THEN XP = X2
            IF XP < X1 THEN XP = X1
            IF YP > Y2 THEN YP = Y2
            IF YP < Y1 THEN YP = Y1
            Dist = Distance(Ent.X, Ent.Y, XP, YP)
            IF Dist < Ent.size THEN
               dx = Ent.X - XP: dy = Ent.Y - YP
               Rotation = ATan2(dy, dx) ' Angle in radians
               Rotation = (Rotation * 180 / PI) + 90
               IF Rotation > 180 THEN Rotation = Rotation - 179.99
               Ent.Y = Ent.Y - (-COS(Rotation * PIDIV180) * ((Ent.size + 0.5) - Dist))
               Ent.X = Ent.X - (SIN(Rotation * PIDIV180) * ((Ent.size + 0.5) - Dist))
               Touched = 1
            END IF
         END IF
      NEXT
   NEXT
   IF Touched = 1 THEN Ent.YM = (Ent.YM / 1.1): Ent.XM = (Ent.XM / 1.1): SUBOutUINT = 1
END SUB


FUNCTION CalculatePercentage (Number AS DOUBLE, Percentage AS DOUBLE)
   DIM Result AS DOUBLE
   Result = (Percentage / Number) * 100
   CalculatePercentage = Result
END FUNCTION
FUNCTION ATan2 (y AS SINGLE, x AS SINGLE)
   DIM AtanResult AS SINGLE
   IF x = 0 THEN
      IF y > 0 THEN
         AtanResult = PI / 2
      ELSEIF y < 0 THEN
         AtanResult = -PI / 2
      ELSE
         AtanResult = 0
      END IF
   ELSE
      AtanResult = ATN(y / x)
      IF x < 0 THEN
         IF y >= 0 THEN AtanResult = AtanResult + PI
      ELSE AtanResult = AtanResult - PI
      END IF
   END IF
   ATan2 = AtanResult
END FUNCTION

FUNCTION ETSX (e)
   ETSX = e - (CameraX) * Map.TileSize
END FUNCTION
FUNCTION ETSY (e)
   ETSY = e - (CameraY) * Map.TileSize
END FUNCTION

FUNCTION WTS (w, Camera)
   WTS = (w - Camera) * Map.TileSize
END FUNCTION

FUNCTION STWX (s)
   STWX = (s + CameraX) / Map.TileSize
END FUNCTION
FUNCTION STWY (s)
   STWY = (s + CameraY) / Map.TileSize
END FUNCTION


SUB RotoZoom (X AS LONG, Y AS LONG, Image AS LONG, Scale AS SINGLE, Rotation AS SINGLE)
   DIM px(3) AS SINGLE: DIM py(3) AS SINGLE
   W& = _WIDTH(Image&): H& = _HEIGHT(Image&)
   px(0) = -W& / 2: py(0) = -H& / 2: px(1) = -W& / 2: py(1) = H& / 2
   px(2) = W& / 2: py(2) = H& / 2: px(3) = W& / 2: py(3) = -H& / 2
   sinr! = SIN(-Rotation / 57.2957795131): cosr! = COS(-Rotation / 57.2957795131)
   FOR i& = 0 TO 3
      x2& = (px(i&) * cosr! + sinr! * py(i&)) * Scale + X: y2& = (py(i&) * cosr! - px(i&) * sinr!) * Scale + Y
      px(i&) = x2&: py(i&) = y2&
   NEXT
   _MAPTRIANGLE (0, 0)-(0, H& - 1)-(W& - 1, H& - 1), Image& TO(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
   _MAPTRIANGLE (0, 0)-(W& - 1, 0)-(W& - 1, H& - 1), Image& TO(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
END SUB

SUB RotoZoomSized (X AS LONG, Y AS LONG, Image AS LONG, Sc1 AS SINGLE, Rotation AS SINGLE)
   DIM px(3) AS DOUBLE: DIM py(3) AS DOUBLE
   Sc1 = Sc1 * 2
   W& = _WIDTH(Image&): H& = _HEIGHT(Image&): M# = (W& / H&)
   px(0) = -(Sc1) / 2: py(0) = -((Sc1)) / 2 / M#
   px(1) = -(Sc1) / 2: py(1) = ((Sc1)) / 2 / M#
   px(2) = (Sc1) / 2: py(2) = ((Sc1)) / 2 / M#
   px(3) = (Sc1) / 2: py(3) = -((Sc1)) / 2 / M#
   sinr! = SIN(-Rotation / 57.2957795131): cosr! = COS(-Rotation / 57.2957795131)
   FOR i& = 0 TO 3
      x2& = (px(i&) * cosr! + sinr! * py(i&)) + X
      y2& = (py(i&) * cosr! - px(i&) * sinr!) + Y
      px(i&) = x2&: py(i&) = y2&
   NEXT
   _MAPTRIANGLE (0, 0)-(0, H& - 1)-(W& - 1, H& - 1), Image& TO(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
   _MAPTRIANGLE (0, 0)-(W& - 1, 0)-(W& - 1, H& - 1), Image& TO(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
END SUB

FUNCTION NewINSTR (start AS _UNSIGNED INTEGER, text AS STRING, desired AS STRING)
   NewINSTR = INSTR(start, text, desired) + LEN(desired)
END FUNCTION


FUNCTION LoadMap (MapName AS STRING)
   LoadMap = 0
   Map.Title = MapName
   OPEN (VantiroPath + "/Maps/" + MapName + ".tmx") FOR INPUT AS #1
   DIM Liner AS STRING
   DIM LoadingLayer AS _UNSIGNED INTEGER
   DIM IDD AS STRING
   DO
      INPUT #1, Liner
      IF INSTR(0, Liner, "<map") THEN
         'if instr(0,Liner ,)
         Num = NewINSTR(0, Liner, ("width=" + CHR$(34)))
         Map.MaxWidth = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))

         Num = NewINSTR(0, Liner, ("height=" + CHR$(34)))
         Map.MaxHeight = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))

         Num = NewINSTR(0, Liner, ("tilewidth=" + CHR$(34)))
         Map.TileSize = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num)) * 2
         Map.TileSizeHalf = Map.TileSize
         Num = NewINSTR(0, Liner, ("nextlayerid=" + CHR$(34)))
         Map.Layers = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num)) - 1
         REDIM Tile(Map.MaxWidth + 5, Map.MaxHeight + 5, Map.Layers) AS Tiles
      END IF

      IF INSTR(0, Liner, "</map>") THEN EXIT DO
      IF INSTR(0, Liner, "<layer") THEN
         Num = NewINSTR(0, Liner, ("id=" + CHR$(34)))
         LoadingLayer = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))
         INPUT #1, Liner
         z = LoadingLayer
         FOR y = 1 TO Map.MaxHeight
            FOR x = 1 TO Map.MaxWidth
               IF x <= Map.MaxWidth THEN INPUT #1, IDD
               IF x = Map.MaxWidth THEN INPUT #1, trash
               Tile(x, y, LoadingLayer).ID = VAL(IDD)
            NEXT
         NEXT
      END IF
   LOOP
   CLOSE #1

   OPEN (VantiroPath + "/Maps/" + MapName + ".info") FOR INPUT AS #1
   DIM GetID AS _UNSIGNED INTEGER
   FOR i = 0 TO 512
      TileProp(i).Health = -1
      TileProp(i).Solid = -1
      TileProp(i).IsFluid = 0
      TileProp(i).SetFire = 0
      TileProp(i).LightLevel = 0
      TileProp(i).DamageOnStep = 0
   NEXT
   TileProp(0).Solid = 0
   DO
      INPUT #1, Liner
      IF INSTR(0, Liner, "DisplayName") THEN Num = NewINSTR(0, Liner, ("DisplayName=" + CHR$(34))): Map.DisplayName = (MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))
      IF INSTR(0, Liner, "Tileset") THEN Num = NewINSTR(0, Liner, ("Tileset=" + CHR$(34))): Map.Tileset = (MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))
      IF INSTR(0, Liner, "AmbientLight") THEN Num = NewINSTR(0, Liner, ("AmbientLight=" + CHR$(34))): Map.AmbientLight = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))
      IF INSTR(0, Liner, "Weather") THEN Num = NewINSTR(0, Liner, ("Weather=" + CHR$(34))): Map.Weather = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))
      IF INSTR(0, Liner, "TextureSize") THEN Num = NewINSTR(0, Liner, ("TextureSize=" + CHR$(34))): Map.TextureSize = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))
      Echo "--- MAP SETTINGS ---"
      Echo "  DisplayName: " + Map.DisplayName
      Echo "  Tileset: " + Map.Tileset
      Echo "  TextureSize: " + STR$(Map.TextureSize)
      IF INSTR(0, Liner, "{EndFile}") THEN EXIT DO
      IF INSTR(0, Liner, "TilesProperties:{{{") THEN
         DO
            INPUT #1, Liner
            IF INSTR(0, Liner, "ID=") THEN
               Num = NewINSTR(0, Liner, ("ID=" + CHR$(34)))
               GetID = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num)) + 1
               IF INSTR(0, Liner, "Fluid") THEN TileProp(GetID).IsFluid = -1
               IF INSTR(0, Liner, "NotSolid") THEN TileProp(GetID).Solid = 0
               IF INSTR(0, Liner, "SetFire") THEN TileProp(GetID).SetFire = -1
               IF INSTR(0, Liner, "LightLevel") THEN
                  Num = NewINSTR(0, Liner, ("LightLevel=" + CHR$(34)))
                  TileProp(GetID).LightLevel = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))
               END IF
               IF INSTR(0, Liner, "DamageOnStep") THEN
                  Num = NewINSTR(0, Liner, ("DamageOnStep=" + CHR$(34)))
                  TileProp(GetID).DamageOnStep = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))
               END IF
               IF INSTR(0, Liner, "Health") THEN
                  Num = NewINSTR(0, Liner, ("Health=" + CHR$(34)))
                  TileProp(GetID).Health = VAL(MID$(Liner, Num, INSTR(Num, Liner, CHR$(34)) - Num))
               END IF
            END IF
            IF INSTR(0, Liner, "}}}") THEN EXIT DO
         LOOP
      END IF
   LOOP
   CLOSE #1
   'Optimize

   FOR x = 0 TO Map.MaxWidth
      FOR y = 0 TO Map.MaxHeight
         IF Tile(x, y, 2).ID <> 0 THEN Tile(x, y, 1).ID = 0
         Tile(x, y, 0).toplayer = 1
         IF Tile(x, y, 1).ID <> 0 THEN Tile(x, y, 0).toplayer = 2
         IF Tile(x, y, 2).ID <> 0 THEN Tile(x, y, 0).toplayer = 3
         IF Tile(x, y, 3).ID <> 0 THEN Tile(x, y, 0).toplayer = 4
      NEXT
   NEXT
   'Apply properties
   FOR x = 0 TO Map.MaxWidth
      FOR y = 0 TO Map.MaxHeight
         FOR z = 0 TO 3
            GetID = Tile(x, y, z).ID
            Tile(x, y, z).prop.Health = TileProp(GetID).Health
            Tile(x, y, z).prop.Solid = TileProp(GetID).Solid
            Tile(x, y, z).prop.IsFluid = TileProp(GetID).IsFluid
            Tile(x, y, z).prop.SetFire = TileProp(GetID).SetFire
            Tile(x, y, z).prop.LightLevel = TileProp(GetID).LightLevel
            Tile(x, y, z).prop.DamageOnStep = TileProp(GetID).DamageOnStep
         NEXT
         '  IF Tile(x, y, 2).ID <> 0 THEN Tile(x, y, 2).solid = 1
      NEXT
   NEXT

   CloseIMG TileSet: TileSet = LoadImage(1, "Tilesets/" + _TRIM$(Map.Tileset) + ".png", 33)
   CloseIMG TileSetSoft: TileSetSoft = LoadImage(1, "Tilesets/" + _TRIM$(Map.Tileset) + ".png", 32)

   LoadMap = -1
END FUNCTION

SUB GenerateTexturesFromTileSet
   DIM x AS _UNSIGNED INTEGER
   DIM y AS _UNSIGNED INTEGER
   DIM total AS _UNSIGNED INTEGER
   DIM Trash AS LONG
   total = 1
   x = -1
   y = 0
   DO
      x = x + 1
      IF x * Map.TextureSize < _WIDTH(TileSetSoft) THEN
         Echo "GenTxt: " + STR$(x) + " , " + STR$(y)
         Trash = _NEWIMAGE(Map.TextureSize, Map.TextureSize, 32)
         _PUTIMAGE (0, 0), TileSetSoft, Trash, (x * Map.TextureSize, y * Map.TextureSize)-((x * Map.TextureSize) + Map.TextureSize, (y * Map.TextureSize) + Map.TextureSize)
         Textures(total) = _COPYIMAGE(Trash, 33)
         CloseIMG Trash
         total = total + 1
      ELSE
         x = -1
         y = y + 1
      END IF
      IF y * Map.TextureSize > _HEIGHT(TileSetSoft) THEN
         EXIT DO
      END IF
   LOOP
END SUB

FUNCTION RayCollideEntity (Rect1 AS Raycast, rect2 AS Entity)
   RayCollideEntity = 0
   IF Rect1.pos.X >= rect2.pos.x1 THEN
      IF Rect1.pos.X <= rect2.pos.x2 THEN
         IF Rect1.pos.Y >= rect2.pos.y1 THEN
            IF Rect1.pos.Y <= rect2.pos.y2 THEN
               RayCollideEntity = -1
            END IF
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION TriggerEntityCollide (Rect1 AS Entity, Rect2 AS Trigger)
   TriggerEntityCollide = 0
   IF Rect1.pos.x2 >= Rect2.x1 THEN
      IF Rect1.pos.x1 <= Rect2.x2 THEN
         IF Rect1.pos.y2 >= Rect2.y1 THEN
            IF Rect1.pos.y1 <= Rect2.y2 THEN
               TriggerEntityCollide = -1
            END IF
         END IF
      END IF
   END IF
END FUNCTION

SUB LoadConfigs
   DIM trash$
   OPEN (VantiroPath + "/config.ini") FOR INPUT AS #4
   INPUT #4, version
   INPUT #4, trash$
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_SmoothingY = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_SmoothingX = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_Distselfall = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_Distselmult = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_Size = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_Side = (_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_Fade = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_XMYMDivide = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_SelectedColor = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Hud_UnSelectedColor = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, trash$
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Game_Lighting = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Game_Interpolation = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Game_Cheats = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, trash$
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Player_MaxSpeed = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Player_Accel = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Player_Size = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Player_MaxHealth = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Player_HealthPerBlood = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Player_DamageMultiplier = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, trash$
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Wave_End = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Wave_ZombieMultiplier = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Wave_ZombieRandom = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.Wave_TimeLimit = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, trash$
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.ParticlesMax = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.EnemiesMax = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   INPUT #4, line$: InsEqual = INSTR(1, line$, "=") + 1: InsApo = INSTR(1, line$, "'") - 1
   Config.FireMax = VAL(_TRIM$((MID$(line$, InsEqual, InsApo - InsEqual))))
   CLOSE #4
   Config.Hud_SelRed = _RED32(Config.Hud_SelectedColor)
   Config.Hud_SelGreen = _GREEN32(Config.Hud_SelectedColor)
   Config.Hud_SelBlue = _BLUE32(Config.Hud_SelectedColor)
   Config.Hud_UnSelRed = _RED32(Config.Hud_UnSelectedColor)
   Config.Hud_UnSelGreen = _GREEN32(Config.Hud_UnSelectedColor)
   Config.Hud_UnSelBlue = _BLUE32(Config.Hud_UnSelectedColor)
END SUB

SUB SaveConfig
   OPEN (VantiroPath + "/config.ini") FOR OUTPUT AS #4
   PRINT #4, "'# Hud settings."
   PRINT #4, "Config.Hud_SmoothingY = " + _TRIM$(STR$(Config.Hud_SmoothingY)) + " ' (Def: 10)"
   PRINT #4, "Config.Hud_SmoothingX = " + _TRIM$(STR$(Config.Hud_SmoothingX)) + " ' (Def: 10)"
   PRINT #4, "Config.Hud_Distselfall = " + _TRIM$(STR$(Config.Hud_Distselfall)) + " ' (Def: 4)"
   PRINT #4, "Config.Hud_Distselmult = " + _TRIM$(STR$(Config.Hud_Distselmult)) + " ' (Def: 5)"
   PRINT #4, "Config.Hud_Size = " + _TRIM$(STR$(Config.Hud_Size)) + " ' (Def: 35)"
   PRINT #4, "Config.Hud_Side = " + _TRIM$((Config.Hud_Side)) + " ' (Def: Down)"
   PRINT #4, "Config.Hud_Fade = " + _TRIM$(STR$(Config.Hud_Fade)) + " ' (Def: 50)"
   PRINT #4, "Config.Hud_XMYMDivide = " + _TRIM$(STR$(Config.Hud_XMYMDivide)) + " ' (Def: 1.075)"
   PRINT #4, "Config.Hud_SelectedColor = " + _TRIM$(STR$(Config.Hud_SelectedColor)) + " ' (Def: -1)"
   PRINT #4, "Config.Hud_UnSelectedColor = " + _TRIM$(STR$(Config.Hud_UnSelectedColor)) + " ' (Def: -8355712)"
   PRINT #4, "'# Game settings."
   PRINT #4, "Config.Game_Lighting = " + _TRIM$(STR$(Config.Game_Lighting)) + " ' (Def: 1)"
   PRINT #4, "Config.Game_Interpolation = " + _TRIM$(STR$(Config.Game_Interpolation)) + " ' (Def: 1)"
   PRINT #4, "Config.Game_Cheats = " + _TRIM$(STR$(Config.Game_Cheats)) + " ' (Def: 1)"
   PRINT #4, "'# Player settings."
   PRINT #4, "Config.Player_MaxSpeed = " + _TRIM$(STR$(Config.Player_MaxSpeed)) + " ' (Def: 70)"
   PRINT #4, "Config.Player_Accel = " + _TRIM$(STR$(Config.Player_Accel)) + " ' (Def: 3)"
   PRINT #4, "Config.Player_Size = " + _TRIM$(STR$(Config.Player_Size)) + " ' (Def: 25) "
   PRINT #4, "Config.Player_MaxHealth = " + _TRIM$(STR$(Config.Player_MaxHealth)) + " ' (Def: 101)"
   PRINT #4, "Config.Player_HealthPerBlood = " + _TRIM$(STR$(Config.Player_HealthPerBlood)) + " ' (Def: 0.11)"
   PRINT #4, "Config.Player_DamageMultiplier = " + _TRIM$(STR$(Config.Player_DamageMultiplier)) + " ' (Def: 1)"
   PRINT #4, "'# Waves settings."
   PRINT #4, "Config.Wave_End = " + _TRIM$(STR$(Config.Wave_End)) + " ' (Def: 11)"
   PRINT #4, "Config.Wave_ZombieMultiplier = " + _TRIM$(STR$(Config.Wave_ZombieMultiplier)) + " ' (Def: 7)"
   PRINT #4, "Config.Wave_ZombieRandom = " + _TRIM$(STR$(Config.Wave_ZombieRandom)) + " ' (Def: 22)"
   PRINT #4, "Config.Wave_TimeLimit = " + _TRIM$(STR$(Config.Wave_TimeLimit)) + " ' (Def: -1)"
   PRINT #4, "'# Limit settings."
   PRINT #4, "Config.ParticlesMax = " + _TRIM$(STR$(Config.ParticlesMax)) + " ' (Def: 600)"
   PRINT #4, "Config.EnemiesMax = " + _TRIM$(STR$(Config.EnemiesMax)) + " ' (Def: 190)"
   PRINT #4, "Config.FireMax = " + _TRIM$(STR$(Config.FireMax)) + " ' (Def: 128)"
   CLOSE #4
END SUB


SUB CalcLightingDynLow (Light AS LightSource)
   sizeoflight = FIX(Light.strength / 25)
   IF sizeoflight > 10 THEN sizeoflight = 10
   xmin = FIX(Light.pos.X / Map.TileSize) - sizeoflight
   xmax = FIX(Light.pos.X / Map.TileSize) + sizeoflight
   ymin = FIX(Light.pos.Y / Map.TileSize) - sizeoflight
   ymax = FIX(Light.pos.Y / Map.TileSize) + sizeoflight
   IF xmin < 0 THEN xmin = 0
   IF ymin < 0 THEN ymin = 0
   IF xmin > Map.MaxWidth THEN xmax = Map.MaxWidth
   IF ymax > Map.MaxWidth THEN ymax = Map.MaxHeight
   FOR x = xmin TO xmax
      FOR y = ymin TO ymax
         XV = (x * Map.TileSize) + MapTileSizeHalf
         YV = (y * Map.TileSize) + MapTileSizeHalf
         IF Light.LightType = 2 THEN
            dx = Light.pos.X - XV: dy = Light.pos.Y - YV
            Rotation = ATan2(dy, dx) ' Angle in radians
            Rotation = (Rotation * 180 / PI) + 90
            IF Rotation > 180 THEN Rotation = Rotation - 179.9
            IsFov = IsInFOV(Light.pos.rot, Rotation, Light.Fov) ' <> 0
         END IF
         dist = INT(DistanceLow(XV, YV, Light.pos.X, Light.pos.Y)) - (Light.strength)
         newlight = (Light.strength - dist) + (IsFov * (Light.strength / 25))
         IF Tile(x, y, 2).ID <> 0 THEN
            df = ABS(newlight - 255)
            newlight = newlight - (df)
         END IF
         IF Tile(x, y, 0).dlight < newlight THEN Tile(x, y, 0).dlight = newlight
         IF Tile(x, y, 0).dlight < 0 THEN Tile(x, y, 0).dlight = 0
         IF Tile(x, y, 0).dlight > 255 THEN Tile(x, y, 0).dlight = 255
      NEXT
   NEXT
END SUB


SUB RenderLighting
   'render
   FOR x = rendcamerax1 TO rendcamerax2 'Map.MaxWidth
      FOR y = rendcameray1 TO rendcameray2 'Map.MaxHeight
         XCalc = (WTS(x, CameraX))
         YCalc = (WTS(y, CameraY))
         XCalc2 = (XCalc + Map.TileSize)
         YCalc2 = (YCalc + Map.TileSize)
         light = Tile(x, y, 0).dlight + (Tile(x, y, 0).alight - INT(RND * 3))
         _PUTIMAGE (XCalc, YCalc)-(XCalc2, YCalc2), Shadowgradient, 0, (light, 0)-(light, 1)
      NEXT
   NEXT
END SUB

SUB LightingLogic
   CalcLightingClear
   FOR i = 1 TO DynamicLightMax
      IF DynamicLight(i).exist THEN
         LogicLightingDyn DynamicLight(i)
         SELECT CASE DynamicLight(i).Detail
            CASE "Normal"
               IF Config.Game_Lighting = 1 THEN
                  CalcLightingDyn DynamicLight(i)
               ELSEIF Config.Game_Lighting = 2 THEN
                  CalcLightingDynHigh DynamicLight(i)
               ELSEIF Config.Game_Lighting = 3 THEN
                  CalcLightingDynLow DynamicLight(i)
               END IF
            CASE "Low": CalcLightingDynLow DynamicLight(i)
         END SELECT
      END IF
   NEXT
END SUB

SUB CalcLightingClear
   xmin = FIX(FIX(CameraX * Map.TileSize) / Map.TileSize) - 1
   xmax = FIX(FIX(CameraX * Map.TileSize) / Map.TileSize) + INT(_WIDTH / Map.TileSize) + 1
   ymin = FIX(FIX(CameraY * Map.TileSize) / Map.TileSize)
   ymax = FIX(FIX(CameraY * Map.TileSize) / Map.TileSize) + INT(_HEIGHT / Map.TileSize) + 1
   FOR x = xmin TO xmax
      FOR y = ymin TO ymax
         Tile(x, y, 0).dlight = Map.AmbientLight
      NEXT
   NEXT
END SUB

SUB CalcLightingDynHigh (Light AS LightSource)
   sizeoflight = FIX(Light.strength / 25)
   IF sizeoflight > 10 THEN sizeoflight = 10
   xmin = FIX(Light.pos.X / Map.TileSize) - sizeoflight
   xmax = FIX(Light.pos.X / Map.TileSize) + sizeoflight
   ymin = FIX(Light.pos.Y / Map.TileSize) - sizeoflight
   ymax = FIX(Light.pos.Y / Map.TileSize) + sizeoflight
   IF xmin < 0 THEN xmin = 0
   IF ymin < 0 THEN ymin = 0
   IF xmin > Map.MaxWidth THEN xmax = Map.MaxWidth
   IF ymax > Map.MaxWidth THEN ymax = Map.MaxHeight
   FOR x = xmin TO xmax
      FOR y = ymin TO ymax
         XV = (x * Map.TileSize) + MapTileSizeHalf
         YV = (y * Map.TileSize) + MapTileSizeHalf
         IF Light.LightType = 2 THEN
            dx = Light.pos.X - XV: dy = Light.pos.Y - YV
            Rotation = ATan2(dy, dx) ' Angle in radians
            Rotation = (Rotation * 180 / PI) + 90
            IF Rotation > 180 THEN Rotation = Rotation - 179.9
            IsFov = IsInFOV(Light.pos.rot, Rotation, Light.Fov) ' <> 0
         END IF
         dist = INT(Distance((x * Map.TileSize) + (Map.TileSizeHalf), (y * Map.TileSize) + (Map.TileSizeHalf), Light.pos.X, Light.pos.Y)) - (Light.strength + (INT(RND * 8) - 4))
         'IF dist > 255 THEN dist = 255
         newlight = (Light.strength - dist) + (IsFov * (Light.strength / 25))
         IF newlight > 255 THEN newlight = 255
         Isview = ShadowView(Light.pos.X - 7, Light.pos.Y, XV + 8, YV, Map.TileSizeHalf, 5, 30, 0, 0)
         IF Isview <> -1 THEN newlight = (newlight - (Isview * 2))
         IF Tile(x, y, 0).dlight < newlight THEN Tile(x, y, 0).dlight = newlight
         IF Tile(x, y, 0).dlight < 0 THEN Tile(x, y, 0).dlight = 0
         IF Tile(x, y, 0).dlight > 255 THEN Tile(x, y, 0).dlight = 255
      NEXT
   NEXT
   IF Tile(FIX(Light.pos.X / Map.TileSize), FIX(Light.pos.Y / Map.TileSize), 0).dlight < Light.strength THEN Tile(FIX(Light.pos.X / Map.TileSize), FIX(Light.pos.Y / Map.TileSize), 0).dlight = Light.strength
END SUB

SUB CalcLightingDyn (Light AS LightSource)
   sizeoflight = FIX(Light.strength / 25)
   IF sizeoflight > 10 THEN sizeoflight = 10
   xmin = FIX(Light.pos.X / Map.TileSize) - sizeoflight
   xmax = FIX(Light.pos.X / Map.TileSize) + sizeoflight
   ymin = FIX(Light.pos.Y / Map.TileSize) - sizeoflight
   ymax = FIX(Light.pos.Y / Map.TileSize) + sizeoflight
   IF xmin < 0 THEN xmin = 0
   IF ymin < 0 THEN ymin = 0
   IF xmin > Map.MaxWidth THEN xmax = Map.MaxWidth
   IF ymax > Map.MaxWidth THEN ymax = Map.MaxHeight
   DIM MapTileSizeHalf AS DOUBLE
   DIM XV AS DOUBLE
   DIM YV AS DOUBLE
   MapTileSizeHalf = Map.TileSize / 2
   FOR x = xmin TO xmax
      FOR y = ymin TO ymax
         XV = (x * Map.TileSize) + MapTileSizeHalf
         YV = (y * Map.TileSize) + MapTileSizeHalf

         IF Light.LightType = 2 THEN
            dx = Light.pos.X - XV: dy = Light.pos.Y - YV
            Rotation = ATan2(dy, dx) ' Angle in radians
            Rotation = (Rotation * 180 / PI) + 90
            IF Rotation > 180 THEN Rotation = Rotation - 179.9
            IsFov = IsInFOV(Light.pos.rot, Rotation, Light.Fov) ' <> 0
         END IF
         dist = INT(Distance((x * Map.TileSize) + (Map.TileSizeHalf), (y * Map.TileSize) + (Map.TileSizeHalf), Light.pos.X, Light.pos.Y)) - Light.strength

         newlight = (Light.strength - dist) + (IsFov * (Light.strength / 25))

         LightDiv = DDATarget(Light.pos.X, Light.pos.Y, XV, YV)
         IF LightDiv < 8 THEN
            newlight = newlight / LightDiv
            IF Tile(x, y, 0).dlight < newlight THEN Tile(x, y, 0).dlight = newlight
            IF Tile(x, y, 0).dlight < 0 THEN Tile(x, y, 0).dlight = 0
         END IF
      NEXT
   NEXT
   IF Tile(FIX(Light.pos.X / Map.TileSize), FIX(Light.pos.Y / Map.TileSize), 0).dlight < Light.strength THEN Tile(FIX(Light.pos.X / Map.TileSize), FIX(Light.pos.Y / Map.TileSize), 0).dlight = Light.strength
END SUB

SUB LogicLightingDyn (Light AS LightSource)
   'Light.strength2 = Light.strength
   'IF Light.duration < 5 AND Light.duration > 0 THEN Light.strength2 = Light.strength2 / (5 - Light.duration)
   IF Light.Duration > 0 THEN Light.Duration = Light.Duration - 1
   IF Light.Duration = 0 THEN Light.exist = 0: Light.strength = 0
   IF Light.EntID > 0 THEN CopyCoords Light.pos, Mobs(Light.EntID).pos
END SUB

SUB CreateDynamicLight (x AS DOUBLE, y AS DOUBLE, strength AS INTEGER, duration AS INTEGER, detail AS STRING, ltype AS _BYTE)
   FOR l = 1 TO DynamicLightMax
      IF DynamicLight(l).exist = 0 THEN EXIT FOR
      IF l = DynamicLightMax THEN EXIT SUB
   NEXT
   LastDynLight = LastDynLight + 1: IF LastDynLight = DynamicLightMax THEN LastDynLight = 0
   DynamicLight(l).pos.X = x
   DynamicLight(l).pos.Y = y
   DynamicLight(l).Detail = detail
   DynamicLight(l).strength = strength
   DynamicLight(l).LightType = ltype
   DynamicLight(l).Duration = duration
   DynamicLight(l).exist = -1
END SUB


FUNCTION LoadImage (autopath AS _BYTE, BPath AS STRING, Mode AS INTEGER)
   DIM Path AS STRING
   DIM Handle AS LONG
   IF autopath = 1 THEN
      Path = AssetPath + AssetPack + "/Textures/" + BPath
   ELSE
      Path = BPath
   END IF
   IF _FILEEXISTS(Path) THEN
      Handle = _LOADIMAGE(Path, Mode)
      LoadImage = Handle
      Echo ("INFO - F(LoadImage): Image '" + _TRIM$(STR$(Handle)) + "' loaded: " + BPath)
   ELSE
      LoadImage = MissingTexture
      Echo ("MERROR - F(LoadImage): Image not found! '" + Path + "'")
   END IF
END FUNCTION

FUNCTION SNDOPEN (autopath AS _BYTE, BPath AS STRING)

   DIM Path AS STRING
   IF autopath = 1 THEN
      Path = AssetPath + AssetPack + "/Sounds/" + BPath
   ELSE
      Path = BPath
   END IF
   SNDOPEN = MissingAudio
   IF _FILEEXISTS(Path) THEN
      SNDOPEN = _SNDOPEN(Path)
      Echo ("INFO - F(SNDOPEN): Sound loaded: " + Path)
   ELSE
      SNDOPEN = MissingAudio
      Echo ("MERROR - F(SNDOPEN): Sound not found!: " + Path)
   END IF
END FUNCTION

SUB LoadWeapons
   $IF DEBUGOUTPUT THEN
      Echo ("INFO - S(LoadWeapons): Start loading...")
   $END IF
   CLS
   LastWeaponID = 1
   OPEN (VantiroPath + "/Guns/active.gun") FOR INPUT AS #9
   LINE INPUT #9, trash$
   DO
      LINE INPUT #9, Gun$
      Echo ("INFO - S(LoadWeapons): Found: " + Gun$)
      IF _TRIM$(Gun$) <> "# End Of File." THEN
         LoadWeapon LastWeaponID, Gun$
         LastWeaponID = LastWeaponID + 1
      ELSE
         LastWeaponID = LastWeaponID - 1
         EXIT DO
      END IF
   LOOP
   CLOSE #9
   FOR i = 1 TO LastWeaponID
      Weapons(i).BulletSprite = LoadImage(0, (VantiroPath + "/Guns/Sprites/" + _TRIM$(Weapons(i).BulletSpritePath) + ".png"), 33)
      Weapons(i).GunSprite = LoadImage(0, (VantiroPath + "/Guns/Sprites/" + _TRIM$(Weapons(i).InternalName) + ".png"), 33)
      Weapons(i).AmmoSprite = LoadImage(0, (VantiroPath + "/Guns/Sprites/" + _TRIM$(Weapons(i).AmmoSpritePath) + ".png"), 33)
      IF INSTR(Weapons(i).SoundPath, "$Res$") THEN
         Weapons(i).SoundHandle = SNDOPEN(1, (RIGHT$(Weapons(i).SoundPath, LEN(Weapons(i).SoundPath) - 5)))
      ELSE
         Weapons(i).SoundHandle = SNDOPEN(0, Weapons(i).SoundPath)
      END IF
   NEXT
END SUB

SUB LoadWeapon (ID AS LONG, Gun AS STRING)
   CLS
   IF _FILEEXISTS(VantiroPath + "/Guns/" + _TRIM$(Gun) + ".gun") THEN
      Weapons(ID).Exists = -1
      OPEN (VantiroPath + "/Guns/" + _TRIM$(Gun) + ".gun") FOR INPUT AS #10
      Weapons(ID).InternalName = UCASE$(_TRIM$(Gun))
      DO
         LINE INPUT #10, Liner$
         IF _TRIM$(Liner$) = "# End Of File." THEN EXIT DO
         start = INSTR(0, Liner$, " =") + 3
         ends = INSTR(0, Liner$, " '")
         bytes = ABS(start - ends)
         Var$ = _TRIM$(LEFT$(Liner$, start - 3))
         SELECT CASE Var$
            CASE "Name"
               Weapons(ID).VisualName = _TRIM$(MID$(Liner$, start + 1, bytes - 2))
            CASE "ImageSize"
               Weapons(ID).ImageSize = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "HandsNeeded"
               Weapons(ID).HandsNeeded = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "UsesAmmo"
               Weapons(ID).UsesAmmo = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "ShotsPerFire"
               Weapons(ID).ShotsPerFire = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "Damage"
               Weapons(ID).Damage = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "MagSize"
               Weapons(ID).MagSize = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "MagLimit"
               Weapons(ID).MagLimit = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "BulletSprite"
               Weapons(ID).BulletSpritePath = _TRIM$(MID$(Liner$, start + 1, bytes - 2))
            CASE "AmmoSprite"
               Weapons(ID).AmmoSpritePath = _TRIM$(MID$(Liner$, start + 1, bytes - 2))
            CASE "SoundPath"
               Weapons(ID).SoundPath = _TRIM$(MID$(Liner$, start + 1, bytes - 2))
            CASE "ReloadTime"
               Weapons(ID).ReloadTime = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "TimeBetweenShots"
               Weapons(ID).TimeBetweenShots = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "Spray"
               Weapons(ID).Spray = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "Recoil"
               Weapons(ID).Recoil = VAL(_TRIM$(MID$(Liner$, start, bytes)))
            CASE "JammingChance"
               Weapons(ID).JammingChance = VAL(_TRIM$(MID$(Liner$, start, bytes)))
         END SELECT
      LOOP
      CLOSE #10
      Echo ("INFO - S(LoadWeapon): Following stats:")
      Echo ("{")
      Echo ("    VisualName: " + Weapons(ID).VisualName)
      Echo ("    ImageSize: " + STR$(Weapons(ID).ImageSize))
      Echo ("    HandsNeeded: " + STR$(Weapons(ID).HandsNeeded))
      Echo ("    UsesAmmo: " + STR$(Weapons(ID).UsesAmmo))
      Echo ("    ShotsPerFire: " + STR$(Weapons(ID).ShotsPerFire))
      Echo ("    Damage: " + STR$(Weapons(ID).Damage))
      Echo ("    MagSize: " + STR$(Weapons(ID).MagSize))
      Echo ("    MagLimit: " + STR$(Weapons(ID).MagLimit))
      Echo ("    BulletSpritePath: " + Weapons(ID).BulletSpritePath)
      Echo ("    AmmoSprite: " + Weapons(ID).AmmoSpritePath)
      Echo ("    SoundPath: " + (Weapons(ID).SoundPath))
      Echo ("    ReloadTime: " + STR$(Weapons(ID).ReloadTime))
      Echo ("    TimeBetweenShots: " + STR$(Weapons(ID).TimeBetweenShots))
      Echo ("    Spray: " + STR$(Weapons(ID).Spray))
      Echo ("    Raw Spray: " + _TRIM$(MID$(Liner$, start, bytes)))
      Echo ("    Recoil: " + STR$(Weapons(ID).Recoil))
      Echo ("    JammingChance: " + STR$(Weapons(ID).JammingChance))
      Echo ("}")
   ELSE
      Echo ("WARN - S(LoadWeapon): " + _TRIM$(Gun) + ".gun not found.")
   END IF
END SUB

SUB SpawnItem (X AS DOUBLE, Y AS DOUBLE, IType2 AS STRING, IName2 AS STRING)
   ValidType = 0
   DIM IType AS STRING
   DIM IName AS STRING
   IType = UCASE$(IType2)
   IName = UCASE$(IName2)
   SELECT CASE IType
      CASE "WEAPON"
         ValidType = 1
      CASE "USABLE"
         ValidType = 1
      CASE "GIB"
         ValidType = 1
   END SELECT
   IF ValidType = 1 THEN
      SELECT CASE IType
         CASE "WEAPON"
            FOR i = 0 TO LastWeaponID
               IF Weapons(i).Exists = -1 THEN
                  IF Weapons(i).InternalName = IName THEN
                     LastItemID = LastItemID + 1
                     Item(LastItemID).exist = -1
                     Item(LastItemID).canuse = -1
                     Item(LastItemID).Image = Weapons(i).GunSprite
                     Item(LastItemID).ItemName = IName
                     Item(LastItemID).ItemType = UCASE$(IType)
                     Item(LastItemID).pos.X = X
                     Item(LastItemID).Extra1 = 0
                     Item(LastItemID).Extra2 = 200
                     Item(LastItemID).InternalID = i
                     Item(LastItemID).pos.Y = Y
                     Item(LastItemID).ImageSize = Weapons(i).ImageSize
                     Item(LastItemID).HandsNeeded = Weapons(i).HandsNeeded
                  END IF
               END IF
            NEXT
         CASE "USABLE"
         CASE "GIB"
      END SELECT
   ELSE
      Echo ("WARN - S(SpawnItem): Type '" + (IType) + "' isn't a valid type.")
   END IF
END SUB


SUB ItemLogic
   FOR i = 1 TO 32
      IF Item(i).ItemType = "WEAPON" AND Item(i).Extra3 > 0 THEN Item(i).Extra3 = Item(i).Extra3 - 1
      GetBPos Item(i).pos
      Item(i).pos.X = Item(i).pos.X + Item(i).pos.XM / 4
      Item(i).pos.Y = Item(i).pos.Y + Item(i).pos.YM / 4
      Item(i).pos.Z = Item(i).pos.Z + Item(i).pos.ZM / 4
      IF Item(i).pos.Z < 0 THEN Item(i).pos.Z = 0: Item(i).pos.ZM = Item(i).pos.ZM * -.5: Item(i).pos.YM = Approach0(Item(i).pos.YM, 6): Item(i).pos.XM = Approach0(Item(i).pos.XM, 6)
      Item(i).pos.XM = Approach0(Item(i).pos.XM, 2)
      Item(i).pos.YM = Approach0(Item(i).pos.YM, 2)
      Item(i).pos.ZM = Item(i).pos.ZM - 8
   NEXT
END SUB

SUB RenderItems
   FOR i = 1 TO 32
      IF Item(i).exist = -1 THEN
         Interpolate Item(i).pos
         RotoZoomSized ETSX(Item(i).pos.Xv), ETSY(Item(i).pos.Yv), Item(i).Image, Item(i).ImageSize + (Item(i).pos.Zv / 2), Item(i).pos.rotv + 90
      END IF
   NEXT
END SUB

SUB PlayerLogic
   'Check for nearby Items
   LowestDist = 99999
   LowestID = 0
   FOR i = 0 TO 32
      IF Item(i).exist = -1 AND Item(i).held = 0 THEN
         Dist = DistanceLow(Item(i).pos.X, Item(i).pos.Y, Mobs(PlayerID).pos.X, Mobs(PlayerID).pos.Y)
         IF Dist < Mobs(PlayerID).pos.size * 7 THEN
            IF Joy.Interact2 = 1 THEN
               IF Dist < LowestDist THEN LowestDist = Dist: LowestID = i
            END IF
            Item(i).PickupV = CheckIfPlayerCanGrab(Item(i))
            IF Item(i).PickupV = -1 THEN _PUTIMAGE (ETSX(Item(i).pos.X) - 16, ETSY(Item(i).pos.Y) - 16)-(ETSX(Item(i).pos.X) + 16, ETSY(Item(i).pos.Y) + 16), PAR_Interact
         END IF
      END IF
   NEXT
   IF Joy.Interact2 = 1 THEN PlayerGrabItem Item(LowestID), LowestID
   'Drop Items
   IF Joy.DropItem = 1 THEN
      FOR o = 3 TO 1 STEP -1
         IF PlHands(o) <> 0 THEN
            PlayerDropItem o
            EXIT FOR
         END IF
      NEXT
   END IF
   'Hold Item
   FOR o = 1 TO 3
      IF PlHands(o) > 0 THEN
         PlayerHoldingItem Item(PlHands(o)), o
         IF Mouse.click = -1 THEN CheckUseItem o
      END IF
   NEXT
END SUB

SUB PlayerHoldingItem (It AS Item, hands AS _UNSIGNED _BYTE)
   DIM dx AS DOUBLE
   DIM dy AS DOUBLE
   It.pos.Z = Approach0(It.pos.Z, 2)
   IF hands < 3 THEN
      It.pos.X = PlayerMember(hands).pos.X: It.pos.Y = PlayerMember(hands).pos.Y
   ELSE
      It.pos.X = (PlayerMember(1).pos.X + PlayerMember(2).pos.X) / 2: It.pos.Y = (PlayerMember(1).pos.Y + PlayerMember(2).pos.Y) / 2
   END IF
   dx = Mobs(PlayerID).pos.X - It.pos.X: dy = Mobs(PlayerID).pos.Y - It.pos.Y
   It.pos.rot = ATan2(dy, dx) ' Angle in radians
   It.pos.rot = (It.pos.rot * 180 / PI) + 90
   IF It.pos.rot > 180 THEN It.pos.rot = It.pos.rot - 179.9
END SUB

FUNCTION CheckIfPlayerCanGrab (it AS Item)
   CheckIfPlayerCanGrab = 0
   IF it.HandsNeeded = 1 THEN
      FOR o = 1 TO 2
         IF PlHands(o) = 0 AND PlHands(3) = 0 THEN CheckIfPlayerCanGrab = -1
      NEXT
   END IF
   IF it.HandsNeeded = 2 THEN IF PlHands(1) = 0 AND PlHands(2) = 0 AND PlHands(3) = 0 THEN CheckIfPlayerCanGrab = -1
END FUNCTION

SUB PlayerGrabItem (It AS Item, id AS _UNSIGNED INTEGER)
   IF It.HandsNeeded = 1 THEN
      FOR o = 1 TO 2
         IF PlHands(o) = 0 AND PlHands(3) = 0 THEN
            PlayerMember(o).extra = id
            PlHands(o) = -1
            It.held = o
            PlayerMember(o).autoBE = 0
            PlayerMember(o).speedDiv = 2
            PlayerMember(o).xbe = It.pos.X: PlayerMember(o).ybe = It.pos.Y: PlayerMember(o).animation = "Grabbing"
            EXIT FOR
         END IF
      NEXT
   END IF
   IF It.HandsNeeded = 2 THEN
      IF PlHands(1) = 0 AND PlHands(2) = 0 AND PlHands(3) = 0 THEN
         FOR o = 1 TO 2
            PlayerMember(o).extra = id
            PlHands(3) = -1
            It.held = 3
            PlayerMember(o).autoBE = 0
            PlayerMember(o).speedDiv = 2
            PlayerMember(o).xbe = It.pos.X: PlayerMember(o).ybe = It.pos.Y: PlayerMember(o).animation = "Grabbing"
         NEXT
      END IF
   END IF
END SUB
FUNCTION Approach0 (Number AS DOUBLE, Amount AS _UNSIGNED INTEGER)
   IF ABS(Number) < Amount THEN
      Approach0 = 0
   ELSE: Approach0 = Number - (SGN(Number) * Amount)
   END IF
END FUNCTION


SUB ArmsAnims (Arm AS PlayerMembers, armid AS INTEGER)
   DIM DistPl AS _UNSIGNED LONG
   DIM Dist AS _UNSIGNED LONG
   SELECT CASE Arm.animation
      CASE "Grabbing"
         DistPl = Distance(Arm.pos.X, Arm.pos.Y, Mobs(PlayerID).pos.X, Mobs(PlayerID).pos.Y)
         Dist = Distance(Arm.pos.X, Arm.pos.Y, Arm.xbe, Arm.ybe)
         Arm.xbe = Item(Arm.extra).pos.X: Arm.ybe = Item(Arm.extra).pos.Y
         IF DistPl > Mobs(PlayerID).pos.size * 4.5 THEN
            Arm.speedDiv = Arm.speedDiv + 2
            IF Arm.speedDiv > 80 THEN
               Arm.animation = "Idle": Arm.autoBE = -1: Item(Arm.extra).held = 0: Arm.extra = 0: Arm.speedDiv = 2
               PlHands(armid) = 0
            ELSEIF DistPl > Mobs(PlayerID).pos.size * 8 THEN
               Arm.animation = "Idle": Arm.autoBE = -1: Item(Arm.extra).held = 0: Arm.extra = 0: Arm.speedDiv = 2
               PlHands(armid) = 0
            END IF
         ELSEIF Arm.speedDiv > 5 THEN Arm.speedDiv = Arm.speedDiv - 3
         END IF
         IF Dist < 16 THEN
            Arm.animation = "Idle"
            Arm.autoBE = -1
            IF Item(Arm.extra).HandsNeeded = 1 THEN PlHands(armid) = Arm.extra
            IF Item(Arm.extra).HandsNeeded = 2 THEN PlHands(3) = Arm.extra: PlHands(1) = 0: PlHands(2) = 0
            Arm.extra = 0
            Arm.speedDiv = 5
         END IF
   END SELECT
END SUB



FUNCTION CheckTileID (x AS DOUBLE, y AS DOUBLE, layer AS _UNSIGNED _BYTE)
   CheckTileID = 0
   tx = FIX((x) / Map.TileSize)
   ty = FIX((y) / Map.TileSize)
   CheckTileID = Tile(tx, ty, layer).ID
END FUNCTION


SUB CheckUseItem (Hand AS INTEGER)
   id = PlHands(Hand)
   IF Item(id).canuse = -1 THEN
      SELECT CASE Item(id).ItemType
         CASE "WEAPON"
            UseWeaponItem Item(id)
      END SELECT
   END IF
END SUB

SUB UseWeaponItem (It AS Item)
   ID = It.InternalID
   IF It.Extra3 > 0 THEN EXIT SUB
   It.pos.Z = (Weapons(ID).Damage + Weapons(ID).ShotsPerFire) * 3: IF It.pos.Z > 25 THEN It.pos.Z = 25
   IF Weapons(ID).Exists THEN
      IF It.held < 3 THEN
         PlayerMember(It.held).pos.X = PlayerMember(It.held).pos.X - ((SIN((It.pos.rot + RNDN(Weapons(ID).Spray * 2)) * PIDIV180)) * Weapons(ID).Recoil)
         PlayerMember(It.held).pos.Y = PlayerMember(It.held).pos.Y + ((COS((It.pos.rot + RNDN(Weapons(ID).Spray * 2)) * PIDIV180)) * Weapons(ID).Recoil)
      ELSE
         FOR y = 1 TO 2
            PlayerMember(y).pos.X = PlayerMember(y).pos.X - ((SIN((It.pos.rot + RNDN(Weapons(ID).Spray * 2)) * PIDIV180)) * Weapons(ID).Recoil)
            PlayerMember(y).pos.Y = PlayerMember(y).pos.Y + ((COS((It.pos.rot + RNDN(Weapons(ID).Spray * 2)) * PIDIV180)) * Weapons(ID).Recoil)
         NEXT
      END IF
      IF It.Extra1 >= Weapons(ID).ShotsPerFire THEN
         It.Extra1 = It.Extra1 - Weapons(ID).ShotsPerFire
         _SNDPLAYCOPY Weapons(ID).SoundHandle, 0.4
         FOR b = 1 TO Weapons(ID).ShotsPerFire
            spray = It.pos.rot + INT(RND * Weapons(ID).Spray) - (Weapons(ID).Spray / 2)
            BulletSpawn It.pos.X, It.pos.Y, spray, Weapons(ID).Damage
            It.Extra3 = Weapons(ID).TimeBetweenShots
         NEXT
         Px = It.pos.X + RNDN(5): Py = It.pos.Y + RNDN(5): Pz = 5
         Pxm = -SIN(RNDN(180) * PIDIV180) * RNDN(15)
         Pym = COS(RNDN(180) * PIDIV180) * RNDN(15)
         SpawnParticle Px, Py, Pz, Pxm, Pym, 3, 4, 128, INT(RND * 360) - 180, RNDN(15), "SMOKE"
      ELSE
         'reload proceedure
         IF It.Extra2 > 0 THEN
            It.Extra2 = It.Extra2 - 1
            It.Extra1 = Weapons(ID).MagSize
         ELSE
            'Fail Fire
         END IF
      END IF
   END IF
END SUB

SUB BulletSpawn (X AS DOUBLE, Y AS DOUBLE, rot AS DOUBLE, damage AS DOUBLE)
   DIM ID AS _UNSIGNED INTEGER
   FOR i = 0 TO BulletTracersMax
      IF BulletTrace(i).FrameLife = 0 THEN ID = i: EXIT FOR
   NEXT
   BulletRay X, Y, rot, damage
   BulletTrace(ID).pos.Xb = X
   BulletTrace(ID).pos.Yb = Y
   BulletTrace(ID).pos.X = Ray.pos.X
   BulletTrace(ID).pos.Y = Ray.pos.Y
   BulletTrace(ID).pos.rot = rot
   BulletTrace(ID).FrameLife = 1
   CreateDynamicLight X, Y, 200, 2, "Low", 1
   '(x AS DOUBLE, y AS DOUBLE, angle AS DOUBLE, damage AS DOUBLE, distallow AS LONG)
   '  LINE (ETSX(X), ETSY(Y))-(ETSX(Ray.pos.x), ETSY(Ray.pos.y)), _RGB32(255, 0, 0)
END SUB

SUB PlayerDropItem (Hand AS _UNSIGNED _BYTE)
   DIM ID AS LONG
   ID = -1
   IF PlHands(Hand) > 0 THEN
      ID = PlHands(Hand)
      Item(PlHands(Hand)).held = 0
      PlHands(Hand) = 0
   END IF
   IF ID <> -1 THEN ThrowItem Item(ID), Mobs(PlayerID).pos.X, Mobs(PlayerID).pos.Y, -Mobs(PlayerID).pos.XM, -Mobs(PlayerID).pos.YM, Mobs(PlayerID).pos.rot + (INT(RND * 40) - 20), 10
END SUB

SUB ThrowItem (It AS Item, x AS _UNSIGNED LONG, y AS _UNSIGNED LONG, xm AS DOUBLE, ym AS DOUBLE, rot AS DOUBLE, force AS DOUBLE)
   It.pos.X = x
   It.pos.Y = y
   It.pos.Z = 3
   It.pos.XM = (SIN(rot * PIDIV180) * force) * (6 + ABS(xm / 20))
   It.pos.YM = (-COS(rot * PIDIV180) * force) * (6 + ABS(ym / 20))
   It.pos.ZM = 20 + INT(RND * 40)
   It.pos.rot = It.pos.rot + (INT(RND * 360) - 180) 'rot + INT(RND * 180)
   IF It.pos.rot > 180 THEN It.pos.rot = It.pos.rot - 179.9
   IF It.pos.rot < -180 THEN It.pos.rot = It.pos.rot + 179.9
END SUB

SUB FillJoy
   IF InputDevicesNum = 3 THEN ControllerFillJoy
   Joy.YMove = 0
   Joy.XMove = 0
   Inte = 0
   Inte2 = 0
   IF ControllerInput = 0 THEN
      Joy.YMove = _KEYDOWN(119) + ABS(_KEYDOWN(115))
      Joy.XMove = _KEYDOWN(97) + ABS(_KEYDOWN(100))
      IF Joy.Interact1 = 0 THEN Joy.Interact1 = Joy.Interact1 + ABS(_KEYDOWN(101))
      IF Joy.Interact2 = 0 THEN Joy.Interact2 = Joy.Interact2 + ABS(_KEYDOWN(102))
      IF Joy.DropItem = 0 THEN Joy.DropItem = Joy.DropItem + ABS(_KEYDOWN(113))
   ELSE
      IF ABS(Joypad.VERTICAL) > JoyDeadzone THEN Joy.YMove = Joypad.VERTICAL
      IF ABS(Joypad.HORIZONTAL) > JoyDeadzone THEN Joy.XMove = Joypad.HORIZONTAL
      IF ABS(Joypad.VERTICAL2) > JoyDeadzone THEN Joy.YVec = Joypad.VERTICAL2
      IF ABS(Joypad.HORIZONTAL2) > JoyDeadzone THEN Joy.XVec = Joypad.HORIZONTAL2
   END IF

END SUB
SUB ControllerFillJoy
   DIM JoyDeadzone AS DOUBLE
   JoyDeadzone = 0.05
   DO WHILE _DEVICEINPUT(3)
      ControllerInput = -1
   LOOP
   Joypad.A = _BUTTON(1)
   Joypad.B = _BUTTON(2)
   Joypad.X = _BUTTON(3)
   Joypad.Y = _BUTTON(4)
   Joypad.L = _BUTTON(5)
   Joypad.R = _BUTTON(6)
   Joypad.BT = _AXIS(3)
   Joypad.SELECTJOY = _BUTTON(7)
   Joypad.START = _BUTTON(8)
   Joypad.HORIZONTAL = _AXIS(1)
   Joypad.VERTICAL = _AXIS(2)
   Joypad.HORIZONTAL2 = _AXIS(3)
   Joypad.VERTICAL2 = _AXIS(4)
   Joypad.HORIZONTAL3 = _AXIS(6)
   Joypad.VERTICAL3 = _AXIS(7)
END SUB
SUB ZRender_PlayerHand
   FOR i = 1 TO 2
      _PUTIMAGE (ETSX(PlayerMember(i).pos.Xv) - 8, ETSY(PlayerMember(i).pos.Yv) - 8)-(ETSX(PlayerMember(i).pos.Xv) + 8, ETSY(PlayerMember(i).pos.Yv) + 8), PlayerHand(PlayerSkin2)
      Interpolate PlayerMember(i).pos
   NEXT
END SUB

SUB ParticleLogic (Part AS Particle)
   Part.DistPlayer = DistanceLow(Mobs(PlayerID).pos.X, Mobs(PlayerID).pos.Y, Part.pos.X, Part.pos.Y)
   Part.Exist = Part.Exist - 1: IF Part.Exist = 0 THEN KillParticle Part: EXIT SUB
   DIM DistXGrab AS _UNSIGNED LONG
   DIM DistYGrab AS _UNSIGNED LONG
   ' -=-  Particle Physics  -=-
   IF FIX(Part.pos.Z) <= 0 THEN Part(i).pos.Z = 0
   GetBPos Part.pos
   Part.pos.X = Part.pos.X + (Part.pos.XM / 5)
   Part.pos.Y = Part.pos.Y + (Part.pos.YM / 5)
   Part.pos.Z = Part.pos.Z + (Part.pos.ZM / 3)
   Part.pos.rot = Part.pos.rot + Part.RotationSpeed
   Part.RotationSpeed = Part.RotationSpeed / 1.02
   IF Part.pos.Z >= .8 THEN Part.pos.ZM = Part.pos.ZM - Part.Gravity * 2
   IF Part.DoPhysics = 1 THEN
      IF ABS(Part.pos.XM) < 3 THEN
         Part.pos.XM = Part.pos.XM / 1.05
      ELSE: Part.pos.XM = Part.pos.XM - SGN(Part.pos.XM)
      END IF
      IF ABS(Part.pos.YM) < 3 THEN
         Part.pos.YM = Part.pos.YM / 1.05
      ELSE: Part.pos.YM = Part.pos.YM - SGN(Part.pos.YM)
      END IF
      IF Part.pos.Z <= 0 THEN Part.pos.ZM = Part.pos.ZM * -.4: Part.pos.Z = 0: Part.pos.XM = (Part.pos.XM / 1.7): Part.pos.YM = (Part.pos.YM / 1.5): Part.RotationSpeed = Part.RotationSpeed / 1.5
      IF FIX(Part.pos.Z) = 0 THEN Part.pos.XM = (Part.pos.XM / 2): Part.pos.YM = (Part.pos.YM / 2)
   END IF

   '  -=-  PlayerCanGrab  -=-
   IF Part.CanGrab AND Part.DistPlayer < BloodPickUpRadius AND Part.pos.Z < 1 THEN
      Part.DoPhysics = 0
      dx = Mobs(PlayerID).pos.X - Part.pos.X: dy = Mobs(PlayerID).pos.Y - Part.pos.Y
      Part.pos.rot = ATan2(dy, dx) ' Angle in radians
      Part.pos.rot = (Part.pos.rot * 180 / PI) + 90 + (INT(RND * 20) - 10)
      IF Part.pos.rot > 180 THEN Part.pos.rot = Part.pos.rot - 179.9
      Part.pos.XM = Part.pos.XM / 1.02
      Part.pos.YM = Part.pos.YM / 1.02
      Part.pos.XM = Part.pos.XM + -SIN(Part.pos.rot * PIDIV180) * 9 / (Part.DistPlayer / 150)
      Part.pos.YM = Part.pos.YM + COS(Part.pos.rot * PIDIV180) * 9 / (Part.DistPlayer / 150)
      Part.pos.Z = 3 / (Part.DistPlayer / 50)
      IF Part.pos.Z > 30 THEN Part.pos.Z = 30
      IF Part.DistPlayer < (Mobs(PlayerID).pos.size * 1.5) THEN PlayerPickUpParticle Part: KillParticle Part
   ELSEIF Part.CanGrab = 1 THEN
      Part.DoPhysics = 1
   END IF

END SUB
SUB PlayerPickUpParticle (Part AS Particle)
   IF Part.WhenCollect = "" THEN EXIT SUB
   DIM CommandsDone AS _BYTE
   DIM s_start AS _UNSIGNED INTEGER
   DIM s_end AS _UNSIGNED INTEGER
   DIM Commands AS STRING
   DIM Value AS STRING
   DO
      s_start = INSTR(s_end, Part.WhenCollect, "{") + 1
      s_end = INSTR(s_start, Part.WhenCollect, "}")
      s_com = INSTR(s_start, Part.WhenCollect, ":")
      CommandsDone = 0
      '{SetHealth:20},{AddHealth:40}
      Commands = MID$(Part.WhenCollect, s_start, s_com - s_start)
      Value = MID$(Part.WhenCollect, s_com + 1, s_end - (s_com - 1))
      SELECT CASE Commands
         CASE "AddHealth"
            Mobs(PlayerID).Health = Mobs(PlayerID).Health + VAL(Value)
            CommandsDone = 1
         CASE "SetHealth"
            Mobs(PlayerID).Health = VAL(Value)
            CommandsDone = 1
         CASE "AmmoType"
            DIM AmmoType AS STRING
            AmmoType = Value
            CommandsDone = 1
         CASE "AddAmmo"
            CommandsDone = 1

      END SELECT
      $IF DEBUGOUTPUT THEN
         IF CommandsDone = 0 THEN Echo ("WARN - S(PlayerPickUpParticle): Unknown command: '" + Commands + "'")
      $END IF
   LOOP WHILE s_start <> 1

END SUB

SUB SpawnParticleSimple (X AS DOUBLE, Y AS DOUBLE, PType AS STRING, Bounce AS DOUBLE, ZM AS DOUBLE)
   DIM XM AS DOUBLE
   DIM YM AS DOUBLE

   XM = RNDN(Bounce)
   YM = RNDN(Bounce)
   SpawnParticle X, Y, 0, XM, YM, ZM, 0, 0, 0, 0, PType
END SUB

SUB SpawnParticle (X AS DOUBLE, Y AS DOUBLE, Z AS DOUBLE, XM AS DOUBLE, YM AS DOUBLE, ZM AS DOUBLE, Size AS DOUBLE, Time AS _UNSIGNED INTEGER, Rotation AS DOUBLE, RotationSpeed AS DOUBLE, PType AS STRING)

   LastPart = LastPart + 1
   IF LastPart > Config.ParticlesMax THEN LastPart = 0
   Part(LastPart).DoLogic = 0
   Part(LastPart).Exist = 0
   Part(LastPart).CanGrab = 0
   Part(LastPart).SpriteHandle = 0
   Part(LastPart).DoPhysics = 1

   Part(LastPart).pos.X = X
   Part(LastPart).pos.Y = Y
   Part(LastPart).pos.Z = Z
   Part(LastPart).pos.XM = XM
   Part(LastPart).pos.YM = YM
   Part(LastPart).pos.ZM = ZM
   Part(LastPart).pos.rot = Rotation
   Part(LastPart).RotationSpeed = RotationSpeed
   Part(LastPart).PartID = PType
   Part(LastPart).Gravity = 3.5
   SELECT CASE UCASE$(PType)
      CASE "RED_BLOOD"
         Part(LastPart).CanGrab = -1
         Part(LastPart).DoLogic = 35
         Part(LastPart).Exist = 1400
         Part(LastPart).SpriteHandle = PAR_BloodRed
         Part(LastPart).pos.size = 24
         Part(LastPart).WhenCollect = "{AddHealth:1}"
      CASE "GREEN_BLOOD"
         Part(LastPart).CanGrab = -1
         Part(LastPart).DoLogic = 35
         Part(LastPart).Exist = 1000
         Part(LastPart).SpriteHandle = PAR_BloodGreen
         Part(LastPart).pos.size = 24
         Part(LastPart).WhenCollect = "{AddHealth:0.5}"

      CASE "FIRE"
         Part(LastPart).Gravity = 0.2
      CASE "GLASSSHARD"
         Part(LastPart).Exist = 1100
         Part(LastPart).pos.size = 30 + RNDN(10)
         Part(LastPart).SpriteHandle = PAR_GlassShard

      CASE "BULLETHOLE"
         Part(LastPart).Exist = 2000
         Part(LastPart).pos.size = 18
         Part(LastPart).SpriteHandle = PAR_BulletHole

      CASE "BIO_SPIT"
         Part(LastPart).FixToTile = 1

      CASE "SMOKE"
         Part(LastPart).Exist = 800
         Part(LastPart).DoLogic = 810
         Part(LastPart).SpriteHandle = PAR_Smoke
         Part(LastPart).pos.size = 20
         Part(LastPart).Gravity = 0.05
      CASE "EXPLOSION"
         Part(LastPart).Exist = 320
         Part(LastPart).DoLogic = 15
         Part(LastPart).SpriteHandle = PAR_Explosion
         Part(LastPart).pos.size = 128
      CASE "BLOCKBREAK"
         Part(LastPart).Exist = 250
         Part(LastPart).DoLogic = 10
         Part(LastPart).SpriteHandle = Textures(Tile(FIX(X / Map.TileSize), FIX(Y / Map.TileSize), 2).ID)
         Part(LastPart).pos.size = 4
         Part(LastPart).pos.rot = RNDN(180)
         Part(LastPart).RotationSpeed = RNDND(25)

   END SELECT
   IF Size <> 0 THEN Part(LastPart).pos.size = Size
   IF Time <> 0 THEN Part(LastPart).Exist = Time
   $IF DEBUGOUTPUT THEN
      IF Part(LastPart).Exist = 0 THEN Echo ("WARN - S(SpawnParticle): Unknown particle: '" + UCASE$(PType) + "'")
   $END IF



END SUB

SUB KillParticle (Part AS Particle)
   Part.DoLogic = 0
   Part.Exist = 0
   Part.CanGrab = 0
   Part.pos.size = 16
   Part.pos.X = 0
   Part.pos.Y = 0
   Part.pos.Z = 0
   Part.pos.XM = 0
   Part.pos.YM = 0
   Part.FixToTile = 0
   Part.pos.ZM = 0
   Part.PartID = ""
   Part.SpriteHandle = MissingTexture
END SUB

SUB ParticleLogicHandler
   FOR i = 1 TO Config.ParticlesMax
      IF Part(i).Exist > 0 THEN
         ParticleLogic Part(i)
      END IF
   NEXT
END SUB

SUB RenderGame
   RenderBottomLayer
   FOR i = 1 TO Config.ParticlesMax: IF Part(i).Exist > 0 AND Part(i).pos.Z < 5 THEN RenderParticles Part(i)
   NEXT
   FOR i = 0 TO BulletTracersMax
      Interpolate BulletTrace(i).pos
      IF BulletTrace(i).FrameLife > 0 THEN RotoZoomSized ETSX(BulletTrace(i).pos.Xv), ETSY(BulletTrace(i).pos.Yv), PAR_BulletTracer, 4, BulletTrace(i).pos.rot
   NEXT
   RenderSecondLayer
   ' ZRender_Player
   ZRender_PlayerHand
   RenderItems
   RenderMobs
   'Particles
   FOR i = 1 TO Config.ParticlesMax: IF Part(i).Exist > 0 AND Part(i).pos.Z >= 5 THEN RenderParticles Part(i)
   NEXT
   RenderTopLayer
   IF Config.Game_Lighting THEN RenderLighting
   DDA Mobs(PlayerID).pos.X, Mobs(PlayerID).pos.Y, Mobs(PlayerID).pos.rot
   LINE (ETSX(Mobs(PlayerID).pos.X), ETSY(Mobs(PlayerID).pos.Y))-(ETSX(Ray.pos.X), ETSY(Ray.pos.Y)), _RGB32(255, 64, 255)

   ' NewHudRenderer
   PRINT Joy.XMove
   PRINT Joy.YMove

END SUB

SUB RenderParticles (Part AS Particle)
   FadeOut = 1
   IF Part.Exist <= 30 THEN FadeOut = Part.Exist / 30
   Interpolate Part.pos
   RotoZoomSized ETSX(Part.pos.Xv), ETSY(Part.pos.Yv), Part.SpriteHandle, (Part.pos.size + (Part.pos.Zv / 2)) * FadeOut, Part.pos.rotv
END SUB
SUB CloseSND (Handle AS _UNSIGNED LONG)
   IF Handle <> 0 THEN _SNDCLOSE Handle
END SUB

SUB CloseIMG (Handle AS _UNSIGNED LONG)
   IF Handle = MissingTexture THEN EXIT SUB
   IF Handle <> 0 THEN _FREEIMAGE Handle
END SUB

SUB LoadDifferentTxtPack (Pack AS STRING)
   IF _FILEEXISTS((AssetPath + Pack) + "/about.txt") THEN
      AssetPack = Pack
      Echo ("INFO - S(LoadDifferentTxtPack): Now loading '" + Pack + "'")
      LoadAssets
   ELSE
      Echo ("WARN - S(LoadDifferentTxtPack): Did not find '" + Pack + "'")
   END IF
END SUB

SUB LoadAssets
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
   FOR i = 1 TO 4: CloseSND SND_ZombieWalk(i): SND_ZombieWalk(i) = SNDOPEN(1, ("Entities/Zombies/Ambient" + _TRIM$(STR$(i)) + ".wav")): NEXT
   FOR i = 1 TO 16: CloseSND SND_ZombieShot(i): SND_ZombieShot(i) = SNDOPEN(1, ("Entities/Zombies/Shot/Shot" + _TRIM$(STR$(i)) + ".wav")): NEXT
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
   CloseIMG PAR_BulletTracer: PAR_BulletTracer = LoadImage(1, "Particles/BulletTracer.png", 33)
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
   FOR i = 1 TO 512
      IF FontSized(i) <> 0 THEN _FREEFONT FontSized(i)
      FontSized(i) = _LOADFONT((AssetPath + AssetPack + "/Font.ttf"), i, "MONOSPACE")
   NEXT

   FOR i = 0 TO 100
      From0To101Images(i) = CreateImageText(From0To101Images(i), _TRIM$(STR$(i)), 60)
   NEXT
   From0To101Images(101) = CreateImageText(From0To101Images(101), "100+", 60)
END SUB

SUB LoadDefaultConfigs
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
   Config.Game_Lighting = 1 ' (Def: 1)
   Config.Game_Interpolation = 1 ' (Def: 1)
   Config.Game_Cheats = 1 ' (Def: 1)
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

   Config.Hud_SelRed = _RED32(Config.Hud_SelectedColor)
   Config.Hud_SelGreen = _GREEN32(Config.Hud_SelectedColor)
   Config.Hud_SelBlue = _BLUE32(Config.Hud_SelectedColor)
   Config.Hud_UnSelRed = _RED32(Config.Hud_UnSelectedColor)
   Config.Hud_UnSelGreen = _GREEN32(Config.Hud_UnSelectedColor)
   Config.Hud_UnSelBlue = _BLUE32(Config.Hud_UnSelectedColor)
   $IF DEBUGOUTPUT THEN
      Echo ("INFO - S(LoadDefaultConfigs): Loaded internal configs.")
   $END IF

END SUB

SUB LoadConfig.INI
   IF _FILEEXISTS(VantiroPath + "/config.ini") THEN
      LoadConfigs
      Echo ("INFO - S(LoadConfig.INI): Loaded succesfully. ")
   ELSE
      Echo ("WARN - S(LoadConfig.INI): {" + VantiroPath + "/config.ini} not found, generating file based off internal configs.")
      SaveConfig
   END IF
END SUB

SUB Mob_EntityHandler
   FOR z = 0 TO Config.EnemiesMax
      IF Mobs(z).Exist = 1 AND Mobs(z).DoAI = 1 THEN
         GetBPos Mobs(z).pos
         Mobs(z).pos.x1 = Mobs(z).pos.X - Mobs(z).pos.size: Mobs(z).pos.x2 = Mobs(z).pos.X + Mobs(z).pos.size: Mobs(z).pos.y1 = Mobs(z).pos.Y - Mobs(z).pos.size: Mobs(z).pos.y2 = Mobs(z).pos.Y + Mobs(z).pos.size
         SELECT CASE Mobs(z).Class
            CASE "ZOMBIE": AI_Zombie Mobs(z)
         END SELECT
      END IF
   NEXT
END SUB

SUB LoadHateType
   IF _FILEEXISTS(VantiroPath + "/Behaviors/EnemyTypeHate.txt") THEN
      DIM Number AS _UNSIGNED INTEGER
      OPEN (VantiroPath + "/Behaviors/EnemyTypeHate.txt") FOR INPUT AS #6
      Y = 1:
      DO
         INPUT #6, Number
         IF Number = 0 THEN AIGroupHate(Y, 0) = X: Y = Y + 1: X = 0
         IF Number = 404 THEN EXIT DO
         X = X + 1
         AIGroupHate(Y, X) = Number
      LOOP WHILE NOT EOF(6)
      CLOSE #6
   ELSE
      _MESSAGEBOX "Missing file.", "Missing 'Behaviours/EnemyTypeHate.txt', AI will not work.", "error"
      Debug_DoAI = 0
   END IF
   AIGroupHate(1, 1) = 0
END SUB

'AIPath(512, 256) AS _UNSIGNED INTEGER
SUB AI_Zombie (Zombie AS Entity)
   DIM ZombieSin AS DOUBLE
   DIM ZombieCos AS DOUBLE
   DIM DistTarget AS DOUBLE
   Zombie.Tick = Zombie.Tick - 1
   CollisionWithWallsEntity Zombie.pos
   Zombie.pos.X = Zombie.pos.X + (Zombie.pos.XM / 4)
   Zombie.pos.Y = Zombie.pos.Y + (Zombie.pos.YM / 4)
   ZombieSin = SIN(Zombie.pos.rot * PIDIV180)
   ZombieCos = -COS(Zombie.pos.rot * PIDIV180)
   IF Zombie.Tick > 0 THEN EXIT SUB
   Zombie.Tick = 3 + INT(RND * 3)
   Zombie.Health = Zombie.Health - Zombie.DamageTaken
   IF Zombie.Health < 0 THEN ZombieDeath Zombie: EXIT SUB
   DistTarget = DistanceLow(Zombie.pos.X, Zombie.pos.Y, Zombie.TargetX, Zombie.TargetY)
   SELECT CASE Zombie.AIstate
      CASE "Run2Mob2Attack" ' Go towards a mob
         Zombie.TargetX = Mobs(Zombie.TargetID).pos.X
         Zombie.TargetY = Mobs(Zombie.TargetID).pos.Y
         IF DistTarget < Zombie.pos.size * 2 THEN Zombie.AIstate = "AttackMob"
         IF DistTarget > Zombie.pos.size * 64 THEN Zombie.AIstate = "IdleTillSight": Echo "ZOMBIE NOT IN SIGHT."
         IF DDATarget(Zombie.pos.X, Zombie.pos.Y, Mobs(Zombie.TargetID).pos.X, Mobs(Zombie.TargetID).pos.Y) > 1 THEN
            AI_Generic_FindPoints Zombie
            Zombie.TargetID = AIPath(Zombie.PathID, 1)
            Zombie.PointFollow = 0
         END IF
      CASE "AttackMob"
         Zombie.AIstate = "Run2Mob2Attack"
         EntityTakeDamage Mobs(Zombie.TargetID), Zombie.pos.X, Zombie.pos.Y, Zombie.Damage
      CASE "Run2PointsAttack" ' Follow Points and attack
         Zombie.TargetX = Waypoint(Zombie.PointFollow).pos.X
         Zombie.TargetY = Waypoint(Zombie.PointFollow).pos.Y
         IF DistanceLow(Zombie.pos.X, Zombie.pos.Y, Zombie.TargetX, Zombie.TargetY) < Zombie.pos.size THEN
            Zombie.PointFollow = Zombie.PointFollow + 1
            IF Zombie.PointFollow = AIPath(Zombie.PathID, 0) THEN Zombie.AIstate = "IdleTillSight"
            Zombie.TargetX = Waypoint(Zombie.PointFollow).pos.X
            Zombie.TargetY = Waypoint(Zombie.PointFollow).pos.Y
         END IF
      CASE "IdleTillSight" ' Stop moving until seen
         Zombie.TargetID = -1
         HatedGroupNearby Zombie
         IF Zombie.TargetID <> -1 THEN IF DDATarget(Zombie.pos.X, Zombie.pos.Y, Mobs(Zombie.TargetID).pos.X, Mobs(Zombie.TargetID).pos.Y) > 1 THEN Zombie.TargetID = -1: Echo ("INFO - S(AI_Zombie): Found entity not in sight."): Zombie.Tick = 20
         IF Zombie.TargetID >= 0 THEN Zombie.AIstate = "Run2Mob2Attack"
      CASE "": Zombie.AIstate = "IdleTillSight"
   END SELECT

   IF DistTarget < (Zombie.pos.size * 2) * Zombie.Speed THEN
      IF SGN(Zombie.pos.XM) <> SGN(ZombieSin) THEN Zombie.pos.XM = Zombie.pos.XM + -(Zombie.pos.XM * 0.25)
      IF SGN(Zombie.pos.YM) <> SGN(ZombieCos) THEN Zombie.pos.YM = Zombie.pos.YM + -(Zombie.pos.YM * 0.25)
   END IF
   Zombie.pos.XM = Zombie.pos.XM + (ZombieSin * Zombie.Speed)
   Zombie.pos.YM = Zombie.pos.YM + (ZombieCos * Zombie.Speed)
   IF ABS(Zombie.pos.XM) > Zombie.MaxSpeed THEN Zombie.pos.XM = Zombie.MaxSpeed * (SGN(Zombie.pos.XM))
   IF ABS(Zombie.pos.YM) > Zombie.MaxSpeed THEN Zombie.pos.YM = Zombie.MaxSpeed * (SGN(Zombie.pos.YM))
   dx = Zombie.pos.X + 1 - Zombie.TargetX - 1: dy = Zombie.pos.Y + 1 - Zombie.TargetY - 1
   Zombie.pos.rot = ATan2(dy, dx)
   Zombie.pos.rot = (Zombie.pos.rot * 180 / PI) + 90 + RNDND(8)
   IF Zombie.pos.rot > 180 THEN Zombie.pos.rot = Zombie.pos.rot - 179.99
END SUB

SUB ZombieDeath (ent AS Entity)
   DIM Rand AS _UNSIGNED INTEGER
   Rand = INT(RND * 8) + 2
   FOR i = 1 TO Rand
      SpawnParticleSimple ent.pos.X, ent.pos.Y, "GREEN_BLOOD", 40 + INT(RND * 20), INT(RND * 20) + 5
   NEXT
   KillEntity ent
END SUB


SUB HatedGroupNearby (Ent AS Entity)
   FOR i = 0 TO Config.EnemiesMax
      IF Mobs(i).Exist THEN
         Dist = DistanceLow(Ent.pos.X, Ent.pos.Y, Mobs(i).pos.X, Mobs(i).pos.Y)
         Echo ("INFO - S(HatedGroupNearby): Found existing at distance: " + STR$(Dist) + ", ID is: " + STR$(i))
         IF Dist < 812 AND Dist > 5 THEN
            FOR o = 1 TO AIGroupHate(Ent.Group, 0)
               IF Mobs(i).Group = AIGroupHate(Ent.Group, o) THEN
                  Echo ("INFO - S(HatedGroupNearby): Found entity IS on target list.")
                  Ent.TargetID = i: EXIT SUB
               END IF
            NEXT
         END IF
      END IF
   NEXT
END SUB

SUB AI_Generic_FindPoints (Ent AS Entity)
   'Clear PathID
   AI_Generic_DeletePoints Ent
   'Find new PathID
   DIM FoundID AS _UNSIGNED INTEGER
   FOR i = 1 TO 512
      IF AIPath(i, 0) = 0 THEN FoundID = i
   NEXT
   AI_Generic_FillPoints Ent, Ent.TargetX, Ent.TargetY, FoundID
END SUB
'/Spawn Enemy = = Zombie_Fast {XM:[1],YM:[1],Size:[16],Name:["Dirt"]}
'= is gonna be player/trigger coordinate.

SUB SpawnEntity (EntType AS STRING, X AS DOUBLE, Y AS DOUBLE, EntName AS STRING, Text AS STRING)
   DIM Namer AS STRING
   DIM Size AS DOUBLE
   XM = VAL(GetBit$(Text, "XM:", "]"))
   YM = VAL(GetBit$(Text, "YM:", "]"))
   Namer = GetBit$(Text, "Name:", "]")
   Size = VAL(GetBit$(Text, "Size:", "]"))
   SELECT CASE UCASE$(EntType)
      CASE "ITEM"

      CASE "ENEMY"

      CASE "FRIEND"

   END SELECT
END SUB

SUB SpawnMob (X AS DOUBLE, Y AS DOUBLE, XM AS DOUBLE, YM AS DOUBLE, Size AS DOUBLE, Class AS STRING, ClassType AS STRING, EntName AS STRING)
   DIM ID AS LONG
   ID = -1
   FOR i = 4 TO Config.EnemiesMax
      IF Mobs(i).Exist = 0 THEN ID = i: EXIT FOR
   NEXT
   IF ID = -1 THEN
      Echo ("WARN - S(SpawnMob): Couldn't spawn entity, limit reached!")
      EXIT SUB
   END IF
   Mobs(ID).pos.X = X
   Mobs(ID).pos.Y = Y
   Mobs(ID).pos.XM = XM
   Mobs(ID).pos.YM = YM
   Mobs(ID).pos.size = Size
   Mobs(ID).Class = UCASE$(Class)
   Mobs(ID).ClassType = UCASE$(ClassType)
   Mobs(ID).EntName = EntName
   Mobs(ID).Exist = 1
   SUBOutUINT = ID
   DIM Separator AS _UNSIGNED INTEGER
   Echo ("INFO - S(SpawnMob): Class: " + Class + " | ClassType: " + ClassType + " X: " + STR$(X) + " Y: " + STR$(Y))
   SELECT CASE UCASE$(Class)
      CASE "ZOMBIE"
         SpawnZombieClass Mobs(ID)
      CASE "VAMPIRE"
         SpawnVampireClass Mobs(ID)
   END SELECT
END SUB

SUB KillEntity (Ent AS Entity)
   AI_Generic_DeletePoints Ent
   Ent.Exist = 0
   Ent.Class = ""
   Ent.EntName = ""
   Ent.ClassType = ""
   Ent.pos.size = 0
   Ent.pos.X = 0
   Ent.DoAI = 0
   Ent.pos.Y = 0
   Ent.Weight = 0
   Ent.Speed = 0
   Ent.Health = 0
   Ent.Sprite = MissingTexture
END SUB

SUB SpawnVampireClass (Mob AS Entity)
   Mob.Group = 1
   SELECT CASE Mob.ClassType
      CASE "PLAYER"
         Mob.DoAI = 0
         Mob.Weight = 1
         Mob.Speed = Config.Player_Accel
         Mob.Health = 105
         Mob.Sprite = PlayerSprite(1)
         Mob.DamageTaken = 0
   END SELECT
END SUB

SUB SpawnZombieClass (Mob AS Entity)
   Mob.DoAI = 1
   Mob.Group = 2
   IF Mob.pos.size <> 0 THEN Size = Mob.pos.size
   SELECT CASE Mob.ClassType
      CASE "NORMAL"
         Mob.pos.size = 65 + INT(RND * 10)
         Mob.Weight = 2 + (RND * 2)
         Mob.Health = 50 + RNDN(20)
         Mob.DoKnockback = INT(RND * 4) + 5
         Mob.Speed = 4.2 + (RND * 2)
         Mob.MaxSpeed = 38 + INT(RND * 10)
         Mob.Damage = 3.6 + RNDN(3)
         Mob.BreakBlocks = 0
         Mob.Smart = 1
         Mob.Sprite = SPR_Zombie
      CASE "SLOW"
         Mob.pos.size = 65 + FIX(RND * 16)
         Mob.Weight = 4
         Mob.Health = 60 + RNDND(10)
         Mob.DoKnockback = INT(RND * 6) + 5
         Mob.Speed = 2.4 + (RND * 1)
         Mob.MaxSpeed = 29
         Mob.Damage = 1.8 + (FIX(RND * 50) / 10)
         Mob.BreakBlocks = 0
         Mob.Smart = 1
         Mob.Sprite = SPR_ZombieSlow
      CASE "BRUTE"
         Mob.pos.size = 180 + (RND * 16)
         Mob.Weight = 7
         Mob.Health = 90 + (RND * 30)
         Mob.DoKnockback = INT(RND * 21) + 30
         Mob.Speed = 2.8 + (RND * 1)
         Mob.MaxSpeed = 45 + INT(RND * 10)
         Mob.Damage = 15 + (FIX(RND * 100) / 10)
         Mob.BreakBlocks = 1
         Mob.Smart = 1
         Mob.Sprite = SPR_Zombie
      CASE "BOMBER"
         Mob.pos.size = 65 + INT(RND * 5)
         Mob.Weight = 3
         Mob.Health = 110 + RNDN(15)
         Mob.DoKnockback = INT(RND * 6) + 5
         Mob.Speed = 3.3 + (RND * 2)
         Mob.MaxSpeed = 70 + INT(RND * 15)
         Mob.Damage = 4
         Mob.BreakBlocks = 0
         Mob.Smart = 1
         Mob.Sprite = SPR_ZombieBomb
      CASE "FIRE"
         Mob.pos.size = 65 + INT(RND * 10)
         Mob.Weight = 3
         Mob.Health = 80 + INT(RND * 10)
         Mob.DoKnockback = INT(RND * 6) + 5
         Mob.Speed = 2 + (RND * 1)
         Mob.MaxSpeed = 39 + INT(RND * 12)
         Mob.Damage = 1.5 + RNDND(3)
         Mob.BreakBlocks = 1
         Mob.Smart = 1
         Mob.Sprite = SPR_ZombieFire
      CASE "BIOHAZARD"
         Mob.pos.size = 70 + INT(RND * 10)
         Mob.Weight = 2 + (RND * 2)
         Mob.Health = 60 + RNDN(20)
         Mob.DoKnockback = -INT(RND * 6) + 5
         Mob.Speed = 2.2 + (RND * 1)
         Mob.MaxSpeed = 43 + INT(RND * 10)
         Mob.Damage = 2.6 + (RND * 4)
         Mob.BreakBlocks = 1
         Mob.Smart = 1
         Mob.Sprite = SPR_Zombie
      CASE "FAST"
         Mob.pos.size = 58 + INT(RND * 10)
         Mob.Weight = 1 + (RND * 1)
         Mob.Health = 50 + RNDN(20)
         Mob.DoKnockback = INT(RND * 6) + 8
         Mob.Speed = 4.2 + (RND * 2)
         Mob.MaxSpeed = 70 + INT(RND * 20)
         Mob.Damage = 2.6 + (RND * 3)
         Mob.BreakBlocks = 0
         Mob.Smart = 1
         Mob.Sprite = SPR_ZombieFast
   END SELECT
   IF Size <> 0 THEN Mob.pos.size = Size
END SUB

FUNCTION GetBit$ (Text AS STRING, SStart AS STRING, SEnd AS STRING)
   size = LEN(SStart)
   GetBit$ = ""
END FUNCTION

SUB AI_Generic_DeletePoints (Ent AS Entity)
   DIM ClearLastID AS _UNSIGNED INTEGER
   ClearLastID = AIPath(Ent.PathID, 0)
   FOR i = 0 TO ClearLastID
      AIPath(Ent.PathID, i) = 0
   NEXT
   Ent.PathID = 0
END SUB

FUNCTION NearestWaypoint (X AS DOUBLE, y AS DOUBLE)
   DIM LowestDist AS _UNSIGNED LONG: LowestDist = 4294967294
   DIM ClosestID AS _UNSIGNED INTEGER
   DIM Dist AS _UNSIGNED LONG
   FOR w = 0 TO WaypointMax
      Dist = DistanceLow(Waypoint(w).pos.X, Waypoint(w).pos.Y, X, y)
      IF Dist < LowestDist THEN LowestDist = Dist: ClosestID = w
   NEXT
   NearestWaypoint = ClosestID
END FUNCTION

SUB AI_Generic_FillPoints (Ent AS Entity, PointX AS DOUBLE, PointY AS DOUBLE, ClearID AS _UNSIGNED INTEGER)
   Ent.PathID = ClearID
   DIM LowestDist AS _UNSIGNED LONG: LowestDist = 4294967294
   DIM ClosestID AS _UNSIGNED INTEGER
   DIM LowestDist2 AS _UNSIGNED LONG: LowestDist2 = 4294967294
   DIM ClosestID2 AS _UNSIGNED INTEGER
   'Find closest to POINT, we'll start from there.
   FOR w = 0 TO WaypointMax
      Waypoint(w).Calculated = 0: Waypoint(w).Dist = 4294967294
      Dist = DistanceLow(Waypoint(w).pos.X, Waypoint(w).pos.Y, PointX, PointY)
      IF Dist < LowestDist THEN LowestDist = Dist: ClosestID = w
   NEXT
   'Find closest to ENTITY, we'll end from there.
   FOR w = 0 TO WaypointMax
      Dist2 = DistanceLow(Waypoint(w).pos.X, Waypoint(w).pos.Y, Ent.pos.X, Ent.pos.Y)
      IF Dist2 < LowestDist2 THEN LowestDist2 = Dist2: ClosestID2 = w
   NEXT
   $IF DEBUGOUTPUT THEN
      DIM DOIterations AS _UNSIGNED LONG
      DIM FORIterations AS _UNSIGNED LONG
   $END IF

   'Calc dist all
   DIM ToRun(WaypointMax) AS _UNSIGNED INTEGER
   DIM Index AS _UNSIGNED INTEGER
   DIM ArraySize AS _UNSIGNED INTEGER
   DIM ID AS _UNSIGNED INTEGER
   ID = ClosestID
   Waypoint(ID).Calculated = 1
   Waypoint(ID).Dist = 1
   DO
      $IF DEBUGOUTPUT THEN
         DOIterations = DOIterations + 1
      $END IF

      FOR i = 1 TO Waypoint(ID).Connections
         $IF DEBUGOUTPUT THEN
            FORIterations = FORIterations + 1
         $END IF

         IF Waypoint(WaypointJoints(ID, i)).Calculated = 0 THEN
            ArraySize = ArraySize + 1
            ToRun(ArraySize) = WaypointJoints(ID, i)
            Waypoint(WaypointJoints(ID, i)).Dist = Waypoint(ID).Dist + (DistanceLow(Waypoint(WaypointJoints(ID, i)).pos.X, Waypoint(WaypointJoints(ID, i)).pos.Y, Waypoint(ID).pos.X, Waypoint(ID).pos.Y) / 15)
            Waypoint(WaypointJoints(ID, i)).Calculated = 1
            IF WaypointJoints(ID, i) = ClosestID2 THEN EXIT DO
         END IF
      NEXT

      ID = ToRun(Index): Index = Index + 1: IF Index > WaypointMax THEN EXIT DO
      IF ToRun(ArraySize) = ClosestID2 THEN EXIT DO

   LOOP
   $IF DEBUGOUTPUT THEN
      Echo ("INFO - S(AI_Generic_FillPoints): Generated path, cost: DO -" + STR$(DOIterations) + ". FOR - " + STR$(FORIterations))
   $END IF

   DIM EID AS _UNSIGNED INTEGER
   ID = ClosestID2
   Waypoint(ID).Calculated = 1
   DO
      o = o + 1
      LowestDist = 4294967294
      FOR i = 1 TO Waypoint(ID).Connections
         IF Waypoint(WaypointJoints(ID, i)).Calculated = 1 THEN
            IF Waypoint(WaypointJoints(ID, i)).Dist <= LowestDist THEN LowestDist = Waypoint(WaypointJoints(ID, i)).Dist: EID = (WaypointJoints(ID, i))
            Waypoint(WaypointJoints(ID, i)).Calculated = 2
         END IF
      NEXT
      ID = EID
      AIPath(Ent.PathID, o) = ID
      IF ID = ClosestID THEN EXIT DO
   LOOP
   AIPath(Ent.PathID, 0) = o
   $IF DEBUGOUTPUT THEN
      text$ = "AIPATH: ("
      FOR i = 1 TO o
         text$ = text$ + (", " + STR$(AIPath(Ent.PathID, i)))
      NEXT
      text$ = text$ + ")"
      Echo (text$)
   $END IF
END SUB


SUB LoadWaypoints
   DIM File AS STRING
   File = (VantiroPath + "/Maps/" + _TRIM$(Map.Title) + ".waypoints")
   IF _FILEEXISTS(File) THEN
      OPEN File FOR INPUT AS #3
      INPUT #3, WaypointMax
      FOR i = 1 TO WaypointMax
         INPUT #3, trash, Waypoint(i).pos.X, Waypoint(i).pos.Y, Waypoint(i).Exist, Waypoint(i).Connections, WaypointJoints(i, 1), WaypointJoints(i, 2), WaypointJoints(i, 3), WaypointJoints(i, 4), WaypointJoints(i, 5), WaypointJoints(i, 6), WaypointJoints(i, 7), WaypointJoints(i, 8), WaypointJoints(i, 9), WaypointJoints(i, 10), WaypointJoints(i, 11), WaypointJoints(i, 12), WaypointJoints(i, 13), WaypointJoints(i, 14), WaypointJoints(i, 15), WaypointJoints(i, 16)
      NEXT
      CLOSE #3
      $IF DEBUGOUTPUT THEN
         Echo "INFO - S(LoadWaypoints): Loaded!"
      $END IF

   ELSE
      Echo "WARN - S(LoadWaypoints): Waypoints not found. '" + File + "'"
   END IF
END SUB

SUB Echo (text AS STRING)
   $IF DEBUGOUTPUT THEN
      _ECHO (text)
   $END IF
END SUB

SUB SaveWaypoints
   OPEN (VantiroPath + "/maps/" + _TRIM$(Map.Title) + ".waypoints") FOR OUTPUT AS #3
   WRITE #3, WaypointMax
   FOR i = 1 TO WaypointMax
      WRITE #3, i, Waypoint(i).pos.X, Waypoint(i).pos.Y, Waypoint(i).Exist, Waypoint(i).Connections, WaypointJoints(i, 1), WaypointJoints(i, 2), WaypointJoints(i, 3), WaypointJoints(i, 4), WaypointJoints(i, 5), WaypointJoints(i, 6), WaypointJoints(i, 7), WaypointJoints(i, 8), WaypointJoints(i, 9), WaypointJoints(i, 10), WaypointJoints(i, 11), WaypointJoints(i, 12), WaypointJoints(i, 13), WaypointJoints(i, 14), WaypointJoints(i, 15), WaypointJoints(i, 16)
   NEXT
   CLOSE #3
   $IF DEBUGOUTPUT THEN
      Echo ("INFO - S(SaveWaypoints): Saved file.")
   $END IF

END SUB

FUNCTION DisplayNumber (Number AS _UNSIGNED LONG)
   IF Number > 10000 THEN Number = 10000
   DisplayNumber = numberimage(Number)
END FUNCTION

SUB Player1Handler (Ent AS Entity)
   HandsCode
   PlayerMovement Ent
   PlayerLogic
   IF Ent.Health > Config.Player_MaxHealth THEN Ent.Health = Ent.Health - 0.05
   IF Ent.Health < 0 THEN Ent.Health = 0

END SUB

SUB ResetGame
   SpawnMob 2064 * 2, 2064 * 2, 0, 0, 32, "VAMPIRE", "PLAYER", "MAINPLAYER"
   PlayerID = SUBOutUINT
   DynamicLight(1).strength = 350
   DynamicLight(1).Duration = -1
   DynamicLight(1).Detail = "Normal"
   DynamicLight(1).exist = -1
   'DynamicLight(1).Size = 16
   DynamicLight(1).Fov = 60
   DynamicLight(1).DistFall = 4
   DynamicLight(1).LightType = 2
   DynamicLight(1).EntID = PlayerID

   DynamicLight(2).strength = 160
   DynamicLight(2).Duration = -1
   DynamicLight(2).Detail = "Normal"
   DynamicLight(2).exist = -1
   DynamicLight(2).DistFall = 2
   DynamicLight(2).LightType = 1
   DynamicLight(2).EntID = PlayerID


   Hud(1).pos.rot = 200
   Mouse.click = 0
   FOR i = 1 TO FireMax
      Fire(i).Exist = 0
      Fire(i).txt = 0
      Fire(i).pos.XM = 0
      Fire(i).pos.YM = 0
      Fire(i).DoLogic = 0
   NEXT
   Delay = 10
   FOR i = 1 TO Config.ParticlesMax
      Part(i).Exist = 0
      Part(i).DoLogic = 0
   NEXT

   FOR i = 1 TO 2
      PlayerMember(i).pos.X = Mobs(PlayerID).pos.X
      PlayerMember(i).pos.Y = Mobs(PlayerID).pos.Y
      PlayerMember(i).pos.size = 9
   NEXT
END SUB


SUB Interpolate (ent AS position)
   IF Config.Game_Interpolation THEN
      DIM Ticktime AS DOUBLE
      Ticktime = (CurTickTime - TimeTick) * TPS
      ent.Xv = (1 - Ticktime) * ent.Xb + Ticktime * ent.X
      ent.Yv = (1 - Ticktime) * ent.Yb + Ticktime * ent.Y
      ent.Zv = (1 - Ticktime) * ent.Zb + Ticktime * ent.Z
      ent.rotv = (1 - Ticktime) * ent.rotb + Ticktime * ent.rot
   ELSE
      ent.rotv = ent.rot
      ent.Xv = ent.X
      ent.Yv = ent.Y
      ent.Zv = ent.Z
   END IF
END SUB

SUB DoVisualHitbox (obj AS position)
   obj.x1v = obj.Xv - obj.size
   obj.x2v = obj.Xv + obj.size
   obj.y1v = obj.Yv - obj.size
   obj.y2v = obj.Yv + obj.size
END SUB

SUB GetBPos (Ent AS position)
   Ent.Xb = Ent.X
   Ent.Yb = Ent.Y
   Ent.Zb = Ent.Z
   Ent.rotb = Ent.rot
END SUB

