# == Schema Information
#
# Table name: hours
#
#  id          :integer          not null, primary key
#  project_id  :integer          not null
#  category_id :integer          not null
#  user_id     :integer          not null
#  value       :integer          not null
#  date        :date             not null
#  created_at  :datetime
#  updated_at  :datetime
#  description :string
#  billed      :boolean          default("false")
#

class Hour < Entry
  audited allow_mass_assignment: true

  belongs_to :category

  has_many :taggings, inverse_of: :hour
  has_many :tags, through: :taggings

  validates :category, presence: true
  validates :value , format: { with: /([0-1]?[0-9]|2[0-3]):[0-5][0-9]|\A\d{1,2}(?!\d)/, message: "Integer or hour format only ex. 10 or 10:20" }
  
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
    if entry.length < 3
      entry = entry.to_f
    else
      hours = entry[/^\d{1,2}(?!\d)/]
      minutes = entry[/([^:]+)$/]
      decimal = (minutes.to_f / 60)
      entry = (hours.to_f + decimal).round(2)
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
