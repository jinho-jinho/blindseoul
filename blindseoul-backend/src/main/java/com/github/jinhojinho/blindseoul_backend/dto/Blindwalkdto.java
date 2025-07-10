package com.github.jinhojinho.blindseoul_backend.dto;

import lombok.Data;

@Data
public class Blindwalkdto {
    private Long sidewalkId;
    private Integer subId;
    private Double latMin;
    private Double lonMin;
    private Double latMax;
    private Double lonMax;
    private String rnNm;
    private String brllBlkKndCode;
    private String cnstrctYy;
}
