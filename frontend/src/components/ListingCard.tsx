import type { Listing } from "../types";

interface ListingCardProps {
  listing: Listing;
  onSelect: (listing: Listing) => void;
}

export function ListingCard({ listing, onSelect }: ListingCardProps) {
  return (
    <button className="listing-card" onClick={() => onSelect(listing)}>
      <div className="listing-card-thumb" aria-hidden="true">
        {listing.title.charAt(0).toUpperCase()}
      </div>
      <div className="listing-card-body">
        <h3 className="listing-card-title">{listing.title}</h3>
        <p className="listing-card-price">{listing.price} credits</p>
        <p className="listing-card-seller">Seller: {listing.seller.display_name}</p>
      </div>
    </button>
  );
}
