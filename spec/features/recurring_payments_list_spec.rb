require 'rails_helper'

feature "Recurring Payments list" do
  given!(:user) { create(:user_example_com) }
  given!(:currency) { create :currency, name: 'USD', unit: '$' }
  given!(:account) { create :account, user: user, name: "Cash", currency: currency }
  given!(:category) { create :income_category, user: user, name: "Salary" }

  scenario "logged out users redirect to login page" do
    visit "/recurring_payments"

    expect(current_path).to eq "/users/sign_in"
    expect(page).to have_content "You are not authorized to access this page."
  end

  scenario "logged in users can see 'No recurring payments' message when there are no recurring payments yet" do
    sign_in_as 'user@example.com', 'password'

    visit "/recurring_payments"

    expect(current_path).to eq recurring_payments_path
    expect(page).to have_content "You have no recurring payments yet."
  end

  scenario "logged in users can see list of their existing recurring payments" do
    create(:recurring_payment, title: "User's rent", user: user, category: category, account: account, amount: 500)
    create(:recurring_payment, title: "Other's rent")

    sign_in_as 'user@example.com', 'password'

    visit "/recurring_payments"

    expect(current_path).to eq recurring_payments_path
    expect(page).not_to have_content "You have no recurring payments yet."

    expect(page).to have_content "User's rent"
    expect(page).not_to have_content "Others's rent"
  end
end
