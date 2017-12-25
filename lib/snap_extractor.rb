module SnapExtractor
  def self.extract(extractor)
    case extractor
    when []
      Rails.logger.info "No extrator with status 0"
    else
      puts extractor
      time_start = DateTime.now.utc
      schedule = extractor.first["schedule"]
      interval = intervaling(extractor.first["interval"])
      requestor = extractor.first["requestor"]
      camera_exid = extractor.first["camera_exid"]
      binding.pry
      puts "I am a test from SnapExtractor Module #{extractor}"
    end
  end

  def self.intervaling(interval)
    case interval
    when interval <= 0
      1
    else
      interval
    end
  end
end