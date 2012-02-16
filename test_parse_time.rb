require 'abstract_controller'
require 'action_controller'

require 'benchmark/ips'


rs = ActionDispatch::Routing::RouteSet.new

Benchmark.ips do |x|
  x.report("draw") {
    rs.draw do
      resources :users
      resources :paths
      resources :donuts
    end
  }
end
