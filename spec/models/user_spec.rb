#
#
#

require 'spec_helper'

describe User do

  let(:user) { User.make }
  
  specify { user.should be_valid }
  
  context "with no #name set" do
    
    let( :user ) { User.make }
    
    it_should_behave_like "a Person with no #name set" do
      subject { user }
      let( :first_name ) { user.first_name }
      let( :last_name) { user.last_name } 
    end
  end

end
