class Report
  def initialize(entries)
    @entries = entries.map { |e| ReportEntry.new(e) }
  end

  def headers(entry_type)
    header = %w(date
        user
        project
        client
        mileages
        billable
        billed) if entry_type == "mileages"
    
    header = %w(
        date
        user
        project
        category
        client
        hours
        billable
        billed
        description) if entry_type == "hours"
    
    header = %w(
        date
        user
        project
        category
        client
        hours
        billable
        billed
        description
        supllier) if entry_type == "expenses"

    header.map do |headers|
      I18n.translate("report.headers.#{headers}")
    end
  end

  def each_row(&block)
    @entries.each(&block)
  end
end
