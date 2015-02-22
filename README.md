Once you have cloned this project locally, you will need to use bundle to install the dependencies usin Bundler.

## Requirements

To run this you need to have Virtual Box installed. 

Docker is also supported, if that is the case you will need Docker or Boot2Docker installed.

## Setup


In order to avoid clashes with already installed Gems you can use Bundler deployment mode. After that any Test Kitchen command will have to be with with `bundle exec` 

It is a one time install and may take a while.

```
bundle install --deployment
```

The default for this is to use Vagrant, running any Kitchen Command will use Vagrant and Virtual Box. 

If you want to use Docker, then you can override the Driver with the environment variable *KITCHEN_DRIVER* in front of any command.

Running the list command with Vagrant and Virtual Box, you would run the following.

``` Shell
bundle exec kitchen list
```

To run with the Docker Driver, make sure Docker Daemon is running first or it will just hang.

``` Shell
KITCHEN_DRIVER=docker bundle exec kitchen list
```

Both options will produce the same output

``` Shell
Instance             Driver  Provisioner  Last Action
default-ubuntu-1404  Docker  ChefSolo     <Not Created>
default-ubuntu-1204  Docker  ChefSolo     <Not Created>
default-debian-74    Docker  ChefSolo     <Not Created>
default-debian-78    Docker  ChefSolo     <Not Created>
default-centos-65    Docker  ChefSolo     <Not Created>
java-8-ubuntu-1404   Docker  ChefSolo     <Not Created>
java-8-ubuntu-1204   Docker  ChefSolo     <Not Created>
java-8-debian-74     Docker  ChefSolo     <Not Created>
java-8-debian-78     Docker  ChefSolo     <Not Created>
java-8-centos-65     Docker  ChefSolo     <Not Created>
```


## Running Test Kitchen

To start with Test Kitchen you can list the configured test suites.

NOTE: For these examples, if you want to use Docker then prefix `KITCHEN_DRIVER=docker ` to the start of anything


```
bundle exec kitchen list
````


