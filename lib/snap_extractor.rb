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

      timezone =
        case extractor.first["timezone"]
        when nil
          "Etc/UTC"
        else
          extractor.first["timezone"]
        end

      start_date = ActiveSupport::TimeZone[timezone].parse(extractor.first["from_date"])
      end_date = ActiveSupport::TimeZone[timezone].parse(extractor.first["to_date"])

      total_days = round(((end_date - start_date) / 86400).round)

      e_start_date = start_date.strftime("%A, %b %d %Y, %H:%M")
      e_to_date = end_date.strftime("%A, %b %d %Y, %H:%M")
      e_schedule = schedule
      e_interval = humanize_interval(interval)

      binding.pry
    end
  end

  def self.humanize_interval(interval)
    case interval
    when 60
      "1 Frame Every 1 min"
    when 300
      "1 Frame Every 5 min"
    when 600
      "1 Frame Every 10 min"
    when 900
      "1 Frame Every 15 min"
    when 1200
      "1 Frame Every 20 min"
    when 1800
      "1 Frame Every 30 min"
    when 3600
      "1 Frame Every hour"
    when 7200
      "1 Frame Every 2 hour"
    when 21600
      "1 Frame Every 6 hour"
    when 43200
      "1 Frame Every 12 hour"
    when 86400
      "1 Frame Every 24 hour"
    when 1
      "All"
    end
  end

  def self.round(days)
    case days
    when 0
      2
    else
      days + 1
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

  def self.request_from_seaweedfs(url, type, attribute)
    request = get(url)
    case
    when request.status == 200 && request.reason_phrase == "OK"
      data = JSON.parse(request.body)
      case data[type].kind_of? Array
      when true
        data[type].map { |e| e[attribute] }
      else
        []
      end
    else
      []
    end
  end

  def self.get(url)
    conn(url).get do |request|
      request.headers['Accept'] = 'application/json'
      request.options.timeout = 15000
    end
  end

  def self.conn(url)
    Faraday.new(:url => url) do |c|
      c.use Faraday::Response::Logger     # log request & response to STDOUT
      c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
    end
  end
end
