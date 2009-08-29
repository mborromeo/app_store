require "rubygems"
require "mechanize"
require "plist"

require "app_store"

# Caller regroups all the calling and xml parsing mechanism to call the AppStore.
module AppStore::Caller
  extend self
  
  FeaturedCategoriesURL = "http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewFeaturedSoftwareCategories"
  ApplicationURL        = "http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware"
  CategoryURL           = "http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewGenre"
  SearchURL             = "http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search"

  # Call the Apple AppStore using given <tt>url</tt> and passing <tt>params</tt> with an HTTP Get method.
  def get(url, params = {})
    # About the X-Apple-Store-Front header: this is used to select which store and which language.
    # Format is XXXXXX-Y,Z where XXXXXX is the store number (us, french, ...), Y the language and Z the return format.
    # If you omit the language, the default one for the store is used.
    # Return format can be either "1" or "2" : "1" returns data to be directly displayed and "2" is a more structured format.
    answer = agent.get(:url => url, :headers => {"X-Apple-Store-Front" => '143441,2'}, :params => params)
    raise AppStore::RequestError if answer.code != '200'
    Plist::parse_xml answer.body
  end
  
  protected
  def agent
    @agent ||= WWW::Mechanize.new { |a| a.user_agent = 'iTunes-iPhone/3.0 (2)' }
  end

end