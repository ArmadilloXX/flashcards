# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: "Chicago" }, { name: "Copenhagen" }])
#   Mayor.create(name: "Emanuel", city: cities.first)

require "nokogiri"
require "open-uri"

default_admin = User.create(email: "test_admin@test.com",
                            password: "password",
                            password_confirmation: "password",
                            locale: "ru")
default_admin.add_role :admin


unless User.find_by(email: "test@test.com")
  default_user = User.create(email: "test@test.com",
                             password: "testpass",
                             password_confirmation: "testpass",
                             locale: "ru")
  default_block = Block.create(title: "TestBlock",user_id: default_user.id)
  doc = Nokogiri::HTML(open(
                      "https://www.learnathome.ru/blog/100-beautiful-words"))

  doc.search("//table/tbody/tr").each do |row|
    original = row.search("td[2]/p")[0].content.downcase
    translated = row.search("td[1]/p")[0].content.downcase
    Card.create(original_text: original,
                translated_text: translated,
                block_id: default_block.id,
                user_id: default_user.id)
  end
end
