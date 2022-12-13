#!/usr/bin/bash


# --------------------------------------------------------------------------------------------------------------
#change color to blue before printing
# Color variables
BOLD="\033[1m"
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
# Clear the color after that
clear='\033[0m'
# Background Color variables
bg_red='\033[0;41m'
bg_green='\033[0;42m'
bg_yellow='\033[0;43m'
bg_blue='\033[0;44m'
bg_magenta='\033[0;45m'
bg_cyan='\033[0;46m'
# --------------------------------------------------------------------------------------------------------------
#Printing Welcomming
source Logo
#Printing Hints
echo ""
echo -e "${green}Hint -- Our Datbase Engine works on HADatabase Directory By Default${clear}"
echo ""

#Go to Directory of Databases
direction=""
if [[ -e "HADatabase" ]]; then
	direction="HADatabase"
else
	mkdir $PWD/HADatabase
	direction="HADatabase"
fi
cd $PWD/$direction

#Listing Database Options 
database-options() {
echo -e "${green}Hint : Choose only Number from the following list${clear}"
select choice in "Create Database" "List Database" "Drop Database" "Connect Database" "Quit"
   do
	echo -e "${green}$choice ${clear}"
	case $choice in 
		"Create Database" )
            createdb
			#Part 1-1 #--running create Database script--#
		;;
		"List Database" )
            listdb
			#Part 1-2 #--running Listing Database script--#
		;;
		"Drop Database" )
            source Drop_DB
			#Part 1-3 #--running Dropping Database script--#
		;;
		"Connect Database" )
            source Connect_DB
			#Part 1-4 #--running Connecting Database script--#	
		;;
        "Quit" )
            exit
        ;;
		* )
			## add condition to make user loop if his choice is wrong##
			echo -e "${red}Entered Choice is not available${clear}"
            database-options
	esac
   done 
}
database-options
