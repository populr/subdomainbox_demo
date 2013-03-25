Factory.sequence :email do |n|
  "email#{n}@factory.com"
end

Factory.sequence :name do |n|
  "Name#{n}"
end

Factory.sequence :title do |n|
  "Title #{n}"
end

Factory.define :user do |f|
  f.email { Factory.next(:email) }
  f.password 'secret'
  f.password_confirmation 'secret'
end

Factory.define :doc do |f|
  f.title { Factory.next(:title) }
end
