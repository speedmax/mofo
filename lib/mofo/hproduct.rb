# => http://microformats.org/wiki/hproduct
require 'microformat'
require 'mofo/hcard'
require 'mofo/hreview'
require 'mofo/rel_tag'
require 'mofo/adr'
require 'mofo/geo'
require 'htmlentities'

class HProduct < Microformat
  container :hproduct

  one :fn!, :description, :url => :url, :brand => [ HCard, String ]
  
  one :price do
    # HTMLEntities.new.decode(text)
  end

  many :listing, :category => [ RelTag, String ], :review => HReview, :photo => :url

  many :identifer  do
    many :type
    many :value
  end
  
  # Hack: htmlentities decode
  after_find do
    instance_variable_set("@price", HTMLEntities.new.decode(price)) if respond_to?(:price)
  end
end
