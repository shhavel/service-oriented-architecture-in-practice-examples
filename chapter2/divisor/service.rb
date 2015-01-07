require "sinatra/main"
require "logger"

set :raise_errors, false # in production and dev mode it is false, so you probably do not need it
set :root, File.dirname(__FILE__)
log_file = File.new(File.join(settings.root, 'log', "#{settings.environment}.log"), 'a+')
log_file.sync = true
use Rack::CommonLogger, log_file
logger = Logger.new(log_file)
logger.formatter = ->(severity, time, progname, msg) { "#{msg}\n" }

before do
  env['rack.logger'] = logger
  content_type :txt
end

get "/api/v1/ratio/:a/:b" do
  logger.info "compute the result of integer division #{params[:a]} / #{params[:b]}"
  "#{params[:a].to_i / params[:b].to_i}"
end

error { "An internal server error occurred. Please try again later." }
