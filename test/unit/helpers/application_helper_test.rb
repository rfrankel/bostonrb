require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "sentence_of" do
    should "take an array and join with 'or's" do
      assert_equal "1, 2, 3, 4, or 5", sentence_of(%w{1 2 3 4 5}, :connector => :or)
      assert_equal "123 or 456", sentence_of([%w{1 2 3},%w{4 5 6}], :connector => :or)
    end

    should "default to %w{1 2 3 4 5}.to_sentence" do
      assert_equal %w{1 2 3 4 5}.to_sentence, sentence_of(%w{1 2 3 4 5})
    end
  end

  def controller
    unless @test_controler
      @test_controller = Object.new
      @test_controller.stubs(:controller_name).returns("current_test_controller")
    end
    @test_controller
  end
end
