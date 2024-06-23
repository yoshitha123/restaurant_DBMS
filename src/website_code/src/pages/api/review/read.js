import pgClient from "@config/pg";

export default function handler(req, res) {
  const { item_id } = req.query;

  pgClient.query(
    `SELECT * FROM review where item_id = ${item_id}`,
    (err, result) => {
      if (err) {
        res.status(500).json({ error: err.message });
      } else {
        res.status(200).json(result.rows);
      }
    }
  );
}
