require 'test_helper'
require 'mofo/xfn'

class XfnTest < Test::Unit::TestCase
  def xfn_setup
    @xfn ||= XFN.find(:first => fixture(:xfn))
  end

  context "A XFN object" do
    setup do
      xfn_setup
    end

    should "know what relations it contains" do
      assert_instance_of Array, @xfn.relations
      assert @xfn.relations.include?('me')
    end

    should "give information about a relationship" do
      me = @xfn.me
      assert_instance_of Array, me
      assert_equal 'me', me.first.relation
      assert_equal '#me', me.first.to_s

      muse = @xfn.muse(true)
      assert_instance_of XFN::Link, muse
      assert_equal 'muse', muse.relation
      assert_equal '#muse', muse.to_s
    end

    should "know relationship intersections" do
      # hot!
      intersection = @xfn.colleague_and_sweetheart
      assert_instance_of XFN::Link, intersection
      assert_equal '#colleague', intersection.to_s

      intersection = @xfn.kin_and_colleague
      assert_instance_of Array, intersection
      assert_equal '#kin', intersection.first.to_s
    end

    should "not know non-existent relationship intersections" do
      intersection = @xfn.colleague_and_sweetheart_and_muse_and_crush
      assert_nil intersection
    end

    should "not pick up reserved relationships" do
      assert_nil @xfn.nofollow
      assert_nil @xfn.friend_and_nofollow
      assert_nil @xfn.bookmark
    end
  end

  context "A XFN::Link object" do
    setup do
      xfn_setup
      @xfn_link ||= @xfn.first

    end

    should "be able to generate an html version of itself" do
      assert_match /href.+\>.+\</, @xfn_link.to_html
    end

    should "know its name" do
      assert_instance_of String, @xfn_link.name
      assert !@xfn_link.name.empty?
    end

    should "know its relation to the page from which it was obtained" do
      assert_instance_of String, @xfn_link.relation
      assert !@xfn_link.relation.empty?
    end

    should "know where it points" do
      assert_instance_of String, @xfn_link.link
      assert !@xfn_link.link.empty?
    end

    should "display itself as its link" do
      assert_equal @xfn_link.link.to_s, @xfn_link.to_s
    end
  end
end