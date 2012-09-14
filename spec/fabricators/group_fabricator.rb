Fabricator(:group) do
  name        { sequence(:name) { |i| "user#{i}" } }
  description "MyText"
  category    "MyString"
  user
end
