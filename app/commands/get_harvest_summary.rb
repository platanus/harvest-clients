class GetHarvestSummary < PowerTypes::Command.new(:client_id, :project_id)
  NUMBER_OF_MONTHS = ENV.fetch('NUMBER_OF_MONTHS').to_i

  def perform
    {
      title: title,
      hours_by_month: hours_by_month
    }
  end

  private

  def title
    return '' if entries.empty?

    if @project_id
      entries[0].attributes['project']['name']
    else
      entries[0].attributes['client']['name']
    end
  end

  def hours_by_month
    hours = init_hours
    entries.each do |entry|
      cur_month = get_month(entry.attributes['spent_date'])
      hours[cur_month] += entry.attributes['hours']
    end
    hours
  end

  def init_hours
    hours = {}
    (NUMBER_OF_MONTHS + 1).times { |i| hours[get_month(Time.zone.today - i.months)] = 0 }
    hours
  end

  def get_month(date)
    date = Time.zone.parse(date) if date.is_a?(String)
    date.strftime("%b-%Y")
  end

  def from
    @from ||= (Time.zone.today - NUMBER_OF_MONTHS.months).at_beginning_of_month
  end

  def entries
    @entries ||= harvest_service.get_time_entries(client_id: @client_id,
                                                  project_id: @project_id,
                                                  from: from,
                                                  to: Time.zone.today)
  end

  def harvest_service
    @harvest_service ||= HarvestService.new
  end
end
