require 'test_helper'
require 'mofo/hproduct'

class HProductTest < Test::Unit::TestCase

  context "A parsed hProduct object " do
    setup do
      @product ||= HProduct.find(:first => fixture('hproduct/hproduct1'))
    end
    
    should 'have fn (formatted name) is a singular value' do
      assert_equal 'Samsung LE32B450', @product.fn
    end
    
    should 'have price as a singular value' do
      assert_equal '£305', @product.price
    end
    
    should 'have brand as a singular value, optionally a HCard' do
      assert_kind_of(HCard, @product.brand)

      assert_equal 'Samsung', @product.brand.fn
    end
    
    should 'have url as a singular value' do
      assert 'http://www.reevoo.com/p/samsung-le32b450', @product.url
    end
  end
  
  context "A parsed hProduct object multiple" do
    setup do
      @product ||= HProduct.find(
        :first => fixture('hproduct/hproduct2'),
        :base_url => 'http://example.org/images/products/'
      )
    end
    
    should "have many photo(s)" do
      assert_kind_of Array, @product.photo
      assert_equal "http://example.org/images/products/../images/photo.gif", @product.photo.first
    end
    
    should "have many review(s)" do
      assert_kind_of HReview, @product.review.first
      assert_equal 2, @product.review.length
    end
    
    should "have many listing(s)" do
      assert_kind_of Array, @product.listing
      assert_equal 2, @product.listing.length
    end
  end
end