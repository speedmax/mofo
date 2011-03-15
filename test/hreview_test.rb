require 'test_helper'
require 'mofo/hreview'
class HReviewTest < Test::Unit::TestCase

  context "The parsed Firesteed hReview object" do
   setup do
     @firesteed ||= HReview.find(:first => fixture(:corkd), :base => 'http://www.corkd.com')
   end

    should "have a valid, coerced dtreviewed field" do
      assert_instance_of Time, @firesteed.dtreviewed
      assert @firesteed.dtreviewed <= Time.parse('20060518')
    end

    should "have a rating of 5" do
      assert_equal 5, @firesteed.rating
    end

   should "have a description" do
     assert_equal %[This is probably my favorite every day (well, not every day) wine.  It's light, subtly sweet, ripe fruit, slightly spicy oak.  It's a bit "slippery", if that makes sense (in a very good way).  Highly drinkable.],
        @firesteed.description
    end

    should "have an HCard as the reviewer" do
      assert_equal "simplebits", @firesteed.reviewer.fn
      assert_equal "http://flickr.com/img/icon-user-64.gif", @firesteed.reviewer.photo
      assert_equal "http://www.corkd.com/people/simplebits", @firesteed.reviewer.url
    end

    should "have a valid item" do
      assert_equal "Firesteed 2003 Pinot Noir", @firesteed.item.fn
    end

    should "have 7 tags" do
      assert_equal 7, @firesteed.tags.size
      assert_equal "berry", @firesteed.tags.first
      assert_equal "sweet", @firesteed.tags.last
    end
  end
end