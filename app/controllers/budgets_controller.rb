class BudgetsController < ApplicationController
  include FeatureFlags
  include BudgetsHelper
  feature_flag :budgets

  before_action :load_budget, only: [:show, :export_pb]
  before_action :load_current_budget, only: :index
  load_and_authorize_resource

  respond_to :html, :js

  def show
    raise ActionController::RoutingError, "Not Found" unless budget_published?(@budget)
  end

  def index
    @finished_budgets = @budgets.finished.order(created_at: :desc)
  end

  # GET /budgets/:id/export_pb
  def export_pb
    authorize! :export_pb, @budget

    exporter = Budget::PbExporter.new(@budget)
    pb_content = exporter.generate_pb_content

    filename = "#{@budget.id}".parameterize + ".pb"

    send_data pb_content,
              type: 'text/plain; charset=utf-8',
              filename: filename
  rescue => e
    logger.error "Export PB failed for Budget ID #{@budget.id}: #{e.message}"
    redirect_to @budget, alert: "Failed to export budget: #{e.message}"
  end

  private

    def load_budget
      @budget = Budget.find_by_slug_or_id! params[:id]
    end

    def load_current_budget
      @budget = current_budget
    end
end
