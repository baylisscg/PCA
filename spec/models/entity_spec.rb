#
#
#

require "spec_helper"

describe Entity do
  subject {Entity.make}
  it_should_behave_like "a basic Entity"
end
