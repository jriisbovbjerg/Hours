describe Assignment do
  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :project }
    it { should validate_presence_of :valid_from }
    it { should validate_presence_of :valid_to }
    it { should validate_presence_of :currency }
    it { should validate_presence_of :hourly_rate }

  end

  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :project }
  end

  describe "#active assignments" do
    it "shows active assignments" do
      create(:assignment)
      create(:assignment_in_past)
      create(:assignment_in_future)
      expect(Assignment.current(1.day.ago).count).to eq 1
    end
  end

  describe "#recent assignments" do
    it "shows recent assignments" do
      create(:assignment)
      create(:assignment_in_past)
      create(:assignment_in_future)
      expect(Assignment.current_and_recent(1.day.ago).count).to eq 2
    end
  end
end