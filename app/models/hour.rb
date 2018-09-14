
class Hour < Entry
  audited allow_mass_assignment: true

  belongs_to :category

  has_many :taggings, inverse_of: :hour
  has_many :tags, through: :taggings

  validates :category, presence: true
  validates :user, :project, :date, :value, presence: true
  validates :value, :numericality => { :greater_than => 0 }

  accepts_nested_attributes_for :taggings

  scope :by_last_created_at, -> { order("created_at DESC") }
  scope :by_date, -> { order("date DESC") }
  scope :billable, -> { where("billable").joins(:project) }
  scope :with_clients, -> {
    where.not("projects.client_id" => nil).joins(:project)
  }

  before_save :set_tags_from_description
  before_save :value

  def tag_list
    tags.map(&:name).join(", ")
  end

  def self.query(params, includes = nil)
    EntryQuery.new(self.includes(includes).by_date, params, "hours").filter
  end

  def value=(value)
    entry = value
    
    if entry =~ /(^\d+):([0-5][0-9]$)/i
      hours = $1
      minutes = $2
      entry = (hours.to_f + (minutes.to_f / 60)).round(2)
    elsif entry =~ /^[1-9][0-9]*$/i
      entry = value.to_f
    end

    write_attribute(:value, entry)
  end

  private

  def set_tags_from_description
    tagnames = extract_hashtags(description)
    self.tags = tagnames.map do |tagname|
      Tag.where("name ILIKE ?", tagname.strip).first_or_initialize.tap do |tag|
        tag.name = tagname.strip
        tag.save!
      end
    end
  end
end
