ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require 'macros/should_validate_url_format_of'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def file_fixture(name)
    File.read(File.join(File.dirname(__FILE__), "file_fixtures", name))
  end

  def assert_response_media_type(expected_content_type)
    actual_content_type = content_type

    msg = "Content Type '#{actual_content_type.inspect}' isn't '#{expected_content_type.inspect}'\n"
    msg += "Body: #{@response.body.first(100).chomp} ..." 

    assert_equal expected_content_type, actual_content_type, msg
  end

  def raw_content_type
    (@response.headers["Content-Type"] || @response.headers["type"]).to_s
  end

  def content_type
    raw_content_type.split(';').first
  end

  def self.should_have_media_type(media_type)
    should "have #{media_type.inspect} media type" do
      assert_response_media_type media_type
    end
  end

  def stubbed_action_view
    view = ActionView::Base.new(@controller.class.view_paths, {}, @controller)
    yield view
    ActionView::Base.stubs(:new).returns(view)
  end
end

module StubChainMocha
  module Object
    def stub_chain(*methods)
      while methods.length > 1 do
        stubs(methods.shift).returns(self)
      end
      stubs(methods.shift)
    end
  end
end

Object.send(:include, StubChainMocha::Object)

