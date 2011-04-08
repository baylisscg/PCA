#
#
#

require 'html5'

module RSpec
  module Matchers
    class HTML
      
      def matches?(document)
        @parser = HTML5::HTMLParser.new()
        @parser.parse(document)
        @errors = @parser.errors
        @errors == []
      end

      #
      #
      #
      def failure_message_for_should
        
        result = "Supplied document has the following errors"
        @errors.each { |error| result << sprintf("%s: %s %s\n",error[0].join('\n'),error[1],error[2].to_s) }
        result
      end

      #
      #
      #
      def failure_message_for_should_not
        "supplied HTML document conforms to schema." 
      end

    end

    def be_html5
      HTML.new
    end
    
    def be_html
      HTML.new
    end
    
  end
end
