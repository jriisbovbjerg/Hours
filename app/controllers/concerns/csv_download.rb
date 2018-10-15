module CSVDownload
  
  def send_csv(name:, type:, hours_entries:, mileages_entries:, expenses_entries:)
    case
    when type == "general"
      return send_data(
              EntryCSVGenerator.generate(hours_entries, mileages_entries, expenses_entries),
              filename: "#{name}-entries-#{timestamp}.csv",
              type: "text/csv")
    
    when type == "user"
      return send_data(
              UserCSVGenerator.generate(hours_entries, mileages_entries, expenses_entries),
              filename: "User-entries-#{timestamp}.csv",
              type: "text/csv")

    when type = "project"
      return send_data(
              ProjectCSVGenerator.generate(hours_entries, mileages_entries, expenses_entries),
              filename: "Project-entries-#{timestamp}.csv",
              type: "text/csv")
    end
  
  end

  def wage_csv(name:, year:, month:)
    return send_data(
              UserWageReport.new(year, month).generate,
              filename: "#{year}_#{month}_#{name}_#{timestamp}.csv",
              type: "text/csv")
  end

  def timestamp
    Time.now.strftime('%Y%m%d%H%M%S')
  end

end
