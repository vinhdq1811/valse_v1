# Kinh doanh: Khóa học piano (4 khóa), Sheet nhạc, Đàn piano
# Mọi khóa học dùng chung 2 gói học phí (bảng plans bên dưới).

Booking.destroy_all
Lesson.destroy_all
Enrollment.destroy_all
BusyDate.destroy_all
Availability.destroy_all
Plan.destroy_all
Product.destroy_all

# ---- Gói học phí (áp dụng cho tất cả khóa học piano) ----
Plan.create!(
  name: "Gói Linh hoạt",
  tagline: "Đến học thoải mái theo thời gian của bạn",
  duration: "3 tháng",
  session_rule: "Tối đa 3 buổi/tuần · Đăng ký buổi học trước trên website",
  price: 5_000_000,
  features: [
    "Thời lượng khóa học 3 tháng",
    "Đăng ký buổi học trước trên website",
    "Tối đa 3 buổi mỗi tuần",
    "Học 1 kèm 1 cùng giảng viên",
    "Miễn phí tài liệu & sheet nhạc trong khóa",
    "Linh hoạt đổi lịch buổi học"
  ],
  position: 1
)

Plan.create!(
  name: "Gói 30 buổi",
  tagline: "Cam kết lộ trình trọn vẹn 30 buổi",
  duration: "6 tháng",
  session_rule: "Trọn 30 buổi học · Đăng ký linh hoạt trong 6 tháng",
  price: 5_000_000,
  features: [
    "Thời lượng khóa học 6 tháng",
    "Trọn 30 buổi học",
    "Đăng ký lịch linh hoạt từng tuần",
    "Học 1 kèm 1 cùng giảng viên",
    "Miễn phí tài liệu & sheet nhạc trong khóa",
    "Kiểm tra đánh giá định kỳ cuối tháng"
  ],
  position: 2
)

# ---- Khóa học Piano ----
img = "/wp-content/uploads/2024/08"

Product.create!(
  name: "Khóa học Piano Cơ bản",
  slug: "piano-co-ban",
  category: :course,
  summary: "Xây dựng nền tảng vững chắc từ con số 0: tư thế, đọc nhạc và kỹ thuật ngón tay cơ bản.",
  description: <<~TEXT,
    Khóa học dành cho người mới bắt đầu, chưa từng tiếp xúc với piano. Bạn sẽ được làm quen với nhạc cụ, học cách đọc bản nhạc, nhận diện nốt nhạc và thực hành các bài tập kỹ thuật cơ bản theo giáo trình chuẩn.

    Sau khóa học, bạn có thể tự tin chơi các bản nhạc đơn giản, đọc được bản nhạc cơ bản và có nền tảng vững chắc để tiếp tục học đệm hát hoặc cổ điển.
  TEXT
  highlights: [
    "Dành cho người chưa từng học piano",
    "Đọc nhạc & lý thuyết âm nhạc nền tảng",
    "Kỹ thuật ngón tay, tư thế ngồi đúng chuẩn",
    "Chơi được các bản nhạc đơn giản sau khóa học"
  ],
  image: "#{img}/valse-img-01.jpg",
  position: 1
)

Product.create!(
  name: "Khóa học Đệm hát Piano",
  slug: "piano-dem-hat",
  category: :course,
  summary: "Tự đệm hát những bản nhạc yêu thích bằng hợp âm — nhanh, thực tế, dễ áp dụng.",
  description: <<~TEXT,
    Khóa học tập trung vào thực hành: hợp âm, vòng hợp âm thông dụng và các kiểu đệm (arpeggio, block chord, rhythm) cho dòng nhạc pop, ballad.

    Bạn sẽ học cách đọc bảng hợp âm (chord chart), đệm hát theo sở thích cá nhân và tự chơi được những bài hát mình yêu thích chỉ sau vài tuần.
  TEXT
  highlights: [
    "Hợp âm & vòng hợp âm thông dụng",
    "Đọc bảng hợp âm (chord chart)",
    "Kiểu đệm pop, ballad, arpeggio",
    "Tự đệm hát bản nhạc yêu thích của bạn"
  ],
  image: "#{img}/valse-img-02.jpg",
  position: 2
)

