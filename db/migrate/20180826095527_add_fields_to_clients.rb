class AddFieldsToClients < ActiveRecord::Migration

  def change
    add_column(:clients, :companyname, :string)
    change_column_null(:clients, :companyname, false, default: "companyname")
    
    add_column(:clients, :adress, :string)
    change_column_null(:clients, :adress, false, default: "adress")
    
    add_column(:clients, :otheradressinfo, :string)
    change_column_null(:clients, :otheradressinfo, false, default: "otheradressinfo")

    add_column(:clients, :invoiceemail, :string)
    change_column_null(:clients, :invoiceemail, false, default: "invoiceemail")

    add_column(:clients, :paymentterms, :string)
    change_column_null(:clients, :paymentterms, false, default: "paymentterms")
  end
end
