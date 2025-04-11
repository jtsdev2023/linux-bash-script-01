#!/usr/bin/bash


declare_variables(){
    bold=$(tput bold)
    normal=${normal}
    BLACK=$(tput setaf 0)
    RED=$(tput setaf 1)
    GREEN=${GREEN}
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)
}


customWriteOutput(){
    echo "${GREEN}"
    echo "$1"
    echo "${normal}"
}


customUpdateRepositories(){
    # """
    # function to update package manager repositories
    # """

    customWriteOutput "Updating ATP repository..."
    apt-get update
}


customInstallPackage(){
    # """
    # function to install packages
    # uses \\$\@ to accept unspecified number of input parameters
    # """

    while [ $# -gt 0 ]; do
        customWriteOutput "Please wait while package '$1' is installed..."
        apt-get install -y $1
        sleep 1
        customWriteOutput "Package '$1' was successfully installed."
        # shift to next variable
        # e.g., moves $2 to $1 and $3 to $2 etc.
        shift
    done
}


customWriteToFile(){
    # """
    # function to write string to file
    # expect the first input argument to be the file name
    # and the second input argument to be the text string
    # """

    printf '%s\n' "$2" >> "$1"

    sleep 1

    printf '\n%s\n\n' \
        "${GREEN}text '$2' written to file${normal}"
}


customAddUser(){
    # """
    # function to add user
    # """

    # get username
    printf '\n%s' "${GREEN}Enter Username: ${normal}"
    read varUsername
    printf '\n'

    # add user
    useradd $varUsername

    printf '\n%s\n\n' "${GREEN}User '$varUsername' added."
}


customGetPassword(){
    # """
    # function to set user password
    # accepts a username as input argument
    # """

    # get password
    printf '\n%s' "${GREEN}Enter Password: ${normal}"
    read -s varPassword
    printf '\n'

    # set password
    expect <<EOF
        spawn passwd "$1"
        expect "New password:"
        send "$varPassword\r"
        expect "Retype new password:"
        send "$varPassword\r"
        expect eof
EOF

    # check that command finished
    if [ $? -eq 0 ]; then
        printf '\n%s\n\n' "${GREEN}Password set for user '$1'.${normal}"
    else
        printf '\n%s' \
        "Failed to set password." >&2
        return 1
    fi
}


# main
# call functions

declare_variables

customUpdateRepositories

customInstallPackage expect

customWriteToFile test.txt "this is a test"

customAddUser test01

customGetPassword test01
