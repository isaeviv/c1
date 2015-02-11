require 'c1'
require 'lib/product'

describe Product do
  it { is_expected.to be_kind_of(C1::StandardOdata::Entry) }

  subject{ Product.new(:'Description' => 'Шлепанцы', :'Описание' => '&lt;html&gt;Шлепанцы пляжные&lt;/html&gt;') }

  before do
    C1.configure do |config|
      config.odata_url = 'http://host/base/odata/standard.odata'
      config.user = 'user'
      config.password = 'password'
    end
  end

  describe '#save' do
    it { 
      expect(RestClient::Request).to receive(:execute).with(
        method: :post, 
        url: URI.encode('http://host/base/odata/standard.odata/Catalog_Товары'),
        payload: subject.to_xml(),
        user: 'user',
        password: 'password'
      );
      subject.save 
    }

    context '#new_record?' do
      before { allow_any_instance_of(RestClient::Request).to receive(:execute).and_return(File.read("spec/fixtures/201_created.xml")) }
  
      it { expect(subject.save).to be true }
      it { subject.save; expect(subject.Ref_Key).not_to be_nil }
    end

    context '!#new_record?' do

    end
  end

  describe '#call' do
    let(:guid) { subject.Ref_Key = SecureRandom.uuid }
    it { 
      expect(RestClient::Request).to receive(:execute).with(
        method: :post, 
        url: URI.encode("http://host/base/odata/standard.odata/Catalog_Товары(guid'#{guid}')/Start()"),
        payload: nil,
        user: 'user',
        password: 'password'
      );
      subject.call('Start()')
    }
  end
end