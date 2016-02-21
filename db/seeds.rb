user = User.create!(
  email: 'eric.pierre.mulligan@gmail.com',
  password: ENV['ERICMULLIGAN_CA_PASSWD'],
  name: 'Eric Mulligan'
)

Category.create!(
  name: 'Coding',
  created_by: user
)

Category.create!(
  name: 'Music',
  created_by: user
)

Category.create!(
  name: 'Other',
  created_by: user
)
