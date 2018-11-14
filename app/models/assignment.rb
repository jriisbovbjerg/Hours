class Assignment < ActiveRecord::Base

  validates :user,        presence: true
  validates :project,     presence: true
  validates :valid_from,  presence: true
  validates :valid_to,    presence: true
  validates :currency,    presence: true
  validates :hourly_rate, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validate :non_overlapping_assignment
  validate :valid_to_date_is_after_valid_from_date

  belongs_to :user
  belongs_to :project

  scope :exclude_self, -> id { where.not(id: id) }
  scope :current,  lambda { |date| where("? between valid_from AND valid_to", date) }
  scope :current_and_recent,  lambda { |date| where("valid_to > ? AND valid_from < ?", date - 35.days, date) }
  scope :by_user, lambda { |user| where("user_id = ?", user) }

  def active?(date: Date.today())
    valid_from <= date && valid_to >= date
  end
  
  def indentifier_with_project
    "#{user.name} - #{valid_from_fmt}/#{valid_to_fmt} - #{hourly_rate} #{currency}/hour"
  end
  
  def indentifier_with_user
    "#{project.name}/#{project.client.name} - #{valid_from_fmt} -> #{valid_to_fmt} - #{hourly_rate} #{currency}/hour"
  end

  def indentifier
    "#{user.name} - #{project.name}/#{project.client.name} - #{valid_from_fmt} ->#{valid_to_fmt} - #{hourly_rate} #{currency}/hour"
  end

  def valid_from_fmt
    valid_from.to_formatted_s(:rfc822)
  end

  def valid_to_fmt
    valid_to.to_formatted_s(:rfc822)
  end
  
  protected
  
  def valid_to_date_is_after_valid_from_date
    return if valid_to.blank? || valid_from.blank?

    if valid_to < valid_from
      errors.add(:valid_to, "cannot be before the start date - #{valid_from_fmt} -> #{valid_to_fmt}") 
    end 
  end
  
  def non_overlapping_assignment
    competing_assignments = Assignment.where(user: user)
                                      .where(project: project)
                                      .exclude_self(id)

    competing_assignments.each do |competing|
      if (valid_from...valid_to).overlaps?(competing.valid_from...competing.valid_to)
        errors.add(:base, "This time have been assignet already - #{competing.valid_from_fmt} -> #{competing.valid_to_fmt}")        
      end
    end
  end
end
