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
        
        @users = @user_limit.times.map do |n|
          User.make
        end

        # Create root certs
        @roots = @root_limit.times.map { |n| CertFactory.make_root( Cert.plan ) }
        @roots.each {|root| root.save }
        
        # Create user certs
        @user_cert = @users.each.map do |user|
          x = CertFactory.make(:user => user, 
                               :subject_dn => "cn=#{user.first_name} #{user.last_name},dc=example,dc=org",
                               :cert_hash=>"0xDEADBEEF",
                               :issuer => random(@roots))
          return x
        end
        
        @users.each {|user| user.save; puts "user #{user.name} #{user.credentials}"; }
        @user_cert.each {|cert| cert.save }
        
        @active_connections = [nil]

        @events = @events_limit.times { |n| self.add_event }

      end
      
      def random(array); array[rand(array.length)]; end

      #
      #
      #
      def add_event
        
        connection = random(@active_connections) #[rand(@active_connections.length)]          
        
        if not connection
          # Create a new connection
          user  = random(@users) #[rand(@user_limit)]
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
