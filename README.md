# OSF Digital Archives

The OSF Digital Archive is a digital repository for audio / video assets from the Oregon Shakespeare Festival archives.

The implementation is derived from Project Hydra's Sufia 4.0.0 rc1

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

Set up hydra-jetty (sufia 4.0)

    rake jetty:clean
    rake jetty:config

Set up hydra-jetty (sufia 6.0)

    rake jetty:clean
    rake sufia:jetty:config

## On-going Development
    
    Looking for a better way to reindex after changing search fields but this works in console
    ActiveFedora::Base.all.each{|f| f.update_index}

### Spinning up the services

Open several tabs and `vagrant ssh` into each of them.

#### Jetty (server for fedora commons / solr)

    rake jetty:start

#### Rails Server (application server)

    rails s -b 0.0.0.0

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
[fedoraCommons](http://localhost:8983/fedoraCommons) username: fedoraAdmin, password: fedoraAdmin
[solr](http://localhost:8983/solr)

## Resources

- [sufia 4.0.0 rc1 Documentation](https://github.com/projecthydra/sufia)
- [sufia 3.7.0 Documentation](http://rubydoc.info/gems/sufia/3.7.0/frames)
- [Blacklight Project Page](https://github.com/projectblacklight/blacklight)
- [hydra-jetty project](https://github.com/projecthydra/hydra-jetty)
- [hydra wiki](https://github.com/projecthydra/hydra/wiki)

Slightly less useful resources:

- [Rsolr Documentation](https://github.com/rsolr/rsolr)
- [solr Wiki](https://wiki.apache.org/solr/FrontPage)
- [Blacklight Solr Configuration](https://github.com/projectblacklight/blacklight/wiki/Solr-Configuration)
