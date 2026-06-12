#!/bin/bash

TEMPLATE_DIR="template"
PROJECT_NAME="attendance_tracker"

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "The source code for the student attandance tracker project is missing"
    exit
fi

overwrite_workspace() {
    echo "archiving start for the workspace: $WORKSPACE"
}

environment_checkup() {
	echo "Starting Environement checkup..."
	echo ""

    if command -v python3 &> /dev/null; then
        echo "[OK] Python 3 is installed. Version: $(python3 --version)"
    else
        echo "[WARNING] Python 3 is not installed. Please install Python 3 to run this generated workspace."
    fi

	echo ""
	echo "Verifying workspace directory structure ..."
	echo ""

	required_paths=(
		"$WORKSPACE|The workspace($WORKSPACE) has not been created|directory"
		"$WORKSPACE/attendance_checker.py|The main python file (attendance_checker.py) is missing|file"
		"$WORKSPACE/Helpers/assets.csv|The assets.csv file is missing|file"
		"$WORKSPACE/Helpers/config.json|The config.json file is missing|file"
		"$WORKSPACE/reports/reports.log|The reports.log file is missing|file"
	)

	error_occurred=0
	for path_entry in "${required_paths[@]}"; do
		IFS='|' read -r path error_msg type <<< "$path_entry"
		
		if [ "$type" = "directory" ]; then
			if [ ! -d "$path" ]; then
				echo "[ERROR] $error_msg"
				error_occurred=1
			else
				echo "[OK] $path exists"
			fi
		else
			if [ ! -f "$path" ]; then
				echo "[ERROR] $error_msg"
				error_occurred=1
			else
				echo "[OK] $path exists"
			fi
		fi
	done

	if [ $error_occurred -eq 1 ]; then
		echo ""
		echo "[ERROR] Workspace environment checkup failed. Please fix the missing files."
		return
	else
		echo ""
		echo "[OK] Workspace environment checkup completed"
	fi
}

update_attendance_thresholds() {
    read -p "Do you want to update the attendance thresholds [Y/N]? " IS_UPDATE

    if [[ "$IS_UPDATE" =~ ^[Yy]$ ]]; then
        read -p "Enter new warning threshold percentage[Default 75%]: " WARNING_THRESHOLD
        read -p "Enter new failure threshold percentage[Default 50%]: " FAILURE_THRESHOLD
        
        sed -i "s/\"warning\": [0-9]*/\"warning\": $WARNING_THRESHOLD/" "$WORKSPACE/Helpers/config.json"
        sed -i "s/\"failure\": [0-9]*/\"failure\": $FAILURE_THRESHOLD/" "$WORKSPACE/Helpers/config.json"
        echo "Updated thresholds: Warning ==> ${WARNING_THRESHOLD}%  |  Failure ==> ${FAILURE_THRESHOLD}%"
		echo ""

		environment_checkup
    else
		echo "Used default thresholds: Warning ==> 75%  |  Failure ==> 50%"
		echo ""

		environment_checkup
    fi
    
}

init_system() {
    clear
    
    read -p "Enter the variation of this project: " PROJ_VARIATION

    WORKSPACE="${PROJECT_NAME}_${PROJ_VARIATION}"
    
    if [ -d "$WORKSPACE" ]; then
        read -p "This workspace  $WORKSPACE already exists. Do you want to overwrite it [Y/N]? " OVERWRITE
        
		if [[ "$OVERWRITE" =~ ^[Yy]$ ]]; then
            echo "Overwriting the existing workspace: $WORKSPACE"
            overwrite_workspace
        else
            echo "Aborting the setup process."
            exit
        fi
    else
	echo " Starting to create a new workspace => $WORKSPACE ......"

	mkdir "$WORKSPACE"

	echo ""
	echo "[OK] Workspace successfully created: $WORKSPACE"
	echo ""
	
	mkdir -p "$WORKSPACE/Helpers" "$WORKSPACE/reports"

	echo "[OK] created the workspace directories successfully"

    files_to_copy=(
        "attendance_checker.py|$WORKSPACE"
        "reports.log|$WORKSPACE/reports"
        "assets.csv|$WORKSPACE/Helpers"
        "config.json|$WORKSPACE/Helpers"
    )

    for file_entry in "${files_to_copy[@]}"; do
        IFS='|' read -r filename dest_dir <<< "$file_entry"
        cp "$TEMPLATE_DIR/$filename" "$dest_dir"
        echo "[OK] Migrated the $filename file to $dest_dir/"
    done

	echo ""

	echo "Successfully created migrated the whole workspace..."
	echo ""

	update_attendance_thresholds
    fi
}

init_system
