require 'test_helper'
require 'mofo/hcalendar'

class HCalendarTest < Test::Unit::TestCase

  context "A parsed hCalendar object with an embedded hCard" do
    setup do
      @hcalendar_hcard ||= HCalendar.find(:first => fixture(:upcoming_single))
    end
    should "should have an HCard for its location" do
      assert_instance_of HCard, @hcalendar_hcard.location
    end
  end
  context "A parsed hCalendar object with embedded adr" do
    setup do
      @hcalendar_addr ||= HCalendar.find(:first => fixture(:event_addr))
    end
    should "have an Adr for its location" do
      assert_instance_of Adr, @hcalendar_addr.location
    end
  end
  context "A parsed hCalendar object with string location" do
    setup do
      @hcalendar_string ||= HCalendar.find(:first => fixture(:upcoming))
    end
    should "have a string for its location" do
      assert_instance_of String, @hcalendar_string.location
      assert_not_nil @hcalendar_string.location
    end
  end

end