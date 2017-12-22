class SnapshotExtractor < ApplicationRecord

  def self.start
    current_status = SnapshotExtractor.if_its_running
    logger.info "This is from info"

    run_or_not(current_status)
  end

  def self.if_its_running
    SnapshotExtractor
      .where(status: 1)
      .first
  end

  def self.fetch_details
    ApplicationController
      .helpers
      .execute_statement('SELECT s0."id", s0."from_date", s0."to_date", s0."interval", s0."schedule", f1."exid", f1."timezone", f1."name", s0."requestor" FROM "snapshot_extractors" AS s0 INNER JOIN LATERAL (SELECT * FROM cameras as cam WHERE cam.id = s0."camera_id") AS f1 ON TRUE WHERE (s0."status" = 1) ORDER BY s0."created_at" DESC LIMIT 1')
      #Make the query in model ASSOC
  end

  def self.run_or_not(args)
    case args
    when nil
      extractor = SnapshotExtractor.fetch_details
      logger.info "Starting Job"
      #TODO start the job now
    else
      logger.info "Job is already running"
    end
  end
end
