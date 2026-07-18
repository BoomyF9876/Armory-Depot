# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = [
  { email: "alice@example.com", display_name: "Alice" },
  { email: "bob@example.com", display_name: "Bob" },
  { email: "carol@example.com", display_name: "Carol" },
  { email: "dave@example.com", display_name: "Dave" },
].map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) { |u| u.display_name = attrs[:display_name] }
end

listings_by_email = {
  "alice@example.com" => [
    { title: "Vintage Longsword", description: "Hand-forged replica, great condition.", price: 120.00 },
    { title: "Leather Shield", description: "Round wooden shield with leather wrap.", price: 45.50 },
  ],
  "bob@example.com" => [
    { title: "Chainmail Armor", description: "Full chainmail hauberk, medium size.", price: 210.00 },
    { title: "Steel Dagger", description: "Lightweight throwing dagger.", price: 18.75 },
  ],
  "carol@example.com" => [
    { title: "Recurve Bow", description: "Composite recurve bow with quiver.", price: 95.00 },
    { title: "Bundle of Arrows (20)", description: "Fletched wooden arrows, steel tips.", price: 30.00 },
  ],
  "dave@example.com" => [
    { title: "War Hammer", description: "Two-handed war hammer, oak handle.", price: 150.00 },
    { title: "Bronze Helmet", description: "Open-face bronze helmet.", price: 60.00 },
  ],
}

users.each do |user|
  listings_by_email.fetch(user.email, []).each do |attrs|
    Listing.find_or_create_by!(seller: user, title: attrs[:title]) do |listing|
      listing.description = attrs[:description]
      listing.price = attrs[:price]
    end
  end
end

puts "Seeded #{User.count} users and #{Listing.count} listings."
