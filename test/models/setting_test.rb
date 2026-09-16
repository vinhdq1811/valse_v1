require "test_helper"

class SettingTest < ActiveSupport::TestCase
  test "trả về giá trị mặc định khi chưa cấu hình" do
    assert_equal 1, Setting.default_max_students
  end

  test "lưu và đọc lại giá trị tùy chỉnh" do
    Setting.default_max_students = 6
    assert_equal "6", Setting["default_max_students"]
    assert_equal 6, Setting.default_max_students
  end

  test "từ chối giá trị không hợp lệ" do
    assert_raises(ActiveRecord::RecordInvalid) { Setting["default_max_students"] = 0 }
    assert_raises(ActiveRecord::RecordInvalid) { Setting["default_max_students"] = "abc" }
  end
end
