require 'rails_helper'
RSpec.describe 'Create new User proccess', type: :system do
  it 'Sign up' do
    visit root_path
    click_link_or_button 'Sign up'
    fill_in 'Name', with: 'User1'
    fill_in 'Email', with: 'user1@gmail.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
    expect(page).to have_text('Welcome! You have signed up successfully.')
  end
end
