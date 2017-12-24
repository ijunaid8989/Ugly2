module SnapExtractor
  def self.extract(extractor)
    case extractor
    when []
      Rails.logger.info "No extrator with status 0"
    else
      puts "I am a test from SnapExtractor Module #{extractor}"
    end
  end
end