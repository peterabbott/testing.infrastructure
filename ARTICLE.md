Infrastructure always has a habit of being the last piece of the deployment puzzle. It is always the part that ends up taking much longer than expected, not matter how many times you've done it before.

{{#data title="Test Kitchen"

definition="Your infrastructure deserves tests too."

source="kitchen.ci"

url="https://kitchen.ci/"
}}
{{> definition}}
{{/data}}



We have automated testing for software development lifecycle. So why not Infrastrucutre? 

With the emmergence of 'Infrastructure as Code' the responsibility of configuring insfrastructure are crossing over to developers, not just the domain of System Administrator. This makes the need to be able to test a change in isolation even more important, before you have the change of brining down an entire environment. 

This is where a tool like [Test Kitchen](http://kitchen.ci/) comes in. It is the glue between the provisioning tools like Chef, Puppet, Ansible; the infrastruction being provisioned like AWS, Docker, VirtualBox; and the tests to validate the setup is correct.

The simple concept is that Test Kichen allows you to execute a convergance on a  given platform(s) and then execute a suite of tests to verify the environment has been setup as expected. 

This is particularly useful if you want to verify a setup against different OS and/or application versions. This can even be setup as part of your Continuous Integration and/or Delivery Pipelines. It also feeds nicely into the concept of [Immutable Infrastructure](http://www.thoughtworks.com/insights/blog/rethinking-building-cloud-part-4-immutable-servers), which I am a big fan of, but that is a whole other discussion.

The configuration Test Kitchen is to break the configuration into Driver, Provisioner, Platform and Tests.


In this simple example, running test kitchen would launch an Ubunu 14 and using the *apt* cookbook run an `apt update`. 

``` 
---
driver:
  name: vagrant
provisioner:
  name: chef_solo
platforms:
  - name: ubuntu-14.04
suites:
  - name: default
    run_list:
    - "recipe[apt]"
    attributes:
 
``` 


The Driver section allows you define what underlying infrastructure you are going to use to launch your environment. The default is Vagrant and VirtualBox, but others like AWS EC2, Docker and Digital Ocean are supported.

The Platforms section allows you define the OS versions you want to run on. When using drivers like Docker and Vagrant, Test Kitchen are pretty good at figuring out what containers these map to. Others like AWS require AMI's to know what to launch.


The Provisioner section defines what you want to use to converge the environment. Chef Solo/Zero and Shell Provisioners are provided out-of-the box, but there are provisioners available for the likes of Puppet and Ansible. 

Finally the test section is where the value comes in to play. This is where you define the tests to run against each platform when convergance execution has completed. 



**Putting it all Together** 

Normally if I were setting up platform, I'd wrap all the recipies into a single wrapper cookbook. This is also known as the [Environment Cookbook Pattern](http://blog.vialstudios.com/the-environment-cookbook-pattern/). While you can use Chef Roles and Environments to manage recipes, I find it much cleaner to use a single wrapper cookbook to define a stack that is used by an application. This approach also makes it far easier to version and feed into different tools (for example Test Kitchen, Packer, Chef Server), instead of maintaining different configuration files for each setup.

For this example, the recipe run list and chef configuration are defined in the Test Kitchen config to make it easier to follow. 

I tend to use Docker to test with as it is much quicker to spin up instances as compared with the default Vagrant and VirtualBox.


*Sample Test Kitchen Config*

``` 
---
driver:
  name: docker 

provisioner:
  name: chef_solo
platforms:
  - name: ubuntu-12.04
    run_list:
    - "recipe[apt]"
    - "recipe[java]" 
    - "recipe[mongodb]"
    - "recipe[jetty]"
    - "recipe[tomcat]"
  - name: ubuntu-14.04
    run_list:
    - "recipe[apt]"
    - "recipe[mongodb]"
    - "recipe[jetty]"
    - "recipe[tomcat]"    
    - "recipe[java]" 
  - name: centos-6.4
    run_list:
    - "recipe[yum]"
    - "recipe[mongodb]"
    - "recipe[tomcat]"
    - "recipe[java]"
    - "recipe[apache]"

suites:
  - name: default
    attributes:
      java:
        install_flavor: openjdk 
        jdk_version: 7

```

So now we are able to run Test Kitchen and verify that each of the Chef recipes will execute and converge successfully. But do we actually know that everything is in place and will run once let loose into the wild?

This is where we need to write some tests to verify that everything is in place. We should test things like versions installed, services running, files in the correct place. Tests don't lie.

We have all been caught out by a Gem or Cookbook being updated and then having to spend hours trying to figure out why things just stopped working. The update to the Apache cookbook from the default Apache 2.2 to 2.4 is a prime example. Even in putting together a sample for this article I found a couple of bugs and unexcepted behaviours in some of the cookbooks I was using. Also that, very few cookbooks seem to show Centos any love.

With infrastrucuture tests in place, we can pick up these changes sooner in the deployment lifecycle then getting caught with an broken environment that others are reliant on.

The most common tests are [Bats](https://github.com/sstephenson/bats) and [Serverspec](http://serverspec.org/). Bats tests (Bash Tests) are probably easier to get to grips with if just writing simple tests. Serverspec allows you to write more complex test and is better at handling cross-platform tests.

A simple Bats testing to verify Java installed.

``` bash
@test "that java is install" {
	run test -f /usr/bin/java 
	[ "$status" -eq 0 ]
}

@test "that java libs is installed" {
	run test -d /usr/lib/jvm 
	[ "$status" -eq 0 ]
}
```

An example Serverspec Test to verify Java version and required services are installed.

``` ruby
require 'serverspec'

set :backend, :exec

describe command('java -version'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /1.7.0_75/ }
end

describe command('java -version'), :if => os[:family] == 'ubuntu' do
  its(:stdout) { should match /1.7.0_65/ }
end

describe service('tomcat7')
  it { should be_installed }
  it { should be_running }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
  it { should be_running }
end

describe service('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
  it { should be_running }
end


```


If you were to go down the route of Immutable Infrastructure, then you would start to add application tests to verify that the application is deployed and can run. 

**Running Test Kitchen**

There are two key phases to Test Kichen, converge and verify. 

To start with you can see what tests are available by running `kitchen list`. This will list all the combinations of platforms and tests configured.

``` console
$ kitchen list
Instance             Driver  Provisioner  Last Action
default-ubuntu-1204  Docker  ChefSolo     Created
default-centos-64    Docker  ChefSolo     <Not Created>

```

You can run each phase of Test Kitchen seperately, but running `kitchen test` will create a container, run the convergence, run the tests and then tear everything down. 

``` console
$ kitchen test ubuntu
///... Lots of output while the tests runs 
$ kitchen list
Instance             Driver  Provisioner  Last Action
default-ubuntu-1204  Docker  ChefSolo     Converged
default-centos-64    Docker  ChefSolo     <Not Created>

```

As the example above shows, only the Ubuntu instances have been converged. Test Kitchen can take multiple formats of inputs, you could run all tests, tests only against Ubuntu or only specific test suite.

``` bash
kitchen test  -  run all test suites against all platforms
kitchen test ubuntu  -  run all test suites only against Ubuntu 
kitchen test default  -  run default test suite against all platforms
kitchen test default-ubuntu-1204  -  run default test suite against Ubuntu 12.04
``` 

During testing you might encounter times where tests fail and you can't figure out why. The staged approach of Test Kitchen allows you to runs the convergence and verification stages separately. What this means is that you can login to the generated and (partially) provisioned Virtual Machine to have a poke around. This is particularly useful during initial setup, it allows you to look around and see how things are setup whithout breaking any "real" environments.

To make connecting to a Virtual Machine, Test Kitchen provides a login command so you don't have to worry about figuring out ports and ssh keys, it remembers all that for you.

So as we can Test Kitchen can provide a really easy mechanism to test your infrastructure, in particular testing the infrastructure after it has been through your provisioning tool of choice. You spin up or updated environments safe in the knowledge that you wont bring down an environment and have angry users blaming your for a lost environments or an annoyed support team that you broke one of their servers. 

At the very least testing the convergence of any cookbooks you write should always come with a basic Test Kitchen config to verify the cookbook itself. TDD for Infrastructure.

** What's Next? **

After you have Test Kitchen in place you could then setup a tool to like [Packer](https://packer.io) to generate your infrastructure VM's with the confidence it will work. 

All this together would put you in a good position to implement a successful Continuous Delivery pipeline.

The example used in this article uses Chef Solo as the provisioniing tool and Docker as the VM platform, it is availble on [GitHub](http://github.com/peterabbott/testing.infrastucture) for people to try it out themselves.


