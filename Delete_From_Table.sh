#!/usr/bin/bash
# --------------------------------------------------------------------------------------------------------------
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
# ----------------------------------------------------------------------------------------------------------------------#
select_from_connect_options () {
    echo -e "${bg_magenta}Please re-choose number from the following list${clear}"
    echo -e "${cyan}1) list table ${clear}"
	echo -e "${cyan}2) create table ${clear}"
    echo -e "${cyan}3) drop table ${clear}"
    echo -e "${cyan}4) insert into table ${clear}"
    echo -e "${cyan}5) select from table${clear}"
    echo -e "${cyan}6) delete from table ${clear}"
    echo -e "${cyan}7) update table ${clear}"
    echo -e "${cyan}8) Exit ${clear}"
}
rechoose_delete_from_options () {
    echo -e "${bg_magenta}Please re-choose number from the following list${clear}"
    echo -e "${cyan}1) delete all data ${clear}"
	echo -e "${cyan}2) delete a row${clear}"
    echo -e "${cyan}3) delete specific value ${clear}"
    echo -e "${cyan}4) delete column data ${clear}"
    echo -e "${cyan}5) Cancel ${clear}"
}

rechoose_delete_byrow_options () {
    echo -e "${bg_magenta}Please re-choose number from the following list${clear}"
    echo -e "${cyan}1) Delete row by Primary Key ${clear}"
	echo -e "${cyan}2) Delete by row number${clear}"
    echo -e "${cyan}3) Delete rows in range ${clear}"
    echo -e "${cyan}4) Cancel ${clear}"
}

rechoose_delete_bycol_options () {
    echo -e "${bg_magenta}Please re-choose number from the following list${clear}"
    echo -e "${cyan}1) Delete single column ${clear}"
    echo -e "${cyan}2) Cancel ${clear}"
}



# --------------------------------------------------SUB-FUNCTIONS--------------------------------------------------------#

#-------------------------------Checking Before Deleting--------------------------
check_before_delete_all (){
    shopt -s extglob
    #export LC_COLLATE=c
    echo -e "${red} Are you Sure you want to delete this content (y/n) :${clear}"
    read 
    case $REPLY in 
        +([Yy|Yes|YES|yEs|YeS|yES|yeS]) ) 
            sed -i d $1
            echo -e "${bg_yellow}* Succesfully Done ${clear}"
            rechoose_delete_from_options 
        ;;
        +([Nn|No|NO|nO]) )
            echo -e "${yellow}* Step Canceled ${clear}"
            rechoose_delete_from_options
        ;;
        * )
            echo -e "${red}*Wrong Entery${clear}"
            check_before_delete_all
    esac
}
#---------------------------------------------------------------------------------

# ------------------------------Delete ALL DATA FROM A TABLE----------------------------------------------------------#
delete_all_fun (){
    read -p "Enter the table name : " tballname
    shopt -s extglob
    while true
    do
        if [[ -e $tballname && `cat $tballname` != "" ]];then
            echo -e "${bg_yellow} ${tballname} Table Contents:${clear}"
            #cat ${tballname}
            column -s ":" -t  ${tballname}
            check_before_delete_all "$tballname"
            break
        elif [[ -e $tballname && `cat $tballname` == "" ]];then   
            echo -e "${bg_red}**Your table is EMPTY**${clear}"
            rechoose_delete_from_options
            break
        elif [[ $tballname = "exit" ]];then
            rechoose_delete_from_options 
            break
        else
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            echo -e "${red} * $tballname not found .${clear}"   
            echo -e "${red} * Please Enter Table Name again .${clear}"          
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            delete_all_fun
            break
        fi
    done
}

# --------------------------------Delete A Row INISDE THE TABLE---------------------------------------------------#
# ----------SUB FUNCTION :CHECKING USING PRIMARY KEY-------#
check_before_delete_pk(){
    shopt -s extglob 
    echo -e "${red} Are you Sure you want to delete this content (y/n) :${clear}"
    read 
    case $REPLY in 
        +([Yy|Yes|YES|yEs|YeS|yES|yeS]) ) 
            awk -v X="$2" -i inplace 'BEGIN{FS=":"}{if($1 != X){print $0}}END{}' $1
            echo -e "${bg_yellow}* Succesfully Done ${clear}" 
            rechoose_delete_byrow_options
        ;;
        +([Nn|No|NO|nO]) )
            echo -e "${yellow}* Step Canceled ${clear}"
            rechoose_delete_byrow_options
        ;;
        * )
            echo -e "${red}*Wrong Entery${clear}"
            rechoose_delete_byrow_options
            check_before_delete_pk
    esac
}

