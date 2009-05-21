require File.dirname(__FILE__) + '/../test_helper'

class CompanyTest < ActiveSupport::TestCase
  context "a company" do
    setup do
      @company = Factory(:company, :name => "Nike")
    end

    should_validate_uniqueness_of :name
    should_validate_url_format_of :website_url

    should "display name as string representation" do
      assert_equal "Nike", @company.to_s
    end
  end
end
