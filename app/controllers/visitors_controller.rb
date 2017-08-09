class VisitorsController < ApplicationController

  def help_search
    @keywords = params[:keywords]
    @keywords = @keywords.strip.gsub(/[^\w -]/, '') if @keywords
    query = @keywords.gsub(/\W/,' ').split(/\s+/).join(' & ')
    @results = ComfyPageContent.search(query)
  end

end
