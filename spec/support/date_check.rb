#
#
#

module PCA
  module Matchers
    class TimeEqual

      def initialize(expected)
        @expected = expected
      end

      def matches?(target)
        @target = target
        @expected - @target < 1.0
      end

      def failure_message
        "expected #{@target} to be within 1ms of #{@expected} was #{@expected - @target}"
      end
      
      def negative_failure_message
        "expected #{@target.inspect} not to be in within 1ms of #{@expected} was  #{@expected - @target}"
      end
    end

    def be_equal_to_time(expected)
      TimeEqual.new(expected)
    end
    
  end
end
