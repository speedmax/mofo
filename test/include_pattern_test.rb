require 'test_helper'
require 'mofo/hcard'

class IncludePatternTest < Test::Unit::TestCase
  context "Multiple attributes within a container" do
    setup do
      @hcards    ||= HCard.find(:all => fixture(:hresume))
      @included  ||= @hcards.first
      @including ||= @hcards[1]
    end

    should "be referenceable by a microformat using the include pattern" do
      %w(fn n).each do |att|
        assert_equal @included.send(att), @including.send(att)
      end
    end
  end

  context "A single attribute" do
    setup do
      @horsed ||= HCard.find(:first => fixture(:include_pattern_single_attribute))
    end

    should "be referenceable by a microformat using the include pattern" do
      assert_not_nil @horsed.logo
      assert_equal Hpricot(open(fixture(:include_pattern_single_attribute))).at("#logo").attributes['src'], @horsed.logo
    end
  end
end