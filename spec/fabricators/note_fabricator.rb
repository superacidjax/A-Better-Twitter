Fabricator(:note) do
  content "Lorum ipsum"
  user { Fabricate(:user) }
end
