# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Cleanup
User.destroy_all
Client.destroy_all
Project.destroy_all
Category.destroy_all
Expense.destroy_all
Hour.destroy_all
Mileage.destroy_all


users = User.create([{first_name: "Jan Riis", last_name: "Bovbjerg", email: "jriisbovbjerg@gmail.com", password: "pass", confirmed_at: Date.current},
                     {first_name: "Ole", last_name: "Pedersen", email: "email1@biir.dk", password: "pass", confirmed_at: Date.current},
                     {first_name: "Torben", last_name: "Andersen", email: "email2@biir.dk", password: "pass", confirmed_at: Date.current},
                     {first_name: "Jonas Bojer", last_name: "Christensen", email: "jbc@biir.dk", password: "pass", confirmed_at: Date.current}])


clients = Client.create([{ name: "BIIR", companyname: "BIIR Aps", adress: "Dusager 14", postalcode: "8200", otherinfo: "Internal", invoiceemail: "jbc@biir.com", paymentterms: "NET OEM 30"},
                         { name: "Alpha", companyname: "Alpha", adress: "A-vej", postalcode: "6600", otherinfo: "building", invoiceemail: "invoice@alpha_test.com", paymentterms: "NET OEM 30"},
                         { name: "Beta", companyname: "Betafon A/S", adress: "B-vej", postalcode: "7900", otherinfo: "steelstructure", invoiceemail: "invoice@beta_test.com", paymentterms: "NET OEM 8"},
                         { name: "Gamma", companyname: "Gamma Aps", adress: "C-vej", postalcode: "8800", otherinfo: "software", invoiceemail: "invoice@agamma_test.com", paymentterms: "NET OEM 30"}])


contacts  =Contact.create([{ name: "JBC", email: "jbc@biir.com", position: "Partner", department: "sales", phone: "4177 0701", client: Client.first},
                           { name: "Anders", email: "anders@alpha_test.com", position: "Projektleder", department: "betonafd", phone: "1234 4567", client: Client.second},
                           { name: "Anna", email: "anna@alpha_test.com", position: "Projektche", department: "betonafd", phone: "1234 4567", client: Client.second},
                           { name: "Benny", email: "benny@beta_test.com", position: "afdelingsleder", department: "Kranudvikling", phone: "2345 6789", client: Client.third},
                           { name: "Christian", email: "christian@gamma_test.com", position: "Opvasker", department: "testdept", phone: "4567 1234", client: Client.fourth}])



projects = Project.create([{ name:"Betonblok", client: Client.second, description: "bare et project 1", reference_number: "JRB", billable: true, invoice_email: "j@b.dk", valid_from: (Date.today - 1.month).beginning_of_month, valid_to: (Date.today + 1.month).end_of_month, currency: "EUR", contact_id: Contact.second},
                          { name:"Betonrør", client: Client.second, description: "bare et project 2", reference_number: "SS123123", billable: true, invoice_email: "j@b.dk", valid_from: (Date.today - 2.month).beginning_of_month, valid_to: (Date.today + 2.month).end_of_month, currency: "EUR", contact_id: Contact.second},
                          { name:"Stålrørs kran", client: Client.third, description: "bare et project 3", reference_number: "321123", billable: true, invoice_email: "j@b.dk", valid_from: (Date.today - 3.month).beginning_of_month, valid_to: (Date.today + 3.month).end_of_month, currency: "EUR", contact_id: Contact.third},
                          { name:"Panservogn", client: Client.third, description: "bare et project 4", reference_number: "PO5676123", billable: true, invoice_email: "j@b.dk", valid_from: (Date.today - 4.month).beginning_of_month, valid_to: (Date.today + 4.month).end_of_month, currency: "EUR", contact_id: Contact.third},
                          { name:"Timereg system", client: Client.first, description: "internal project", reference_number: "PO765123", billable: false, invoice_email: "j@b.dk", valid_from: (Date.today - 5.month).beginning_of_month, valid_to: (Date.today + 5.month).end_of_month, currency: "EUR", contact_id: Contact.fourth}])

