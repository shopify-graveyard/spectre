require 'rails_helper'

RSpec.describe Test do
  it 'flags if the tests has failed more than five consecutive times' do
    5.times do
      FactoryBot.create(:test)
    end
    test = FactoryBot.create(:test)
    expect(test.five_consecutive_failures).to eq true
  end

  it 'should have a default fuzz level of 30%' do
    test = FactoryBot.create(:test)
    expect(test.fuzz_level).to eq '30%'
  end
end
