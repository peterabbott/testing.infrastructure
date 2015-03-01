Once you have cloned this project locally, you will need to use bundle to install the dependencies using Bundler.

## Requirements

To run this you need to have Virtual Box installed. 

Docker is also supported, if that is the case you will need Docker or Boot2Docker installed.

If running on a Mac, using Homebrew and Cask will make the installation of dependencies much easier.

### Versions

The demo was tested with the follow versions on OSX 10.10

- Docker: 1.4.1
- Virtualbox: 4.3.14
- Bundler: 1.7.6
- Ruby: 2.0 and 2.1

Recent changes to some framework Gem dependencies means that some aspects of Test Kitchen do not work with Ruby 1.9


## Setup

In order to avoid clashes with already installed Gems you can use Bundler deployment mode. After that any Test Kitchen command will have to be with with `bundle exec` 

It is a one time install (and may take a while).

```
bundle install --deployment
```

The default for this is to use Vagrant, running any Kitchen Command will use Vagrant and Virtual Box. 

If you want to use Docker, then you can override the Driver with the environment variable *KITCHEN_DRIVER* in front of any command.

Running the list command with Vagrant and Virtual Box

``` Shell
bundle exec kitchen list
```

To run with the Docker Driver, make sure Docker Daemon is running first or the process will appear to hang.

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


**List Tests**
```
bundle exec kitchen list
```

**Run Single Test**

To run all steps in the process, create, converge, verify and destroy, then you can use the test command.

```
bundle exec kitchen test default-ubuntu-1404
```

**Run All Test**

To run all of them (will take a while), just leave off then name regex.

```
bundle exec kitchen test 
```


**Converge Single Test Setup**

If you just want to create and converge instance(s), you can use the converge command

```
bundle exec kitchen converge default-ubuntu-1404
```

**Verify a Single Test Setup**

If you are still working on the setup or configuration it is possible to rerun convergence. Then when you think you have the correct setup you can run the verify command. It is still recommended that as part of any CD process you run the testing from a clean slate. 


```
bundle exec kitchen verify default-ubuntu-1204
```

**Destroy a Test Setup**

If you are finished with a specific instance and want to throw it away or even start again, you can use the destroy command.

```
bundle exec kitchen destroy default-ubuntu-1204
```