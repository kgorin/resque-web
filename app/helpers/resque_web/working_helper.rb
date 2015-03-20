module ResqueWeb
  module WorkingHelper
    def workers
      @workers ||= Resque.workers
    end

    def jobs
      @jobs ||= workers.map(&:job)
    end

    def worker_jobs
      @worker_jobs ||= workers.zip(jobs).reject { |w, j| w.idle? || j['queue'].nil? }
    end

    def sorted_worker_jobs(sort_by = 'run_at', desc = false)
      @sorted_worker_jobs ||= sorted_by(worker_jobs, sort_by, desc)
    end

  private

    def sorted_by(worker_jobs, sort_by, desc)
      res = case sort_by
      when 'run_at'
        worker_jobs.sort_by { |w, j| j['run_at'] || '' }
      when 'queue'
        worker_jobs.sort_by { |w, j| j['queue'] || '' }
      when 'worker_name'
        worker_jobs.sort_by { |w, j| w.to_s || '' }
      when 'job_class'
        worker_jobs.sort_by { |w, j| j['payload']['class'] || '' }
      end

      desc ? res.reverse : res
    end
  end
end
