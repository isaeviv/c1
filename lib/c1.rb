require "c1/version"
require "c1/standard_odata/entry.rb"

module C1
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :odata_url, :user, :password
  end
end

# class WebAnketa < C1::StandardODATA::Entry
#   self.resource_id = 'BusinessProcess_ВебАнкетаДоговор'
# end

# class Task < WebAnketa
#   self.resource_id = 'BusinessProcess_Задача'
# end

# WebAnketa.new.collection
# Task.new.collection
# require 'nokogiri'
# require 'rest_client'



# user = 'WebService'
# pass = 'admin'



# # begin
# response = RestClient::Request.execute(method: :post, url: URI.encode('http://WebService:admin@10.10.102.81:8090/serg/odata/standard.odata/BusinessProcess_ВебАнкетаДоговор'), payload: builder.doc.root.to_xml, user: user, password: pass)
#   # response = RestClient.post(URI.encode('http://10.10.102.81:8090/serg/odata/standard.odata/BusinessProcess_ВебАнкетаДоговор'), builder.doc.root.to_xml, {  })

# puts response.to_s

#   # .remove_namespaces!
#   # .xpath("//content/Ref_Key")
# # rescue => e
# #   puts e.response
# # end

# # body = Nokogiri::XML(xml)

# # response = RestClient.post(URI.encode("http://WebService:admin@10.10.102.81:8090/serg/odata/standard.odata/BusinessProcess_ВебАнкетаДоговор(guid'e7abf006-ac6f-11e4-b6a8-5cf3fc3a294e')/Start()"), nil)
# # puts response.to_s



