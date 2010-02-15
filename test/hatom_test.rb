require 'test_helper'
require 'mofo/hfeed'

class HatomTest < Test::Unit::TestCase

  context "A parsed hEntry object" do

    setup do
      @hentry ||= HEntry.find(:first => fixture(:hatom), :base => 'http://errtheblog.com')
    end

    should "have a title" do
      assert_equal "&ldquo;A Rails Toolbox&rdquo;", @hentry.entry_title
    end

    should "have an author string " do
      assert_instance_of HCard, @hentry.author
      assert_equal @hentry.author.fn, "Chris"
    end

    should "have an author when there are no entry author but a nearest in parent hcard" do
      with_parent = HEntry.find(:first => fixture(:redflavor),
                               :base => 'http://journal.redflavor.com')
      assert_instance_of HCard, with_parent.author
      assert_equal "Eivind Uggedal", with_parent.author.fn
      assert_equal "http://redflavor.com", with_parent.author.url
    end

    should "be invalid without any author in strict mode" do
      assert_raises InvalidMicroformat do
        HEntry.find(
          :first => fixture(:hatom_without_author),
          :base => 'http://bogus.redflavor.com',
          :strict => true
        )
      end
    end

    should "have content" do
      assert @hentry.entry_content.instance_of?(String)
    end

    should "have an attached published date object" do
      assert @hentry.published.instance_of?(Time)
    end

    should "have an inferred updated attribute which references the published date object" do
      assert @hentry.updated.instance_of?(Time)
      assert_equal(@hentry.published, @hentry.updated)
    end

    should "have a bookmark (permalink)" do
      assert_equal "/post/13", @hentry.bookmark
    end

    should "have an array of tags" do
      assert_instance_of Array, @hentry.tags
    end

    should "know its Atom representation" do
      to_atom = @hentry.to_atom
      expected = <<-end_atom
        <entry>
          <id>tag:errtheblog.com,2008
          <link type="text/html" href="http://errtheblog.com/post/13" rel="alternate"/>
          <title>&ldquo;A Rails Toolbox&rdquo;</title>
          <content type="html">
            &lt;img
            src=
            http://errtheblog.com/static/images/pink-toolbox.jpg
            &lt;p&gt;
          </content>
          <author>
            <name>Chris</name>
          </author>
        </entry>
      end_atom

      expected.split("\n").each do |line|
        assert to_atom.include?(line.strip)
      end
    end
  end

  context "An hFeed" do
    setup do
      @hentries ||= HEntry.find(:all => fixture(:hatom), :base => 'http://errtheblog.com/posts/rss')
    end

    should "know its atom id" do
      assert_equal "<id>tag:errtheblog.com,2008-01-22:a7ec6beee025594bbed6817b361e0e45</id>", @hentries.first.atom_id

    end

    should "know its Atom representation" do
      to_atom = @hentries.to_atom(:title => 'Err the Blog')
      expected = <<-end_atom
        <entry>
          <id>http://errtheblog.com/posts/rss</id>
          <link type="text/html" href="http://errtheblog.com/post/13" rel="alternate"/>
          <title>Err the Blog</title>
          <content type="html">
            &lt;img
            src=
            http://errtheblog.com/static/images/pink-toolbox.jpg
            &lt;p&gt;
          </content>
          <updated>
          <author>
            <name>Chris</name>
          </author>
        </entry>
      end_atom

      expected << <<-end_atom
      <?xml version="1.0" encoding="UTF-8"?>
      <feed xml:lang="en-US" xmlns="http://www.w3.org/2005/Atom">
        <link type="text/html" href="
      </feed>
      end_atom

      expected.split("\n").each do |line|
        assert to_atom.include?(line.strip)
      end
    end
  end
end