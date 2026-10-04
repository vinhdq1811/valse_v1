class PagesController < ApplicationController
  allow_unauthenticated_access

  def home
    @page_title = t("pages.home.page_title")
    render "home", layout: "theme"
  end

  def contact
    @page_title = "Liên hệ"
    @contact_message = ContactMessage.new
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

  # Form Enquiry trang /contact — form Rails thường, POST tới contact_path
  def contact_form_submit
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save
      redirect_to contact_path, flash: {
        contact_form_success: "Thank you for contacting us. We will get back to you as soon as possible."
      }
    else
      @page_title = "Liên hệ"
      render "contact", layout: "theme", status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    {
      name: params["contact-name"],
      email: params["contact-email"],
      phone: params["contact-phone"],
      title: params["contact-subject"],
      message: params["contact-message"]
    }
  end
end
