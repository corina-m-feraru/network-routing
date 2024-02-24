
require 'net/http'
require 'json'

routers_url = URI('https://my-json-server.typicode.com/marcuzh/router_location_test_api/db')

response = Net::HTTP.get_response(routers_url)
data = JSON.parse(response.body)

# Creates the locations
data['locations'].each do |location_data|
  Location.create(name: location_data['name'], postcode: location_data['postcode'])
end

# Creates the routers
data['routers'].sort_by{|x| x['id']}.each do |router_data|
  location = Location.find(router_data['location_id'])
  Router.create(name: router_data['name'], location: location)
end

json_ids = data['routers'].map {|item| item['id']}.sort
router_ids = Router.all.pluck(:id).sort

# There are some ids discrepancies, the referenced ids within the links will not match the ones created in the DB hence
# sanitizing them and making sure they match; did not want to create the Routers objects with the hardcoded id
# as it is not best practice to hardcode a primary key leading to numerous data integrity issues and discrepancies

ids_to_be_replaced = json_ids - router_ids
# [14, 15]
replacemenent_ids = router_ids - json_ids
# [12, 13]
replacement_pair = Hash[ids_to_be_replaced.zip(replacemenent_ids)]

# Sanitizes the mismatched ids for the router links
replacement_pair.each do |ids_to_be_replaced|
  data['routers'].each do |router|
    if router['router_links'].include?(ids_to_be_replaced[0])
      router['router_links'].map! { |link| link == ids_to_be_replaced[0] ? ids_to_be_replaced[1] : link }
    end
  end
end

# Creates the router links associated objects
data['routers'].each do |router_data|
  router = Router.find_by(name: router_data['name'])
  router_data['router_links'].each do |router_link_id|
    linked_router = Router.find_by(id: router_link_id)
    router.router_links << RouterLink.create(router_id: router.id, linked_router_id: linked_router.id) if linked_router
  end
end

