class LinkController < ActionController::Base

  def index
    long_url = params[:long_url]
    unless long_url.blank?
      url_details=insert_into_db(long_url)
      @short_url = request.url + url_details.short_url
    end
  end

  def redirect
    url_details = UrlDetails.find(:first, :conditions => ["short_url = ?", params[:id]])
    url_details.update_attribute('clicks', url_details.clicks+1)
    redirect_to url_details.long_url
  end

  private

  def generate_short_url(id)
    (123456+id).to_s(36)
  end

  def insert_into_db(long_url)
    url_details = UrlDetails.create
    short_url = generate_short_url(url_details.id)
    url_details.update_attribute('long_url', long_url)
    url_details.update_attribute('short_url', short_url)
    url_details.update_attribute('clicks', 0)
    url_details
  end
end
