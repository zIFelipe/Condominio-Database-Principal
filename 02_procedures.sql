
--Procedures registrar
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_PERSONA (
                                p_id        VARCHAR2,
                                p_nombre    VARCHAR2,
                                p_apellidos VARCHAR2,
                                p_telefono  NUMBER,
                                p_correo    VARCHAR2
                                ) 
 IS
 BEGIN
    INSERT INTO CONDOMINIO.PERSONAS (ID, NOMBRE, APELLIDOS, TELEFONO, CORREO) 
    VALUES (p_id, p_nombre, p_apellidos, p_telefono, p_correo);
DBMS_OUTPUT.PUT_LINE('Insertado cliente: ' || p_id || ' ' || p_nombre || ' ' || 
p_apellidos || ' ' || p_telefono || ' ' || p_correo);
  END SP_REGISTRAR_PERSONA;

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_PROPIETARIO (
                                p_id_persona        VARCHAR2,
                                p_fecha_adquisicion TIMESTAMP
                                ) 
 IS
    v_cod_propietario CHAR(5);
 BEGIN
    SELECT 'PR' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(COD_PROPIETARIO, 3))), 0) + 1, 3, '0')
    INTO v_cod_propietario
    FROM CONDOMINIO.PROPIETARIOS;
    
    INSERT INTO CONDOMINIO.PROPIETARIOS (COD_PROPIETARIO, ID_PERSONA, 
    FECHA_ADQUISICION) 
    VALUES (v_cod_propietario, p_id_persona, p_fecha_adquisicion);
    
    DBMS_OUTPUT.PUT_LINE('Insertado cliente: ' || v_cod_propietario || ' ' || 
    p_id_persona || ' ' || p_fecha_adquisicion);
  END SP_REGISTRAR_PROPIETARIO;

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_FILIAL (
                                p_cod_propietario CHAR,
                                p_descripcion     VARCHAR2,
                                p_valor           FLOAT,
                                p_direccion       VARCHAR2
                                ) 
 IS
    v_cod_filial CHAR(5);
 BEGIN
 
