module ContentsList
  include ActionView::Helpers::UrlHelper

  def contents
    contents_items.map do |item|
      {
        text: item[:text],
        href: '##{item[:id]}',
        level: 1,
        data: {
          track_category: 'contentsClicked',
          track_action: 'leftColumnH2',
          track_label: item[:id]
        }
      }
    end
  end

  def contents_items
    extract_headings_with_ids(body)
  end

private

  def extract_headings_with_ids(html)
    headings = Nokogiri::HTML(html).css('h2').map do |heading|
      id = heading.attribute('id')
      { text: strip_trailing_colons(heading.text), id: id.value } if id
    end
    headings.compact
  end

  def strip_trailing_colons(heading)
    heading.gsub(/\:$/, '')
  end
end
