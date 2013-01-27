Rabl.configure do |config|
  config.include_child_root = false
  unless Rails.env.development?
    config.view_paths = [Rails.root.join("app/views")]
  end
end