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

# Prices are rough real-world unit-cost estimates (public sources), used here purely as
# realistic placeholder data for demo listings.
listings_by_email = {
  "alice@example.com" => [
    {
      title: "USS Gerald R. Ford (CVN-78)",
      description: "Lead ship of the Ford-class nuclear-powered aircraft carrier, commissioned in 2017. " \
                    "Displaces over 100,000 tons and carries an air wing of 75+ aircraft.",
      price: 13_000_000_000.00,
    },
    {
      title: "F-35A Lightning II",
      description: "Single-seat, single-engine stealth multirole fighter built by Lockheed Martin. " \
                    "Unit cost based on recent U.S. DoD Lot procurement pricing.",
      price: 82_500_000.00,
    },
  ],
  "bob@example.com" => [
    {
      title: "M1A2 Abrams",
      description: "American third-generation main battle tank, armed with a 120mm smoothbore cannon " \
                    "and composite armor. Price reflects recent foreign military sales unit cost.",
      price: 10_000_000.00,
    },
    {
      title: "B-2 Spirit",
      description: "Northrop Grumman heavy strategic stealth bomber capable of penetrating dense " \
                    "anti-aircraft defenses. One of the most expensive aircraft ever built.",
      price: 2_100_000_000.00,
    },
  ],
  "carol@example.com" => [
    {
      title: "F-22 Raptor",
      description: "Lockheed Martin/Boeing twin-engine, single-seat, all-weather stealth air superiority " \
                    "fighter. Production ended in 2011; no longer available for export.",
      price: 150_000_000.00,
    },
    {
      title: "Leopard 2A7",
      description: "German-made main battle tank by Krauss-Maffei Wegmann, featuring a 120mm L/55 " \
                    "smoothbore gun and modular armor package.",
      price: 11_000_000.00,
    },
  ],
  "dave@example.com" => [
    {
      title: "B-52H Stratofortress",
      description: "Boeing long-range, subsonic, strategic bomber in continuous US Air Force service " \
                    "since 1961, capable of carrying a mix of guided and unguided munitions.",
      price: 88_000_000.00,
    },
    {
      title: "USS Nimitz (CVN-68)",
      description: "Lead ship of the Nimitz-class nuclear-powered supercarrier, in service since 1975 " \
                    "and one of the largest warships ever built.",
      price: 8_500_000_000.00,
    },
  ],
}

users.each do |user|
  # Drop this seller's previous listings so re-seeding doesn't leave stale items mixed in.
  user.listings.destroy_all
  listings_by_email.fetch(user.email, []).each do |attrs|
    Listing.create!(seller: user, title: attrs[:title], description: attrs[:description], price: attrs[:price])
  end
end

puts "Seeded #{User.count} users and #{Listing.count} listings."
