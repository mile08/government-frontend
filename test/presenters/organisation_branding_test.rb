require 'test_helper'

class OrganisationBrandingTest < ActiveSupport::TestCase
  include OrganisationBranding

  def test_organisation
    {
      "base_path" => "/base-path",
      "details" => {
        "brand" => "department-of-health",
        "logo" => {
          "formatted_title" => "Department<br/>of Health",
          "crest" => "single-identity"
        }
      }
    }
  end

  test "presents the logo for organisations" do
    logo = organisation_logo(test_organisation)

    assert_equal logo[:organisation][:brand], test_organisation["details"]["brand"]
    assert_equal logo[:organisation][:url], test_organisation["base_path"]
    assert_equal logo[:organisation][:crest], test_organisation["details"]["logo"]["crest"]
    assert_equal logo[:organisation][:name], test_organisation["details"]["logo"]["formatted_title"]
  end

  test "presents the brand colour class for organisations" do
    assert_equal "department-of-health-brand-colour", organisation_brand_class(test_organisation)
  end

  test "alters the brand for organisations with an executive order crest" do
    organisation = test_organisation
    organisation["details"]["logo"]["crest"] = "eo"

    refute_equal organisation_brand(organisation), test_organisation["details"]["brand"]
    assert_equal organisation_brand(organisation), "executive-office"
  end
end