# ----------SUB FUNCTION :DELETE A ROW USING PRIMARY KEY-------#
delete_by_pk () {
    echo -e "${bg_red} Hint: If you want to go back enter (exit)..${clear}"
    read -p "Enter Primary Key Value : " pkvalue
    while true
    do
        if [[ `cut -d : -f1 $tbname | grep "$pkvalue"` -ne \0 ]];then
            echo -e "${bg_yellow}The row of $pkvalue Primary Key Value: ${clear}"
            awk -v X="$pkvalue" 'BEGIN{FS=":"}{if ($1==X){print NR,$0}} END{}' $PWD/$tbname
            check_before_delete_pk "$1" "$pkvalue"
            break
        elif [[ $pkvalue = "exit" ]];then
            rechoose_delete_from_options 
            break
        else 
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            echo -e "${red} * $pkvalue not found .${clear}"   
            echo -e "${red} * Please Enter Primary Key value again.${clear}"          
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            delete_by_pk
            break
        fi
    done
}

# ----------SUB FUNCTION :CHECKING USING ROW NUMBER -----------#
check_before_delete_row_number(){
    shopt -s extglob 
    echo -e "${red} Are you Sure you want to delete this content (y/n) :${clear}"
    read 
    case $REPLY in 
        +([Yy|Yes|YES|yEs|YeS|yES|yeS]) ) 
            sed -i ''$2'd' $PWD/$1
            echo -e "${bg_yellow}*Deleting Succesfully Done ${clear}" 
            rechoose_delete_byrow_options
        ;;
        +([Nn|No|NO|nO]) )
            echo -e "${yellow}*Deleting Step Canceled ${clear}"
            rechoose_delete_byrow_options
        ;;
        * )
            echo -e "${red}*Wrong Entery${clear}"
            rechoose_delete_byrow_options
            check_before_delete_row_number
    esac
}

# ----------SUB FUNCTION :DELETE A ROW USING IT'S NUMBER-------#
delete_row_number () {
    read -p "Enter the number of row you want to delete : " rwnumber 
    echo -e "${bg_red} Hint: If you want to go back enter (exit)...${clear}"
    case $rwnumber in 
    +([0-99]) )
        echo -e "${bg_yellow}The content of the row number you entered($rwnumber): ${clear}"
        cat $PWD/$tbname | sed -n ''$rwnumber'p'
        check_before_delete_row_number "$1" "$rwnumber"
    ;;
    "exit" )
        rechoose_delete_from_options 
    ;;
    * )
        echo -e "${yellow}--------------------------------------------------------------------${clear}"
        echo -e "${red} * Your entery is not a number.${clear}"   
        echo -e "${yellow}--------------------------------------------------------------------${clear}"
        delete_row_number
    esac
}
# ----------SUB FUNCTION :CHECKING USING ROW IN RANGE------#
check_before_delete_row_inrange (){
    shopt -s extglob 
    echo -e "${red} Are you Sure you want to delete this content (y/n) :${clear}"
    read 
    case $REPLY in 
        +([Yy|Yes|YES|yEs|YeS|yES|yeS]) ) 
            sed -i ''$2','$3'd' $PWD/$1
            echo -e "${bg_yellow}*Deleting Succesfully Done ${clear}" 
            rechoose_delete_byrow_options
        ;;
        +([Nn|No|NO|nO]) )
            echo -e "${yellow}*Deleting Step Canceled ${clear}"
            rechoose_delete_byrow_options
        ;;
        * )
            echo -e "${red}*Wrong Entery${clear}"
            rechoose_delete_byrow_options
            check_before_delete_row_inrange
    esac
}
# ----------SUB FUNCTION :DELETE A ROW IN RANGE-------#
delete_in_range (){
    read -p "Please enter start point(row number): " startpoint
    case $startpoint in     
        +([1-99999]) )
            read -p "please enter end point(row number): " endpoint
            case $endpoint in 
                +([1-99999]) )
                    if [[ "$startpoint" -lt "$endpoint" ]];then
                        echo -e "${bg_yellow}The content of the rows numbers you entered($startpoint):($endpoint): ${clear}"
                        echo -e "${BOLD}`awk -vx="$startpoint" -vy="$endpoint"  'NR>=x && NR<=y {print}' $1`${clear}"
                        check_before_delete_row_inrange "$1" "$startpoint" "$endpoint"
                    else
                        echo -e "${yellow}--------------------------------------------------------------------${clear}"
                        echo -e "${red} * End Point should not be smaller than Start Point.${clear}"   
                        echo -e "${yellow}--------------------------------------------------------------------${clear}"
                        rechoose_delete_byrow_options
                    fi
                ;;
                "exit" )
                    delete_by_row_fun   
                ;;
                * )
                echo -e "${yellow}--------------------------------------------------------------------${clear}"
                echo -e "${red} * Your entery is Wrong.${clear}"   
                echo -e "${yellow}--------------------------------------------------------------------${clear}"
                delete_by_row_fun
            esac
        ;;
        [0] )
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            echo -e "${red} * Your entery is should not be Zero.${clear}"   
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            delete_by_row_fun
        ;;
        "exit" )
            break
            delete_by_row_fun 
        ;;
        *)
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            echo -e "${red} * Your entery is Wrong.${clear}"   
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            delete_by_row_fun
    esac
}



