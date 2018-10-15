class Expense < Entry
  
  validates :user, :project, :date, :amount, :value, presence: true
  validates :description, :currency, :exchangerate, :supplier, presence: true
  validates :amount, :numericality => { :greater_than => 0, only_integer: false }
  validates :value, :numericality => { :greater_than => 0, only_integer: false }
  validates :exchangerate, :numericality => { :greater_than => 0, only_integer: false }
  
  has_attached_file :receipt,
                    styles: { thumb: ["32x32#", :png]},
                    default_url: "",
                    s3_protocol: ""
  validates_attachment_content_type :receipt, content_type: /\Aimage\/.*\Z/

  scope :by_last_created_at, -> { order("created_at DESC") }
  scope :by_date, -> { order("date DESC") }
  scope :billable, -> { where("billable").joins(:project) }
  scope :with_clients, -> { where.not("projects.client_id" => nil).joins(:project) }
  scope :in_year,      lambda {|year| where("extract(year from date) = ?", year)}
  scope :in_month,     lambda {|month| where("extract(month from date) = ?", month)}
  scope :date_between, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}

  before_validation :calculate_value

  def calculate_value
    if amount && exchangerate
      self.value = amount * exchangerate
    end
  end

  def receipt_url
    receipt.url(:original)
  end

  def receipt_thumb
    receipt.url(:thumb)
  end

  def self.query(params, includes = nil)
    EntryQuery.new(self.includes(includes).by_date, params, "expenses").filter
  end
end