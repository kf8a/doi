require 'typhoeus'
require 'json'

class Doi
  def initialize(doi_uri)
    get(doi_uri)
  end

  def title
    @citation.fetch('title')
  end

  def journal
    @citation.fetch("container-title")
  end

  def volume
    @citation.fetch("volume")
  end

  def issue
    @citation.fetch("issue")
  end

  def page
    @citation.fetch("page")
  end

  def get(doi_uri)
    # create a request 
    response = Typhoeus.get("dx.doi.org/" + doi_uri, 
                          headers: {'Accept': 'application/vnd.citationstyles.csl+json, application/rdf+xml'},
                          followlocation: true)

    @citation = JSON.parse(response.response_body)
  end
end
