class Invoice < ActiveRecord::Base

  MILEAGE_RATE = 3.56

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :from_date, presence: true
  validates :to_date, presence: true

  has_one :client, through: :project
  belongs_to :project, touch: true
  
  scope :by_name, -> { order("lower(name)") }
  
  def dates
    return " [#{from_date} -> #{to_date}] "
  end
  
  def to_s
    name
  end
  
  def generate(params)
    self.project = Project.find(params["project_id"])
    self.payload["project"]  = get_project
    
    client = project.client
    self.payload["client"]   = get_client
    
    self.payload["hours"]    = params["hours_to_bill"].blank? ? "{}" : extend_hours(params["hours_to_bill"])
    self.payload["expenses"] = params["expenses_to_bill"].blank? ? "{}" : extend_expenses(params["expenses_to_bill"])
    self.payload["mileages"] = params["mileages_to_bill"].blank? ? "{}" : extend_mileages(params["mileages_to_bill"])
    self.name = "#{client.name}-#{project.name}"
    self.from_date = Date.today #get_first_date(params["hours_to_bill"], params["expenses_to_bill"], params["mileages_to_bill"] ) 
    self.to_date = Date.today #get_last_date(params["hours_to_bill"], params["expenses_to_bill"], params["mileages_to_bill"] )
    self.save!
  end

  def get_client
    return {"name":"#{client.name}",
            "companyname":"#{client.companyname}",
            "adress":"#{client.adress}",
            "postalcode":"#{client.postalcode}",
            "otherinfo":"#{client.otherinfo}",
            "invoiceemail":"#{client.invoiceemail}",
            "paymentterms":"#{client.paymentterms}"}
  end
  
  def get_project
    return {"PO":"#{project.reference_number}",
            "name":"#{project.name}",
            "contact":"#{project.contact.name}",
            "currency":"#{project.currency}",
            "period":"#{project.period}",
            "invoice_email":"#{project.invoice_email}"}
  end

  def get_first_and_last_date(hours, expenses, mileages)
    first_date = min(first_date(hours), first_date(expenses), first_date(mileages))
    last_date = max(last_date(hours), last_date(expenses), last_date(mileages))
  end
  
  def extend_hours(hours)
    detailed_hours = []
    hours.each do |hour|
      hr = Hour.find(hour)
      assign = Assignment.at_date(hr.date).by_user(hr.user_id).by_project(project_id).first
      project_rate = settle_currency(assign.hourly_rate, assign.currency, project.currency)
      total = hr.value * project_rate.to_f
      detailed_hours << {:date => hr.date,
                          :hours => hr.value.to_f,
                          :who => hr.user.name,
                          :hourly_rate => project_rate.to_f,
                          :total => total.to_f}
    end
    summary_hours = condense_hours(detailed_hours)
    return {:detailed => detailed_hours,
            :summary => summary_hours}
  end

  def condense_hours(data)
    summary_array = []
    summary = data.group_by { |item| [item[:who], item[:hourly_rate]] }.values
    summary.each do |arr|
      who = arr.first[:who]
      hourly_rate = arr.first[:hourly_rate]
      total_sum = arr.inject(0) {|sum, hash| sum + hash[:total]}
      hours_sum = arr.inject(0) {|sum, hash| sum + hash[:hours]}
      summary_array << {:who => who, :hourly_rate => hourly_rate, :total => total_sum, :hours => hours_sum}
    end
    return summary_array
  end

  def extend_expenses(expenses)
    detailed_expenses = []
    expenses.each do |expense|
      ex = Expense.find(expense)
      project_value = settle_currency(ex.value, "DKK", project.currency).to_f
      detailed_expenses << {:total => project_value,
                            :what => ex.description,
                            :who => ex.user.name}
    end
    summary_expenses = condense_expenses(detailed_expenses)
    return {:detailed => detailed_expenses,
            :summary => summary_expenses}
  end
  
  def condense_expenses(data)
    summary_array = []
    summary = data.group_by { |item| item[:who] }.values
    summary.each do |arr|
      who = arr.first[:who]
      total_sum = arr.inject(0) {|sum, hash| sum + hash[:total] }
      summary_array << { :who => who, :total => total_sum }
    end
    return summary_array
  end


  def extend_mileages(mileages)
    detailed_mileages = []
    mileages.each do |mileage|
      mil = Mileage.find(mileage)
      mileage_value = MILEAGE_RATE * mil.value
      total_value = settle_currency(mileage_value, "DKK", project.currency).to_f
      detailed_mileages << {:total => total_value,
                            :what => mil.description,
                            :who => mil.user.name,
                            :rate => MILEAGE_RATE,
                            :distance => mil.value.to_f}
    end
    summary_mileages = condense_mileages(detailed_mileages)
    return {:detailed => detailed_mileages,
            :summary => summary_mileages}
  end

  def condense_mileages(data)
    summary_array = []
    summary = data.group_by { |item| item[:who] }.values
    summary.each do |arr|
      who = arr.first[:who]
      total_sum = arr.inject(0) {|sum, hash| sum + hash[:total] }
      total_dist = arr.inject(0) {|sum, hash| sum + hash[:distance] }
      summary_array << {:who => who, :total => total_sum, :distance => total_dist }
    end
    return summary_array
  end

  def timestamp
    Time.now.strftime('%Y%m%d%H%M%S')
  end

  def settle_currency(rate, from_currency, to_currency)
    Money.new(rate.to_f * 100, from_currency).exchange_to(to_currency).to_s
  end

end
