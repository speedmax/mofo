require 'test_helper'
require 'mofo/rel_tag'

class RelTagTest < Test::Unit::TestCase
  context "An array of reltag arrays created from the corkd review webpage" do
    setup do
      @tags ||= RelTag.find(:all => fixture(:corkd))
    end

    should "consist of 23 tags" do
      assert_equal 23, @tags.size
    end

    should "include the berry and slippery tags" do
      assert @tags.flatten.include?('berry')
      assert @tags.flatten.include?('slippery')
    end
  end

  context "A web page with three rel tags" do
    setup do
      @page ||= <<-EOF
      <html>
      <body>
      <ul>
        <li><a href="/tags/miracle" rel="tag">miracle</a></li>
        <li><a href="/tags/wonder" rel="tag">wonder</a></li>
        <li><a href="/tags/amusement" rel="tag">amusement</a></li>
      </ul>
      </body>
      </html>
      EOF
    end

    should "produce an array of three RelTag objects" do
      tags = RelTag.find(:all, :text => @page)
      assert_instance_of Array, tags
      assert_equal 3, tags.size
      assert_equal ["miracle", "wonder", "amusement"], tags
    end
  end
end