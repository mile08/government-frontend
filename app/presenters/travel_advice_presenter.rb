class TravelAdvicePresenter < ContentItemPresenter



  def country
    content_item["details"]["country"]["name"]
  end
end
