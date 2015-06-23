# encoding: utf-8
begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
  exit
end

# Loads bundler tasks
Bundler::GemHelper.install_tasks

# Loads the Hexx::RSpec and its tasks
begin
  require "hexx-suit"
  Hexx::Suit.install_tasks
rescue LoadError
  require "hexx-rspec"
  Hexx::RSpec.install_tasks
end

# Sets the Hexx::RSpec :test task to default
task :default do
  system "bundle exec rspec spec"
end

desc "Runs mutation metric for testing"
task :mutant do
  system "mutant -r ./spec/spec_helper --use rspec 'Assertion*'"
end