internalproj = Project.create([{ name:"Parental Leave", client: Client.first, description: "Parental leave", reference_number: "0008", billable: false, invoice_email: "jcb@biir.dk", valid_from: (Date.today - 1.year).beginning_of_month, valid_to: (Date.today + 1.year).end_of_month, currency: "DKK", contact_id: Contact.first},
                          { name:"Vacation", client: Client.first, description: "Vacation", reference_number: "0007", billable: false, invoice_email: "jcb@biir.dk", valid_from: (Date.today - 1.year).beginning_of_month, valid_to: (Date.today + 1.year).end_of_month, currency: "DKK", contact_id: Contact.first},
                          { name:"Child sick", client: Client.first, description: "Child sick", reference_number: "0006", billable: false, invoice_email: "jcb@biir.dk", valid_from: (Date.today - 1.year).beginning_of_month, valid_to: (Date.today + 1.year).end_of_month, currency: "DKK", contact_id: Contact.first},
                          { name:"Sick", client: Client.first, description: "Sick", reference_number: "0005", billable: false, invoice_email: "jcb@biir.dk", valid_from: (Date.today - 1.year).beginning_of_month, valid_to: (Date.today + 1.year).end_of_month, currency: "DKK", contact_id: Contact.first},
                          { name:"ISO", client: Client.first, description: "ISO", reference_number: "0004", billable: false, invoice_email: "jcb@biir.dk", valid_from: (Date.today - 1.year).beginning_of_month, valid_to: (Date.today + 1.year).end_of_month, currency: "DKK", contact_id: Contact.first},
                          { name:"Training", client: Client.first, description: "Training", reference_number: "0003", billable: false, invoice_email: "jcb@biir.dk", valid_from: (Date.today - 1.year).beginning_of_month, valid_to: (Date.today + 1.year).end_of_month, currency: "DKK", contact_id: Contact.first}])

categories = Category.create([{ name: "Analyse"}, { name: "Beregning"}, { name: "Udvikling"}, { name: "Rådgivning"}, { name: "Test"}, { name: "Administration"}])

