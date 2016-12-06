require 'presenter_test_helper'

class SpecialistDocumentPresenterTest
  class PresentedSpecialistDocument < PresenterTestCase
    def format_name
      "specialist_document"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end
  end
end
