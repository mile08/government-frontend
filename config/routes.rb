Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  with_options format: false do |r|
    r.get 'healthcheck', to: proc { [200, {}, ['']] }
    r.get 'foreign-travel-advice/:path/:section' => 'content_items#show',
          content_item_prepend: "foreign-travel-advice/", as: :travel_advice_country
    r.get '*path' => 'content_items#show', constraints: { path: %r[.*] }
  end
end
