xml.instruct!
xml.feed("xmlns" => "http://www.w3.org/2005/Atom") do
  xml.title "Feed Name"
  xml.link :rel => :self, :href=>connections_url+".atom"
  xml.link :rel => :alternate, :href=>connections_url
  xml.id connections_url
  xml.updated @conns.first.created_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @conns.any?
  @conns.each do |conn|
    xml.entry do
      xml.title conn.server+" <-> "+conn.peer
      xml.link :rel => :alternate, :href => connection_url(conn)
      xml.link :rel => :alternate, :type=>Mime::ATOM , :href => connection_url(conn)+".atom"
      xml.id  conn.id
      xml.updated conn.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.summary conn.id
      xml.content :type => :html do
        xml.text! conn.server
      end
    end
  end
end
