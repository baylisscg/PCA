#
#
#

#
#
#
Service.blueprint do
  tag {"tag:exmaple.org,2011:example"}
  url { "http://example.org" }
end

#
#
#
Person.blueprint do
  first_name {Faker::Name.first_name}
  last_name  {Faker::Name.last_name}
  name { "#{first_name} #{last_name}" }
  tag   {"tag:example.org:user:#{first_name}_#{last_name}"}
  url  {"http://user.example.org/#{first_name}/#{last_name}"}
end

PCA::Objects::GRAM.blueprint do; end
PCA::Objects::GSI.blueprint do; end
PCA::Objects::WMS.blueprint do; end

class ServiceFactory 

  @@gram = PCA::Objects::GRAM.make(:tag=>"tag:example.org,2011:Service/GRAM",
                                   :name=>"Test GRAM service",
                                   :url =>"http://example.org/gram")
  @@gsi = PCA::Objects::GSI.make(:tag=>"tag:example.org,2011:Service/GSI",
                                 :name=>"Test GSI service",
                                 :url =>"http://gram.example.org/gsi")
  @@wms = PCA::Objects::WMS.make(:tag=>"tag:example.org,2011:Service/wms",
                                 :name=>"Test WMS service",
                                 :url =>"http://example.org/wms")
    
  class << self
    attr_reader :gram, :gsi, :wms
  end

end
