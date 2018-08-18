feature "User manages their own expense" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "views their expenses overview" do
    2.times { create(:expense, user: user) }
    click_link I18n.t("navbar.entries")

    expect(page.title).to eq("#{user.full_name} | Hours")
    expect(page).to have_content("#{user.first_name}")
    expect(page).to have_content(user.expenses.last.project.name)
  end

  scenario "deletes an entry" do
    create(:expense, user: user)
    click_link I18n.t("navbar.entries")

    click_link I18n.t("entries.index.delete")
    expect(page).to have_content(I18n.t("entry_deleted.expenses"))
  end

  scenario "edits an entry" do
    create(:expense, user: user)
    new_project = create(:project)
    new_value = rand(1..100)
    new_date = Date.current.strftime("%d/%m/%Y")

    edit_entry(new_project, new_value, new_date)
    click_link I18n.t("entries.index.edit")

    expect(page).to have_select("expense_project_id",
                                selected: new_project.name)
    expect(find_field("expense_value").value).to eq(new_value.to_f.to_s)
    expect(find_field("expense_date").value).to eq(new_date.to_s)
  end

  scenario "can not edit someone elses entries" do
    other_user = create(:user)
    create(:expense, user: other_user)

    visit user_entries_url(other_user, subdomain: subdomain)
    expect(page).to_not have_content("edit")
  end

  scenario "can not delete someone elses entries" do
    other_user = build(:user)
    create(:expense, user: other_user)

    visit user_entries_url(other_user, subdomain: subdomain)

    expect(page).to_not have_content("delete")
  end

  let(:new_value) { "Not a number" }

  scenario "edits entry with wrong data" do
    create(:expense, user: user)
    new_project = create(:project)
    new_value = "these are not valid"
    new_date = Date.current.strftime("%d/%m/%Y")
    click_link I18n.t("navbar.entries")

    edit_entry(new_project, new_value, new_date)

    expect(page).to have_content("Something went wrong saving your entry")
  end

  private

  def edit_entry(new_project, new_expenses, new_date)
    click_link I18n.t("navbar.entries")
    click_link I18n.t("entries.index.edit")

    select(new_project.name, from: "expense_project_id")
    fill_in "expense_value", with: new_expenses
    fill_in "expense_date", with: new_date

    click_button (I18n.t("helpers.submit.update"))
  end
end