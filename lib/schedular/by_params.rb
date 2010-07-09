module Schedular
  module ByParams
    def by_params params
      day = Date.civil params[:year].to_i, params[:month].to_i, (params[:day] || 1).to_i
      params[:day] ? by_time_or_period(day) : by_time_or_period(day..day >> 1)
    end
  end
end