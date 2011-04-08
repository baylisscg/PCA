#
#
#

require 'pca/event_generator'

#
# 
#
def make_connection(args={})

  def pick_start(t_start,t_end)
    x = if t_start.is_a? Time then; t_start; else; t_start.to_time end
    y = if t_end.is_a? Time then; t_end; else; t_end.to_time end
    diff = y-x
    x + rand(diff)
  end

  user = args[:user] || User.make_unsaved
  cred = args[:cert] || Cert.make_unsaved 
  start_time = args[:start_time] || (Time.now - 3628800)
  end_time   = args[:end_time] || Time.now

  event_generatror = Digraph[:test]

  
  
  connection = Connection.make
  connection.cred = cred
  current_start = start_time
  picked_end    = pick_start( start_time, end_time)
        
  # Make events
  events = event_generatror.get_trace
  
  time_step = (picked_end - start_time)/events.length
  
  events.inject(nil) do |parent,event|
    new_event = if parent
                  Event.make(:parent=>parent,:created_at=>current_start,:action=>event.value)
                else
                  Event.make(:created_at=>current_start,:action=>event.value)
                end
    current_start += time_step
    connection.events << new_event
    new_event
  end
  
  return connection
end


