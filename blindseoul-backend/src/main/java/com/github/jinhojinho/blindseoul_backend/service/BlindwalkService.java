package com.github.jinhojinho.blindseoul_backend.service;

import com.github.jinhojinho.blindseoul_backend.domain.BlindwalkInfo;
import com.github.jinhojinho.blindseoul_backend.repository.BlindwalkRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BlindwalkService {

    private final BlindwalkRepository blindwalkRepository;

    public BlindwalkService(BlindwalkRepository blindwalkRepository) {
        this.blindwalkRepository = blindwalkRepository;
    }

    public List<BlindwalkInfo> findAll() {
        return blindwalkRepository.findAll();
    }

    public List<BlindwalkInfo> findNearby(double userLat, double userLon, double radiusKm) {
        return blindwalkRepository.findNearby(userLat, userLon, radiusKm);
    }
}
