
-- TRARET1
SELECT
    COUNT(*),
    TraRet1.TfRFecha,
    TfRConce,
    TfR1Cli,
    TfR1Men,
    Tfr1Obs,
    Tfr1MarIg
FROM TraRet1
WHERE TfRFecha = '20261026'
    AND Tfr1Obs NOT LIKE '%Proce%'
    AND Tfr1Obs <> ''
    AND TfRConce = '23'
    AND TfR1MarIg = '0'
GROUP BY
    TfRFecha,
    TfRConce,
    TfR1Cli,
    TfR1Men,
    Tfr1Obs,
    Tfr1MarIg
ORDER BY
    TfRFecha DESC;


-- TRARET2
SELECT
    COUNT(*) AS Cantidad,
    TraRet2.TfR2Cli,
    Tfr2Obs,
    TraRet2.TfRFecha,
    TfRConce
FROM TraRet2
WHERE Tfr2Obs NOT LIKE '%Procesado%'
    AND Tfr2Obs <> ''
    AND TfR2MarIg = '0'
    AND TfRConce = '23'
    AND TfRFecha >= '20261023'
    AND Tfr2Obs NOT LIKE '%ED96%'
    AND Tfr2Obs NOT LIKE '%EM96%'
GROUP BY
    TraRet2.TfR2Cli,
    Tfr2Obs,
    TfRFecha,
    TfRConce
ORDER BY
    TfRFecha DESC,
    Cantidad DESC;


/* ===================================================================================================== */


SELECT
    TraRet2.Tfr2Fec,
    TraRet2.TfRFecha,
    TraRet2.TfRConce,
    TraRet2.Tfr2MarIg,
    TraRet2.Tfr2Obs,
    ViaPaEr.ViErNrTag,
    COUNT(*) AS Expr1,
    TraRet2.TfR2Rng,
    TraRet2.TfR2Cli
FROM TraRet2 WITH (NOLOCK)
RIGHT OUTER JOIN ViaPaEr
    ON SUBSTRING(TraRet2.TfR2Tag, 5, 8) = ViaPaEr.ViErNrTag
    -- AND TraRet2.TfR2DomVeh = ViaPaEr.ViErDomin
WHERE TraRet2.Tfr2Obs <> ''
    AND TraRet2.TfR2Fec >= '20261027'
    AND TraRet2.Tfr2Obs NOT LIKE 'Proce%'
    AND TraRet2.Tfr2MarIg <> 1
    AND TraRet2.TfRConce <> 'ED'
    AND TraRet2.TfR2Sts = 'H'
    -- AND TraRet2.Tfr2Obs LIKE 'Categoría%'
    -- AND TraRet2.TfR2Tag IN ('si9060935456')
GROUP BY
    TraRet2.Tfr2Fec,
    TraRet2.TfRFecha,
    TraRet2.TfRConce,
    TraRet2.Tfr2MarIg,
    TraRet2.Tfr2Obs,
    ViaPaEr.ViErNrTag,
    TraRet2.TfR2Rng,
    TraRet2.TfR2Cli
ORDER BY
    TraRet2.Tfr2Fec,
    TraRet2.TfRFecha DESC;



/* ===================================================================================================== */


SELECT
    TraRet2.TfRConce AS Concecionaria,
    TraRet2.TfRFecha AS Fecha,
    TraRet2.Tfr2Obs AS Observacion,
    TraRet2.TfR2Cli AS ClienteInformado,
    TraRet2.TfR2Tag AS TagInformado,
    TraRet2.TfR2Men AS Patente,
    TraRet2.TfR2Sts AS Estado,
    CLIENT.CliCod AS ClienteEnClient,
    SubTag.CliCod AS ClienteDelTag,
    SubTag.Sum6Tag AS Sum6Tag,
    SubTag.Sum6Sts AS Sum6Sts,
    SubCta.SumNro AS SubcuentaEnSubCta,
    CASE
        WHEN SubTag.Sum6Tag IS NULL THEN 'TAG NO ENCONTRADO EN SUBTAG'
        WHEN LEFT(TraRet2.TfR2Cli, 15) = SubTag.CliCod THEN 'MISMO CLIENTE'
        ELSE 'TAG PERTENECE A OTRO CLIENTE'
    END AS Resultado
