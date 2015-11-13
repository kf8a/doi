require 'rspec'
require './doi.rb'

describe Doi do
  it 'returns the right info' do
    doi = Doi.new('10.1126/science.169.3946.635')
    expect(doi.title).to eq "The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance" 
    expect(doi.container_title).to eq "Science"
    expect(doi.volume).to eq "169"
    expect(doi.issue).to eq "3946"
    expect(doi.page).to eq "635-641"
  end
end
