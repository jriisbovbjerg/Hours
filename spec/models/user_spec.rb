describe User do
  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :slug }
    it { should validate_uniqueness_of :slug }
  end

  describe "associations" do
    it { should have_one :account }
    it { should belong_to :organization }
    it { should have_many :hours }
    it { should have_many :mileages }
  end

  describe "#label" do
    it "returns the users full name" do
      user = create(:user, first_name: "Karel", last_name: "Appel")
      expect(user.label).to eq("Karel Appel")
    end
  end

  describe "#full_name" do
    it "returns the users full name" do
      user = create(:user, first_name: "John", last_name: "Doe")
      expect(user.full_name).to eq("John Doe")
    end
  end

  describe "generating unique slugs" do
    it "uses the full name when available" do
      user = create(:user, first_name: "Phillip", last_name: "Fry")
      expect(user.slug).to eq("phillip-fry")
    end

    it "uses the full name with an index when the full name is taken" do
      create(:user, first_name: "Phillip", last_name: "Fry")
      user_with_same_name = create(:user, first_name: "Phillip", last_name: "Fry")
      expect(user_with_same_name.slug).to eq("phillip-fry-1")
    end
  end

  describe "#email_domain" do
    it "returns the users email domain" do
      user = build(:user, email: "test@example.com")
      expect(user.email_domain).to eq("example.com")
    end
  end

  describe "#color" do
    it "is the pastel color for the first and last names" do
      expect(build(:user).color).to eq "#7BD95C"
    end
  end

  describe "#acronyms" do
    it "is an acronym of the user's name" do
      user = build(:user, first_name: "Andy", last_name: "Stabler")
      expect(user.acronyms).to eq "AS"
    end
  end
end
