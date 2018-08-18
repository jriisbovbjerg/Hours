class Expense < Entry
  
  validates :user, :project, :date, :value, presence: true
  validates :description, :currency, :exchangerate, :supplier, presence: true
  validates :value, :numericality => { :greater_than => 0, only_integer: false }
  validates :exchangerate, :numericality => { :greater_than => 0, only_integer: false }
  
  scope :by_last_created_at, -> { order("created_at DESC") }
  scope :by_date, -> { order("date DESC") }
  scope :billable, -> { where("billable").joins(:project) }
  scope :with_clients, -> {
    where.not("projects.client_id" => nil).joins(:project)
  }

  def self.query(params, includes = nil)
    EntryQuery.new(self.includes(includes).by_date, params, "expenses").filter
  end
end