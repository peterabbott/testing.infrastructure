require 'serverspec'

set :backend, :exec

describe command('java -version'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /1.8.0_25/ }
end

describe command('java -version'), :if => os[:family] == 'ubuntu' do
  its(:stdout) { should match /1.8.0.25/ }
  its(:stdout) { should match /Java\(TM\) SE Runtime Environment/ }
  its(:stdout) { should_not match /OpenJDK/ }
end