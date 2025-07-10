package com.github.jinhojinho.blindseoul_backend.repository;

import com.github.jinhojinho.blindseoul_backend.domain.BlindwalkInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class BlindwalkRepository {

    private final JdbcTemplate jdbcTemplate;

    public BlindwalkRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<BlindwalkInfo> findAll() {
        String sql = "SELECT * FROM swm_joined_blindwalk";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(BlindwalkInfo.class));
    }

    public List<BlindwalkInfo> findNearby(double userLat, double userLon, double radiusKm) {
        String sql = """
            SELECT *
            FROM swm_joined_blindwalk
            WHERE ST_DWithin(
                ST_SetSRID(
                    ST_MakePoint(
                        (lon_min + lon_max) / 2.0,
                        (lat_min + lat_max) / 2.0
                    ), 4326
                )::geography,
                ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography,
                ?
            )
        """;

        double radiusMeters = radiusKm * 1000;

        return jdbcTemplate.query(
                sql,
                new Object[]{userLon, userLat, radiusMeters},
                new BeanPropertyRowMapper<>(BlindwalkInfo.class)
        );
    }

}
