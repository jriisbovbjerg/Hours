class Invoice < ActiveRecord::Base

  MILEAGE_RATE = 3.56

  has_one :client, through: :project
  belongs_to :project, touch: true
  
  def generate(params)
    self.project = Project.find(params["project_id"])
    self.payload["project"]  = get_project
    
    client = project.client
    self.payload["client"]   = get_client
    
    self.payload["hours"]    = params["hours_to_bill"].blank? ? "{}" : extend_hours(params["hours_to_bill"])
    self.payload["expenses"] = params["expenses_to_bill"].blank? ? "{}" : extend_expenses(params["expenses_to_bill"])
    self.payload["mileages"] = params["mileages_to_bill"].blank? ? "{}" : extend_mileages(params["mileages_to_bill"])
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
  
  def extend_hours(hours)
    extended_hours = []
    hours.each do |hour|
      hr = Hour.find(hour)
      assign = Assignment.where(user: hr.user.id, project: project.id).at_date(hr.date)
      
      project_rate = settle_currency(assign.hourly_rate, assign.currency, project.currency)
      total = hr.value * project_rate.to_f
      extended_hours << {"date":hr.date,
                          "hours":hr.value.to_f,
                          "who":hr.user.name,
                          "hourly_rate":project_rate.to_f,
                          "total":total.to_f}
    end
    condense_hours(extended_hours)
    return extended_hours
  end 

  def extend_expenses(expenses)
    extended_expenses = []
    expenses.each do |expense|
      ex = Expense.find(expense)
      project_value = settle_currency(ex.value, "DKK", project.currency).to_f
      extended_expenses << {"total":project_value,
                              "what":ex.description,
                              "who":ex.user.name}
    end
    condense_expenses(extended_expenses)
    return extended_expenses
  end

  def extend_mileages(mileages)
    extended_mileages = []
    mileages.each do |mileage|
      mil = Mileage.find(mileage)
      mileage_value = MILEAGE_RATE * mil.value
      total_value = settle_currency(mileage_value, "DKK", project.currency).to_f
      extended_mileages << {"total":total_value,
                              "what":mil.description,
                              "who":mil.user.name,
                              "rate":MILEAGE_RATE,
                              "distance":mil.value.to_f}
    end
    condense_mileages(extended_mileages)
    return extended_mileages
  end

  def condense_hours(data)
    return data
  end

  def condense_expenses(data)
    return data
  end

  def condense_mileages(data)
    return data
  end


  def timestamp
    Time.now.strftime('%Y%m%d%H%M%S')
  end

  def settle_currency(rate, from_currency, to_currency)
    Money.new(rate.to_f * 100, from_currency).exchange_to(to_currency).to_s
  end

end
