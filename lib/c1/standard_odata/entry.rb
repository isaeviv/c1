require 'nokogiri'
require 'rest_client'

module C1
  module StandardOdata
    class Entry
      PROPS = []

      def self.resource_id
        @resource_id  
      end

      def self.resource_id=(resource_id)
        @resource_id = resource_id
      end

      def self.properties
        [:Ref_Key] + self.const_get(:PROPS)
      end

      def self.find guid
        response = RestClient::Request.execute(method: :get, 
          url: URI.encode("#{C1.configuration.odata_url}/#{self.resource_id}(guid'#{guid}')"), 
          payload: nil, user: C1.configuration.user, password: C1.configuration.password)

        xml = Nokogiri::XML(response)
        xml.remove_namespaces!

        assign_attributes Hash[self.properties.map{ |p| [p, xml.xpath("//content/properties/#{p}").inner_text] }]

        true
      end

      def initialize(attrs = {})
        self.class.class_eval{ attr_accessor *properties }
        assign_attributes(attrs) if attrs

        super()
      end


      def save
        if @Ref_Key
          # TODO
        else
          create_new_entry
        end
      end

      def call method
        RestClient::Request.execute(method: :post, 
          url: URI.encode("#{C1.configuration.odata_url}/#{self.class.resource_id}(guid'#{@Ref_Key}')/#{method}"), 
          payload: nil, user: C1.configuration.user, password: C1.configuration.password)
      end

      def to_xml
        builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.entry do
            xml.category(term: "StandardODATA.#{self.class.resource_id}", scheme: "http://schemas.microsoft.com/ado/2007/08/dataservices/scheme")
            xml.title

            xml.updated Time.now.strftime '%Y-%m-%dT%H:%M:%S%z'
            xml.author
            xml.summary

            xml.content(type: 'application/xml') do
              xml[:m].properties(:'xmlns:d' => "http://schemas.microsoft.com/ado/2007/08/dataservices", :'xmlns:m' => "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata") do
                self.class.properties.each do |name|
                  next if name.to_sym == :Ref_Key
                  xml[:d].send(name, self.instance_variable_get("@#{name}"))
                end
              end
            end
          end
        end

        builder.doc.root.to_xml
      end

    private
      def create_new_entry
        response = RestClient::Request.execute(method: :post, 
          url: URI.encode("#{C1.configuration.odata_url}/#{self.class.resource_id}"), 
          payload: to_xml, user: C1.configuration.user, password: C1.configuration.password)

        xml = Nokogiri::XML(response)
        xml.remove_namespaces!

        assign_attributes Hash[self.class.properties.map{ |p| [p, xml.xpath("//content/properties/#{p}").inner_text] }]

        true
      end

      def assign_attributes(attrs)
        attrs.each{ |k, v| self.send("#{k}=", v) }
      end

    end
  end
end
