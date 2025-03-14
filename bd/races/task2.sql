SELECT r.car,
       c.class,
       AVG(r.position) AS avg_pos,
       COUNT(r.race)   AS race_count,
       cl.country      AS car_country
FROM Results r
         JOIN Cars c ON r.car = c.name
         JOIN Classes cl ON c.class = cl.class
GROUP BY r.car
ORDER BY avg_pos, c.name LIMIT 1;