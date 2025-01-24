require "rails_helper"

RSpec.describe Admin::BudgetInvestments::ToggleWinningComponent, type: :component do
  let(:investment) { create(:budget_investment) }

  before do
    allow(view).to receive(:can?).and_return(true)
  end

  it "renders the toggle switch for winning status" do
    render_inline(described_class.new(investment))

    expect(page).to have_css(".toggle-winning")
  end

  context "when the investment is winning" do
    before do
      investment.update!(winning: true)
    end

    it "renders the toggle switch as pressed" do
      render_inline(described_class.new(investment))

      expect(page).to have_css(".toggle-winning[aria-pressed='true']")
    end
  end

  context "when the investment is not winning" do
    before do
      investment.update!(winning: false)
    end

    it "renders the toggle switch as not pressed" do
      render_inline(described_class.new(investment))

      expect(page).to have_css(".toggle-winning[aria-pressed='false']")
    end
  end
end
