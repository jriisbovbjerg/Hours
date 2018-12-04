class InvoicesPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(invoice)
    super()
    register_font
    @invoice = invoice
    upper_logo
    client(@invoice.payload["client"])
    invoice_details
    project(@invoice.payload["project"])
    move_cursor_to 480
    table(invoice_lines(@invoice.payload),
                        :column_widths => [60, 40, 290, 70, 80],
                        :header => true, 
                        :row_colors => ["EFEFEF", "FEFEFE"]) do
       cells.borders = []
       column(0).align = :right
       column(-1).align = :right
       column(-2).align = :right
       row(0).background_color = "CCCCCC"
       row(0).borders = [:bottom]
       row(-5).background_color = "FFFFFF"
       row(-5).borders = [:top]

       row(-4).background_color = "EEEEEE"
       row(-4).align = :right

       row(-3).background_color = "DDDDDD"
       row(-3).align = :right

       row(-2).background_color = "EEEEEE"
       row(-2).align = :right

       row(-1).background_color = "AAAAAA"
       row(-1).font_style = :bold
       row(-1).align = :right
       row(-1).borders = [:top]
    end

    bank_details
    footer
  end

  def upper_logo
    logopath =  "#{Rails.root}/app/assets/images/biir_only_logo_300x124.png"
    scale = 0.4
    image logopath, :width => 300 * scale, :height => 124 * scale
  end

  def client(info)
    bounding_box([20, 650], :width => 230, :height => 70) do
      text "#{info["companyname"]}"
      text "#{info["adress"]}"
      text "#{info["postalcode"]}"
      text "#{info["invoiceemail"]}"
    end
  end

  def project(info)
    bounding_box([20, 570], :width => 230, :height => 90) do
      text "Your Ref.: #{info["contact"]}"
      text "Currency: #{info["currency"]}"
      text "PO.:       #{info["PO"]}"
      text "WBS:"
      text "Our ref.: Jonas Bojer Christensen"
    end
  end

  def invoice_details
    bounding_box([370, 690], :width => 180, :height => 110) do
      text "INVOICE", :style => :bold
      text "Invoice No.: 008"
      text "Invoice Date: 30/11/2018"
      text "PMT Terms: 60EOM+5"
      text "Telephone: +45 41 77 07 01"
      text "Web: www.biir.dk"
      text "VAT number: 31762022"
    end
  end

  def invoice_lines(info)
    table_data = []
    grand_total = 0.0
    table_data << ["Qty", "Unit", "Item", "Unit Price", "Amount"]
    hours = info["hours"]["summary"]
    unless hours.blank?
      hours.each_with_index do |h, i|
        quant = number_with_precision(h["hours"], precision: 2, separator: ',', delimiter: '.')
        desc = "#{h["who"]}"
        rate = number_with_precision(h["rate"], precision: 2, separator: ',', delimiter: '.')
        tot = number_with_precision(h["hours"] * h["rate"], precision: 2, separator: ',', delimiter: '.')
        grand_total += h["hours"] * h["rate"]
        table_data << [quant, "hrs", desc, rate, tot]
      end
    end 

    mileages = info["mileages"]["summary"]
    unless mileages.blank?
      mileages.each_with_index do |h, i|
        quant = number_with_precision(h["distance"], precision: 2, separator: ',', delimiter: '.') 
        desc = "#{h["who"]}, #{h["description"]}"
        rate = number_with_precision(h["rate"], precision: 2, separator: ',', delimiter: '.')
        tot = number_with_precision((h["distance"] * h["rate"]), precision: 2, separator: ',', delimiter: '.')
        grand_total += h["distance"] * h["rate"]
        table_data << [quant, "km", desc, rate, tot]
      end 
    end
    
    expenses = info["expenses"]["summary"]
    unless expenses.blank? 
      expenses.each_with_index do |h, i|
        desc = "#{h["who"]}, #{h["what"]}"
        tot = number_with_precision(h["total"], precision: 2, separator: ',', delimiter: '.')
        grand_total += h["total"]
        table_data << ["1", "pcs", desc, tot, tot]
      end
    end
    #table_data << invoice_sum(grand_total)  
    table_data << [ " ", "", "","", "" ]
    table_data << [ "", "", "Sub total", "EUR", number_with_precision(grand_total, precision: 2, separator: ',', delimiter: '.') ]
    table_data << [ "", "", "Subject to VAT", "EUR", number_with_precision(grand_total, precision: 2, separator: ',', delimiter: '.') ]
    table_data << [ "", "", "VAT 25%", "EUR", number_with_precision(0.25 * grand_total, precision: 2, separator: ',', delimiter: '.') ]
    table_data << [ "", "", "Total amount", "EUR", number_with_precision(1.25 * grand_total, precision: 2, separator: ',', delimiter: '.') ]
    return table_data
  end

  def bank_details
    move_down 50
    draw_text "Payment after the due date incurs a 2% per month surcharge", :at => [40,85], :size => 10, :style => :bold
    draw_text "Bojer Innovativ IngeniørRådgivning Aps  |  Holger Drachmanns Vej 9, DK-8000 Århus C", :at => [20,60], :size => 12
    draw_text "Bank: Sparekassen Kronjylland   |   Bank address: Tronholmen 1, DK-8960 Randers SØ", :at => [20,45], :size => 12
    draw_text "Account: 6181-10561183   |   (BIC)Swift: KRONDK22   |   IBAN: DK6961810010561183", :at => [20,30], :size => 12
  end

  def footer
    repeat(:all) do
      logopath =  "#{Rails.root}/app/assets/images/biir_footer_1496x122.png"
      scale = 0.41
      image logopath, :width => 1496 * scale, :height => 122 * scale, :at => [-38,5]
    end
  end

  def register_font
    font_path = "#{Rails.root}/app/assets/fonts/"
    font_families.update("OpenSans" => {
      :normal => "#{font_path}OpenSans-Regular.ttf",
      :italic => "#{font_path}OpenSans-Italic.ttf",
      :bold => "#{font_path}OpenSans-Bold.ttf",
      :bold_italic => "#{font_path}OpenSans-BoldItalic.ttf"})
    font "OpenSans"
  end
end 