SELECT 'FI' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(COD_FILIAL, 3))), 0) + 1, 3, '0')
INTO v_cod_filial
FROM CONDOMINIO.FILIALES;
    
    INSERT INTO CONDOMINIO.FILIALES (COD_FILIAL, COD_PROPIETARIO, DESCRIPCION, 
    VALOR, DIRECCION) 
    VALUES (v_cod_filial, p_cod_propietario, p_descripcion, p_valor, p_direccion);
    
    DBMS_OUTPUT.PUT_LINE('Insertado filial: ' || v_cod_filial || ' ' || 
    p_cod_propietario || ' ' || p_descripcion || ' ' || p_valor || ' ' || p_direccion);
  END SP_REGISTRAR_FILIAL;
  
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_ACCESOS (
                                p_cod_filial  CHAR,
                                p_id_persona  VARCHAR2,
                                p_fecha_hora  TIMESTAMP,
                                p_tipo_acceso VARCHAR2,
                                p_detalle     VARCHAR2
                                ) 
 IS
    v_cod_acceso CHAR(5);
 BEGIN
    SELECT 'AC' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(COD_ACCESO, 3))), 0) + 1, 3, '0')
    INTO v_cod_acceso
    FROM CONDOMINIO.ACCESOS;
 
    INSERT INTO CONDOMINIO.ACCESOS (COD_ACCESO, COD_FILIAL, ID_PERSONA, 
    FECHA_HORA, TIPO_ACCESO, DETALLE) 
    VALUES (v_cod_acceso, p_cod_filial, p_id_persona, p_fecha_hora, p_tipo_acceso, p_detalle);
    
    DBMS_OUTPUT.PUT_LINE('Insertado acceso: ' || v_cod_acceso || ' ' || p_cod_filial || ' ' || 
    p_id_persona || ' ' || p_fecha_hora || ' ' || p_tipo_acceso || ' ' || p_detalle);
  END SP_REGISTRAR_ACCESOS;

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_CUOTA_CONDOMINIAL (
                                p_monto             FLOAT,
                                p_fecha_vencimiento TIMESTAMP,
                                p_detalle           VARCHAR2
                                ) 
 IS
    v_cod_cuota_c CHAR(5);
 BEGIN
    SELECT 'CC' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(COD_CUOTA_C, 3))), 0) + 1, 3, '0')
    INTO v_cod_cuota_c
    FROM CONDOMINIO.CUOTAS_CONDOMINIALES;
    
    INSERT INTO CONDOMINIO.CUOTAS_CONDOMINIALES (COD_CUOTA_C, MONTO, 
    FECHA_VENCIMIENTO, DETALLE) 
    VALUES (v_cod_cuota_c, p_monto, p_fecha_vencimiento, p_detalle);
    
    DBMS_OUTPUT.PUT_LINE('Insertado cuota: ' || v_cod_cuota_c || ' ' || p_monto || ' ' || 
    p_fecha_vencimiento || ' ' || p_detalle);
  END SP_REGISTRAR_CUOTA_CONDOMINIAL;
  
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_CUOTA_EXTRAORDINARIA (
                                p_monto             FLOAT,
                                p_fecha_emision     TIMESTAMP,
                                p_fecha_vencimiento TIMESTAMP,
                                p_detalle           VARCHAR2
                                ) 
 IS
    v_cod_cuota_e CHAR(5);
 BEGIN
    SELECT 'CE' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(COD_CUOTA_E, 3))), 0) + 1, 3, '0')
    INTO v_cod_cuota_e
    FROM CONDOMINIO.CUOTAS_EXTRAORDINARIAS;
 
    INSERT INTO CONDOMINIO.CUOTAS_EXTRAORDINARIAS (COD_CUOTA_E, MONTO, FECHA_EMISION, 
    FECHA_VENCIMIENTO, DETALLE) 
    VALUES (v_cod_cuota_e, p_monto, p_fecha_emision, p_fecha_vencimiento, p_detalle);
    
    DBMS_OUTPUT.PUT_LINE('Insertado cuota: ' || v_cod_cuota_e || ' ' || p_monto || ' ' || 
    p_fecha_emision || ' ' || p_fecha_vencimiento || ' ' || p_detalle);
  END SP_REGISTRAR_CUOTA_EXTRAORDINARIA;
  
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_CUOTA_FINAL (
                                p_cod_filial CHAR,
                                p_cod_cuota_c     CHAR,
                                p_cod_cuota_e     CHAR
                                ) 
 IS
    v_cod_cuota CHAR(5);
 BEGIN
    SELECT 'CF' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(COD_CUOTA, 3))), 0) + 1, 3, '0')
    INTO v_cod_cuota
    FROM CONDOMINIO.CUOTAS_FINALES;
 
    INSERT INTO CONDOMINIO.CUOTAS_FINALES (COD_CUOTA, COD_FILIAL, COD_CUOTA_C, 
    COD_CUOTA_E, ESTADO) 
    VALUES (v_cod_cuota, p_cod_filial, p_cod_cuota_c, p_cod_cuota_e, 
    'Pendiente');
    
    DBMS_OUTPUT.PUT_LINE('Insertado cuota: ' || v_cod_cuota || ' ' || 
    p_cod_filial || ' ' || p_cod_cuota_c || ' ' || p_cod_cuota_e || ' ' 
    || 'Pendiente');
  END SP_REGISTRAR_CUOTA_FINAL;
  
--Procedures eliminar
CREATE OR REPLACE PROCEDURE SP_ELIMINAR_PERSONAS (p_id IN VARCHAR2)
 IS
 BEGIN
    DELETE FROM CONDOMINIO.PERSONAS WHERE ID = p_id;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ELIMINAR_PERSONAS;
    
CREATE OR REPLACE PROCEDURE SP_ELIMINAR_PROPIETARIOS (p_cod_propietario IN VARCHAR2)
 IS
 BEGIN
    DELETE FROM CONDOMINIO.PROPIETARIOS WHERE COD_PROPIETARIO = p_cod_propietario;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ELIMINAR_PROPIETARIOS;

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_FILIAL (p_cod_filial IN VARCHAR2)
 IS
 BEGIN
    DELETE FROM CONDOMINIO.FILIALES WHERE COD_FILIAL = p_cod_filial;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ELIMINAR_FILIAL;

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_ACCESOS (p_cod_acceso IN VARCHAR2)
 IS
 BEGIN
    DELETE FROM CONDOMINIO.ACCESOS WHERE COD_ACCESO = p_cod_acceso;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ELIMINAR_ACCESOS;
    
CREATE OR REPLACE PROCEDURE SP_ELIMINAR_CUOTAS_CONDOMINIALES (p_cod_cuota_c IN VARCHAR2)
 IS
 BEGIN
    DELETE FROM CONDOMINIO.CUOTAS_CONDOMINIALES WHERE COD_CUOTA_C = p_cod_cuota_c;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ELIMINAR_CUOTAS_CONDOMINIALES;
    
CREATE OR REPLACE PROCEDURE SP_ELIMINAR_CUOTAS_EXTRAORDINARIAS (p_cod_cuota_e IN VARCHAR2)
 IS
 BEGIN
    DELETE FROM CONDOMINIO.CUOTAS_EXTRAORDINARIAS WHERE COD_CUOTA_E = p_cod_cuota_e;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ELIMINAR_CUOTAS_EXTRAORDINARIAS;
    
