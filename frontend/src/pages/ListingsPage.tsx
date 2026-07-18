import { useEffect, useState } from "react";
import { apiClient } from "../api/client";
import { ListingCard } from "../components/ListingCard";
import { ListingModal } from "../components/ListingModal";
import type { Listing } from "../types";
import "./ListingsPage.css";

export function ListingsPage() {
  const [listings, setListings] = useState<Listing[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedListing, setSelectedListing] = useState<Listing | null>(null);

  useEffect(() => {
    apiClient
      .get<Listing[]>("/listings")
      .then((response) => setListings(response.data))
      .catch(() => setError("Could not reach the backend API."))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div className="listings-page">
      <div className="listings-page-header">
        <h1 className="listings-page-title">All Listings</h1>
        {!loading && !error && (
          <span className="listings-page-count">
            {listings.length} item{listings.length === 1 ? "" : "s"}
          </span>
        )}
      </div>

      {loading && <p className="listings-page-status">Loading listings...</p>}
      {error && <p className="listings-page-status">{error}</p>}
      {!loading && !error && listings.length === 0 && (
        <p className="listings-page-status">No listings yet.</p>
      )}

      {!loading && !error && listings.length > 0 && (
        <div className="listing-grid">
          {listings.map((listing) => (
            <ListingCard key={listing.id} listing={listing} onSelect={setSelectedListing} />
          ))}
        </div>
      )}

      {selectedListing && (
        <ListingModal listing={selectedListing} onClose={() => setSelectedListing(null)} />
      )}
    </div>
  );
}
