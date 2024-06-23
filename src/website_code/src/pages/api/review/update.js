import pgClient from "@config/pg";

// Create a review for a menu item with id and save them in database
export default async (req, res) => {
  const { id } = req.query;
  const { customer_id, item_id, rating, comment } = req.body;

  try {
    const { rows: result } = await pgClient.query(
      `INSERT INTO review (id, customer_id, item_id, rating, comment)
      VALUES ${(id, customer_id, item_id, rating, comment)} RETURNING *;`
    );

    res.status(200).json({ data: result[0] });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: err.message });
  }
};
