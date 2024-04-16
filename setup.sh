#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if a custom UUID is provided as an argument
if [ -n "$1" ]; then
    UUID=$1
    echo -e "${GREEN}Using custom UUID: $UUID${NC}"
else
    UUID=$(uuidgen) # Generate a UUID
    echo -e "${YELLOW}No UUID provided in args. Generated a new UUID: $UUID${NC}"
fi

# Ask the user if they are GPU rich
read -p "Are you GPU rich? (yes/no, default: yes): " gpu_rich

# Set GPU_STATUS based on user input
case $gpu_rich in
    [Yy]* | "" )
        GPU_STATUS="gpu"
        NOT_GPU_STATUS="no_gpu"
        ;;
    [Nn]* )
        GPU_STATUS="no_gpu"
        NOT_GPU_STATUS="gpu"
        ;;
    * )
        echo -e "${RED}Invalid input. Assuming GPU rich.${NC}"
        GPU_STATUS="gpu"
        NOT_GPU_STATUS="no_gpu"
        ;;
esac

mv .$GPU_STATUS.template.env .template.env 2> /dev/null
rm .$NOT_GPU_STATUS.template.env 2> /dev/null

mv docker-compose.$GPU_STATUS.template.yml docker-compose.template.yml 2> /dev/null
rm docker-compose.$NOT_GPU_STATUS.template.yml 2> /dev/null

mv dev.$GPU_STATUS.Dockerfile dev.Dockerfile 2> /dev/null
rm dev.$NOT_GPU_STATUS.Dockerfile 2> /dev/null

rm -rf .git 2> /dev/null

# Inform the user to adapt the .template.env file and wait for their confirmation
echo -e "${YELLOW}Please adapt the .template.env file to your needs. Press enter to continue after you have finished editing.${NC}"
read -p "Press enter to continue"

# Replace placeholders in the template and output to .env
sed "s/{{UUID}}/$UUID/g" .template.env > .env
echo -e "${GREEN}Generated .env with UUID=$UUID${NC}"

# Replace placeholders in the docker-compose template and output to docker-compose.yml
sed "s/{{UUID}}/$UUID/g" docker-compose.template.yml > docker-compose.yml
echo -e "${GREEN}Generated docker-compose.yml with service name python_debian_$UUID${NC}"

. .env # To get $CONTAINER_BASENAME

# Perform both replacements using a single sed command
sed -e "s/{{CONTAINER_BASENAME}}/$CONTAINER_BASENAME/g" -e "s/{{UUID}}/$UUID/g" devcontainer.template.json > devcontainer.json
echo -e "${GREEN}Generated devcontainer.json with UUID=$UUID, CONTAINER_BASENAME=$CONTAINER_BASENAME${NC}"