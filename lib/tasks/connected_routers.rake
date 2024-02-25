namespace :connected_routers do
  desc 'Retrieves and outputs the unique bidirectional router connections'
  task get: :environment do
    connections = ConnectedRouters.call
    connections.each { |connection| puts connection }
  end
end
