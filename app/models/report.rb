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
        billed
        from_adress
        to_adress
        ) if entry_type == "mileages"
    
    header = %w(
        date
        user
        project
        client
        hours
        billable
        billed
        description
        category) if entry_type == "hours"
    
    header = %w(
        date
        user
        project
        client
        value
        billable
        billed
        description
        supplier
        currency
        exchangerate) if entry_type == "expenses"

    header.map do |headers|
      I18n.translate("report.headers.#{headers}")
    end
  end



  def each_row(&block)
    @entries.each(&block)
  end
end
