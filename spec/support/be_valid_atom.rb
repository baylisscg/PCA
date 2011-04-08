#
#
#

require 'nokogiri'
require 'pca/atom'

module RSpec
  module Matchers
    class Atom

      RELAX_NG = Nokogiri::XML::RelaxNG(File.open(::Rails.root.join("lib/schema/atom.rng")))

      #
      #
      #
      def matches?(document)
        doc = Nokogiri::XML(document)
        @errors = RELAX_NG.validate doc
        @errors == []
      end

      #
      #
      #
      def failure_message_for_should
    
        result = "Supplied document has the following errors"
    
        @errors.each { |error| result << error.mesage }

        result
      end

      def failure_message_for_should_not
        "supplied ATOM document conforms to schema." 
      end

    end

    #
    #
    #
    def be_valid_atom
      Atom.new
    end

  end
end  

