xml.instruct!
xml.declare! :DOCTYPE, :html
xml.html( "xmlns" => "http://www.w3.org/1999/xhtml" ) {
  xml.head{
    xml << ( javascript_include_tag "prototype")
    xml << ( stylesheet_link_tag "main")
    xml << ( yield :head )
  }
  xml.body {
    xml << yield
  }
}
