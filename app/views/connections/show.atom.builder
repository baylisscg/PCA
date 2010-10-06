xml.instruct!
xml.feed("xmlns" => "http://www.w3.org/2005/Atom") do
  xml.title "Feed Name"
  xml.link :rel => :self, :href=>connection_url(@conn)
  xml.link :rel => :alternate, :href=>connection_url(@conn)
  xml.id @conn.id
  xml.updated @conn.events.first.created_at.strftime "%Y-%m-%dT%H:%M:%SZ" 
  @conn.events.each do |event|
    xml.entry do
      xml.title event.action
      xml.link :rel => :alternate, :href => event_url(event)
      xml.id  event.id
      xml.updated event.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.summary event.action
      xml.content :type => :html do
        xml.text! event.to_s
      end
    end
  end
end
