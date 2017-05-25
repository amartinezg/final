CREATE TABLE mascaras
(
  mascara VARCHAR2(1000) NOT NULL,
  resultado VARCHAR2(4000)NOT NULL
);


CREATE OR REPLACE FUNCTION f_mascara( mascara_in IN VARCHAR2)
RETURN VARCHAR2
IS
  excep EXCEPTION;
  resultado VARCHAR2(4000):='';
  numero INT:= 0;
  contador INT:=1;
BEGIN
  
  IF 1 >= LENGTH(mascara_in) AND LENGTH(mascara_in)<= 1000 THEN
      FOR i IN 0..9 LOOP
      numero:= TO_NUMBER( REPLACE(mascara_in , '*' , TO_CHAR(i)) );
      IF (MOD(numero,6) = 0) THEN
        IF contador = 1 THEN
          contador := contador + 1;
          resultado:= TO_CHAR(numero);
        ELSE
          resultado:= resultado || ',' || TO_CHAR(numero);
        END IF;
      END IF;
    END LOOP;
  ELSE
    RAISE excep;
  END IF;
  RETURN resultado;
  EXCEPTION
    WHEN excep THEN
      dbms_output.put_line('La cadena debe de tener una longitud mayor o igual a 1 hasta 1000');
END f_mascara;

--
CREATE OR REPLACE TRIGGER insertar_mascara
BEFORE INSERT ON mascaras FOR EACH ROW
DECLARE
  resultado_mascara VARCHAR2(4000);
BEGIN
  SELECT f_mascara(mascara)
  INTO resultado_mascara
  FROM DUAL;
  :new.resultado:= resultado_mascara;
END;