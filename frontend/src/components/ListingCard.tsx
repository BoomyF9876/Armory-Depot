import type { Listing } from "../types";
import { resolveImageUrl } from "../api/client";
import { formatCredits } from "../utils/formatPrice";

interface ListingCardProps {
  listing: Listing;
  onSelect: (listing: Listing) => void;
}

export function ListingCard({ listing, onSelect }: ListingCardProps) {
  return (
    <button className="listing-card" onClick={() => onSelect(listing)}>
      {listing.image_url ? (
        <img
          className="listing-card-thumb-img"
          src={resolveImageUrl(listing.image_url)}
          alt={listing.title}
        />
      ) : (
        <div className="listing-card-thumb" aria-hidden="true">
          {listing.title.charAt(0).toUpperCase()}
        </div>
      )}
      <div className="listing-card-body">
        <h3 className="listing-card-title">{listing.title}</h3>
        <p className="listing-card-price">{formatCredits(listing.price, { compact: true })} credits</p>
        <p className="listing-card-seller">Seller: {listing.seller.display_name}</p>
      </div>
    </button>
  );
}
