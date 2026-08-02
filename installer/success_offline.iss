; Inno Setup script for SuccessBOX (Chronicles Revolution) — builds a
; single self-contained Setup.exe from the Flutter Windows release build.
; Compile with: ISCC.exe installer\success_offline.iss
; (run from the project root so the relative Source/IconFile paths resolve)

#define MyAppName "SuccessBOX"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Chronicles Revolution"
#define MyAppExeName "success_offline.exe"

[Setup]
AppId={{B4E2F3D1-9A6C-4E7B-8F1A-2C5D6E8A9B3F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=..\installer\output
OutputBaseFilename=SuccessBOX-Setup
Compression=lzma2
SolidCompression=yes
SetupIconFile=..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
WizardStyle=modern
; Not code-signed — first launch may show a Windows SmartScreen prompt;
; recipients click "More info" -> "Run anyway". Fine for direct-to-tester
; distribution; a real code-signing cert would remove that prompt.

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
; Everything the release build needs at runtime — exe, plugin DLLs, and
; the data\ folder (flutter_assets, app.so, icudtl.dat) — copied as-is.
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent
