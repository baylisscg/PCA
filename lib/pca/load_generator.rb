#
#
#

require "#{Rails.root}/spec/support/blueprints"

module PCA
  module Generator
    
    #
    #
    #
    class LoadGenerator

      #
      #
      #
      def initialize(args={})
        @root_limit = args[:root]   || 5     # Default to 5 root cas 
        @user_limit = args[:users]  || 100    # Default to 100 users
        @events_limit = args[:events] || 10**3 # Default to creating 10000 events
        @start_date = args[:start_date] || (Time.now - 3628800) # Start 6 weeks ago
        @end_date   = args[:end_date]   || Time.now 
        
        # Create root certs
        @roots = @root_limit.times.map { |n| CertFactory.make_root( Cert.plan ) }
        @roots.each {|root| root.save }
        
        # Create user certs
        @users = @user_limit.times.map do |n|
          params = Cert.plan
          params[:issuer] = @roots[rand(@root_limit)]  
          CertFactory.make(params)
        end
        
        self.pick_start
        # @events = @events_limit.times.map do |n|
          
        # end

      end

      #
      #
      #
      def pick_start
        range = @end_date - @start_date
        start = rand(range)
        puts "Range = #{range} start = #{@start_date+start}"
        start
      end

    end

  end
end
