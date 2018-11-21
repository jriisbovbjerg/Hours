
class Mileage < Entry
  
  validates :user, :project, :date, :value, presence: true
  validates :from_adress, :to_adress, presence: true
  validates :value, :numericality => { :greater_than => 0, only_integer: true }
  
  scope :by_last_created_at, -> { order("created_at DESC") }
  scope :by_date, -> { order("date DESC") }
  scope :billable, -> { where("billable").joins(:project) }
  scope :with_clients, -> { where.not("projects.client_id" => nil).joins(:project) }
  scope :in_year,     lambda {|year| where("extract(year from date) = ?", year)}
  scope :in_month,     lambda {|month| where("extract(month from date) = ?", month)}
  scope :date_between, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}
  scope :taxfree,    -> { where(taxfree: true) }
  scope :nontaxfree, -> { where(taxfree: false)}

  def description
    "#{from_adress} -> #{to_adress}"
  end
  
  def self.query(params, includes = nil)
    EntryQuery.new(self.includes(includes).by_date, params, "mileages").filter
  end
end
