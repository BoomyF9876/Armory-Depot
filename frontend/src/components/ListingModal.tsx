import { useEffect } from "react";
import type { Listing } from "../types";

interface ListingModalProps {
  listing: Listing;
  onClose: () => void;
}

export function ListingModal({ listing, onClose }: ListingModalProps) {
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === "Escape") onClose();
    };
    document.addEventListener("keydown", handleKeyDown);
    return () => document.removeEventListener("keydown", handleKeyDown);
  }, [onClose]);

  return (
    <div className="listing-modal-backdrop" onClick={onClose}>
      <div
        className="listing-modal"
        role="dialog"
        aria-modal="true"
        aria-labelledby="listing-modal-title"
        onClick={(event) => event.stopPropagation()}
      >
        <button className="listing-modal-close" onClick={onClose} aria-label="Close">
          ×
        </button>
        <h2 id="listing-modal-title">{listing.title}</h2>
        <p className="listing-modal-price">{listing.price} credits</p>
        <p className="listing-modal-seller">Sold by {listing.seller.display_name}</p>
        <p className="listing-modal-status">Status: {listing.status}</p>
        <p className="listing-modal-description">
          {listing.description ?? "No description provided."}
        </p>
      </div>
    </div>
  );
}
