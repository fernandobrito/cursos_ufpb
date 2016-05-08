# Feature: Sample transcript
#   As a visitor
#   I want to see the graphs
#   Without providing my transcript of records
feature 'Transcript of records sample' do
  # Scenario: Find link on home page
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see the link "use um arquivo exemplo"
  scenario 'find link on home page' do
    visit root_path
    expect(page).to have_content 'use um arquivo exemplo'
  end

  # Scenario: Follow link
  #   Given I am a visitor
  #   When I follow the sample link
  #   Then I go to the transcript sample page
  scenario 'follow link' do
    visit root_path
    click_link 'use um arquivo exemplo'
    expect(page).to have_content 'Gráficos'
  end
end