FROM TraRet2 WITH (NOLOCK)
LEFT JOIN CLIENT WITH (NOLOCK)
    ON CLIENT.CliCod = LEFT(TraRet2.TfR2Cli, 15)
LEFT JOIN SubTag WITH (NOLOCK)
    ON SubTag.Sum6Tag = TRY_CONVERT(NUMERIC(15, 0), SUBSTRING(TraRet2.TfR2Tag, 4, 15))
LEFT JOIN SubCta WITH (NOLOCK)
    ON SubCta.SucCod = SubTag.SucCod
    AND SubCta.CliCod = SubTag.CliCod
    AND SubCta.SumNro = SubTag.SumNro
WHERE TraRet2.TfRFecha >= '20261023'
    AND TraRet2.TfR2MarIg = '0'
    AND TraRet2.TfRConce = '23'

    -- Estos NULLs se exigen para ambos casos
    AND SubTag.CliCod IS NULL
    AND SubTag.Sum6Tag IS NULL
    AND SubTag.Sum6Sts IS NULL
    AND SubCta.SumNro IS NULL

    -- Aquí separamos la lógica según la observación
    AND (
        -- Caso 1: Tag Inexistente (no exige que CLIENT sea NULL)
        TraRet2.Tfr2Obs LIKE '%Cliente / Subcuenta / Tag Inexistente%'

        OR

        -- Caso 2: Cliente/Subcuenta Inexistente (SÍ exige que CLIENT sea NULL)
        (
            TraRet2.Tfr2Obs LIKE '%Cliente / Subcuenta Inexistente%'
            AND CLIENT.CliCod IS NULL
        )
    )
ORDER BY
    TraRet2.TfRFecha ASC,
    TraRet2.TfR2Cli,
    TraRet2.TfR2Tag;



/* ===================================================================================================== */

-- UPDATE - Parametrizar fecha
SELECT *
FROM TraRet2
WHERE Tfr2Obs LIKE 'Estado no corresponde%'
    AND TfRFecha = '20261026'
    AND TfR2Sts = 'H'
    AND TfRConce = '23';
-- 134 filas


-- PREVIEW
SELECT
    tn.TagNro,
    tn.TagStT,
    tn.TagFecCtr,
    t.TfR2Tag,
    t.TfRFecha
FROM dbo.TraRet2 t
INNER JOIN dbo.TagNum tn
    ON TRY_CAST(LTRIM(RTRIM(SUBSTRING(t.TfR2Tag, 5, 8))) AS BIGINT) = tn.TagNro
WHERE t.Tfr2Obs LIKE 'Estado no corresponde%'
    AND t.TfRFecha = '20261026'
    AND t.TfR2Sts = 'H'
    AND t.TfRConce = '23';
-- 134 filas


-- CONTEO PREVIO
SELECT COUNT(*) AS FilasAfectadasEstimadas
FROM dbo.TraRet2 t
INNER JOIN dbo.TagNum tn
    ON TRY_CAST(LTRIM(RTRIM(SUBSTRING(t.TfR2Tag, 5, 8))) AS BIGINT) = tn.TagNro
WHERE t.Tfr2Obs LIKE 'Estado no corresponde%'
    AND t.TfRFecha = '20261026'
    AND t.TfR2Sts = 'H'
    AND ISNULL(tn.TagStT, '') <> 'D'
    AND t.TfRConce = '23';
-- 80 filas


-- DETALLE
SELECT *
FROM dbo.TraRet2 t
INNER JOIN dbo.TagNum tn
    ON TRY_CAST(LTRIM(RTRIM(SUBSTRING(t.TfR2Tag, 5, 8))) AS BIGINT) = tn.TagNro
