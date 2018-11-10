describe Expense do
  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :project }
    it { should validate_presence_of :value }
    it { should validate_presence_of :amount }
    it { should validate_presence_of :date }
    it { should validate_presence_of :supplier }
    it { should validate_presence_of :currency }
    it { should validate_presence_of :exchangerate }
    it { should validate_presence_of :description }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_numericality_of(:value).is_greater_than(0) }
    it { should validate_numericality_of(:exchangerate).is_greater_than(0) }
  end

  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :project }
  end

  it "is audited" do
    expense = create(:expense)
    user = create(:user)

    Audited.audit_class.as_user(user) do
      expense.update_attribute(:amount, 2)
    end
    expect(expense.audits.last.user).to eq(user)
  end

  describe "#by_last_created_at" do
    it "orders the entries by created_at" do
      create(:expense)
      Timecop.scale(600)
      last_hour = create(:expense)
      expect(Expense.by_last_created_at.first).to eq(last_hour)
    end
  end

  describe "by_date" do
    it "orders the entries by date (latest first)" do
      create(:expense, date: Date.new(2014, 01, 01))
      latest = create(:expense, date: Date.new(2014, 03, 03))
      create(:expense, date: Date.new(2014, 02, 02))

      expect(Expense.by_date.first).to eq(latest)
    end

    it "#with_clients" do
      client = create(:client)
      create(:expense)
      create(:expense).project.update_attribute(:client, client)

      expect(Expense.with_clients.count).to eq(1)
    end
  end

  describe "calulates value" do
    let(:expense) { build(:expense) }
    it "calulates" do
      expense.amount = 100
      expense.exchangerate = 7.46
      expense.save
      expect(expense.value).to eq(746)
    end
  end
end
