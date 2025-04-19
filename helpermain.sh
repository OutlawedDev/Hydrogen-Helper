#!/bin/bash

# Colors and formatting
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
RESET="\033[0m"

# Animation function
animate_text() {
  text=$1
  color=$2
  for (( i=0; i<${#text}; i++ )); do
    echo -ne "${color}${text:$i:1}${RESET}"
    sleep 0.01
  done
  echo
}

# Loading animation
show_loading() {
  message=$1
  echo -ne "${YELLOW}$message ${RESET}"
  for i in {1..3}; do
    for s in / - \\ \|; do
      echo -ne "\b$s"
      sleep 0.1
    done
  done
  echo -ne "\b \n"
}

# Display banner
display_banner() {
  clear
  echo -e "${BLUE}${BOLD}"
  echo "╔═══════════════════════════════════════════════════════════╗"
  echo "║                                                           ║"
  animate_text "       ██╗  ██╗██╗   ██╗██████╗ ██████╗  ██████╗  ██████╗ ███████╗███╗   ██╗      " "$CYAN"
  animate_text "       ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔═══██╗██╔════╝ ██╔════╝████╗  ██║      " "$CYAN"
  animate_text "       ███████║ ╚████╔╝ ██║  ██║██████╔╝██║   ██║██║  ███╗█████╗  ██╔██╗ ██║      " "$CYAN"
  animate_text "       ██╔══██║  ╚██╔╝  ██║  ██║██╔══██╗██║   ██║██║   ██║██╔══╝  ██║╚██╗██║      " "$CYAN"
  animate_text "       ██║  ██║   ██║   ██████╔╝██║  ██║╚██████╔╝╚██████╔╝███████╗██║ ╚████║      " "$CYAN"
  animate_text "       ╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝      " "$CYAN"
  echo "║                                                           ║"
  echo -e "╚═══════════════════════════════════════════════════════════╝${RESET}"
  echo -e "${GREEN}${BOLD}                 Hydrogen Helper Utility${RESET}"
  echo -e "${YELLOW}                 from my-oblilyum & 109dg${RESET}"
  echo
}

# Check for sudo access
check_sudo() {
  echo -e "${YELLOW}Checking for administrative privileges...${RESET}"
  if sudo -v; then
    echo -e "${GREEN}✓ Admin access confirmed${RESET}"
    sleep 1
  else
    echo -e "${RED}✗ Admin access required but not granted${RESET}"
    echo -e "${RED}Please run this script again with admin privileges${RESET}"
    exit 1
  fi
}

# Main script execution
display_banner
check_sudo

# Run the AppleScript
osascript <<'APPLESCRIPT'
use scripting additions

property RBX_APP        : "/Applications/Roblox.app"
property HYD_APP        : "/Applications/Hydrogen-M.app"
property HYD_URL        : "https://0ai4bbbahf.ufs.sh/f/4fzhZqSSYIjmaQcw2hMCuIoXRdv5E3iwKj1g7S8GWLOxkpfJ"

on sh(cmd)
	try
		return do shell script cmd
	on error e
		return "[ERROR] " & e
	end try
end sh

-- Open Roblox
on openRoblox()
	if sh("test -x " & quoted form of (RBX_APP & "/Contents/MacOS/RobloxPlayer") & " && echo OK") ≠ "OK" then
		display alert "Cannot open Roblox" message "Roblox.app missing or broken." buttons {"OK"} as critical
	else
		do shell script "echo -e '\\033[32mLaunching Roblox...\\033[0m'"
		sh("open -a " & quoted form of RBX_APP)
	end if
end openRoblox

-- Clear Roblox cache
on clearCache()
	do shell script "echo -e '\\033[33mClearing Roblox cache...\\033[0m'"
	do shell script "for i in {1..20}; do echo -ne '\\033[33mProgress: ['; for ((j=0; j<i; j++)); do echo -ne '#'; done; for ((j=i; j<20; j++)); do echo -ne ' '; done; echo -ne '] '\\r\\033[0m'; sleep 0.1; done"
	sh("rm -rf ~/Library/Application\\ Support/Roblox")
	sh("rm -rf ~/Library/Caches/com.roblox.Roblox")
	do shell script "echo -e '\\033[32m\\nRoblox cache cleared successfully!\\033[0m'"
	display dialog "Roblox cache cleared." buttons {"OK"} default button "OK"
end clearCache

-- Uninstall both Roblox & Hydrogen
on uninstallAll()
	do shell script "echo -e '\\033[33mUninstalling Roblox and Hydrogen-M...\\033[0m'"
	do shell script "for i in {1..20}; do echo -ne '\\033[33mProgress: ['; for ((j=0; j<i; j++)); do echo -ne '#'; done; for ((j=i; j<20; j++)); do echo -ne ' '; done; echo -ne '] '\\r\\033[0m'; sleep 0.1; done"
	sh("rm -rf " & quoted form of RBX_APP)
	sh("rm -rf " & quoted form of HYD_APP)
	sh("rm -rf ~/Library/Application\\ Support/Roblox")
	sh("rm -rf ~/Library/Caches/com.roblox.Roblox")
	do shell script "echo -e '\\033[32m\\nUninstallation complete!\\033[0m'"
	display dialog "Uninstalled Roblox and Hydrogen‑M (if present)." buttons {"OK"} default button "OK"
end uninstallAll

-- Reinstall both (Roblox & Hydrogen)
on reinstallBoth()
	display dialog "Reinstalling Roblox (this will also reinstall Hydrogen)..." buttons {"OK"} default button "OK"
	do shell script "echo -e '\\033[33mReinstalling Roblox and Hydrogen-M...\\033[0m'"
	uninstallAll()
	installHydrogen()
	do shell script "echo -e '\\033[32mReinstallation complete!\\033[0m'"
	display dialog "Reinstallation complete!" buttons {"OK"} default button "OK"
end reinstallBoth

-- Install Hydrogen
on installHydrogen()
	do shell script "echo -e '\\033[36mPreparing to install Hydrogen-M...\\033[0m'"
	do shell script "echo -e '\\033[36mOpening Terminal and running installer...\\033[0m'"
	set HYD_CMD to "echo -e '\\033[35m'; echo '╔═══════════════════════════════════════════╗'; echo '║ Installing Hydrogen-M, please wait...     ║'; echo '╚═══════════════════════════════════════════╝'; echo -e '\\033[0m'; curl -fsSL " & HYD_URL & " | bash"
	tell application "Terminal"
		activate
		do script HYD_CMD
	end tell
	display notification "Hydrogen‑M is running in Terminal" with title "Hydrogen Helper"
end installHydrogen

-- Fixer handlers
on checkSysReq()
	do shell script "echo -e '\\033[36mChecking system requirements...\\033[0m'"
	set v to system version of (system info)
	set arch to do shell script "uname -m"
	do shell script "echo -e '\\033[36mDetected: macOS " & v & " on " & arch & "\\033[0m'"
	if v < "11.0" then
		do shell script "echo -e '\\033[31m✗ macOS 11+ required. You're on " & v & "\\033[0m'"
		display dialog "macOS 11+ required. You're on " & v buttons {"OK"} default button "OK"
	else
		do shell script "echo -e '\\033[32m✓ System meets requirements!\\033[0m'"
		display dialog "System meets requirements:" & return & "macOS " & v & return & "CPU: " & arch buttons {"OK"} default button "OK"
	end if
end checkSysReq

on fixSuddenClose()
	do shell script "echo -e '\\033[33mTroubleshooting sudden close issues...\\033[0m'"
	do shell script "echo -e '\\033[36m1) Redownload Hydrogen and open it.\\033[0m'"
	do shell script "echo -e '\\033[36m2) Open Roblox, let it fully load.\\033[0m'"
	do shell script "echo -e '\\033[36m3) Restart your Mac if needed.\\033[0m'"
	display dialog "Fix if Hydrogen‑M closes suddenly:" & return & return & ¬
		"1) Redownload Hydrogen and open it." & return & ¬
		"2) Open Roblox, let it fully load." & return & ¬
		"3) Restart your Mac if needed." buttons {"OK"} default button "OK"
end fixSuddenClose

on fixRobloxArch()
	do shell script "echo -e '\\033[36mChecking Roblox architecture...\\033[0m'"
	set info to sh("file " & quoted form of (RBX_APP & "/Contents/MacOS/RobloxPlayer"))
	if info contains "arm64" or info contains "x86_64" then
		do shell script "echo -e '\\033[32m✓ Roblox architecture is OK.\\033[0m'"
		display dialog "Roblox architecture is OK." buttons {"OK"} default button "OK"
	else
		do shell script "echo -e '\\033[31m✗ RobloxPlayer isn't arm64/x86_64.\\033[0m'"
		do shell script "echo -e '\\033[36mRecommended fixes:\\033[0m'"
		do shell script "echo -e '\\033[36m1) Delete /Applications/Roblox.app\\033[0m'"
		do shell script "echo -e '\\033[36m2) Download correct build from roblox.com\\033[0m'"
		do shell script "echo -e '\\033[36m3) Install it (no Rosetta)\\033[0m'"
		display dialog "RobloxPlayer isn't arm64/x86_64." & return & return & ¬
			"1) Delete /Applications/Roblox.app" & return & ¬
			"2) Download correct build from roblox.com" & return & ¬
			"3) Install it (no Rosetta)" buttons {"OK"} default button "OK"
	end if
end fixRobloxArch

on fixPortBinding()
	do shell script "echo -e '\\033[36mChecking port binding...\\033[0m'"
	openRoblox()
	delay 5
	do shell script "echo -e '\\033[36mVerifying ports 6969-7069...\\033[0m'"
	if sh("lsof -iTCP -sTCP:LISTEN | grep -E '6969|6970|7069'") = "" then
		do shell script "echo -e '\\033[31m✗ No HTTP server on ports 6969–7069.\\033[0m'"
		display dialog "No HTTP server on ports 6969–7069." buttons {"Install Hydrogen‑M"} default button "Install Hydrogen‑M"
		installHydrogen()
	else
		do shell script "echo -e '\\033[32m✓ Ports 6969–7069 are active. Hydrogen‑M is loaded.\\033[0m'"
		display dialog "Ports 6969–7069 are active. Hydrogen‑M is loaded." buttons {"OK"} default button "OK"
	end if
end fixPortBinding

on fixPasswordPrompt()
	do shell script "echo -e '\\033[33mTroubleshooting password prompt issues...\\033[0m'"
	do shell script "echo -e '\\033[36mIf password prompt is hidden, type your password and press Enter.\\033[0m'"
	display dialog "Password prompt hidden? Type your password and press Enter." buttons {"OK"} default button "OK"
end fixPasswordPrompt

-- Helper menu
on helperMenu()
	repeat
		do shell script "clear; echo -e '\\033[34m╔═══════════════════════════════════════════╗\\n║           HYDROGEN HELPER MENU           ║\\n╚═══════════════════════════════════════════╝\\033[0m'"
		do shell script "echo -e '\\033[36m 1. Open Roblox\\033[0m'"
		do shell script "echo -e '\\033[36m 2. Clear Roblox Cache\\033[0m'"
		do shell script "echo -e '\\033[36m 3. Reinstall Roblox (will reinstall Hydrogen)\\033[0m'"
		do shell script "echo -e '\\033[36m 4. Install Hydrogen‑M\\033[0m'"
		do shell script "echo -e '\\033[36m 5. Uninstall All\\033[0m'"
		do shell script "echo -e '\\033[36m 6. Back\\033[0m'"
		
		set choice to choose from list ¬
			{"Open Roblox", "Clear Roblox Cache", ¬
			 "Reinstall Roblox (will reinstall Hydrogen)", ¬
			 "Install Hydrogen‑M", "Uninstall All", "Back"} ¬
			with title "Hydrogen Helper" with prompt "Helper Options:"
		if choice is false or item 1 of choice = "Back" then return
		set sel to item 1 of choice
		if sel = "Open Roblox" then openRoblox()
		if sel = "Clear Roblox Cache" then clearCache()
		if sel = "Reinstall Roblox (will reinstall Hydrogen)" then reinstallBoth()
		if sel = "Install Hydrogen‑M" then installHydrogen()
		if sel = "Uninstall All" then uninstallAll()
	end repeat
end helperMenu

-- Fixer menu
on fixerMenu()
	repeat
		do shell script "clear; echo -e '\\033[34m╔═══════════════════════════════════════════╗\\n║           HYDROGEN FIXER MENU           ║\\n╚═══════════════════════════════════════════╝\\033[0m'"
		do shell script "echo -e '\\033[36m 1. System Requirements Check\\033[0m'"
		do shell script "echo -e '\\033[36m 2. Fix Sudden Close\\033[0m'"
		do shell script "echo -e '\\033[36m 3. Fix Roblox Architecture\\033[0m'"
		do shell script "echo -e '\\033[36m 4. Fix Port Binding\\033[0m'"
		do shell script "echo -e '\\033[36m 5. Password Prompt Fix\\033[0m'"
		do shell script "echo -e '\\033[36m 6. Back\\033[0m'"
		
		set choice to choose from list ¬
			{"System Requirements Check", "Fix Sudden Close", ¬
			 "Fix Roblox Architecture", "Fix Port Binding", ¬
			 "Password Prompt Fix", "Back"} ¬
			with title "Hydrogen Fixer" with prompt "Fixer Options:"
		if choice is false or item 1 of choice = "Back" then return
		set sel to item 1 of choice
		if sel = "System Requirements Check" then checkSysReq()
		if sel = "Fix Sudden Close" then fixSuddenClose()
		if sel = "Fix Roblox Architecture" then fixRobloxArch()
		if sel = "Fix Port Binding" then fixPortBinding()
		if sel = "Password Prompt Fix" then fixPasswordPrompt()
	end repeat
end fixerMenu

-- Main loop (close to exit)
repeat
	do shell script "clear; echo -e '\\033[34m╔═══════════════════════════════════════════╗\\n║              HYDROGEN MENU              ║\\n╚═══════════════════════════════════════════╝\\033[0m'"
	do shell script "echo -e '\\033[36m 1. Helper\\033[0m'"
	do shell script "echo -e '\\033[36m 2. Fixer\\033[0m'"
	
	set page to choose from list {"Helper", "Fixer"} with title "Hydrogen Menu - from my-oblilyum & inspiration from 109dg" with prompt "Select Page:"
	if page is false then exit repeat
	if item 1 of page = "Helper" then helperMenu()
	if item 1 of page = "Fixer" then fixerMenu()
end repeat

APPLESCRIPT

# Display exit message with animation
echo
animate_text "Thank you for using Hydrogen Helper!" "$GREEN"
echo
