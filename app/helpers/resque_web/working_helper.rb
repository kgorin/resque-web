require 'resque-web/worker_job'

module ResqueWeb
  module WorkingHelper
    def workers
      @workers ||= Resque.workers
    end

    def jobs
      @jobs ||= workers.map(&:job)
    end

    def worker_jobs
      @worker_jobs ||= workers.
        map{ |w| ResqueWeb::WorkerJob.new(w) }.
        reject { |w| w.idle? || w.queue.nil? }
    end

    def sorted_worker_jobs(sort_by = 'run_at', desc = false)
      @sorted_worker_jobs ||= sorted_by(worker_jobs, sort_by, desc)
    end

  private

    def sorted_by(worker_jobs, sort_by, desc)
      res = worker_jobs.sort_by { |wj| wj.send(sort_by) }
      desc ? res.reverse : res
    end
  end
end
