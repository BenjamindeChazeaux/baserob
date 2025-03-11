# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Ben = User.create!(email: "ben@gmail.com", password: "password1")
Anh = User.create!(email: "anh@gmail.com", password: "password2")
Antoine = User.create!(email: "antoine@gmail.com", password: "password3")
Yannick = User.create!(email: "yannick@gmail.com", password: "password4")