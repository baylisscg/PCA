
module PCA::Generator


  class EventGenerator
    include Enumerable

    GSI_CONNECT = "gsi_connect"
    GSI_SUCCESS = "gsi_success"
    GSI_FAILURE = "gsi_failure"

    GRAM_SUBMIT   = "gram_submit"
    GRAM_SUCCESS  = "gram_success"
    GRAM_FAILURE  = "gram_failure"
    GRAM_COMPLETE = "gram_complete"

    WMS_SUBMIT = "wms_submit"

    def initalize
      @state = {}
      reset
    end

    def reset
      @state = {"depth"  => 1,
        "state"  => "gsi_connect",
        "next_op" => ACTION_TABLE["gsi_connect"]}
      end

      def self.select_weighted(targets)
        limit = targets.inject( 0 ) { |sum,x| sum+x[1] }
        total = rand(limit)
        targets.each do |name,weight|
          return name if total <= weight
          total -= weight
        end
      end

      #
      #
      #
      def self.gsi_connect(args)
        depth = 1 || args["depth"]
        return GSI_FAILURE if depth >= 10 # Fail if we are 10  or more calls deep (simulate max )
        return select_weighted [GSI_SUCCESS, GSI_FAILURE].zip([9,1]) # 1:10 chance of failure
      end

      def self.gsi_success(args)
        depth = args["depth"] || 1
        weights = [2**(depth-2),2]
        return select_weighted [GRAM_SUBMIT,WMS_SUBMIT].zip(weights) # exponentially decreasing odds of a WMS submit as depth grows
      end

      def self.gram_submit(args)
        depth = args["depth"] || 1
        return select_weighted [GRAM_SUCCESS, GRAM_FAILURE].zip([9,1]) # 1:10 chance of failure
      end

      def self.gram_success(args)
        depth = args["depth"] || 1
        weights = [2,2**(depth-2)]
        return select_weighted  [GSI_CONNECT, GRAM_COMPLETE].zip(weights) #
      end

      ACTION_TABLE = {
        GSI_CONNECT   => Proc.new { |args| gsi_connect(args) },
        GSI_SUCCESS   => Proc.new { |args| gsi_success(args) },
        GSI_FAILURE   => nil,
        GRAM_SUBMIT   => Proc.new { |args| gram_submit(args) },
        GRAM_SUCCESS  => Proc.new { |args| gram_success(args) },
        GRAM_FAILURE  => nil,
        GRAM_COMPLETE => nil,
        WMS_SUBMIT    => Proc.new { |args| GSI_CONNECT },
      }


      #
      #
      #
      def each

        yield "gsi_connect"
        state = {"depth"  => 1,
          "state"  => "gsi_connect",
          "next_op" => ACTION_TABLE["gsi_connect"]}

          while state["next_op"]
            state["state"]   = state["next_op"].call(state)
            state["next_op"] = ACTION_TABLE[state["state"]]
            state["depth"]   += 1
            yield state["state"]
          end
        end

      end
    end
