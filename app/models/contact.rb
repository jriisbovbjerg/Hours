#:name, :position, :department, :phone, :email

class Contact < ActiveRecord::Base
  validates :name,         presence: true
  validates :position,     presence: true
  validates :department,   presence: true
  validates :phone,        presence: true
  validates :email,        presence: true
  
  scope :by_name, -> { order("lower(name)") }

  has_many :projects
  
  belongs_to :client, touch: true

end