class SchedulerPing
  include Sidekiq::Worker

  def perform(*args)
    puts 'sidekiq-scheduler is running'
  end
end
