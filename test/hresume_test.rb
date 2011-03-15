require 'test_helper'
require 'mofo/hresume'

class HResumeTest < Test::Unit::TestCase
  context "A parsed hResume object" do
    setup do
      @hresume ||= HResume.find(:first => fixture(:hresume))
    end

    fields = {
      :contact    => HCard,
      # :education  => HCalendar,
      # :experience => Array,
      # :summary    => String,
      # :skills     => String
    }

    fields.each do |field, klass|
      should "have an #{klass} for #{field}" do
        assert_not_nil @hresume.send(field)
        assert_instance_of klass, @hresume.send(field)
      end
    end
  end
end