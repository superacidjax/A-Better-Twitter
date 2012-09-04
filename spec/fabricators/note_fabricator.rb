Fabricator(:note) do
  content "Lorum ipsum"
  user { Fabricate(:user) }
  group_id 99
end
