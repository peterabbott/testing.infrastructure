require 'serverspec'

set :backend, :exec

describe command('java -version'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /1.7.0_75/ }
end

describe command('java -version'), :if => os[:family] == 'ubuntu' do
  its(:stdout) { should match /1.7.0_65/ }
end

describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end
