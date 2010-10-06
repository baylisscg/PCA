xml.instruct!
xml.feed("xmlns" => "http://www.w3.org/2005/Atom") do
  xml.title "Feed Name"
  xml.link :rel => :self, :href=>event_url(@event)
  xml.link :rel => :alternate, :href=>event_url(@event)
  xml.id_ certs_url
  xml.updated @event.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
  xml.posts do
    xml.post do
    end
  end
end
