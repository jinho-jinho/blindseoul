package com.github.jinhojinho.blindseoul_backend.repository;

import com.github.jinhojinho.blindseoul_backend.domain.BlindwalkInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BlindwalkRepository extends JpaRepository<BlindwalkInfo, Long> {

    @Query(value = """
        SELECT *
        FROM swm_joined_blindwalk
        WHERE ST_DWithin(
            ST_SetSRID(
                ST_MakePoint(
                    (lon_min + lon_max) / 2.0,
                    (lat_min + lat_max) / 2.0
                ), 4326
            )::geography,
            ST_SetSRID(ST_MakePoint(:lon, :lat), 4326)::geography,
            :radius
        )
        """, nativeQuery = true)
    List<BlindwalkInfo> findNearby(
            @Param("lat") double userLat,
            @Param("lon") double userLon,
            @Param("radius") double radiusInMeters
    );
}
