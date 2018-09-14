require "csv"

class UserCSVGenerator
  def self.generate(hours_entries, mileages_entries, expenses_entries)
    new(hours_entries, mileages_entries, expenses_entries).generate
  end

  def initialize(hours_entries, mileages_entries, expenses_entries)
    @hours_report = Report.new(hours_entries)
    @mileages_report = Report.new(mileages_entries)
    binding.pry
    @expenses_report = Report.new(expenses_entries)
  end

  def generate
    #CSV.generate(options) do |csv|
      csv = []
      fill_fields("hours", csv)
      fill_fields("mileages", csv)
      fill_fields("expenses", csv)
    #end
      binding.pry # Execution will stop here.
      e = 23
      puts 'Goodbye World' # Run 'next' in the console to move here.
  end

  def fill_fields(entry_type, csv)
    report = instance_variable_get("@#{entry_type}_report")
    report.each_row do |entry|
      csv << get_fields(entry, entry_type)
    end
  end

  def get_fields(entry, entry_type)
    fields = [entry.date, entry.user, entry.project]
    fields.push [entry.description]
    fields.push [entry.client, entry.value, entry.billable, entry.billed]
    fields.flatten
  end

  def options
    return {
      col_sep: ";"
    } if I18n.locale.in?([:nl, :de])

    CSV::DEFAULT_OPTIONS
  end

end
