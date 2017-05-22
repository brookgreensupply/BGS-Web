module ApplicationHelper

  def slug_to_url(slug)
    page = Comfy::Cms::Page.find_by_slug(slug)
    if page
      page.url
    else
      "/404?missing-slug=#{slug}"
    end
  end

end
