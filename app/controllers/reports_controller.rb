class ReportsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  def index
    @report = Report.new
  end
end
