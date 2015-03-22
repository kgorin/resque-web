module ResqueWeb
  class WorkingController < ResqueWeb::ApplicationController

    def index
      @worker_jobs = Resque.workers
        .map { |w| ResqueWeb::WorkerJob.new(w) }
        .reject { |wj| wj.idle? || wj.queue.nil? }
    end

  end
end
