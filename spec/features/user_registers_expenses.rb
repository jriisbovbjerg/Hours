feature "User registers expenses" do
  let(:user) { build(:user) }
  let(:subdomain) { generate(:subdomain) }
  let(:capp11) { build(:project, name: "CAPP11") }
  let(:conversations) { build(:project, name: "Conversations") }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
    capp11.save
    conversations.save

    visit root_url(subdomain: subdomain)
  end

  context "with valid data" do
    scenario "full data" do
      within ".tab-header-and-content.expenses-input" do
        select capp11.name, from: I18n.t("entries.index.project")
        fill_in (I18n.t("entries.index.expense")), with: 20
        fill_in "expense_date", with: "17/02/2015"
        fill_in "expense_description", with: "desc"
        fill_in "expense_supplier", with: "sup1"
        fill_in "expense_currency", with: "HUF"
        fill_in "expense_exchangerate", with: 7.46
        
        click_button (I18n.t("helpers.submit.create"))
      end
      expect(page).to have_content(I18n.t("entry_created.expenses"))
    end
  end

  context "with invalid data" do

    scenario "blank text" do
      within ".tab-header-and-content.expenses-input" do
        select capp11.name, from: I18n.t("entries.index.project")
        fill_in (I18n.t("entries.index.expense")), with: ""
        fill_in "expense_date", with: "17/02/2015"

        click_button (I18n.t("helpers.submit.create"))
      end
      expect(page).to have_content(
        I18n.t("activerecord.attributes.expense.value") + " can't be blank. " +
        I18n.t("activerecord.attributes.expense.value") + " is not a number")
    end

    scenario "missing currency" do
      within ".tab-header-and-content.expenses-input" do
        select capp11.name, from: I18n.t("entries.index.project")
        fill_in (I18n.t("entries.index.expense")), with: 20
        fill_in "expense_date", with: "17/02/2015"
        fill_in "expense_description", with: "desc"
        fill_in "expense_supplier", with: "sup1"
        fill_in "expense_currency", with: ""
        fill_in "expense_exchangerate", with: 7.46
        
        click_button (I18n.t("helpers.submit.create"))
      end
      expect(page).to have_content(
        I18n.t("activerecord.attributes.expense.currency") + " can't be blank.)
    end
  end
end