CREATE OR REPLACE PROCEDURE SP_ELIMINAR_CUOTAS_FINALES (p_cod_cuota IN VARCHAR2)
 IS
 BEGIN
    DELETE FROM CONDOMINIO.CUOTAS_FINALES WHERE COD_CUOTA = p_cod_cuota;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ELIMINAR_CUOTAS_FINALES;
    
--Procedures actualizar
CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_PERSONA(
                                p_id        VARCHAR2,
                                p_nombre    VARCHAR2,
                                p_apellidos VARCHAR2,
                                p_telefono  NUMBER,
                                p_correo    VARCHAR2
                                )  
 IS
 BEGIN
    UPDATE CONDOMINIO.PERSONAS SET NOMBRE = p_nombre,
APELLIDOS = p_apellidos, TELEFONO = p_telefono, CORREO = p_correo
    WHERE ID = p_id;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ACTUALIZAR_PERSONA;

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_PROPIETARIO(
                                p_cod_propietario   CHAR,
                                p_id_persona        VARCHAR2,
                                p_fecha_adquisicion TIMESTAMP
                                ) 
 IS
 BEGIN
    UPDATE CONDOMINIO.PROPIETARIOS SET ID_PERSONA = p_id_persona, 
    FECHA_ADQUISICION = p_fecha_adquisicion
    WHERE COD_PROPIETARIO = p_cod_propietario;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ACTUALIZAR_PROPIETARIO;
    
CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_FILIAL(
                                p_cod_filial      CHAR,
                                p_cod_propietario CHAR,
                                p_descripcion     VARCHAR2,
                                p_valor           FLOAT,
                                p_direccion       VARCHAR2
                                )  
 IS
 BEGIN
    UPDATE CONDOMINIO.FILIALES SET COD_PROPIETARIO = p_cod_propietario, 
    DESCRIPCION = p_descripcion, VALOR = p_valor, DIRECCION = p_direccion
    WHERE COD_FILIAL = p_cod_filial;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ACTUALIZAR_FILIAL;

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_ACCESO(
                                p_cod_acceso  CHAR,
                                p_cod_filial  CHAR,
                                p_id_persona  VARCHAR2,
                                p_fecha_hora  TIMESTAMP,
                                p_tipo_acceso VARCHAR2,
                                p_detalle     VARCHAR2
                                )  
 IS
 BEGIN
    UPDATE CONDOMINIO.ACCESOS SET COD_FILIAL = p_cod_filial,
    ID_PERSONA = p_id_persona, FECHA_HORA = p_fecha_hora, 
    TIPO_ACCESO = p_tipo_acceso, DETALLE = p_detalle
    WHERE COD_ACCESO = p_cod_acceso;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ACTUALIZAR_ACCESO;
    
CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_CUOTA_CONDOMINIAL(
                                p_cod_cuota_c       CHAR,
                                p_monto             FLOAT,
                                p_detalle           VARCHAR2
                                ) 
 IS
 BEGIN
    UPDATE CONDOMINIO.CUOTAS_CONDOMINIALES SET MONTO = p_monto, 
    DETALLE = p_detalle
    WHERE COD_CUOTA_C = p_cod_cuota_c;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ACTUALIZAR_CUOTA_CONDOMINIAL;
    
CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_CUOTA_EXTRAORDINARIA(
                                p_cod_cuota_e       CHAR,
                                p_monto             FLOAT,
                                p_fecha_emision     TIMESTAMP,
                                p_fecha_vencimiento TIMESTAMP,
                                p_detalle           VARCHAR2
                                )  
 IS
 BEGIN
    UPDATE CONDOMINIO.CUOTAS_EXTRAORDINARIAS SET  MONTO = p_monto, 
    FECHA_EMISION = p_fecha_emision, FECHA_VENCIMIENTO = p_fecha_vencimiento, 
    DETALLE = p_detalle
    WHERE COD_CUOTA_E = p_cod_cuota_e;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ACTUALIZAR_CUOTA_EXTRAORDINARIA;
    
CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_CUOTA_FINAL(
                                p_cod_cuota       CHAR,
                                p_cod_filial      CHAR,
                                p_cod_cuota_c     CHAR,
                                p_cod_cuota_e     CHAR,
                                p_estado          VARCHAR2
                                )  
 IS
 BEGIN
    UPDATE CONDOMINIO.CUOTAS_FINALES SET COD_FILIAL = p_cod_filial, 
    COD_CUOTA_C = p_cod_cuota_c, COD_CUOTA_E = p_cod_cuota_e, ESTADO = p_estado
    WHERE COD_CUOTA = p_cod_cuota;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    END SP_ACTUALIZAR_CUOTA_FINAL;    
