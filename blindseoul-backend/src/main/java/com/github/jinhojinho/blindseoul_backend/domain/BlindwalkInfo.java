package com.github.jinhojinho.blindseoul_backend.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "swm_joined_blindwalk")
public class BlindwalkInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sidewalk_id")
    private Long sidewalkId;

    @Column(name = "sub_id")
    private Integer subId;

    @Column(name = "g2_xmin")
    private Long g2Xmin;

    @Column(name = "g2_ymin")
    private Long g2Ymin;

    @Column(name = "g2_xmax")
    private Long g2Xmax;

    @Column(name = "g2_ymax")
    private Long g2Ymax;

    @Column(name = "rn_nm")
    private String rnNm;

    @Column(name = "gu_cde")
    private Integer guCde;

    @Column(name = "brll_blk_knd_code")
    private String brllBlkKndCode;

    @Column(name = "cnstrct_yy")
    private String cnstrctYy;

    @Column(name = "lat_min")
    private Double latMin;

    @Column(name = "lon_min")
    private Double lonMin;

    @Column(name = "lat_max")
    private Double latMax;

    @Column(name = "lon_max")
    private Double lonMax;
}
