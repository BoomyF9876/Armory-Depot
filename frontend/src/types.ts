export interface User {
  id: number;
  email: string;
  display_name: string;
  fake_currency_balance: string;
}

export interface Listing {
  id: number;
  title: string;
  description: string | null;
  price: string;
  status: "active" | "sold" | "removed";
  seller_id: number;
  seller: Pick<User, "id" | "display_name">;
  image_url: string | null;
}
