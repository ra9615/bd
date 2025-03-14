WITH CarResults AS (SELECT c.name          AS car_name,
                           c.class         AS car_class,
                           AVG(r.position) AS average_position,
                           COUNT(r.race)   AS race_count,
                           cl.country      AS car_country
                    FROM Results r
                             JOIN Cars c ON r.car = c.name
                             JOIN Classes cl on cl.class = c.class
                    GROUP BY c.name, c.class, cl.country
                    HAVING average_position > 3.0),

     ClassResults AS (SELECT c.class       AS class,
                             COUNT(c.name) AS car_count,
                             COUNT(r.race) AS total_races
                      FROM Results r
                               JOIN Cars c ON r.car = c.name
                      GROUP BY c.class)

SELECT cr.car_name         AS car_name,
       cr.car_class        AS car_class,
       cr.average_position AS average_position,
       cr.race_count       AS race_count,
       cr.car_country      AS car_country,
       cls.total_races     AS total_races,
       cls.car_count       AS low_position_count
FROM CarResults cr
         JOIN ClassResults cls on cls.class = cr.car_class
ORDER BY low_position_count DESC;