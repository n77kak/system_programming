#!/bin/bash

# Display information about the program on startup
echo "Author: Korpacheva Veronika 720-1"
echo "Program: Create CD Image"
echo "Description: This script prompts the user for a directory path, the name of the future CD image, and creates a CD image with the contents of the specified directory."

# Check if genisoimage is installed
if ! command -v genisoimage &> /dev/null; then
    echo "Error: genisoimage is not installed. Please install it before running this script." >&2
    exit 1
fi

# Trap INT signal to exit gracefully
trap 'echo "Goodbye!"; exit 0' INT

# Infinite loop
while :
do
    # Request the directory path
    read -rp "Enter the path to the directory with files: " directory

    # Check for the existence of the directory
    if [ ! -d "$directory" ]; then
        echo "Error: The specified directory does not exist. Please enter a correct path." >&2
        continue
    fi

    # Request the name of the CD image
    read -rp "Enter the name of the future CD image: " image_name

    # Check for the existence of a file with the same name
    while [ -e "$image_name.iso" ]; do
        # If the file exists, add the current date to the name and ask for a new one
        image_name="${image_name}_$(date +'%Y%m%d')"
    done

    # Add .iso extension
    image_name="$image_name.iso"

    # Create a CD image using genisoimage
    if genisoimage -o "$image_name" "$directory"; then
        echo "CD image successfully created: $image_name"
    else
        echo "Error: Failed to create CD image. Please check your input and try again." >&2
    fi

    # Ask the user if they want to start over or exit the loop
    read -rp "Do you want to create another image? (yes/no): " answer

    case $answer in
        [Nn]*)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            continue
            ;;
    esac
done
