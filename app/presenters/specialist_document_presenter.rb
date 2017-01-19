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
      metadata = metadata.transform_keys{ |md| md.to_s.humanize }
      md[:other].merge!(metadata)
      return md
    end
  end

  def contents
    extract_headings_with_ids(body).map do |heading|
      link_to(heading[:text], "##{heading[:id]}")
    end
  end
end
