class SpecialistDocumentPresenter < ContentItemPresenter
  include Metadata
  include Updatable
  include Linkable
  include ExtractsHeadings
  include ActionView::Helpers::UrlHelper

  def body
    content_item["details"]["body"]
  end

  def metadata
    super.tap do |md|
      metadata = content_item["details"]["metadata"].reject{ |m| m == "document_type" }
      metadata.each do |key,value|
        date = Date.parse(value) rescue nil
        metadata[key] = nice_date_format(date) if date
      end

      metadata = metadata.transform_keys{ |md| md.to_s.humanize }
      md[:other].merge!(metadata)
      return md
    end
  end

  # this seems to be legacy now, as it comes back with headings
  def contents
    extract_headings_with_ids(body).map do |heading|
      link_to(heading[:text], "##{heading[:id]}")
    end
  end

  def change_history
    content_item["details"]["change_history"] || []
  end

  def headings
    content_item["details"]["headers"]
  end


  # copied from specialist document
  def nice_date_format(time_string)
    unless time_string.blank?
      time = Time.zone.parse(time_string.to_s)
      string = "<time datetime='#{time.iso8601}'>"
      string += time.strftime('%-d %B %Y')
      string += '</time>'
      string.html_safe
    end
  end

  def first_edition?
    change_history.size <= 1
  end

  def bulk_published
    content_item["details"]["metadata"]["bulk_published"]
  end

  def footer_date_metadata
    return {} if bulk_published
    if first_edition?
      { published: nice_date_format(published) }
    else
      { updated: nice_date_format(updated) }
    end
  end
end