Product.create!(
  name: "Khóa học Piano Cổ điển",
  slug: "piano-co-dien",
  category: :course,
  summary: "Chinh phục các tác phẩm kinh điển và luyện thi chứng chỉ ABRSM, LCM bài bản.",
  description: <<~TEXT,
    Khóa học đi sâu vào kỹ thuật biểu diễn cổ điển: từ các tác phẩm Baroque, Classical đến Romantic. Giáo trình bám sát chương trình các cấp độ của ABRSM và LCM.

    Giảng viên hướng dẫn chi tiết về nghệ thuật pedal, biểu cảm âm nhạc và kỹ thuật chạy ngón nâng cao, giúp bạn tự tin biểu diễn và đạt kết quả cao trong các kỳ thi chứng chỉ.
  TEXT
  highlights: [
    "Tác phẩm kinh điển từ Baroque đến Romantic",
    "Kỹ thuật chạy ngón & pedal nâng cao",
    "Luyện thi chứng chỉ ABRSM, LCM",
    "Biểu cảm âm nhạc & kỹ thuật biểu diễn"
  ],
  image: "#{img}/valse-img-03.jpg",
  position: 3
)

Product.create!(
  name: "Khóa học Piano Trẻ em",
  slug: "piano-tre-em",
  category: :course,
  summary: "Làm quen âm nhạc qua trò chơi và bài hát thiếu nhi — dành cho bé từ 4 đến 12 tuổi.",
  description: <<~TEXT,
    Khóa học thiết kế riêng cho trẻ em từ 4 đến 12 tuổi, giúp bé yêu âm nhạc từ những buổi học đầu tiên thông qua trò chơi âm nhạc, bài hát thiếu nhi quen thuộc và các hoạt động tiết tấu vui nhộn.

    Giảng viên có kinh nghiệm dạy trẻ, theo sát tiến độ của từng bé và cập nhật thường xuyên cho phụ huynh. Bé sẽ phát triển thính giác, khả năng tập trung và sự tự tin khi biểu diễn.
  TEXT
  highlights: [
    "Dành cho bé từ 4 đến 12 tuổi",
    "Làm quen âm nhạc qua trò chơi",
    "Bài hát thiếu nhi quen thuộc",
    "Phát triển thính giác & tiết tấu"
  ],
  image: "#{img}/valse-img-05.jpg",
  position: 4
)

# ---- Sheet nhạc ----
Product.create!(
  name: "Sheet: Canon in D — Pachelbel (Trung cấp)",
  slug: "canon-in-d-pachelbel",
  category: :sheet,
  summary: "Bản nhạc kinh điển bất hủ, trình bày đầy đủ cho piano solo. File PDF 6 trang.",
  description: "Bản xếp tấu Canon in D cho piano solo ở trình độ trung cấp, giữ trọn vẹn giai điệu gốc với phần hòa âm phù hợp tay đệm hát. Bao gồm cả bản nhạc có ghi chú ngón tay (fingering) chi tiết.",
  highlights: ["PDF 6 trang, có ghi chú ngón", "Trình độ trung cấp", "Bản quyền in cá nhân"],
  image: "#{img}/valse-img-012.jpg",
  price: 80_000,
  position: 1
)

Product.create!(
  name: "Sheet: Tuyển tập Nhạc Trẻ đệm Piano — Tập 1",
  slug: "tuyen-tap-nhac-tre-tap-1",
  category: :sheet,
  summary: "20 bản nhạc trẻ Việt Nam được chuyển soạn cho piano đệm hát, kèm bảng hợp âm.",
  description: "Tuyển tập 20 ca khúc nhạc trẻ phổ biến được chuyển soạn cho piano, trình bày dưới dạng giai điệu + hợp âm, phù hợp để vừa đệm hát vừa biểu diễn. Kèm hướng dẫn ký hiệu đệm cơ bản.",
  highlights: ["20 bản nhạc trẻ nổi tiếng", "Giai điệu + hợp âm đầy đủ", "PDF 45 trang"],
  image: "#{img}/valse-img-013.jpg",
  price: 120_000,
  position: 2
)

