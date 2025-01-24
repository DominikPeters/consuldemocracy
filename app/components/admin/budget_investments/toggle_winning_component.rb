class Admin::BudgetInvestments::ToggleWinningComponent < ApplicationComponent
  attr_reader :investment
  use_helpers :can?
  delegate :winning?, to: :investment

  def initialize(investment)
    @investment = investment
  end

  private

    def action
      if winning?
        :unmark_as_winner
      else
        :mark_as_winner
      end
    end

    def path
      url_for({
        controller: "admin/budget_investments",
        action: action,
        budget_id: investment.budget,
        id: investment,
        filter: params[:filter],
        sort_by: params[:sort_by],
        min_total_supports: params[:min_total_supports],
        max_total_supports: params[:max_total_supports],
        advanced_filters: params[:advanced_filters],
        page: params[:page]
      })
    end

    def options
      {
        "aria-label": label,
        form_class: "toggle-winning",
        path: path
      }
    end

    def label
      t("admin.actions.label", action: t("admin.actions.winning"), name: investment.title)
    end
end
