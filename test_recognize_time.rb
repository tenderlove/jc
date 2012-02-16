require 'abstract_controller'
require 'action_controller'

require 'benchmark/ips'


rs = ActionDispatch::Routing::RouteSet.new
rs.draw do
  match '/foo/bar', :to => lambda { |env|
    [200, {}, ['hello world']]
  }

  match '/paths/:id', :to => lambda { |env|
    [200, {}, ['paths']]
  }

  match '/omg/*rest', :to => lambda { |env|
    [200, {}, ['paths']]
  }
end

def get(uri, routes)
  host = uri.host
  path = uri.path

  params = {'PATH_INFO'      => path,
            'REQUEST_METHOD' => 'GET',
            'HTTP_HOST'      => host}

  routes.call(params)[2].join
end

Benchmark.ips do |x|
  foobar = URI('http://localhost/foo/bar')
  x.report("foobar") { get foobar, rs }

  paths = URI('http://localhost/paths/1')
  x.report("paths") { get paths, rs }

  blob = URI('http://localhost/omg/hello/world')
  x.report("blob") { get blob, rs }
end

