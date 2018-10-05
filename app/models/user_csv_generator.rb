require "csv"

class UserCSVGenerator
  def self.generate(hours_entries, mileages_entries, expenses_entries)
    new(hours_entries, mileages_entries, expenses_entries).generate
  end

  def initialize(hours_entries, mileages_entries, expenses_entries)
    @hours_report    = Report.new(hours_entries)
    @mileages_report = Report.new(mileages_entries)
    @expenses_report = Report.new(expenses_entries)
  end

  def generate
    data = []
    fill_fields("hours", data)
    fill_fields("mileages", data)
    fill_fields("expenses", data)
    data = concentrate_on_user(data)

    CSV.generate(options) do |csv|
      csv << user_csv_header
      data.each do |row|
        csv << row
      end
    end
  end

  def concentrate_on_user(data)
    puts "------data: #{data.inspect}------------"
    users = data.transpose[0].uniq
    #puts "-------users: #{users}--------"
    concentrate = []
    users.each do |user|
      mileage = get_mileage(user, data)
      hours_invoiced = get_hours_invoiced(user, data)
      hours_non_invoiced = get_hours_non_invoiced(user, data)
      expense = get_expenses(user, data)
      concentrate << [user, hours_invoiced, hours_non_invoiced, expense, mileage ]
    end
    puts "-------concentrate: #{concentrate}--------"
    return concentrate
  end

  def get_mileage(user, data)
    data.select{|x| x[0] == user}.map{|y| y[5].to_i}.reduce(:+)
  end

  def get_hours_invoiced(user, data)
    data.select{|x| (x[0] == user && x[1] == true)}.map{|y| y[3].to_i}.reduce(:+)
  end

  def get_hours_non_invoiced(user, data)
    data.select{|x| (x[0] == user && x[1] == false)}.map{|y| y[3].to_i}.reduce(:+)
  end

  def get_expenses(user, data)
    data.select{|x| x[0] == user}.map{|y| y[4].to_i}.reduce(:+)
  end

  def options
    return {
      col_sep: ";"
    } if I18n.locale.in?([:nl, :de])

    CSV::DEFAULT_OPTIONS
  end

  def get_fields(entry, entry_type)
    fields = [ entry.user, entry.billable, entry.billed ]
    fields.push [ entry.value, "", ""] if entry_type == "hours"
    fields.push [ "", entry.value, "" ] if entry_type == "expenses"
    fields.push [ "", "", entry.value ] if entry_type == "mileages"
    fields.flatten
  end

  def fill_fields(entry_type, data)
    report = instance_variable_get("@#{entry_type}_report")
    report.each_row do |entry|
      data << get_fields(entry, entry_type)
    end
  end

  def user_csv_header
    header = %w(
        user
        hours_invoiced
        hours_non_invoiced
        expenses
        mileages)

    header.map do |headers|
      I18n.translate("report.headers.#{headers}")
    end
  end
end