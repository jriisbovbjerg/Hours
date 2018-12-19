
class Project < ActiveRecord::Base
  include Sluggable

  audited allow_mass_assignment: true

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates_with ClientBillableValidator
  has_many :hours
  has_many :mileages
  has_many :expenses

  has_many :assignments

  has_many :users, -> { uniq }, through: :hours
  has_many :categories, -> { uniq }, through: :hours
  has_many :tags, -> { uniq }, through: :hours

  belongs_to :client, touch: true
  belongs_to :contact, touch: true

  scope :by_last_updated, -> { order("projects.updated_at DESC") }
  scope :by_name, -> { order("lower(name)") }
  scope :active,  lambda { |date| where("? between valid_from AND valid_to", date) }
  scope :are_archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }
  scope :billable, -> { where(billable: true) }
  scope :administrative, -> { where(administrative: true) }

  def sorted_categories
    categories.sort_by do |category|
      EntryStats.new(hours, category).percentage_for_subject
    end.reverse
  end
  
  def dates
    "From: #{valid_from_fmt} - To: #{valid_to_fmt}"
  end

  def valid_from_fmt
    valid_from.to_formatted_s(:rfc822)
  end

  def valid_to_fmt
    valid_to.to_formatted_s(:rfc822)
  end

  def active?(date: Date.today())
    valid_from <= date && valid_to >= date
  end

  def label
    name
  end

  def long_name
    "#{name}  [#{client.name}]"
  end

  def budget_status
    budget - hours.sum(:value) if budget
  end

  def has_billable_entries?
    [hours.exists?(billed: false),
    mileages.exists?(billed: false),
    expenses.exists?(billed: false)].any?
  end

  def unbilled_hours
    hours.where(billed: false).sum(:value)
  end
  
  def unbilled_mileages
    mileages.where(billed:false).sum(:value)
  end

  def unbilled_expenses
    expenses.where(billed:false).sum(:value)
  end

  private

  def slug_source
    name
  end
end
