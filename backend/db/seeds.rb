# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "net/http"

users = [
  { email: "alice@example.com", display_name: "Alice" },
  { email: "bob@example.com", display_name: "Bob" },
  { email: "carol@example.com", display_name: "Carol" },
  { email: "dave@example.com", display_name: "Dave" },
].map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) { |u| u.display_name = attrs[:display_name] }
end

# Prices are rough real-world unit-cost estimates (public sources), used here purely as
# realistic placeholder data for demo listings. Images are public-domain/freely-licensed
# photos from Wikimedia Commons matching each item, downloaded and stored in the DB below.
listings_by_email = {
  "alice@example.com" => [
    {
      title: "USS Gerald R. Ford (CVN-78)",
      description: "Lead ship of the Ford-class nuclear-powered aircraft carrier, commissioned in 2017. " \
                    "Displaces over 100,000 tons and carries an air wing of 75+ aircraft.",
      price: 13_000_000_000.00,
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/USS_Gerald_R._Ford_%28CVN-78%29_" \
                  "underway_in_the_Atlantic_Ocean_on_9_October_2022_%28221009-N-TL968-1248%29.JPG/330px-" \
                  "USS_Gerald_R._Ford_%28CVN-78%29_underway_in_the_Atlantic_Ocean_on_9_October_2022_" \
                  "%28221009-N-TL968-1248%29.JPG",
    },
    {
      title: "F-35A Lightning II",
      description: "Single-seat, single-engine stealth multirole fighter built by Lockheed Martin. " \
                    "Unit cost based on recent U.S. DoD Lot procurement pricing.",
      price: 82_500_000.00,
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/F-35A_flight_%28cropped%29.jpg/" \
                  "330px-F-35A_flight_%28cropped%29.jpg",
    },
  ],
  "bob@example.com" => [
    {
      title: "M1A2 Abrams",
      description: "American third-generation main battle tank, armed with a 120mm smoothbore cannon " \
                    "and composite armor. Price reflects recent foreign military sales unit cost.",
      price: 10_000_000.00,
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/M1A2_SEP_v3.jpg/330px-M1A2_SEP_v3.jpg",
    },
    {
      title: "B-2 Spirit",
      description: "Northrop Grumman heavy strategic stealth bomber capable of penetrating dense " \
                    "anti-aircraft defenses. One of the most expensive aircraft ever built.",
      price: 2_100_000_000.00,
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/" \
                  "RAF_F-35B_integration_flying_training_with_USAF_B-2_30092019_-_4.jpg/330px-" \
                  "RAF_F-35B_integration_flying_training_with_USAF_B-2_30092019_-_4.jpg",
    },
  ],
  "carol@example.com" => [
    {
      title: "F-22 Raptor",
      description: "Lockheed Martin/Boeing twin-engine, single-seat, all-weather stealth air superiority " \
                    "fighter. Production ended in 2011; no longer available for export.",
      price: 150_000_000.00,
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/F-22_Raptor_edit1_%28cropped%29.jpg/" \
                  "330px-F-22_Raptor_edit1_%28cropped%29.jpg",
    },
    {
      title: "Leopard 2A7",
      description: "German-made main battle tank by Krauss-Maffei Wegmann, featuring a 120mm L/55 " \
                    "smoothbore gun and modular armor package.",
      price: 11_000_000.00,
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/" \
                  "Leopard_2_A7V_313_Bad_Frankenhausen_2024.JPG/330px-Leopard_2_A7V_313_Bad_Frankenhausen_2024.JPG",
    },
  ],
  "dave@example.com" => [
    {
      title: "B-52H Stratofortress",
      description: "Boeing long-range, subsonic, strategic bomber in continuous US Air Force service " \
                    "since 1961, capable of carrying a mix of guided and unguided munitions.",
      price: 88_000_000.00,
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/" \
                  "B-52_Stratofortress_assigned_to_the_307th_Bomb_Wing_%28cropped%29.jpg/330px-" \
                  "B-52_Stratofortress_assigned_to_the_307th_Bomb_Wing_%28cropped%29.jpg",
    },
    {
      title: "USS Nimitz (CVN-68)",
      description: "Lead ship of the Nimitz-class nuclear-powered supercarrier, in service since 1975 " \
                    "and one of the largest warships ever built.",
      price: 8_500_000_000.00,
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/USS_Nimitz_%28CVN-68%29.jpg/330px-" \
                  "USS_Nimitz_%28CVN-68%29.jpg",
    },
  ],
}

def download_image(url, attempts: 3)
  uri = URI.parse(url)
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] =
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"

  attempts.times do |attempt|
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 10) do |http|
      http.request(request)
    end

    return [response.body, response.content_type] if response.is_a?(Net::HTTPSuccess)

    warn "  (attempt #{attempt + 1}/#{attempts} got HTTP #{response.code} for #{url})"
    sleep 3 * (attempt + 1)
  end

  nil
rescue StandardError => e
  warn "  (could not download image: #{e.message})"
  nil
end

users.each do |user|
  # Drop this seller's previous listings so re-seeding doesn't leave stale items mixed in.
  user.listings.destroy_all
  listings_by_email.fetch(user.email, []).each do |attrs|
    listing = Listing.new(seller: user, title: attrs[:title], description: attrs[:description], price: attrs[:price])

    if (image = download_image(attrs[:image_url]))
      listing.image_data, listing.image_content_type = image
    end

    listing.save!
    sleep 1.5 # be polite to Wikimedia's rate limiter across the batch of downloads
  end
end

puts "Seeded #{User.count} users and #{Listing.count} listings."
