class HarvestService < PowerTypes::Service.new
  def initialize
    @client = Harvesting::Client.new
  end

  def get_time_entries(options)
    page = 1
    time_entries = []
    loop do
      request = @client.time_entries(options.merge(page: page))
      time_entries += request.entries
      page += 1
      break if page > request.attributes['total_pages']
    end
    time_entries
  end
end
