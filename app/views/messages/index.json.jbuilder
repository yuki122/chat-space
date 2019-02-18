json.array!(@messages) do |message|
  # jbuilderのpartialは遅いらしいので、DRYを妥協
  json.user_name message.user.name
  json.created_at message.created_at_for_disp
  json.body message.body
  json.image_url message.image.url
end
