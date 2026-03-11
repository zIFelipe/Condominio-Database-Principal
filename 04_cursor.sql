
--Cursor
SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_cuotas_pago IS
        SELECT COD_CUOTA, COD_FILIAL, COD_CUOTA_C, COD_CUOTA_E, ESTADO, TOTAL, IVA, TOTAL_IVA
        FROM CONDOMINIO.CUOTAS_FINALES 
        WHERE ESTADO = 'Pago';

    v_cuota CONDOMINIO.CUOTAS_FINALES%ROWTYPE;
    
BEGIN
    OPEN c_cuotas_pago;
    LOOP
        FETCH c_cuotas_pago INTO v_cuota;
        EXIT WHEN c_cuotas_pago%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Cuota: ' || v_cuota.COD_CUOTA || 
                             ', Filial: ' || v_cuota.COD_FILIAL ||
                             ', Total: ' || v_cuota.TOTAL ||
                             ', IVA: ' || v_cuota.IVA ||
                             ', Total IVA: ' || v_cuota.TOTAL_IVA);
    END LOOP;
    CLOSE c_cuotas_pago;
END;

---procedimiento para encapsular el cursor y mostrarlo en el programa:
CREATE OR REPLACE PROCEDURE SP_OBTENER_CUOTAS_PAGADAS (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT 
        cf.COD_CUOTA, cf.ESTADO, cf.TOTAL, cf.IVA, cf.TOTAL_IVA, f.COD_FILIAL AS FILIAL_COD, f.DESCRIPCION AS DESCRIPCION, cc.COD_CUOTA_C AS CUOTA_CONDOMINAL_CODIGO, cc.DETALLE AS CUOTA_CONDOMINAL_DETALLE,ce.COD_CUOTA_E AS CUOTA_EXTRAORDINARIA_CODIGO, ce.DETALLE AS CUOTA_EXTRAORDINARIA_DETALLE
        FROM CONDOMINIO.CUOTAS_FINALES cf
        LEFT JOIN CONDOMINIO.FILIALES f ON (cf.COD_FILIAL = f.COD_FILIAL)
        LEFT JOIN CONDOMINIO.CUOTAS_CONDOMINIALES cc ON (cf.COD_CUOTA_C = cc.COD_CUOTA_C)
        LEFT JOIN CONDOMINIO.CUOTAS_EXTRAORDINARIAS ce ON (cf.COD_CUOTA_E = ce.COD_CUOTA_E)
        WHERE cf.ESTADO = 'Pago';
END;