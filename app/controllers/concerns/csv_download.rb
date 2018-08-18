module CSVDownload
  def send_csv(name:, hours_entries:, mileages_entries:, expenses_entries:)
    send_data(
      EntryCSVGenerator.generate(hours_entries, mileages_entries),
      filename: "#{name}-entries-#{timestamp}.csv",
      type: "text/csv"
    )
  end

  def timestamp
    Time.now.strftime('%Y%m%d%H%M%S')
  end

end
