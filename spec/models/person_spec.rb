#
#
#

require 'spec_helper'

#
#
#
shared_examples_for "a Person with no #name set" do
  it { should be_valid }
  its(:name) { should == "#{first_name} #{last_name}" }
end

describe Person do

  subject { Person.make }

  it_should_behave_like "a basic Entity"

  context "no #name set" do

    let( :user ) { Person.make }

    it_should_behave_like "a Person with no #name set" do
      subject { user }
      let( :first_name ) { user.first_name }
      let( :last_name) { user.last_name } 
    end
  end
end
