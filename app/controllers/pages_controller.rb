class PagesController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token, only: [:contact_form_submit, :contact_form_view]

  def home
    @page_title = t("pages.home.page_title")
    render "home", layout: "theme"
  end

  def contact
    @page_title = "Liên hệ"
    render "contact", layout: "theme"
  end

  def pricing
    @plans = Plan.ordered
    @page_title = "Bảng giá"
    render "pricing", layout: "theme"
  end

  def testimonials
    @testimonials = Testimonial.published.ordered
    @page_title = "Cảm nhận học viên"
    render "testimonials", layout: "theme"
  end

  def contact_form_submit
    contact = ContactMessage.new(
      name: params["contact-name"],
      email: params["contact-email"],
      phone: params["contact-phone"],
      title: params["contact-subject"],
      message: params["contact-message"]
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

  def contact_form_view
    head :no_content
  end
end
