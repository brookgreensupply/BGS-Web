module CmsHelper

  def bgs_header(h1, h2, summary=nil)
    html = content_tag(:div, class: "hero") do
      content_tag(:div, class: "hero-top hero-home full-width") do
        content_tag(:div, class: "header-text text-center") do
          content_tag(:center) do
            content_tag(:h1) do
              h1
            end
          end
        end
      end +
      content_tag(:div, class: "hero-main") do
        content_tag(:div, class: "container-fluid") do
          content_tag(:div, class: "row text-center") do
            content_tag(:div, class: "col-xs-12") do
              content_tag(:div, class: "header-text") do
                content_tag(:div, class: "h2 font-primary") do
                  h2
                end
              end
            end
          end +
          if !summary.blank?
            content_tag(:div, class: "row text-center") do
              content_tag(:div, class: "col-xs-12 col-sm-8 col-sm-offset-2") do
                content_tag(:h4, class: "summary") do
                  summary
                end
              end
            end
          else
            ''
          end
        end
      end
    end
    html.html_safe
  end

end
