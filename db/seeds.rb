#Cleanup
puts "Start"

User.destroy_all
puts "deleted Users"

Client.destroy_all
puts "deleted Clients"

Project.destroy_all
puts "deleted Projects"

Contact.destroy_all
puts "deleted Contacts"

Category.destroy_all
puts "deleted Categories"

Expense.destroy_all
puts "deleted Expenses"

Hour.destroy_all
puts "deleted Hours"

Mileage.destroy_all
puts "deleted Mileages"

Assignment.destroy_all
puts "deleted Assignemnts"

puts "Cleanup done"

require 'csv'

User.create({ first_name: "Jan Riis",
              last_name: "Bovbjerg",
              email: "jriisbovbjerg@gmail.com",
              password: "pass",
              confirmed_at: Date.current}
              )

user_data = 'db/seed_data/Consultants.csv'

File.open(user_data) do |file|
  CSV.parse(file, :headers => true, :col_sep => ",").each do |row|
    #Name,Initials,Title,Vestas Init,MVOW Init
    row_hash = row.to_hash
    User.create({first_name:   row_hash["Name"].split[0..-2].join(" "),
                 last_name:    row_hash["Name"].split[-1],
                 email:        row_hash["Initials"].downcase + "@biir.dk",
                 password:     row_hash["Initials"].downcase,
                 confirmed_at: Date.current}
                 )
  end
end
puts "Users done"

own_client = Client.create({ name:         "BIIR",
                             companyname:  "BIIR Aps",
                             adress:       "Dusager 14",
                             postalcode:   "8200 Århus N",
                             otherinfo:    "Internal",
                             invoiceemail: "jbc@biir.com",
                             paymentterms: "NET OEM 30"
                           })


client_data = 'db/seed_data/Companies.csv'
File.open(client_data) do |file|
  CSV.parse(file, :headers => true, :col_sep => ",").each do |row|
    #ClientName,Company,Street,PostalCode,Other address info,Invoice Email,Payment Terms
    row_hash = row.to_hash
    Client.create({ name:         row_hash["ClientName"],
                    companyname:  row_hash["Company"] || row_hash["ClientName"],
                    adress:       row_hash["Street"] || "missing",
                    postalcode:   row_hash["PostalCode"] || "missing",
                    otherinfo:    row_hash["Other address info"] || "none",
                    invoiceemail: row_hash["Invoice Email"] || "missing",
                    paymentterms: row_hash["Payment Terms"] || "missing"
                  })
  end
end
puts "Clients done"

own_contact = Contact.create({ name: "JBC",
                               email: "jbc@biir.com",
                               position: "Partner",
                               department: "sales",
                               phone: "4177 0701",
                               client: own_client
                             })

contacts_data = 'db/seed_data/Contacts.csv'
File.open(contacts_data) do |file|
  CSV.parse(file, :headers => true, :col_sep => ",").each do |row|
    #Name,Company,Position,Department,Phone,Email
    row_hash = row.to_hash
    client = Client.where(name: row_hash["Company"]).first
    Contact.create({ name:       row_hash["Name"],
                     email:      row_hash["Email"] || "missing",
                     position:   row_hash["Position"] || "-",
                     department: row_hash["Department"] || "-",
                     phone:      row_hash["Phone"] || "-",
                     client:     client || Client.first
                    })
  end
end
puts "Contacts done"

Project.create([{ name:"Parental Leave", client: own_client, description: "Parental leave", reference_number: "BIIR0008", administrative: true, billable: false, invoice_email: "jcb@biir.dk", currency: "DKK", contact_id: own_contact},
                { name:"Vacation",       client: own_client, description: "Vacation",       reference_number: "BIIR0007", administrative: true, billable: false, invoice_email: "jcb@biir.dk", currency: "DKK", contact_id: own_contact},
                { name:"Child sick",     client: own_client, description: "Child sick",     reference_number: "BIIR0006", administrative: true, billable: false, invoice_email: "jcb@biir.dk", currency: "DKK", contact_id: own_contact},
                { name:"Sick",           client: own_client, description: "Sick",           reference_number: "BIIR0005", administrative: true, billable: false, invoice_email: "jcb@biir.dk", currency: "DKK", contact_id: own_contact},
                { name:"ISO",            client: own_client, description: "ISO",            reference_number: "BIIR0004", administrative: true, billable: false, invoice_email: "jcb@biir.dk", currency: "DKK", contact_id: own_contact},                 
                { name:"Training",       client: own_client, description: "Training",       reference_number: "BIIR0003", administrative: true, billable: false, invoice_email: "jcb@biir.dk", currency: "DKK", contact_id: own_contact}
               ])

