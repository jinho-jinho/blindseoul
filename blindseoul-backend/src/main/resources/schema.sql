CREATE TABLE swm_wkar_as (
                             g2_id BIGINT,
                             g2_datasetid BIGINT,
                             g2_spatialtype INTEGER,
                             g2_xmin BIGINT,
                             g2_ymin BIGINT,
                             g2_xmax BIGINT,
                             g2_ymax BIGINT,
                             g2_index INTEGER,
                             g2_spatial TEXT,
                             "보도면관리번호" BIGINT,
                             ftr_cde TEXT,
                             sec_idn TEXT,
                             sys_chk INTEGER,
                             rmk TEXT,
                             stt_cde TEXT,
                             "보도현황관리번호" BIGINT,
                             bdl_ara FLOAT,
                             bdl_wid FLOAT,
                             bdl_len FLOAT,
                             swb_code TEXT,
                             vhcle_passway_co TEXT,
                             bccrd_ennc_code TEXT,
                             fom_code TEXT,
                             clr_code TEXT,
                             siz_code TEXT,
                             thk_code TEXT,
                             ptw_code TEXT,
                             gu_cde INTEGER,
                             rn_nm TEXT,
                             rn BIGINT,
                             bd_mnnm BIGINT,
                             bd_slno TEXT,
                             "보도면관리번호부번" INTEGER,
                             cnstrct_yy TEXT,
                             pnu TEXT
);

CREATE TABLE swm_brll_dt (
                             "보도면관리번호" BIGINT,
                             brll_blk_sn INTEGER,
                             brll_blk_knd_code TEXT,
                             swb_code TEXT,
                             fom_code TEXT,
                             clr_code TEXT,
                             siz_code TEXT,
                             thk_code TEXT,
                             ptw_code TEXT,
                             cnstrct_yy TEXT,
                             "보도면관리번호부번" INTEGER
);

\copy public.swm_brll_dt("보도면관리번호", brll_blk_sn, brll_blk_knd_code, swb_code, fom_code, clr_code, siz_code, thk_code, ptw_code, cnstrct_yy, "보도면관리번호부번") FROM 'C:/Users/Jinho/Downloads/SWM_BRLL_DT.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', ENCODING 'UTF8', NULL '-');
\copy public.swm_wkar_as(g2_id, g2_datasetid, g2_spatialtype, g2_xmin, g2_ymin, g2_xmax, g2_ymax, g2_index, g2_spatial, "보도면관리번호", ftr_cde, sec_idn, sys_chk, rmk, stt_cde, "보도현황관리번호", bdl_ara, bdl_wid, bdl_len, swb_code, vhcle_passway_co, bccrd_ennc_code, fom_code, clr_code, siz_code, thk_code, ptw_code, gu_cde, rn_nm, rn, bd_mnnm, bd_slno, "보도면관리번호부번", cnstrct_yy, pnu) FROM 'C:/Users/Jinho/Downloads/SWM_WKAR_AS.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', ENCODING 'UTF8', NULL '-');

CREATE TABLE swm_joined_blindwalk AS
SELECT
    brll."보도면관리번호",
    brll."보도면관리번호부번",
    asw.g2_xmin,
    asw.g2_ymin,
    asw.g2_xmax,
    asw.g2_ymax,
    asw.rn_nm,      -- 도로명
    asw.gu_cde,     -- 구 코드
    brll.brll_blk_knd_code,
    brll.cnstrct_yy
FROM
    swm_brll_dt brll
        JOIN
    swm_wkar_as asw
    ON
        brll."보도면관리번호" = asw."보도면관리번호"
            AND brll."보도면관리번호부번" = asw."보도면관리번호부번";

ALTER TABLE swm_joined_blindwalk
    ADD COLUMN id BIGSERIAL PRIMARY KEY;

ALTER TABLE swm_joined_blindwalk
    RENAME COLUMN 보도면관리번호 TO sidewalk_id;

ALTER TABLE swm_joined_blindwalk
    RENAME COLUMN 보도면관리번호부번 TO sub_id;
