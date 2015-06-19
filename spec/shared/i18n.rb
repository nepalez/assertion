# encoding: utf-8

shared_context "preloaded translations" do

  around do |example|

    load_path = Dir[File.expand_path "../*.yml", __FILE__]

    old_locale, I18n.locale = I18n.locale, :en
    old_path, I18n.load_path = I18n.load_path, load_path
    I18n.backend.load_translations

    example.run

    I18n.locale    = old_locale
    I18n.load_path = old_path
    I18n.backend.reload!

  end

end # shared context
