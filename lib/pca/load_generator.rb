#
#
#

require "#{Rails.root}/spec/support/blueprints"

require 'pca/event_generator'
require 'pca/logger'

#require "java"
#require "#{Rails.root}/lib/jars/slf4j-api-1.6.1.jar"
#require "#{Rails.root}/lib/jars/slf4j-simple-1.6.1.jar"

#java_import org.slf4j.Logger
#java_import org.slf4j.LoggerFactory

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
        
        @logger = Logger.get_logger("LoadGenerator")
        @logger.info "Test"

        @root_limit = args[:root]   || 5     # Default to 5 root cas 
        @user_limit = args[:users]  || 100    # Default to 100 users
        @events_limit = args[:events] || 10**3 # Default to creating 10000 events
        @start_date = args[:start_date] || (Time.now - 3628800) # Start 6 weeks ago
        @end_date   = args[:end_date]   || Time.now 
        
        @logger.info "Creating #{@root_limit} roots #{@user_limit} users #{@events_limit} events"

        @users = @user_limit.times.map do |n|
          User.make
        end

        # Create root certs
        @roots = @root_limit.times.map { |n| CertFactory.make_root( Cert.plan ) }
        @roots.each {|root| root.save }
        
        @logger.info "Made {} roots", @roots.length

        # Create user certs
        @user_cert = @users.each.map do |user|
          x = CertFactory.make(:user => user, 
                               :subject_dn => "cn=#{user.first_name} #{user.last_name},dc=example,dc=org",
                               :cert_hash=>"0xDEADBEEF",
                               :issuer => random(@roots))
          x
        end
        
        @logger.info "Made {} user certificates", @user_cert.length

        @users.each do |user|
          user.save
          @logger.debug "User {} {}", user.name, user.credentials
        end

        @logger.info "Made {} users",@users.length

        #@user_cert.each {|cert| cert.save }
        
        @active_connections = [nil]

        @events = @events_limit.times do |n|
          start = pick_start
          conn = self.make_connection(random(@users),start,pick_start(start))
          conn.save
        end

      end
      
      def random(array); array[rand(array.length)]; end

      @@event_generatror =  Digraph[:test]

      #
      #
      #      
      def make_connection(user, start_time, end_time)

        cred  = random(user.credentials)

        connection = Connection.make
        connection.cred = cred
        current_start = start_time
        picked_end    = pick_start( start_time, end_time)
        
        # Make 
        events = @@event_generatror.get_trace
         
        time_step = (picked_end - start_time)/events.length

        events.inject(nil) do |parent,event|
          new_event = if parent
                       Event.make(:parent=>parent,:created_at=>current_start,:action=>event.value)
                     else
                       Event.make(:created_at=>current_start,:action=>event.value)
                     end
          @logger.info "Event #{event.value} @ #{current_start}"
          current_start += time_step
          connection.events << new_event
          new_event.save
          new_event
        end

        connection
      end

      #
      #
      #
      def add_event
        
        connection = random(@active_connections) #[rand(@active_connections.length)]          
        
        if not connection
          # Create a new connection
          user  = random(@users) #[rand(@user_limit)]
          start = self.pick_start
          connection = Connection.make
          connection.cred = user
          connection.save
        end
        event = Event.make(:created_at=>start,:action=>"Test")
        event.save
        connection.events << event 

      end


      def self.to_time(time)
        return time if time.is_a? Time
        time.to_time      
      end

      #
      #
      #
      def pick_start(t_start=@start_date,t_end=@end_date)

        x = LoadGenerator.to_time(t_start)
        y = LoadGenerator.to_time(t_end)

#        @logger.info "#{x.class} #{y.class}"

        diff = y-x
        
        #@logger.info "#{x} #{y} = #{diff}"
        x + rand(diff)
     end

    end

  end
end