# ----------MAIN FUNCTION:DELETE A ROW INSIDE THE TABLE-------#
delete_by_row_fun () {
    read -p "Enter the table name : " tbname
    shopt -s extglob
    while true
    do
        if [[ -e $tbname && `cat $tbname` != "" ]];then
            echo -e "${yellow} Metadata of the table :${clear}"
            echo -e "${blue}`sed -n '1,3p' $tbname`${clear}"
            select numrow in "Delete row by Primary Key" "Delete by row number" "Delete rows in range" "Cancel"
            do 
                echo -e "${bg_cyan}$numrow${clear}"
                case $numrow in 
                "Delete row by Primary Key" )
                    delete_by_pk "$tbname"
                ;;
                "Delete by row number" )
                    delete_row_number "$tbname"
                ;;
                "Delete rows in range" )
                    delete_in_range "$tbname"
                ;;  
                "Cancel" )
                    delete_from_fun
                    break
                esac
            done
        elif [[ -e $tbname && `cat $tbname` = "" ]];then
            echo -e "${bg_red}**Your table is EMPTY**${clear}"
            rechoose_delete_from_options
            break
        elif [[ $tbname == "exit" ]];then
            rechoose_delete_from_options 
            break
        else
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            echo -e "${red} * $tbname not found .${clear}"   
            echo -e "${red} * Please Enter Table Name again .${clear}"          
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            delete_by_row_fun
            break
        fi
    done
}
# ----------MAIN FUNCTION:DELETE A ROW INSIDE THE TABLE-------# ---------ENDED
#--------------------------------------------------------------------------------------#

