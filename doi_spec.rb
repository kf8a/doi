require 'rspec'
require 'csv'
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

  i = 0
  CSV.foreach("./test.csv") do |line|
    i = i + 1
    next if i < 2
    # doi_string, id, title, date, year, citation_type_id = line
    doi_string,id,title,pub_date,pub_year,type,publication,start_page_number,ending_page_number,volume,issue,city,publisher, website_id = line
    next unless type ==  "ArticleCitation"
    next unless website_id == "1"

    it "returns the right title for #{doi_string}" do
      doi = Doi.new(doi_string)
      expect(doi.title.downcase.strip).to eq title.downcase.strip
    end
    sleep rand
  end
end
