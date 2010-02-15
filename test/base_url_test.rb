require 'test_helper'
require 'mofo/hreview'

alias :real_open :open
def open(input)
  input[/^http/] ? open(fixture(:corkd)) : real_open(input)
end


class BaseUrlTest < Test::Unit::TestCase

  context "Grabbing an hReview from a URL" do
    setup do
      url = 'http://www.corkd.com/views/123'
      @url_hreview ||= HReview.find(:first => url)
    end

    should "add the base URL to all nested relative links" do
      assert_equal 'http://www.corkd.com/people/simplebits', @url_hreview.reviewer.url
    end

    should "not add the base URL to absolute links" do
      assert_equal 'http://flickr.com/img/icon-user-64.gif', @url_hreview.reviewer.photo
    end
  end
end