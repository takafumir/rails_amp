# Just for test.
class HomeController < ApplicationController
  def index
  end

  def about
    respond_to do |format|
      format.html  # about.html.erb
      format.json { render json:
        { object_id: RailsAmp.config.object_id, format: RailsAmp.config.format }
      }
    end
  end
end

class HomeController
  before_action :amp_render

  private

    def about_with_amp
      about_without_amp

      respond_to do |format|
        format.amp do
          # search .amp .html templates
          lookup_context.formats = [:amp, :html]
          render
        end
      end
    end

    def amp_render
      if request.format == 'amp'
        class_eval do
          alias_method :about_without_amp, :about
          alias_method :about, :about_with_amp
        end
      end
    end
end
