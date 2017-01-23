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

module Ampify
  def about
    super
    respond_to do |format|
      format.amp do
        # search .amp .html templates
        lookup_context.formats = [:amp, :html]
        render
      end
    end
  end
end

class HomeController
  before_action :amp_render

  private

    def amp_render
      if request.format == 'amp'
        self.class.class_eval do
          prepend Ampify
        end
      end
    end
end