Product.create!(
  name: "Sheet: Für Elise — Beethoven (Cơ bản)",
  slug: "fur-elise-beethoven",
  category: :sheet,
  summary: "Tác phẩm kinh điển quen thuộc trong bản đơn giản hóa cho người mới học.",
  description: "Bản đơn giản hóa của Für Elise dành cho trình độ cơ bản, giữ nguyên phần chủ đề nổi tiếng nhất. Là lựa chọn hoàn hảo cho buổi biểu diễn đầu tiên của học viên.",
  highlights: ["Bản đơn giản hóa", "Trình độ cơ bản", "PDF 3 trang, có ngón tay"],
  image: "#{img}/valse-img-014.jpg",
  price: 60_000,
  position: 3
)

Product.create!(
  name: "Sheet: Nhạc phim Ghibli tuyển chọn (Piano solo)",
  slug: "nhac-phim-ghibli-tuyen-chon",
  category: :sheet,
  summary: "5 bản nhạc phim Ghibli nổi tiếng nhất, xếp tấu cho piano solo trình độ trung cấp.",
  description: "Tuyển chọn 5 bản nhạc kinh điển từ các bộ phim Ghibli: Merry-Go-Round of Life, One Summer's Day, A Town with an Ocean View và hai bản khác. Bản xếp tấu trung cấp, giàu cảm xúc.",
  highlights: ["5 bản nhạc phim Ghibli", "Trình độ trung cấp", "PDF 24 trang"],
  image: "#{img}/valse-img-015.jpg",
  price: 150_000,
  position: 4
)

Product.create!(
  name: "Bộ Sheet: 20 bài tập kỹ thuật hàng ngày",
  slug: "20-bai-tap-ky-thuat-hang-ngay",
  category: :sheet,
  summary: "Bộ bài tập ngón tay thiết kế theo từng cấp độ, dùng kèm cho mọi khóa học.",
  description: "Bộ 20 bài tập kỹ thuật được thiết kế theo lộ trình từ cơ bản đến nâng cao, giúp rèn độ dẻo dai, độc lập của ngón tay và kiểm soát âm thanh. Dùng kèm hiệu quả cho cả 4 khóa học piano.",
  highlights: ["20 bài tập theo cấp độ", "Kèm hướng dẫn tập luyện", "PDF 18 trang"],
  image: "#{img}/valse-img-016.jpg",
  price: 90_000,
  position: 5
)

# ---- Đàn piano ----
Product.create!(
  name: "Đàn Piano Điện Yamaha P-145",
  slug: "piano-dien-yamaha-p-145",
  category: :piano,
  summary: "Piano điện 88 phím cảm ứng nặng, âm thanh grand piano — lựa chọn số 1 cho người mới.",
  description: "Yamaha P-145 sở hữu 88 phím graded hammer action cho cảm giác bấm gần như đàn cơ, âm thanh sampled từ đại dương cầm Yamaha CFIIIS. Thiết kế mỏng nhẹ, phù hợp căn hộ và người mới bắt đầu.",
  highlights: ["88 phím GHS cảm ứng nặng", "10 voices, chế độ dual", "Kbao gồm chân đàn + ghế"],
  image: "#{img}/valse-img-017.jpg",
  price: 18_900_000,
  position: 1
)

Product.create!(
  name: "Đàn Piano Điện Roland RP30",
  slug: "piano-dien-roland-rp30",
  category: :piano,
  summary: "Piano điện dạng tủ với hệ phím Roland nổi tiếng bền bỉ, phù hợp học lâu dài.",
  description: "Roland RP30 là piano điện dạng tủ (cabinet) với hệ phím cơ cấu búa Roland lừng danh độ bền, âm thanh SuperNATURAL rõ ràng. Hệ thống loa hai chiều cho trải nghiệm chơi tại nhà trọn vẹn.",
  highlights: ["Hệ phím cơ cấu búa Roland", "Âm thanh SuperNATURAL", "Dạng tủ, kèm ghế đàn"],
  image: "#{img}/valse-img-018.jpg",
  price: 21_500_000,
  position: 2
)