mileages = Mileage.create([{ project: Project.first, user: User.first, value: 100, date: 1.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.first, user: User.first, value: 100, date: 2.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.first, user: User.first, value: 100, date: 3.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.first, user: User.first, value: 100, date: 5.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.first, user: User.first, value: 100, date: 7.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.first, user: User.first, value: 100, date: 8.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.first, user: User.first, value: 100, date: 9.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.second, user: User.first, value: 250, date: 10.day.ago, billed: true, from_adress: "Elsøvej, 7900 Nykøbing Mors", to_adress: "Skivevej 15, 8200, Thisted", taxfree: true},
                          { project: Project.second, user: User.first, value: 250, date: 20.day.ago, billed: true, from_adress: "Elsøvej, 7900 Nykøbing Mors", to_adress: "Skivevej 15, 8200, Thisted", taxfree: true},
                          { project: Project.second, user: User.first, value: 250, date: 30.day.ago, billed: true, from_adress: "Elsøvej, 7900 Nykøbing Mors", to_adress: "Skivevej 15, 8200, Thisted", taxfree: true},
                          { project: Project.third, user: User.second, value: 131, date: 51.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Mejerivej 25, 2300, Helsinge", taxfree: true},
                          { project: Project.third, user: User.second, value: 131, date: 71.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Mejerivej 25, 2300, Helsinge", taxfree: true},
                          { project: Project.third, user: User.second, value: 131, date: 81.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Mejerivej 25, 2300, Helsinge", taxfree: true},
                          { project: Project.fourth, user: User.second, value: 80, date: 9.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.fourth, user: User.second, value: 80, date: 1.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.fourth, user: User.second, value: 80, date: 2.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.fourth, user: User.second, value: 80, date: 3.day.ago, billed: false, from_adress: "Alsvej, 4500 Kolding", to_adress: "Møllevej 5, 7000, Horsens", taxfree: true},
                          { project: Project.fifth, user: User.first, value: 123, date: 5.day.ago, billed: false, from_adress: "Alsvej 45, 7800 Kolding", to_adress: "Mallevej 75, 7055, Hansestad", taxfree: false},
                          { project: Project.fifth, user: User.first, value: 123, date: 7.day.ago, billed: false, from_adress: "Alsvej 45, 7800 Kolding", to_adress: "Mallevej 75, 7055, Hansestad", taxfree: false},
                          { project: Project.fifth, user: User.first, value: 123, date: 8.day.ago, billed: false, from_adress: "Alsvej 45, 7800 Kolding", to_adress: "Mallevej 75, 7055, Hansestad", taxfree: false},
                          { project: Project.fifth, user: User.first, value: 123, date: 9.day.ago, billed: false, from_adress: "Alsvej 45, 7800 Kolding", to_adress: "Mallevej 75, 7055, Hansestad", taxfree: false}])

expenses = Expense.create([{ project: Project.first, user: User.first, amount: 100, date: 1.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.first, user: User.first, amount: 100, date: 2.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.first, user: User.first, amount: 100, date: 3.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.first, user: User.first, amount: 100, date: 5.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.first, user: User.first, amount: 100, date: 7.day.ago, billed: false, currency: "EUR", exchangerate: 7.46, description: "description", supplier: "Go Go Bar"},
                           { project: Project.first, user: User.first, amount: 100, date: 8.day.ago, billed: false, currency: "EUR", exchangerate: 7.46, description: "description", supplier: "Go Go Bar"},
                           { project: Project.first, user: User.first, amount: 100, date: 9.day.ago, billed: false, currency: "EUR", exchangerate: 7.46, description: "description", supplier: "Go Go Bar"},
                           { project: Project.second, user: User.first, amount: 250, date: 10.day.ago, billed: true, currency: "EUR", exchangerate: 7.46, description: "description", supplier: "Go Go Bar"},
                           { project: Project.second, user: User.first, amount: 250, date: 20.day.ago, billed: true, currency: "EUR", exchangerate: 7.46, description: "description", supplier: "Go Go Bar"},
                           { project: Project.second, user: User.first, amount: 250, date: 30.day.ago, billed: true, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.third, user: User.second, amount: 131, date: 51.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.third, user: User.second, amount: 131, date: 71.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.third, user: User.second, amount: 131, date: 81.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.fourth, user: User.second, amount: 80, date: 9.day.ago, billed: false, currency: "EUR", exchangerate: 7.46, description: "description", supplier: "Go Go Bar"},
                           { project: Project.fourth, user: User.second, amount: 80, date: 1.day.ago, billed: false, currency: "EUR", exchangerate: 7.46, description: "description", supplier: "Go Go Bar"},
                           { project: Project.fourth, user: User.second, amount: 80, date: 2.day.ago, billed: false, currency: "EUR", exchangerate: 7.46, description: "description", supplier: "Go Go Bar"},
                           { project: Project.fourth, user: User.second, value: 80, date: 3.day.ago, billed: false, currency: "EUR", exchangerate: 7.46, description: "description", supplier: "Go Go Bar"},
                           { project: Project.fifth, user: User.first, amount: 123, date: 5.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.fifth, user: User.first, amount: 123, date: 7.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.fifth, user: User.first, amount: 123, date: 8.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"},
                           { project: Project.fifth, user: User.first, amount: 123, date: 9.day.ago, billed: false, currency: "DKK", exchangerate: 1, description: "description", supplier: "gl. Brugs"}])


first = Date.ordinal(2018, 1)
last = Date.ordinal(2018, 280)

intprojects = Project.where(client_id: 1)
ordprojects = Project.where.not(client_id: 1)
users = User.all

first.upto(last) do |date|
  unless date.saturday? || date.sunday?
    users.each do |user|
      if rand(7) == 1
        proj = intprojects.sample
        cat = Category.last
      else
        proj = ordprojects.sample
        cat = Category.all[1..-2].sample
      end
      Hour.create({ project: proj, user: user, value: 6.2 + (rand(100)/50.0), date: date, billed: false, description: "ref #{rand(100)/49.0}", category: cat})
    end
  end
end
