require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::Helpers::TranslationHelper

  # Use :chrome to see the browser, or :headless_chrome for background tests
  # You can switch this by setting DRIVER=chrome in your terminal
  driven_by :selenium, using: (ENV["DRIVER"] == "chrome" ? :chrome : :headless_chrome), screen_size: [ 1400, 1400 ]

  def pause_for_human
    if ENV["DRIVER"] == "chrome" || ENV["SLOW"]
      sleep 1.0
    end
  end
end