Product.create!(
  name: "Đàn Piano Cơ Kawai K-200",
  slug: "piano-co-kawai-k-200",
  category: :piano,
  summary: "Upright piano cơ Nhật Bản 121cm, âm thanh ấm — dành cho học viên nghiêm túc.",
  description: "Kawai K-200 là upright piano cơ 121cm thuộc dòng K Series nổi tiếng, được sử dụng rộng rãi tại các trường âm nhạc. Phím hành động Millennium III cho độ nhạy và độ bền vượt trội, âm thanh ấm áp, sâu lắng.",
  highlights: ["Piano cơ Nhật Bản, cao 121cm", "Hệ phím Millennium III", "Bảo hành 10 năm"],
  image: "#{img}/valse-img-020.jpg",
  price: 89_000_000,
  position: 3
)

Product.create!(
  name: "Đàn Piano Yamaha U1J (Mới 100%)",
  slug: "piano-yamaha-u1j",
  category: :piano,
  summary: "Biểu tượng upright piano 121cm — chuẩn âm thanh cho gia đình và phòng thu.",
  description: "Yamaha U1J là phiên bản tối ưu của dòng U1 huyền thoại — upright piano bán chạy nhất thế giới. Chất gỗ được chọn lọc kỹ, âm thanh sáng, lực phím đồng đều, phù hợp từ học viên đến người chơi chuyên nghiệp.",
  highlights: ["Dòng U1 huyền thoại, 121cm", "Âm thanh sáng, lực phím đều", "Bảo hành chính hãng 10 năm"],
  image: "#{img}/Gallery-01.jpg",
  price: 139_000_000,
  position: 4
)


# ============================================================
# BLOG: users (role), categories, tags, posts (Action Text + ảnh)
# ============================================================

def seed_blog_image(post, filename)
  path = Rails.root.join("public/wp-content/uploads/2024/08/#{filename}")
  return unless File.exist?(path)

  post.featured_image.attach(io: File.open(path), filename: filename, content_type: "image/jpeg")
end

users_seed = {
  "superadmin@valse.test" => { name: "Super Admin", role: :superadmin },
  "admin@valse.test" => { name: "Quản trị viên", role: :admin },
  "teacher@valse.test" => { name: "Nguyễn Thu Hà", role: :teacher },
  "teacher2@valse.test" => { name: "Trần Minh Quân", role: :teacher },
  "student@valse.test" => { name: "Học viên demo", role: :student },
  "student2@valse.test" => { name: "Lê Gia Bảo", role: :student }
}

author = nil
users_seed.each do |email, attrs|
  user = User.find_or_initialize_by(email_address: email)
  user.name = attrs[:name]
  user.role = attrs[:role]
  user.password = "password123"
  user.save!
  author = user if attrs[:role] == :teacher
end

categories_seed = {
  "String Instruments" => "Đàn guitar, ukulele và các nhạc cụ dây",
  "Jazz and Improvisation" => "Kỹ thuật jazz và ứng tấu",
  "Percussion and Drumming" => "Trống và nhạc cụ gõ",
  "Guitar Mastery" => "Lộ trình chinh phục guitar",
  "Piano Lessons" => "Kỹ thuật và bài tập piano"
}

categories = {}
categories_seed.each_key do |name|
  categories[name] = Category.find_or_create_by!(name: name)
end

tags_seed = %w[guitar fingerstyle beginner piano jazz ukulele practice]
tags = {}
tags_seed.each do |name|
  tags[name] = Tag.find_or_create_by!(name: name)
end

