module Body
  def body
    content_item["details"]["body"]
  end

  def govspeak_body
    {
      content: "#{body}#{append_to_body}",
      direction: text_direction
    }
  end

private

  def render_partial(path)
    locals = { content_item: self }
    ContentItemsController.render(path, layout: false, locals: locals)
  end

  def append_to_body
    ""
  end
end
