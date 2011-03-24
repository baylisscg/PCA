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

        @active_connections = [nil]

        @events = @events_limit.times { |n| self.add_event }

      end
      
      #
      #
      #
      def add_event
        
        connection = @active_connections[rand(@active_connections.length)]          
        
        if not connection
          # Create a new connection
          user  = @users[rand(@user_limit)]
          start = self.pick_start
          connection = Connection.make()
          connection.cred = user
        end
        event = Event.new(:created_at=>start,:action=>"Test")
        connection.events << event 

      end


      #
      #
      #
      def pick_start(t_start=@start_date,t_end=@end_date)
        rand(t_end - t_start)
      end

    end

  end
end