projects_data = 'db/seed_data/Projects.csv'
File.open(projects_data) do |file|
  CSV.parse(file, :headers => true, :col_sep => ",").each do |row|
    #ref_number,Customer,Customer Reference,Cur,Rate,Rate Period,PO Valid from,PO Valid untill,PO Status,Agreement Statement,Conditions 1a,Conditions 1b,Conditions 2a,Conditions 2b,Conditions 3a,Conditions 3b,Conditions 4a,Conditions 4b,Conditions 5a,Conditions 5b,Invoice mailadress,,"BiiR Engineer (DK individual or CORE-lead)",BiiR Init,BiiR Engineers Costumer Init,Notes
    row_hash = row.to_hash
    client = Client.where(name: row_hash["Customer"]).first
    contact = Contact.where(name: row_hash["Customer Reference"]).first
    project = Project.create({ name:             row_hash["ref_number"],
                               client:           client,
                               description:      "-",
                               reference_number: row_hash["ref_number"] || "0000",
                               billable:         true,
                               invoice_email:    row_hash["Invoice mailadress"] || "missing",
                               valid_from:       row_hash["PO Valid from"].blank? ? Date.ordinal(2018, 1) : Date.strptime(row_hash["PO Valid from"], "%d/%m/%y"),
                               valid_to:         row_hash["PO Valid untill"].blank? ? Date.ordinal(2018, -1) : Date.strptime(row_hash["PO Valid untill"], "%d/%m/%y"),
                               currency:         row_hash["Cur"] || "DKK",
                               administrative:   false,
                               contact:          contact
                              })

  end
end


puts "Projects done"

users = User.all
projects = Project.where(administrative: false)

count_of_projects = projects.count
puts "count_of_projects = #{count_of_projects}"

count_of_users = users.count
puts "count_of_users = #{count_of_users}"

user_per_project = (count_of_users / count_of_projects).ceil
puts "user_per_project = #{user_per_project}"

projects.each do |project|
  (rand(-1..5) + user_per_project).times do |count|  
    user = User.order("RANDOM()").first
  
    Assignment.create(user: user,
                      project: project,
                      valid_from: project.valid_from,
                      valid_to: project.valid_to,
                      hourly_rate: rand(50..1200),
                      currency: ["EUR", "DKK"].sample
                      )
  end
end

puts "Assignments done"

Category.create([{ name: "Administration"},
                 { name: "Analyse"},
                 { name: "Beregning"},
                 { name: "Udvikling"},
                 { name: "Rådgivning"},
                 { name: "Test"}
                 ])

puts "Categories done"

first = Date.ordinal(2018, 200)
last = Date.ordinal(2018, 255)

admprojects = Project.where(administrative: true)
puts "There is #{admprojects.count} administrative projects"

client_projects = Project.where(administrative: false)
puts "There is #{client_projects.count} external projects"

users = User.all
first.upto(last) do |date|
  unless date.saturday? || date.sunday?
    users.each do |user|
      proj = Assignment.by_user(user).at_date(date).includes(:project).map(&:project).first
      if proj.blank? || rand(11) == 1 
        type = 1
        proj = admprojects.sample
        cat = Category.first
      else
        type = 0
        cat = Category.all[1..-1].sample
      end
      Hour.create({ project: proj, user: user, value: 6.2 + (rand(100)/50.0), date: date, billed: false, description: "ref #{rand(100)/49.0}", category: cat})

      if type == 0 && rand(7) == 1
        Expense.create({ project: proj, user: user, amount: rand(1000) + 100, date: date, billed: false, currency: rand(2)==1 ? "DKK" : "EUR", exchangerate: (3.3 + rand(713)) / (1.1 + rand(387) ), description: "description", supplier: "gl. Brugs"}
        )
      end
      if type == 0 && rand(5) == 1
        Mileage.create({ project: proj, user: user, value: rand(250) + 25, date: date, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: rand(2)==1}
        )
      end
    end
  end
  puts "Date: #{date}"
end
