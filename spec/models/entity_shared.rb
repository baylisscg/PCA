#
#
#

shared_examples_for "a basic Entity" do

  # tag replaces id here
  its(:tag) { should_not be_nil }
  its(:object_type) { should == described_class::Object_Type }

#  its(:name) { should_not be_nil}
#  its(:summary) { should_not be_nil }
#  its(:object_type) { should_not be_nil}

  it { should respond_to(:to_atom) }
  it { should respond_to(:to_yaml) }

end
