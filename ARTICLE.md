Infrastructure always has a habit of being the last piece of the deployment puzzle. It is always the part that ends up taking much longer than expected, not matter how many times you've done it before.

/quote Your infrastructure deserves tests too.

We have automated testing for all other areas of software development lifecycle, why not Infrastrucutre?

With the emmergence of 'Infrastructure as Code' the lines of responsibility around configuring infrastructure become more blurred. We need to be able to test a change before it has a chance to bring an environment down, be proactive not reactive.

This is where a tool like [Test Kitchen](http://kitchen.ci/) comes in. It is the glue between the provisioning tool of choice: Chef, Puppet, Ansible, etc; and the infrastruction being provisioned, AWS, Docker, VirtualBox, etc. 

The simple concept is that Test Kichen allows you to execute a convergance on a  given platform(s) and then execute a suite of tests to verify the environment has been setup as expected. 

This is particularly useful if you want to verify a setup against different OS and/or application versions. This can even be setup as part of your Continuous Integration and/or Delivery Pipelines. It also feeds nicely into the concept of [Immutable Infrastructure](http://www.thoughtworks.com/insights/blog/rethinking-building-cloud-part-4-immutable-servers), which I am a big fan of, but that is a whole other discussion.

The configuration Test Kitchen is to break the configuration into Driver, Provisioner, Platform and Tests.


````
Test Kitchen file 
````

The Driver section allows you define what underlying infrastructure you are going to use to launch your environment. The default is Vagrant and VirtualBox, but others like AWS EC2, Docker and Digital Ocean are supported.

The Platforms section allows you define the OS versions you want to run on. When using drivers like Docker and Vagrant, Test Kitchen are pretty good at figuring out what containers these map to. Others like AWS require AMI's to know what to launch.


The Provisioner section defines what you want to use to converge the environment. Chef Solo/Zero and Shell Provisioners are provided out-of-the box, but there are provisioners available for the likes of Puppet and Ansible. 

Finally the test section is where the value comes in to play. This is where you define the tests to run against each platform when convergance execution has completed. 



**Putting it all Together** 



Cookbook Environment Pattern

Demo application

BATS test Versus.




This example is also availble on [GitHub](http://github.com/peterabbott/testing.infrastucture) to try for yourself.




