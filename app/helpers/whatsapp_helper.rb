# app/helpers/whatsapp_helper.rb
module WhatsappHelper
  def whatsapp_link(phone_number, items)
    base_url = "https://wa.me/#{phone_number}"
    
    # Construimos el cuerpo del mensaje
    message = "¡Hola! Me gustaría comprar los siguientes productos:\n\n"
    
    items.each do |item|
      message += "- #{item.product.name} (Cantidad: #{item.quantity})\n"
    end
    
    message += "\n*Total: #{number_to_currency(items.sum(&:total_price))}*"

    # Es vital usar ERB::Util.url_encode para los espacios y caracteres especiales
    "#{base_url}?text=#{ERB::Util.url_encode(message)}"
  end
end