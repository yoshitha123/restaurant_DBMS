import pgClient from "@config/pg";

export default function handler(req, res) {
  const { review_id, review_title, review, user_id, rating } = req.body; // Assuming you're receiving this data in the request body

  const query = `
    INSERT INTO restaurant_reviews (review_id, review_title, review, user_id, rating)
    VALUES (${review_id}, ${review_title}, ${review}, ${user_id}, ${rating})
RETURNING *;`;

  pgClient.query(query, (err, result) => {
    if (err) {
      res.status(500).json({ error: err.message });
    } else {
      res.status(200).json(result.rows);
    }
  });
}
