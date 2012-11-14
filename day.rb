class Day
  def render_in(pdf)
    # Settings
    text_color   = '000000'
    date_format  = '%d.%m.%Y'
    label_styles = {style: :bold, size: 16}
    medium_size  = 15

    # Initialization
    pdf.fill_color text_color

    # Invoice number and date
    pdf.move_down 20
    pdf.text "Invoice No. #{purchase.invoice_number}", label_styles
    pdf.text 'Issued on ' + purchase.paid_at.strftime(date_format)

    # Client
    pdf.move_down 25
    pdf.text 'CLIENT', label_styles
    [
        :full_name,
        :email,
        :address,
        :zip_and_city,
        :state,
        :country_name,
    ].each do |customer_field|
      value = purchase.send("customer_#{customer_field}")
      pdf.text value unless value.blank?
    end

    # Provider
    pdf.move_down 20
    pdf.text 'PROVIDER', label_styles
    pdf.text purchase.provider_details

    # Description
    pdf.move_down 50
    pdf.text 'DESCRIPTION', label_styles
    pdf.text 'Purchase for ' + pluralize(purchase.credits, 'credit')

    # Amount
    pdf.move_down 40

    if purchase.has_vat?
      pdf.text 'VAT BASE', label_styles
      pdf.text format_price(purchase.vat_base_amount)

      pdf.text "VAT AMOUNT, #{purchase.vat_percentage}%", label_styles
      pdf.text format_price(purchase.vat_amount)
    end

    pdf.text "TOTAL AMOUNT", label_styles
    pdf.text format_price(purchase.total_amount)

    # Footer texts
    if purchase.invoice_footer_text.present?
      pdf.bounding_box [pdf.bounds.left, 30], width: pdf.bounds.width do
        pdf.text purchase.invoice_footer_text, size: 10
      end
    end
  end
end
