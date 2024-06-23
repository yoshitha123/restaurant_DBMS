import pgClient from "@config/pg";

export default function handler(req, res) {
  const { item_name, description, price, category } = req.body; // Assuming you're receiving this data in the request body

  item_id = parseInt(new Date().getTime());

  const query = `
    INSERT INTO menu (item_id, item_name, description, price, category)
    VALUES ${(item_id, item_name, description, price, category)}
RETURNING *;`;

  const values = [item_id, item_name, description, price, category];

  pgClient.query(query, values, (err, result) => {
    if (err) {
      res.status(500).json({ error: err.message });
    } else {
      res.status(200).json(result.rows);
    }
  });
}
