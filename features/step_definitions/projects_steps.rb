Given(/^there are projects with tests$/) do
  3.times do
    FactoryBot.create(:test)
  end
end

When(/^we visit the projects page$/) do
  visit '/projects'
end

Then(/^we should see the projects$/) do
  within ".body" do
    expect(page.all("tr.project").count).to eq 3
  end
end
