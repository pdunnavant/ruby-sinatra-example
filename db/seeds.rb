users = [
  { first_name: 'Frodo', last_name: 'Baggins' },
  { first_name: 'Bilbo', last_name: 'Baggins' },
  { first_name: 'George', last_name: 'Jetson' },
]

users.each do |u|
  Users.create(u)
end
