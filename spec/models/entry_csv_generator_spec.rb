require "csv"

describe EntryCSVGenerator do
  let(:first_entry) { build_stubbed(:hour) }
  let(:second_entry) { build_stubbed(:hour) }
  let(:third_entry) { build_stubbed(:mileage) }
  let(:fourth_entry) { build_stubbed(:mileage) }
  let(:fifth_entry) { build_stubbed(:expense) }
  let(:sixth_entry) { build_stubbed(:expense) }

  let(:generator) do
    EntryCSVGenerator.new([first_entry, second_entry],
                          [third_entry, fourth_entry],
                          [fifth_entry, sixth_entry])
  end

  it "generates csv" do
    csv = generator.generate

    expect(csv).to include(
      #Date  User  Project Client  Hours Billable  Billed  Description Category
      "Date,User,Project,Client,Hours,Billable,Billed,Description,Category")
    expect(csv).to include(
      #Date  User  Project Client  Kilometers  Billable  Billed  From Adress To Adress
      "Date,User,Project,Client,Kilometers,Billable,Billed,From Adress,To Adress")
    expect(csv).to include(
      #Date  User  Project Client  Value Billable  Billed  Description Supplier  Currency  Exchangerate
      "Date,User,Project,Client,Value,Billable,Billed,Description,Supplier,Currency,Exchangerate")
    
    expect(csv.lines.count).to eq(15)
    expect(csv.lines.second.split(",").count).to eq(1)
    expect(csv.lines.last.split(",").count).to eq(11)
  end

  it "localizes the separator" do
    I18n.locale = :nl
    expect(generator.options).to include(col_sep: ";")
    I18n.locale = I18n.default_locale
    expect(generator.options).to include(col_sep: ",")
  end
end
