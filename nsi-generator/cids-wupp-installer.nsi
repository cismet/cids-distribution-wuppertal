### INCLUDES
!include LogicLib.nsh
!include MUI2.nsh
###/INCLUDES

### CONFIG
!define CIDS_NAME "cids-wunda"
!define CIDS_INSTALLER "${CIDS_NAME}-install.exe"
!define CIDS_HKLM_UNINSTALL "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${CIDS_NAME}"
!define MUI_ICON "installer.ico"

Name "cids Wupp Installer"
Caption "cids Installation für Stadtverwaltung Wuppertal"
Icon "installer.ico"
OutFile "${CIDS_INSTALLER}"
InstallDir "$DESKTOP\${CIDS_NAME}\"
###/CONFIG


### WELCOME PAGE
!define MUI_TEXT_WELCOME_INFO_TITLE "cids-Starter"
!define MUI_TEXT_WELCOME_INFO_TEXT "Willkommens-Text"
!insertmacro MUI_PAGE_WELCOME
###/WELCOME PAGE

### DIRECTORY PAGE
!define MUI_TEXT_DIRECTORY_TITLE "Verzeichnis-Titel"
!define MUI_TEXT_DIRECTORY_SUBTITLE "Verzeichnis-Text"
!insertmacro MUI_PAGE_DIRECTORY
###/DIRECTORY PAGE

### COMPONENTS PAGE
!insertmacro MUI_PAGE_COMPONENTS
###/COMPONENTS PAGE

### INSTALLING PAGE
!define MUI_TEXT_INSTALLING_TITLE "Installation-Titel"
!define MUI_TEXT_INSTALLING_SUBTITLE "Installation-Text"
!insertmacro MUI_PAGE_INSTFILES
###/INSTALLING PAGE

### FINISH PAGE
#!define MUI_FINISHPAGE_SHOWREADME "Abschluss-Text"
#!define MUI_FINISHPAGE_SHOWREADME_TEXT "Verknüpfungen im Startmenü erzeugen"
#!define MUI_FINISHPAGE_SHOWREADME_FUNCTION CreateShortcuts
#!define MUI_TEXT_FINISH_TITLE "Abschluss-Titel"
#!define MUI_TEXT_FINISH_SUBTITLE "Abschluss-Text"
#!define MUI_TEXT_FINISH_INFO_TITLE "Fertig-Titel"
#!define MUI_TEXT_FINISH_INFO_REBOOT "Neustart"
#!define MUI_TEXT_FINISH_REBOOTNOW "Jetzt neustarten"
#!define MUI_TEXT_FINISH_REBOOTLATER "Später neustarten"
#!define MUI_TEXT_FINISH_INFO_TEXT "Fertig-Text"
#!insertmacro MUI_PAGE_FINISH
###/FINISH PAGE

!insertmacro MUI_LANGUAGE "German"

!define MUI_TEXT_ABORT_TITLE "Abbruch-Titel"
!define MUI_TEXT_ABORT_SUBTITLE "Abbruch-Text"
!define MUI_BUTTONTEXT_FINISH "Fertig"

#### CreateShortcuts
!macro CreateShortcuts TARGETDIR
  push ${TARGETDIR}
  call CreateShortcuts
!macroend
Function CreateShortcuts
    pop $R0
    CreateDirectory "$SMPROGRAMS\${CIDS_NAME}"
    FindFirst $0 $1 "$INSTDIR\launchers\*.exe"
    loop:
    StrCmp $1 "" done
    StrCmp $1 "." next
    StrCmp $1 ".." next
    DetailPrint "creating shortcut for launcher: $INSTDIR\launchers\$1"
    StrCpy $2 $1 -4 
    CreateShortcut "$R0\$2.lnk" "$INSTDIR\launchers\$1"
    next:
    FindNext $0 $1
    Goto loop
    done:
    FindClose $0    
FunctionEnd
####/CreateShortcuts

