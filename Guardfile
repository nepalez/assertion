# encoding: utf-8

guard :rspec, cmd: "bundle exec rspec" do

  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^lib/assertion/(.+)\.rb}) do |m|
    "spec/unit/assertion/#{m[1]}_spec.rb"
  end

  watch(%r{^lib/assertion/transproc.rb}) do
    "spec/unit/assertion/transproc"
  end

  watch("lib/assertion.rb")        { "spec" }
  watch("spec/spec_helper.rb") { "spec" }

end # guard :rspec