posts_seed = [
  {
    title: "Mastering Fingerstyle Guitar: A Step-by-Step Course for Beginners",
    slug: "mastering-fingerstyle-guitar-a-step-by-step-course-for-beginners",
    category: "String Instruments",
    tags: %w[guitar fingerstyle beginner],
    image: "Blog-05.jpg",
    published_at: Time.zone.local(2024, 8, 29, 10, 0, 0),
    excerpt: "Learn fingerstyle guitar from the ground up: hand positioning, basic patterns and open chords to build a solid foundation.",
    body: <<~HTML
      <h2>Understanding the Basics of Fingerstyle Guitar</h2>
      <p>Before diving into techniques, it's important to understand what fingerstyle guitar is. Unlike using a pick, in fingerstyle playing, each finger plucks individual strings. Typically, the thumb plays the bass notes (on the 6th, 5th, and 4th strings), while the index, middle, and ring fingers play the higher strings. This method gives you greater control over tone and dynamics.</p>
      <p>Key points:</p>
      <ul>
        <li><strong>Posture and Hand Positioning:</strong> Start by ensuring your thumb is placed behind the neck and your fingers are arched slightly above the strings.</li>
        <li><strong>Nail Length:</strong> Some fingerstyle players prefer using their fingernails, while others play with the flesh of their fingers. Experiment to see what works best for you.</li>
      </ul>
      <h2>2. Fingerstyle Patterns for Beginner</h2>
      <p>Now that you're comfortable with basic fingerstyle patterns, introduce open chords like C, G, Am, and Em into your practice. These chords are perfect for beginners and give you a solid foundation to experiment with different fingerpicking patterns.</p>
      <p>Recording yourself is a great way to track your progress and identify areas for improvement. You can start by recording simple exercises and gradually move to songs. Listening back will help you notice things like timing, clarity, and dynamics that you might miss while playing.</p>
      <ul>
        <li><strong>Be Patient:</strong> Fingerstyle guitar takes time and practice, so don't rush.</li>
        <li><strong>Daily Practice:</strong> Consistent practice, even if it's just 15-30 minutes a day, is crucial.</li>
        <li><strong>Enjoy the Process:</strong> Make sure you're having fun! Explore different songs and techniques to keep yourself motivated.</li>
      </ul>
      <h2>3. Practicing with Open Chords</h2>
      <p>Combine the patterns you learned with open chord progressions. Start slowly with a steady tempo, then gradually increase speed as muscle memory develops. A metronome is your best friend here.</p>
    HTML
  },
  {
    title: "Why Ukulele is the Ideal Instrument for First-Time Musicians",
    slug: "why-ukulele-is-the-ideal-instrument-for-first-time-musicians-2",
    category: "Jazz and Improvisation",
    tags: %w[ukulele beginner],
    image: "Blog-06.jpg",
    published_at: Time.zone.local(2024, 8, 29, 9, 0, 0),
    excerpt: "Lightweight, friendly and fun — discover why the ukulele is the perfect first instrument for learners of all ages.",
    body: "<p>The ukulele has earned its reputation as one of the most beginner-friendly instruments in the world...</p><h2>Easy on the Fingers</h2><p>Nylon strings are gentle on fingertips, making longer practice sessions comfortable from day one.</p><h2>Fast Wins</h2><p>With just four strings and a handful of chords, students can play real songs within their first week.</p>"
  },
  {
    title: "Jazz Piano Improvisation: Techniques for Intermediate Players",
    slug: "jazz-piano-improvisation-techniques-for-intermediate-players",
    category: "Percussion and Drumming",
    tags: %w[piano jazz],
    image: "Blog-04.jpg",
    published_at: Time.zone.local(2024, 8, 29, 8, 0, 0),
    excerpt: "Take your jazz piano playing further with ii-V-I lines, comping rhythms and chord substitutions.",
    body: "<p>Improvisation is the heart of jazz. For intermediate players, the journey continues with deeper harmonic vocabulary...</p><h2>Master the ii-V-I</h2><p>Practice lines over the most common progression in jazz, starting in C major and moving around the circle of fifths.</p><h2>Comping with Rhythm</h2><p>Great comping is about space and time — experiment with shell voicings and syncopated rhythms.</p>"
  },
  {
    title: "Why Ukulele is the Ideal Instrument for First-Time Musicians",
    slug: "why-ukulele-is-the-ideal-instrument-for-first-time-musicians",
    category: "String Instruments",
    tags: %w[ukulele beginner],
    image: "Blog-03.jpg",
    published_at: Time.zone.local(2024, 8, 29, 7, 0, 0),
    excerpt: "Small size, big smiles — how the ukulele builds confidence in brand-new musicians.",
    body: "<p>Don't let its size fool you — the ukulele is a serious gateway into music...</p><h2>Portable and Affordable</h2><p>You can take it anywhere, and entry-level models cost less than most other instruments.</p><h2>A Gateway Instrument</h2><p>Many guitarists started on the ukulele — the skills transfer directly.</p>"
  },
  {
    title: "The Best Guitar Scales Every Beginner Should Learn First",
    slug: "the-best-guitar-scales-every-beginner-should-learn-first",
    category: "Guitar Mastery",
    tags: %w[guitar beginner practice],
    image: "Blog-02.jpg",
    published_at: Time.zone.local(2024, 8, 29, 6, 0, 0),
    excerpt: "Start with the minor pentatonic, the blues scale and the major scale — the three pillars of guitar playing.",
    body: "<p>Scales are the vocabulary of music. Here are the three every beginner should prioritize...</p><h2>1. The Minor Pentatonic</h2><p>Five notes, endless possibilities — the foundation of rock and blues soloing.</p><h2>2. The Blues Scale</h2><p>Add one note to the pentatonic and unlock the classic blues sound.</p><h2>3. The Major Scale</h2><p>The mother of all scales — everything else is measured against it.</p>"
  },
  {
    title: "Mastering the Piano: Essential Techniques for Beginner Pianists",
    slug: "mastering-the-piano-essential-techniques-for-beginner-pianists",
    category: "Piano Lessons",
    tags: %w[piano beginner practice],
    image: "Blog-01.jpg",
    published_at: Time.zone.local(2024, 8, 29, 5, 0, 0),
    excerpt: "Posture, hand position and daily drills — build correct habits from your very first piano lesson.",
    body: "<p>Good technique starts from day one. These fundamentals will shape everything you play...</p><h2>Sit Tall, Play Relaxed</h2><p>Adjust your bench height so your forearms are level with the keys.</p><h2>Curved Fingers, Natural Hand</h2><p>Imagine holding a small ball — that's the shape your hand should keep.</p><h2>Practice Slowly</h2><p>Speed is a byproduct of accuracy. Start slow and let tempo come naturally.</p>"
  }
]