### Vars
Var INSTALL_BELIS
Var INSTALL_BELIS_PUBLIC
Var INSTALL_CISMAP
Var INSTALL_CISMAP_3GB
Var INSTALL_CONNECTION_TESTER
Var INSTALL_CONNECTION_TESTER_PUBLIC
Var INSTALL_LAGIS
Var INSTALL_NAVIGATOR
Var INSTALL_NAVIGATOR_3GB
Var INSTALL_NAVIGATOR_PUBLIC
Var INSTALL_NAVIGATOR_PUBLIC_2GB
Var INSTALL_NAVIGATOR_PUBLIC_ALKIS
Var INSTALL_NAVIGATOR_PUBLIC_ALKIS_1000MB
Var INSTALL_NAVIGATOR_PUBLIC_ALKIS_700MB
Var INSTALL_NAVIGATOR_PUBLIC_IMMO
Var INSTALL_NAVIGATOR_PUBLIC_MAUERN
Var INSTALL_NAVIGATOR_PUBLIC_WOHNLAGEN
Var INSTALL_NAVIGATOR_WSW
Var INSTALL_PASSWORD_SWITCHER
Var INSTALL_VERDIS
Var INSTALL_VERDIS_3GB

###/Vars

!define INSTALL_SELECTED "SELECTED"
Function InstallApps
### INSTALL
    ; ../getdown-belis-client-ext/pom.xml
    ${If} $INSTALL_BELIS_PUBLIC == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\belis-public"
        File /r "apps\belis-public\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\BelIS (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-belis-client/pom.xml
    ${If} $INSTALL_BELIS == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\belis"
        File /r "apps\belis\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\BelIS.exe"
    ${EndIf}
    ; ../getdown-connection-tester-internet/pom.xml
    ${If} $INSTALL_CONNECTION_TESTER_PUBLIC == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\connection-tester-public"
        File /r "apps\connection-tester-public\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\Verbindungstest (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-connection-tester/pom.xml
    ${If} $INSTALL_CONNECTION_TESTER == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\connection-tester"
        File /r "apps\connection-tester\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\Verbindungstest.exe"
    ${EndIf}
    ; ../getdown-lagis-client/pom.xml
    ${If} $INSTALL_LAGIS == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\lagis"
        File /r "apps\lagis\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\LagIS.exe"
    ${EndIf}
    ; ../getdown-password-switcher/pom.xml
    ${If} $INSTALL_PASSWORD_SWITCHER == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\password-switcher"
        File /r "apps\password-switcher\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\Passwort-Switcher.exe"
    ${EndIf}
    ; ../getdown-verdis-client-3gb/pom.xml
    ${If} $INSTALL_VERDIS_3GB == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\verdis-3gb"
        File /r "apps\verdis-3gb\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\VerdIS 3GB.exe"
    ${EndIf}
    ; ../getdown-verdis-client/pom.xml
    ${If} $INSTALL_VERDIS == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\verdis"
        File /r "apps\verdis\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\VerdIS.exe"
    ${EndIf}
    ; ../getdown-wunda-dk-standalone-3gb/pom.xml
    ${If} $INSTALL_CISMAP_3GB == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\cismap-3gb"
        File /r "apps\cismap-3gb\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa DK 3GB.exe"
    ${EndIf}
    ; ../getdown-wunda-dk-standalone/pom.xml
    ${If} $INSTALL_CISMAP == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\cismap"
        File /r "apps\cismap\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa DK.exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-3gb/pom.xml
    ${If} $INSTALL_NAVIGATOR_3GB == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-3gb"
        File /r "apps\navigator-3gb\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator 3GB.exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-alkis-internet1000MB/pom.xml
    ${If} $INSTALL_NAVIGATOR_PUBLIC_ALKIS_1000MB == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-public-alkis-1000mb"
        File /r "apps\navigator-public-alkis-1000mb\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator ALKIS 1000MB (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-alkis-internet700MB/pom.xml
    ${If} $INSTALL_NAVIGATOR_PUBLIC_ALKIS_700MB == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-public-alkis-700mb"
        File /r "apps\navigator-public-alkis-700mb\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator ALKIS 700MB (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-alkis-internet/pom.xml
    ${If} $INSTALL_NAVIGATOR_PUBLIC_ALKIS == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-public-alkis"
        File /r "apps\navigator-public-alkis\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator ALKIS (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-immo-internet/pom.xml
    ${If} $INSTALL_NAVIGATOR_PUBLIC_IMMO == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-public-immo"
        File /r "apps\navigator-public-immo\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator IMMO (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-internet-2gb/pom.xml
    ${If} $INSTALL_NAVIGATOR_PUBLIC_2GB == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-public-2gb"
        File /r "apps\navigator-public-2gb\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator 2GB (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-internet/pom.xml
    ${If} $INSTALL_NAVIGATOR_PUBLIC == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-public"
        File /r "apps\navigator-public\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-mauern-internet/pom.xml
    ${If} $INSTALL_NAVIGATOR_PUBLIC_MAUERN == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-public-mauern"
        File /r "apps\navigator-public-mauern\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator Mauern (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-wunda-navigator/pom.xml
    ${If} $INSTALL_NAVIGATOR == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator"
        File /r "apps\navigator\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator.exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-wohnlagen-internet/pom.xml
    ${If} $INSTALL_NAVIGATOR_PUBLIC_WOHNLAGEN == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-public-wohnlagen"
        File /r "apps\navigator-public-wohnlagen\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator Wohnlagen (Öffentlich).exe"
    ${EndIf}
    ; ../getdown-wunda-navigator-wsw/pom.xml
    ${If} $INSTALL_NAVIGATOR_WSW == ${INSTALL_SELECTED}
        SetOutPath "$INSTDIR\apps\navigator-wsw"
        File /r "apps\navigator-wsw\"
        SetOutPath "$INSTDIR\launchers"
        File "launchers\WuNDa Navigator für WSW (Intranet).exe"
    ${EndIf}

