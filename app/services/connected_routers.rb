class ConnectedRouters
  def self.call
    begin
      connected_routers = Router.joins(:linked_routers).distinct.map do |router|
        connections = RouterLink.where.not(router_id: router.id)
                                .where(linked_router_id: router.id)
                                .filter {|link| link.router.location_id != router.location_id }
        next unless connections.any?

        connections.map { |connection| [connection.router.location.name, connection.linked_router.location.name].join(' <-> ') }
      end.compact.flatten
      filter_unique_bidirectional_values(connected_routers)
    rescue StandardError => e
      puts "An error has occurred, please check: #{e.message}"
      return []
    end
  end

private

  def self.filter_unique_bidirectional_values(connected_routers)
    connected_routers.each_with_object({}) do |connection, hash|
      reverse_connection = connection.split(' <-> ').reverse.join(' <-> ')
      hash[connection] = true unless hash[reverse_connection]
    end.keys
  end
end