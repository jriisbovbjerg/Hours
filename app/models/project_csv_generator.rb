require "csv"

class ProjectCSVGenerator
  def self.generate(hours_entries, mileages_entries, expenses_entries)
    new(hours_entries, mileages_entries, expenses_entries).generate
  end

  def initialize(hours_entries, mileages_entries, expenses_entries)
    @hours_report = Report.new(hours_entries)
    @mileages_report = Report.new(mileages_entries)
    @expenses_report = Report.new(expenses_entries)
  end

  def generate
    data = []
    fill_fields("hours", data)
    fill_fields("mileages", data)
    fill_fields("expenses", data)
    data = concentrate_on_project(data)

    CSV.generate(options) do |csv|
      csv << project_csv_header
      data.each do |row|
        csv << row
      end
    end
  end
  
  def concentrate_on_project(data)
    puts "------data: #{data.inspect}------------"
    projects = data.transpose[0].uniq
    #puts "-------users: #{users}--------"
    concentrate = []
    projects.each do |project|
      mileage = get_mileage(project, data)
      hours = get_hours(project, data)
      expense = get_expenses(project, data)
      concentrate << [project, hours, expense, mileage ]
    end
    puts "-------concentrate: #{concentrate}--------"
    return concentrate
  end
  
  def get_hours(project, data)
    data.select{|x| x[0] == project}.map{|y| y[1].to_i}.reduce(:+)
  end

  def get_expenses(project, data)
    data.select{|x| x[0] == project}.map{|y| y[2].to_i}.reduce(:+)
  end

  def get_mileage(project, data)
    data.select{|x| x[0] == project}.map{|y| y[3].to_i}.reduce(:+)
  end

  def options
    return {
      col_sep: ";"
    } if I18n.locale.in?([:nl, :de])

    CSV::DEFAULT_OPTIONS
  end

  def get_fields(entry, entry_type)
    fields = [ entry.project ]
    fields.push [ entry.value, 0, 0] if entry_type == "hours"
    fields.push [ 0, entry.value, 0 ] if entry_type == "expenses"
    fields.push [ 0, 0, entry.value ] if entry_type == "mileages"
    fields.flatten
  end

  def fill_fields(entry_type, csv)
    report = instance_variable_get("@#{entry_type}_report")
    report.each_row do |entry|
      csv << get_fields(entry, entry_type)
    end
  end

  def project_csv_header
    header = %w(
        project
        hours
        expenses
        mileages)

    header.map do |headers|
      I18n.translate("report.headers.#{headers}")
    end
  end
end
