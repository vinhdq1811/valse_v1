class PagesController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token, only: [:metform_insert, :metform_view]

  def home
    render_musicali_page("musicali-template.html")
  end

  def contact
    render_musicali_page("musicali-contact.html")
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

  private

  def render_musicali_page(filename)
    template = Rails.root.join("public", filename)
    html = File.binread(template).force_encoding(Encoding::UTF_8)
    html.gsub!(%r{<span class="__cf_email__"[^>]*>.*?</span>}) { |span| decode_cf_email(span) }
    html.sub!(%r{</head>}m) { "#{valse_stylesheets}\n</head>" }
    html.sub!(%r{<header id="masthead".*?</header>}m) { rails_header }
    render html: html.html_safe, layout: false
  end

  # CSS vp-* dùng chung cho header (file tĩnh gốc không có các stylesheet này).
  def valse_stylesheets
    helpers.stylesheet_link_tag("valse/base", "valse/header", "data-turbo-track": "reload")
  end

  # File template tĩnh chưa có trạng thái đăng nhập — thay bằng header partial
  # của Rails (động, đồng bộ với các trang dùng layout musicali).
  def rails_header
    rendered = render_to_string(partial: "layouts/musicali/header")
    rendered[%r{<header id="masthead".*?</header>}m] or raise "Header partial thiếu khối <header id=\"masthead\">"
  end

  # Decodes Cloudflare email-protection spans (<span class="__cf_email__"
  # data-cfemail="...">) back into the real email addresses shown on the
  # original site. Each span is decoded with its own XOR key.
  def decode_cf_email(span)
    encoded = span[/data-cfemail="([0-9a-f]+)"/, 1]
    return span unless encoded

    key = encoded[0, 2].to_i(16)
    encoded[2..].scan(/../).map { |byte| (byte.to_i(16) ^ key).chr }.join
  end
end
