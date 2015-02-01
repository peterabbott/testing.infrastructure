require 'serverspec'

set :backend, :exec

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_running }
end

describe service('apache2'), :if => os[:family] != 'redhat' do
  it { should be_running }
end

