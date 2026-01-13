
<img width="1440" height="480" alt="Enhanced SC Logo" src="https://github.com/user-attachments/assets/6af39e6a-6238-40bc-bc27-a84d1b428674"/>
A major patch for the original Splinter Cell, fixing bugs and adding gameplay improvements.

For a full list of patch notes, refer to the [Patch Notes](PatchNotes.md) page.

[![Discord](https://img.shields.io/discord/1371978442194817254?color=%237289DA&label=Members&logo=discord&logoColor=white)](https://discord.gg/k6mZJcfjSh)

## Installation
The latest version of Enhanced SC can be found in the [Releases](https://github.com/Joshhhuaaa/EnhancedSC/releases) page. Please note that saves from Enhanced SC are not compatible with the original version of the game.

### Game Setup
- After downloading Enhanced SC, extract the contents to your Splinter Cell directory and overwrite all existing files when prompted.
- You can adjust additional settings in the Enhanced tab within the in-game settings.

> [!NOTE]
> Your original saves will not be deleted, but they will appear as missing. Enhanced intentionally hides them because they aren't compatible with this version.

## Linux / Steam Deck Installation
**This section is intended for Linux only, and should be skipped if installing on Windows.**

Download the latest Linux (Steam Deck) build from the [Releases](https://github.com/Joshhhuaaa/EnhancedSC/releases) page, rather than the standard release. This version includes dgVoodoo v2.79.3 for Linux, since newer versions currently cause the game to crash.

Enhanced SC, [dgVoodoo2](https://github.com/dege-diosg/dgVoodoo2), [ThirteenAG Widescreen Fix](https://github.com/ThirteenAG/WidescreenFixesPack), and [Xidi](https://github.com/samuelgr/Xidi) won't load without a DLL override in your Wine prefix.

To add the DLL override in Steam, right-click the game in the library and select `Properties`.

In the General tab, add the following to the launch options:
```
WINEDLLOVERRIDES="D3D8,msacm32,msvfw32,dinput8=n,b" %command%
```

In the Compatibility tab, check `Force the use of a specific Steam Play compatibility tool` and select `Proton 10.0-1`. Other versions may work, but this one has been tested.

<img src="https://github.com/user-attachments/assets/b133d6f4-e2c9-48ba-8f71-d96817baa145" width="640"/>

For more detailed instructions on how to override a DLL, refer to this [guide](https://cookieplmonster.github.io/setup-instructions/#proton-wine).

> [!NOTE]
> If you're playing on a Steam Deck, it's recommended to download the `EnhancedSC Layout` by Vanilla from Steam's Community Layouts.
>
> <img src="https://github.com/user-attachments/assets/5d559a82-bb8f-4b21-9ecb-d99f314cabda" width="640"/>


## Uninstallation
To manually remove Enhanced SC from your game installation:
- Navigate to the `System` folder, delete the `Enhanced` folder, and `Enhanced.ini`.
- Navigate to the `System/scripts` folder and delete `EnhancedSC.asi`.

This patch also includes [dgVoodoo2](https://github.com/dege-diosg/dgVoodoo2), [ThirteenAG Widescreen Fix](https://github.com/ThirteenAG/WidescreenFixesPack), and [Xidi](https://github.com/samuelgr/Xidi).

#### dgVoodoo2
- Delete `D3D8.dll` and `dgVoodoo.conf`.

#### ThirteenAG Widescreen Fix
- Delete `SplinterCell.WidescreenFix.asi` from the `System/scripts` folder.
- Both Enhanced SC and ThirteenAG Widescreen Fix depend on `msacm32.dll` and `msvfw32.dll`.
  - If removing both mods, these `.dll` files can also be deleted.

#### Xidi
- Delete `dinput8.dll`, `Xidi.32.dll`, and `Xidi.ini`.

## Mission Statistics
Mission Statistics can be viewed while playing a mission by pressing `Tab` on keyboard or upon completing a mission.

The Mission Statistics key can be rebound in the Controls tab in Settings. Controllers use the `Back` button to view Mission Statistics.

Mission Statistics feature two rating systems: Ghost and Stealth. Ghost penalizes unnecessary knockouts, while Stealth allows knockouts as long as the player remains undetected.

| Statistic                     | Ghost Penalty | Stealth Penalty |
|-------------------------------|---------------|------------------
| Times Identified as Intruder  | -15%          | -15%            |
| Bodies Found                  | -15%          | -15%            |
| Alarms Triggered              | -20%          | -20%            |
| Enemies Knocked Out           | -5%           | -0%             |
| Enemies Killed                | -10%          | -10%            |
| Civilians Knocked Out         | -5%           | -0%             |
| Civilians Killed              | -30%          | -30%            |
| Locks Destroyed               | -2%           | -2%             |

### Notes
- All missions can be completed with a 100% rating.
- NPCs involved in a forced action sequence do not penalize you for being seen, knocked out, or found.
- If an NPC must be taken out and can be done stealthily, you must remain undetected and hide the body.
- NPCs who carry required data such as door codes in their satchel will not penalize you for knocking them out. You are not expected to remember codes from previous playthroughs.

## Language Pack
The Steam version of Splinter Cell only includes English and French by default. The original release of the game included English, French, Italian, German, and Spanish. If you would like to play in a missing language, download the language pack below.

- Download [Language Pack](https://drive.usercontent.google.com/download?id=1BNKBA8SiK611fz_Ypj_j6DVSsLYEFTs2)
- After downloading the language pack, extract the contents to your Splinter Cell directory and overwrite all existing files when prompted.
- To change the language, open `SplinterCell.ini` in the System folder and modify the `Language=int` line to the code for your desired language:

| Language Code  | Language                |
| -------------- | ------------------------|
| deu            | German                  |
| esp            | Spanish                 |
| fra            | French                  |
| int            | English / International |
| ita            | Italian                 |

> [!NOTE]
> Russian, Polish, and Korean translations were released for this game, but Enhanced SC does not currently support them due to font incompatibility.

## PlayStation 3 HD Textures for Enhanced SC
Enhanced SC includes an improved character texture package that replaces the original PS3 `ETexCharacter.utx`. It also uses the `System\Enhanced\Textures` directory to override the original texture packages without overwriting them. This download has been specifically made to be used with Enhanced SC.

- Download [Enhanced SC PS3 Textures](https://drive.usercontent.google.com/uc?id=1_3h-L5dKsHgrB8rt8pZ3SVajxRQYtjG8)
- After downloading the textures, extract the contents to your Splinter Cell directory and overwrite all existing files when prompted.

> [!NOTE]
> The PlayStation 3 HD textures originally caused issues with shadows not rendering properly through alpha textures. I’ve recently rebuilt them to fix this problem. However, some of Ubisoft's replacement textures deviate from the original design instead of just increasing resolution.

<img width="3840" height="3240" alt="PS3_Comparison" src="https://github.com/user-attachments/assets/a1ccf32b-1d0a-40cd-b1a7-effc16f9910a"/>
