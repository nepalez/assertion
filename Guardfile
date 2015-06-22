# encoding: utf-8

guard :rspec, cmd: "bundle exec rspec" do

  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^lib/(.+)\.rb}) do |m|
    "spec/unit/#{m[1]}_spec.rb"
  end

  watch("lib/assertion/dsl.rb")       { "spec/unit/assertion_spec.rb"       }
  watch("lib/assertion/base_dsl.rb")  { "spec/unit/assertion/base_spec.rb"  }
  watch("lib/assertion/guard_dsl.rb") { "spec/unit/assertion/guard_spec.rb" }
  watch("lib/assertion/inflector.rb") { "spec/unit/assertion/inflector"     }

  watch("spec/spec_helper.rb") { "spec" }

end # guard :rspec
