module ResqueWeb
  class OverviewController < ResqueWeb::ApplicationController
    def show
      order_by = params.fetch(:order_by, :run_at)
      desc = params.fetch(:desc, false) == '1'

      @worker_jobs = Resque.workers
        .map { |w| ResqueWeb::WorkerJob.new(w) }
        .reject { |wj| wj.idle? || wj.queue.nil? }

      @worker_jobs = sort(@worker_jobs, order_by, desc) if order_by

      render :layout => !request.xhr?, :locals => { :polling => request.xhr? }
    end

    protected

    def sort(worker_jobs, sort_by, desc)
      res = worker_jobs.sort_by { |wj| wj.send(sort_by) }
      desc ? res.reverse : res
    end
  end
end
