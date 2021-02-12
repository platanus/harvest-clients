class TimeController < ApplicationController
  def show
    if time_params[:client_id].blank? && time_params[:project_id].blank?
      @error_message = 'Debes incluir un id de cliente o proyecto'
    else
      @client = harvest_summary[:client]
      @hours_by_month = harvest_summary[:hours_by_month]
    end
  end

  private

  def harvest_summary
    @harvest_summary ||= GetHarvestSummary.for(client_id: time_params[:client_id],
                                               project_id: time_params[:project_id])
  end

  def time_params
    params.permit(:client_id, :project_id)
  end
end
