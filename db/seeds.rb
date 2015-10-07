# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user  = Role.create(name: "user")
# admin = Role.create(name: "admin")

# [:admin, :user].each do |role|
#   Role.find_or_create_by_name({ name: role }, without_protection: true)
# end

Role.create([{ name: 'admin' }, { name: 'user' }])

a1 = User.create({email: "admin@email.com", password: "11111111", password_confirmation: "11111111"})
a1.add_role :admin
u1 = User.create({email: "user1@email.com", password: "11111111", password_confirmation: "11111111"})
u2 = User.create({email: "user2@email.com", password: "11111111", password_confirmation: "11111111"})
u3 = User.create({email: "user3@email.com", password: "11111111", password_confirmation: "11111111"})

c1 = Category.create({name: "Category 1"})
c2 = Category.create({name: "Category 2"})

i1 = Article.create({title: "Article 1", content: "Lorem ipsum dolor sit amet, accumsan percipit intellegam ad vim. In vim commodo luptatum verterem, eos id decore percipit conceptam. Et iusto offendit constituto sit, an nemore percipit adipiscing sea. Tation essent vis ei, odio nibh mea ne, omnis zril sed ne. Has id nibh falli dicit, mutat solet petentium cum an. Ne nominavi vivendum iracundia nec.", user_id: u2.id, category_id: c1.id})
i2 = Article.create({title: "Article 2", content: "Lorem ipsum dolor sit amet, accumsan percipit intellegam ad vim. In vim commodo luptatum verterem, eos id decore percipit conceptam. Et iusto offendit constituto sit, an nemore percipit adipiscing sea. Tation essent vis ei, odio nibh mea ne, omnis zril sed ne. Has id nibh falli dicit, mutat solet petentium cum an. Ne nominavi vivendum iracundia nec.", user_id: u2.id, category_id: c2.id})
i3 = Article.create({title: "Article 3", content: "Lorem ipsum dolor sit amet, accumsan percipit intellegam ad vim. In vim commodo luptatum verterem, eos id decore percipit conceptam. Et iusto offendit constituto sit, an nemore percipit adipiscing sea. Tation essent vis ei, odio nibh mea ne, omnis zril sed ne. Has id nibh falli dicit, mutat solet petentium cum an. Ne nominavi vivendum iracundia nec.", user_id: u3.id, category_id: c1.id})
i4 = Article.create({title: "Article 4", content: "Lorem ipsum dolor sit amet, accumsan percipit intellegam ad vim. In vim commodo luptatum verterem, eos id decore percipit conceptam. Et iusto offendit constituto sit, an nemore percipit adipiscing sea. Tation essent vis ei, odio nibh mea ne, omnis zril sed ne. Has id nibh falli dicit, mutat solet petentium cum an. Ne nominavi vivendum iracundia nec.", user_id: u3.id, category_id: c2.id})
