class AddFieldsToProjects < ActiveRecord::Migration
  def change
    add_column(:projects, :currency, :string, default: "EUR")
    change_column_null(:projects, :currency, false)
    
    add_column(:projects, :period, :string, default: "hourly")
    change_column_null(:projects, :period, false)

    add_column(:projects, :valid_from, :string, default: -> { 'CURRENT_TIMESTAMP' } )
    change_column_null(:projects, :valid_from, false)
    
    add_column(:projects, :valid_to, :string, default: -> { 'CURRENT_TIMESTAMP' })
    change_column_null(:projects, :valid_to, false)

    add_column(:projects, :invoice_email, :string, default: "")
    change_column_null(:projects, :invoice_email, false)

    add_column(:projects, :reference_number, :string, default: "")
    change_column_null(:projects, :reference_number, false)
  end
end