posts_seed.each do |attrs|
  post = Post.find_or_initialize_by(slug: attrs[:slug])
  post.title = attrs[:title]
  post.category = categories[attrs[:category]]
  post.author = author || User.staff.first
  post.excerpt = attrs[:excerpt]
  post.status = :published
  post.published_at = attrs[:published_at]
  post.body = attrs[:body]
  post.save!

  seed_blog_image(post, attrs[:image]) unless post.featured_image.attached?
  attrs[:tags].each { |tag_name| post.tags << tags[tag_name] unless post.tags.include?(tags[tag_name]) }
end

# ============================================================
# TESTIMONIALS: cảm nhận học viên (trang /testimonials + trang chủ)
# ============================================================

Testimonial.destroy_all

def seed_testimonial_avatar(testimonial, filename)
  path = Rails.root.join("public/wp-content/uploads/2024/08/#{filename}")
  return unless File.exist?(path)

  testimonial.avatar.attach(io: File.open(path), filename: filename, content_type: "image/jpeg")
end

testimonials_seed = [
  {
    name: "Sarah M",
    role: "CEO của Tech Solutions",
    quote: "Khóa học thực sự là một bước ngoặt! Nó giúp tôi hiểu sâu hơn về lý thuyết âm nhạc lẫn kỹ thuật biểu diễn. Đặc biệt đáng để giới thiệu!",
    image: "Testimonials-02.jpg",
    position: 1
  },
  {
    name: "David H",
    role: "CFO của Green Energy Corp",
    quote: "Tôi rất thích cách dạy thực hành của khóa học. Các giảng viên tài năng tuyệt vời, và tôi chưa bao giờ tự tin về khả năng âm nhạc của mình như bây giờ.",
    image: "Testimonials-01.jpg",
    position: 2
  },
  {
    name: "Lisa R.",
    role: "Giám đốc HealthCare",
    quote: "Từ sáng tác nhạc đến làm chủ nhạc cụ, khóa học này có đủ mọi thứ! Bài học được thiết kế bài bản và thật sự cuốn hút.",
    image: "Testimonials-05.jpg",
    position: 3
  },
  {
    name: "Ethan Marshall",
    role: "Chủ cửa hàng Nancy's Boutique",
    quote: "Dù bạn mới học piano hay đã ở trình độ nâng cao, khóa học đều có nội dung phù hợp với bạn. Sự linh hoạt và hỗ trợ của giảng viên thật tuyệt vời!",
    image: "Testimonials-03.jpg",
    position: 4
  },
  {
    name: "Olivia Bennett",
    role: "CEO Agency Marketing",
    quote: "Khóa học chuyên sâu âm nhạc giúp tôi tiến bộ cả về kỹ năng biểu diễn lẫn kiến thức sản xuất nhạc. Hoàn hảo cho những ai khát khao theo đuổi con đường âm nhạc!",
    image: "Testimonials-04.jpg",
    position: 5,
    show_on_home: true
  }
]

