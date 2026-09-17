class PagesController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token, only: [:metform_insert, :metform_view]

  def home
    @page_title = "Trang chủ"
    render "home", layout: "musicali"
  end

  def contact
    @page_title = "Liên hệ"
    render "contact", layout: "musicali"
  end

  def pricing
    @plans = Plan.ordered
    @page_title = "Bảng giá"
    render "pricing", layout: "musicali"
  end

  def testimonials
    @testimonials = Testimonial.published.ordered
    @page_title = "Cảm nhận học viên"
    render "testimonials", layout: "musicali"
  end

  def metform_insert
    contact = ContactMessage.new(
      name: params["mf-listing-fname"],
      email: params["mf-email_527908"],
      phone: params["mf-telephone"],
      title: params["mf-title"],
      message: params["mf-textarea"]
    )

    if contact.save
      render json: {
        status: true,
        data: { message: "Thank you for contacting us. We will get back to you as soon as possible." }
      }
    else
      render json: {
        status: false,
        data: { message: contact.errors.full_messages.to_sentence }
      }
    end
  end

  def metform_view
    head :no_content
  end
end
