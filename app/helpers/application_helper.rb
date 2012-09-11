module ApplicationHelper

  #returns full page title on per-page basis
  def full_title(page_title)
    base_title = 'Zebra Crossing'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
