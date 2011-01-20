RSpec::Matchers.define :be_expired do
  
  match do |model|
    model.expired?
  end

  failure_message_for_should do |model|
    
      "#{model.class} not expired."
    
  end

  failure_message_for_should_not do |model|
    "#{model.class} is expired" 
  end

end  
