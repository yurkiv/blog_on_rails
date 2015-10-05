# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u1 = User.create({email: "user1@example.com", password: "aaaaaaaa", password_confirmation: "aaaaaaaa"})
u2 = User.create({email: "user2@example.com", password: "aaaaaaaa", password_confirmation: "aaaaaaaa"})
u3 = User.create({email: "user3@example.com", password: "aaaaaaaa", password_confirmation: "aaaaaaaa"})

i1 = Article.create({title: "Article 1", content: "Lorem ipsum dolor sit amet, accumsan percipit intellegam ad vim. In vim commodo luptatum verterem, eos id decore percipit conceptam. Et iusto offendit constituto sit, an nemore percipit adipiscing sea. Tation essent vis ei, odio nibh mea ne, omnis zril sed ne. Has id nibh falli dicit, mutat solet petentium cum an. Ne nominavi vivendum iracundia nec.", user_id: u2.id})
i2 = Article.create({title: "Article 2", content: "Lorem ipsum dolor sit amet, accumsan percipit intellegam ad vim. In vim commodo luptatum verterem, eos id decore percipit conceptam. Et iusto offendit constituto sit, an nemore percipit adipiscing sea. Tation essent vis ei, odio nibh mea ne, omnis zril sed ne. Has id nibh falli dicit, mutat solet petentium cum an. Ne nominavi vivendum iracundia nec.", user_id: u2.id})
i3 = Article.create({title: "Article 3", content: "Lorem ipsum dolor sit amet, accumsan percipit intellegam ad vim. In vim commodo luptatum verterem, eos id decore percipit conceptam. Et iusto offendit constituto sit, an nemore percipit adipiscing sea. Tation essent vis ei, odio nibh mea ne, omnis zril sed ne. Has id nibh falli dicit, mutat solet petentium cum an. Ne nominavi vivendum iracundia nec.", user_id: u3.id})
i4 = Article.create({title: "Article 4", content: "Lorem ipsum dolor sit amet, accumsan percipit intellegam ad vim. In vim commodo luptatum verterem, eos id decore percipit conceptam. Et iusto offendit constituto sit, an nemore percipit adipiscing sea. Tation essent vis ei, odio nibh mea ne, omnis zril sed ne. Has id nibh falli dicit, mutat solet petentium cum an. Ne nominavi vivendum iracundia nec.", user_id: u3.id})
