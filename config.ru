require "./app"

map "/assets" do
  run App.settings.sprockets
end

map "/" do
  run App
end