require 'resque-web/worker_job'

module ResqueWeb
  module WorkingHelper
    def workers
      @workers ||= Resque.workers
    end

    def jobs
      @jobs ||= workers.map(&:job)
    end
  end
end
