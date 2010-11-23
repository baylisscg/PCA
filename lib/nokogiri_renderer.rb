require 'nokogiri'

module ActionView
  module TemplateHandlers
    class Nokogiri < TemplateHandler
      include Compilable

      def compile(template)
        <<-eotemplate
#_set_controller_content_type(Mime::XML)
builder = ::Nokogiri::XML::Builder.new do |xml|
#{template.source}
end
builder.to_xml
eotemplate
      end
    end
  end
end

ActionView::Template.register_template_handler :nokogiri, ActionView::TemplateHandlers::Nokogiri
