source 'https://rubygems.org'

ruby '2.1.4'
group :lint do
  gem 'foodcritic', '~> 3.0'
  gem 'rubocop', '~> 0.18'
  gem 'rainbow', '< 2.0'
  gem 'rake'
end

group :unit do
  gem 'berkshelf',  '~> 3.1'
  gem 'chefspec',   '~> 4.0'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.2'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 0.11'
end

group :kitchen_cloud do
  #gem 'kitchen-ec2', '~> 0.8.0'
  gem 'kitchen-ec2', :git => 'https://github.com/test-kitchen/kitchen-ec2.git'
  gem 'kitchen-gce', '~> 0.2.0'
  gem 'travis', '~> 1.7.5'
end


group :kitchen_docker do
#  gem 'kitchen-docker', '~> 1.7.0'
  gem 'kitchen-docker', :git => 'https://github.com/peterabbott/kitchen-docker.git' 
end

group :ci do
  gem 'stove', '= 3.2.3'
  gem 'thor-scmversion', '= 1.7.0'
end

group :development do
  gem 'ruby_gntp'
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard', '~> 2.4'
  gem 'guard-kitchen'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end
