#!/bin/bash

TEMPLATE_DIR="template"
PROJECT_NAME="attendance_tracker"

if [ -d "$TEMPLATE_DIR"]; then
    echo "The source code for the student attandance tracker project is missing"
    exit
fi

archive_continue() {}

init_system() {
    clear
    
    read -p "Enter the variation of this project: " PROJ_VARIATION

    WORKSPACE="${PROJECT_NAME}_${PROJ_VARIATION}"
    
    if [ -d "$WORKSPACE" ]; then
        read -p "This workspace  $WORKSPACE already exists. Do you want to overwrite it? [Y / N]"
        archive_continue PROJ_VARIATION
    else
	echo " Starting to create a new workspace => $WORKSPACE ......"

	
    fi
}
