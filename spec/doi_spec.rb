require 'rspec'
require 'csv'
require "./lib/doi.rb"

describe Doi do
  it 'returns the right info' do
    doi = Doi.new('10.1126/science.169.3946.635')
    expect(doi.citation['title']).to eq "The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance" 
    expect(doi.citation['container-title']).to eq "Science"
    expect(doi.citation['volume']).to eq "169"
    # expect(doi.author.first.family).to eq "Frank"
    expect(doi.citation['issue']).to eq "3946"
    expect(doi.citation['page']).to eq "635-641"
  end

  it 'can use google scholar if it can not find it in the doi system' do
    doi = Doi.new('10.4319/lo.2013.58.4.1271')
    doi.get_with_google_scholar('10.4319/lo.2013.58.4.1271')
    expect(doi.citation['title']).to eq "Quantifying the production of dissolved organic nitrogen in headwater streams using 15N tracer additions"
  end

  it 'can use google scholar if it can not find it in the doi system' do
    doi = Doi.new('10.4319/lo.2013.58.4.1271')
    expect(doi.citation['title']).to eq "Quantifying the production of dissolved organic nitrogen in headwater streams using 15N tracer additions"
  end

  describe '10.1016/j.ecolecon.2007.09.020' do
    before(:all) do 
      @doi = Doi.new('10.1016/j.ecolecon.2007.09.020')
    end
    it 'gets the pdf for 10.1016/j.ecolecon.2007.09.020' do
      expect(@doi.citation['pdf']).to start_with "http://www.sciencedirect.com/science/article"
    end

    it 'gets the authors for 10.1016/j.ecolecon.2007.09.020' do
      expect(@doi.citation['author']).to be_a Array
    end
  end

  # i = 0
  # CSV.foreach("./test.csv") do |line|
  #   i = i + 1
  #   next if i < 2
  #   # doi_string, id, title, date, year, citation_type_id = line
  #   doi_string,id,title,pub_date,pub_year,type,publication,start_page_number,ending_page_number,volume,issue,city,publisher, website_id = line
  #   next unless type ==  "ArticleCitation"
  #   # next unless website_id == "1"

  #   it "returns the right title for id #{id} with doi #{doi_string}" do
  #     doi = Doi.new(doi_string)
  #     expect(doi.citation['title'].downcase.strip).to eq title.downcase.strip
  #   end
  #   sleep rand
  # end
end
