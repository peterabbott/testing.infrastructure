Once you have cloned this project locally, you will need to use bundle to install the dependencies usin Bundler.

In order to avoid clashes with already installed Gems you can use Bundler deployment mode. After that any Test Kitchen command will have to be with with `bundle exec` 

## Setup

It is a one time install and may take a while.

```
bundle install --deployment
```

The default for this is to use Docker, but if you want to use Vagrant and Virtualbox then in the file `.kitchen.yml` replace the driver configuration value 'docker' with 'vagrant'

The start of the would look something like this: 
```
---
driver:
  name: docker
```



## Running Test Kitchen

To start with Test Kitchen you can list the configured test suites

```
bundle exec kitchen list
````


