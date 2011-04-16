#
#
#

module PCA
  module Matchers
    class TimeEqual

      def initialize(expected,mode=:equal)
        @expected = expected
        @mode = mode
      end

      def less_than
        @diff < -1.0 
      end

      def greater_than
        @diff > 1.0 
      end

      def equality
        not less_than || greater_than
      end

      def matches?(target)
        @target = target
        @diff =  @target - @expected
        if @mode == :equals
          return equality
        elsif @mode == :less_than
          return less_than
        elsif @mode == :greater_than
          return greater_than
        end
      end

      def failure_message
        "expected #{@target} to be within 1ms of #{@expected} was #{@diff}"
      end
      
      def negative_failure_message
        "expected #{@target.inspect} not to be in within 1ms of #{@expected} was  #{@diff}"
      end
    end

    def be_equal_to_time(expected)
      TimeEqual.new(expected,:equals)
    end
    
    def be_less_than_time(expected)
      TimeEqual.new(expected,:less_than)
    end

    def be_greater_than_time(expected)
      TimeEqual.new(expected,:greater_than)
    end

  end
end

RSpec.configure do |config|
  
  config.include(PCA::Matchers)

end
