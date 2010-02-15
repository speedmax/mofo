require 'test_helper'
require 'mofo/hcard'

module Formats
  class Card < HCard
  end
end

class SubclassTest < Test::Unit::TestCase
  context "Subclassing an hCard" do
    should "parse a page with an hcard" do
      assert_nothing_raised do
        Formats::Card.find(fixture(:fauxtank))
      end
    end

    should "raise an error if no hcard is found in strict mode" do
      assert_raise MicroformatNotFound do
        Formats::Card.find(fixture(:fake), :strict => true)
      end
    end

    should "return an empty array if no hcard is found" do
      assert_equal [], Formats::Card.find(fixture(:fake))
    end

    should "return nil if no hcard is found with :first" do
      assert_nil Formats::Card.find(:first => fixture(:fake))
    end

    should "return empty array if no hcard is found with :all" do
      assert_equal [], Formats::Card.find(:all => fixture(:fake))
    end

    should "accept a :text option" do
      assert_not_equal [], Formats::Card.find(:text => open(fixture(:fauxtank)).read)
      assert_not_nil Formats::Card.find(:text => open(fixture(:fauxtank)).read)
    end
  end
end