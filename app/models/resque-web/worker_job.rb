module ResqueWeb
  class WorkerJob < SimpleDelegator
    attr_reader :worker

    def initialize(worker)
      @worker = worker
      super
    end

    def run_at
      job['run_at']
    end

    def queue
      job['queue']
    end

    def worker_name
      @worker.to_s
    end

    def job_class
      job['payload']['class']
    end
  end
end
