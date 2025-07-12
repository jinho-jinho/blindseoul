package com.github.jinhojinho.blindseoul_backend.repository;

import com.github.jinhojinho.blindseoul_backend.domain.BlindwalkInfo;
import jakarta.persistence.EntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class BlindwalkRepository {
    private final EntityManager entityManager;
    private final JdbcTemplate jdbcTemplate;

    public BlindwalkRepository(EntityManager entityManager, JdbcTemplate jdbcTemplate) {
        this.entityManager = entityManager;
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<BlindwalkInfo> findAll() {
        return entityManager.createQuery("SELECT b FROM BlindwalkInfo b", BlindwalkInfo.class)
                .getResultList();
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
