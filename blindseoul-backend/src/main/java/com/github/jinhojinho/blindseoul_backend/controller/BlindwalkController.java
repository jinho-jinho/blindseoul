package com.github.jinhojinho.blindseoul_backend.controller;

import com.github.jinhojinho.blindseoul_backend.domain.BlindwalkInfo;
import com.github.jinhojinho.blindseoul_backend.dto.BlindwalkDto;
import com.github.jinhojinho.blindseoul_backend.service.BlindwalkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/blindwalk")
public class BlindwalkController {

    private final BlindwalkService blindwalkService;

    @Autowired
    public BlindwalkController(BlindwalkService blindwalkService) {
        this.blindwalkService = blindwalkService;
    }

    @GetMapping("/all")
    public List<BlindwalkDto> getAllBlindwalkLocation() {
        return blindwalkService.findAll()
                .stream()
                .map(this::convertToDto)
                .toList();
    }

    @GetMapping("/nearby")
    public List<BlindwalkDto> getNearbyBlindwalkLocation(
            @RequestParam("lat") double userLat,
            @RequestParam("lon") double userLon,
            @RequestParam(value = "radius", defaultValue = "0.5") double radiusKm) {

        return blindwalkService.findNearby(userLat, userLon, radiusKm)
                .stream()
                .map(this::convertToDto)
                .toList();
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
