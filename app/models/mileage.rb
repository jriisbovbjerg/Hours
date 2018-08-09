# == Schema Information
#
# Table name: mileages
#
#  id         :integer          not null, primary key
#  project_id :integer          not null
#  user_id    :integer          not null
#  value      :integer          not null
#  date       :date             not null
#  billed     :boolean          default("false")
#  created_at :datetime
#  updated_at :datetime
#  from_adress :string,         null => false)
#  to_adress   :string,         null => false)
#  taxfree     :boolean         default("false"))
#

class Mileage < Entry
  
  validates :user, :project, :date, :value, presence: true
  validates :from_adress, :to_adress, presence: true
  validates :value, :numericality => { :greater_than => 0, only_integer: true }
  
  scope :by_last_created_at, -> { order("created_at DESC") }
  scope :by_date, -> { order("date DESC") }
  scope :billable, -> { where("billable").joins(:project) }
  scope :with_clients, -> {
    where.not("projects.client_id" => nil).joins(:project)
  }

  def self.query(params, includes = nil)
    EntryQuery.new(self.includes(includes).by_date, params, "mileages").filter
  end
end
