# TODO following part is only valid in rapid development stage
# Should not be apply at production!

raise 'Remove following part!' if Rails.env.production?

o = Organization.create!(name: 'MyGigaCorp')

u = User.new(
  id: 1,
  organizations: [o],
  email: 'lukas.svoboda@gmail.com',
  password: '123456',
  password_confirmation: '123456',
  name: 'Lukas Svoboda'
)
#u.skip_confirmation!
u.save!

team = FactoryBot.create(:team)
u.teams << team

service = FactoryBot.create(:service, name: 'testing service 1')
FactoryBot.create(:integration, service: service)
