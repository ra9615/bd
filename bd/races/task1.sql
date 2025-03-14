WITH CarResults AS (SELECT c.class,
                           r.car,
                           AVG(r.position) AS avg_pos,
                           COUNT(r.race)   AS race_count
                    FROM Results r
                             JOIN Cars c ON r.car = c.name
                    GROUP BY c.class, r.car),

     MinAvgPosition AS (SELECT cr.class,
                               cr.car,
                               cr.avg_pos,
                               cr.race_count,
                               RANK() OVER (PARTITION BY cr.class ORDER BY cr.avg_pos) AS rank
                        FROM CarResults cr)

SELECT m.car     AS car_name,
       m.class   AS car_class,
       m.avg_pos AS average_position,
       m.race_count
FROM MinAvgPosition m
WHERE m.rank = 1
ORDER BY m.avg_pos;
