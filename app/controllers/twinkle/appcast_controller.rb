module Twinkle
  class AppcastController < ApplicationController
    def show
      @app = App.includes(:versions)
        .where(versions: { published: true })
        .order('versions.build DESC')
        .find_by!(slug: params[:slug])
      Event.create(app: @app, **event_params)
      render layout: false, formats: :xml
    end

    private

    def event_params
      params.permit(
        :cpu64bit,
        :ncpu,
        :appVersion,
        :cpuFreqMHz,
        :cputype,
        :cpusubtype,
        :ramMB,
        :osVersion,
        :lang,
        :model
      )
    end
  end
end
