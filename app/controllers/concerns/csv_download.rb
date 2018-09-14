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

  def timestamp
    Time.now.strftime('%Y%m%d%H%M%S')
  end

end
