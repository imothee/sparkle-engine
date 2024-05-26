# desc "Explaining what the task does"
# task :twinkle do
#   # Task goes here
# end

desc "Summarize Twinkle Events in the week period"
task :summarize_twinkle_events_week do
  week_start = Time.now.beginning_of_week
  week_end = Time.now.end_of_week
  
  Apps.all.each do |app|
    app.summarize_events(Summary.period[:week], week_start, week_end)
  end
end