WHERE t.Tfr2Obs LIKE 'Estado no corresponde%'
    AND t.TfRFecha = '20261026'
    AND t.TfR2Sts = 'H'
    AND ISNULL(tn.TagStT, '') <> 'D'
    AND t.TfRConce = '23';
-- 80 filas


-- UPDATE SEGURO
BEGIN TRAN;

UPDATE tn
SET
    tn.TagStT = 'D',
    tn.TagFecCtr = t.TfRFecha
OUTPUT
    inserted.TagNro,
    deleted.TagStT AS Antes_TagStT,
    inserted.TagStT AS Despues_TagStT,
    deleted.TagFecCtr AS Antes_TagFecCtr,
    inserted.TagFecCtr AS Despues_TagFecCtr,
    t.TfR2Tag,
    t.TfRFecha
FROM dbo.TagNum tn
INNER JOIN dbo.TraRet2 t
    ON TRY_CAST(LTRIM(RTRIM(SUBSTRING(t.TfR2Tag, 5, 8))) AS BIGINT) = tn.TagNro
WHERE t.Tfr2Obs LIKE 'Estado no corresponde%'
    AND t.TfRFecha = '20261026'
    AND t.TfR2Sts = 'H'
    AND ISNULL(tn.TagStT, '') <> 'D'
    AND t.TfRConce = '23';

-- Revisar OUTPUT antes de confirmar
-- COMMIT;
-- ROLLBACK;


-- VERIFICACIÓN
SELECT
    t.TfRFecha AS Fecha,
    COUNT(DISTINCT tn.TagNro) AS CantidadTagNumModificados
FROM dbo.TraRet2 t
INNER JOIN dbo.TagNum tn
    ON TRY_CAST(LTRIM(RTRIM(SUBSTRING(t.TfR2Tag, 5, 8))) AS BIGINT) = tn.TagNro
WHERE t.Tfr2Obs LIKE 'Estado no corresponde%'
    AND t.TfRFecha = '20261026'
    AND t.TfR2Sts = 'H'
    AND t.TfRConce = '23'
GROUP BY
    t.TfRFecha;


/* ===================================================================================================== */

SELECT
    t.TfRFecha, t.TfRConce, t.TfRRed, t.TfR2Rng, t.TfR2Fec, t.TfR2Hor, t.TfR2Men, t.TfR2Cli, t.TfR2Tag,
    t.TfR2Eje, t.TfR2Alt, t.TfR2Rue, t.TfR2MarVeh, t.TfR2ModVeh, t.TfR2DomVeh, t.TfR2De1, t.TfR2De2,
    t.TfR2De3, t.TfR2De4, t.TfR2De5, t.TfR2De6, t.TfR2De7, t.TfR2De8, t.TfR2De9, t.TfR2De10, t.TfR2Sts,
    t.TfR2TpoDis, t.TfR2Mar, t.TfR2Red, t.Tfr2Obs, t.Tfr2MarIg, t.Tfr2MarIgO, t.Tfr2MarIgD, t.TfR2FEI,
    t.TfR2FEF, s.Sum6VehDom, s.Sum6Sts, s.Sum6Tag, s.Sum6FecBaj
FROM TraRet2 t
INNER JOIN SubTag s ON t.TfR2DomVeh = s.Sum6VehDom
  AND t.Tfr2Obs LIKE 'Dominio duplicado%: 90%'
  AND t.Tfr2MarIg = 0
WHERE t.TfRFecha >= '20261026'
  AND s.Sum6FecBaj = '17530101'
  AND t.TfRConce = '23';

SELECT *
FROM SubTag
WHERE Sum6VehDom IN (
'AG143MH','LMO172','FMW949','AB424CH','JGN790','MVH354','JUN183','JHU934','LEN987','AC574CI','AH759MW','AF411DS','AG224NO','AA754XD','PFJ529','AD826YM','GUB420','FQK496','NRW490','AH798VP','OSP761')
AND Sum6FecBaj = '17530101';






 