###/INSTALL
FunctionEnd

### SECTIONS
SectionGroup /e "Starter" secgroup_apps
    SectionGroup /e "Intranet" secgroup_intra
        SectionGroup "WuNDa Navigator" secgroup_navigator_intra
            Section "WuNDa Navigator 3GB" sec-navigator-navigator-3gb
                StrCpy $INSTALL_NAVIGATOR_3GB "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa Navigator" sec-navigator-navigator
                StrCpy $INSTALL_NAVIGATOR "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa Navigator für WSW (Intranet)" sec-navigator-navigator-wsw
                StrCpy $INSTALL_NAVIGATOR_WSW "${INSTALL_SELECTED}"
            SectionEnd
        SectionGroupEnd
        SectionGroup "WuNDa DK" secgroup_cismap_intra
            Section "WuNDa DK 3GB" sec-cismap-cismap-3gb
                StrCpy $INSTALL_CISMAP_3GB "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa DK" sec-cismap-cismap
                StrCpy $INSTALL_CISMAP "${INSTALL_SELECTED}"
            SectionEnd
        SectionGroupEnd
        SectionGroup "BelIS" secgroup_belis_intra
            Section "BelIS" sec-belis-belis
                StrCpy $INSTALL_BELIS "${INSTALL_SELECTED}"
            SectionEnd
        SectionGroupEnd
        SectionGroup "LagIS" secgroup_lagis_intra
            Section "LagIS" sec-lagis-lagis
                StrCpy $INSTALL_LAGIS "${INSTALL_SELECTED}"
            SectionEnd
        SectionGroupEnd
        SectionGroup "VerdIS" secgroup_verdis_intra
            Section "VerdIS 3GB" sec-verdis-verdis-3gb
                StrCpy $INSTALL_VERDIS_3GB "${INSTALL_SELECTED}"
            SectionEnd
            Section "VerdIS" sec-verdis-verdis
                StrCpy $INSTALL_VERDIS "${INSTALL_SELECTED}"
            SectionEnd
        SectionGroupEnd
        SectionGroup "Tools" secgroup_tools_intra
            Section "Verbindungstest" sec-tools-connection-tester
                StrCpy $INSTALL_CONNECTION_TESTER "${INSTALL_SELECTED}"
            SectionEnd
            Section "Passwort-Switcher" sec-tools-password-switcher
                StrCpy $INSTALL_PASSWORD_SWITCHER "${INSTALL_SELECTED}"
            SectionEnd
        SectionGroupEnd
    SectionGroupEnd
    SectionGroup /e "Öffentlich" secgroup_public
        SectionGroup "WuNDa Navigator" secgroup_navigator_public
            Section "WuNDa Navigator ALKIS 1000MB (Öffentlich)" sec-navigator-public-navigator-public-alkis-1000mb
                StrCpy $INSTALL_NAVIGATOR_PUBLIC_ALKIS_1000MB "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa Navigator ALKIS 700MB (Öffentlich)" sec-navigator-public-navigator-public-alkis-700mb
                StrCpy $INSTALL_NAVIGATOR_PUBLIC_ALKIS_700MB "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa Navigator ALKIS (Öffentlich)" sec-navigator-public-navigator-public-alkis
                StrCpy $INSTALL_NAVIGATOR_PUBLIC_ALKIS "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa Navigator IMMO (Öffentlich)" sec-navigator-public-navigator-public-immo
                StrCpy $INSTALL_NAVIGATOR_PUBLIC_IMMO "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa Navigator 2GB (Öffentlich)" sec-navigator-public-navigator-public-2gb
                StrCpy $INSTALL_NAVIGATOR_PUBLIC_2GB "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa Navigator (Öffentlich)" sec-navigator-public-navigator-public
                StrCpy $INSTALL_NAVIGATOR_PUBLIC "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa Navigator Mauern (Öffentlich)" sec-navigator-public-navigator-public-mauern
                StrCpy $INSTALL_NAVIGATOR_PUBLIC_MAUERN "${INSTALL_SELECTED}"
            SectionEnd
            Section "WuNDa Navigator Wohnlagen (Öffentlich)" sec-navigator-public-navigator-public-wohnlagen
                StrCpy $INSTALL_NAVIGATOR_PUBLIC_WOHNLAGEN "${INSTALL_SELECTED}"
            SectionEnd
        SectionGroupEnd
        SectionGroup "WuNDa DK" secgroup_cismap_public
        SectionGroupEnd
        SectionGroup "BelIS" secgroup_belis_public
            Section "BelIS (Öffentlich)" sec-belis-public-belis-public
                StrCpy $INSTALL_BELIS_PUBLIC "${INSTALL_SELECTED}"
            SectionEnd
        SectionGroupEnd
        SectionGroup "LagIS" secgroup_lagis_public
        SectionGroupEnd
        SectionGroup "VerdIS" secgroup_verdis_public
        SectionGroupEnd
        SectionGroup "Tools" secgroup_tools_public
            Section "Verbindungstest (Öffentlich)" sec-tools-public-connection-tester-public
                StrCpy $INSTALL_CONNECTION_TESTER_PUBLIC "${INSTALL_SELECTED}"
            SectionEnd
        SectionGroupEnd
    SectionGroupEnd
