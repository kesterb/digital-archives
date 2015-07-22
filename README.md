# OSF Digital Archives

The OSF Digital Archive is a digital repository for audio / video assets from the Oregon Shakespeare Festival archives.

The implementation is derived from Project Hydra's Sufia 6.2.0

See https://github.com/projecthydra/sufia

# Developing the OSF Digital Archives on Mac OS

## One-time Preparations

### VirtualBox

Download and install VirtualBox from:

https://www.virtualbox.org/wiki/Downloads

### Vagrant

Download and install Vagrant from:

https://www.vagrantup.com/downloads.html

### Source code

Clone the project into a workspace

    cd ~/workspace/
    git clone git@github.com:OregonShakespeareFestival/digital-archives.git

Download and spin up the virtual machine

    vagrant up

Enter the virtual box

    vagrant ssh

### Preparation

Install gems

    bundle

Create the database

    rake db:create
    rake db:migrate
    rake db:seed

The first time you spin up the vagrant box you must initialize the docker images (fedora/solr)

    ./bin/init-docker.sh

When starting up the vagrant box anytime after that you can simply run

    ./bin/start-docker.sh


Docker services can be restarted by first issuing the following commands.  This will erase all data stored in them.

    ./bin/destroy-docker.sh
    ./bin/start-docker.sh

#### Rails Server (application server)

    rails s

You can reach the application at [http://localhost:3000/](http://localhost:3000/)

#### Resque (background job workers)

Resque queues can be spun up the old fashioned way with the following command.

    QUEUE=* rake resque:work

Resque pools can be used alternatively. Place the included `resque-pools.yml` file in the application config directory and spin up resque in the background with the following command.

    resque-pool --daemon --environment development start

#### Admin Users
Admin users are defined in the seeds file.

#### FedoraCommons/Solr
Fedora Commons and Solr can be accessed on port 8983  
[fedoraCommons](http://localhost:8080/fcrepo-webapp-4.1.1/rest) username: fedoraAdmin, password: fedoraAdmin
[solr](http://localhost:8081/solr)

## Resources

- [sufia 6.2.0 Documentation](https://github.com/projecthydra/sufia)
- [Blacklight Project Page](https://github.com/projectblacklight/blacklight)
- [hydra-jetty project](https://github.com/projecthydra/hydra-jetty)
- [hydra wiki](https://github.com/projecthydra/hydra/wiki)
- [Rsolr Documentation](https://github.com/rsolr/rsolr)
- [solr Wiki](https://wiki.apache.org/solr/FrontPage)
- [Blacklight Solr Configuration](https://github.com/projectblacklight/blacklight/wiki/Solr-Configuration)
