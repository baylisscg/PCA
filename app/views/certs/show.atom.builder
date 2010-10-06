xml.instruct!
xml.feed("xmlns" => "http://www.w3.org/2005/Atom") do
  xml.title "Feed Name"
  xml.link :rel => :self, :href=>cert_url(@cert)
  xml.link :rel => :alternate, :href=>cert_url(@cert)
  xml.id certs_url
  xml.updated @conns.first.created_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @conns.any?
  @conns.each do |conn|
    xml.entry do
      xml.title  conn.id
      xml.link :rel => :alternate, :href => connection_url(conn)
      xml.id  cert_url(@cert)
      xml.updated conn.updated_at
      xml.summary conn.id
      xml.content :type => :html do
        xml.text! conn.to_s
      end
    end
  end
end
