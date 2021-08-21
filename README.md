# Hallchant Marketplace ver. 1

The marketplace version 1 utilizes Ruby on Rails version 6 with Ruby 2.7.3 based on Solidus to catalyze the development process. The application has been containerized for easier documentation purposes. The ideal deployment OS is Ubuntu 20.04. We will breakdown the installation steps into the following:

- [Pre-Installation: Setting Up GitHub Access](#github)
- [1. Prepare the Docker and Docker Compose](#prep)
- [2. Build and Up the Built Container Using Docker Compose](#build)
- [Note: Pulling Update to the Server](#pull-update)
- [Note: Increase Entropy to Prevent docker-compose Hangs](#entropy)

Assuming you have prepared the Ubuntu 20.04 server, to start the installation, all you need to do is to follow these steps:

***

### <a name="prep"></a>Pre-Installation: Setting Up GitHub Access
The following steps are straightly taken from GitHub Docs on [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

First, Open Terminal.

Second, Paste the text below, substituting in your GitHub email address.

    ssh-keygen -t ed25519 -C "your_email@example.com"

Note: If you are using a legacy system that doesn't support the Ed25519 algorithm, use:

    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

This creates a new ssh key, using the provided email as a label.
When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.

    > Enter a file in which to save the key (/Users/you/.ssh/id_ed25519): [Press enter]

At the prompt, type a secure passphrase. For more information, see "Working with SSH key passphrases."

    > Enter passphrase (empty for no passphrase): [Type a passphrase]
    > Enter same passphrase again: [Type passphrase again]

Then open your GitHub profile setting page. Go to SSH and GPG keys tab and add your newly generated SSH key there. Depends on where your SSH key is generated, you can see your generated SSH public key by running the following command

    cat ~/.ssh/id_ed25519.pub

After adding your SSH key, you can now pull your repository with ease by running this command:

    git pull https://github.com/uzzybotak/pradipa-marketplace.git

### <a name="prep"></a>1. Prepare the Docker and Docker Compose

Quoting from DigitalOcean articles on [How To Install and Use Docker on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04) and [How To Install and Use Docker Compose on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04), below are the steps to install Docker and Docker Compose:

#### Docker Installation

First, update your existing list of packages:

    sudo apt update
 
Next, install a few prerequisite packages which let apt use packages over HTTPS:

    sudo apt install apt-transport-https ca-certificates curl software-properties-common
 
Then add the GPG key for the official Docker repository to your system:

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 
Add the Docker repository to APT sources:

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
 
Next, update the package database with the Docker packages from the newly added repo:

    sudo apt update
 
Make sure you are about to install from the Docker repo instead of the default Ubuntu repo:

    apt-cache policy docker-ce

Finally, install Docker:

    sudo apt install docker-ce
 
Docker should now be installed, the daemon started, and the process enabled to start on boot. Check that it’s running:

    sudo systemctl status docker

#### Docker Compose Installation

First, confirm the latest version available in their releases page. At the time of this writing, the most current stable version is 1.27.4.

The following command will download the 1.27.4 release and save the executable file at /usr/local/bin/docker-compose, which will make this software globally accessible as docker-compose:

    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
 
Next, set the correct permissions so that the docker-compose command is executable:

    sudo chmod +x /usr/local/bin/docker-compose
 
To verify that the installation was successful, you can run:

    docker-compose --version
 
You’ll see output similar to this:

    Output
    docker-compose version 1.27.4, build 40524192

***

### <a name="build"></a>2. Build and Up the Built Container Using Docker Compose

Start off the building process by cloning the repository to your server. You can run the command below to clone the repository

    git clone https://github.com/uzzybotak/hallchant-marketplace.git

Then let the Docker Compose do the rest for the building process by running the following commands

    cd hallchant-marketplace
    docker-compose up -d --build

There are three containers, sqlite, app, and nginx. Make sure all the containers are running by running this command:

    docker ps

After that, we can use the init-rails-app.sh and load-sample.sh to prepare all the databases and webpacker installation for the app to run properly. Run these commands:

    chmod +x init-rails-app.sh sample.sh update-rails-app.sh
    ./init-rails-app.sh
    ./load-sample.sh

Test the connection on your server by inputting your server's active IP address, (or domain in case you have set one), to check if Rails instance is running properly.

Installation should be done if the instance is running properly. 

***

### <a name="pull-update"></a>Note: Pulling Update to the Server

As for pulling the update to the server, you can run the following command to make changes when update is committed to the repo.

    git pull
    ./update-rails-app.sh

### <a name="pull-update"></a>Note: Increase Entropy to Prevent docker-compose Hangs

Sometimes docker-compose command will hang if there is not enough entropy. To prevent this, we can increase the entropy by running the following command:

    sudo apt install haveged
    haveged

