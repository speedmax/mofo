require 'test_helper'
require 'microformat/string'
require 'microformat/array'
require 'mofo/hcard'
require 'mofo/hcalendar'
require 'mofo/hentry'

class ExtTest < Test::Unit::TestCase
  context "A string should be coercable into" do
    should "an integer" do
      assert_equal 2, "2".coerce
    end

    should "a float" do
      assert_equal 4.0, "4.0".coerce
      assert_not_equal 4.0, "4,0".coerce
    end

    should "a datetime" do
      assert_equal Time.parse("2004-08-03T03:48:27Z"), "2004-08-03T03:48:27Z".coerce
      assert_equal Time.parse("1985-03-13"), "1985-03-13".coerce
    end

    should "a boolean" do
      assert_equal true, "true".coerce
      assert_equal false, "false".coerce
    end
  end

  context "A string with HTML" do
    should "be able to remove the HTML" do
      string = %[<ol> <li><a href="http://diveintomark.org/xml/blink.xml" type="application/rss+xml">dive into mark b-links</a></li> <li><a href="http://www.thauvin.net/blog/xml.jsp?format=rdf" type="application/rss+xml">Eric&#39;s Weblog</a></li> <li><a href="http://intertwingly.net/blog/index.rss2" type="application/rss+xml">Sam Ruby</a></li> <li><a href="http://diveintomark.org/xml/atom.xml" type="application/atom+xml">dive into mark</a></li> <li><a href="http://www.decafbad.com/blog/index.rss" type="application/rss+xml">0xDECAFBAD</a></li> </ol>]
      assert_equal "dive into mark b-links Eric&#39;s Weblog Sam Ruby dive into mark 0xDECAFBAD", string.strip_html.strip
    end
  end

  context "An array sent first_or_self" do
    setup do
      @array = %w(one two)
    end

    should "return itself if it has more than one element" do
      assert_equal @array, @array.first_or_self
    end

    should "return its first element if it has only one element" do
      @array.pop
      assert_instance_of String, @array.first_or_self
    end
  end

  context "Any defined h* microformat" do
    should "have a lowercase h* method, for fun" do
      assert_equal HCard, hCard
      assert_equal HCalendar, hCalendar
    end
  end

  context "Searching a page with multiple uformats using Microformat.find" do
    setup do
      @multi_formats ||= Microformat.find(fixture(:chowhound))
    end

    should "find all the instances of the different microformats" do
      assert_instance_of Array, @multi_formats
      classes = @multi_formats.map { |i| i.class }
      assert classes.include?(HEntry)
      assert classes.include?(HCard)
    end
  end

  context "Mofo's timeout duration" do
    should "be alterable" do
      Timeout.expects(:timeout).at_least_once.with(5)
      Microformat.find('random_file.html')

      Microformat.timeout = 11
      Timeout.expects(:timeout).at_least_once.with(11)
      Microformat.find('random_file.html')
    end
  end
end