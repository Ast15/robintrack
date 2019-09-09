class Quote
  def self.find_by_symbol(symbol)
    MongoClient[:index].aggregate([
      {"$match": {symbol: symbol}},
      {"$lookup": {
        from: "quotes_2",
        localField: "instrument_id",
        foreignField: "instrument_id",
        as: "quote",
      }},
      {"$project": {quote: {"$arrayElemAt": ["$quote", 0]}}},
      {"$project": {quote: {"$arrayElemAt": ["$quote.updates", -1]}}},
      {"$replaceRoot": {newRoot: "$quote"}},
    ])
  end

  def self.search_by_symbol(symbol)
    MongoClient[:index].aggregate([
      {"$match": {symbol: symbol}},
      {"$lookup": {
        from: "quotes_2",
        localField: "instrument_id",
        foreignField: "instrument_id",
        as: "quote",
      }},
      {"$project": {quote: {"$arrayElemAt": ["$quote", 0]}}},
      {"$unwind": {path: "$quote.updates"}},
      {"$replaceRoot": {newRoot: "$quote.updates"}},
    ])
  end
end
