package com.github.jinhojinho.blindseoul_backend.controller;

import com.github.jinhojinho.blindseoul_backend.domain.BlindwalkInfo;
import com.github.jinhojinho.blindseoul_backend.dto.BlindwalkDto;
import com.github.jinhojinho.blindseoul_backend.dto.common.ApiResponse;
import com.github.jinhojinho.blindseoul_backend.service.BlindwalkService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/blindwalk")
public class BlindwalkController {

    private final BlindwalkService blindwalkService;

    public BlindwalkController(BlindwalkService blindwalkService) {
        this.blindwalkService = blindwalkService;
    }

    @GetMapping("/nearby")
    public ResponseEntity<ApiResponse<List<BlindwalkDto>>> getNearbyBlindwalkLocation(
            @RequestParam("lat") double userLat,
            @RequestParam("lon") double userLon,
            @RequestParam(value = "radius", defaultValue = "0.5") double radiusKm) {

        List<BlindwalkDto> result = blindwalkService
                .findNearby(userLat, userLon, radiusKm)
                .stream()
                .map(this::convertToDto)
                .toList();

        return ResponseEntity.ok(new ApiResponse<>(true, result, "주변 유도블록 조회 성공"));
    }

    private BlindwalkDto convertToDto(BlindwalkInfo entity) {
        BlindwalkDto dto = new BlindwalkDto();
        dto.setSidewalkId(entity.getSidewalkId());
        dto.setSubId(entity.getSubId());
        dto.setLatMin(entity.getLatMin());
        dto.setLonMin(entity.getLonMin());
        dto.setLatMax(entity.getLatMax());
        dto.setLonMax(entity.getLonMax());
        dto.setRnNm(entity.getRnNm());
        dto.setBrllBlkKndCode(entity.getBrllBlkKndCode());
        dto.setCnstrctYy(entity.getCnstrctYy());
        return dto;
    }

}
