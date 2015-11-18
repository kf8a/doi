require 'typhoeus'
require 'json'
require 'nokogiri'

class Doi
  attr_reader :citation

  def initialize(doi_uri)
    @citation = {}
    get(doi_uri)
    # get_pdf(doi_uri)
  end

  def method_missing(method)
    key = method.to_s.gsub(/_/,'-')
    @citation.fetch(key)
  end

  def get(doi_uri)
    # create a request 
    response = Typhoeus.get("dx.doi.org/" + doi_uri, 
                          headers: {'Accept': 'application/vnd.citationstyles.csl+json'},
                          followlocation: true)

    if response.response_code == 404
      # try google scholar
      get_with_google_scholar(doi_uri)
    else
      begin
        @citation = JSON.parse(response.response_body)
      rescue JSON::ParserError
        warn "JSON:ParserError @{citation}"
        @citation = {}
      end
    end
  end

  def get_pdf(doi_uri)
    response = Typhoeus.get("dx.doi.org/" + doi_uri, 
                          headers: {'Accept': 'text/html'},
                          followlocation: true)
    if response.response_code == 200
      if response.effective_url.start_with? "http://www.sciencedirect.com/science/article"
        data = Nokogiri::HTML(response.response_body)
        result = data.css("a#pdfLink").first["href"]
        @citation['pdf'] = result
      end
    end
  end

  def get_with_google_scholar(doi_uri)
    response = Typhoeus.get("scholar.google.com/scholar?q="+ doi_uri, followlocation: true)
    data = Nokogiri::HTML(response.response_body)
    result = data.css "h3.gs_rt"
    @citation['title'] = result.text
  end
end
