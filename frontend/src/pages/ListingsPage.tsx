import { useEffect, useState } from "react";
import { apiClient } from "../api/client";
import type { Listing } from "../types";

export function ListingsPage() {
  const [listings, setListings] = useState<Listing[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    apiClient
      .get<Listing[]>("/listings")
      .then((response) => setListings(response.data))
      .catch(() => setError("Could not reach the backend API."))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p>Loading listings...</p>;
  if (error) return <p>{error}</p>;

  return (
    <section>
      <h1>Listings</h1>
      {listings.length === 0 ? (
        <p>No listings yet.</p>
      ) : (
        <ul>
          {listings.map((listing) => (
            <li key={listing.id}>
              <strong>{listing.title}</strong> — {listing.price} credits
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}
