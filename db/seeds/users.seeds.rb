# Create the only two users of this application with super secure passwords
User.create(email: 'admin@picpic.mroach.com', admin: true,
  encrypted_password: '$2a$10$VjJtEKjq/ohqZFAbojnrPupqFpR7tzjEKIUzGBvuT8M5C.37.AsjS')
User.create(email: 'user@picpic.mroach.com',
  encrypted_password: '$2a$10$2kW3Kq5GGNvrE8qWKmnmo.tFb9m/mUUB.8jj.2L9x./ff82OKjv9q')
