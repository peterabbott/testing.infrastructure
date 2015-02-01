require 'serverspec'

set :backend, :exec

describe service('tomcat') do
  it { should be_running }
end

describe command('curl --silent -o /dev/null  -w "%{response_code}" localhost:8080/manager/status') do
 its(:stdout) { should match /401/ }
end
