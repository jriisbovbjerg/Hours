class AddFieldsToClients < ActiveRecord::Migration

  def change
    add_column(:clients, :companyname, :string, default: "")
    change_column_null(:clients, :companyname, false)
    
    add_column(:clients, :adress, :string, default: "")
    change_column_null(:clients, :adress, false)

    add_column(:clients, :postalcode, :string, default: "")
    change_column_null(:clients, :postalcode, false)
    
    add_column(:clients, :otherinfo, :string, default: "")
    change_column_null(:clients, :otherinfo, false)

    add_column(:clients, :invoiceemail, :string, default: "")
    change_column_null(:clients, :invoiceemail, false)

    add_column(:clients, :paymentterms, :string, default: "")
    change_column_null(:clients, :paymentterms, false)
  end
end
