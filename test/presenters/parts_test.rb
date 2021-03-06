require 'test_helper'

module PartsStubs
  def base_path
    '/base-path'
  end

  def content_item
    {
      'details' => {
        'parts' => [
          {
            'title' => 'first-title',
            'slug' => 'first-slug',
            'body' => 'first-body',
          },
          {
            'title' => 'second-title',
            'slug' => 'second-slug',
            'body' => 'second-body',
          }
        ]
      }
    }
  end
end

module PresentingFirstPartInContentItem
  def part_slug
    nil
  end

  def requested_content_item_path
    base_path
  end
end

class PartsTest < ActiveSupport::TestCase
  def setup
    @parts = Object.new
    @parts.extend(Parts)
    @parts.extend(PartsStubs)
  end

  def presenting_first_part_in_content_item
    @parts.extend(PresentingFirstPartInContentItem)
  end

  test 'is not requesting a part when no parts exist' do
    class << @parts
      def content_item
        { 'details' => {} }
      end
    end

    refute @parts.requesting_a_part?
  end

  test 'is not requesting a part when parts exist and base_path matches requested_content_item_path' do
    class << @parts
      def requested_content_item_path
        base_path
      end
    end

    refute @parts.requesting_a_part?
  end

  test 'is requesting a part when part exists and base_path is different to requested_content_item_path' do
    class << @parts
      def part_slug
        'second-slug'
      end

      def requested_content_item_path
        base_path + '/second-slug'
      end
    end

    assert @parts.requesting_a_part?
  end

  test 'is requesting a valid part when part exists' do
    class << @parts
      def part_slug
        'second-slug'
      end

      def requested_content_item_path
        base_path + '/' + part_slug
      end
    end

    assert @parts.has_valid_part?
    assert_equal @parts.current_part_body, 'second-body'
    assert_equal @parts.current_part_title, 'second-title'
  end

  test 'is requesting an invalid part when no part with corresponding slug exists' do
    class << @parts
      def part_slug
        'not-a-valid-slug'
      end

      def requested_content_item_path
        base_path + '/' + part_slug
      end
    end

    assert @parts.requesting_a_part?
    refute @parts.has_valid_part?
  end

  test 'defaults to first part as current part when parts exist but no part requested' do
    presenting_first_part_in_content_item

    refute @parts.requesting_a_part?
    assert_equal @parts.current_part_body, 'first-body'
    assert_equal @parts.current_part_title, 'first-title'
  end

  test 'navigation items are presented as links unless they are the current part' do
    presenting_first_part_in_content_item
    assert_equal @parts.current_part_title, 'first-title'
    assert_equal @parts.parts_navigation, [["first-title", "<a href=\"/second-slug\">second-title</a>"]]
  end

  test 'navigation items link to all parts' do
    presenting_first_part_in_content_item
    assert_equal @parts.parts.size, @parts.parts_navigation.flatten.size
  end

  test 'part navigation is in one group when 3 or fewer navigation items (2 parts + summary)' do
    presenting_first_part_in_content_item

    class << @parts
      def content_item
        {
          'details' => {
            'parts' => [
              {
                'title' => 'first-title',
                'slug' => 'first-slug',
                'body' => 'first-body',
              },
              {
                'title' => 'second-title',
                'slug' => 'second-slug',
                'body' => 'second-body',
              },
              {
                'title' => 'third-title',
                'slug' => 'third-slug',
                'body' => 'third-body',
              }
            ]
          }
        }
      end
    end

    assert_equal 1, @parts.parts_navigation.size
  end

  test "part navigation is split into two equal groups when more than 3 items" do
    presenting_first_part_in_content_item

    class << @parts
      def content_item
        {
          'details' => {
            'parts' => [
              {
                'title' => 'first-title',
                'slug' => 'first-slug',
                'body' => 'first-body',
              },
              {
                'title' => 'second-title',
                'slug' => 'second-slug',
                'body' => 'second-body',
              },
              {
                'title' => 'third-title',
                'slug' => 'third-slug',
                'body' => 'third-body',
              },
              {
                'title' => 'fourth-title',
                'slug' => 'fourth-slug',
                'body' => 'fourth-body',
              }
            ]
          }
        }
      end
    end

    assert_equal @parts.parts_navigation, [
        ["first-title", "<a href=\"/second-slug\">second-title</a>"],
        ["<a href=\"/third-slug\">third-title</a>", "<a href=\"/fourth-slug\">fourth-title</a>"]
      ]
  end
end
