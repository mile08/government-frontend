class DocumentCollectionPresenter < ContentItemPresenter
  include Linkable
  include Political
  include Updatable
  include ActionView::Helpers::UrlHelper

  def body
    content_item["details"]["body"]
  end

  def contents
    groups.map do |group|
      title = group["title"]
      link_to(title, "##{group_title_id(title)}")
    end
  end

  def groups
    content_item["details"]["collection_groups"].reject do |group|
      group_document_links(group).empty?
    end
  end

  def group_document_links(group)
    group_documents(group).map do |link|
      {
        public_updated_at: Time.parse(link["public_updated_at"]),
        document_type: link["document_type"],
        title: link["title"],
        base_path: link["base_path"]
      }
    end
  end

  def group_heading(group)
    title = group["title"]
    content_tag :h3, title, class: "group-title", id: group_title_id(title)
  end

private

  def group_documents(group)
    group["documents"].map { |id| documents_hash[id] }.compact
  end

  def group_title_id(title)
    title.tr(' ', '-').downcase
  end

  def documents_hash
    @documents_hash ||= content_item["links"]["documents"].map { |d| [d["content_id"], d] }.to_h
  end
end
