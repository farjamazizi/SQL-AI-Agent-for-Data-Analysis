# SFO Air Traffic Passenger Statistics - Domain Knowledge

## Schema Reference

Table: air_traffic, monthly passenger data from July 1999 onward.

- Year: 4-digit year.
- Date: first day of month.
- Operating Airline: airline that operated the flight.
- Operating Airline IATA Code: 2-letter code, may be null.
- Published Airline: marketing airline, relevant for codeshare tickets.
- Published Airline IATA Code: 2-letter code, may be null.
- GEO Summary: Domestic or International.
- GEO Region: US, Europe, Asia, Canada, Mexico, and similar regions.
- Activity Type Code: Deplaned, Enplaned, or Thru / Transit.
- Price Category Code: Low Fare or Other.
- Terminal: terminal name.
- Boarding Area: boarding area letter.
- Passenger Count: monthly passenger total.

Column names with spaces must be quoted, for example `"Operating Airline"` and
`"Passenger Count"`.

## Query Guidance

Most passenger analyses should exclude transit passengers:

```sql
WHERE "Activity Type Code" IN ('Deplaned', 'Enplaned')
```

Use `"Operating Airline"` for passenger totals to avoid codeshare double-counting.

Use `"Year"` for simple yearly filtering, and `"Date"` for month or quarter logic.

For growth percentages, aggregate first and use the prior period as the denominator:

```sql
growth_percentage = ((current_period - prior_period) * 100.0) / NULLIF(prior_period, 0)
```

For rankings based on percentages, calculate the percentage first, exclude null or
invalid denominators, then rank the final result.
