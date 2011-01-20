RSpec::Matchers.define :be_valid do
  
  match do |model|
    valid = model.valid?
    @errors = model.errors unless valid
    valid
  end

  failure_message_for_should do |model|
    
      "#{model.class} not valid due to "+@errors.full_messages.join
    
  end

  failure_message_for_should_not do |model|
    "#{model.class} valid due to "+@errors.class.to_s
  end

end  
