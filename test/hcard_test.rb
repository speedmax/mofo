require 'test_helper'
require 'mofo/hcard'
require 'mofo/hreview'

class HCardTest < Test::Unit::TestCase

  context "A simple hcard definition" do
    should "parse a page with an hcard" do
      assert_nothing_raised do
        HCard.find(fixture(:fauxtank))
      end
    end

    should "raise an error if no hcard is found in strict mode" do
      assert_raise MicroformatNotFound do
        HCard.find(fixture(:fake), :strict => true)
      end
    end

    should "return an empty array if no hcard is found" do
      assert_equal [], HCard.find(fixture(:fake))
    end

    should "return nil if no hcard is found with :first" do
      assert_nil HCard.find(:first => fixture(:fake))
    end

    should "return empty array if no hcard is found with :all" do
      assert_equal [], HCard.find(:all => fixture(:fake))
    end

    should "accept a :text option" do
      assert_not_equal [], HCard.find(:text => open(fixture(:fauxtank)).read)
      assert_not_nil HCard.find(:text => open(fixture(:fauxtank)).read)
    end
  end

  context "The hCard found in the upcoming_single page" do
    setup do
      @upcoming_text = HCard.find(:text => open(fixture(:upcoming_single)).read)
      @upcoming_find = HCard.find(fixture(:upcoming_single))
    end

    should "be identical whether passed as :text or found with default method" do
      assert_equal @upcoming_find.fn, @upcoming_text.fn
      assert_equal @upcoming_find.org, @upcoming_text.org
      assert_equal @upcoming_find.adr.base_url, @upcoming_text.adr.base_url
      assert_equal @upcoming_find.adr.postal_code, @upcoming_text.adr.postal_code
      assert_equal @upcoming_find.adr.locality, @upcoming_text.adr.locality
      assert_equal @upcoming_find.adr.region, @upcoming_text.adr.region
      assert_equal @upcoming_find.adr.street_address, @upcoming_text.adr.street_address
      assert_equal @upcoming_find.geo.longitude, @upcoming_text.geo.longitude
      assert_equal @upcoming_find.geo.latitude, @upcoming_text.geo.latitude
    end
  end

  context "The parsed fauxtank hCard object" do
    setup do
      @fauxtank ||= HCard.find(:first => fixture(:fauxtank))
    end

    should "be an instance of HCard" do
      assert_instance_of HCard, @fauxtank
    end

    should "have `fauxtank' as the nickname" do
      assert_equal "fauxtank", @fauxtank.nickname
    end

    should "have two email addresses" do
      assert_equal 2, @fauxtank.email.size
      assert_equal "fauxtank [at] gmail.com", @fauxtank.email.first
      assert_equal "chris [at] fauxtank.com", @fauxtank.email.last
    end

    should "have `Chris' as the given name" do
      assert_equal "Chris", @fauxtank.n.given_name
    end

    should "have `Murphy' as the family name" do
      assert_equal "Murphy", @fauxtank.n.family_name
    end

    should "have `Chicago' as the locality" do
      assert_equal "Chicago", @fauxtank.adr.locality
    end

    should "have `United States' as the country-name" do
      assert_equal "United States", @fauxtank.adr.country_name
    end

    should "have fauxtank's profile pic as the logo" do
      assert_equal "http://static.flickr.com/25/buddyicons/89622800@N00.jpg?1128967902", @fauxtank.logo
    end

    should "know what properties it found" do
      assert_equal ["fn", "note", "n", "email", "logo", "adr", "nickname", "title", "url"].sort, @fauxtank.properties.sort
    end
  end

  context "The parsed Bob hCard object" do
    setup do
      @bob ||= HCard.find(:first => fixture(:bob))
    end

    should "have three valid emails with type information" do
      assert_equal 3, @bob.email.value.size
      assert_equal 'home', @bob.email.type.first
      assert_equal 'bob@gmail.com', @bob.email.value.first
      assert_equal 'work', @bob.email.type[1]
      assert_equal 'robert@yahoo.com', @bob.email.value[1]
      assert_equal 'home', @bob.email.type.last
      assert_equal 'bobby@gmail.com', @bob.email.value.last
    end

    should "have two valid telephone numbers with type information" do
      assert_equal 2, @bob.tel.type.size
      assert_equal 'home', @bob.tel.type.first
      assert_equal '707-555-9990', @bob.tel.value.first
      assert_equal 'cell', @bob.tel.type.last
      assert_equal '707-555-4756', @bob.tel.value.last
    end

    should "have a given, additional, and family name" do
      assert_equal 'Robert', @bob.n.given_name
      assert_equal 'Albert', @bob.n.additional_name
      assert_equal 'Smith', @bob.n.family_name
    end

    should "have a valid postal code" do
      assert_equal '01234', @bob.adr.postal_code
    end

    should "have a valid url" do
      assert_equal "http://nubhub.com/bob", @bob.url
    end
  end

  context "The parsed Stoneship hCard objects" do
    setup do
      @stoneship ||= HCard.find(:all => fixture(:stoneship))
    end

    should "only have String nicknames" do
      @stoneship.collect { |h| h.nickname }.compact.uniq.each do |nickname|
        assert_instance_of String, nickname
      end
    end

    should "ignore broken urls" do
      assert_nil @stoneship.first.logo
    end
  end

  context "The parsed simple hCard object" do
    setup do
      @simple ||= HCard.find(:first => fixture(:simple))
    end

    should "have an org string" do
      assert_instance_of String, @simple.org
      assert_equal "Err the Blog", @simple.org
    end

    should "have an email string" do
      assert_instance_of String, @simple.email
      assert_equal "chris[at]ozmm[dot]org", @simple.email
    end

    should "have a valid name" do
      assert_equal "Chris Wanstrath", @simple.fn
    end

    should "have a valid url" do
      assert_equal "http://ozmm.org/", @simple.url
    end
  end
end