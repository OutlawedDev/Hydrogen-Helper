#!/bin/bash

# ======= CONFIGURATION =======
VERSION="2.0"
THEME="cyberpunk" # Options: cyberpunk, neon, classic

# ======= COLORS AND FORMATTING =======
BOLD="\033[1m"
ITALIC="\033[3m"
UNDERLINE="\033[4m"
BLINK="\033[5m"
REVERSE="\033[7m"
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
BG_BLACK="\033[40m"
BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"
BG_BLUE="\033[44m"
BG_MAGENTA="\033[45m"
BG_CYAN="\033[46m"
BG_WHITE="\033[47m"
RESET="\033[0m"

# ======= THEME SETTINGS =======
if [ "$THEME" = "cyberpunk" ]; then
  PRIMARY=$CYAN
  SECONDARY=$MAGENTA
  ACCENT=$YELLOW
  HIGHLIGHT=$BG_BLUE$WHITE
  TITLE_COLOR=$BG_MAGENTA$WHITE$BOLD
  MENU_COLOR=$CYAN
  SUCCESS_COLOR=$GREEN
  ERROR_COLOR=$RED
  WARNING_COLOR=$YELLOW
  INFO_COLOR=$BLUE
elif [ "$THEME" = "neon" ]; then
  PRIMARY=$GREEN
  SECONDARY=$MAGENTA
  ACCENT=$CYAN
  HIGHLIGHT=$BG_GREEN$BLACK
  TITLE_COLOR=$BG_GREEN$BLACK$BOLD
  MENU_COLOR=$GREEN
  SUCCESS_COLOR=$GREEN
  ERROR_COLOR=$RED
  WARNING_COLOR=$YELLOW
  INFO_COLOR=$BLUE
else # classic
  PRIMARY=$BLUE
  SECONDARY=$CYAN
  ACCENT=$YELLOW
  HIGHLIGHT=$BG_BLUE$WHITE
  TITLE_COLOR=$BG_BLUE$WHITE$BOLD
  MENU_COLOR=$CYAN
  SUCCESS_COLOR=$GREEN
  ERROR_COLOR=$RED
  WARNING_COLOR=$YELLOW
  INFO_COLOR=$BLUE
fi

# ======= TERMINAL SIZE =======
TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput lines)

# ======= UTILITY FUNCTIONS =======

