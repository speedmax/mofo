require 'test_helper'
require 'mofo/xoxo'

class XOXOTest < Test::Unit::TestCase

  context "A simple xoxo object" do
    setup do
      @xoxo = XOXO.find(:text => '<ol> <li><a href="http://diveintomark.org/xml/blink.xml" type="application/rss+xml">dive into mark b-links</a></li> <li><a href="http://www.thauvin.net/blog/xml.jsp?format=rdf" type="application/rss+xml">Eric&#39;s Weblog</a></li> <li><a href="http://intertwingly.net/blog/index.rss2" type="application/rss+xml">Sam Ruby</a></li> <li><a href="http://diveintomark.org/xml/atom.xml" type="application/atom+xml">dive into mark</a></li> <li><a href="http://www.decafbad.com/blog/index.rss" type="application/rss+xml">0xDECAFBAD</a></li> </ol>')
    end
    should "have five label elements" do
      assert_equal 5, @xoxo.size
      classes = @xoxo.map { |x| x.class }.uniq
      assert_equal 1, classes.size
      assert_equal XOXO::Label, classes.first
    end
  end

  context "A simple xoxo object with two nested LIs" do
    setup do
      @xoxo = XOXO.find(:text => '<ol> <li><p>Linkblogs</p> <ol> <li><a href="http://diveintomark.org/xml/blink.xml" type="application/rss+xml">dive into mark b-links</a></li> <li><a href="http://www.thauvin.net/blog/xml.jsp?format=rdf" type="application/rss+xml">Eric&#39;s Weblog</a></li> </ol> </li> <li><p>Weblogs</p> <ol> <li><a href="http://intertwingly.net/blog/index.rss2" type="application/rss+xml">Sam Ruby</a></li> <li><a href="http://diveintomark.org/xml/atom.xml" type="application/atom+xml">dive into mark</a></li> <li><a href="http://www.decafbad.com/blog/index.rss" type="application/rss+xml">0xDECAFBAD</a></li> </ol> </li> </ol>')
    end

    should "be a two element array of hashes" do
      assert_equal 2, @xoxo.size
    end

    should "have hashes with two and three strings respectively" do
      assert_instance_of Hash, @xoxo.first
      assert_instance_of Array, @xoxo.first["Linkblogs"]
      assert_equal 2, @xoxo.first["Linkblogs"].size
      assert_equal 3, @xoxo.last["Weblogs"].size
    end
  end

  context "An array of xoxo objects created from a full webpage identified by class" do
    setup do
      @xoxo = XOXO.find(fixture(:chowhound), :class => true)
    end

    should "not be empty" do
      assert @xoxo.size > 0
    end

    should "be four arrays of arrays" do
      assert_equal 4, @xoxo.size
      assert_equal Array, @xoxo.map { |x| x.class }.uniq.first
    end
  end
end