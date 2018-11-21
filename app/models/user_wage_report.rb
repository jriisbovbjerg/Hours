#wage_report
require "csv"

class UserWageReport
  def initialize(year, month)
    @year = 2018
    @month = 8
  end
  

  def generate
    CSV.generate(options) do |csv|
        csv << headers
      values.each do |row|
        csv << row
      end
    end
  end

  def options
    return { col_sep: ";" } if I18n.locale.in?([:nl, :de])
    CSV::DEFAULT_OPTIONS
  end

  def values
    expenses          = Expense.in_month(@month).in_year(@year).group(:user_id).sum(:value)
    taxfreemileage    = Mileage.in_month(@month).in_year(@year).taxfree.group(:user_id).sum(:value)
    nontaxfreemileage = Mileage.in_month(@month).in_year(@year).nontaxfree.group(:user_id).sum(:value)
    hours_total       = Hour.in_year(@year).in_month(@month).group(:user_id).sum(:value)
    hours_invoiced    = Hour.billable.in_year(@year).in_month(@month).group(:user_id).sum(:value)
    hours_sick        = Hour.sick.in_year(@year).in_month(@month).group(:user_id).sum(:value)
    hours_training    = Hour.training.in_year(@year).in_month(@month).group(:user_id).sum(:value)
    hours_parental    = Hour.parental.in_year(@year).in_month(@month).group(:user_id).sum(:value)
    hours_childsick   = Hour.child_sick.in_year(@year).in_month(@month).group(:user_id).sum(:value)
    hours_iso         = Hour.iso_work.in_year(@year).in_month(@month).group(:user_id).sum(:value)
    hours_vacation    = Hour.vacation.in_year(@year).in_month(@month).group(:user_id).sum(:value)
    
    users = User.all.pluck(:id, :email, :first_name, :last_name, :weeklyhours)
    
    strings = []
    users.each do |id, email, first, last, hours| 
      strings << [id, 
                 full_name(first, last),
                 initials(email),
                 hours,
                 expenses[id],
                 taxfreemileage[id],
                 nontaxfreemileage[id],
                 hours_total[id],
                 hours_invoiced[id],
                 overtime(hours_invoiced[id]),
                 hours_sick[id],
                 hours_training[id],
                 hours_parental[id],
                 hours_childsick[id],
                 hours_iso[id],
                 hours_vacation[id],
                 days(hours_vacation[id])
                ]
      
    end
    return strings
  end
  
  def initials(email)
    email.blank? ? "missing?" : email.split('@')[0]
  end

  def days(hours)
    hours.blank? ? "" : (hours / 7.4).round(2)
  end

  def full_name(first, last)
    "#{first} #{last}"
  end

  def overtime(hours)
    hours = hours.presence || 0
    overtime = hours - 160
    overtime > 0 ? overtime : ""
  end

  def headers()
    header = %w(id
                name
                initials
                weeklyhours
                expenses_dkk
                taxfremileages_km
                nontaxfreemileage_km
                total_h
                invoiced_h
                overtime_h
                sick_h
                training_h
                parental_h
                chlidsick_h
                isowork_h
                vacation_h
                vacation_d)

    header.map do |header|
      I18n.translate("report.headers.#{header}")
    end
  end
end