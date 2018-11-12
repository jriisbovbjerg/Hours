class Assignment < ActiveRecord::Base

  validates :user,        presence: true
  validates :project,     presence: true
  validates :valid_from,  presence: true
  validates :valid_to,    presence: true
  validates :currency,    presence: true
  validates :hourly_rate, presence: true

  belongs_to :user
  belongs_to :project

  scope :current,  lambda { |date| where("? between valid_from AND valid_to", date) }
  scope :current_and_recent,  lambda { |date| where("valid_to > ? AND valid_from < ?", date - 35.days, date) }

  def active?(date: Date.today())
    valid_from <= date && valid_to >= date
  end
  
  def indentifier_with_project
    "#{user.name} - #{valid_from}/#{valid_to} - #{hourly_rate} #{currency}/hour"
  end
  
  def indentifier_with_user
    "#{project.name}/#{project.client.name} - #{valid_from}/#{valid_to} - #{hourly_rate} #{currency}/hour"
  end
end
