xml.connection :id => connection_path(@connection),
               :server => @connection.server,
               :peer   => @connection.server,
               :credential => credential_path(@connection.cred_id) do
  @connection.events.each do |event| 
      xml.event :action => event.action,
                :date   => event.created_at
  end
end

               
