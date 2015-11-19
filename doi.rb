require 'typhoeus'
require 'json'
require 'nokogiri'

class Author
  attr :author

  def method_missing(method)
  end
end

class Doi
  attr_reader :citation

  def initialize(doi_uri)
    @citation = {}
    get(doi_uri)
    get_pdf(doi_uri)
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
        pdf = Typhoeus.get(result, cookiefile: "./cookies", cookiejar: "./cookies", followlocation: true, accept_encoding: "gzip")
        File.open("#{citation['title'].gsub(/ /,"+")}.pdf", "wb") {|file| file.write(pdf.response_body)}
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
