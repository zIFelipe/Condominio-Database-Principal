
--Trigger
CREATE OR REPLACE TRIGGER TR_CREAR_CUOTA_AL_CREAR_FILIAL
AFTER INSERT ON CONDOMINIO.FILIALES
FOR EACH ROW
DECLARE
    v_cod_cuota_c CHAR(5);
    v_cod_cuota CHAR(8);
BEGIN
    -- Crear cuota condominial
    SP_REGISTRAR_CUOTA_CONDOMINIAL(
        p_monto             => 60000.00,
        p_fecha_vencimiento => SYSDATE + 30,
        p_detalle           => 'Cuota inicial automática'
    );

    -- Obtener el último código de cuota condominial generado
    SELECT 'CC' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(COD_CUOTA_C, 3))), 0), 3, '0')
    INTO v_cod_cuota_c
    FROM CONDOMINIO.CUOTAS_CONDOMINIALES;

    -- Crear cuota final
    SP_REGISTRAR_CUOTA_FINAL(
        p_cod_filial => :NEW.COD_FILIAL,
        p_cod_cuota_c     => v_cod_cuota_c,
        p_cod_cuota_e     => NULL
    );

    DBMS_OUTPUT.PUT_LINE('Trigger ejecutado: Creada cuota condominial y cuota final para el filial ' || :NEW.COD_FILIAL);
END;

CREATE OR REPLACE TRIGGER TR_CALCULAR_TOTALES_AL_CREAR_CUOTA_FINAL
BEFORE INSERT ON CONDOMINIO.CUOTAS_FINALES
FOR EACH ROW
DECLARE
    v_monto_c FLOAT;
    v_monto_e FLOAT := 0;
BEGIN
    -- Obtener monto de cuota condominial
    SELECT MONTO INTO v_monto_c FROM CONDOMINIO.CUOTAS_CONDOMINIALES WHERE COD_CUOTA_C = :NEW.COD_CUOTA_C;

    -- Si hay cuota extraordinaria, obtener su monto
    IF :NEW.COD_CUOTA_E IS NOT NULL THEN
        SELECT MONTO INTO v_monto_e FROM CONDOMINIO.CUOTAS_EXTRAORDINARIAS WHERE COD_CUOTA_E = :NEW.COD_CUOTA_E;
    END IF;

    -- Asignar directamente los valores calculados
    :NEW.TOTAL := v_monto_c + v_monto_e;
    :NEW.IVA := :NEW.TOTAL * 0.13;
    :NEW.TOTAL_IVA := :NEW.TOTAL * 1.13;

    DBMS_OUTPUT.PUT_LINE('Trigger ejecutado: Totales calculados ANTES de insertar para cuota final.');
END;

CREATE OR REPLACE TRIGGER TR_TIPO_PERSONA_ACCESO
BEFORE INSERT ON CONDOMINIO.ACCESOS
FOR EACH ROW
DECLARE
    v_es_propietario NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_es_propietario
    FROM CONDOMINIO.PROPIETARIOS
    WHERE ID_PERSONA = :NEW.ID_PERSONA;

    IF v_es_propietario > 0 THEN
        :NEW.TIPO_PERSONA := 'propietario';
    ELSE
        :NEW.TIPO_PERSONA := 'visitante';
    END IF;
END;

---triggger para actualizar el monto de la cuota final:
CREATE OR REPLACE TRIGGER TR_RECALCULAR_TOTALES_AL_ACTUALIZAR_CUOTA_FINAL
BEFORE UPDATE ON CONDOMINIO.CUOTAS_FINALES
FOR EACH ROW
DECLARE
    v_monto_c FLOAT;
    v_monto_e FLOAT := 0;
BEGIN
--se obtine lo valores de la cuota condominal
    SELECT MONTO INTO v_monto_c FROM CONDOMINIO.CUOTAS_CONDOMINIALES WHERE COD_CUOTA_C = :NEW.COD_CUOTA_C;

---se obtienen los valores de la cuota extraordinariua
    IF :NEW.COD_CUOTA_E IS NOT NULL THEN
        SELECT MONTO INTO v_monto_e FROM CONDOMINIO.CUOTAS_EXTRAORDINARIAS WHERE COD_CUOTA_E = :NEW.COD_CUOTA_E;
    END IF;

---asignamo valores de iva y ltotales
    :NEW.TOTAL := v_monto_c + v_monto_e;
    :NEW.IVA := :NEW.TOTAL * 0.13;
    :NEW.TOTAL_IVA := :NEW.TOTAL * 1.13;

    DBMS_OUTPUT.PUT_LINE('Trigger ejecutado: Totales recalculados ANTES de actualizar cuota final.');
END;