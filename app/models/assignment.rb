class Assignment < ActiveRecord::Base

  validates :user, presence: true
  validates :project, presence: true
  validates :valid_from, presence: true
  validates :valid_to, presence: true
  validates :currency, presence: true
  validates :hourly_rate, presence: true

  belongs_to :user
  belongs_to :project

  scope :active,  lambda { |date| where("? between valid_from AND valid_to", date) }

end
