describe Client do
  let(:client) { create(:client) }

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :companyname }
    it { should validate_presence_of :adress }
    it { should validate_presence_of :postalcode }
    it { should validate_presence_of :otherinfo }
    it { should validate_presence_of :invoiceemail }
    it { should validate_presence_of :paymentterms }
  end

  describe "uniqueness" do
    subject { FactoryGirl.build(:client) }    
    it { should validate_uniqueness_of :name }
  end

  describe "associations" do
    it { should have_many :projects }
  end

  describe "#by_name" do
    it "orders by name case insensitive" do
      create(:client, name: "B")
      a = create(:client, name: "a")
      expect(Client.by_name.first).to eq(a)
    end
  end

  describe "#logo_url" do
    context "when it is set" do
      it "returns the uploaded image" do
        fake_logo = "logo.png"
        client = build(:client, logo: fixture_file_upload(fake_logo))
        expect(client.logo_url).to eq(client.logo.url(:original))
      end
    end
  end
end