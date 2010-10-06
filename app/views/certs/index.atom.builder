xml.instruct!
xml.feed("xmlns" => "http://www.w3.org/2005/Atom") do
  xml.title "Feed Name"
  xml.link :rel => :self, :href=>certs_url
  xml.link :rel => :alternate, :href=>certs_url
  xml.id certs_url
  xml.updated @certs.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @certs.any?
  @certs.each do |cert|
    xml.entry do
      xml.title  cert.sha
      xml.link :rel => :alternate, :href => cert_url(cert)
      xml.id  cert_url(cert)
      xml.updated cert.updated_at
      xml.summary cert.subject_dn
      xml.content :type => :html do
        xml.text! cert.to_s
      end
    end
  end
end