# Center text
center_text() {
  local text="$1"
  local width=${2:-$TERM_WIDTH}
  local padding=$(( (width - ${#text}) / 2 ))
  printf "%${padding}s%s%${padding}s\n" "" "$text" ""
}

# Create a box around text
box() {
  local text="$1"
  local color="${2:-$PRIMARY}"
  local width=${3:-$TERM_WIDTH}
  local padding=$(( (width - ${#text} - 4) / 2 ))
  
  echo -e "$color╔═$(printf '═%.0s' $(seq 1 $((width - 2))))═╗$RESET"
  echo -e "$color║ $(printf ' %.0s' $(seq 1 $padding))$text$(printf ' %.0s' $(seq 1 $padding)) ║$RESET"
  echo -e "$color╚═$(printf '═%.0s' $(seq 1 $((width - 2))))═╝$RESET"
}

# Create a horizontal line
hr() {
  local color="${1:-$PRIMARY}"
  local char="${2:-═}"
  echo -e "$color$(printf "$char%.0s" $(seq 1 $TERM_WIDTH))$RESET"
}

# Animated text typing
type_text() {
  local text="$1"
  local color="${2:-$PRIMARY}"
  local speed="${3:-0.02}"
  
  echo -ne "$color"
  for (( i=0; i<${#text}; i++ )); do
    echo -ne "${text:$i:1}"
    sleep $speed
  done
  echo -e "$RESET"
}

# Progress bar
progress_bar() {
  local message="$1"
  local color="${2:-$PRIMARY}"
  local duration="${3:-2}"
  local width=${4:-50}
  local bar_char="${5:-█}"
  local empty_char="${6:-░}"
  
  echo -ne "$color$message\n"
  for (( i=0; i<=width; i++ )); do
    local percent=$((i * 100 / width))
    local filled=$i
    local empty=$((width - filled))
    
    echo -ne "\r["
    echo -ne "$(printf "$bar_char%.0s" $(seq 1 $filled))"
    echo -ne "$(printf "$empty_char%.0s" $(seq 1 $empty))"
    echo -ne "] $percent%"
    
    sleep $(echo "$duration / $width" | bc -l)
  done
  echo -e "$RESET\n"
}

# Spinner animation
spinner() {
  local message="$1"
  local color="${2:-$PRIMARY}"
  local duration="${3:-2}"
  local pid=$!
  local spin='-\|/'
  local i=0
  
  echo -ne "$color$message "
  
  local start_time=$(date +%s)
  local end_time=$((start_time + duration))
  
  while [ $(date +%s) -lt $end_time ]; do
    echo -ne "\b${spin:i++%4:1}"
    sleep 0.1
  done
  
  echo -e "\b $RESET"
}

# Animated banner
animated_banner() {
  clear
  
  # Hydrogen ASCII Art
  local banner=(
    "██╗  ██╗██╗   ██╗██████╗ ██████╗  ██████╗  ██████╗ ███████╗███╗   ██╗"
    "██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔═══██╗██╔════╝ ██╔════╝████╗  ██║"
    "███████║ ╚████╔╝ ██║  ██║██████╔╝██║   ██║██║  ███╗█████╗  ██╔██╗ ██║"
    "██╔══██║  ╚██╔╝  ██║  ██║██╔══██╗██║   ██║██║   ██║██╔══╝  ██║╚██╗██║"
    "██║  ██║   ██║   ██████╔╝██║  ██║╚██████╔╝╚██████╔╝███████╗██║ ╚████║"
    "╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝"
  )
  
  # Frame animation
  echo -e "$PRIMARY"
  
  # Top border animation
  echo -ne "╔"
  for (( i=0; i<$((TERM_WIDTH-2)); i++ )); do
    echo -ne "═"
    sleep 0.002
  done
  echo -e "╗"
  
  # Side borders with space for banner
  for (( i=0; i<2; i++ )); do
    echo -e "║$(printf ' %.0s' $(seq 1 $((TERM_WIDTH-2))))║"
    sleep 0.01
  done
  
  # Display banner with animation
  for line in "${banner[@]}"; do
    local padding=$(( (TERM_WIDTH - ${#line} - 2) / 2 ))
    echo -ne "║$(printf ' %.0s' $(seq 1 $padding))"
    
    # Animate each character with color transition
    for (( i=0; i<${#line}; i++ )); do
      if (( i % 3 == 0 )); then
        echo -ne "$PRIMARY"
      elif (( i % 3 == 1 )); then
        echo -ne "$SECONDARY"
      else
        echo -ne "$ACCENT"
      fi
      echo -ne "${line:$i:1}"
      sleep 0.001
    done
    
    echo -e "$PRIMARY$(printf ' %.0s' $(seq 1 $padding))║"
    sleep 0.05
  done
  
  # Side borders with space for banner
  for (( i=0; i<2; i++ )); do
    echo -e "║$(printf ' %.0s' $(seq 1 $((TERM_WIDTH-2))))║"
    sleep 0.01
  done
  
  # Bottom border animation
  echo -ne "╚"
  for (( i=0; i<$((TERM_WIDTH-2)); i++ )); do
    echo -ne "═"
    sleep 0.002
  done
  echo -e "╝$RESET"
  
  # Display version and credits with typing effect
  center_text " " 
  type_text "$(center_text "Hydrogen Helper Utility v$VERSION")" "$SUCCESS_COLOR$BOLD" 0.01
  type_text "$(center_text "from my-oblilyum & 109dg")" "$WARNING_COLOR" 0.01
  center_text " "
}

# Interactive menu
interactive_menu() {
  local title="$1"
  shift
  local options=("$@")
  local selected=0
  local key
  
  while true; do
    clear
    box "$title" "$TITLE_COLOR" $((TERM_WIDTH - 10))
    echo
    
    for (( i=0; i<${#options[@]}; i++ )); do
      if [ $i -eq $selected ]; then
        echo -e "   $HIGHLIGHT ${options[$i]} $RESET"
      else
        echo -e "   $MENU_COLOR ${options[$i]} $RESET"
      fi
    done
    
    echo
    echo -e "$INFO_COLOR Use arrow keys to navigate and Enter to select $RESET"
    
    # Read a single key press
    read -s -n 1 key
    
    # Handle arrow keys
    if [[ $key == $'\e' ]]; then
      read -s -n 1 key
      if [[ $key == '[' ]]; then
        read -s -n 1 key
        if [[ $key == 'A' ]]; then # Up arrow
          (( selected-- ))
          if [ $selected -lt 0 ]; then
            selected=$((${#options[@]} - 1))
          fi
        elif [[ $key == 'B' ]]; then # Down arrow
          (( selected++ ))
          if [ $selected -ge ${#options[@]} ]; then
            selected=0
          fi
        fi
      fi
    elif [[ $key == '' ]]; then # Enter key
      return $selected
    fi
  done
}

# Notification toast
show_toast() {
  local message="$1"
  local color="${2:-$SUCCESS_COLOR}"
  local duration="${3:-2}"
  
  # Save cursor position
  tput sc
  
  # Move to bottom of screen
  tput cup $((TERM_HEIGHT - 3)) 0
  
  # Display toast
  local padding=$(( (TERM_WIDTH - ${#message} - 4) / 2 ))
  echo -e "$color╭─$(printf '─%.0s' $(seq 1 $((TERM_WIDTH - 2))))─╮$RESET"
  echo -e "$color│ $(printf ' %.0s' $(seq 1 $padding))$message$(printf ' %.0s' $(seq 1 $padding)) │$RESET"
  echo -e "$color╰─$(printf '─%.0s' $(seq 1 $((TERM_WIDTH - 2))))─╯$RESET"
  
  # Wait for duration
  sleep $duration
  
  # Clear toast
  tput cup $((TERM_HEIGHT - 3)) 0
  echo -e "$(printf ' %.0s' $(seq 1 $TERM_WIDTH))"
  echo -e "$(printf ' %.0s' $(seq 1 $TERM_WIDTH))"
  echo -e "$(printf ' %.0s' $(seq 1 $TERM_WIDTH))"
  
  # Restore cursor position
  tput rc
}

# Confirmation dialog
confirm_dialog() {
  local message="$1"
  local color="${2:-$WARNING_COLOR}"
  
  echo
  echo -e "$color$message$RESET"
  echo -e "${INFO_COLOR}Press Y to confirm or any other key to cancel$RESET"
  
  read -s -n 1 key
  if [[ $key == 'y' || $key == 'Y' ]]; then
    return 0
  else
    return 1
  fi
}

# ======= MAIN SCRIPT =======

# Check for terminal size
if [ $TERM_WIDTH -lt 80 ] || [ $TERM_HEIGHT -lt 24 ]; then
  echo -e "${ERROR_COLOR}Terminal window too small. Please resize to at least 80x24.$RESET"
  exit 1
fi

# Check for sudo access
check_sudo() {
  echo -e "${WARNING_COLOR}Checking for administrative privileges...$RESET"
  if sudo -v; then
    show_toast "Admin access confirmed" "$SUCCESS_COLOR" 1
    sleep 1
  else
    show_toast "Admin access required but not granted" "$ERROR_COLOR" 2
    echo -e "${ERROR_COLOR}Please run this script again with admin privileges$RESET"
    exit 1
  fi
}

# Display animated banner
animated_banner

# Check for sudo access
check_sudo

# Main menu options
main_options=("Helper" "Fixer" "Settings" "Exit")
helper_options=("Open Roblox" "Clear Roblox Cache" "Reinstall Roblox (will reinstall Hydrogen)" "Install Hydrogen‑M" "Uninstall All" "Back")
fixer_options=("System Requirements Check" "Fix Sudden Close" "Fix Roblox Architecture" "Fix Port Binding" "Password Prompt Fix" "Back")
settings_options=("Change Theme" "Toggle Animations" "About" "Back")

# Main loop
while true; do
  interactive_menu "HYDROGEN MENU" "${main_options[@]}"
  main_choice=$?
  
  case $main_choice in
    0) # Helper
      while true; do
        interactive_menu "HYDROGEN HELPER" "${helper_options[@]}"
        helper_choice=$?
        
        case $helper_choice in
          0) # Open Roblox
            progress_bar "Launching Roblox..." "$INFO_COLOR" 1
            show_toast "Roblox launched successfully!" "$SUCCESS_COLOR" 2
            ;;
          1) # Clear Cache
            if confirm_dialog "Are you sure you want to clear the Roblox cache?"; then
              progress_bar "Clearing Roblox cache..." "$WARNING_COLOR" 3
              show_toast "Roblox cache cleared successfully!" "$SUCCESS_COLOR" 2
            fi
            ;;
          2) # Reinstall
            if confirm_dialog "This will reinstall both Roblox and Hydrogen. Continue?"; then
              progress_bar "Uninstalling Roblox and Hydrogen..." "$WARNING_COLOR" 3
              progress_bar "Installing Hydrogen..." "$INFO_COLOR" 3
              show_toast "Reinstallation complete!" "$SUCCESS_COLOR" 2
            fi
            ;;
          3) # Install Hydrogen
            if confirm_dialog "Ready to install Hydrogen-M?"; then
              progress_bar "Installing Hydrogen-M..." "$INFO_COLOR" 3
              show_toast "Hydrogen-M installed successfully!" "$SUCCESS_COLOR" 2
            fi
            ;;
          4) # Uninstall All
            if confirm_dialog "This will remove Roblox and Hydrogen-M from your system. Continue?"; then
              progress_bar "Uninstalling Roblox and Hydrogen-M..." "$WARNING_COLOR" 3
              show_toast "Uninstallation complete!" "$SUCCESS_COLOR" 2
            fi
            ;;
          5) # Back
            break
            ;;
        esac
      done
      ;;
      
    1) # Fixer
      while true; do
        interactive_menu "HYDROGEN FIXER" "${fixer_options[@]}"
        fixer_choice=$?
        
        case $fixer_choice in
          0) # System Requirements
            progress_bar "Checking system requirements..." "$INFO_COLOR" 2
            show_toast "System meets all requirements!" "$SUCCESS_COLOR" 2
            ;;
          1) # Fix Sudden Close
            type_text "Fix if Hydrogen‑M closes suddenly:" "$WARNING_COLOR" 0.01
            type_text "1) Redownload Hydrogen and open it." "$INFO_COLOR" 0.01
            type_text "2) Open Roblox, let it fully load." "$INFO_COLOR" 0.01
            type_text "3) Restart your Mac if needed." "$INFO_COLOR" 0.01
            echo
            echo -e "${INFO_COLOR}Press any key to continue$RESET"
            read -s -n 1
            ;;
          2) # Fix Architecture
            progress_bar "Checking Roblox architecture..." "$INFO_COLOR" 2
            show_toast "Roblox architecture is OK" "$SUCCESS_COLOR" 2
            ;;
          3) # Fix Port Binding
            progress_bar "Checking port binding..." "$INFO_COLOR" 2
            progress_bar "Verifying ports 6969-7069..." "$INFO_COLOR" 2
            show_toast "Ports 6969–7069 are active. Hydrogen‑M is loaded." "$SUCCESS_COLOR" 2
            ;;
          4) # Password Prompt
            type_text "If password prompt is hidden, type your password and press Enter." "$INFO_COLOR" 0.01
            echo
            echo -e "${INFO_COLOR}Press any key to continue$RESET"
            read -s -n 1
            ;;
          5) # Back
            break
            ;;
        esac
      done
      ;;
      
    2) # Settings
      while true; do
        interactive_menu "SETTINGS" "${settings_options[@]}"
        settings_choice=$?
        
        case $settings_choice in
          0) # Change Theme
            theme_options=("Cyberpunk" "Neon" "Classic" "Back")
            interactive_menu "SELECT THEME" "${theme_options[@]}"
            theme_choice=$?
            
            case $theme_choice in
              0) THEME="cyberpunk"; show_toast "Theme changed to Cyberpunk" "$SUCCESS_COLOR" 1;;
              1) THEME="neon"; show_toast "Theme changed to Neon" "$SUCCESS_COLOR" 1;;
              2) THEME="classic"; show_toast "Theme changed to Classic" "$SUCCESS_COLOR" 1;;
              3) ;;
            esac
            
            # Update theme settings
            if [ "$THEME" = "cyberpunk" ]; then
              PRIMARY=$CYAN
              SECONDARY=$MAGENTA
              ACCENT=$YELLOW
              HIGHLIGHT=$BG_BLUE$WHITE
              TITLE_COLOR=$BG_MAGENTA$WHITE$BOLD
              MENU_COLOR=$CYAN
              SUCCESS_COLOR=$GREEN
              ERROR_COLOR=$RED
              WARNING_COLOR=$YELLOW
              INFO_COLOR=$BLUE
            elif [ "$THEME" = "neon" ]; then
              PRIMARY=$GREEN
              SECONDARY=$MAGENTA
              ACCENT=$CYAN
              HIGHLIGHT=$BG_GREEN$BLACK
              TITLE_COLOR=$BG_GREEN$BLACK$BOLD
              MENU_COLOR=$GREEN
              SUCCESS_COLOR=$GREEN
              ERROR_COLOR=$RED
              WARNING_COLOR=$YELLOW
              INFO_COLOR=$BLUE
            else # classic
              PRIMARY=$BLUE
              SECONDARY=$CYAN
              ACCENT=$YELLOW
              HIGHLIGHT=$BG_BLUE$WHITE
              TITLE_COLOR=$BG_BLUE$WHITE$BOLD
              MENU_COLOR=$CYAN
              SUCCESS_COLOR=$GREEN
              ERROR_COLOR=$RED
              WARNING_COLOR=$YELLOW
              INFO_COLOR=$BLUE
            fi
            ;;
          1) # Toggle Animations
            show_toast "Animation settings updated" "$SUCCESS_COLOR" 1
            ;;
          2) # About
            clear
            box "ABOUT HYDROGEN HELPER" "$TITLE_COLOR" $((TERM_WIDTH - 10))
            echo
            type_text "Hydrogen Helper v$VERSION" "$PRIMARY$BOLD" 0.01
            type_text "Created by my-oblilyum & 109dg" "$SECONDARY" 0.01
            type_text "Enhanced UI by v0" "$SECONDARY" 0.01
            echo
            type_text "This utility helps manage Roblox and Hydrogen-M on macOS systems." "$INFO_COLOR" 0.01
            echo
            echo -e "${INFO_COLOR}Press any key to continue$RESET"
            read -s -n 1
            ;;
          3) # Back
            break
            ;;
        esac
      done
      ;;
      
    3) # Exit
      clear
      type_text "Thank you for using Hydrogen Helper!" "$SUCCESS_COLOR$BOLD" 0.02
      echo
      exit 0
      ;;
  esac
done

# This script is a standalone bash UI that simulates the functionality
# To integrate with the actual AppleScript, you would need to modify the
# case statements to call the appropriate AppleScript functions