# (1/1)----------SUB FUNCTION :SELECTION OF SPEC--VALUE ------#
select_spec_value(){
    read -p "Enter the value to be deleted : " specvalue
    if [[ `grep "$specvalue" $1` != \0 ]];then
        echo -e "${yellow}Rows That Contains Selected Value : ${clear}"
        echo -e "${magenta}`grep "$specvalue" $1`${clear}"
        read -p "Enter Primary Key Value  : " specpkvalue
        if [[ `cut -d : -f1 $1 | grep "$specpkvalue"` == "" ]];then
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            echo -e "${red} * Your entery is not Exist.${clear}"   
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            delete_by_spec_val
        else
            grep -rl "$specpkvalue" $1 | xargs sed -i 's/'$specvalue'//'
            rechoose_delete_from_options
        fi
    else 
        echo -e "${yellow}--------------------------------------------------------------------${clear}"
        echo -e "${red} * Your entery is not Exist.${clear}"   
        echo -e "${yellow}--------------------------------------------------------------------${clear}"
        select_spec_value
    fi
}
#------------------MAIN FUNCTION : DELETE A SPECIFIC VALUE ---------#
delete_by_spec_val () {
    echo -e "${bg_red} Hint: If you want to go back enter (exit)..${clear}"
    read -p "Enter the table name : " spectbname
    shopt -s extglob
    if [[ -e $spectbname ]];then
        echo -e "${yellow} Metadata of the table :${clear}"
        echo -e "${blue}`sed -n '1,3p' $spectbname`${clear}"
        select_spec_value "$spectbname"
    elif [[ $spectbname = "exit" ]];then
        rechoose_delete_from_options
    else
        echo -e "${yellow}--------------------------------------------------------------------${clear}"
        echo -e "${red} * Your entery table is not Exist.${clear}"   
        echo -e "${yellow}--------------------------------------------------------------------${clear}"
        delete_by_spec_val
    fi
}
# ----------MAIN FUNCTION:DELETE A SPECIFIC VALUE-------# ---------ENDED
#--------------------------------------------------------------------------------------#
# (1/3)----------SUB FUNCTION :CHECKING USING ROW IN RANGE------#
check_before_delete_col (){
    shopt -s extglob 
    echo -e "${red} Are you Sure you want to delete this content (y/n) :${clear}"
    read    
    case $REPLY in 
        +([Yy|Yes|YES|yEs|YeS|yES|yeS]) )
            echo -e "${yellow}-------------------${clear}" 
            
            # awk -F : -vNU="$1" -i inplace '!/{print "$"NU}/' $2
            #awk -vX="$1" -i inplace 'BEGIN{FS=":"}{if('$'X!=""){print ''}}END{}' $2
            #cut -d : -f$1 $2 | sed -eir 's/+//g' 
            # awk -vX="$1" -F ":" -i inplace '{$0=gensub(/\s*\S+/,"",X)}1' $2
            echo -e "${bg_yellow}*Deleting Succesfully Done ${clear}" 
            rechoose_delete_bycol_options
        ;;
        +([Nn|No|NO|nO]) )
            echo -e "${yellow}*Deleting Step Canceled ${clear}"
            check_before_delete_col
        ;;
        * )
            echo -e "${red}*Wrong Entery${clear}"
            check_before_delete_row_inrange
    esac
}
# (2/3) ----------SUB FUNCTION :CHEHCK.COL.CONSTRAINTS---------#
check_col_constraints_fun (){
    case $1 in 
        +([1-99999]) )
            columns=$(awk 'BEGIN{FS=":"}{while(i<1){print NF; i++;}}END{}' $2)
            if [[ "$1" -le "$columns" ]];then
                echo -e "${bg_yellow}The content of column ($1) : ${clear}"
                cut -d : -f$1 $2  
                check_before_delete_col "$1" "$2"
            else
                echo -e "${yellow}--------------------------------------------------------------------${clear}"
                echo -e "${red} * Your entery is not Exist.${clear}"   
                echo -e "${yellow}--------------------------------------------------------------------${clear}"
                delete_a_col
            fi
        ;;
        [0] ) 
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            echo -e "${red} * Your entery is should not be Zero.${clear}"   
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            delete_a_col
        ;;
        *)
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            echo -e "${red} * Your entery is not number.${clear}"   
            echo -e "${yellow}--------------------------------------------------------------------${clear}"
            rechoose_delete_bycol_options
        esac
}
#--(3/3) ----------SELECT-COL-NUM ---------#
select_col_num (){ 
    select coloption in "select single-column" "cancel"
    do
        echo -e "${bg_cyan}$coloption${clear}" 
        case $coloption in 
            "select single-column" )
                read -p "Enter column number : " colnumber
                check_col_constraints_fun "$colnumber" "$1"
            ;;
            "cancel" )
                rechoose_delete_from_options
                break
            ;;
            *)
                echo -e "${yellow}--------------------------------------------------------------------${clear}"
                echo -e "${red} * Your entery is Wrong.${clear}"   
                echo -e "${yellow}--------------------------------------------------------------------${clear}"
                select_col_num 
        esac
    done
}
#------------------MAIN FUNCTION : DELETE COLUMN ---------#
delete_a_col (){
    echo -e "${bg_red} Hint: If you want to go back enter (exit)..${clear}"
    read -p "Enter the table name : " coltbname
    shopt -s extglob
    if [[ -e $coltbname ]];then
        echo -e "${yellow} Metadata of the table :${clear}"
        echo -e "${blue}`sed -n '1,$d p' $coltbname`${clear}"
        select_col_num "$coltbname"
    elif [[ $coltbname = "exit" ]];then
        delete_from_fun
    else
        echo -e "${yellow}--------------------------------------------------------------------${clear}"
        echo -e "${red} * Your entery table is not Exist.${clear}"   
        echo -e "${yellow}--------------------------------------------------------------------${clear}"
        delete_a_col
    fi
}   
#-------------------------------------------DELETE_FROM------------------------------------------------------------#
delete_from_fun (){
    echo -e "${bg_red}Hint : choose a number from the following list :${clear}"
    select selection in "delete all data" "delete a row" "delete specific value" "delete column data" "Cancel"
    do
        echo -e "${green} $selection ${clear}"
        case $selection in 
            "delete all data" )
               delete_all_fun
            ;;
            "delete a row" )
                delete_by_row_fun
            ;;
            "delete specific value" )
                delete_by_spec_val
            ;;
            "delete column data" )
                delete_a_col
            ;;   
            "Cancel" )  
                select_from_connect_options
                break
        esac
    done
}
delete_from_fun



# awk -vX="$1" -F : '{print $"X"}' $2
#awk -F : -vNU="$1" -i inplace '!/{print "$"NU}/' $2
# cut -d : -f$1 $2 | sed -i -r 's/\S+//3' 
#awk -v NU="$1" -F : -i inplace '{$0=gensub(/\s*\S+/,"",NU)}1' file
# awk -vX="$1" -i inplace '{$0=gensub(/\s*\S+$/,"",X)}1' $2
# awk -vX="$1" -F : -i inplace '{$0=gensub(/\s*\S+/,"",X)}1' $2
#awk -vX="$1" '!("$"X="")' $2
####################################awk -vX="$1" -i inplace 'BEGIN{FS=":"}{if('$'X!=""){print ''}}END{}' $2  
# sed -i 's/*/""/g' $2  
# #cut -d : -f"$1" $2 |