testimonials_seed.each do |attrs|
  testimonial = Testimonial.create!(
    name: attrs[:name],
    role: attrs[:role],
    quote: attrs[:quote],
    position: attrs[:position],
    show_on_home: attrs.fetch(:show_on_home, false),
    published: true
  )
  seed_testimonial_avatar(testimonial, attrs[:image])
end


# ============================================================
# ĐẶT LỊCH HỌC: cài đặt hệ thống, khung giờ dạy, ngày nghỉ,
# đăng ký khóa học (enrollment) cho học viên
# ============================================================

Setting["default_max_students"] = 2

teacher1 = User.find_by!(email_address: "teacher@valse.test")
teacher2 = User.find_by!(email_address: "teacher2@valse.test")
student1 = User.find_by!(email_address: "student@valse.test")
student2 = User.find_by!(email_address: "student2@valse.test")

availabilities_seed = [
  [teacher1, 1, "08:00", "09:00", nil],   # Thứ 2 sáng — sĩ số mặc định
  [teacher1, 3, "18:00", "19:30", 4],     # Thứ 4 tối — lớp nhóm
  [teacher1, 6, "09:00", "11:00", 1],     # Thứ 7 — 1 kèm 1
  [teacher2, 2, "17:30", "19:00", nil],   # Thứ 3 tối — sĩ số mặc định
  [teacher2, 4, "18:00", "19:00", nil],   # Thứ 5 tối — sĩ số mặc định
  [teacher2, 0, "09:00", "10:30", 3]      # Chủ nhật sáng — lớp nhóm nhỏ
].freeze

availabilities_seed.each do |teacher, weekday, starts, ends, max|
  Availability.find_or_create_by!(
    user: teacher,
    weekday: weekday,
    start_time: Time.parse(starts),
    end_time: Time.parse(ends)
  ) { |slot| slot.max_students = max }
end

BusyDate.find_or_create_by!(user: teacher1, date: Time.zone.today.next_occurring(:friday))

enrollments_seed = [
  [student1, "Gói Linh hoạt", 2, 24],
  [student2, "Gói 30 buổi", 3, 30]
].freeze

enrollments_seed.each do |student, plan_name, per_week, total|
  plan = Plan.find_by!(name: plan_name)
  Enrollment.find_or_create_by!(user: student, plan: plan) do |enrollment|
    enrollment.lessons_per_week = per_week
    enrollment.total_lessons = total
    enrollment.active = true
  end
end