SectionGroupEnd

###/SECTIONS

Section "-installation"
    SetOutPath "$INSTDIR\launchers"
    File /r "launchers\*.jar"

    WriteRegStr HKLM "${CIDS_HKLM_UNINSTALL}" "DisplayName" "${CIDS_NAME} (Deinstallieren)"
    WriteRegStr HKLM "${CIDS_HKLM_UNINSTALL}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteUninstaller "$INSTDIR\uninstall.exe"

    Call InstallApps
SectionEnd

SectionGroup /e "Verknüpfungen"
    Section "Startmenü"
        !insertmacro CreateShortcuts "$SMPROGRAMS\${CIDS_NAME}"
    SectionEnd

    Section /o "Desktop"
        !insertmacro CreateShortcuts "$DESKTOP"
    SectionEnd
SectionGroupEnd

Section "Uninstall"
  RMDir /r "$INSTDIR\*.*"     
  RMDir "$INSTDIR"
 
  Delete "$SMPROGRAMS\${CIDS_NAME}\*.*"
  RmDir  "$SMPROGRAMS\${CIDS_NAME}"
 
  DeleteRegKey HKEY_LOCAL_MACHINE "${CIDS_HKLM_UNINSTALL}"  
SectionEnd

### DESCRIPTIONS
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${secgroup_apps} "CIDS-WuNDa Starter."
    !insertmacro MUI_DESCRIPTION_TEXT ${secgroup_intra} "Starter die nur aus dem Netzwerk der Stadtverwaltung Wuppertal heraus aufrufbar."
    !insertmacro MUI_DESCRIPTION_TEXT ${secgroup_public} "Starter welche explizit für den Aufruf außerhalb des Netzwerks der Stadtverwaltung Wuppertal vorgesehen sind."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

###/DESCRIPTIONS
