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
  
  describe "#date_order" do
    let(:assignment) { create(:assignment) }

    it "can't allow valid_from to be later than valid_to" do
      expect(assignment.valid?).to be_truthy
      assignment.valid_from = 2.days.from_now
      assignment.valid_to = 2.days.ago
      expect(assignment.valid?).to be_falsey
    end
  end

  describe "#very short assignments" do
    let(:assignment) { create(:assignment) }

    it "allow valid_from to be same day as  valid_to" do
      expect(assignment.valid?).to be_truthy
      assignment.valid_from = 2.days.ago
      assignment.valid_to = 2.days.ago
      expect(assignment.valid?).to be_truthy
    end
  end

  describe "#being updateable" do
    let(:assignment) { create(:assignment) }
    
    it 'it can be updated' do
      expect(assignment.valid?).to be_truthy
      assignment.hourly_rate = 120
      expect(assignment.valid?).to be_truthy
    end
  end

  describe "#current assignments" do
    it "shows current assignments" do
      create(:assignment)
      create(:assignment_in_past)
      create(:assignment_in_future)
      expect(Assignment.current(1.day.ago).count).to eq 1
    end
  end

  describe "#current and recent assignments" do
    it "shows current and recent assignments" do
      create(:assignment)
      create(:assignment_in_past)
      create(:assignment_in_future)
      expect(Assignment.current_and_recent(1.day.ago).count).to eq 2
    end
  end

  describe "#non_overlapping_assignment" do
    let(:assignment) { create(:assignment) }
    let(:assignment_overlapping) { build(:assignment_overlapping) }
      
    it 'should have a valid factory' do
      expect(assignment.errors).to be_empty
    end

    it 'should have a valid factory' do
      expect(assignment_overlapping.errors).to be_empty
    end

    context 'when days overlap' do
      it 'raises an error that times overlap' do
        expect(assignment.valid?).to be_truthy
        
        assignment_overlapping.user = assignment.user
        assignment_overlapping.project = assignment.project
        
        expect(assignment_overlapping.valid?).to be_falsey
        expect(assignment_overlapping.errors[:base].size).to eq 1
      end
    end
  end
end