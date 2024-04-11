#!/bin/bash

# Function to display loading message
loading() {
    local pid=$!
    local delay=0.75
    local spin='|/-\'
    printf "  "
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spin#?}
        printf " [%c]  " "$spin"
        local spin=$temp${spin%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# As we are in Islamic Republic of Iran we have to set a DNS first to connect to the free world.
sudo echo -e 'nameserver 185.51.200.2' >> /etc/resolv.conf
if [ $? -ne 0  ]; then
    echo "Command failed!"
    exit 1
else
    echo "You connected to the Free world!"
fi

# It's a good idea to update all packages.
echo "Updating packages..."
sudo apt update & loading

if [ $? -ne 0 ]; then
    echo "Command failed"
    exit 1
else
    echo "Now you are Updated!"
fi

# Now Install dependencies of Docker.
echo "Installing dependencies..."
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y & loading

if [ $? -ne 0 ]; then
    echo "Command Failed!"
    exit 1
else
    echo "Dependencies Installed!"
fi

# Now, add Docker’s GPG key and the Docker repository to your system.
echo "Downloading Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - & loading
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" & loading

if [ $? -ne 0 ]; then
    echo "Command Failed!"
    exit 1
else
    echo "Docker downloaded!"
fi

# Now you can Install Docker.
echo "Installing Docker..."
sudo apt update & loading
sudo apt install docker-ce -y & loading

if [ $? -ne 0 ]; then
    echo "Command Failed!"
    exit 1
else
    echo "Docker Installed!"
fi

##########

#Now Installing DOCKER-COMPOSE
echo "Now we installing docker-compose"

#Download docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
if [ $? -ne 0 ]; then
    echo "Command FAILED!!!!!!!!"
    exit 1
else
    echo "File Downloaded!"
fi

#change ownership
sudo chmod +x /usr/local/bin/docker-compose
if [ $? -ne 0 ]; then
    echo "Command FAILED!!!!!!!!"
    exit 1
else
    echo "Ownership has changed"
fi

#see Version of the docker-compose
docker_version=$(docker-compose --version)
if [ $? -ne 0 ]; then
    echo "Command FAILED!!!!!!!!"
    exit 1
else
    echo "$docker_version"
fi
