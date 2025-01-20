

DELIMITER $$
--
-- Procedimientos
--
$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

CREATE  PROCEDURE `alm_papcompraingresoegreso` (IN `pTipo` VARCHAR(1), IN `pidcompra` INT, IN `pnumerocompra` INT, IN `pnombrecompra` VARCHAR(256), IN `ptitulo` VARCHAR(256), IN `pidusuario` INT, IN `pidproveedor` INT, IN `pfechacompra` DATETIME, IN `ptipocompra` INT, IN `pidoficina` INT, IN `psubtotal` DECIMAL(10,0), IN `pdescuento` DECIMAL(10,0), IN `ptotal` DECIMAL(10,0), IN `pidmoneda` INT, IN `pdescripcion` VARCHAR(512), IN `pidestadocompra` INT, IN `ppagado` DECIMAL(10,0), IN `pcambio` DECIMAL(10,0), IN `pidusuarioresponsable` INT, IN `pidaperturacierrecaja` INT)   begin
DECLARE pidingresoegreso INT ;
DECLARE pidpagocompra INT ;	
DECLARE pidproductostock INT ;
DECLARE pidproducto INT ;
DECLARE pcantidad INT ;
DECLARE ppreciounitario INT ;
DECLARE pprecioventa INT ;
DECLARE pidcompradetalle INT ;
IF ptipo='U' then
call alm_papcompraingresoegreso_stock(pidcompra,pidoficina,pidusuario); 
IF (SELECT count(*) FROM alm_tblcompra WHERE titulo='ok' and idcompra=pidcompra AND estadoregistro=1)=1
and (SELECT count(*) FROM alm_tblcompradetalle WHERE idcompra=pidcompra AND estadoregistro=1)>0 then 
		SET psubtotal=(SELECT sum(preciounitario*cantidad) FROM alm_tblcompradetalle WHERE idcompra=pidcompra AND estadoregistro=1);
		SET ptotal=psubtotal-pdescuento;
                SET pnumerocompra=(SELECT max(ifnull(numerocompra,0)) FROM alm_tblcompra WHERE estadoregistro=1)+1;
		UPDATE alm_tblcompra SET idestadocompra=pidestadocompra,subtotal=psubtotal,total=ptotal,numerocompra=pnumerocompra WHERE idcompra=pidcompra AND estadoregistro=1;
		#registramos compra al contado
		IF pidestadocompra=2 then  
			SET pidingresoegreso = (SELECT(IFNULL(MAX(idingresoegreso) + 1, 1)) FROM alm_tblingresoegreso);
			INSERT INTO alm_tblingresoegreso(
idingresoegreso,descripcion,fechaingresoegreso,idplandecuenta,monto,idmoneda,idtipopago,idusuario,idoficina,idcierrecaja,fecharegistro,estadoregistro)	values (
pidingresoegreso,concat('idcompra:',pidcompra),DATE_ADD(NOW(),INTERVAL -4 HOUR),1,ptotal,1,1,pidusuario,pidoficina,1,now(),1);
			SET pidpagocompra = (SELECT  (IFNULL(MAX(idpagocompra) + 1,1)) FROM alm_tblpagocompra);
		INSERT INTO alm_tblpagocompra(
idpagocompra,idcompra,idingresoegreso,fecha,descripcion,monto,idtipopago,idcotizacionmoneda,idusuario,idoficina,fecharegistro,estadoregistro)	values (
pidpagocompra,pidcompra,pidingresoegreso,DATE_ADD(NOW(),INTERVAL -4 HOUR),concat('idcompra:',pidcompra),ptotal,1,1,pidusuario,pidoficina,now(),1);
			UPDATE alm_tblcompra SET pagado=ptotal WHERE idcompra=pidcompra AND estadoregistro=1;
		END IF;
#registramos stock

else
SELECT idcompra,idestadocompra FROM alm_tblcompra WHERE titulo='ok' and idcompra=pidcompra AND estadoregistro=1;
END IF;
END IF;
END$$

CREATE  PROCEDURE `alm_papcompraingresoegreso_stock` (IN `pidcompra` INT, IN `pidoficina` INT, IN `pidusuario` INT)   BEGIN
DECLARE pidproductostock INT ;
DECLARE pidproducto INT ;
DECLARE pcantidad decimal(10,0) ;
DECLARE ppreciounitario decimal(10,0) ;
DECLARE pprecioventa decimal(10,0) ;
DECLARE pidcompradetalle INT ;
DECLARE var_final INTEGER DEFAULT 0;
  DECLARE cursor1 CURSOR FOR SELECT idproducto,cantidad,preciounitario,precioventa,idcompradetalle FROM alm_viscompradetalle WHERE idcompra=pidcompra;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
  OPEN cursor1;
  bucle: LOOP
    FETCH cursor1 INTO pidproducto,pcantidad,ppreciounitario,pprecioventa,pidcompradetalle;
    IF var_final = 1 THEN
      LEAVE bucle;
    END IF;
	SET pidproductostock = (SELECT(IFNULL(MAX(idproductostock) + 1, 1)) FROM alm_tblproductostock);
	INSERT INTO alm_tblproductostock(
	idproductostock,idproducto,idoficina,cantidad,cantidadminima,cantidadmaxima,preciocompra,precioventa,idusuarioregistra,idcompradetalle,idcompradetalledato,fecharegistro,estadoregistro)	values (
	pidproductostock,pidproducto,pidoficina,pcantidad,0,pcantidad,ppreciounitario,pprecioventa,pidusuario,pidcompradetalle,1,now(),1);
  END LOOP bucle;
  CLOSE cursor1;
UPDATE alm_tblcompra SET titulo='ok' WHERE idcompra=pidcompra AND estadoregistro=1;
END$$

CREATE  PROCEDURE `alm_pappagocompra` (IN `pTipo` VARCHAR(1), IN `pidpagocompra` INT, IN `pidcompra` INT, IN `pidingresoegreso` INT, IN `pfecha` DATETIME, IN `pdescripcion` VARCHAR(2000), IN `pmonto` DECIMAL(10,0), IN `pidtipopago` INT, IN `pidcotizacionmoneda` INT, IN `pidusuario` INT, IN `pidoficina` INT)   begin
DECLARE pidestadocompra INT;
DECLARE pmontocompra decimal;
	IF ptipo='U' then 
		SET pidestadocompra = (SELECT idestadocompra FROM alm_tblcompra WHERE idcompra=pidcompra AND estadoregistro=1 LIMIT 1);
		
		IF pidestadocompra=3 then  
			SET pidingresoegreso = (SELECT(IFNULL(MAX(idingresoegreso) + 1, 1)) FROM alm_tblingresoegreso);
			INSERT INTO alm_tblingresoegreso(
idingresoegreso,descripcion,fechaingresoegreso,idplandecuenta,monto,idmoneda,idtipopago,idusuario,idoficina,idcierrecaja,fecharegistro,estadoregistro)	values (
pidingresoegreso,concat('idcompra:',pidcompra),DATE_ADD(NOW(),INTERVAL -4 HOUR),1,pmonto,1,1,pidusuario,pidoficina,1,now(),1);
			SET pidpagocompra = (SELECT  (IFNULL(MAX(idpagocompra) + 1,1)) FROM alm_tblpagocompra);
		INSERT INTO alm_tblpagocompra(
idpagocompra,idcompra,idingresoegreso,fecha,descripcion,monto,idtipopago,idcotizacionmoneda,idusuario,idoficina,fecharegistro,estadoregistro)	values (
pidpagocompra,pidcompra,pidingresoegreso,DATE_ADD(NOW(),INTERVAL -4 HOUR),pdescripcion,pmonto,1,1,pidusuario,pidoficina,now(),1);

			SET pmonto=(SELECT SUM(monto) from alm_tblpagocompra WHERE idcompra=pidcompra AND estadoregistro=1);
			SET pmontocompra = (SELECT total FROM alm_tblcompra WHERE idcompra=pidcompra AND estadoregistro=1 LIMIT 1);
			update alm_tblcompra SET pagado=pmonto WHERE idcompra=pidcompra AND estadoregistro=1;
			if (pmonto)>=(pmontocompra) then
				update alm_tblcompra SET idestadocompra=2 WHERE idcompra=pidcompra AND estadoregistro=1;
			END if;
			
			select pidpagocompra idpagocompra;
		END IF;
		IF pidestadocompra=1 then 
			SELECT -1 idpagocompra;
		END IF;
	END IF;
END$$

CREATE  PROCEDURE `alm_pappagoventa` (IN `pTipo` VARCHAR(1), IN `pidpagoventa` INT, IN `pidventa` INT, IN `pidingresoegreso` INT, IN `pfecha` DATETIME, IN `pdescripcion` VARCHAR(2000), IN `pmonto` DECIMAL(10,0), IN `pidtipopago` INT, IN `pidcotizacionmoneda` INT, IN `pidusuario` INT, IN `pidoficina` INT)   begin
DECLARE pidestadoventa INT;
DECLARE pmontoventa decimal;
	IF ptipo='U' then 
		SET pidestadoventa = (SELECT idestadoventa FROM alm_tblventa WHERE idventa=pidventa AND estadoregistro=1 LIMIT 1);
		
		IF pidestadoventa=3 then  
			SET pidingresoegreso = (SELECT(IFNULL(MAX(idingresoegreso) + 1, 1)) FROM alm_tblingresoegreso);
			INSERT INTO alm_tblingresoegreso(
idingresoegreso,descripcion,fechaingresoegreso,idplandecuenta,monto,idmoneda,idtipopago,idusuario,idoficina,idcierrecaja,fecharegistro,estadoregistro)	values (
pidingresoegreso,concat('idventa:',pidventa),DATE_ADD(NOW(),INTERVAL -4 HOUR),1,pmonto,1,1,pidusuario,pidoficina,1,now(),1);
			SET pidpagoventa = (SELECT  (IFNULL(MAX(idpagoventa) + 1,1)) FROM alm_tblpagoventa);
		INSERT INTO alm_tblpagoventa(
idpagoventa,idventa,idingresoegreso,fecha,descripcion,monto,idtipopago,idcotizacionmoneda,idusuario,idoficina,fecharegistro,estadoregistro)	values (
pidpagoventa,pidventa,pidingresoegreso,DATE_ADD(NOW(),INTERVAL -4 HOUR),pdescripcion,pmonto,1,1,pidusuario,pidoficina,now(),1);

			SET pmonto=(SELECT SUM(monto) from alm_tblpagoventa WHERE idventa=pidventa AND estadoregistro=1);
			SET pmontoventa = (SELECT total FROM alm_tblventa WHERE idventa=pidventa AND estadoregistro=1 LIMIT 1);
			update alm_tblventa SET pagado=pmonto WHERE idventa=pidventa AND estadoregistro=1;
			if (pmonto)>=(pmontoventa) then
				update alm_tblventa SET idestadoventa=2 WHERE idventa=pidventa AND estadoregistro=1;
			END if;
			
			select pidpagoventa idpagoventa;
		END IF;
		IF pidestadoventa=1 then 
			SELECT -1 idpagoventa;
		END IF;
	END IF;
END$$

CREATE  PROCEDURE `alm_papventaingresoegreso` (IN `pTipo` VARCHAR(1), IN `pidventa` INT, IN `pnumeroventa` INT, IN `pnombreventa` VARCHAR(256), IN `ptitulo` VARCHAR(256), IN `pidusuario` INT, IN `pidcliente` INT, IN `pfechaventa` DATETIME, IN `ptipoventa` INT, IN `pidoficina` INT, IN `psubtotal` DECIMAL(10,0), IN `pdescuento` DECIMAL(10,0), IN `ptotal` DECIMAL(10,0), IN `pidmoneda` INT, IN `pdescripcion` VARCHAR(512), IN `pidestadoventa` INT, IN `ppagado` DECIMAL(10,0), IN `pcambio` DECIMAL(10,0), IN `pidusuarioresponsable` INT, IN `pidaperturacierrecaja` INT)   begin
DECLARE pidingresoegreso INT ;
DECLARE pidpagoventa INT ;	
DECLARE pidproductostock INT ;
DECLARE pidproducto INT ;
DECLARE pcantidad INT ;
DECLARE ppreciounitario INT ;
DECLARE pprecioventa INT ;
DECLARE pidventadetalle INT ;
IF ptipo='U' then
UPDATE alm_tblventa SET titulo='ini' WHERE idventa=pidventa AND estadoregistro=1;
if (SELECT count(*) FROM alm_tblventadetalle,alm_tblproductostock WHERE alm_tblventadetalle.estadoregistro=1 AND alm_tblventadetalle.idcompradetalle=alm_tblproductostock.idcompradetalle AND alm_tblventadetalle.cantidad>alm_tblproductostock.cantidad and alm_tblventadetalle.idventa=pidventa)>0 and
(SELECT count(*) FROM alm_tblventadetalle where idventa=pidventa)>0 then
UPDATE alm_tblventa SET titulo='sin stock' WHERE idventa=pidventa AND estadoregistro=1;
else
call alm_papventaingresoegreso_stock(pidventa,pidoficina,pidusuario); 
IF (SELECT count(*) FROM alm_tblventa WHERE titulo='ok' and idventa=pidventa AND estadoregistro=1)=1 then 
		SET psubtotal=(SELECT sum(preciounitario*cantidad) FROM alm_tblventadetalle WHERE idventa=pidventa AND estadoregistro=1);
		SET ptotal=psubtotal-pdescuento;
                SET pnumeroventa=(SELECT max(ifnull(numeroventa,0)) FROM alm_tblventa WHERE estadoregistro=1)+1;
		UPDATE alm_tblventa SET idestadoventa=pidestadoventa,subtotal=psubtotal,total=ptotal,numeroventa=pnumeroventa WHERE idventa=pidventa AND estadoregistro=1;
		#registramos venta al contado
		IF pidestadoventa=2 then  
			SET pidingresoegreso = (SELECT(IFNULL(MAX(idingresoegreso) + 1, 1)) FROM alm_tblingresoegreso);
			INSERT INTO alm_tblingresoegreso(
idingresoegreso,descripcion,fechaingresoegreso,idplandecuenta,monto,idmoneda,idtipopago,idusuario,idoficina,idcierrecaja,fecharegistro,estadoregistro)	values (
pidingresoegreso,concat('idventa:',pidventa),DATE_ADD(NOW(),INTERVAL -4 HOUR),2,ptotal,1,1,pidusuario,pidoficina,1,now(),1);
			SET pidpagoventa = (SELECT  (IFNULL(MAX(idpagoventa) + 1,1)) FROM alm_tblpagoventa);
		INSERT INTO alm_tblpagoventa(
idpagoventa,idventa,idingresoegreso,fecha,descripcion,monto,idtipopago,idcotizacionmoneda,idusuario,idoficina,fecharegistro,estadoregistro)	values (
pidpagoventa,pidventa,pidingresoegreso,DATE_ADD(NOW(),INTERVAL -4 HOUR),concat('idventa:',pidventa),ptotal,1,1,pidusuario,pidoficina,now(),1);
			UPDATE alm_tblventa SET pagado=ptotal WHERE idventa=pidventa AND estadoregistro=1;
		END IF;
#registramos stock

else
SELECT idventa,idestadoventa FROM alm_tblventa WHERE titulo='ok' and idventa=pidventa AND estadoregistro=1;
END IF;
END IF;
END IF;
END$$

CREATE  PROCEDURE `alm_papventaingresoegreso_stock` (IN `pidventa` INT, IN `pidoficina` INT, IN `pidusuario` INT)   BEGIN
DECLARE pidproductostock INT ;
DECLARE pidproducto INT ;
DECLARE pcantidad decimal(10,0) ;
DECLARE ppreciounitario decimal(10,0) ;
DECLARE pprecioventa decimal(10,0) ;
DECLARE pidventadetalle INT ;
DECLARE pidcompradetalle INT ;

DECLARE var_final INTEGER DEFAULT 0;
  DECLARE cursor1 CURSOR FOR SELECT idventadetalle,cantidad,idcompradetalle FROM alm_visventadetalle WHERE idventa=pidventa;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
  OPEN cursor1;
  bucle: LOOP
    FETCH cursor1 INTO pidventadetalle,pcantidad,pidcompradetalle;
    IF var_final = 1 THEN
      LEAVE bucle;
    END IF;
	update alm_tblproductostock set cantidad=cantidad-pcantidad where idcompradetalle=pidcompradetalle;
	update alm_tblventadetalle set idestadoventadetalle=1 where idventadetalle=pidventadetalle;
  END LOOP bucle;
  CLOSE cursor1;
UPDATE alm_tblventa SET titulo='ok' WHERE idventa=pidventa AND estadoregistro=1;


END$$

$$

$$

$$

$$

$$

CREATE  PROCEDURE `pcontrolsesion` (IN `pTipo` VARCHAR(1), IN `pidusuariologueado` INT, IN `pidusuario` INT, IN `pidrolusuario` INT, IN `pllave` VARCHAR(300), IN `pidestadollave` INT, IN `pfecha` DATETIME, IN `pdireccionip` VARCHAR(25), IN `pdireccionhost` VARCHAR(25), IN `pdirecciondest` VARCHAR(250), IN `pidsucursal` INT)   begin
	IF pTipo='C' then  	
	UPDATE  seg_tblusuariologueado SET idestadollave=2 WHERE idusuario=pidusuario AND idestadollave=1;
	SET pidusuariologueado = (SELECT  (IFNULL(MAX(idusuariologueado) + 1,1)) FROM seg_tblusuariologueado);
	INSERT INTO seg_tblusuariologueado(idusuariologueado, idusuario, idrolusuario, llave, idestadollave, fecha, direccionip, direccionhost, direcciondest,idsucursal,fecharegistro,estadoregistro)	
	values (pidusuariologueado, pidusuario, pidrolusuario, pllave, pidestadollave, pfecha, pdireccionip, pdireccionhost, pdirecciondest,pidsucursal,NOW(),1);
	SELECT pidusuariologueado AS idusuariologueado;
	END IF;
END$$

CREATE  PROCEDURE `pcontrolsesionlog` (IN `pTipo` VARCHAR(1), IN `pnombresistema` CHAR(6), IN `pidusuario` INT, IN `pnombreservicio` CHAR(32))   begin
	IF pTipo='C' then  	
	INSERT INTO seg_tbllogusuario(nombresistema, idusuario, nombreservicio, fecharegistro, estadoregistro)	
	values (pnombresistema, pidusuario, pnombreservicio,NOW(),1);
	SELECT NOW() AS fecha;
	END IF;
END$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblcierrecaja`
--

CREATE TABLE `alm_tblcierrecaja` (
  `idcierrecaja` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `montoinicio` decimal(10,0) DEFAULT NULL,
  `montofinal` decimal(10,0) DEFAULT NULL,
  `idusuariocierre` int(11) DEFAULT NULL,
  `idestadocierrecaja` smallint(6) DEFAULT NULL,
  `fechainicio` datetime DEFAULT NULL,
  `fechafinal` datetime DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblclasificacionproducto`
--

CREATE TABLE `alm_tblclasificacionproducto` (
  `idclasificacionproducto` int(11) DEFAULT NULL,
  `nombreclasificacionproducto` varchar(50) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `idclasificacionproductopadre` int(11) DEFAULT NULL,
  `primario` int(11) DEFAULT NULL,
  `idtipoclasificacionproducto` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblclasificacionproducto`
--

INSERT INTO `alm_tblclasificacionproducto` (`idclasificacionproducto`, `nombreclasificacionproducto`, `descripcion`, `idclasificacionproductopadre`, `primario`, `idtipoclasificacionproducto`, `fecharegistro`, `estadoregistro`) VALUES
(1, 'PRODUCTO', ' ', 0, 1, 1, '2024-02-18 20:04:58', b'1'),
(2, 'SERVICIO', ' ', 0, 1, 2, '2024-02-18 20:05:00', b'1'),
(3, 'INSUMO', ' ', 0, 1, 3, '2024-02-18 20:05:01', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblcompra`
--

CREATE TABLE `alm_tblcompra` (
  `idcompra` int(11) DEFAULT NULL,
  `numerocompra` int(11) DEFAULT NULL,
  `nombrecompra` varchar(256) DEFAULT NULL,
  `titulo` varchar(256) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `idproveedor` int(11) DEFAULT NULL,
  `fechacompra` datetime DEFAULT NULL,
  `tipocompra` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `subtotal` decimal(10,0) DEFAULT NULL,
  `descuento` decimal(10,0) DEFAULT NULL,
  `total` decimal(10,0) DEFAULT NULL,
  `idmoneda` int(11) DEFAULT NULL,
  `descripcion` varchar(512) DEFAULT NULL,
  `idestadocompra` int(11) DEFAULT NULL,
  `pagado` decimal(10,0) DEFAULT NULL,
  `cambio` decimal(10,0) DEFAULT NULL,
  `idusuarioresponsable` int(11) DEFAULT NULL,
  `idaperturacierrecaja` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblcompra`
--

INSERT INTO `alm_tblcompra` (`idcompra`, `numerocompra`, `nombrecompra`, `titulo`, `idusuario`, `idproveedor`, `fechacompra`, `tipocompra`, `idoficina`, `subtotal`, `descuento`, `total`, `idmoneda`, `descripcion`, `idestadocompra`, `pagado`, `cambio`, `idusuarioresponsable`, `idaperturacierrecaja`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 'ci:71682810 prov:(Super Mobil) Manuel  Dorado ', 'ok', 2, 2, '2024-02-26 09:49:57', 0, 1, 350, 0, 350, 0, '', 2, 350, 0, 0, 0, '2024-02-26 13:50:07', b'1'),
(2, 2, 'ci:100 prov:Distribuidora YPFB San Luis ', 'ok', 2, 3, '2024-02-26 09:57:33', 0, 1, 210, 0, 210, 0, '', 2, 210, 0, 0, 0, '2024-02-26 13:57:38', b'1'),
(3, 3, 'ci:200 prov:Rafael  Feria Ferreteros ', 'ok', 2, 4, '2024-02-26 10:01:52', 0, 1, 464, 0, 464, 0, '', 2, 464, 0, 0, 0, '2024-02-26 14:01:58', b'1'),
(4, 4, 'ci:200 prov:Rafael  Feria Ferreteros ', 'ok', 2, 4, '2024-02-25 10:12:29', 0, 1, 168, 0, 168, 0, '', 2, 168, 0, 0, 0, '2024-02-26 14:12:39', b'1'),
(5, 11, 'ci:200 prov:Rafael  Feria Ferreteros ', 'ok', 2, 4, '2024-02-26 10:14:06', 0, 1, 35, 0, 35, 0, '', 2, 35, 0, 0, 0, '2024-02-26 14:14:13', b'1'),
(6, 5, 'ci:200 prov:Rafael  Feria Ferreteros ', 'ok', 2, 4, '2024-02-26 10:15:41', 0, 1, 360, 0, 360, 0, '', 2, 360, 0, 0, 0, '2024-02-25 14:15:45', b'1'),
(7, 5, 'ci:123 prov:sin datos ', 'ok', 6, 1, '2024-03-06 13:40:35', 0, 1, 70, 0, 70, 0, '', 2, 70, 0, 0, 0, '2024-03-06 17:40:40', b'1'),
(8, 5, 'ci:123 prov:sin datos ', 'ok', 1, 1, '2024-03-07 12:21:36', 0, 1, 100, 0, 100, 0, '', 2, 100, 0, 0, 0, '2024-03-07 16:21:39', b'1'),
(9, 6, 'ci:123 prov:sin datos ', 'ok', 1, 1, '2024-03-07 12:27:41', 0, 1, 200, 0, 200, 0, '', 2, 200, 0, 0, 0, '2024-03-07 16:27:44', b'1'),
(10, 7, 'ci:123 prov:sin datos ', 'ok', 1, 1, '2024-03-07 12:39:06', 0, 1, 1000, 0, 1000, 0, '', 2, 1000, 0, 0, 0, '2024-03-07 16:39:08', b'1'),
(11, 8, 'ci:71682810 prov:(Super Mobil) Manuel  Dorado ', 'ok', 1, 2, '2024-03-07 18:37:23', 0, 1, 1015, 0, 1015, 0, '', 2, 1015, 0, 0, 0, '2024-03-07 22:37:27', b'1'),
(12, 12, 'ci:71682810 prov:(Super Mobil) Manuel  Dorado ', 'ok', 1, 2, '2024-03-07 18:39:48', 0, 1, 14, 0, 14, 0, '', 2, 14, 0, 0, 0, '2024-03-07 22:39:53', b'1'),
(13, 13, 'ci:100 prov:Distribuidora YPFB San Luis ', 'ok', 3, 3, '2024-03-09 11:12:34', 0, 1, 408, 0, 408, 0, '', 2, 408, 0, 0, 0, '2024-03-09 15:12:42', b'1'),
(14, 0, 'ci:71682810 prov:(Super Mobil) Manuel  Dorado ', '', 6, 2, '2024-03-11 10:02:30', 0, 1, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '2024-03-11 14:02:40', b'1'),
(15, 0, 'ci:123 prov:sin datos ', '', 7, 1, '2024-03-11 15:59:22', 0, 1, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '2024-03-11 19:59:39', b'1'),
(16, 0, 'ci:123 prov:sin datos ', 'ok', 7, 1, '2024-03-11 16:20:39', 0, 1, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '2024-03-11 20:20:46', b'1'),
(17, 0, 'ci:100 prov:Distribuidora YPFB San Luis ', '', 6, 3, '2024-03-11 17:43:30', 0, 1, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '2024-03-11 21:43:55', b'1'),
(18, 0, 'ci:71682810 prov:(Super Mobil) Manuel  Dorado ', '', 6, 2, '2024-03-11 18:38:42', 0, 1, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '2024-03-11 22:38:51', b'1'),
(19, 9, 'ci:71682810 prov:(Super Mobil) Manuel  Dorado ', 'ok', 6, 2, '2024-03-12 09:35:16', 0, 1, 35, 0, 30, 0, '', 3, 0, 0, 0, 0, '2024-03-12 13:35:46', b'1'),
(20, 10, 'ci:71682810 prov:(Super Mobil) Manuel  Dorado ', 'ok', 1, 2, '2024-03-12 17:32:47', 0, 1, 350, 0, 350, 0, '', 2, 350, 0, 0, 0, '2024-03-12 21:32:56', b'1'),
(21, 0, 'ci:123456 prov:CORRAL   ', '', 1, 7, '2024-03-26 21:38:06', 0, 1, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '2024-03-27 01:38:22', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblcompradetalle`
--

CREATE TABLE `alm_tblcompradetalle` (
  `idcompradetalle` int(11) DEFAULT NULL,
  `idcompra` int(11) DEFAULT NULL,
  `nombrecompradetalle` varchar(512) DEFAULT NULL,
  `idproducto` int(11) DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT NULL,
  `preciounitario` decimal(10,0) DEFAULT NULL,
  `precioventa` decimal(10,0) DEFAULT NULL,
  `subtotal` decimal(10,0) DEFAULT NULL,
  `fechaini` datetime DEFAULT NULL,
  `fechafin` datetime DEFAULT NULL,
  `idestadocompradetalle` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblcompradetalle`
--

INSERT INTO `alm_tblcompradetalle` (`idcompradetalle`, `idcompra`, `nombrecompradetalle`, `idproducto`, `cantidad`, `preciounitario`, `precioventa`, `subtotal`, `fechaini`, `fechafin`, `idestadocompradetalle`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 'Mobil Super Moto 20w50 Mineral', 1, 10, 35, 40, 0, '2024-02-26 09:53:20', '2024-02-26 09:53:20', 0, '2024-02-26 13:53:20', b'1'),
(2, 2, 'MOTO 4T 20W50 1 L', 2, 6, 35, 40, 0, '2024-02-26 09:57:54', '2024-02-26 09:57:54', 0, '2024-02-26 13:57:54', b'1'),
(3, 3, 'Motul 20w50 4 T Amarillo 1 L', 3, 8, 58, 65, 0, '2024-02-26 10:02:35', '2024-02-26 10:02:35', 0, '2024-02-26 14:02:35', b'1'),
(4, 4, 'Tipe A liquido HIdraulico', 4, 12, 14, 20, 0, '2024-02-26 10:13:00', '2024-02-26 10:13:00', 0, '2024-02-26 14:13:00', b'1'),
(5, 6, 'Liquido de Frenos', 5, 24, 15, 20, 0, '2024-02-26 10:16:18', '2024-02-26 10:16:18', 0, '2024-02-26 14:16:18', b'1'),
(6, 5, 'Mobil Super Moto 20w50 Mineral', 1, 1, 35, 40, 0, '2024-02-28 18:54:03', '2024-02-28 18:54:03', 0, '2024-02-28 22:54:03', b'0'),
(7, 7, 'MOTO 4T 20W50 1 L', 3, 1, 35, 0, 0, '2024-03-06 13:46:44', '2024-03-06 13:46:44', 0, '2024-03-06 17:46:44', b'0'),
(7, 7, 'Mobil Super Moto 20w50 Mineral', 1, 1, 35, 40, 0, '2024-03-06 13:48:19', '2024-03-06 13:48:19', 0, '2024-03-06 17:48:19', b'0'),
(7, 7, 'Mobil Super Moto 20w50 Mineral', 1, 2, 35, 80, 0, '2024-03-06 13:54:52', '2024-03-06 13:54:52', 0, '2024-03-06 17:54:53', b'1'),
(8, 8, 'STP', 6, 1, 100, 120, 0, '2024-03-07 12:21:47', '2024-03-07 12:21:47', 0, '2024-03-07 16:21:47', b'1'),
(9, 9, 'STP', 6, 1, 200, 220, 0, '2024-03-07 12:27:52', '2024-03-07 12:27:52', 0, '2024-03-07 16:27:52', b'1'),
(10, 10, 'STP', 6, 10, 100, 120, 0, '2024-03-07 12:39:15', '2024-03-07 12:39:15', 0, '2024-03-07 16:39:15', b'1'),
(11, 11, 'Liquido de Frenos', 5, 1, 15, 18, 0, '2024-03-07 18:37:36', '2024-03-07 18:37:36', 0, '2024-03-07 22:37:37', b'1'),
(12, 11, 'STP', 6, 10, 100, 120, 0, '2024-03-07 18:37:44', '2024-03-07 18:37:44', 0, '2024-03-07 22:37:44', b'1'),
(13, 12, 'Tipe A liquido HIdraulico', 4, 1, 14, 15, 0, '2024-03-07 18:40:10', '2024-03-07 18:40:10', 0, '2024-03-07 22:40:10', b'1'),
(14, 5, 'Mobil Super Moto 20w50 Mineral', 1, 1, 35, 0, 0, '2024-03-07 18:51:13', '2024-03-07 18:51:13', 0, '2024-03-07 22:51:13', b'1'),
(15, 13, 'MOTO 4T 20W50 1 L', 2, 10, 35, 120, 0, '2024-03-09 11:12:53', '2024-03-09 11:12:53', 0, '2024-03-09 15:12:54', b'1'),
(16, 14, 'MOTO 4T 20W50 1 L', 2, 1, 35, 40, 0, '2024-03-11 10:03:13', '2024-03-11 10:03:13', 0, '2024-03-11 14:03:13', b'0'),
(17, 19, 'MOTO 4T 20W50 1 L', 2, 1, 35, 40, 0, '2024-03-12 09:54:27', '2024-03-12 09:54:27', 0, '2024-03-12 13:54:27', b'0'),
(17, 19, 'MOTO 4T 20W50 1 L', 2, 1, 35, 40, 0, '2024-03-12 09:55:03', '2024-03-12 09:55:03', 0, '2024-03-12 13:55:03', b'0'),
(17, 19, 'MOTO 4T 20W50 1 L', 2, 1, 35, 40, 0, '2024-03-12 10:02:28', '2024-03-12 10:02:28', 0, '2024-03-12 14:02:28', b'1'),
(18, 20, 'MOTO 4T 20W50 1 L', 2, 10, 35, 120, 0, '2024-03-12 17:33:11', '2024-03-12 17:33:11', 0, '2024-03-12 21:33:12', b'1'),
(19, 13, 'Motul 20w50 4 T Amarillo 1 L', 3, 1, 58, 0, 0, '2024-03-15 16:56:11', '2024-03-15 16:56:11', 0, '2024-03-15 20:56:11', b'1'),
(20, 21, 'MORRAL GRANDE DE 30CM', 8, 50, 30, 80, 0, '2024-03-26 21:38:42', '2024-03-26 21:38:42', 0, '2024-03-27 01:38:40', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblcotizacion`
--

CREATE TABLE `alm_tblcotizacion` (
  `idcotizacion` int(11) DEFAULT NULL,
  `numerocotizacion` int(11) DEFAULT NULL,
  `nombrecotizacion` varchar(256) DEFAULT NULL,
  `titulo` varchar(256) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `idcliente` int(11) DEFAULT NULL,
  `fechacotizacion` datetime DEFAULT NULL,
  `tipocotizacion` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `subtotal` decimal(10,0) DEFAULT NULL,
  `descuento` decimal(10,0) DEFAULT NULL,
  `total` decimal(10,0) DEFAULT NULL,
  `idmoneda` int(11) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `idestadocotizacion` int(11) DEFAULT NULL,
  `pagado` decimal(10,0) DEFAULT NULL,
  `cambio` decimal(10,0) DEFAULT NULL,
  `idusuarioresponsable` int(11) DEFAULT NULL,
  `idaperturacierrecaja` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblcotizacion`
--

INSERT INTO `alm_tblcotizacion` (`idcotizacion`, `numerocotizacion`, `nombrecotizacion`, `titulo`, `idusuario`, `idcliente`, `fechacotizacion`, `tipocotizacion`, `idoficina`, `subtotal`, `descuento`, `total`, `idmoneda`, `descripcion`, `idestadocotizacion`, `pagado`, `cambio`, `idusuarioresponsable`, `idaperturacierrecaja`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 'ci:-0000 cliente:sin datos ', '', 1, 1, '2024-03-07 12:37:21', 0, 1, 120, 0, 120, 0, '', 2, 0, 0, 0, 0, '2024-03-07 16:37:21', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblcotizaciondetalle`
--

CREATE TABLE `alm_tblcotizaciondetalle` (
  `idcotizaciondetalle` int(11) DEFAULT NULL,
  `idcotizacion` int(11) DEFAULT NULL,
  `nombrecotizaciondetalle` varchar(512) DEFAULT NULL,
  `idproducto` int(11) DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT NULL,
  `preciounitario` decimal(10,0) DEFAULT NULL,
  `precioventa` decimal(10,0) DEFAULT NULL,
  `subtotal` decimal(10,0) DEFAULT NULL,
  `fechaini` datetime DEFAULT NULL,
  `fechafin` datetime DEFAULT NULL,
  `idestadocotizaciondetalle` int(11) DEFAULT NULL,
  `idcompradetalle` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblcotizaciondetalle`
--

INSERT INTO `alm_tblcotizaciondetalle` (`idcotizaciondetalle`, `idcotizacion`, `nombrecotizaciondetalle`, `idproducto`, `cantidad`, `preciounitario`, `precioventa`, `subtotal`, `fechaini`, `fechafin`, `idestadocotizaciondetalle`, `idcompradetalle`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 'STP', 6, 1, 120, 120, 0, '2024-03-07 12:37:27', '2024-03-07 12:37:27', 0, 0, '2024-03-07 16:37:27', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblingresoegreso`
--

CREATE TABLE `alm_tblingresoegreso` (
  `idingresoegreso` int(11) DEFAULT NULL,
  `descripcion` varchar(2000) DEFAULT NULL,
  `fechaingresoegreso` datetime DEFAULT NULL,
  `idplandecuenta` int(11) DEFAULT NULL,
  `monto` decimal(10,0) DEFAULT NULL,
  `idmoneda` int(11) DEFAULT NULL,
  `idtipopago` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `idcierrecaja` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblingresoegreso`
--

INSERT INTO `alm_tblingresoegreso` (`idingresoegreso`, `descripcion`, `fechaingresoegreso`, `idplandecuenta`, `monto`, `idmoneda`, `idtipopago`, `idusuario`, `idoficina`, `idcierrecaja`, `fecharegistro`, `estadoregistro`) VALUES
(1, 'idcompra:1', '2024-02-26 09:53:29', 1, 350, 1, 1, 2, 1, 1, '2024-02-26 13:53:29', b'1'),
(2, 'idcompra:2', '2024-02-26 09:57:59', 1, 210, 1, 1, 2, 1, 1, '2024-02-26 13:57:59', b'1'),
(3, 'idcompra:3', '2024-02-26 10:02:36', 1, 464, 1, 1, 2, 1, 1, '2024-02-26 14:02:36', b'1'),
(4, 'idcompra:4', '2024-02-26 10:13:02', 1, 168, 1, 1, 2, 1, 1, '2024-02-26 14:13:02', b'1'),
(5, 'idcompra:6', '2024-02-26 10:16:20', 1, 360, 1, 1, 2, 1, 1, '2024-02-26 14:16:20', b'1'),
(6, 'idcompra:7', '2024-03-06 13:55:05', 1, 70, 1, 1, 6, 1, 1, '2024-03-06 17:55:05', b'1'),
(7, 'idcompra:8', '2024-03-07 12:21:52', 1, 100, 1, 1, 1, 1, 1, '2024-03-07 16:21:52', b'1'),
(8, 'idcompra:9', '2024-03-07 12:27:55', 1, 200, 1, 1, 1, 1, 1, '2024-03-07 16:27:55', b'1'),
(9, 'idcompra:10', '2024-03-07 12:39:17', 1, 1000, 1, 1, 1, 1, 1, '2024-03-07 16:39:17', b'1'),
(10, 'idventa:2', '2024-03-07 12:41:14', 2, 1, 1, 1, 1, 1, 1, '2024-03-07 16:41:14', b'1'),
(11, 'idventa:3', '2024-03-07 18:47:37', 2, 65, 1, 1, 1, 1, 1, '2024-03-07 22:47:37', b'1'),
(12, 'idventa:5', '2024-03-11 16:47:08', 2, NULL, 1, 1, 7, 1, 1, '2024-03-11 20:47:08', b'1'),
(13, 'idcompra:20', '2024-03-12 17:33:25', 1, 350, 1, 1, 1, 1, 1, '2024-03-12 21:33:25', b'1'),
(14, 'idcompra:11', '2024-03-12 17:39:12', 1, 200, 1, 1, 0, 1, 1, '2024-03-12 21:39:12', b'1'),
(15, 'idcompra:11', '2024-03-12 17:40:35', 1, 815, 1, 1, 0, 1, 1, '2024-03-12 21:40:35', b'1'),
(16, 'idcompra:5', '2024-03-15 19:44:20', 1, 35, 1, 1, 0, 1, 1, '2024-03-15 23:44:20', b'1'),
(17, 'idcompra:12', '2024-03-15 19:50:54', 1, 14, 1, 1, 0, 1, 1, '2024-03-15 23:50:54', b'1'),
(18, 'idcompra:13', '2024-03-16 08:24:29', 1, 408, 1, 1, 0, 1, 1, '2024-03-16 12:24:29', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblmarca`
--

CREATE TABLE `alm_tblmarca` (
  `idmarca` int(11) DEFAULT NULL,
  `nombremarca` varchar(50) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblmarca`
--

INSERT INTO `alm_tblmarca` (`idmarca`, `nombremarca`, `fecharegistro`, `estadoregistro`) VALUES
(1, ' ', '2024-02-18 16:47:44', b'1'),
(2, 'Motul ', '2024-02-26 13:42:03', b'1'),
(3, 'YPFB Nacional', '2024-02-26 13:42:18', b'1'),
(4, 'QUALITY TIPE A', '2024-02-26 13:42:40', b'1'),
(5, 'Quality Optimus', '2024-02-26 14:13:51', b'1'),
(6, 'Wagner', '2024-02-26 14:17:33', b'1'),
(7, 'Vistony', '2024-02-26 14:17:48', b'1'),
(8, 'Lubristone', '2024-02-26 14:19:01', b'1'),
(9, 'MC 2', '2024-02-26 14:19:14', b'1'),
(10, 'STP', '2024-02-26 14:20:19', b'1'),
(11, 'Castrol', '2024-03-04 15:24:46', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblpagocompra`
--

CREATE TABLE `alm_tblpagocompra` (
  `idpagocompra` int(11) DEFAULT NULL,
  `idcompra` int(11) DEFAULT NULL,
  `idingresoegreso` int(11) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `descripcion` varchar(2000) DEFAULT NULL,
  `monto` decimal(10,0) DEFAULT NULL,
  `idtipopago` int(11) DEFAULT NULL,
  `idcotizacionmoneda` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblpagocompra`
--

INSERT INTO `alm_tblpagocompra` (`idpagocompra`, `idcompra`, `idingresoegreso`, `fecha`, `descripcion`, `monto`, `idtipopago`, `idcotizacionmoneda`, `idusuario`, `idoficina`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 1, '2024-02-26 09:53:29', 'idcompra:1', 350, 1, 1, 2, 1, '2024-02-26 13:53:29', b'1'),
(2, 2, 2, '2024-02-26 09:57:59', 'idcompra:2', 210, 1, 1, 2, 1, '2024-02-26 13:57:59', b'1'),
(3, 3, 3, '2024-02-26 10:02:36', 'idcompra:3', 464, 1, 1, 2, 1, '2024-02-26 14:02:36', b'1'),
(4, 4, 4, '2024-02-26 10:13:02', 'idcompra:4', 168, 1, 1, 2, 1, '2024-02-26 14:13:02', b'1'),
(5, 6, 5, '2024-02-26 10:16:20', 'idcompra:6', 360, 1, 1, 2, 1, '2024-02-26 14:16:20', b'1'),
(6, 7, 6, '2024-03-06 13:55:05', 'idcompra:7', 70, 1, 1, 6, 1, '2024-03-06 17:55:05', b'1'),
(7, 8, 7, '2024-03-07 12:21:52', 'idcompra:8', 100, 1, 1, 1, 1, '2024-03-07 16:21:52', b'1'),
(8, 9, 8, '2024-03-07 12:27:55', 'idcompra:9', 200, 1, 1, 1, 1, '2024-03-07 16:27:55', b'1'),
(9, 10, 9, '2024-03-07 12:39:17', 'idcompra:10', 1000, 1, 1, 1, 1, '2024-03-07 16:39:17', b'1'),
(10, 20, 13, '2024-03-12 17:33:25', 'idcompra:20', 350, 1, 1, 1, 1, '2024-03-12 21:33:25', b'1'),
(11, 11, 14, '2024-03-12 17:39:12', 'anticipo 1', 200, 1, 1, 0, 1, '2024-03-12 21:39:12', b'1'),
(12, 11, 15, '2024-03-12 17:40:35', 'final', 815, 1, 1, 0, 1, '2024-03-12 21:40:35', b'1'),
(13, 5, 16, '2024-03-15 19:44:20', 'artículos', 35, 1, 1, 0, 1, '2024-03-15 23:44:20', b'1'),
(14, 12, 17, '2024-03-15 19:50:54', 'pagos', 14, 1, 1, 0, 1, '2024-03-15 23:50:54', b'1'),
(15, 13, 18, '2024-03-16 08:24:29', 'pago total de la compra', 408, 1, 1, 0, 1, '2024-03-16 12:24:29', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblpagoventa`
--

CREATE TABLE `alm_tblpagoventa` (
  `idpagoventa` int(11) DEFAULT NULL,
  `idventa` int(11) DEFAULT NULL,
  `idingresoegreso` int(11) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `descripcion` varchar(2000) DEFAULT NULL,
  `monto` decimal(10,0) DEFAULT NULL,
  `idtipopago` int(11) DEFAULT NULL,
  `idcotizacionmoneda` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblpagoventa`
--

INSERT INTO `alm_tblpagoventa` (`idpagoventa`, `idventa`, `idingresoegreso`, `fecha`, `descripcion`, `monto`, `idtipopago`, `idcotizacionmoneda`, `idusuario`, `idoficina`, `fecharegistro`, `estadoregistro`) VALUES
(1, 2, 10, '2024-03-07 12:41:14', 'idventa:2', 1, 1, 1, 1, 1, '2024-03-07 16:41:14', b'1'),
(2, 3, 11, '2024-03-07 18:47:37', 'idventa:3', 65, 1, 1, 1, 1, '2024-03-07 22:47:37', b'1'),
(3, 5, 12, '2024-03-11 16:47:08', 'idventa:5', NULL, 1, 1, 7, 1, '2024-03-11 20:47:08', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblplandecuenta`
--

CREATE TABLE `alm_tblplandecuenta` (
  `idplandecuenta` int(11) DEFAULT NULL,
  `descripcion` varchar(512) DEFAULT NULL,
  `idplandecuentapadre` int(11) DEFAULT NULL,
  `primario` int(11) DEFAULT NULL,
  `idtipoplandecuenta` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblplandecuenta`
--

INSERT INTO `alm_tblplandecuenta` (`idplandecuenta`, `descripcion`, `idplandecuentapadre`, `primario`, `idtipoplandecuenta`, `fecharegistro`, `estadoregistro`) VALUES
(1, 'COMPRA', 0, 1, 2, '2024-02-19 01:40:51', b'1'),
(2, 'VENTA', 0, 1, 1, '2024-02-19 01:48:13', b'1'),
(3, 'INGRESOS', 0, 1, 1, '2024-02-25 12:02:56', b'1'),
(4, 'EGRESOS', 0, 1, 2, '2024-02-25 12:03:18', b'1'),
(5, 'PAGO DE LUZ', 0, 0, 2, '2024-02-25 16:08:51', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblproducto`
--

CREATE TABLE `alm_tblproducto` (
  `idproducto` int(11) DEFAULT NULL,
  `nombreproducto` char(150) DEFAULT NULL,
  `idclasificacionproducto` int(11) DEFAULT NULL,
  `referencia` int(11) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL,
  `talla` int(11) DEFAULT NULL,
  `idmarca` int(11) DEFAULT NULL,
  `codigobarra1` char(30) DEFAULT NULL,
  `codigobarra2` char(30) DEFAULT NULL,
  `idtipounidad` int(11) DEFAULT NULL,
  `tipoproducto` char(30) DEFAULT NULL,
  `ventacongarantia` bit(1) DEFAULT NULL,
  `connumeroserie` bit(1) DEFAULT NULL,
  `conrfid` bit(1) DEFAULT NULL,
  `diasvalides` int(11) DEFAULT NULL,
  `montocompra` decimal(10,0) DEFAULT NULL,
  `montoventa` decimal(10,0) DEFAULT NULL,
  `modelo` char(20) DEFAULT NULL,
  `idusuarioactualiza` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblproducto`
--

INSERT INTO `alm_tblproducto` (`idproducto`, `nombreproducto`, `idclasificacionproducto`, `referencia`, `descripcion`, `color`, `talla`, `idmarca`, `codigobarra1`, `codigobarra2`, `idtipounidad`, `tipoproducto`, `ventacongarantia`, `connumeroserie`, `conrfid`, `diasvalides`, `montocompra`, `montoventa`, `modelo`, `idusuarioactualiza`, `fecharegistro`, `estadoregistro`) VALUES
(1, 'Mobil Super Moto 20w50 Mineral', 1, 0, '', '', 0, 1, '7896636550803', '', 0, '', b'1', b'1', b'1', 0, 35, 40, '', 2, '2024-02-26 13:45:30', b'1'),
(2, 'MOTO 4T 20W50 1 L', 1, 0, '', '', 0, 1, 'YPFB-01', '', 0, '', b'1', b'1', b'1', 0, 35, 40, '', 2, '2024-02-26 13:57:25', b'1'),
(3, 'Motul 20w50 4 T Amarillo 1 L', 1, 0, '', '', 0, 1, '3374650303123', '', 0, '', b'1', b'1', b'1', 0, 58, 65, '', 2, '2024-02-26 13:59:54', b'1'),
(4, 'Tipe A liquido HIdraulico', 1, 0, '', '', 0, 1, '7503007918130', '', 0, '', b'1', b'1', b'1', 0, 14, 20, '', 2, '2024-02-26 14:12:23', b'1'),
(5, 'Liquido de Frenos', 1, 0, '', '', 0, 1, '7501799117113', '', 0, '', b'1', b'1', b'1', 0, 15, 20, '', 2, '2024-02-26 14:15:38', b'1'),
(6, 'STP', 1, 0, '', '', 0, 1, 'STP', '', 0, '', b'1', b'1', b'1', 0, 0, 120, '', 2, '2024-03-07 16:21:34', b'1'),
(7, 'lucas', 2, 0, '', '', 0, 1, '1', '', 0, '', b'1', b'1', b'1', 0, 35, 26, '', 2, '2024-03-15 23:37:11', b'1'),
(8, 'MORRAL GRANDE DE 30CM', 1, 0, '', '', 0, 1, '123', '', 0, '', b'1', b'1', b'1', 0, 30, 80, '', 1, '2024-03-27 01:37:20', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblproductostock`
--

CREATE TABLE `alm_tblproductostock` (
  `idproductostock` int(11) DEFAULT NULL,
  `idproducto` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT NULL,
  `cantidadminima` decimal(10,0) DEFAULT NULL,
  `cantidadmaxima` decimal(10,0) DEFAULT NULL,
  `preciocompra` decimal(10,0) DEFAULT NULL,
  `precioventa` decimal(10,0) DEFAULT NULL,
  `idusuarioregistra` int(11) DEFAULT NULL,
  `idcompradetalle` int(11) DEFAULT NULL,
  `idcompradetalledato` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblproductostock`
--

INSERT INTO `alm_tblproductostock` (`idproductostock`, `idproducto`, `idoficina`, `cantidad`, `cantidadminima`, `cantidadmaxima`, `preciocompra`, `precioventa`, `idusuarioregistra`, `idcompradetalle`, `idcompradetalledato`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 1, 10, 0, 10, 35, 40, 2, 1, 1, '2024-02-26 13:53:29', b'1'),
(2, 2, 1, 6, 0, 6, 35, 40, 2, 2, 1, '2024-02-26 13:57:59', b'1'),
(3, 3, 1, 7, 0, 8, 58, 65, 2, 3, 1, '2024-02-26 14:02:36', b'1'),
(4, 4, 1, 11, 0, 12, 14, 20, 2, 4, 1, '2024-02-26 14:13:02', b'1'),
(5, 5, 1, 24, 0, 24, 15, 20, 2, 5, 1, '2024-02-26 14:16:20', b'1'),
(6, 1, 1, 2, 0, 2, 35, 80, 6, 7, 1, '2024-03-06 17:55:05', b'1'),
(7, 6, 1, 1, 0, 1, 100, 120, 1, 8, 1, '2024-03-07 16:21:52', b'1'),
(8, 6, 1, 1, 0, 1, 200, 220, 1, 9, 1, '2024-03-07 16:27:55', b'1'),
(9, 6, 1, 9, 0, 10, 100, 120, 1, 10, 1, '2024-03-07 16:39:17', b'1'),
(10, 5, 1, 1, 0, 1, 15, 18, 1, 11, 1, '2024-03-07 22:37:47', b'1'),
(11, 6, 1, 10, 0, 10, 100, 120, 1, 12, 1, '2024-03-07 22:37:47', b'1'),
(12, 2, 1, 1, 0, 1, 35, 40, 6, 17, 1, '2024-03-12 14:32:25', b'1'),
(13, 2, 1, 10, 0, 10, 35, 120, 1, 18, 1, '2024-03-12 21:33:25', b'1'),
(14, 1, 1, 1, 0, 1, 35, 0, 6, 14, 1, '2024-03-15 20:21:39', b'1'),
(15, 4, 1, 1, 0, 1, 14, 15, 6, 13, 1, '2024-03-15 20:36:12', b'1'),
(16, 2, 1, 10, 0, 10, 35, 120, 6, 15, 1, '2024-03-15 20:56:46', b'1'),
(17, 3, 1, 1, 0, 1, 58, 0, 6, 19, 1, '2024-03-15 20:56:46', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblventa`
--

CREATE TABLE `alm_tblventa` (
  `idventa` int(11) DEFAULT NULL,
  `numeroventa` int(11) DEFAULT NULL,
  `nombreventa` varchar(256) DEFAULT NULL,
  `titulo` varchar(256) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `idcliente` int(11) DEFAULT NULL,
  `fechaventa` datetime DEFAULT NULL,
  `tipoventa` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `subtotal` decimal(10,0) DEFAULT NULL,
  `descuento` decimal(10,0) DEFAULT NULL,
  `total` decimal(10,0) DEFAULT NULL,
  `idmoneda` int(11) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `idestadoventa` int(11) DEFAULT NULL,
  `pagado` decimal(10,0) DEFAULT NULL,
  `cambio` decimal(10,0) DEFAULT NULL,
  `idusuarioresponsable` int(11) DEFAULT NULL,
  `idaperturacierrecaja` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblventa`
--

INSERT INTO `alm_tblventa` (`idventa`, `numeroventa`, `nombreventa`, `titulo`, `idusuario`, `idcliente`, `fechaventa`, `tipoventa`, `idoficina`, `subtotal`, `descuento`, `total`, `idmoneda`, `descripcion`, `idestadoventa`, `pagado`, `cambio`, `idusuarioresponsable`, `idaperturacierrecaja`, `fecharegistro`, `estadoregistro`) VALUES
(1, 0, 'ci:0000 cli:sin datos ', '', 1, 1, '2024-03-07 12:28:41', 0, 1, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '2024-03-07 16:28:44', b'1'),
(2, 1, 'ci:0000 cli:sin datos ', 'ok', 1, 1, '2024-03-07 12:39:22', 0, 1, 1, 0, 1, 0, '', 2, 1, 0, 0, 0, '2024-03-07 16:39:23', b'1'),
(3, 2, 'ci:0000 cli:sin datos ', 'ok', 1, 1, '2024-03-07 18:46:46', 0, 1, 65, 0, 65, 0, '', 2, 65, 0, 0, 0, '2024-03-07 22:46:49', b'1'),
(4, 0, 'ci:0000 cli:sin datos ', '', 7, 1, '2024-03-11 16:43:27', 0, 1, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '2024-03-11 20:43:32', b'1'),
(5, 3, 'ci:0000 cli:sin datos ', 'ok', 7, 1, '2024-03-11 16:46:30', 0, 1, NULL, 0, NULL, 0, '', 2, NULL, 0, 0, 0, '2024-03-11 20:46:39', b'1'),
(6, 0, 'ci:0000 cli:sin datos ', '', 6, 1, '2024-03-15 17:54:54', 0, 1, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '2024-03-15 21:54:59', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alm_tblventadetalle`
--

CREATE TABLE `alm_tblventadetalle` (
  `idventadetalle` int(11) DEFAULT NULL,
  `idventa` int(11) DEFAULT NULL,
  `nombreventadetalle` varchar(512) DEFAULT NULL,
  `idproducto` int(11) DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT NULL,
  `preciounitario` decimal(10,0) DEFAULT NULL,
  `subtotal` decimal(10,0) DEFAULT NULL,
  `fechaini` datetime DEFAULT NULL,
  `fechafin` datetime DEFAULT NULL,
  `idestadoventadetalle` int(11) DEFAULT NULL,
  `idcompradetalle` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alm_tblventadetalle`
--

INSERT INTO `alm_tblventadetalle` (`idventadetalle`, `idventa`, `nombreventadetalle`, `idproducto`, `cantidad`, `preciounitario`, `subtotal`, `fechaini`, `fechafin`, `idestadoventadetalle`, `idcompradetalle`, `fecharegistro`, `estadoregistro`) VALUES
(1, 2, 'STP', 6, 1, 1, 0, '2024-03-07 12:41:08', '2024-03-07 12:41:08', 1, 10, '2024-03-07 16:41:08', b'1'),
(2, 3, 'Motul 20w50 4 T Amarillo 1 L', 3, 1, 65, 0, '2024-03-07 18:47:25', '2024-03-07 18:47:25', 1, 3, '2024-03-07 22:47:25', b'1');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_viscierrecaja`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_viscierrecaja` (
`idcierrecaja` int(11)
,`idoficina` int(11)
,`idusuario` int(11)
,`montoinicio` decimal(10,0)
,`montofinal` decimal(10,0)
,`idusuariocierre` int(11)
,`idestadocierrecaja` smallint(6)
,`fechainicio` datetime
,`fechafinal` datetime
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_visclasificacionproducto`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_visclasificacionproducto` (
`idclasificacionproducto` int(11)
,`nombreclasificacionproducto` varchar(50)
,`descripcion` varchar(250)
,`idclasificacionproductopadre` int(11)
,`primario` int(11)
,`idtipoclasificacionproducto` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_viscompra`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_viscompra` (
`idcompra` int(11)
,`numerocompra` int(11)
,`nombrecompra` varchar(256)
,`titulo` varchar(256)
,`idusuario` int(11)
,`idproveedor` int(11)
,`fechacompra` datetime
,`tipocompra` int(11)
,`idoficina` int(11)
,`subtotal` decimal(10,0)
,`descuento` decimal(10,0)
,`total` decimal(10,0)
,`idmoneda` int(11)
,`descripcion` varchar(512)
,`idestadocompra` int(11)
,`pagado` decimal(10,0)
,`cambio` decimal(10,0)
,`idusuarioresponsable` int(11)
,`idaperturacierrecaja` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
,`nombreestadocompra` varchar(2024)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_viscompradetalle`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_viscompradetalle` (
`idcompradetalle` int(11)
,`idcompra` int(11)
,`nombrecompradetalle` varchar(512)
,`idproducto` int(11)
,`cantidad` decimal(10,0)
,`preciounitario` decimal(10,0)
,`precioventa` decimal(10,0)
,`subtotal` decimal(10,0)
,`fechaini` datetime
,`fechafin` datetime
,`idestadocompradetalle` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_viscotizacion`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_viscotizacion` (
`idcotizacion` int(11)
,`numerocotizacion` int(11)
,`nombrecotizacion` varchar(256)
,`titulo` varchar(256)
,`idusuario` int(11)
,`idcliente` int(11)
,`fechacotizacion` datetime
,`tipocotizacion` int(11)
,`idoficina` int(11)
,`subtotal` decimal(10,0)
,`descuento` decimal(10,0)
,`total` decimal(10,0)
,`idmoneda` int(11)
,`descripcion` varchar(250)
,`idestadocotizacion` int(11)
,`pagado` decimal(10,0)
,`cambio` decimal(10,0)
,`idusuarioresponsable` int(11)
,`idaperturacierrecaja` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_viscotizaciondetalle`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_viscotizaciondetalle` (
`idcotizaciondetalle` int(11)
,`idcotizacion` int(11)
,`nombrecotizaciondetalle` varchar(512)
,`idproducto` int(11)
,`cantidad` decimal(10,0)
,`preciounitario` decimal(10,0)
,`precioventa` decimal(10,0)
,`subtotal` decimal(10,0)
,`fechaini` datetime
,`fechafin` datetime
,`idestadocotizaciondetalle` int(11)
,`idcompradetalle` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_visingresoegreso`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_visingresoegreso` (
`idingresoegreso` int(11)
,`descripcion` varchar(2000)
,`fechaingresoegreso` datetime
,`idplandecuenta` int(11)
,`monto` decimal(10,0)
,`idmoneda` int(11)
,`idtipopago` int(11)
,`idusuario` int(11)
,`idoficina` int(11)
,`idcierrecaja` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_vismarca`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_vismarca` (
`idmarca` int(11)
,`nombremarca` varchar(50)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_vispagocompra`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_vispagocompra` (
`idpagocompra` int(11)
,`idcompra` int(11)
,`idingresoegreso` int(11)
,`fecha` datetime
,`descripcion` varchar(2000)
,`monto` decimal(10,0)
,`idtipopago` int(11)
,`idcotizacionmoneda` int(11)
,`idusuario` int(11)
,`idoficina` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_vispagoventa`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_vispagoventa` (
`idpagoventa` int(11)
,`idventa` int(11)
,`idingresoegreso` int(11)
,`fecha` datetime
,`descripcion` varchar(2000)
,`monto` decimal(10,0)
,`idtipopago` int(11)
,`idcotizacionmoneda` int(11)
,`idusuario` int(11)
,`idoficina` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_visplandecuenta`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_visplandecuenta` (
`idplandecuenta` int(11)
,`descripcion` varchar(512)
,`idplandecuentapadre` int(11)
,`primario` int(11)
,`idtipoplandecuenta` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_visproducto`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_visproducto` (
`idproducto` int(11)
,`nombreproducto` char(150)
,`idclasificacionproducto` int(11)
,`referencia` int(11)
,`descripcion` varchar(250)
,`color` varchar(20)
,`talla` int(11)
,`idmarca` int(11)
,`codigobarra1` char(30)
,`codigobarra2` char(30)
,`idtipounidad` int(11)
,`tipoproducto` char(30)
,`ventacongarantia` bit(1)
,`connumeroserie` bit(1)
,`conrfid` bit(1)
,`diasvalides` int(11)
,`montocompra` decimal(10,0)
,`montoventa` decimal(10,0)
,`modelo` char(20)
,`idusuarioactualiza` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_visproductostock`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_visproductostock` (
`idproductostock` int(11)
,`idproducto` int(11)
,`idoficina` int(11)
,`cantidad` decimal(10,0)
,`cantidadminima` decimal(10,0)
,`cantidadmaxima` decimal(10,0)
,`preciocompra` decimal(10,0)
,`precioventa` decimal(10,0)
,`idusuarioregistra` int(11)
,`idcompradetalle` int(11)
,`idcompradetalledato` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
,`codigobarra1` char(30)
,`nombreproducto` char(150)
,`montocompra` decimal(10,0)
,`montoventa` decimal(10,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_visventa`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_visventa` (
`idventa` int(11)
,`numeroventa` int(11)
,`nombreventa` varchar(256)
,`titulo` varchar(256)
,`idusuario` int(11)
,`idcliente` int(11)
,`fechaventa` datetime
,`tipoventa` int(11)
,`idoficina` int(11)
,`subtotal` decimal(10,0)
,`descuento` decimal(10,0)
,`total` decimal(10,0)
,`idmoneda` int(11)
,`descripcion` varchar(250)
,`idestadoventa` int(11)
,`pagado` decimal(10,0)
,`cambio` decimal(10,0)
,`idusuarioresponsable` int(11)
,`idaperturacierrecaja` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
,`nombreestadoventa` varchar(2024)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `alm_visventadetalle`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `alm_visventadetalle` (
`idventadetalle` int(11)
,`idventa` int(11)
,`nombreventadetalle` varchar(512)
,`idproducto` int(11)
,`cantidad` decimal(10,0)
,`preciounitario` decimal(10,0)
,`subtotal` decimal(10,0)
,`fechaini` datetime
,`fechafin` datetime
,`idestadoventadetalle` int(11)
,`idcompradetalle` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cli_tblconsultorio`
--

CREATE TABLE `cli_tblconsultorio` (
  `idconsultorio` int(11) DEFAULT NULL,
  `nombreconsultorio` varchar(50) DEFAULT NULL,
  `numeroconsultorio` int(11) DEFAULT NULL,
  `detalle` varchar(50) DEFAULT NULL,
  `horainiciorefrigerio` datetime DEFAULT NULL,
  `horafinrefrigerio` datetime DEFAULT NULL,
  `fecharegistro` date DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cli_tblespecialidad`
--

CREATE TABLE `cli_tblespecialidad` (
  `idespecialidad` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `nombreespecialidad` varchar(512) DEFAULT NULL,
  `titulo` varchar(512) DEFAULT NULL,
  `detalle` varchar(512) DEFAULT NULL,
  `pieespecialidad` varchar(1024) DEFAULT NULL,
  `orden` int(11) DEFAULT NULL,
  `agendarcita` bit(1) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cli_tblespecialidadmedico`
--

CREATE TABLE `cli_tblespecialidadmedico` (
  `idespecialidadmedico` int(11) DEFAULT NULL,
  `idmedico` int(11) DEFAULT NULL,
  `idespecialidad` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cli_tblmedico`
--

CREATE TABLE `cli_tblmedico` (
  `idmedico` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `matricula` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cli_tblreserva`
--

CREATE TABLE `cli_tblreserva` (
  `idreserva` int(11) NOT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `idespecialidad` int(11) DEFAULT NULL,
  `fechareserva` date DEFAULT NULL,
  `horainicio` datetime DEFAULT NULL,
  `horafin` datetime DEFAULT NULL,
  `fechaevento` datetime DEFAULT NULL,
  `idestadoreserva` int(11) DEFAULT NULL,
  `fechacancelacion` datetime DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `observaciones` varchar(50) DEFAULT NULL,
  `carnetidentidad` char(12) DEFAULT NULL,
  `idtipodocumento` int(11) DEFAULT NULL,
  `nombre` varchar(64) DEFAULT NULL,
  `paterno` varchar(64) DEFAULT NULL,
  `materno` varchar(64) DEFAULT NULL,
  `celular` char(8) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `idconsultorio` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `cli_visconsultorio`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `cli_visconsultorio` (
`idconsultorio` int(11)
,`nombreconsultorio` varchar(50)
,`numeroconsultorio` int(11)
,`detalle` varchar(50)
,`horainiciorefrigerio` datetime
,`horafinrefrigerio` datetime
,`fecharegistro` date
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `cli_visespecialidad`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `cli_visespecialidad` (
`idespecialidad` int(11)
,`idoficina` int(11)
,`nombreespecialidad` varchar(512)
,`titulo` varchar(512)
,`detalle` varchar(512)
,`pieespecialidad` varchar(1024)
,`orden` int(11)
,`agendarcita` bit(1)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `cli_visespecialidadmedico`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `cli_visespecialidadmedico` (
`idespecialidadmedico` int(11)
,`idmedico` int(11)
,`idespecialidad` int(11)
,`idusuario` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `cli_vismedico`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `cli_vismedico` (
`idmedico` int(11)
,`idusuario` int(11)
,`matricula` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `cli_visreserva`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `cli_visreserva` (
`idreserva` int(11)
,`idoficina` int(11)
,`idespecialidad` int(11)
,`fechareserva` date
,`horainicio` datetime
,`horafin` datetime
,`fechaevento` datetime
,`idestadoreserva` int(11)
,`fechacancelacion` datetime
,`idusuario` int(11)
,`observaciones` varchar(50)
,`carnetidentidad` char(12)
,`idtipodocumento` int(11)
,`nombre` varchar(64)
,`paterno` varchar(64)
,`materno` varchar(64)
,`celular` char(8)
,`email` varchar(64)
,`idconsultorio` int(11)
,`fecharegistro` datetime
,`estadoregistro` int(11)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `per_tblasistencia`
--

CREATE TABLE `per_tblasistencia` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `fechahora` datetime NOT NULL,
  `estado` varchar(50) NOT NULL,
  `verificacion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `per_tblasistencia`
--

INSERT INTO `per_tblasistencia` (`id`, `userid`, `fechahora`, `estado`, `verificacion`) VALUES
(609, 52, '2024-06-18 06:30:35', '1', '1'),
(610, 11344768, '2024-06-18 07:00:56', '1', '1'),
(611, 11344768, '2024-06-18 07:00:57', '1', '1'),
(612, 11344768, '2024-06-18 07:01:01', '1', '1'),
(613, 11344768, '2024-06-18 07:01:05', '1', '1'),
(614, 21, '2024-06-18 07:02:57', '1', '1'),
(615, 21, '2024-06-18 07:03:01', '1', '1'),
(616, 78, '2024-06-18 07:05:15', '1', '1'),
(617, 37, '2024-06-18 07:28:16', '1', '1'),
(618, 75, '2024-06-18 07:33:08', '1', '1'),
(619, 75, '2024-06-18 07:33:11', '1', '1'),
(620, 77, '2024-06-18 07:37:09', '1', '1'),
(621, 5, '2024-06-18 07:43:56', '1', '1'),
(622, 5, '2024-06-18 07:44:01', '1', '1'),
(623, 3, '2024-06-18 07:44:23', '1', '1'),
(624, 3, '2024-06-18 07:44:27', '1', '1'),
(625, 3, '2024-06-18 07:44:33', '1', '1'),
(626, 3296579, '2024-06-18 07:45:05', '1', '1'),
(627, 34, '2024-06-18 07:47:46', '1', '1'),
(628, 34, '2024-06-18 07:47:51', '1', '1'),
(629, 34, '2024-06-18 07:47:56', '1', '1'),
(630, 34, '2024-06-18 07:47:57', '1', '1'),
(631, 123, '2024-06-18 07:49:05', '1', '1'),
(632, 123, '2024-06-18 07:49:13', '1', '1'),
(633, 123, '2024-06-18 07:49:17', '1', '1'),
(634, 7090472, '2024-06-18 07:57:06', '1', '1'),
(635, 53, '2024-06-18 07:57:15', '1', '1'),
(636, 53, '2024-06-18 07:57:19', '1', '1'),
(637, 8992299, '2024-06-18 07:59:05', '1', '1'),
(638, 20, '2024-06-18 08:00:37', '1', '1'),
(639, 54, '2024-06-18 08:00:42', '1', '1'),
(640, 13079868, '2024-06-18 08:00:52', '1', '1'),
(641, 13079868, '2024-06-18 08:00:55', '1', '1'),
(642, 10, '2024-06-18 08:01:59', '1', '1'),
(643, 8969452, '2024-06-18 08:10:03', '1', '1'),
(644, 8969452, '2024-06-18 08:10:07', '1', '1'),
(645, 2708782, '2024-06-18 08:11:07', '1', '1'),
(646, 2708782, '2024-06-18 08:11:10', '1', '1'),
(647, 8929159, '2024-06-18 08:12:37', '1', '1'),
(648, 8929159, '2024-06-18 08:12:41', '1', '1'),
(649, 74, '2024-06-18 08:12:57', '1', '1'),
(650, 74, '2024-06-18 08:13:00', '1', '1'),
(651, 8913882, '2024-06-18 08:14:14', '1', '1'),
(652, 8913882, '2024-06-18 08:14:18', '1', '1'),
(653, 3923030, '2024-06-18 08:14:29', '1', '1'),
(654, 1, '2024-06-18 08:14:51', '1', '1'),
(655, 1, '2024-06-18 08:14:55', '1', '1'),
(656, 6337583, '2024-06-18 08:15:30', '1', '1'),
(657, 6337583, '2024-06-18 08:15:34', '1', '1'),
(658, 9837586, '2024-06-18 08:15:40', '1', '1'),
(659, 12475463, '2024-06-18 08:16:04', '1', '1'),
(660, 5403347, '2024-06-18 08:17:01', '1', '1'),
(661, 9272440, '2024-06-18 08:18:48', '1', '1'),
(662, 5379139, '2024-06-18 08:19:05', '1', '1'),
(663, 5379139, '2024-06-18 08:19:09', '1', '1'),
(664, 13, '2024-06-18 08:19:33', '1', '1'),
(665, 18, '2024-06-18 08:19:39', '1', '1'),
(666, 5347651, '2024-06-18 08:20:44', '1', '1'),
(667, 5347651, '2024-06-18 08:20:49', '1', '1'),
(668, 11342745, '2024-06-18 08:20:54', '1', '1'),
(669, 8160107, '2024-06-18 08:21:45', '1', '1'),
(670, 5859364, '2024-06-18 08:24:10', '1', '1'),
(671, 5859364, '2024-06-18 08:24:16', '1', '1'),
(672, 5859364, '2024-06-18 08:24:22', '1', '1'),
(673, 5859364, '2024-06-18 08:24:27', '1', '1'),
(674, 40, '2024-06-18 08:25:22', '1', '1'),
(675, 5049082, '2024-06-18 08:26:51', '1', '1'),
(676, 5895212, '2024-06-18 08:27:31', '1', '1'),
(677, 6282278, '2024-06-18 08:28:04', '1', '1'),
(678, 6282278, '2024-06-18 08:28:07', '1', '1'),
(679, 5862586, '2024-06-18 08:29:09', '1', '1'),
(680, 5862586, '2024-06-18 08:29:18', '1', '1'),
(681, 5828008, '2024-06-18 08:29:24', '1', '1'),
(682, 4295735, '2024-06-18 08:29:31', '1', '1'),
(683, 62, '2024-06-18 08:29:37', '1', '1'),
(684, 62, '2024-06-18 08:29:40', '1', '1'),
(685, 5828795, '2024-06-18 08:29:48', '1', '1'),
(686, 11303105, '2024-06-18 08:30:04', '1', '1'),
(687, 1734878, '2024-06-18 08:30:50', '1', '1'),
(688, 1734878, '2024-06-18 08:30:54', '1', '1'),
(689, 5555563, '2024-06-18 08:30:59', '1', '1'),
(690, 73, '2024-06-18 08:31:07', '1', '1'),
(691, 789, '2024-06-18 08:31:21', '1', '1'),
(692, 19, '2024-06-18 08:31:58', '1', '1'),
(693, 43, '2024-06-18 08:32:05', '1', '1'),
(694, 43, '2024-06-18 08:32:09', '1', '1'),
(695, 3927161, '2024-06-18 08:33:25', '1', '1'),
(696, 3927161, '2024-06-18 08:33:29', '1', '1'),
(697, 6339596, '2024-06-18 08:34:38', '1', '1'),
(698, 6339596, '2024-06-18 08:34:44', '1', '1'),
(699, 6379417, '2024-06-18 08:35:20', '1', '1'),
(700, 6379417, '2024-06-18 08:35:25', '1', '1'),
(701, 41, '2024-06-18 08:40:38', '1', '1'),
(702, 6236864, '2024-06-18 08:42:21', '1', '1'),
(703, 11, '2024-06-18 09:33:17', '1', '1'),
(704, 11, '2024-06-18 09:33:21', '1', '1'),
(705, 11342745, '2024-06-18 12:00:36', '1', '1'),
(706, 75, '2024-06-18 12:01:31', '1', '1'),
(707, 75, '2024-06-18 12:01:36', '1', '1'),
(708, 34, '2024-06-18 12:01:41', '1', '1'),
(709, 5862586, '2024-06-18 12:02:15', '1', '1'),
(710, 123, '2024-06-18 12:02:49', '1', '1'),
(711, 123, '2024-06-18 12:02:57', '1', '1'),
(712, 123, '2024-06-18 12:03:02', '1', '1'),
(713, 3927161, '2024-06-18 12:03:16', '1', '1'),
(714, 8160107, '2024-06-18 12:03:24', '1', '1'),
(715, 3927161, '2024-06-18 12:03:39', '1', '1'),
(716, 74, '2024-06-18 12:03:44', '1', '1'),
(717, 3, '2024-06-18 12:03:49', '1', '1'),
(718, 3, '2024-06-18 12:03:53', '1', '1'),
(719, 3, '2024-06-18 12:03:56', '1', '1'),
(720, 20, '2024-06-18 12:04:11', '1', '1'),
(721, 20, '2024-06-18 12:04:15', '1', '1'),
(722, 37, '2024-06-18 12:04:22', '1', '1'),
(723, 37, '2024-06-18 12:04:26', '1', '1'),
(724, 6337583, '2024-06-18 12:04:33', '1', '1'),
(725, 789, '2024-06-18 12:04:46', '1', '1'),
(726, 789, '2024-06-18 12:04:50', '1', '1'),
(727, 3927161, '2024-06-18 12:06:06', '1', '1'),
(728, 52, '2024-06-18 12:06:43', '1', '1'),
(729, 54, '2024-06-18 12:06:58', '1', '1'),
(730, 13, '2024-06-18 12:07:36', '1', '1'),
(731, 13, '2024-06-18 12:07:40', '1', '1'),
(732, 10, '2024-06-18 12:07:45', '1', '1'),
(733, 10, '2024-06-18 12:07:54', '1', '1'),
(734, 5828795, '2024-06-18 12:08:20', '1', '1'),
(735, 5828795, '2024-06-18 12:08:24', '1', '1'),
(736, 11303105, '2024-06-18 12:10:02', '1', '1'),
(737, 11342745, '2024-06-18 12:10:24', '1', '1'),
(738, 6236864, '2024-06-18 12:11:03', '1', '1'),
(739, 6339596, '2024-06-18 12:11:09', '1', '1'),
(740, 5555563, '2024-06-18 12:13:58', '1', '1'),
(741, 37, '2024-06-18 12:14:06', '1', '1'),
(742, 7090472, '2024-06-18 12:15:45', '1', '1'),
(743, 6379417, '2024-06-18 12:16:24', '1', '1'),
(744, 52, '2024-06-18 12:16:33', '1', '1'),
(745, 123, '2024-06-18 12:16:41', '1', '1'),
(746, 13, '2024-06-18 12:16:46', '1', '1'),
(747, 10, '2024-06-18 12:16:50', '1', '1'),
(748, 789, '2024-06-18 12:18:18', '1', '1'),
(749, 6337583, '2024-06-18 12:18:42', '1', '1'),
(750, 6337583, '2024-06-18 12:18:45', '1', '1'),
(751, 75, '2024-06-18 12:18:53', '1', '1'),
(752, 53, '2024-06-18 12:19:04', '1', '1'),
(753, 5403347, '2024-06-18 12:20:27', '1', '1'),
(754, 41, '2024-06-18 12:20:36', '1', '1'),
(755, 54, '2024-06-18 12:20:41', '1', '1'),
(756, 40, '2024-06-18 12:21:55', '1', '1'),
(757, 20, '2024-06-18 12:22:51', '1', '1'),
(758, 74, '2024-06-18 12:22:56', '1', '1'),
(759, 6339596, '2024-06-18 12:23:40', '1', '1'),
(760, 6379417, '2024-06-18 12:23:47', '1', '1'),
(761, 34, '2024-06-18 12:23:54', '1', '1'),
(762, 75, '2024-06-18 12:25:22', '1', '1'),
(763, 75, '2024-06-18 12:25:26', '1', '1'),
(764, 6379417, '2024-06-18 12:25:30', '1', '1'),
(765, 3927161, '2024-06-18 12:27:13', '1', '1'),
(766, 3927161, '2024-06-18 12:27:17', '1', '1'),
(767, 3, '2024-06-18 12:27:59', '1', '1'),
(768, 5555563, '2024-06-18 12:28:37', '1', '1'),
(769, 18, '2024-06-18 12:28:44', '1', '1'),
(770, 8160107, '2024-06-18 12:28:49', '1', '1'),
(771, 41, '2024-06-18 12:30:04', '1', '1'),
(772, 73, '2024-06-18 12:30:06', '1', '1'),
(773, 73, '2024-06-18 12:30:07', '1', '1'),
(774, 5379139, '2024-06-18 12:33:04', '1', '1'),
(775, 5862586, '2024-06-18 12:33:56', '1', '1'),
(776, 21, '2024-06-18 12:34:11', '1', '1'),
(777, 62, '2024-06-18 12:34:16', '1', '1'),
(778, 9837586, '2024-06-18 12:35:35', '1', '1'),
(779, 6236864, '2024-06-18 12:37:47', '1', '1'),
(780, 5828795, '2024-06-18 12:37:52', '1', '1'),
(781, 5828795, '2024-06-18 12:37:56', '1', '1'),
(782, 9272440, '2024-06-18 12:38:11', '1', '1'),
(783, 8929159, '2024-06-18 12:38:39', '1', '1'),
(784, 5049082, '2024-06-18 12:39:17', '1', '1'),
(785, 5049082, '2024-06-18 12:39:21', '1', '1'),
(786, 11303105, '2024-06-18 12:39:45', '1', '1'),
(787, 11303105, '2024-06-18 12:39:48', '1', '1'),
(788, 40, '2024-06-18 12:39:55', '1', '1'),
(789, 7090472, '2024-06-18 12:40:46', '1', '1'),
(790, 7090472, '2024-06-18 12:40:49', '1', '1'),
(791, 73, '2024-06-18 12:43:16', '1', '1'),
(792, 5379139, '2024-06-18 12:43:59', '1', '1'),
(793, 5379139, '2024-06-18 12:44:05', '1', '1'),
(794, 53, '2024-06-18 12:44:11', '1', '1'),
(795, 18, '2024-06-18 12:44:40', '1', '1'),
(796, 5403347, '2024-06-18 12:45:00', '1', '1'),
(797, 5347651, '2024-06-18 12:47:54', '1', '1'),
(798, 19, '2024-06-18 12:51:15', '1', '1'),
(799, 19, '2024-06-18 12:51:19', '1', '1'),
(800, 21, '2024-06-18 12:52:09', '1', '1'),
(801, 21, '2024-06-18 12:52:13', '1', '1'),
(802, 11, '2024-06-18 12:54:31', '1', '1'),
(803, 8929159, '2024-06-18 12:56:50', '1', '1'),
(804, 5859364, '2024-06-18 13:00:26', '1', '1'),
(805, 5859364, '2024-06-18 13:00:31', '1', '1'),
(806, 8913882, '2024-06-18 13:01:48', '1', '1'),
(807, 5895212, '2024-06-18 13:01:53', '1', '1'),
(808, 12475463, '2024-06-18 13:01:59', '1', '1'),
(809, 62, '2024-06-18 13:04:26', '1', '1'),
(810, 5049082, '2024-06-18 13:04:33', '1', '1'),
(811, 9837586, '2024-06-18 13:04:38', '1', '1'),
(812, 9272440, '2024-06-18 13:05:43', '1', '1'),
(813, 1734878, '2024-06-18 13:07:50', '1', '1'),
(814, 19, '2024-06-18 13:09:08', '1', '1'),
(815, 2708782, '2024-06-18 13:12:50', '1', '1'),
(816, 2708782, '2024-06-18 13:12:53', '1', '1'),
(817, 2708782, '2024-06-18 13:12:56', '1', '1'),
(818, 8992299, '2024-06-18 13:13:54', '1', '1'),
(819, 8992299, '2024-06-18 13:13:57', '1', '1'),
(820, 5859364, '2024-06-18 13:15:24', '1', '1'),
(821, 5859364, '2024-06-18 13:15:32', '1', '1'),
(822, 5859364, '2024-06-18 13:15:35', '1', '1'),
(823, 11, '2024-06-18 13:17:26', '1', '1'),
(824, 11, '2024-06-18 13:17:30', '1', '1'),
(825, 5347651, '2024-06-18 13:17:35', '1', '1'),
(826, 8969452, '2024-06-18 13:17:41', '1', '1'),
(827, 6282278, '2024-06-18 13:20:15', '1', '1'),
(828, 6282278, '2024-06-18 13:20:20', '1', '1'),
(829, 12475463, '2024-06-18 13:22:11', '1', '1'),
(830, 12475463, '2024-06-18 13:22:15', '1', '1'),
(831, 12475463, '2024-06-18 13:22:20', '1', '1'),
(832, 8913882, '2024-06-18 13:24:29', '1', '1'),
(833, 8913882, '2024-06-18 13:24:34', '1', '1'),
(834, 43, '2024-06-18 13:34:06', '1', '1'),
(835, 5895212, '2024-06-18 13:35:58', '1', '1'),
(836, 1734878, '2024-06-18 13:36:12', '1', '1'),
(837, 2708782, '2024-06-18 13:42:08', '1', '1'),
(838, 2708782, '2024-06-18 13:42:11', '1', '1'),
(839, 2708782, '2024-06-18 13:42:15', '1', '1'),
(840, 8992299, '2024-06-18 13:42:20', '1', '1'),
(841, 6282278, '2024-06-18 13:42:31', '1', '1'),
(842, 8969452, '2024-06-18 13:44:35', '1', '1'),
(843, 3296579, '2024-06-18 13:46:01', '1', '1'),
(844, 3296579, '2024-06-18 13:46:09', '1', '1'),
(845, 4295735, '2024-06-18 13:52:24', '1', '1'),
(846, 4295735, '2024-06-18 13:52:29', '1', '1'),
(847, 13079868, '2024-06-18 13:56:45', '1', '1'),
(848, 3296579, '2024-06-18 13:57:07', '1', '1'),
(849, 43, '2024-06-18 14:02:10', '1', '1'),
(850, 43, '2024-06-18 14:02:14', '1', '1'),
(851, 4295735, '2024-06-18 14:13:47', '1', '1'),
(852, 13079868, '2024-06-18 14:21:57', '1', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `per_tblcliente`
--

CREATE TABLE `per_tblcliente` (
  `idcliente` int(11) DEFAULT NULL,
  `idpersona` int(11) DEFAULT NULL,
  `idtipocliente` int(11) DEFAULT NULL,
  `saldo` decimal(10,0) DEFAULT NULL,
  `creditopermitido` decimal(10,0) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `per_tblcliente`
--

INSERT INTO `per_tblcliente` (`idcliente`, `idpersona`, `idtipocliente`, `saldo`, `creditopermitido`, `fecharegistro`, `estadoregistro`) VALUES
(1, 4, 0, 0, 0, '2024-02-26 01:05:29', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `per_tblpersona`
--

CREATE TABLE `per_tblpersona` (
  `idpersona` int(11) DEFAULT NULL,
  `idtipopersona` int(11) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `paterno` varchar(50) DEFAULT NULL,
  `materno` varchar(50) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `celular` varchar(11) DEFAULT NULL,
  `celularcontacto` varchar(11) DEFAULT NULL,
  `fechanacimiento` datetime DEFAULT NULL,
  `idtiposexo` int(11) DEFAULT NULL,
  `observaciones` varchar(50) DEFAULT NULL,
  `nrodocumento` varchar(11) DEFAULT NULL,
  `idtipodocumento` int(11) DEFAULT NULL,
  `nit` varchar(50) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `per_tblpersona`
--

INSERT INTO `per_tblpersona` (`idpersona`, `idtipopersona`, `nombre`, `paterno`, `materno`, `direccion`, `celular`, `celularcontacto`, `fechanacimiento`, `idtiposexo`, `observaciones`, `nrodocumento`, `idtipodocumento`, `nit`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 'admin', 'root', '', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '123', 1, '123', '2024-09-19 19:00:18', b'1'),
(2, 1, 'ROSEMARY', 'ALACHI', 'MAMANI', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5086050-1G', 1, '5086050-1G', '2024-09-19 19:00:18', b'1'),
(3, 1, 'MARTHA', 'ALMENDRAS', 'MEDRANO', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5666422', 1, '5666422', '2024-09-19 19:00:18', b'1'),
(4, 1, 'LEYLA ARACELY', 'ARROYO', 'GARNICA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '10342432', 1, '10342432', '2024-09-19 19:00:18', b'1'),
(5, 1, 'MARIA ELENA', 'CABA', 'LLANOS', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '4081386', 1, '4081386', '2024-09-19 19:00:18', b'1'),
(6, 1, 'JUAN CARLOS', 'CASTRO', 'FLORES', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '7552023', 1, '7552023', '2024-09-19 19:00:18', b'1'),
(7, 1, 'MARIA ELENA', 'CHOQUE', 'ACCHURA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '8572843', 1, '8572843', '2024-09-19 19:00:18', b'1'),
(8, 1, 'JULIA', 'COCA', 'TORRES', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '4086210', 1, '4086210', '2024-09-19 19:00:18', b'1'),
(9, 1, 'TRIFONIA', 'COLQUE', 'HUGARTE', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '7250724', 1, '7250724', '2024-09-19 19:00:18', b'1'),
(10, 1, 'YAMIL FERNANDO', 'CRESPO', 'ALFARO', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5487901', 1, '5487901', '2024-09-19 19:00:18', b'1'),
(11, 1, 'SERGIO', 'ECHALAR', 'GUZMAN', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '4088539', 1, '4088539', '2024-09-19 19:00:18', b'1'),
(12, 1, 'SUSANA', 'ENCINAS', '', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '1145195', 1, '1145195', '2024-09-19 19:00:18', b'1'),
(13, 1, 'GLADYS VANESA', 'FERNANDEZ', 'CAZON', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '7244559', 1, '7244559', '2024-09-19 19:00:18', b'1'),
(14, 1, 'LILIANA VANESSA', 'FLORES', 'MIRANDA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '10350248', 1, '10350248', '2024-09-19 19:00:18', b'1'),
(15, 1, 'PAOLA WENDY', 'FLORES', 'GORENA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5680352', 1, '5680352', '2024-09-19 19:00:18', b'1'),
(16, 1, 'JUAN', 'GARCIA', 'CESPEDES', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5196418', 1, '5196418', '2024-09-19 19:00:18', b'1'),
(17, 1, 'MIRTHA MERCEDES', 'GOMEZ', 'PINTO', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5070947', 1, '5070947', '2024-09-19 19:00:18', b'1'),
(18, 1, 'WALDIR', 'LAZO', 'MARTINEZ', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5493076', 1, '5493076', '2024-09-19 19:00:18', b'1'),
(19, 1, 'MAURICIO', 'LORA', 'HUAYLLA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5653197', 1, '5653197', '2024-09-19 19:00:18', b'1'),
(20, 1, 'JORGE', 'LUCUY', 'BARJA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5679038', 1, '5679038', '2024-09-19 19:00:18', b'1'),
(21, 1, 'GISELA MABEL', 'MACIAS', 'BARJA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '12455796', 1, '12455796', '2024-09-19 19:00:18', b'1'),
(22, 1, 'LIZETH', 'MALDONADO', 'QUISPE', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5652229', 1, '5652229', '2024-09-19 19:00:18', b'1'),
(23, 1, 'ELIZABETH', 'MAMANI', 'MUÑOZ', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '3963375', 1, '3963375', '2024-09-19 19:00:18', b'1'),
(24, 1, 'PASCUALA', 'MARAS', 'LUNA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '7498812', 1, '7498812', '2024-09-19 19:00:18', b'1'),
(25, 1, 'WALDID LUCIO', 'MARIN', 'GUZMAN', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5643922', 1, '5643922', '2024-09-19 19:00:18', b'1'),
(26, 1, 'DAMIANA', 'MENCHACA', 'CARDENAS', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '6600107', 1, '6600107', '2024-09-19 19:00:18', b'1'),
(27, 1, 'MARIA', 'MENDEZ', 'MAMANI', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '3080181', 1, '3080181', '2024-09-19 19:00:18', b'1'),
(28, 1, 'MARINA', 'NAVARRO', 'TRUJILLO', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '4081061', 1, '4081061', '2024-09-19 19:00:18', b'1'),
(29, 1, 'RAQUEL', 'NOGALES', 'ANDRADE', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '4504828', 1, '4504828', '2024-09-19 19:00:18', b'1'),
(30, 1, 'MARINA', 'PACO', 'QUITU', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '7504956', 1, '7504956', '2024-09-19 19:00:18', b'1'),
(31, 1, 'CARMELA', 'PARACTA', 'GONZALES', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5656861', 1, '5656861', '2024-09-19 19:00:18', b'1'),
(32, 1, 'TOMAS', 'PEREZ', 'CHOQUE', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '4107188', 1, '4107188', '2024-09-19 19:00:18', b'1'),
(33, 1, 'MARIA ALICIA', 'PRADO', 'GONZALES', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '3232329', 1, '3232329', '2024-09-19 19:00:18', b'1'),
(34, 1, 'DONATA', 'PUMA', 'AGUILAR', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5498150', 1, '5498150', '2024-09-19 19:00:18', b'1'),
(35, 1, 'CLAUDIA DAYANA', 'QUIROGA', 'GUERRA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '7537663', 1, '7537663', '2024-09-19 19:00:18', b'1'),
(36, 1, 'RICHARD TIMOTEO', 'RENDON', 'MALDONADO', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5669467', 1, '5669467', '2024-09-19 19:00:18', b'1'),
(37, 1, 'FABIOLA MARTHA', 'RIVERA', 'SOLIS', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '4631519', 1, '4631519', '2024-09-19 19:00:18', b'1'),
(38, 1, 'ABIGAIL', 'RODRIGUEZ', 'BARRERO', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '10381905', 1, '10381905', '2024-09-19 19:00:18', b'1'),
(39, 1, 'MARTINA', 'SOSSA', 'SALAZAR', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '1109800', 1, '1109800', '2024-09-19 19:00:18', b'1'),
(40, 1, 'CARLOS MARCELO', 'SOTO', 'QUINTANILLA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '8509175', 1, '8509175', '2024-09-19 19:00:18', b'1'),
(41, 1, 'LUPE NINOSKA', 'URIBE', 'ROMAY', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '3712175', 1, '3712175', '2024-09-19 19:00:18', b'1'),
(42, 1, 'MAURICIO PERCY', 'VELASCO', 'PADILLA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5495505', 1, '5495505', '2024-09-19 19:00:18', b'1'),
(43, 1, 'VIVIANA', 'VILLCA', 'ZAMBRANA', 'Sucre', '', '', '2000-01-01 00:00:00', 1, '', '5681079', 1, '5681079', '2024-09-19 19:00:18', b'1'),
(44, 1, 'FRANCO JASHIL', 'VISCARRA', 'ROMERO', 'Sucre', '0', '', '2000-01-01 00:00:00', 1, '', '5800414', 1, '5800414', '2024-09-19 19:00:18', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `per_tblproveedor`
--

CREATE TABLE `per_tblproveedor` (
  `idproveedor` int(11) DEFAULT NULL,
  `idpersona` int(11) DEFAULT NULL,
  `idtipoproveedor` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `per_tblproveedor`
--

INSERT INTO `per_tblproveedor` (`idproveedor`, `idpersona`, `idtipoproveedor`, `fecharegistro`, `estadoregistro`) VALUES
(1, 3, 0, '2024-02-14 15:32:45', b'1'),
(2, 5, 0, '2024-02-26 13:49:48', b'1'),
(3, 6, 0, '2024-02-26 13:55:21', b'1'),
(4, 7, 0, '2024-02-26 14:01:31', b'1'),
(5, 13, 0, '2024-03-11 19:46:28', b'1'),
(6, 16, 0, '2024-03-15 23:33:18', b'1'),
(7, 17, 0, '2024-03-27 01:37:53', b'1');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `per_viscliente`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `per_viscliente` (
`idcliente` int(11)
,`nombrecliente` double
,`idpersona` int(11)
,`idtipopersona` int(11)
,`nombre` varchar(50)
,`paterno` varchar(50)
,`materno` varchar(50)
,`direccion` varchar(50)
,`celular` varchar(11)
,`celularcontacto` varchar(11)
,`fechanacimiento` datetime
,`idtiposexo` int(11)
,`observaciones` varchar(50)
,`nrodocumento` varchar(11)
,`idtipodocumento` int(11)
,`nit` varchar(50)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `per_vispersona`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `per_vispersona` (
`idpersona` int(11)
,`idtipopersona` int(11)
,`nombre` varchar(50)
,`paterno` varchar(50)
,`materno` varchar(50)
,`direccion` varchar(50)
,`celular` varchar(11)
,`celularcontacto` varchar(11)
,`fechanacimiento` datetime
,`idtiposexo` int(11)
,`observaciones` varchar(50)
,`nrodocumento` varchar(11)
,`idtipodocumento` int(11)
,`nit` varchar(50)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `per_visproveedor`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `per_visproveedor` (
`idproveedor` int(11)
,`nombreproveedor` double
,`idpersona` int(11)
,`idtipopersona` int(11)
,`nombre` varchar(50)
,`paterno` varchar(50)
,`materno` varchar(50)
,`direccion` varchar(50)
,`celular` varchar(11)
,`celularcontacto` varchar(11)
,`fechanacimiento` datetime
,`idtiposexo` int(11)
,`observaciones` varchar(50)
,`nrodocumento` varchar(11)
,`idtipodocumento` int(11)
,`nit` varchar(50)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `restrnclasificador`
--

CREATE TABLE `restrnclasificador` (
  `idclasificador` int(11) NOT NULL,
  `nombreclasificador` varchar(1024) NOT NULL,
  `detalle` varchar(2024) NOT NULL,
  `orden` int(11) NOT NULL,
  `fecharegistro` datetime NOT NULL,
  `estadoregistro` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `restrnclasificador`
--

INSERT INTO `restrnclasificador` (`idclasificador`, `nombreclasificador`, `detalle`, `orden`, `fecharegistro`, `estadoregistro`) VALUES
(1, 'TRAMITES C/PRUEBA', '1. NUMERO DE TRAMITES ADMINISTRATIVOS DE SANEAMIENTO DE PARTIDAS', 1, '2024-01-01 00:00:00', b'1'),
(2, 'TRAMITES S/PRUEBA', '1. NUMERO DE TRAMITES ADMINISTRATIVOS DE SANEAMIENTO DE PARTIDAS', 2, '2024-01-01 00:00:00', b'1'),
(3, 'OBSERVADOS', '1. NUMERO DE TRAMITES ADMINISTRATIVOS DE SANEAMIENTO DE PARTIDAS', 3, '2024-01-01 00:00:00', b'1'),
(4, 'RECHAZADOS', '1. NUMERO DE TRAMITES ADMINISTRATIVOS DE SANEAMIENTO DE PARTIDAS', 4, '2024-01-01 00:00:00', b'1'),
(5, 'REPOSICIONES', '1. NUMERO DE TRAMITES ADMINISTRATIVOS DE SANEAMIENTO DE PARTIDAS', 5, '2024-01-01 00:00:00', b'1'),
(6, 'TRASPASOS', '1. NUMERO DE TRAMITES ADMINISTRATIVOS DE SANEAMIENTO DE PARTIDAS', 6, '2024-01-01 00:00:00', b'1'),
(7, 'REVOCATORIO APROBADO', '2. Datos de Recursos Revocatorio', 7, '2024-01-01 00:00:00', b'1'),
(8, 'REVOCATORIO RECHAZADO', '2. Datos de Recursos Revocatorio', 8, '2024-01-01 00:00:00', b'1'),
(9, 'REVOCATORIO OBSERVADO', '2. Datos de Recursos Revocatorio', 9, '2024-01-01 00:00:00', b'1'),
(10, 'JERARQUICO APROBADO', '3. Datos de Recurso Jerarquico', 10, '2024-01-01 00:00:00', b'1'),
(11, 'JERARQUICO RECHAZADO', '3. Datos de Recurso Jerarquico', 11, '2024-01-01 00:00:00', b'1'),
(12, 'JERARQUICO OBSERVADO', '3. Datos de Recurso Jerarquico', 12, '2024-01-01 00:00:00', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `restrnclasificadortramitesirius`
--

CREATE TABLE `restrnclasificadortramitesirius` (
  `idclasificadortramitesirius` int(11) NOT NULL,
  `idclasificador` int(11) NOT NULL,
  `idtramitesirius` int(11) NOT NULL,
  `fecharegistro` datetime NOT NULL,
  `estadoregistro` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `restrnclasificadortramitesirius`
--

INSERT INTO `restrnclasificadortramitesirius` (`idclasificadortramitesirius`, `idclasificador`, `idtramitesirius`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 1119, '2024-01-01 00:00:00', b'1'),
(2, 1, 1118, '2024-01-01 00:00:00', b'1'),
(3, 1, 1082, '2024-01-01 00:00:00', b'1'),
(4, 1, 1121, '2024-01-01 00:00:00', b'1'),
(5, 1, 1120, '2024-01-01 00:00:00', b'1'),
(6, 2, 1123, '2024-01-01 00:00:00', b'1'),
(7, 2, 1122, '2024-01-01 00:00:00', b'1'),
(8, 2, 1083, '2024-01-01 00:00:00', b'1'),
(9, 2, 1124, '2024-01-01 00:00:00', b'1'),
(10, 3, 1062, '2024-01-01 00:00:00', b'1'),
(11, 4, 1067, '2024-01-01 00:00:00', b'1'),
(12, 5, 1075, '2024-01-01 00:00:00', b'1'),
(13, 5, 1074, '2024-01-01 00:00:00', b'1'),
(14, 5, 1073, '2024-01-01 00:00:00', b'1'),
(15, 6, 1090, '2024-01-01 00:00:00', b'1'),
(16, 6, 1089, '2024-01-01 00:00:00', b'1'),
(17, 6, 1088, '2024-01-01 00:00:00', b'1'),
(18, 7, 1071, '2024-01-01 00:00:00', b'1'),
(19, 8, 1115, '2024-01-01 00:00:00', b'1'),
(20, 8, 1116, '2024-01-01 00:00:00', b'1'),
(21, 9, 1117, '2024-01-01 00:00:00', b'1'),
(22, 10, 1069, '2024-01-01 00:00:00', b'1'),
(23, 11, 1112, '2024-01-01 00:00:00', b'1'),
(24, 11, 1113, '2024-01-01 00:00:00', b'1'),
(25, 12, 1114, '2024-01-01 00:00:00', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `res_tblhorariogeneral`
--

CREATE TABLE `res_tblhorariogeneral` (
  `idhorariogeneral` int(11) DEFAULT NULL,
  `idhorario` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `diasemana` int(11) DEFAULT NULL,
  `idferiado` int(11) DEFAULT NULL,
  `idtipofecha` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `res_tbloficina`
--

CREATE TABLE `res_tbloficina` (
  `idoficina` int(11) DEFAULT NULL,
  `nombreoficina` varchar(64) DEFAULT NULL,
  `iddepartamento` int(11) DEFAULT NULL,
  `direccion` varchar(256) DEFAULT NULL,
  `ubicacion` varchar(512) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `res_tbloficina`
--

INSERT INTO `res_tbloficina` (`idoficina`, `nombreoficina`, `iddepartamento`, `direccion`, `ubicacion`, `fecharegistro`, `estadoregistro`) VALUES
(1, 'central', 7, 'direcion', 'google maps', '2023-11-03 20:04:05', b'1'),
(2, 'oficina 2', 0, 'direccion 2', 'ubicacion 2', '2023-11-04 13:49:47', b'1'),
(3, 'oficina 3', 0, 'direccion 3', 'ubicacion 3', '2023-11-04 17:51:07', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `res_tblreserva`
--

CREATE TABLE `res_tblreserva` (
  `idreserva` int(11) NOT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `idtramite` int(11) DEFAULT NULL,
  `fechareserva` date DEFAULT NULL,
  `horainicio` datetime DEFAULT NULL,
  `horafin` datetime DEFAULT NULL,
  `fechaevento` datetime DEFAULT NULL,
  `estadoreserva` int(11) DEFAULT NULL,
  `historico` char(1) DEFAULT NULL,
  `urlsolicitud` int(11) DEFAULT NULL,
  `fechacancelacion` datetime DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `llave` varchar(50) DEFAULT NULL,
  `presente` char(50) DEFAULT NULL,
  `observaciones` varchar(50) DEFAULT NULL,
  `carnetidentidad` char(12) DEFAULT NULL,
  `complemento` char(2) DEFAULT NULL,
  `idtipodocumento` int(11) DEFAULT NULL,
  `nombre` varchar(64) DEFAULT NULL,
  `paterno` varchar(64) DEFAULT NULL,
  `materno` varchar(64) DEFAULT NULL,
  `celular` char(8) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `idubicacion` int(11) DEFAULT NULL,
  `preferencial` bit(1) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `res_tbltramitegrupo`
--

CREATE TABLE `res_tbltramitegrupo` (
  `idtramitegrupo` int(11) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `nombretramitegrupo` varchar(256) DEFAULT NULL,
  `titulo` varchar(256) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `res_tbltramitemenu`
--

CREATE TABLE `res_tbltramitemenu` (
  `idtramitemenu` int(11) DEFAULT NULL,
  `nombretramitemenu` varchar(512) DEFAULT NULL,
  `idoficina` int(11) DEFAULT NULL,
  `titulo` varchar(512) DEFAULT NULL,
  `detalle` varchar(512) DEFAULT NULL,
  `pietramitemenu` varchar(1024) DEFAULT NULL,
  `orden` int(11) DEFAULT NULL,
  `programacita` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `res_tbltramitemenuespecialidad`
--

CREATE TABLE `res_tbltramitemenuespecialidad` (
  `idtramitemenuespecialidad` int(11) DEFAULT NULL,
  `idtramitemenu` int(11) DEFAULT NULL,
  `idespecialidad` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `fecharegistro` date DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `res_tblubicacion`
--

CREATE TABLE `res_tblubicacion` (
  `idubicacion` int(11) NOT NULL,
  `idtramitegrupo` int(11) DEFAULT NULL,
  `idconsultorio` int(11) DEFAULT NULL,
  `tiempoestimado` int(11) DEFAULT NULL,
  `numeroubicacion` int(11) DEFAULT NULL,
  `nombreubicacion` varchar(50) DEFAULT NULL,
  `servicio` varchar(50) DEFAULT NULL,
  `programarcita` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `res_tblubicacionhorario`
--

CREATE TABLE `res_tblubicacionhorario` (
  `idubicacionhorario` int(11) NOT NULL,
  `idubicacion` int(11) DEFAULT NULL,
  `diasemana` int(11) DEFAULT NULL,
  `horareinicio` datetime DEFAULT NULL,
  `horarefin` datetime DEFAULT NULL,
  `horarefrigerioinicio` datetime DEFAULT NULL,
  `horarefrigeriofin` datetime DEFAULT NULL,
  `programarcita` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `res_vishorariogeneral`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `res_vishorariogeneral` (
`idhorariogeneral` int(11)
,`idhorario` int(11)
,`fecha` date
,`diasemana` int(11)
,`idferiado` int(11)
,`idtipofecha` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `res_visoficina`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `res_visoficina` (
`idoficina` int(11)
,`nombreoficina` varchar(64)
,`iddepartamento` int(11)
,`direccion` varchar(256)
,`ubicacion` varchar(512)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `res_visreserva`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `res_visreserva` (
`idreserva` int(11)
,`idoficina` int(11)
,`idtramite` int(11)
,`fechareserva` date
,`horainicio` datetime
,`horafin` datetime
,`fechaevento` datetime
,`estadoreserva` int(11)
,`historico` char(1)
,`urlsolicitud` int(11)
,`fechacancelacion` datetime
,`idusuario` int(11)
,`llave` varchar(50)
,`presente` char(50)
,`observaciones` varchar(50)
,`carnetidentidad` char(12)
,`complemento` char(2)
,`idtipodocumento` int(11)
,`nombre` varchar(64)
,`paterno` varchar(64)
,`materno` varchar(64)
,`celular` char(8)
,`email` varchar(64)
,`idubicacion` int(11)
,`preferencial` bit(1)
,`fecharegistro` datetime
,`estadoregistro` int(11)
,`idtramitegrupo` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `res_vistramitegrupo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `res_vistramitegrupo` (
`idtramitegrupo` int(11)
,`idoficina` int(11)
,`nombretramitegrupo` varchar(256)
,`titulo` varchar(256)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `res_vistramitemenu`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `res_vistramitemenu` (
`idtramitemenu` int(11)
,`nombretramitemenu` varchar(512)
,`idoficina` int(11)
,`titulo` varchar(512)
,`detalle` varchar(512)
,`pietramitemenu` varchar(1024)
,`orden` int(11)
,`programacita` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `res_vistramitemenuespecialidad`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `res_vistramitemenuespecialidad` (
`idtramitemenuespecialidad` int(11)
,`idtramitemenu` int(11)
,`idespecialidad` int(11)
,`nombreespecialidad` varchar(512)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `res_visubicacion`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `res_visubicacion` (
`idubicacion` int(11)
,`idtramitegrupo` int(11)
,`idconsultorio` int(11)
,`tiempoestimado` int(11)
,`numeroubicacion` int(11)
,`nombreubicacion` varchar(50)
,`servicio` varchar(50)
,`programarcita` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `res_visubicacionhorario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `res_visubicacionhorario` (
`idubicacionhorario` int(11)
,`idubicacion` int(11)
,`diasemana` int(11)
,`horareinicio` datetime
,`horarefin` datetime
,`horarefrigerioinicio` datetime
,`horarefrigeriofin` datetime
,`programarcita` int(11)
,`idusuario` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seg_tblestado`
--

CREATE TABLE `seg_tblestado` (
  `idestado` int(11) DEFAULT NULL,
  `nombretabla` varchar(50) DEFAULT NULL,
  `nombrecampo` varchar(50) DEFAULT NULL,
  `valorcampo` varchar(2048) DEFAULT NULL,
  `habilitado` bit(1) DEFAULT NULL,
  `idestadopadre` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seg_tbllogusuario`
--

CREATE TABLE `seg_tbllogusuario` (
  `idlogusuario` int(11) NOT NULL,
  `nombresistema` char(6) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `nombreservicio` char(32) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `seg_tbllogusuario`
--

INSERT INTO `seg_tbllogusuario` (`idlogusuario`, `nombresistema`, `idusuario`, `nombreservicio`, `fecharegistro`, `estadoregistro`) VALUES
(4119, 'sisesc', 1, 'seloficina', '2024-02-14 15:06:31', b'1'),
(4120, 'sisesc', 1, 'selusuario', '2024-02-14 15:06:34', b'1'),
(4121, 'sisesc', 1, 'selusuario', '2024-02-14 15:08:18', b'1'),
(4122, 'sisesc', 1, 'addpersona', '2024-02-14 15:15:56', b'1'),
(4123, 'sisesc', 1, 'addusuario', '2024-02-14 15:15:56', b'1'),
(4124, 'sisesc', 1, 'selusuario', '2024-02-14 15:15:57', b'1'),
(4125, 'sisesc', 1, 'getusuario', '2024-02-14 15:16:05', b'1'),
(4126, 'sisesc', 1, 'getpersona', '2024-02-14 15:16:05', b'1'),
(4127, 'sisesc', 1, 'selrolusuario', '2024-02-14 15:16:05', b'1'),
(4128, 'sisesc', 1, 'getusuario', '2024-02-14 15:16:08', b'1'),
(4129, 'sisesc', 1, 'selrol', '2024-02-14 15:16:08', b'1'),
(4130, 'sisesc', 1, 'selubicacion', '2024-02-14 15:16:08', b'1'),
(4131, 'sisesc', 1, 'selproveedor', '2024-02-14 15:32:24', b'1'),
(4132, 'sisesc', 1, 'selmarca', '2024-02-14 15:32:25', b'1'),
(4133, 'sisesc', 1, 'addpersona', '2024-02-14 15:32:45', b'1'),
(4134, 'sisesc', 1, 'addproveedor', '2024-02-14 15:32:45', b'1'),
(4135, 'sisesc', 1, 'selproveedor', '2024-02-14 15:32:46', b'1'),
(4136, 'sisesc', 1, 'selproveedor', '2024-02-14 19:42:29', b'1'),
(4137, 'sisesc', 1, 'getproveedor', '2024-02-14 19:42:32', b'1'),
(4138, 'sisesc', 1, 'addcompra', '2024-02-14 19:42:32', b'1'),
(4139, 'sisesc', 1, 'getpersona', '2024-02-14 19:42:33', b'1'),
(4140, 'sisesc', 1, 'selproducto', '2024-02-14 19:42:33', b'1'),
(4141, 'sisesc', 1, 'selproveedor', '2024-02-14 19:43:36', b'1'),
(4142, 'sisesc', 1, 'getcompra', '2024-02-14 19:43:36', b'1'),
(4143, 'sisesc', 1, 'selcompradetalle', '2024-02-14 19:43:36', b'1'),
(4144, 'sisesc', 1, 'selproducto', '2024-02-14 19:43:37', b'1'),
(4145, 'sisesc', 1, 'getproveedor', '2024-02-14 19:43:37', b'1'),
(4146, 'sisesc', 1, 'getpersona', '2024-02-14 19:43:37', b'1'),
(4147, 'sisesc', 1, 'selproveedor', '2024-02-14 20:00:40', b'1'),
(4148, 'sisesc', 1, 'getcompra', '2024-02-14 20:00:40', b'1'),
(4149, 'sisesc', 1, 'selcompradetalle', '2024-02-14 20:00:40', b'1'),
(4150, 'sisesc', 1, 'selproducto', '2024-02-14 20:00:41', b'1'),
(4151, 'sisesc', 1, 'getproveedor', '2024-02-14 20:00:41', b'1'),
(4152, 'sisesc', 1, 'getpersona', '2024-02-14 20:00:41', b'1'),
(4153, 'sisesc', 1, 'getproducto', '2024-02-14 20:01:05', b'1'),
(4154, 'sisesc', 1, 'selproducto', '2024-02-14 20:01:10', b'1'),
(4155, 'sisesc', 1, 'selmarca', '2024-02-14 20:01:11', b'1'),
(4156, 'sisesc', 1, 'seloficina', '2024-02-14 20:36:45', b'1'),
(4157, 'sisesc', 1, 'seloficina', '2024-02-14 20:36:59', b'1'),
(4158, 'sisesc', 1, 'seloficina', '2024-02-14 20:37:18', b'1'),
(4159, 'sisesc', 1, 'seloficina', '2024-02-14 20:37:25', b'1'),
(4160, 'sisesc', 1, 'seloficina', '2024-02-14 20:37:44', b'1'),
(4161, 'sisesc', 1, 'seloficina', '2024-02-14 20:38:12', b'1'),
(4162, 'sisesc', 1, 'seloficina', '2024-02-14 20:38:44', b'1'),
(4163, 'sisesc', 1, 'selproducto', '2024-02-14 20:38:49', b'1'),
(4164, 'sisesc', 1, 'selusuario', '2024-02-14 20:38:54', b'1'),
(4165, 'sisesc', 1, 'getusuario', '2024-02-14 20:38:58', b'1'),
(4166, 'sisesc', 1, 'selusuario', '2024-02-14 20:39:01', b'1'),
(4167, 'sisesc', 1, 'getusuario', '2024-02-14 20:39:03', b'1'),
(4168, 'sisesc', 1, 'selusuario', '2024-02-14 20:40:01', b'1'),
(4169, 'sisesc', 1, 'getusuario', '2024-02-14 20:40:06', b'1'),
(4170, 'sisesc', 1, 'getusuario', '2024-02-14 20:41:02', b'1'),
(4171, 'sisesc', 1, 'selusuario', '2024-02-14 20:43:29', b'1'),
(4172, 'sisesc', 1, 'getusuario', '2024-02-14 20:43:31', b'1'),
(4173, 'sisesc', 1, 'selusuario', '2024-02-14 20:43:33', b'1'),
(4174, 'sisesc', 1, 'getusuario', '2024-02-14 20:43:34', b'1'),
(4175, 'sisesc', 1, 'selusuario', '2024-02-14 20:45:21', b'1'),
(4176, 'sisesc', 1, 'getusuario', '2024-02-14 20:45:23', b'1'),
(4177, 'sisesc', 1, 'getpersona', '2024-02-14 20:45:24', b'1'),
(4178, 'sisesc', 1, 'selrolusuario', '2024-02-14 20:45:24', b'1'),
(4179, 'sisesc', 1, 'selusuario', '2024-02-14 20:45:27', b'1'),
(4180, 'sisesc', 1, 'selusuario', '2024-02-14 20:45:29', b'1'),
(4181, 'sisesc', 1, 'getusuario', '2024-02-14 20:45:31', b'1'),
(4182, 'sisesc', 1, 'getpersona', '2024-02-14 20:45:31', b'1'),
(4183, 'sisesc', 1, 'selrolusuario', '2024-02-14 20:45:31', b'1'),
(4184, 'sisesc', 1, 'selusuario', '2024-02-14 20:45:36', b'1'),
(4185, 'sisesc', 1, 'getusuario', '2024-02-14 20:45:37', b'1'),
(4186, 'sisesc', 1, 'getpersona', '2024-02-14 20:45:37', b'1'),
(4187, 'sisesc', 1, 'selrolusuario', '2024-02-14 20:45:38', b'1'),
(4188, 'sisesc', 1, 'updusuario', '2024-02-14 20:46:22', b'1'),
(4189, 'sisesc', 1, 'updpersona', '2024-02-14 20:46:23', b'1'),
(4190, 'sisesc', 1, 'selusuario', '2024-02-14 20:46:25', b'1'),
(4191, 'sisesc', 2, 'seloficina', '2024-02-14 20:46:39', b'1'),
(4192, 'sisesc', 2, 'seloficina', '2024-02-14 20:46:45', b'1'),
(4193, 'sisesc', 2, 'selusuario', '2024-02-14 20:46:51', b'1'),
(4194, 'sisesc', 2, 'getusuario', '2024-02-14 20:46:55', b'1'),
(4195, 'sisesc', 2, 'getpersona', '2024-02-14 20:46:55', b'1'),
(4196, 'sisesc', 2, 'selrolusuario', '2024-02-14 20:46:56', b'1'),
(4197, 'sisesc', 2, 'updusuario', '2024-02-14 20:47:17', b'1'),
(4198, 'sisesc', 2, 'updpersona', '2024-02-14 20:47:17', b'1'),
(4199, 'sisesc', 2, 'selusuario', '2024-02-14 20:47:22', b'1'),
(4200, 'sisesc', 2, 'getusuario', '2024-02-14 20:47:33', b'1'),
(4201, 'sisesc', 2, 'getpersona', '2024-02-14 20:47:33', b'1'),
(4202, 'sisesc', 2, 'selrolusuario', '2024-02-14 20:47:33', b'1'),
(4203, 'sisesc', 2, 'updusuario', '2024-02-14 20:47:43', b'1'),
(4204, 'sisesc', 2, 'updpersona', '2024-02-14 20:47:44', b'1'),
(4205, 'sisesc', 1, 'seloficina', '2024-02-14 20:47:53', b'1'),
(4206, 'sisesc', 1, 'seloficina', '2024-02-14 20:48:00', b'1'),
(4207, 'sisesc', 1, 'selusuario', '2024-02-14 20:48:06', b'1'),
(4208, 'sisesc', 1, 'selproveedor', '2024-02-14 20:48:09', b'1'),
(4209, 'sisesc', 1, 'seloficina', '2024-02-16 14:15:09', b'1'),
(4210, 'sisesc', 1, 'selcompra', '2024-02-16 14:15:24', b'1'),
(4211, 'sisesc', 1, 'selproveedor', '2024-02-16 14:15:26', b'1'),
(4212, 'sisesc', 1, 'getcompra', '2024-02-16 14:15:26', b'1'),
(4213, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:15:26', b'1'),
(4214, 'sisesc', 1, 'selproducto', '2024-02-16 14:15:26', b'1'),
(4215, 'sisesc', 1, 'getproveedor', '2024-02-16 14:15:27', b'1'),
(4216, 'sisesc', 1, 'getpersona', '2024-02-16 14:15:27', b'1'),
(4217, 'sisesc', 1, 'selproveedor', '2024-02-16 14:16:11', b'1'),
(4218, 'sisesc', 1, 'getcompra', '2024-02-16 14:16:11', b'1'),
(4219, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:16:11', b'1'),
(4220, 'sisesc', 1, 'selproducto', '2024-02-16 14:16:12', b'1'),
(4221, 'sisesc', 1, 'getproveedor', '2024-02-16 14:16:12', b'1'),
(4222, 'sisesc', 1, 'getpersona', '2024-02-16 14:16:12', b'1'),
(4223, 'sisesc', 1, 'selproveedor', '2024-02-16 14:17:34', b'1'),
(4224, 'sisesc', 1, 'getcompra', '2024-02-16 14:17:34', b'1'),
(4225, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:17:35', b'1'),
(4226, 'sisesc', 1, 'selproducto', '2024-02-16 14:17:35', b'1'),
(4227, 'sisesc', 1, 'getproveedor', '2024-02-16 14:17:35', b'1'),
(4228, 'sisesc', 1, 'getpersona', '2024-02-16 14:17:35', b'1'),
(4229, 'sisesc', 1, 'papcompra', '2024-02-16 14:17:49', b'1'),
(4230, 'sisesc', 1, 'seloficina', '2024-02-16 14:17:52', b'1'),
(4231, 'sisesc', 1, 'seloficina', '2024-02-16 14:30:08', b'1'),
(4232, 'sisesc', 1, 'seloficina', '2024-02-16 14:30:10', b'1'),
(4233, 'sisesc', 1, 'seloficina', '2024-02-16 14:30:57', b'1'),
(4234, 'sisesc', 1, 'getcompra', '2024-02-16 14:30:58', b'1'),
(4235, 'sisesc', 1, 'selproveedor', '2024-02-16 14:36:28', b'1'),
(4236, 'sisesc', 1, 'getcompra', '2024-02-16 14:36:28', b'1'),
(4237, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:36:29', b'1'),
(4238, 'sisesc', 1, 'selproducto', '2024-02-16 14:36:29', b'1'),
(4239, 'sisesc', 1, 'getproveedor', '2024-02-16 14:36:29', b'1'),
(4240, 'sisesc', 1, 'getpersona', '2024-02-16 14:36:29', b'1'),
(4241, 'sisesc', 1, 'selcompra', '2024-02-16 14:39:57', b'1'),
(4242, 'sisesc', 1, 'selproveedor', '2024-02-16 14:39:59', b'1'),
(4243, 'sisesc', 1, 'getcompra', '2024-02-16 14:39:59', b'1'),
(4244, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:39:59', b'1'),
(4245, 'sisesc', 1, 'selproducto', '2024-02-16 14:39:59', b'1'),
(4246, 'sisesc', 1, 'getproveedor', '2024-02-16 14:40:00', b'1'),
(4247, 'sisesc', 1, 'getpersona', '2024-02-16 14:40:00', b'1'),
(4248, 'sisesc', 1, 'getcompra', '2024-02-16 14:40:02', b'1'),
(4249, 'sisesc', 1, 'getcompra', '2024-02-16 14:40:02', b'1'),
(4250, 'sisesc', 1, 'getcompra', '2024-02-16 14:40:13', b'1'),
(4251, 'sisesc', 1, 'getcompra', '2024-02-16 14:40:13', b'1'),
(4252, 'sisesc', 1, 'getcompra', '2024-02-16 14:40:51', b'1'),
(4253, 'sisesc', 1, 'getcompra', '2024-02-16 14:42:24', b'1'),
(4254, 'sisesc', 1, 'getcompra', '2024-02-16 14:48:34', b'1'),
(4255, 'sisesc', 1, 'selproveedor', '2024-02-16 14:48:34', b'1'),
(4256, 'sisesc', 1, 'selproveedor', '2024-02-16 14:48:34', b'1'),
(4257, 'sisesc', 1, 'getcompra', '2024-02-16 14:48:34', b'1'),
(4258, 'sisesc', 1, 'getcompra', '2024-02-16 14:48:34', b'1'),
(4259, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:48:34', b'1'),
(4260, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:48:34', b'1'),
(4261, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:48:34', b'1'),
(4262, 'sisesc', 1, 'getproveedor', '2024-02-16 14:48:34', b'1'),
(4263, 'sisesc', 1, 'selproducto', '2024-02-16 14:48:34', b'1'),
(4264, 'sisesc', 1, 'selproducto', '2024-02-16 14:48:34', b'1'),
(4265, 'sisesc', 1, 'getpersona', '2024-02-16 14:48:35', b'1'),
(4266, 'sisesc', 1, 'getproveedor', '2024-02-16 14:48:35', b'1'),
(4267, 'sisesc', 1, 'getproveedor', '2024-02-16 14:48:35', b'1'),
(4268, 'sisesc', 1, 'getpersona', '2024-02-16 14:48:35', b'1'),
(4269, 'sisesc', 1, 'getpersona', '2024-02-16 14:48:35', b'1'),
(4270, 'sisesc', 1, 'getcompra', '2024-02-16 14:48:49', b'1'),
(4271, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:48:50', b'1'),
(4272, 'sisesc', 1, 'getproveedor', '2024-02-16 14:48:50', b'1'),
(4273, 'sisesc', 1, 'getpersona', '2024-02-16 14:48:50', b'1'),
(4274, 'sisesc', 1, 'selproveedor', '2024-02-16 14:49:22', b'1'),
(4275, 'sisesc', 1, 'getproveedor', '2024-02-16 14:49:26', b'1'),
(4276, 'sisesc', 1, 'addcompra', '2024-02-16 14:49:26', b'1'),
(4277, 'sisesc', 1, 'getpersona', '2024-02-16 14:49:26', b'1'),
(4278, 'sisesc', 1, 'selproducto', '2024-02-16 14:49:26', b'1'),
(4279, 'sisesc', 1, 'getproducto', '2024-02-16 14:49:32', b'1'),
(4280, 'sisesc', 1, 'selproducto', '2024-02-16 14:49:33', b'1'),
(4281, 'sisesc', 1, 'selmarca', '2024-02-16 14:49:37', b'1'),
(4282, 'sisesc', 1, 'addproducto', '2024-02-16 14:49:45', b'1'),
(4283, 'sisesc', 1, 'selproducto', '2024-02-16 14:49:45', b'1'),
(4284, 'sisesc', 1, 'selproveedor', '2024-02-16 14:49:48', b'1'),
(4285, 'sisesc', 1, 'selcompra', '2024-02-16 14:49:52', b'1'),
(4286, 'sisesc', 1, 'selproveedor', '2024-02-16 14:49:54', b'1'),
(4287, 'sisesc', 1, 'getcompra', '2024-02-16 14:49:54', b'1'),
(4288, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:49:54', b'1'),
(4289, 'sisesc', 1, 'selproducto', '2024-02-16 14:49:54', b'1'),
(4290, 'sisesc', 1, 'getproveedor', '2024-02-16 14:49:54', b'1'),
(4291, 'sisesc', 1, 'getpersona', '2024-02-16 14:49:55', b'1'),
(4292, 'sisesc', 1, 'getproducto', '2024-02-16 14:49:57', b'1'),
(4293, 'sisesc', 1, 'addcompradetalle', '2024-02-16 14:50:00', b'1'),
(4294, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:50:01', b'1'),
(4295, 'sisesc', 1, 'papcompra', '2024-02-16 14:50:04', b'1'),
(4296, 'sisesc', 1, 'getcompra', '2024-02-16 14:50:06', b'1'),
(4297, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:50:06', b'1'),
(4298, 'sisesc', 1, 'getproveedor', '2024-02-16 14:50:07', b'1'),
(4299, 'sisesc', 1, 'getpersona', '2024-02-16 14:50:07', b'1'),
(4300, 'sisesc', 1, 'getcompra', '2024-02-16 14:51:23', b'1'),
(4301, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:51:23', b'1'),
(4302, 'sisesc', 1, 'getproveedor', '2024-02-16 14:51:23', b'1'),
(4303, 'sisesc', 1, 'getpersona', '2024-02-16 14:51:23', b'1'),
(4304, 'sisesc', 1, 'selproveedor', '2024-02-16 14:52:19', b'1'),
(4305, 'sisesc', 1, 'getcompra', '2024-02-16 14:52:19', b'1'),
(4306, 'sisesc', 1, 'getcompra', '2024-02-16 14:52:19', b'1'),
(4307, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:52:19', b'1'),
(4308, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:52:19', b'1'),
(4309, 'sisesc', 1, 'selproducto', '2024-02-16 14:52:19', b'1'),
(4310, 'sisesc', 1, 'getproveedor', '2024-02-16 14:52:19', b'1'),
(4311, 'sisesc', 1, 'getproveedor', '2024-02-16 14:52:19', b'1'),
(4312, 'sisesc', 1, 'selproveedor', '2024-02-16 14:52:19', b'1'),
(4313, 'sisesc', 1, 'getcompra', '2024-02-16 14:52:19', b'1'),
(4314, 'sisesc', 1, 'getpersona', '2024-02-16 14:52:19', b'1'),
(4315, 'sisesc', 1, 'getpersona', '2024-02-16 14:52:20', b'1'),
(4316, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:52:20', b'1'),
(4317, 'sisesc', 1, 'selproducto', '2024-02-16 14:52:20', b'1'),
(4318, 'sisesc', 1, 'getproveedor', '2024-02-16 14:52:20', b'1'),
(4319, 'sisesc', 1, 'getpersona', '2024-02-16 14:52:20', b'1'),
(4320, 'sisesc', 1, 'getcompra', '2024-02-16 14:52:29', b'1'),
(4321, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:52:29', b'1'),
(4322, 'sisesc', 1, 'getproveedor', '2024-02-16 14:52:29', b'1'),
(4323, 'sisesc', 1, 'getpersona', '2024-02-16 14:52:30', b'1'),
(4324, 'sisesc', 1, 'selproveedor', '2024-02-16 14:53:35', b'1'),
(4325, 'sisesc', 1, 'getcompra', '2024-02-16 14:53:35', b'1'),
(4326, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:53:36', b'1'),
(4327, 'sisesc', 1, 'selproducto', '2024-02-16 14:53:36', b'1'),
(4328, 'sisesc', 1, 'getproveedor', '2024-02-16 14:53:36', b'1'),
(4329, 'sisesc', 1, 'getpersona', '2024-02-16 14:53:36', b'1'),
(4330, 'sisesc', 1, 'getcompra', '2024-02-16 14:53:37', b'1'),
(4331, 'sisesc', 1, 'selproveedor', '2024-02-16 14:53:37', b'1'),
(4332, 'sisesc', 1, 'getcompra', '2024-02-16 14:53:37', b'1'),
(4333, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:53:38', b'1'),
(4334, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:53:38', b'1'),
(4335, 'sisesc', 1, 'getproveedor', '2024-02-16 14:53:38', b'1'),
(4336, 'sisesc', 1, 'selproducto', '2024-02-16 14:53:38', b'1'),
(4337, 'sisesc', 1, 'getpersona', '2024-02-16 14:53:38', b'1'),
(4338, 'sisesc', 1, 'getproveedor', '2024-02-16 14:53:38', b'1'),
(4339, 'sisesc', 1, 'getpersona', '2024-02-16 14:53:38', b'1'),
(4340, 'sisesc', 1, 'getcompra', '2024-02-16 14:55:46', b'1'),
(4341, 'sisesc', 1, 'getcompra', '2024-02-16 14:55:46', b'1'),
(4342, 'sisesc', 1, 'selproveedor', '2024-02-16 14:55:46', b'1'),
(4343, 'sisesc', 1, 'selproveedor', '2024-02-16 14:55:46', b'1'),
(4344, 'sisesc', 1, 'getcompra', '2024-02-16 14:55:46', b'1'),
(4345, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:55:46', b'1'),
(4346, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:55:46', b'1'),
(4347, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:55:46', b'1'),
(4348, 'sisesc', 1, 'getproveedor', '2024-02-16 14:55:46', b'1'),
(4349, 'sisesc', 1, 'selproducto', '2024-02-16 14:55:46', b'1'),
(4350, 'sisesc', 1, 'selproducto', '2024-02-16 14:55:46', b'1'),
(4351, 'sisesc', 1, 'getpersona', '2024-02-16 14:55:46', b'1'),
(4352, 'sisesc', 1, 'getproveedor', '2024-02-16 14:55:46', b'1'),
(4353, 'sisesc', 1, 'getproveedor', '2024-02-16 14:55:47', b'1'),
(4354, 'sisesc', 1, 'getpersona', '2024-02-16 14:55:47', b'1'),
(4355, 'sisesc', 1, 'getpersona', '2024-02-16 14:55:47', b'1'),
(4356, 'sisesc', 1, 'selproveedor', '2024-02-16 14:56:04', b'1'),
(4357, 'sisesc', 1, 'getcompra', '2024-02-16 14:56:04', b'1'),
(4358, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:56:04', b'1'),
(4359, 'sisesc', 1, 'selproducto', '2024-02-16 14:56:04', b'1'),
(4360, 'sisesc', 1, 'getproveedor', '2024-02-16 14:56:05', b'1'),
(4361, 'sisesc', 1, 'getpersona', '2024-02-16 14:56:05', b'1'),
(4362, 'sisesc', 1, 'getcompra', '2024-02-16 14:56:14', b'1'),
(4363, 'sisesc', 1, 'selproveedor', '2024-02-16 14:56:14', b'1'),
(4364, 'sisesc', 1, 'getcompra', '2024-02-16 14:56:14', b'1'),
(4365, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:56:14', b'1'),
(4366, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:56:14', b'1'),
(4367, 'sisesc', 1, 'getproveedor', '2024-02-16 14:56:14', b'1'),
(4368, 'sisesc', 1, 'selproducto', '2024-02-16 14:56:14', b'1'),
(4369, 'sisesc', 1, 'getpersona', '2024-02-16 14:56:15', b'1'),
(4370, 'sisesc', 1, 'getproveedor', '2024-02-16 14:56:15', b'1'),
(4371, 'sisesc', 1, 'getpersona', '2024-02-16 14:56:15', b'1'),
(4372, 'sisesc', 1, 'getcompra', '2024-02-16 14:56:41', b'1'),
(4373, 'sisesc', 1, 'selproveedor', '2024-02-16 14:56:41', b'1'),
(4374, 'sisesc', 1, 'getcompra', '2024-02-16 14:56:41', b'1'),
(4375, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:56:41', b'1'),
(4376, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:56:41', b'1'),
(4377, 'sisesc', 1, 'getproveedor', '2024-02-16 14:56:41', b'1'),
(4378, 'sisesc', 1, 'selproveedor', '2024-02-16 14:56:41', b'1'),
(4379, 'sisesc', 1, 'getcompra', '2024-02-16 14:56:41', b'1'),
(4380, 'sisesc', 1, 'selproducto', '2024-02-16 14:56:41', b'1'),
(4381, 'sisesc', 1, 'getpersona', '2024-02-16 14:56:41', b'1'),
(4382, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:56:42', b'1'),
(4383, 'sisesc', 1, 'getproveedor', '2024-02-16 14:56:42', b'1'),
(4384, 'sisesc', 1, 'selproducto', '2024-02-16 14:56:42', b'1'),
(4385, 'sisesc', 1, 'getpersona', '2024-02-16 14:56:42', b'1'),
(4386, 'sisesc', 1, 'getproveedor', '2024-02-16 14:56:42', b'1'),
(4387, 'sisesc', 1, 'getpersona', '2024-02-16 14:56:42', b'1'),
(4388, 'sisesc', 1, 'getcompra', '2024-02-16 14:57:12', b'1'),
(4389, 'sisesc', 1, 'selproveedor', '2024-02-16 14:57:12', b'1'),
(4390, 'sisesc', 1, 'getcompra', '2024-02-16 14:57:12', b'1'),
(4391, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:57:12', b'1'),
(4392, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:57:12', b'1'),
(4393, 'sisesc', 1, 'getproveedor', '2024-02-16 14:57:13', b'1'),
(4394, 'sisesc', 1, 'selproducto', '2024-02-16 14:57:13', b'1'),
(4395, 'sisesc', 1, 'selproveedor', '2024-02-16 14:57:13', b'1'),
(4396, 'sisesc', 1, 'getcompra', '2024-02-16 14:57:13', b'1'),
(4397, 'sisesc', 1, 'getpersona', '2024-02-16 14:57:13', b'1'),
(4398, 'sisesc', 1, 'getproveedor', '2024-02-16 14:57:13', b'1'),
(4399, 'sisesc', 1, 'selcompradetalle', '2024-02-16 14:57:13', b'1'),
(4400, 'sisesc', 1, 'getpersona', '2024-02-16 14:57:13', b'1'),
(4401, 'sisesc', 1, 'selproducto', '2024-02-16 14:57:13', b'1'),
(4402, 'sisesc', 1, 'getproveedor', '2024-02-16 14:57:13', b'1'),
(4403, 'sisesc', 1, 'getpersona', '2024-02-16 14:57:14', b'1'),
(4404, 'sisesc', 1, 'selusuario', '2024-02-18 15:26:49', b'1'),
(4405, 'sisesc', 1, 'selproducto', '2024-02-18 15:35:49', b'1'),
(4406, 'sisesc', 1, 'selusuario', '2024-02-18 15:37:47', b'1'),
(4407, 'sisesc', 1, 'selusuario', '2024-02-18 16:05:50', b'1'),
(4408, 'sisesc', 1, 'selusuario', '2024-02-18 16:25:17', b'1'),
(4409, 'sisesc', 1, 'selusuario', '2024-02-18 16:29:04', b'1'),
(4410, 'sisesc', 1, 'selusuario', '2024-02-18 16:38:39', b'1'),
(4411, 'sisesc', 1, 'selusuario', '2024-02-18 16:39:58', b'1'),
(4412, 'sisesc', 1, 'selproducto', '2024-02-18 16:39:59', b'1'),
(4413, 'sisesc', 1, 'selproducto', '2024-02-18 16:40:15', b'1'),
(4414, 'sisesc', 1, 'selproducto', '2024-02-18 16:40:26', b'1'),
(4415, 'sisesc', 1, 'selproducto', '2024-02-18 16:41:04', b'1'),
(4416, 'sisesc', 1, 'selproducto', '2024-02-18 16:41:08', b'1'),
(4417, 'sisesc', 1, 'selmarca', '2024-02-18 16:41:12', b'1'),
(4418, 'sisesc', 1, 'selproducto', '2024-02-18 16:41:15', b'1'),
(4419, 'sisesc', 1, 'getproducto', '2024-02-18 16:41:17', b'1'),
(4420, 'sisesc', 1, 'selmarca', '2024-02-18 16:41:17', b'1'),
(4421, 'sisesc', 1, 'selmarca', '2024-02-18 16:41:21', b'1'),
(4422, 'sisesc', 1, 'selmarca', '2024-02-18 16:43:27', b'1'),
(4423, 'sisesc', 1, 'selmarca', '2024-02-18 16:43:52', b'1'),
(4424, 'sisesc', 1, 'updmarca', '2024-02-18 16:43:59', b'1'),
(4425, 'sisesc', 1, 'selmarca', '2024-02-18 16:44:00', b'1'),
(4426, 'sisesc', 1, 'selproducto', '2024-02-18 16:45:43', b'1'),
(4427, 'sisesc', 1, 'selmarca', '2024-02-18 16:45:47', b'1'),
(4428, 'sisesc', 1, 'selmarca', '2024-02-18 16:45:57', b'1'),
(4429, 'sisesc', 1, 'selmarca', '2024-02-18 16:46:45', b'1'),
(4430, 'sisesc', 1, 'updmarca', '2024-02-18 16:46:48', b'1'),
(4431, 'sisesc', 1, 'selmarca', '2024-02-18 16:46:49', b'1'),
(4432, 'sisesc', 1, 'selmarca', '2024-02-18 16:47:00', b'1'),
(4433, 'sisesc', 1, 'selmarca', '2024-02-18 16:47:16', b'1'),
(4434, 'sisesc', 1, 'updmarca', '2024-02-18 16:47:19', b'1'),
(4435, 'sisesc', 1, 'selmarca', '2024-02-18 16:47:35', b'1'),
(4436, 'sisesc', 1, 'addmarca', '2024-02-18 16:47:44', b'1'),
(4437, 'sisesc', 1, 'selmarca', '2024-02-18 16:47:46', b'1'),
(4438, 'sisesc', 1, 'selmarca', '2024-02-18 16:47:58', b'1'),
(4439, 'sisesc', 1, 'selmarca', '2024-02-18 16:48:26', b'1'),
(4440, 'sisesc', 1, 'selproducto', '2024-02-18 16:48:28', b'1'),
(4441, 'sisesc', 1, 'getproducto', '2024-02-18 16:48:30', b'1'),
(4442, 'sisesc', 1, 'selmarca', '2024-02-18 16:48:30', b'1'),
(4443, 'sisesc', 1, 'getproducto', '2024-02-18 16:51:50', b'1'),
(4444, 'sisesc', 1, 'selmarca', '2024-02-18 16:51:50', b'1'),
(4445, 'sisesc', 1, 'selclasificacionproducto', '2024-02-18 16:51:51', b'1'),
(4446, 'sisesc', 1, 'selmarca', '2024-02-19 00:00:32', b'1'),
(4447, 'sisesc', 1, 'getmarca', '2024-02-19 00:00:37', b'1'),
(4448, 'sisesc', 1, 'selmarca', '2024-02-19 00:00:37', b'1'),
(4449, 'sisesc', 1, 'updmarca', '2024-02-19 00:00:43', b'1'),
(4450, 'sisesc', 1, 'selmarca', '2024-02-19 00:00:44', b'1'),
(4451, 'sisesc', 1, 'selmarca', '2024-02-19 00:01:09', b'1'),
(4452, 'sisesc', 1, 'seloficina', '2024-02-19 00:01:10', b'1'),
(4453, 'sisesc', 1, 'seloficina', '2024-02-19 00:01:39', b'1'),
(4454, 'sisesc', 1, 'selproducto', '2024-02-19 00:01:40', b'1'),
(4455, 'sisesc', 1, 'getproducto', '2024-02-19 00:01:42', b'1'),
(4456, 'sisesc', 1, 'selmarca', '2024-02-19 00:01:42', b'1'),
(4457, 'sisesc', 1, 'selclasificacionproducto', '2024-02-19 00:01:42', b'1'),
(4458, 'sisesc', 1, 'getproducto', '2024-02-19 00:03:10', b'1'),
(4459, 'sisesc', 1, 'selmarca', '2024-02-19 00:03:11', b'1'),
(4460, 'sisesc', 1, 'selclasificacionproducto', '2024-02-19 00:03:11', b'1'),
(4461, 'sisesc', 1, 'getproducto', '2024-02-19 00:03:31', b'1'),
(4462, 'sisesc', 1, 'selmarca', '2024-02-19 00:03:31', b'1'),
(4463, 'sisesc', 1, 'selclasificacionproducto', '2024-02-19 00:03:31', b'1'),
(4464, 'sisesc', 1, 'seloficina', '2024-02-19 00:03:37', b'1'),
(4465, 'sisesc', 1, 'selproducto', '2024-02-19 00:05:16', b'1'),
(4466, 'sisesc', 1, 'getproducto', '2024-02-19 00:05:18', b'1'),
(4467, 'sisesc', 1, 'selmarca', '2024-02-19 00:05:18', b'1'),
(4468, 'sisesc', 1, 'selclasificacionproducto', '2024-02-19 00:05:18', b'1'),
(4469, 'sisesc', 1, 'updproducto', '2024-02-19 00:05:23', b'1'),
(4470, 'sisesc', 1, 'selproducto', '2024-02-19 00:05:23', b'1'),
(4471, 'sisesc', 1, 'getproducto', '2024-02-19 00:05:25', b'1'),
(4472, 'sisesc', 1, 'selmarca', '2024-02-19 00:05:26', b'1'),
(4473, 'sisesc', 1, 'selclasificacionproducto', '2024-02-19 00:05:26', b'1'),
(4474, 'sisesc', 1, 'selproducto', '2024-02-19 00:05:29', b'1'),
(4475, 'sisesc', 1, 'selplandecuenta', '2024-02-19 00:16:45', b'1'),
(4476, 'sisesc', 1, 'selplandecuenta', '2024-02-19 00:17:19', b'1'),
(4477, 'sisesc', 1, 'selplandecuenta', '2024-02-19 00:17:49', b'1'),
(4478, 'sisesc', 1, 'seloficina', '2024-02-19 01:28:02', b'1'),
(4479, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:28:04', b'1'),
(4480, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:28:04', b'1'),
(4481, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:28:06', b'1'),
(4482, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:28:07', b'1'),
(4483, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:29:51', b'1'),
(4484, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:29:52', b'1'),
(4485, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:29:54', b'1'),
(4486, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:29:56', b'1'),
(4487, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:29:58', b'1'),
(4488, 'sisesc', 1, 'addplandecuenta', '2024-02-19 01:40:51', b'1'),
(4489, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:40:52', b'1'),
(4490, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:40:52', b'1'),
(4491, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:40:54', b'1'),
(4492, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:40:56', b'1'),
(4493, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:41:34', b'1'),
(4494, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:41:50', b'1'),
(4495, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:41:50', b'1'),
(4496, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:42:03', b'1'),
(4497, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:42:04', b'1'),
(4498, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:43:38', b'1'),
(4499, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:43:39', b'1'),
(4500, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:44:01', b'1'),
(4501, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:44:01', b'1'),
(4502, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:45:25', b'1'),
(4503, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:45:26', b'1'),
(4504, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:46:45', b'1'),
(4505, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:46:46', b'1'),
(4506, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:47:19', b'1'),
(4507, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:47:19', b'1'),
(4508, 'sisesc', 1, 'getplandecuenta', '2024-02-19 01:47:43', b'1'),
(4509, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:47:43', b'1'),
(4510, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:47:44', b'1'),
(4511, 'sisesc', 1, 'getplandecuenta', '2024-02-19 01:47:51', b'1'),
(4512, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:47:51', b'1'),
(4513, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:47:52', b'1'),
(4514, 'sisesc', 1, 'updplandecuenta', '2024-02-19 01:47:58', b'1'),
(4515, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:47:58', b'1'),
(4516, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:47:59', b'1'),
(4517, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:48:05', b'1'),
(4518, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:48:08', b'1'),
(4519, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:48:08', b'1'),
(4520, 'sisesc', 1, 'addplandecuenta', '2024-02-19 01:48:13', b'1'),
(4521, 'sisesc', 1, 'selparametrotipo', '2024-02-19 01:48:13', b'1'),
(4522, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:48:14', b'1'),
(4523, 'sisesc', 1, 'selplandecuenta', '2024-02-19 01:48:17', b'1'),
(4524, 'sisesc', 1, 'selparametrotipo', '2024-02-19 02:00:13', b'1'),
(4525, 'sisesc', 1, 'selplandecuenta', '2024-02-19 02:00:13', b'1'),
(4526, 'sisesc', 1, 'selusuario', '2024-02-19 02:00:24', b'1'),
(4527, 'sisesc', 1, 'selproducto', '2024-02-19 02:00:27', b'1'),
(4528, 'sisesc', 1, 'selmarca', '2024-02-19 02:00:29', b'1'),
(4529, 'sisesc', 1, 'seloficina', '2024-02-19 02:00:32', b'1'),
(4530, 'sisesc', 1, 'selparametrotipo', '2024-02-19 02:00:35', b'1'),
(4531, 'sisesc', 1, 'selplandecuenta', '2024-02-19 02:00:35', b'1'),
(4532, 'sisesc', 1, 'selplandecuenta', '2024-02-19 02:00:38', b'1'),
(4533, 'sisesc', 1, 'selproveedor', '2024-02-19 02:01:04', b'1'),
(4534, 'sisesc', 1, 'getproveedor', '2024-02-19 02:01:08', b'1'),
(4535, 'sisesc', 1, 'addcompra', '2024-02-19 02:01:08', b'1'),
(4536, 'sisesc', 1, 'getpersona', '2024-02-19 02:01:09', b'1'),
(4537, 'sisesc', 1, 'selproducto', '2024-02-19 02:01:09', b'1'),
(4538, 'sisesc', 1, 'getproducto', '2024-02-19 02:01:14', b'1'),
(4539, 'sisesc', 1, 'addcompradetalle', '2024-02-19 02:01:18', b'1'),
(4540, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:01:18', b'1'),
(4541, 'sisesc', 1, 'getproducto', '2024-02-19 02:01:21', b'1'),
(4542, 'sisesc', 1, 'addcompradetalle', '2024-02-19 02:01:26', b'1'),
(4543, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:01:26', b'1'),
(4544, 'sisesc', 1, 'papcompra', '2024-02-19 02:09:59', b'1'),
(4545, 'sisesc', 1, 'getproducto', '2024-02-19 02:10:18', b'1'),
(4546, 'sisesc', 1, 'selcompra', '2024-02-19 02:10:33', b'1'),
(4547, 'sisesc', 1, 'selproveedor', '2024-02-19 02:10:35', b'1'),
(4548, 'sisesc', 1, 'getcompra', '2024-02-19 02:10:35', b'1'),
(4549, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:10:36', b'1'),
(4550, 'sisesc', 1, 'selproducto', '2024-02-19 02:10:36', b'1'),
(4551, 'sisesc', 1, 'getproveedor', '2024-02-19 02:10:36', b'1'),
(4552, 'sisesc', 1, 'getpersona', '2024-02-19 02:10:36', b'1'),
(4553, 'sisesc', 1, 'selproveedor', '2024-02-19 02:11:55', b'1'),
(4554, 'sisesc', 1, 'getcompra', '2024-02-19 02:11:55', b'1'),
(4555, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:11:56', b'1'),
(4556, 'sisesc', 1, 'selcompra', '2024-02-19 02:12:29', b'1'),
(4557, 'sisesc', 1, 'selproveedor', '2024-02-19 02:12:31', b'1'),
(4558, 'sisesc', 1, 'getcompra', '2024-02-19 02:12:31', b'1'),
(4559, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:12:31', b'1'),
(4560, 'sisesc', 1, 'selproveedor', '2024-02-19 02:13:09', b'1'),
(4561, 'sisesc', 1, 'getcompra', '2024-02-19 02:13:09', b'1'),
(4562, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:13:10', b'1'),
(4563, 'sisesc', 1, 'selproducto', '2024-02-19 02:13:10', b'1'),
(4564, 'sisesc', 1, 'getproveedor', '2024-02-19 02:13:10', b'1'),
(4565, 'sisesc', 1, 'getpersona', '2024-02-19 02:13:11', b'1'),
(4566, 'sisesc', 1, 'selproveedor', '2024-02-19 02:13:41', b'1'),
(4567, 'sisesc', 1, 'getcompra', '2024-02-19 02:13:41', b'1'),
(4568, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:13:41', b'1'),
(4569, 'sisesc', 1, 'selproveedor', '2024-02-19 02:14:44', b'1'),
(4570, 'sisesc', 1, 'getcompra', '2024-02-19 02:14:44', b'1'),
(4571, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:14:45', b'1'),
(4572, 'sisesc', 1, 'selproveedor', '2024-02-19 02:15:40', b'1'),
(4573, 'sisesc', 1, 'getcompra', '2024-02-19 02:15:40', b'1'),
(4574, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:15:40', b'1'),
(4575, 'sisesc', 1, 'selproveedor', '2024-02-19 02:16:52', b'1'),
(4576, 'sisesc', 1, 'getcompra', '2024-02-19 02:16:52', b'1'),
(4577, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:16:52', b'1'),
(4578, 'sisesc', 1, 'selproveedor', '2024-02-19 02:17:01', b'1'),
(4579, 'sisesc', 1, 'getcompra', '2024-02-19 02:17:01', b'1'),
(4580, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:17:01', b'1'),
(4581, 'sisesc', 1, 'selproveedor', '2024-02-19 02:17:46', b'1'),
(4582, 'sisesc', 1, 'getcompra', '2024-02-19 02:17:46', b'1'),
(4583, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:17:46', b'1'),
(4584, 'sisesc', 1, 'selproducto', '2024-02-19 02:17:47', b'1'),
(4585, 'sisesc', 1, 'getproveedor', '2024-02-19 02:17:47', b'1'),
(4586, 'sisesc', 1, 'getpersona', '2024-02-19 02:17:47', b'1'),
(4587, 'sisesc', 1, 'selproveedor', '2024-02-19 02:18:11', b'1'),
(4588, 'sisesc', 1, 'addcompra', '2024-02-19 02:18:14', b'1'),
(4589, 'sisesc', 1, 'getproveedor', '2024-02-19 02:18:14', b'1'),
(4590, 'sisesc', 1, 'selproducto', '2024-02-19 02:18:14', b'1'),
(4591, 'sisesc', 1, 'getpersona', '2024-02-19 02:18:14', b'1'),
(4592, 'sisesc', 1, 'getproducto', '2024-02-19 02:18:20', b'1'),
(4593, 'sisesc', 1, 'addcompradetalle', '2024-02-19 02:18:23', b'1'),
(4594, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:18:23', b'1'),
(4595, 'sisesc', 1, 'papcompra', '2024-02-19 02:18:27', b'1'),
(4596, 'sisesc', 1, 'selcompra', '2024-02-19 02:20:46', b'1'),
(4597, 'sisesc', 1, 'selproveedor', '2024-02-19 02:20:48', b'1'),
(4598, 'sisesc', 1, 'getcompra', '2024-02-19 02:20:48', b'1'),
(4599, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:20:49', b'1'),
(4600, 'sisesc', 1, 'selproducto', '2024-02-19 02:20:49', b'1'),
(4601, 'sisesc', 1, 'getproveedor', '2024-02-19 02:20:49', b'1'),
(4602, 'sisesc', 1, 'getpersona', '2024-02-19 02:20:49', b'1'),
(4603, 'sisesc', 1, 'getcompra', '2024-02-19 02:20:57', b'1'),
(4604, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:20:57', b'1'),
(4605, 'sisesc', 1, 'getproveedor', '2024-02-19 02:20:57', b'1'),
(4606, 'sisesc', 1, 'getpersona', '2024-02-19 02:20:58', b'1'),
(4607, 'sisesc', 1, 'selproveedor', '2024-02-19 02:22:35', b'1'),
(4608, 'sisesc', 1, 'getcompra', '2024-02-19 02:22:35', b'1'),
(4609, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:22:36', b'1'),
(4610, 'sisesc', 1, 'selproducto', '2024-02-19 02:22:36', b'1'),
(4611, 'sisesc', 1, 'getproveedor', '2024-02-19 02:22:36', b'1'),
(4612, 'sisesc', 1, 'getpersona', '2024-02-19 02:22:36', b'1'),
(4613, 'sisesc', 1, 'selproveedor', '2024-02-19 02:22:58', b'1'),
(4614, 'sisesc', 1, 'getcompra', '2024-02-19 02:22:58', b'1'),
(4615, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:22:58', b'1'),
(4616, 'sisesc', 1, 'selproducto', '2024-02-19 02:22:59', b'1'),
(4617, 'sisesc', 1, 'getproveedor', '2024-02-19 02:22:59', b'1'),
(4618, 'sisesc', 1, 'getpersona', '2024-02-19 02:22:59', b'1'),
(4619, 'sisesc', 1, 'selcompra', '2024-02-19 02:24:15', b'1'),
(4620, 'sisesc', 1, 'selcompra', '2024-02-19 02:26:11', b'1'),
(4621, 'sisesc', 1, 'selcompra', '2024-02-19 02:26:28', b'1'),
(4622, 'sisesc', 1, 'selcompra', '2024-02-19 02:26:40', b'1'),
(4623, 'sisesc', 1, 'selproveedor', '2024-02-19 02:26:49', b'1'),
(4624, 'sisesc', 1, 'getcompra', '2024-02-19 02:26:49', b'1'),
(4625, 'sisesc', 1, 'selcompradetalle', '2024-02-19 02:26:49', b'1'),
(4626, 'sisesc', 1, 'selproducto', '2024-02-19 02:26:50', b'1'),
(4627, 'sisesc', 1, 'getproveedor', '2024-02-19 02:26:50', b'1'),
(4628, 'sisesc', 1, 'getpersona', '2024-02-19 02:26:50', b'1'),
(4629, 'sisesc', 1, 'seloficina', '2024-02-19 02:26:55', b'1'),
(4630, 'sisesc', 1, 'seloficina', '2024-02-19 02:55:35', b'1'),
(4631, 'sisesc', 1, 'seloficina', '2024-02-19 03:06:25', b'1'),
(4632, 'sisesc', 1, 'selproveedor', '2024-02-19 03:06:34', b'1'),
(4633, 'sisesc', 1, 'getproveedor', '2024-02-19 03:06:36', b'1'),
(4634, 'sisesc', 1, 'addcompra', '2024-02-19 03:06:36', b'1'),
(4635, 'sisesc', 1, 'getpersona', '2024-02-19 03:06:36', b'1'),
(4636, 'sisesc', 1, 'selproducto', '2024-02-19 03:06:37', b'1'),
(4637, 'sisesc', 1, 'getproducto', '2024-02-19 03:06:39', b'1'),
(4638, 'sisesc', 1, 'addcompradetalle', '2024-02-19 03:06:46', b'1'),
(4639, 'sisesc', 1, 'selcompradetalle', '2024-02-19 03:06:47', b'1'),
(4640, 'sisesc', 1, 'papcompra', '2024-02-19 03:06:51', b'1'),
(4641, 'sisesc', 1, 'selproveedor', '2024-02-19 03:07:36', b'1'),
(4642, 'sisesc', 1, 'getcompra', '2024-02-19 03:07:36', b'1'),
(4643, 'sisesc', 1, 'selcompradetalle', '2024-02-19 03:07:36', b'1'),
(4644, 'sisesc', 1, 'selproducto', '2024-02-19 03:07:37', b'1'),
(4645, 'sisesc', 1, 'getproveedor', '2024-02-19 03:07:37', b'1'),
(4646, 'sisesc', 1, 'getpersona', '2024-02-19 03:07:37', b'1'),
(4647, 'sisesc', 1, 'seloficina', '2024-02-19 03:36:00', b'1'),
(4648, 'sisesc', 1, 'selproveedor', '2024-02-19 03:36:02', b'1'),
(4649, 'sisesc', 1, 'getproveedor', '2024-02-19 03:36:03', b'1'),
(4650, 'sisesc', 1, 'addcompra', '2024-02-19 03:36:03', b'1'),
(4651, 'sisesc', 1, 'getpersona', '2024-02-19 03:36:03', b'1'),
(4652, 'sisesc', 1, 'selproducto', '2024-02-19 03:36:03', b'1'),
(4653, 'sisesc', 1, 'getproducto', '2024-02-19 03:36:05', b'1'),
(4654, 'sisesc', 1, 'addcompradetalle', '2024-02-19 03:36:10', b'1'),
(4655, 'sisesc', 1, 'selcompradetalle', '2024-02-19 03:36:11', b'1'),
(4656, 'sisesc', 1, 'papcompra', '2024-02-19 03:36:14', b'1'),
(4657, 'sisesc', 1, 'selproveedor', '2024-02-19 03:39:37', b'1'),
(4658, 'sisesc', 1, 'getcompra', '2024-02-19 03:39:37', b'1'),
(4659, 'sisesc', 1, 'selcompradetalle', '2024-02-19 03:39:38', b'1'),
(4660, 'sisesc', 1, 'selproducto', '2024-02-19 03:39:38', b'1'),
(4661, 'sisesc', 1, 'getproveedor', '2024-02-19 03:39:38', b'1'),
(4662, 'sisesc', 1, 'getpersona', '2024-02-19 03:39:38', b'1'),
(4663, 'sisesc', 1, 'selproveedor', '2024-02-19 03:39:45', b'1'),
(4664, 'sisesc', 1, 'getcompra', '2024-02-19 03:39:45', b'1'),
(4665, 'sisesc', 1, 'selcompradetalle', '2024-02-19 03:39:45', b'1'),
(4666, 'sisesc', 1, 'selproducto', '2024-02-19 03:39:45', b'1'),
(4667, 'sisesc', 1, 'getproveedor', '2024-02-19 03:39:46', b'1'),
(4668, 'sisesc', 1, 'getpersona', '2024-02-19 03:39:46', b'1'),
(4669, 'sisesc', 1, 'selproveedor', '2024-02-19 03:42:12', b'1'),
(4670, 'sisesc', 1, 'getcompra', '2024-02-19 03:42:12', b'1'),
(4671, 'sisesc', 1, 'selcompradetalle', '2024-02-19 03:42:13', b'1'),
(4672, 'sisesc', 1, 'selproducto', '2024-02-19 03:42:13', b'1'),
(4673, 'sisesc', 1, 'getproveedor', '2024-02-19 03:42:13', b'1'),
(4674, 'sisesc', 1, 'getpersona', '2024-02-19 03:42:14', b'1'),
(4675, 'sisesc', 1, 'seloficina', '2024-02-19 03:47:12', b'1'),
(4676, 'sisesc', 1, 'selproveedor', '2024-02-19 03:47:14', b'1'),
(4677, 'sisesc', 1, 'getproveedor', '2024-02-19 03:47:16', b'1'),
(4678, 'sisesc', 1, 'addcompra', '2024-02-19 03:47:16', b'1'),
(4679, 'sisesc', 1, 'getpersona', '2024-02-19 03:47:16', b'1'),
(4680, 'sisesc', 1, 'selproducto', '2024-02-19 03:47:16', b'1'),
(4681, 'sisesc', 1, 'getproducto', '2024-02-19 03:47:18', b'1'),
(4682, 'sisesc', 1, 'addcompradetalle', '2024-02-19 03:47:21', b'1'),
(4683, 'sisesc', 1, 'selcompradetalle', '2024-02-19 03:47:22', b'1'),
(4684, 'sisesc', 1, 'papcompra', '2024-02-19 03:47:23', b'1'),
(4685, 'sisesc', 1, 'selproveedor', '2024-02-19 03:49:09', b'1'),
(4686, 'sisesc', 1, 'getcompra', '2024-02-19 03:49:09', b'1'),
(4687, 'sisesc', 1, 'selcompradetalle', '2024-02-19 03:49:10', b'1'),
(4688, 'sisesc', 1, 'selproducto', '2024-02-19 03:49:10', b'1'),
(4689, 'sisesc', 1, 'getproveedor', '2024-02-19 03:49:10', b'1'),
(4690, 'sisesc', 1, 'getpersona', '2024-02-19 03:49:10', b'1'),
(4691, 'sisesc', 1, 'seloficina', '2024-02-19 03:49:13', b'1'),
(4692, 'sisesc', 1, 'seloficina', '2024-02-19 03:49:43', b'1'),
(4693, 'sisesc', 1, 'seloficina', '2024-02-19 03:50:00', b'1'),
(4694, 'sisesc', 1, 'selproveedor', '2024-02-19 03:50:02', b'1'),
(4695, 'sisesc', 1, 'getproveedor', '2024-02-19 03:50:04', b'1'),
(4696, 'sisesc', 1, 'addcompra', '2024-02-19 03:50:04', b'1'),
(4697, 'sisesc', 1, 'getpersona', '2024-02-19 03:50:04', b'1'),
(4698, 'sisesc', 1, 'selproducto', '2024-02-19 03:50:04', b'1'),
(4699, 'sisesc', 1, 'getproducto', '2024-02-19 03:50:06', b'1'),
(4700, 'sisesc', 1, 'addcompradetalle', '2024-02-19 03:50:09', b'1'),
(4701, 'sisesc', 1, 'selcompradetalle', '2024-02-19 03:50:09', b'1'),
(4702, 'sisesc', 1, 'papcompra', '2024-02-19 03:50:12', b'1'),
(4703, 'sisesc', 1, 'seloficina', '2024-02-24 19:48:51', b'1'),
(4704, 'sisesc', 1, 'selusuario', '2024-02-24 19:48:52', b'1'),
(4705, 'sisesc', 1, 'selproducto', '2024-02-24 19:49:12', b'1'),
(4706, 'sisesc', 1, 'selmarca', '2024-02-24 19:49:15', b'1'),
(4707, 'sisesc', 1, 'selclasificacionproducto', '2024-02-24 19:49:15', b'1'),
(4708, 'sisesc', 1, 'selmarca', '2024-02-24 19:49:19', b'1'),
(4709, 'sisesc', 1, 'selmarca', '2024-02-24 19:49:21', b'1'),
(4710, 'sisesc', 1, 'selmarca', '2024-02-24 19:49:25', b'1'),
(4711, 'sisesc', 1, 'seloficina', '2024-02-24 19:49:31', b'1'),
(4712, 'sisesc', 1, 'selparametrotipo', '2024-02-24 19:49:35', b'1'),
(4713, 'sisesc', 1, 'selplandecuenta', '2024-02-24 19:49:35', b'1'),
(4714, 'sisesc', 1, 'selplandecuenta', '2024-02-24 19:49:39', b'1'),
(4715, 'sisesc', 1, 'selplandecuenta', '2024-02-24 19:49:42', b'1'),
(4716, 'sisesc', 1, 'selproveedor', '2024-02-24 19:49:45', b'1'),
(4717, 'sisesc', 1, 'selcompra', '2024-02-24 19:49:49', b'1'),
(4718, 'sisesc', 1, 'seloficina', '2024-02-24 20:04:06', b'1'),
(4719, 'sisesc', 1, 'selproveedor', '2024-02-24 20:04:10', b'1'),
(4720, 'sisesc', 1, 'selproveedor', '2024-02-24 20:04:14', b'1'),
(4721, 'sisesc', 1, 'selcompra', '2024-02-24 20:04:16', b'1'),
(4722, 'sisesc', 1, 'seloficina', '2024-02-24 20:04:18', b'1'),
(4723, 'sisesc', 1, 'selproveedor', '2024-02-24 20:04:33', b'1'),
(4724, 'sisesc', 1, 'selcompra', '2024-02-24 20:04:38', b'1'),
(4725, 'sisesc', 1, 'selproveedor', '2024-02-24 20:04:39', b'1'),
(4726, 'sisesc', 1, 'selcompra', '2024-02-24 20:04:41', b'1'),
(4727, 'sisesc', 1, 'selproveedor', '2024-02-24 20:04:42', b'1'),
(4728, 'sisesc', 1, 'getproveedor', '2024-02-24 20:04:46', b'1'),
(4729, 'sisesc', 1, 'getpersona', '2024-02-24 20:04:46', b'1'),
(4730, 'sisesc', 1, 'addcompra', '2024-02-24 20:04:46', b'1'),
(4731, 'sisesc', 1, 'selproducto', '2024-02-24 20:04:47', b'1'),
(4732, 'sisesc', 1, 'getproducto', '2024-02-24 20:09:53', b'1'),
(4733, 'sisesc', 1, 'addcompradetalle', '2024-02-24 20:10:07', b'1'),
(4734, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:10:07', b'1'),
(4735, 'sisesc', 1, 'papcompra', '2024-02-24 20:10:11', b'1'),
(4736, 'sisesc', 1, 'selproveedor', '2024-02-24 20:13:33', b'1'),
(4737, 'sisesc', 1, 'getcompra', '2024-02-24 20:13:33', b'1'),
(4738, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:13:33', b'1'),
(4739, 'sisesc', 1, 'selproducto', '2024-02-24 20:13:34', b'1'),
(4740, 'sisesc', 1, 'getproveedor', '2024-02-24 20:13:34', b'1'),
(4741, 'sisesc', 1, 'getpersona', '2024-02-24 20:13:34', b'1'),
(4742, 'sisesc', 1, 'selproveedor', '2024-02-24 20:13:56', b'1'),
(4743, 'sisesc', 1, 'getcompra', '2024-02-24 20:13:56', b'1'),
(4744, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:13:56', b'1'),
(4745, 'sisesc', 1, 'selproducto', '2024-02-24 20:13:57', b'1'),
(4746, 'sisesc', 1, 'getproveedor', '2024-02-24 20:13:57', b'1'),
(4747, 'sisesc', 1, 'getpersona', '2024-02-24 20:13:57', b'1'),
(4748, 'sisesc', 1, 'papcompra', '2024-02-24 20:14:02', b'1'),
(4749, 'sisesc', 1, 'selcompra', '2024-02-24 20:14:08', b'1'),
(4750, 'sisesc', 1, 'selproveedor', '2024-02-24 20:14:11', b'1'),
(4751, 'sisesc', 1, 'getcompra', '2024-02-24 20:14:11', b'1'),
(4752, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:14:12', b'1'),
(4753, 'sisesc', 1, 'selproducto', '2024-02-24 20:14:12', b'1'),
(4754, 'sisesc', 1, 'getproveedor', '2024-02-24 20:14:12', b'1'),
(4755, 'sisesc', 1, 'getpersona', '2024-02-24 20:14:12', b'1'),
(4756, 'sisesc', 1, 'selproveedor', '2024-02-24 20:14:40', b'1'),
(4757, 'sisesc', 1, 'getcompra', '2024-02-24 20:14:40', b'1'),
(4758, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:14:41', b'1'),
(4759, 'sisesc', 1, 'selproducto', '2024-02-24 20:14:41', b'1'),
(4760, 'sisesc', 1, 'getproveedor', '2024-02-24 20:14:41', b'1'),
(4761, 'sisesc', 1, 'getpersona', '2024-02-24 20:14:42', b'1'),
(4762, 'sisesc', 1, 'papcompra', '2024-02-24 20:14:43', b'1'),
(4763, 'sisesc', 1, 'selproveedor', '2024-02-24 20:14:45', b'1'),
(4764, 'sisesc', 1, 'getcompra', '2024-02-24 20:14:45', b'1'),
(4765, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:14:45', b'1'),
(4766, 'sisesc', 1, 'selproducto', '2024-02-24 20:14:46', b'1'),
(4767, 'sisesc', 1, 'getproveedor', '2024-02-24 20:14:46', b'1'),
(4768, 'sisesc', 1, 'getpersona', '2024-02-24 20:14:46', b'1'),
(4769, 'sisesc', 1, 'selproveedor', '2024-02-24 20:16:07', b'1'),
(4770, 'sisesc', 1, 'getcompra', '2024-02-24 20:16:07', b'1'),
(4771, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:16:07', b'1'),
(4772, 'sisesc', 1, 'selproducto', '2024-02-24 20:16:07', b'1'),
(4773, 'sisesc', 1, 'getproveedor', '2024-02-24 20:16:07', b'1'),
(4774, 'sisesc', 1, 'getpersona', '2024-02-24 20:16:08', b'1'),
(4775, 'sisesc', 1, 'papcompra', '2024-02-24 20:16:11', b'1'),
(4776, 'sisesc', 1, 'selproveedor', '2024-02-24 20:16:11', b'1'),
(4777, 'sisesc', 1, 'getcompra', '2024-02-24 20:16:11', b'1'),
(4778, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:16:12', b'1'),
(4779, 'sisesc', 1, 'selproducto', '2024-02-24 20:16:12', b'1'),
(4780, 'sisesc', 1, 'getproveedor', '2024-02-24 20:16:12', b'1'),
(4781, 'sisesc', 1, 'getpersona', '2024-02-24 20:16:12', b'1'),
(4782, 'sisesc', 1, 'selproveedor', '2024-02-24 20:17:06', b'1'),
(4783, 'sisesc', 1, 'getcompra', '2024-02-24 20:17:06', b'1'),
(4784, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:17:06', b'1'),
(4785, 'sisesc', 1, 'selproducto', '2024-02-24 20:17:07', b'1'),
(4786, 'sisesc', 1, 'getproveedor', '2024-02-24 20:17:07', b'1'),
(4787, 'sisesc', 1, 'getpersona', '2024-02-24 20:17:07', b'1'),
(4788, 'sisesc', 1, 'selcompra', '2024-02-24 20:17:10', b'1'),
(4789, 'sisesc', 1, 'selproveedor', '2024-02-24 20:17:13', b'1'),
(4790, 'sisesc', 1, 'getproveedor', '2024-02-24 20:17:16', b'1'),
(4791, 'sisesc', 1, 'getpersona', '2024-02-24 20:17:16', b'1'),
(4792, 'sisesc', 1, 'addcompra', '2024-02-24 20:17:17', b'1'),
(4793, 'sisesc', 1, 'selproducto', '2024-02-24 20:17:17', b'1'),
(4794, 'sisesc', 1, 'selproveedor', '2024-02-24 20:17:17', b'1'),
(4795, 'sisesc', 1, 'selproveedor', '2024-02-24 20:17:53', b'1'),
(4796, 'sisesc', 1, 'selcompra', '2024-02-24 20:18:03', b'1'),
(4797, 'sisesc', 1, 'selproveedor', '2024-02-24 20:18:06', b'1'),
(4798, 'sisesc', 1, 'getcompra', '2024-02-24 20:18:06', b'1'),
(4799, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:18:07', b'1'),
(4800, 'sisesc', 1, 'selproducto', '2024-02-24 20:18:07', b'1'),
(4801, 'sisesc', 1, 'getproveedor', '2024-02-24 20:18:07', b'1'),
(4802, 'sisesc', 1, 'getpersona', '2024-02-24 20:18:07', b'1'),
(4803, 'sisesc', 1, 'papcompra', '2024-02-24 20:18:12', b'1'),
(4804, 'sisesc', 1, 'selproveedor', '2024-02-24 20:18:12', b'1'),
(4805, 'sisesc', 1, 'getcompra', '2024-02-24 20:18:12', b'1'),
(4806, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:18:12', b'1'),
(4807, 'sisesc', 1, 'selproducto', '2024-02-24 20:18:13', b'1'),
(4808, 'sisesc', 1, 'getproveedor', '2024-02-24 20:18:13', b'1'),
(4809, 'sisesc', 1, 'getpersona', '2024-02-24 20:18:13', b'1'),
(4810, 'sisesc', 1, 'papcompra', '2024-02-24 20:22:12', b'1'),
(4811, 'sisesc', 1, 'selproveedor', '2024-02-24 20:22:13', b'1'),
(4812, 'sisesc', 1, 'getcompra', '2024-02-24 20:22:13', b'1'),
(4813, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:22:13', b'1'),
(4814, 'sisesc', 1, 'selproducto', '2024-02-24 20:22:14', b'1'),
(4815, 'sisesc', 1, 'getproveedor', '2024-02-24 20:22:14', b'1'),
(4816, 'sisesc', 1, 'getpersona', '2024-02-24 20:22:14', b'1'),
(4817, 'sisesc', 1, 'selcompra', '2024-02-24 20:22:18', b'1'),
(4818, 'sisesc', 1, 'selproveedor', '2024-02-24 20:22:21', b'1'),
(4819, 'sisesc', 1, 'getcompra', '2024-02-24 20:22:21', b'1'),
(4820, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:22:21', b'1'),
(4821, 'sisesc', 1, 'selproducto', '2024-02-24 20:22:21', b'1'),
(4822, 'sisesc', 1, 'getproveedor', '2024-02-24 20:22:22', b'1'),
(4823, 'sisesc', 1, 'getpersona', '2024-02-24 20:22:22', b'1'),
(4824, 'sisesc', 1, 'getcompra', '2024-02-24 20:22:35', b'1'),
(4825, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:22:35', b'1'),
(4826, 'sisesc', 1, 'getproveedor', '2024-02-24 20:22:35', b'1'),
(4827, 'sisesc', 1, 'getpersona', '2024-02-24 20:22:35', b'1'),
(4828, 'sisesc', 1, 'getcompra', '2024-02-24 20:23:14', b'1'),
(4829, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:23:14', b'1'),
(4830, 'sisesc', 1, 'getproveedor', '2024-02-24 20:23:14', b'1'),
(4831, 'sisesc', 1, 'getpersona', '2024-02-24 20:23:15', b'1'),
(4832, 'sisesc', 1, 'getcompra', '2024-02-24 20:23:38', b'1'),
(4833, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:23:39', b'1'),
(4834, 'sisesc', 1, 'getproveedor', '2024-02-24 20:23:39', b'1'),
(4835, 'sisesc', 1, 'getpersona', '2024-02-24 20:23:39', b'1'),
(4836, 'sisesc', 1, 'selproveedor', '2024-02-24 20:26:10', b'1'),
(4837, 'sisesc', 1, 'getcompra', '2024-02-24 20:26:10', b'1'),
(4838, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:26:10', b'1'),
(4839, 'sisesc', 1, 'selproducto', '2024-02-24 20:26:11', b'1'),
(4840, 'sisesc', 1, 'getproveedor', '2024-02-24 20:26:11', b'1'),
(4841, 'sisesc', 1, 'getpersona', '2024-02-24 20:26:11', b'1'),
(4842, 'sisesc', 1, 'selcompra', '2024-02-24 20:26:12', b'1'),
(4843, 'sisesc', 1, 'selcompra', '2024-02-24 20:26:27', b'1'),
(4844, 'sisesc', 1, 'selcompra', '2024-02-24 20:26:39', b'1'),
(4845, 'sisesc', 1, 'selproveedor', '2024-02-24 20:28:52', b'1'),
(4846, 'sisesc', 1, 'getcompra', '2024-02-24 20:28:52', b'1'),
(4847, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:28:52', b'1'),
(4848, 'sisesc', 1, 'selproducto', '2024-02-24 20:28:52', b'1'),
(4849, 'sisesc', 1, 'getproveedor', '2024-02-24 20:28:53', b'1'),
(4850, 'sisesc', 1, 'getpersona', '2024-02-24 20:28:53', b'1'),
(4851, 'sisesc', 1, 'seloficina', '2024-02-24 20:28:54', b'1'),
(4852, 'sisesc', 1, 'selproveedor', '2024-02-24 20:28:56', b'1'),
(4853, 'sisesc', 1, 'getcompra', '2024-02-24 20:28:56', b'1'),
(4854, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:28:56', b'1'),
(4855, 'sisesc', 1, 'selproducto', '2024-02-24 20:28:57', b'1'),
(4856, 'sisesc', 1, 'getproveedor', '2024-02-24 20:28:57', b'1'),
(4857, 'sisesc', 1, 'getpersona', '2024-02-24 20:28:57', b'1'),
(4858, 'sisesc', 1, 'getcompra', '2024-02-24 20:37:10', b'1'),
(4859, 'sisesc', 1, 'selproveedor', '2024-02-24 20:37:10', b'1'),
(4860, 'sisesc', 1, 'selcompradetalle', '2024-02-24 20:37:10', b'1'),
(4861, 'sisesc', 1, 'selproducto', '2024-02-24 20:37:11', b'1'),
(4862, 'sisesc', 1, 'getproveedor', '2024-02-24 20:37:11', b'1'),
(4863, 'sisesc', 1, 'getpersona', '2024-02-24 20:37:11', b'1'),
(4864, 'sisesc', 1, 'seloficina', '2024-02-24 20:37:24', b'1'),
(4865, 'sisesc', 1, 'getcompra', '2024-02-24 20:38:07', b'1'),
(4866, 'sisesc', 1, 'getcompra', '2024-02-24 20:45:23', b'1'),
(4867, 'sisesc', 1, 'selpagocompra', '2024-02-24 20:45:23', b'1'),
(4868, 'sisesc', 1, 'getproveedor', '2024-02-24 20:45:24', b'1'),
(4869, 'sisesc', 1, 'getpersona', '2024-02-24 20:45:24', b'1'),
(4870, 'sisesc', 1, 'getcompra', '2024-02-24 20:45:24', b'1'),
(4871, 'sisesc', 1, 'pappagocompra', '2024-02-24 20:46:11', b'1'),
(4872, 'sisesc', 1, 'getcompra', '2024-02-24 21:08:59', b'1'),
(4873, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:08:59', b'1'),
(4874, 'sisesc', 1, 'getproveedor', '2024-02-24 21:08:59', b'1'),
(4875, 'sisesc', 1, 'getpersona', '2024-02-24 21:08:59', b'1'),
(4876, 'sisesc', 1, 'getcompra', '2024-02-24 21:09:00', b'1'),
(4877, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:09:05', b'1'),
(4878, 'sisesc', 1, 'getcompra', '2024-02-24 21:11:01', b'1'),
(4879, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:11:01', b'1'),
(4880, 'sisesc', 1, 'getproveedor', '2024-02-24 21:11:01', b'1'),
(4881, 'sisesc', 1, 'getpersona', '2024-02-24 21:11:01', b'1'),
(4882, 'sisesc', 1, 'getcompra', '2024-02-24 21:11:02', b'1'),
(4883, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:11:05', b'1'),
(4884, 'sisesc', 1, 'getcompra', '2024-02-24 21:16:57', b'1'),
(4885, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:16:57', b'1'),
(4886, 'sisesc', 1, 'getproveedor', '2024-02-24 21:16:58', b'1'),
(4887, 'sisesc', 1, 'getpersona', '2024-02-24 21:16:58', b'1'),
(4888, 'sisesc', 1, 'getcompra', '2024-02-24 21:16:58', b'1'),
(4889, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:17:01', b'1'),
(4890, 'sisesc', 1, 'getcompra', '2024-02-24 21:19:34', b'1'),
(4891, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:19:34', b'1'),
(4892, 'sisesc', 1, 'getproveedor', '2024-02-24 21:19:35', b'1'),
(4893, 'sisesc', 1, 'getpersona', '2024-02-24 21:19:35', b'1'),
(4894, 'sisesc', 1, 'getcompra', '2024-02-24 21:19:35', b'1'),
(4895, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:19:38', b'1'),
(4896, 'sisesc', 1, 'getcompra', '2024-02-24 21:20:44', b'1'),
(4897, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:20:44', b'1'),
(4898, 'sisesc', 1, 'getproveedor', '2024-02-24 21:20:44', b'1'),
(4899, 'sisesc', 1, 'getpersona', '2024-02-24 21:20:44', b'1'),
(4900, 'sisesc', 1, 'getcompra', '2024-02-24 21:20:45', b'1'),
(4901, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:20:46', b'1'),
(4902, 'sisesc', 1, 'getcompra', '2024-02-24 21:21:54', b'1');
INSERT INTO `seg_tbllogusuario` (`idlogusuario`, `nombresistema`, `idusuario`, `nombreservicio`, `fecharegistro`, `estadoregistro`) VALUES
(4903, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:21:54', b'1'),
(4904, 'sisesc', 1, 'getproveedor', '2024-02-24 21:21:55', b'1'),
(4905, 'sisesc', 1, 'getpersona', '2024-02-24 21:21:55', b'1'),
(4906, 'sisesc', 1, 'getcompra', '2024-02-24 21:21:55', b'1'),
(4907, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:21:59', b'1'),
(4908, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:21:59', b'1'),
(4909, 'sisesc', 1, 'getcompra', '2024-02-24 21:22:00', b'1'),
(4910, 'sisesc', 1, 'getcompra', '2024-02-24 21:22:20', b'1'),
(4911, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:22:20', b'1'),
(4912, 'sisesc', 1, 'getproveedor', '2024-02-24 21:22:20', b'1'),
(4913, 'sisesc', 1, 'getpersona', '2024-02-24 21:22:21', b'1'),
(4914, 'sisesc', 1, 'getcompra', '2024-02-24 21:22:21', b'1'),
(4915, 'sisesc', 1, 'getcompra', '2024-02-24 21:23:19', b'1'),
(4916, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:23:19', b'1'),
(4917, 'sisesc', 1, 'getproveedor', '2024-02-24 21:23:19', b'1'),
(4918, 'sisesc', 1, 'getpersona', '2024-02-24 21:23:19', b'1'),
(4919, 'sisesc', 1, 'getcompra', '2024-02-24 21:23:20', b'1'),
(4920, 'sisesc', 1, 'getcompra', '2024-02-24 21:23:28', b'1'),
(4921, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:23:28', b'1'),
(4922, 'sisesc', 1, 'getproveedor', '2024-02-24 21:23:28', b'1'),
(4923, 'sisesc', 1, 'getpersona', '2024-02-24 21:23:29', b'1'),
(4924, 'sisesc', 1, 'getcompra', '2024-02-24 21:23:29', b'1'),
(4925, 'sisesc', 1, 'getcompra', '2024-02-24 21:24:38', b'1'),
(4926, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:24:39', b'1'),
(4927, 'sisesc', 1, 'getproveedor', '2024-02-24 21:24:39', b'1'),
(4928, 'sisesc', 1, 'getpersona', '2024-02-24 21:24:39', b'1'),
(4929, 'sisesc', 1, 'getcompra', '2024-02-24 21:24:39', b'1'),
(4930, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:28:26', b'1'),
(4931, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:28:26', b'1'),
(4932, 'sisesc', 1, 'getcompra', '2024-02-24 21:28:26', b'1'),
(4933, 'sisesc', 1, 'getcompra', '2024-02-24 21:28:51', b'1'),
(4934, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:28:51', b'1'),
(4935, 'sisesc', 1, 'getproveedor', '2024-02-24 21:28:52', b'1'),
(4936, 'sisesc', 1, 'getpersona', '2024-02-24 21:28:52', b'1'),
(4937, 'sisesc', 1, 'getcompra', '2024-02-24 21:28:52', b'1'),
(4938, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:29:10', b'1'),
(4939, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:29:10', b'1'),
(4940, 'sisesc', 1, 'getcompra', '2024-02-24 21:29:10', b'1'),
(4941, 'sisesc', 1, 'getcompra', '2024-02-24 21:29:17', b'1'),
(4942, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:29:18', b'1'),
(4943, 'sisesc', 1, 'getproveedor', '2024-02-24 21:29:18', b'1'),
(4944, 'sisesc', 1, 'getpersona', '2024-02-24 21:29:18', b'1'),
(4945, 'sisesc', 1, 'getcompra', '2024-02-24 21:29:18', b'1'),
(4946, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:30:14', b'1'),
(4947, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:30:14', b'1'),
(4948, 'sisesc', 1, 'getcompra', '2024-02-24 21:30:15', b'1'),
(4949, 'sisesc', 1, 'getcompra', '2024-02-24 21:31:28', b'1'),
(4950, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:31:28', b'1'),
(4951, 'sisesc', 1, 'getproveedor', '2024-02-24 21:31:28', b'1'),
(4952, 'sisesc', 1, 'getpersona', '2024-02-24 21:31:29', b'1'),
(4953, 'sisesc', 1, 'selcompra', '2024-02-24 21:31:29', b'1'),
(4954, 'sisesc', 1, 'getcompra', '2024-02-24 21:31:29', b'1'),
(4955, 'sisesc', 1, 'selproveedor', '2024-02-24 21:31:31', b'1'),
(4956, 'sisesc', 1, 'getcompra', '2024-02-24 21:31:31', b'1'),
(4957, 'sisesc', 1, 'selcompradetalle', '2024-02-24 21:31:32', b'1'),
(4958, 'sisesc', 1, 'selproducto', '2024-02-24 21:31:32', b'1'),
(4959, 'sisesc', 1, 'getproveedor', '2024-02-24 21:31:32', b'1'),
(4960, 'sisesc', 1, 'getpersona', '2024-02-24 21:31:32', b'1'),
(4961, 'sisesc', 1, 'addcompradetalle', '2024-02-24 21:31:38', b'1'),
(4962, 'sisesc', 1, 'selcompradetalle', '2024-02-24 21:31:38', b'1'),
(4963, 'sisesc', 1, 'papcompra', '2024-02-24 21:31:40', b'1'),
(4964, 'sisesc', 1, 'selproveedor', '2024-02-24 21:31:41', b'1'),
(4965, 'sisesc', 1, 'getcompra', '2024-02-24 21:31:41', b'1'),
(4966, 'sisesc', 1, 'selcompradetalle', '2024-02-24 21:31:41', b'1'),
(4967, 'sisesc', 1, 'selproducto', '2024-02-24 21:31:41', b'1'),
(4968, 'sisesc', 1, 'getproveedor', '2024-02-24 21:31:42', b'1'),
(4969, 'sisesc', 1, 'getpersona', '2024-02-24 21:31:42', b'1'),
(4970, 'sisesc', 1, 'getcompra', '2024-02-24 21:31:42', b'1'),
(4971, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:31:43', b'1'),
(4972, 'sisesc', 1, 'getproveedor', '2024-02-24 21:31:43', b'1'),
(4973, 'sisesc', 1, 'getpersona', '2024-02-24 21:31:43', b'1'),
(4974, 'sisesc', 1, 'getcompra', '2024-02-24 21:31:43', b'1'),
(4975, 'sisesc', 1, 'selproveedor', '2024-02-24 21:31:50', b'1'),
(4976, 'sisesc', 1, 'selcompra', '2024-02-24 21:31:52', b'1'),
(4977, 'sisesc', 1, 'selproveedor', '2024-02-24 21:31:54', b'1'),
(4978, 'sisesc', 1, 'getcompra', '2024-02-24 21:31:54', b'1'),
(4979, 'sisesc', 1, 'selcompradetalle', '2024-02-24 21:31:54', b'1'),
(4980, 'sisesc', 1, 'selproducto', '2024-02-24 21:31:54', b'1'),
(4981, 'sisesc', 1, 'getproveedor', '2024-02-24 21:31:55', b'1'),
(4982, 'sisesc', 1, 'getpersona', '2024-02-24 21:31:55', b'1'),
(4983, 'sisesc', 1, 'getcompra', '2024-02-24 21:32:01', b'1'),
(4984, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:32:01', b'1'),
(4985, 'sisesc', 1, 'getproveedor', '2024-02-24 21:32:02', b'1'),
(4986, 'sisesc', 1, 'getpersona', '2024-02-24 21:32:02', b'1'),
(4987, 'sisesc', 1, 'getcompra', '2024-02-24 21:32:02', b'1'),
(4988, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:32:09', b'1'),
(4989, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:32:09', b'1'),
(4990, 'sisesc', 1, 'getcompra', '2024-02-24 21:32:09', b'1'),
(4991, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:36:23', b'1'),
(4992, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:36:23', b'1'),
(4993, 'sisesc', 1, 'getcompra', '2024-02-24 21:36:23', b'1'),
(4994, 'sisesc', 1, 'getcompra', '2024-02-24 21:36:59', b'1'),
(4995, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:37:00', b'1'),
(4996, 'sisesc', 1, 'getproveedor', '2024-02-24 21:37:00', b'1'),
(4997, 'sisesc', 1, 'getpersona', '2024-02-24 21:37:00', b'1'),
(4998, 'sisesc', 1, 'getcompra', '2024-02-24 21:37:00', b'1'),
(4999, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:37:05', b'1'),
(5000, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:37:05', b'1'),
(5001, 'sisesc', 1, 'getcompra', '2024-02-24 21:37:05', b'1'),
(5002, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:37:16', b'1'),
(5003, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:37:16', b'1'),
(5004, 'sisesc', 1, 'getcompra', '2024-02-24 21:37:16', b'1'),
(5005, 'sisesc', 1, 'getcompra', '2024-02-24 21:40:14', b'1'),
(5006, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:40:14', b'1'),
(5007, 'sisesc', 1, 'getproveedor', '2024-02-24 21:40:15', b'1'),
(5008, 'sisesc', 1, 'getpersona', '2024-02-24 21:40:15', b'1'),
(5009, 'sisesc', 1, 'getcompra', '2024-02-24 21:40:15', b'1'),
(5010, 'sisesc', 1, 'getcompra', '2024-02-24 21:41:36', b'1'),
(5011, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:41:36', b'1'),
(5012, 'sisesc', 1, 'getproveedor', '2024-02-24 21:41:37', b'1'),
(5013, 'sisesc', 1, 'getpersona', '2024-02-24 21:41:37', b'1'),
(5014, 'sisesc', 1, 'getcompra', '2024-02-24 21:41:37', b'1'),
(5015, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:41:42', b'1'),
(5016, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:41:42', b'1'),
(5017, 'sisesc', 1, 'getcompra', '2024-02-24 21:41:42', b'1'),
(5018, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:45:06', b'1'),
(5019, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:45:06', b'1'),
(5020, 'sisesc', 1, 'getcompra', '2024-02-24 21:45:06', b'1'),
(5021, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:46:09', b'1'),
(5022, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:46:09', b'1'),
(5023, 'sisesc', 1, 'getcompra', '2024-02-24 21:46:09', b'1'),
(5024, 'sisesc', 1, 'selcompra', '2024-02-24 21:54:16', b'1'),
(5025, 'sisesc', 1, 'selproveedor', '2024-02-24 21:54:18', b'1'),
(5026, 'sisesc', 1, 'getcompra', '2024-02-24 21:54:18', b'1'),
(5027, 'sisesc', 1, 'selcompradetalle', '2024-02-24 21:54:19', b'1'),
(5028, 'sisesc', 1, 'selproducto', '2024-02-24 21:54:19', b'1'),
(5029, 'sisesc', 1, 'getproveedor', '2024-02-24 21:54:19', b'1'),
(5030, 'sisesc', 1, 'getpersona', '2024-02-24 21:54:19', b'1'),
(5031, 'sisesc', 1, 'getcompra', '2024-02-24 21:54:20', b'1'),
(5032, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:54:20', b'1'),
(5033, 'sisesc', 1, 'getproveedor', '2024-02-24 21:54:21', b'1'),
(5034, 'sisesc', 1, 'getpersona', '2024-02-24 21:54:21', b'1'),
(5035, 'sisesc', 1, 'selcompra', '2024-02-24 21:54:31', b'1'),
(5036, 'sisesc', 1, 'selcompra', '2024-02-24 21:56:43', b'1'),
(5037, 'sisesc', 1, 'getcompra', '2024-02-24 21:56:43', b'1'),
(5038, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:56:43', b'1'),
(5039, 'sisesc', 1, 'getproveedor', '2024-02-24 21:56:43', b'1'),
(5040, 'sisesc', 1, 'getpersona', '2024-02-24 21:56:43', b'1'),
(5041, 'sisesc', 1, 'getcompra', '2024-02-24 21:56:44', b'1'),
(5042, 'sisesc', 1, 'selproveedor', '2024-02-24 21:56:56', b'1'),
(5043, 'sisesc', 1, 'getcompra', '2024-02-24 21:56:56', b'1'),
(5044, 'sisesc', 1, 'selcompradetalle', '2024-02-24 21:56:56', b'1'),
(5045, 'sisesc', 1, 'selproducto', '2024-02-24 21:56:57', b'1'),
(5046, 'sisesc', 1, 'getproveedor', '2024-02-24 21:56:57', b'1'),
(5047, 'sisesc', 1, 'getpersona', '2024-02-24 21:56:57', b'1'),
(5048, 'sisesc', 1, 'selcompra', '2024-02-24 21:56:59', b'1'),
(5049, 'sisesc', 1, 'selproveedor', '2024-02-24 21:57:03', b'1'),
(5050, 'sisesc', 1, 'getcompra', '2024-02-24 21:57:03', b'1'),
(5051, 'sisesc', 1, 'selcompradetalle', '2024-02-24 21:57:03', b'1'),
(5052, 'sisesc', 1, 'selproducto', '2024-02-24 21:57:03', b'1'),
(5053, 'sisesc', 1, 'getproveedor', '2024-02-24 21:57:04', b'1'),
(5054, 'sisesc', 1, 'getpersona', '2024-02-24 21:57:04', b'1'),
(5055, 'sisesc', 1, 'getcompra', '2024-02-24 21:57:06', b'1'),
(5056, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:57:06', b'1'),
(5057, 'sisesc', 1, 'getproveedor', '2024-02-24 21:57:07', b'1'),
(5058, 'sisesc', 1, 'getpersona', '2024-02-24 21:57:07', b'1'),
(5059, 'sisesc', 1, 'getcompra', '2024-02-24 21:57:07', b'1'),
(5060, 'sisesc', 1, 'getpagocompra', '2024-02-24 21:57:10', b'1'),
(5061, 'sisesc', 1, 'getcompra', '2024-02-24 21:57:11', b'1'),
(5062, 'sisesc', 1, 'getproveedor', '2024-02-24 21:57:11', b'1'),
(5063, 'sisesc', 1, 'getpersona', '2024-02-24 21:57:11', b'1'),
(5064, 'sisesc', 1, 'getpagocompra', '2024-02-24 21:57:18', b'1'),
(5065, 'sisesc', 1, 'getcompra', '2024-02-24 21:57:18', b'1'),
(5066, 'sisesc', 1, 'getproveedor', '2024-02-24 21:57:19', b'1'),
(5067, 'sisesc', 1, 'getpersona', '2024-02-24 21:57:19', b'1'),
(5068, 'sisesc', 1, 'getpagocompra', '2024-02-24 21:59:09', b'1'),
(5069, 'sisesc', 1, 'getcompra', '2024-02-24 21:59:09', b'1'),
(5070, 'sisesc', 1, 'getcompra', '2024-02-24 21:59:10', b'1'),
(5071, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:59:10', b'1'),
(5072, 'sisesc', 1, 'getproveedor', '2024-02-24 21:59:10', b'1'),
(5073, 'sisesc', 1, 'getproveedor', '2024-02-24 21:59:10', b'1'),
(5074, 'sisesc', 1, 'getpersona', '2024-02-24 21:59:10', b'1'),
(5075, 'sisesc', 1, 'getpersona', '2024-02-24 21:59:10', b'1'),
(5076, 'sisesc', 1, 'getcompra', '2024-02-24 21:59:10', b'1'),
(5077, 'sisesc', 1, 'selcompra', '2024-02-24 21:59:27', b'1'),
(5078, 'sisesc', 1, 'selproveedor', '2024-02-24 21:59:30', b'1'),
(5079, 'sisesc', 1, 'getcompra', '2024-02-24 21:59:30', b'1'),
(5080, 'sisesc', 1, 'selcompradetalle', '2024-02-24 21:59:30', b'1'),
(5081, 'sisesc', 1, 'selproducto', '2024-02-24 21:59:30', b'1'),
(5082, 'sisesc', 1, 'getproveedor', '2024-02-24 21:59:30', b'1'),
(5083, 'sisesc', 1, 'getpersona', '2024-02-24 21:59:31', b'1'),
(5084, 'sisesc', 1, 'getcompra', '2024-02-24 21:59:31', b'1'),
(5085, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:59:31', b'1'),
(5086, 'sisesc', 1, 'getproveedor', '2024-02-24 21:59:32', b'1'),
(5087, 'sisesc', 1, 'getpersona', '2024-02-24 21:59:32', b'1'),
(5088, 'sisesc', 1, 'getcompra', '2024-02-24 21:59:32', b'1'),
(5089, 'sisesc', 1, 'pappagocompra', '2024-02-24 21:59:53', b'1'),
(5090, 'sisesc', 1, 'selpagocompra', '2024-02-24 21:59:53', b'1'),
(5091, 'sisesc', 1, 'getcompra', '2024-02-24 21:59:53', b'1'),
(5092, 'sisesc', 1, 'getpagocompra', '2024-02-24 21:59:56', b'1'),
(5093, 'sisesc', 1, 'getcompra', '2024-02-24 21:59:57', b'1'),
(5094, 'sisesc', 1, 'getproveedor', '2024-02-24 21:59:57', b'1'),
(5095, 'sisesc', 1, 'getpersona', '2024-02-24 21:59:57', b'1'),
(5096, 'sisesc', 1, 'getpagocompra', '2024-02-24 22:00:39', b'1'),
(5097, 'sisesc', 1, 'getcompra', '2024-02-24 22:00:39', b'1'),
(5098, 'sisesc', 1, 'getcompra', '2024-02-24 22:00:40', b'1'),
(5099, 'sisesc', 1, 'selpagocompra', '2024-02-24 22:00:40', b'1'),
(5100, 'sisesc', 1, 'getproveedor', '2024-02-24 22:00:40', b'1'),
(5101, 'sisesc', 1, 'getproveedor', '2024-02-24 22:00:40', b'1'),
(5102, 'sisesc', 1, 'getpersona', '2024-02-24 22:00:40', b'1'),
(5103, 'sisesc', 1, 'getpersona', '2024-02-24 22:00:40', b'1'),
(5104, 'sisesc', 1, 'getcompra', '2024-02-24 22:00:40', b'1'),
(5105, 'sisesc', 1, 'getpagocompra', '2024-02-24 22:05:08', b'1'),
(5106, 'sisesc', 1, 'getcompra', '2024-02-24 22:05:08', b'1'),
(5107, 'sisesc', 1, 'getcompra', '2024-02-24 22:05:08', b'1'),
(5108, 'sisesc', 1, 'selpagocompra', '2024-02-24 22:05:08', b'1'),
(5109, 'sisesc', 1, 'getproveedor', '2024-02-24 22:05:09', b'1'),
(5110, 'sisesc', 1, 'getproveedor', '2024-02-24 22:05:09', b'1'),
(5111, 'sisesc', 1, 'getpersona', '2024-02-24 22:05:09', b'1'),
(5112, 'sisesc', 1, 'getpersona', '2024-02-24 22:05:09', b'1'),
(5113, 'sisesc', 1, 'getcompra', '2024-02-24 22:05:09', b'1'),
(5114, 'sisesc', 1, 'getpagocompra', '2024-02-24 22:05:21', b'1'),
(5115, 'sisesc', 1, 'getcompra', '2024-02-24 22:05:21', b'1'),
(5116, 'sisesc', 1, 'getcompra', '2024-02-24 22:05:21', b'1'),
(5117, 'sisesc', 1, 'selpagocompra', '2024-02-24 22:05:21', b'1'),
(5118, 'sisesc', 1, 'getproveedor', '2024-02-24 22:05:22', b'1'),
(5119, 'sisesc', 1, 'getproveedor', '2024-02-24 22:05:22', b'1'),
(5120, 'sisesc', 1, 'getpersona', '2024-02-24 22:05:22', b'1'),
(5121, 'sisesc', 1, 'getpersona', '2024-02-24 22:05:22', b'1'),
(5122, 'sisesc', 1, 'getcompra', '2024-02-24 22:05:22', b'1'),
(5123, 'sisesc', 1, 'getpagocompra', '2024-02-24 22:06:07', b'1'),
(5124, 'sisesc', 1, 'getcompra', '2024-02-24 22:06:07', b'1'),
(5125, 'sisesc', 1, 'getcompra', '2024-02-24 22:06:07', b'1'),
(5126, 'sisesc', 1, 'selpagocompra', '2024-02-24 22:06:07', b'1'),
(5127, 'sisesc', 1, 'getproveedor', '2024-02-24 22:06:07', b'1'),
(5128, 'sisesc', 1, 'getproveedor', '2024-02-24 22:06:07', b'1'),
(5129, 'sisesc', 1, 'getpersona', '2024-02-24 22:06:07', b'1'),
(5130, 'sisesc', 1, 'getpersona', '2024-02-24 22:06:07', b'1'),
(5131, 'sisesc', 1, 'getcompra', '2024-02-24 22:06:08', b'1'),
(5132, 'sisesc', 1, 'getpagocompra', '2024-02-24 22:06:14', b'1'),
(5133, 'sisesc', 1, 'getcompra', '2024-02-24 22:06:14', b'1'),
(5134, 'sisesc', 1, 'getcompra', '2024-02-24 22:06:15', b'1'),
(5135, 'sisesc', 1, 'selpagocompra', '2024-02-24 22:06:15', b'1'),
(5136, 'sisesc', 1, 'getproveedor', '2024-02-24 22:06:15', b'1'),
(5137, 'sisesc', 1, 'getproveedor', '2024-02-24 22:06:15', b'1'),
(5138, 'sisesc', 1, 'getpersona', '2024-02-24 22:06:15', b'1'),
(5139, 'sisesc', 1, 'getpersona', '2024-02-24 22:06:15', b'1'),
(5140, 'sisesc', 1, 'getcompra', '2024-02-24 22:06:15', b'1'),
(5141, 'sisesc', 1, 'getcompra', '2024-02-25 15:24:28', b'1'),
(5142, 'sisesc', 1, 'selpagocompra', '2024-02-25 15:24:28', b'1'),
(5143, 'sisesc', 1, 'getproveedor', '2024-02-25 15:24:29', b'1'),
(5144, 'sisesc', 1, 'getpersona', '2024-02-25 15:24:29', b'1'),
(5145, 'sisesc', 1, 'getcompra', '2024-02-25 15:24:29', b'1'),
(5146, 'sisesc', 1, 'selusuario', '2024-02-25 15:24:29', b'1'),
(5147, 'sisesc', 1, 'getusuario', '2024-02-25 15:24:33', b'1'),
(5148, 'sisesc', 1, 'getpersona', '2024-02-25 15:24:33', b'1'),
(5149, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:24:33', b'1'),
(5150, 'sisesc', 1, 'selusuario', '2024-02-25 15:25:12', b'1'),
(5151, 'sisesc', 1, 'selusuario', '2024-02-25 15:25:27', b'1'),
(5152, 'sisesc', 1, 'getusuario', '2024-02-25 15:25:35', b'1'),
(5153, 'sisesc', 1, 'getpersona', '2024-02-25 15:25:35', b'1'),
(5154, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:25:36', b'1'),
(5155, 'sisesc', 1, 'updusuario', '2024-02-25 15:25:56', b'1'),
(5156, 'sisesc', 1, 'updpersona', '2024-02-25 15:25:56', b'1'),
(5157, 'sisesc', 1, 'selusuario', '2024-02-25 15:25:58', b'1'),
(5158, 'sisesc', 1, 'selusuario', '2024-02-25 15:27:38', b'1'),
(5159, 'sisesc', 1, 'selusuario', '2024-02-25 15:27:42', b'1'),
(5160, 'sisesc', 1, 'getusuario', '2024-02-25 15:27:46', b'1'),
(5161, 'sisesc', 1, 'getpersona', '2024-02-25 15:27:46', b'1'),
(5162, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:27:46', b'1'),
(5163, 'sisesc', 1, 'getusuario', '2024-02-25 15:27:56', b'1'),
(5164, 'sisesc', 1, 'getpersona', '2024-02-25 15:27:57', b'1'),
(5165, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:27:57', b'1'),
(5166, 'sisesc', 1, 'getusuario', '2024-02-25 15:28:13', b'1'),
(5167, 'sisesc', 1, 'getpersona', '2024-02-25 15:28:13', b'1'),
(5168, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:28:13', b'1'),
(5169, 'sisesc', 1, 'getusuario', '2024-02-25 15:28:35', b'1'),
(5170, 'sisesc', 1, 'getpersona', '2024-02-25 15:28:35', b'1'),
(5171, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:28:35', b'1'),
(5172, 'sisesc', 1, 'getusuario', '2024-02-25 15:29:34', b'1'),
(5173, 'sisesc', 1, 'getpersona', '2024-02-25 15:29:34', b'1'),
(5174, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:29:34', b'1'),
(5175, 'sisesc', 1, 'getusuario', '2024-02-25 15:29:49', b'1'),
(5176, 'sisesc', 1, 'getpersona', '2024-02-25 15:29:49', b'1'),
(5177, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:29:49', b'1'),
(5178, 'sisesc', 1, 'selproducto', '2024-02-25 15:29:58', b'1'),
(5179, 'sisesc', 1, 'getproducto', '2024-02-25 15:30:03', b'1'),
(5180, 'sisesc', 1, 'selmarca', '2024-02-25 15:30:03', b'1'),
(5181, 'sisesc', 1, 'selclasificacionproducto', '2024-02-25 15:30:03', b'1'),
(5182, 'sisesc', 1, 'getproducto', '2024-02-25 15:32:46', b'1'),
(5183, 'sisesc', 1, 'selmarca', '2024-02-25 15:32:46', b'1'),
(5184, 'sisesc', 1, 'selclasificacionproducto', '2024-02-25 15:32:47', b'1'),
(5185, 'sisesc', 1, 'selmarca', '2024-02-25 15:33:05', b'1'),
(5186, 'sisesc', 1, 'selusuario', '2024-02-25 15:33:15', b'1'),
(5187, 'sisesc', 1, 'getusuario', '2024-02-25 15:33:19', b'1'),
(5188, 'sisesc', 1, 'getpersona', '2024-02-25 15:33:19', b'1'),
(5189, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:33:20', b'1'),
(5190, 'sisesc', 1, 'getusuario', '2024-02-25 15:33:49', b'1'),
(5191, 'sisesc', 1, 'selrol', '2024-02-25 15:33:49', b'1'),
(5192, 'sisesc', 1, 'selubicacion', '2024-02-25 15:33:49', b'1'),
(5193, 'sisesc', 1, 'getusuario', '2024-02-25 15:36:08', b'1'),
(5194, 'sisesc', 1, 'getpersona', '2024-02-25 15:36:08', b'1'),
(5195, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:36:08', b'1'),
(5196, 'sisesc', 1, 'selusuario', '2024-02-25 15:36:13', b'1'),
(5197, 'sisesc', 1, 'getusuario', '2024-02-25 15:36:15', b'1'),
(5198, 'sisesc', 1, 'getpersona', '2024-02-25 15:36:15', b'1'),
(5199, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:36:15', b'1'),
(5200, 'sisesc', 1, 'selusuario', '2024-02-25 15:36:17', b'1'),
(5201, 'sisesc', 1, 'getusuario', '2024-02-25 15:36:18', b'1'),
(5202, 'sisesc', 1, 'getpersona', '2024-02-25 15:36:18', b'1'),
(5203, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:36:18', b'1'),
(5204, 'sisesc', 1, 'selusuario', '2024-02-25 15:36:20', b'1'),
(5205, 'sisesc', 1, 'getusuario', '2024-02-25 15:36:34', b'1'),
(5206, 'sisesc', 1, 'getpersona', '2024-02-25 15:36:35', b'1'),
(5207, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:36:35', b'1'),
(5208, 'sisesc', 1, 'selusuario', '2024-02-25 15:36:36', b'1'),
(5209, 'sisesc', 1, 'selusuario', '2024-02-25 15:36:46', b'1'),
(5210, 'sisesc', 1, 'getusuario', '2024-02-25 15:36:48', b'1'),
(5211, 'sisesc', 1, 'getpersona', '2024-02-25 15:36:49', b'1'),
(5212, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:36:49', b'1'),
(5213, 'sisesc', 1, 'getusuario', '2024-02-25 15:37:30', b'1'),
(5214, 'sisesc', 1, 'getpersona', '2024-02-25 15:37:30', b'1'),
(5215, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:37:30', b'1'),
(5216, 'sisesc', 1, 'selusuario', '2024-02-25 15:37:50', b'1'),
(5217, 'sisesc', 1, 'seloficina', '2024-02-25 15:50:18', b'1'),
(5218, 'sisesc', 1, 'seloficina', '2024-02-25 15:51:10', b'1'),
(5219, 'sisesc', 1, 'seloficina', '2024-02-25 15:52:14', b'1'),
(5220, 'sisesc', 1, 'seloficina', '2024-02-25 15:52:31', b'1'),
(5221, 'sisesc', 1, 'selusuario', '2024-02-25 15:53:19', b'1'),
(5222, 'sisesc', 1, 'getusuario', '2024-02-25 15:53:22', b'1'),
(5223, 'sisesc', 1, 'getpersona', '2024-02-25 15:53:23', b'1'),
(5224, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:53:23', b'1'),
(5225, 'sisesc', 1, 'updusuario', '2024-02-25 15:55:16', b'1'),
(5226, 'sisesc', 1, 'updpersona', '2024-02-25 15:55:16', b'1'),
(5227, 'sisesc', 1, 'selusuario', '2024-02-25 15:55:18', b'1'),
(5228, 'sisesc', 1, 'selusuario', '2024-02-25 15:55:27', b'1'),
(5229, 'sisesc', 1, 'getusuario', '2024-02-25 15:55:36', b'1'),
(5230, 'sisesc', 1, 'getpersona', '2024-02-25 15:55:36', b'1'),
(5231, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:55:37', b'1'),
(5232, 'sisesc', 1, 'getusuario', '2024-02-25 15:57:02', b'1'),
(5233, 'sisesc', 1, 'selusuario', '2024-02-25 15:57:02', b'1'),
(5234, 'sisesc', 1, 'getpersona', '2024-02-25 15:57:02', b'1'),
(5235, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:57:02', b'1'),
(5236, 'sisesc', 1, 'getusuario', '2024-02-25 15:57:06', b'1'),
(5237, 'sisesc', 1, 'getpersona', '2024-02-25 15:57:07', b'1'),
(5238, 'sisesc', 1, 'selrolusuario', '2024-02-25 15:57:07', b'1'),
(5239, 'sisesc', 1, 'updusuario', '2024-02-25 15:57:14', b'1'),
(5240, 'sisesc', 1, 'updpersona', '2024-02-25 15:57:14', b'1'),
(5241, 'sisesc', 1, 'selusuario', '2024-02-25 15:57:17', b'1'),
(5242, 'sisesc', 2, 'seloficina', '2024-02-25 15:57:26', b'1'),
(5243, 'sisesc', 2, 'seloficina', '2024-02-25 15:57:30', b'1'),
(5244, 'sisesc', 2, 'seloficina', '2024-02-25 15:58:27', b'1'),
(5245, 'sisesc', 2, 'selusuario', '2024-02-25 15:58:28', b'1'),
(5246, 'sisesc', 2, 'getusuario', '2024-02-25 15:58:33', b'1'),
(5247, 'sisesc', 2, 'getpersona', '2024-02-25 15:58:33', b'1'),
(5248, 'sisesc', 2, 'selrolusuario', '2024-02-25 15:58:33', b'1'),
(5249, 'sisesc', 2, 'updusuario', '2024-02-25 15:58:40', b'1'),
(5250, 'sisesc', 2, 'updpersona', '2024-02-25 15:58:40', b'1'),
(5251, 'sisesc', 2, 'seloficina', '2024-02-25 15:58:51', b'1'),
(5252, 'sisesc', 2, 'seloficina', '2024-02-25 15:58:55', b'1'),
(5253, 'sisesc', 2, 'seloficina', '2024-02-25 15:59:11', b'1'),
(5254, 'sisesc', 1, 'seloficina', '2024-02-25 15:59:16', b'1'),
(5255, 'sisesc', 1, 'seloficina', '2024-02-25 15:59:18', b'1'),
(5256, 'sisesc', 1, 'seloficina', '2024-02-25 16:01:42', b'1'),
(5257, 'sisesc', 1, 'seloficina', '2024-02-25 16:01:53', b'1'),
(5258, 'sisesc', 1, 'seloficina', '2024-02-25 16:02:00', b'1'),
(5259, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:02:04', b'1'),
(5260, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:02:05', b'1'),
(5261, 'sisesc', 1, 'getplandecuenta', '2024-02-25 16:02:07', b'1'),
(5262, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:02:08', b'1'),
(5263, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:02:08', b'1'),
(5264, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:04:21', b'1'),
(5265, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:04:21', b'1'),
(5266, 'sisesc', 1, 'getplandecuenta', '2024-02-25 16:04:22', b'1'),
(5267, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:04:23', b'1'),
(5268, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:04:23', b'1'),
(5269, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:04:33', b'1'),
(5270, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:04:33', b'1'),
(5271, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:05:50', b'1'),
(5272, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:05:54', b'1'),
(5273, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:05:54', b'1'),
(5274, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:07:01', b'1'),
(5275, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:07:01', b'1'),
(5276, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:07:28', b'1'),
(5277, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:07:28', b'1'),
(5278, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:07:41', b'1'),
(5279, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:07:42', b'1'),
(5280, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:07:50', b'1'),
(5281, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:07:51', b'1'),
(5282, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:07:52', b'1'),
(5283, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:07:59', b'1'),
(5284, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:07:59', b'1'),
(5285, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:08:37', b'1'),
(5286, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:08:37', b'1'),
(5287, 'sisesc', 1, 'addplandecuenta', '2024-02-25 16:08:51', b'1'),
(5288, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:08:51', b'1'),
(5289, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:08:52', b'1'),
(5290, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:08:54', b'1'),
(5291, 'sisesc', 1, 'getplandecuenta', '2024-02-25 16:08:59', b'1'),
(5292, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:08:59', b'1'),
(5293, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:08:59', b'1'),
(5294, 'sisesc', 1, 'getplandecuenta', '2024-02-25 16:09:48', b'1'),
(5295, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:09:48', b'1'),
(5296, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:09:49', b'1'),
(5297, 'sisesc', 1, 'getplandecuenta', '2024-02-25 16:10:23', b'1'),
(5298, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:10:24', b'1'),
(5299, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:10:24', b'1'),
(5300, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:10:42', b'1'),
(5301, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:10:42', b'1'),
(5302, 'sisesc', 1, 'getplandecuenta', '2024-02-25 16:10:45', b'1'),
(5303, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:10:45', b'1'),
(5304, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:10:45', b'1'),
(5305, 'sisesc', 1, 'getplandecuenta', '2024-02-25 16:10:53', b'1'),
(5306, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:10:53', b'1'),
(5307, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:10:54', b'1'),
(5308, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:10:59', b'1'),
(5309, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:10:59', b'1'),
(5310, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:11:01', b'1'),
(5311, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:11:01', b'1'),
(5312, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:11:04', b'1'),
(5313, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:11:04', b'1'),
(5314, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:11:06', b'1'),
(5315, 'sisesc', 1, 'getplandecuenta', '2024-02-25 16:11:07', b'1'),
(5316, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:11:08', b'1'),
(5317, 'sisesc', 1, 'selplandecuenta', '2024-02-25 16:11:08', b'1'),
(5318, 'sisesc', 1, 'getplandecuenta', '2024-02-25 16:13:11', b'1'),
(5319, 'sisesc', 1, 'selparametrotipo', '2024-02-25 16:13:11', b'1'),
(5320, 'sisesc', 1, 'selproveedor', '2024-02-25 16:13:30', b'1'),
(5321, 'sisesc', 1, 'selcompra', '2024-02-25 16:13:35', b'1'),
(5322, 'sisesc', 1, 'selcompra', '2024-02-25 16:14:50', b'1'),
(5323, 'sisesc', 1, 'selproveedor', '2024-02-25 16:14:54', b'1'),
(5324, 'sisesc', 1, 'seloficina', '2024-02-25 19:45:50', b'1'),
(5325, 'sisesc', 1, 'seloficina', '2024-02-25 19:45:52', b'1'),
(5326, 'sisesc', 1, 'selproducto', '2024-02-25 19:45:56', b'1'),
(5327, 'sisesc', 1, 'selusuario', '2024-02-25 19:46:00', b'1'),
(5328, 'sisesc', 1, 'selmarca', '2024-02-25 19:46:03', b'1'),
(5329, 'sisesc', 1, 'selparametrotipo', '2024-02-25 19:46:05', b'1'),
(5330, 'sisesc', 1, 'selplandecuenta', '2024-02-25 19:46:06', b'1'),
(5331, 'sisesc', 1, 'selproveedor', '2024-02-25 19:46:10', b'1'),
(5332, 'sisesc', 1, 'selcompra', '2024-02-25 19:46:11', b'1'),
(5333, 'sisesc', 1, 'seloficina', '2024-02-26 00:56:50', b'1'),
(5334, 'sisesc', 1, 'selcliente', '2024-02-26 00:56:54', b'1'),
(5335, 'sisesc', 1, 'selcliente', '2024-02-26 01:03:29', b'1'),
(5336, 'sisesc', 1, 'selcliente', '2024-02-26 01:03:45', b'1'),
(5337, 'sisesc', 1, 'selcliente', '2024-02-26 01:04:54', b'1'),
(5338, 'sisesc', 1, 'selcliente', '2024-02-26 01:04:57', b'1'),
(5339, 'sisesc', 1, 'selmarca', '2024-02-26 01:04:59', b'1'),
(5340, 'sisesc', 1, 'addpersona', '2024-02-26 01:05:29', b'1'),
(5341, 'sisesc', 1, 'addcliente', '2024-02-26 01:05:29', b'1'),
(5342, 'sisesc', 1, 'selcliente', '2024-02-26 01:05:29', b'1'),
(5343, 'sisesc', 1, 'selcliente', '2024-02-26 01:11:39', b'1'),
(5344, 'sisesc', 1, 'getcliente', '2024-02-26 01:17:20', b'1'),
(5345, 'sisesc', 1, 'getpersona', '2024-02-26 01:17:20', b'1'),
(5346, 'sisesc', 1, 'selmarca', '2024-02-26 01:17:20', b'1'),
(5347, 'sisesc', 1, 'getcliente', '2024-02-26 01:17:35', b'1'),
(5348, 'sisesc', 1, 'getpersona', '2024-02-26 01:17:36', b'1'),
(5349, 'sisesc', 1, 'selmarca', '2024-02-26 01:17:36', b'1'),
(5350, 'sisesc', 1, 'getcliente', '2024-02-26 01:17:44', b'1'),
(5351, 'sisesc', 1, 'getpersona', '2024-02-26 01:17:44', b'1'),
(5352, 'sisesc', 1, 'selmarca', '2024-02-26 01:17:44', b'1'),
(5353, 'sisesc', 1, 'getcliente', '2024-02-26 01:19:25', b'1'),
(5354, 'sisesc', 1, 'getpersona', '2024-02-26 01:19:25', b'1'),
(5355, 'sisesc', 1, 'selmarca', '2024-02-26 01:19:26', b'1'),
(5356, 'sisesc', 1, 'getcliente', '2024-02-26 01:21:32', b'1'),
(5357, 'sisesc', 1, 'getpersona', '2024-02-26 01:21:33', b'1'),
(5358, 'sisesc', 1, 'selmarca', '2024-02-26 01:21:33', b'1'),
(5359, 'sisesc', 1, 'getcliente', '2024-02-26 01:22:16', b'1'),
(5360, 'sisesc', 1, 'getpersona', '2024-02-26 01:22:16', b'1'),
(5361, 'sisesc', 1, 'selmarca', '2024-02-26 01:22:16', b'1'),
(5362, 'sisesc', 1, 'getcliente', '2024-02-26 01:23:30', b'1'),
(5363, 'sisesc', 1, 'getpersona', '2024-02-26 01:23:30', b'1'),
(5364, 'sisesc', 1, 'selmarca', '2024-02-26 01:23:30', b'1'),
(5365, 'sisesc', 1, 'getcliente', '2024-02-26 01:23:32', b'1'),
(5366, 'sisesc', 1, 'getpersona', '2024-02-26 01:23:32', b'1'),
(5367, 'sisesc', 1, 'selmarca', '2024-02-26 01:23:32', b'1'),
(5368, 'sisesc', 1, 'selcliente', '2024-02-26 01:37:37', b'1'),
(5369, 'sisesc', 1, 'selcliente', '2024-02-26 01:37:39', b'1'),
(5370, 'sisesc', 1, 'getcliente', '2024-02-26 01:37:44', b'1'),
(5371, 'sisesc', 1, 'getpersona', '2024-02-26 01:37:45', b'1'),
(5372, 'sisesc', 1, 'addventa', '2024-02-26 01:37:45', b'1'),
(5373, 'sisesc', 1, 'selproducto', '2024-02-26 01:37:45', b'1'),
(5374, 'sisesc', 1, 'selventa', '2024-02-26 01:37:52', b'1'),
(5375, 'sisesc', 1, 'selcliente', '2024-02-26 01:37:54', b'1'),
(5376, 'sisesc', 1, 'getventa', '2024-02-26 01:37:55', b'1'),
(5377, 'sisesc', 1, 'selventadetalle', '2024-02-26 01:37:55', b'1'),
(5378, 'sisesc', 1, 'selproducto', '2024-02-26 01:37:55', b'1'),
(5379, 'sisesc', 1, 'getcliente', '2024-02-26 01:37:55', b'1'),
(5380, 'sisesc', 1, 'getpersona', '2024-02-26 01:37:56', b'1'),
(5381, 'sisesc', 1, 'selcompra', '2024-02-26 01:38:05', b'1'),
(5382, 'sisesc', 1, 'selcliente', '2024-02-26 01:38:09', b'1'),
(5383, 'sisesc', 1, 'selcliente', '2024-02-26 02:31:30', b'1'),
(5384, 'sisesc', 1, 'selcliente', '2024-02-26 02:32:20', b'1'),
(5385, 'sisesc', 1, 'getcliente', '2024-02-26 02:36:30', b'1'),
(5386, 'sisesc', 1, 'getpersona', '2024-02-26 02:36:31', b'1'),
(5387, 'sisesc', 1, 'addventa', '2024-02-26 02:36:31', b'1'),
(5388, 'sisesc', 1, 'selproducto', '2024-02-26 02:36:31', b'1'),
(5389, 'sisesc', 1, 'selventa', '2024-02-26 02:38:10', b'1'),
(5390, 'sisesc', 1, 'selcliente', '2024-02-26 02:38:12', b'1'),
(5391, 'sisesc', 1, 'getventa', '2024-02-26 02:38:12', b'1'),
(5392, 'sisesc', 1, 'selventadetalle', '2024-02-26 02:38:13', b'1'),
(5393, 'sisesc', 1, 'selproducto', '2024-02-26 02:38:13', b'1'),
(5394, 'sisesc', 1, 'getcliente', '2024-02-26 02:38:13', b'1'),
(5395, 'sisesc', 1, 'getpersona', '2024-02-26 02:38:14', b'1'),
(5396, 'sisesc', 1, 'selcliente', '2024-02-26 02:38:23', b'1'),
(5397, 'sisesc', 1, 'getcliente', '2024-02-26 02:38:28', b'1'),
(5398, 'sisesc', 1, 'getpersona', '2024-02-26 02:38:28', b'1'),
(5399, 'sisesc', 1, 'addcotizacion', '2024-02-26 02:38:28', b'1'),
(5400, 'sisesc', 1, 'getcliente', '2024-02-26 02:39:02', b'1'),
(5401, 'sisesc', 1, 'getpersona', '2024-02-26 02:39:02', b'1'),
(5402, 'sisesc', 1, 'addcotizacion', '2024-02-26 02:39:03', b'1'),
(5403, 'sisesc', 1, 'selcotizacion', '2024-02-26 02:40:04', b'1'),
(5404, 'sisesc', 1, 'selcliente', '2024-02-26 02:40:06', b'1'),
(5405, 'sisesc', 1, 'selcliente', '2024-02-26 02:40:25', b'1'),
(5406, 'sisesc', 1, 'getcliente', '2024-02-26 02:40:33', b'1'),
(5407, 'sisesc', 1, 'getpersona', '2024-02-26 02:40:33', b'1'),
(5408, 'sisesc', 1, 'addcotizacion', '2024-02-26 02:40:33', b'1'),
(5409, 'sisesc', 1, 'selcotizacion', '2024-02-26 02:41:49', b'1'),
(5410, 'sisesc', 1, 'selcliente', '2024-02-26 02:41:50', b'1'),
(5411, 'sisesc', 1, 'selcliente', '2024-02-26 02:41:54', b'1'),
(5412, 'sisesc', 1, 'getcliente', '2024-02-26 02:41:56', b'1'),
(5413, 'sisesc', 1, 'getpersona', '2024-02-26 02:41:56', b'1'),
(5414, 'sisesc', 1, 'addcotizacion', '2024-02-26 02:41:56', b'1'),
(5415, 'sisesc', 1, 'selproducto', '2024-02-26 02:41:57', b'1'),
(5416, 'sisesc', 1, 'selproducto', '2024-02-26 02:42:08', b'1'),
(5417, 'sisesc', 1, 'selproducto', '2024-02-26 02:50:49', b'1'),
(5418, 'sisesc', 2, 'seloficina', '2024-02-26 13:33:30', b'1'),
(5419, 'sisesc', 2, 'seloficina', '2024-02-26 13:34:06', b'1'),
(5420, 'sisesc', 2, 'selcompra', '2024-02-26 13:34:41', b'1'),
(5421, 'sisesc', 2, 'selproveedor', '2024-02-26 13:34:44', b'1'),
(5422, 'sisesc', 2, 'getproveedor', '2024-02-26 13:35:04', b'1'),
(5423, 'sisesc', 2, 'seloficina', '2024-02-26 13:36:27', b'1'),
(5424, 'sisesc', 1, 'seloficina', '2024-02-26 13:36:37', b'1'),
(5425, 'sisesc', 1, 'seloficina', '2024-02-26 13:36:39', b'1'),
(5426, 'sisesc', 1, 'selusuario', '2024-02-26 13:36:41', b'1'),
(5427, 'sisesc', 1, 'getusuario', '2024-02-26 13:36:46', b'1'),
(5428, 'sisesc', 1, 'getpersona', '2024-02-26 13:36:46', b'1'),
(5429, 'sisesc', 1, 'selrolusuario', '2024-02-26 13:36:46', b'1'),
(5430, 'sisesc', 1, 'updusuario', '2024-02-26 13:37:04', b'1'),
(5431, 'sisesc', 1, 'updpersona', '2024-02-26 13:37:04', b'1'),
(5432, 'sisesc', 1, 'selusuario', '2024-02-26 13:37:07', b'1'),
(5433, 'sisesc', 2, 'seloficina', '2024-02-26 13:37:36', b'1'),
(5434, 'sisesc', 2, 'seloficina', '2024-02-26 13:40:32', b'1'),
(5435, 'sisesc', 2, 'selproducto', '2024-02-26 13:40:57', b'1'),
(5436, 'sisesc', 2, 'selmarca', '2024-02-26 13:41:02', b'1'),
(5437, 'sisesc', 2, 'selclasificacionproducto', '2024-02-26 13:41:03', b'1'),
(5438, 'sisesc', 2, 'selmarca', '2024-02-26 13:41:29', b'1'),
(5439, 'sisesc', 2, 'getmarca', '2024-02-26 13:41:31', b'1'),
(5440, 'sisesc', 2, 'selmarca', '2024-02-26 13:41:31', b'1'),
(5441, 'sisesc', 2, 'updmarca', '2024-02-26 13:41:42', b'1'),
(5442, 'sisesc', 2, 'selmarca', '2024-02-26 13:41:42', b'1'),
(5443, 'sisesc', 2, 'selmarca', '2024-02-26 13:41:54', b'1'),
(5444, 'sisesc', 2, 'addmarca', '2024-02-26 13:42:03', b'1'),
(5445, 'sisesc', 2, 'selmarca', '2024-02-26 13:42:03', b'1'),
(5446, 'sisesc', 2, 'selmarca', '2024-02-26 13:42:09', b'1'),
(5447, 'sisesc', 2, 'addmarca', '2024-02-26 13:42:18', b'1'),
(5448, 'sisesc', 2, 'selmarca', '2024-02-26 13:42:18', b'1'),
(5449, 'sisesc', 2, 'selmarca', '2024-02-26 13:42:20', b'1'),
(5450, 'sisesc', 2, 'addmarca', '2024-02-26 13:42:40', b'1'),
(5451, 'sisesc', 2, 'selmarca', '2024-02-26 13:42:40', b'1'),
(5452, 'sisesc', 2, 'selproducto', '2024-02-26 13:42:52', b'1'),
(5453, 'sisesc', 2, 'selmarca', '2024-02-26 13:42:54', b'1'),
(5454, 'sisesc', 2, 'selclasificacionproducto', '2024-02-26 13:42:54', b'1'),
(5455, 'sisesc', 2, 'selproducto', '2024-02-26 13:45:30', b'1'),
(5456, 'sisesc', 2, 'addproducto', '2024-02-26 13:45:30', b'1'),
(5457, 'sisesc', 1, 'seloficina', '2024-02-26 13:46:33', b'1'),
(5458, 'sisesc', 1, 'selproducto', '2024-02-26 13:46:38', b'1'),
(5459, 'sisesc', 2, 'selproveedor', '2024-02-26 13:46:57', b'1'),
(5460, 'sisesc', 1, 'selproveedor', '2024-02-26 13:47:01', b'1'),
(5461, 'sisesc', 2, 'selproveedor', '2024-02-26 13:47:12', b'1'),
(5462, 'sisesc', 2, 'getproveedor', '2024-02-26 13:47:14', b'1'),
(5463, 'sisesc', 2, 'getpersona', '2024-02-26 13:47:15', b'1'),
(5464, 'sisesc', 2, 'selmarca', '2024-02-26 13:47:15', b'1'),
(5465, 'sisesc', 2, 'selproveedor', '2024-02-26 13:47:19', b'1'),
(5466, 'sisesc', 2, 'selmarca', '2024-02-26 13:47:20', b'1'),
(5467, 'sisesc', 2, 'addpersona', '2024-02-26 13:49:48', b'1'),
(5468, 'sisesc', 2, 'addproveedor', '2024-02-26 13:49:48', b'1'),
(5469, 'sisesc', 2, 'selproveedor', '2024-02-26 13:49:48', b'1'),
(5470, 'sisesc', 2, 'selproveedor', '2024-02-26 13:49:57', b'1'),
(5471, 'sisesc', 2, 'getproveedor', '2024-02-26 13:50:06', b'1'),
(5472, 'sisesc', 2, 'getpersona', '2024-02-26 13:50:06', b'1'),
(5473, 'sisesc', 2, 'addcompra', '2024-02-26 13:50:07', b'1'),
(5474, 'sisesc', 2, 'selproducto', '2024-02-26 13:50:07', b'1'),
(5475, 'sisesc', 2, 'getproducto', '2024-02-26 13:50:31', b'1'),
(5476, 'sisesc', 2, 'papcompra', '2024-02-26 13:51:16', b'1'),
(5477, 'sisesc', 2, 'getcompra', '2024-02-26 13:51:17', b'1'),
(5478, 'sisesc', 2, 'selproveedor', '2024-02-26 13:51:17', b'1'),
(5479, 'sisesc', 2, 'selcompradetalle', '2024-02-26 13:51:17', b'1'),
(5480, 'sisesc', 2, 'selproducto', '2024-02-26 13:51:18', b'1'),
(5481, 'sisesc', 2, 'getproveedor', '2024-02-26 13:51:18', b'1'),
(5482, 'sisesc', 2, 'getpersona', '2024-02-26 13:51:18', b'1'),
(5483, 'sisesc', 2, 'selcompra', '2024-02-26 13:51:35', b'1'),
(5484, 'sisesc', 2, 'selproveedor', '2024-02-26 13:51:40', b'1'),
(5485, 'sisesc', 2, 'getcompra', '2024-02-26 13:51:40', b'1'),
(5486, 'sisesc', 2, 'selcompradetalle', '2024-02-26 13:51:40', b'1'),
(5487, 'sisesc', 2, 'selproducto', '2024-02-26 13:51:40', b'1'),
(5488, 'sisesc', 2, 'getproveedor', '2024-02-26 13:51:40', b'1'),
(5489, 'sisesc', 2, 'getpersona', '2024-02-26 13:51:41', b'1'),
(5490, 'sisesc', 2, 'selproveedor', '2024-02-26 13:52:33', b'1'),
(5491, 'sisesc', 2, 'selcompra', '2024-02-26 13:52:41', b'1'),
(5492, 'sisesc', 2, 'selproveedor', '2024-02-26 13:52:48', b'1'),
(5493, 'sisesc', 2, 'getcompra', '2024-02-26 13:52:48', b'1'),
(5494, 'sisesc', 2, 'selcompradetalle', '2024-02-26 13:52:48', b'1'),
(5495, 'sisesc', 2, 'selproducto', '2024-02-26 13:52:48', b'1'),
(5496, 'sisesc', 2, 'getproveedor', '2024-02-26 13:52:49', b'1'),
(5497, 'sisesc', 2, 'getpersona', '2024-02-26 13:52:49', b'1'),
(5498, 'sisesc', 2, 'getproducto', '2024-02-26 13:52:57', b'1'),
(5499, 'sisesc', 2, 'addcompradetalle', '2024-02-26 13:53:20', b'1'),
(5500, 'sisesc', 2, 'selcompradetalle', '2024-02-26 13:53:20', b'1'),
(5501, 'sisesc', 2, 'papcompra', '2024-02-26 13:53:29', b'1'),
(5502, 'sisesc', 2, 'selproveedor', '2024-02-26 13:53:29', b'1'),
(5503, 'sisesc', 2, 'getcompra', '2024-02-26 13:53:29', b'1'),
(5504, 'sisesc', 2, 'selcompradetalle', '2024-02-26 13:53:30', b'1'),
(5505, 'sisesc', 2, 'selproducto', '2024-02-26 13:53:30', b'1'),
(5506, 'sisesc', 2, 'getproveedor', '2024-02-26 13:53:30', b'1'),
(5507, 'sisesc', 2, 'getpersona', '2024-02-26 13:53:30', b'1'),
(5508, 'sisesc', 2, 'getcompra', '2024-02-26 13:53:46', b'1'),
(5509, 'sisesc', 2, 'selcompradetalle', '2024-02-26 13:53:46', b'1'),
(5510, 'sisesc', 2, 'getproveedor', '2024-02-26 13:53:46', b'1'),
(5511, 'sisesc', 2, 'getpersona', '2024-02-26 13:53:46', b'1'),
(5512, 'sisesc', 2, 'selproveedor', '2024-02-26 13:54:10', b'1'),
(5513, 'sisesc', 2, 'selmarca', '2024-02-26 13:54:13', b'1'),
(5514, 'sisesc', 2, 'addpersona', '2024-02-26 13:55:21', b'1'),
(5515, 'sisesc', 2, 'addproveedor', '2024-02-26 13:55:21', b'1'),
(5516, 'sisesc', 2, 'selproveedor', '2024-02-26 13:55:21', b'1'),
(5517, 'sisesc', 2, 'getproveedor', '2024-02-26 13:55:26', b'1'),
(5518, 'sisesc', 2, 'getpersona', '2024-02-26 13:55:26', b'1'),
(5519, 'sisesc', 2, 'selmarca', '2024-02-26 13:55:27', b'1'),
(5520, 'sisesc', 2, 'updpersona', '2024-02-26 13:55:32', b'1'),
(5521, 'sisesc', 2, 'updproveedor', '2024-02-26 13:55:32', b'1'),
(5522, 'sisesc', 2, 'selproveedor', '2024-02-26 13:55:32', b'1'),
(5523, 'sisesc', 2, 'selproducto', '2024-02-26 13:55:48', b'1'),
(5524, 'sisesc', 2, 'selmarca', '2024-02-26 13:55:51', b'1'),
(5525, 'sisesc', 2, 'selclasificacionproducto', '2024-02-26 13:55:51', b'1'),
(5526, 'sisesc', 2, 'selproducto', '2024-02-26 13:57:25', b'1'),
(5527, 'sisesc', 2, 'addproducto', '2024-02-26 13:57:25', b'1'),
(5528, 'sisesc', 2, 'selproveedor', '2024-02-26 13:57:34', b'1'),
(5529, 'sisesc', 2, 'getproveedor', '2024-02-26 13:57:38', b'1'),
(5530, 'sisesc', 2, 'getpersona', '2024-02-26 13:57:38', b'1'),
(5531, 'sisesc', 2, 'addcompra', '2024-02-26 13:57:38', b'1'),
(5532, 'sisesc', 2, 'selproducto', '2024-02-26 13:57:38', b'1'),
(5533, 'sisesc', 2, 'getproducto', '2024-02-26 13:57:42', b'1'),
(5534, 'sisesc', 2, 'addcompradetalle', '2024-02-26 13:57:54', b'1'),
(5535, 'sisesc', 2, 'selcompradetalle', '2024-02-26 13:57:54', b'1'),
(5536, 'sisesc', 2, 'papcompra', '2024-02-26 13:57:59', b'1'),
(5537, 'sisesc', 2, 'selproveedor', '2024-02-26 13:58:00', b'1'),
(5538, 'sisesc', 2, 'getcompra', '2024-02-26 13:58:00', b'1'),
(5539, 'sisesc', 2, 'selcompradetalle', '2024-02-26 13:58:00', b'1'),
(5540, 'sisesc', 2, 'selproducto', '2024-02-26 13:58:01', b'1'),
(5541, 'sisesc', 2, 'getproveedor', '2024-02-26 13:58:01', b'1'),
(5542, 'sisesc', 2, 'getpersona', '2024-02-26 13:58:01', b'1'),
(5543, 'sisesc', 2, 'selproducto', '2024-02-26 13:58:32', b'1'),
(5544, 'sisesc', 2, 'selmarca', '2024-02-26 13:58:34', b'1'),
(5545, 'sisesc', 2, 'selclasificacionproducto', '2024-02-26 13:58:34', b'1'),
(5546, 'sisesc', 2, 'selproducto', '2024-02-26 13:59:54', b'1'),
(5547, 'sisesc', 2, 'addproducto', '2024-02-26 13:59:54', b'1'),
(5548, 'sisesc', 2, 'selproveedor', '2024-02-26 14:00:12', b'1'),
(5549, 'sisesc', 2, 'selmarca', '2024-02-26 14:00:17', b'1'),
(5550, 'sisesc', 2, 'addpersona', '2024-02-26 14:01:31', b'1'),
(5551, 'sisesc', 2, 'addproveedor', '2024-02-26 14:01:31', b'1'),
(5552, 'sisesc', 2, 'selproveedor', '2024-02-26 14:01:31', b'1'),
(5553, 'sisesc', 2, 'getproveedor', '2024-02-26 14:01:36', b'1'),
(5554, 'sisesc', 2, 'getpersona', '2024-02-26 14:01:36', b'1'),
(5555, 'sisesc', 2, 'selmarca', '2024-02-26 14:01:36', b'1'),
(5556, 'sisesc', 2, 'updpersona', '2024-02-26 14:01:43', b'1'),
(5557, 'sisesc', 2, 'updproveedor', '2024-02-26 14:01:43', b'1'),
(5558, 'sisesc', 2, 'selproveedor', '2024-02-26 14:01:43', b'1'),
(5559, 'sisesc', 2, 'selproveedor', '2024-02-26 14:01:52', b'1'),
(5560, 'sisesc', 2, 'getproveedor', '2024-02-26 14:01:57', b'1'),
(5561, 'sisesc', 2, 'getpersona', '2024-02-26 14:01:57', b'1'),
(5562, 'sisesc', 2, 'addcompra', '2024-02-26 14:01:58', b'1'),
(5563, 'sisesc', 2, 'selproducto', '2024-02-26 14:01:58', b'1'),
(5564, 'sisesc', 2, 'getproducto', '2024-02-26 14:02:08', b'1'),
(5565, 'sisesc', 2, 'addcompradetalle', '2024-02-26 14:02:35', b'1'),
(5566, 'sisesc', 2, 'selcompradetalle', '2024-02-26 14:02:35', b'1'),
(5567, 'sisesc', 2, 'papcompra', '2024-02-26 14:02:36', b'1'),
(5568, 'sisesc', 2, 'selproveedor', '2024-02-26 14:02:37', b'1'),
(5569, 'sisesc', 2, 'getcompra', '2024-02-26 14:02:37', b'1'),
(5570, 'sisesc', 2, 'selcompradetalle', '2024-02-26 14:02:37', b'1'),
(5571, 'sisesc', 2, 'selproducto', '2024-02-26 14:02:37', b'1'),
(5572, 'sisesc', 2, 'getproveedor', '2024-02-26 14:02:38', b'1'),
(5573, 'sisesc', 2, 'getpersona', '2024-02-26 14:02:38', b'1'),
(5574, 'sisesc', 2, 'getcompra', '2024-02-26 14:03:37', b'1'),
(5575, 'sisesc', 2, 'selcompradetalle', '2024-02-26 14:03:37', b'1'),
(5576, 'sisesc', 2, 'getproveedor', '2024-02-26 14:03:38', b'1'),
(5577, 'sisesc', 2, 'getpersona', '2024-02-26 14:03:38', b'1'),
(5578, 'sisesc', 2, 'selproveedor', '2024-02-26 14:03:59', b'1'),
(5579, 'sisesc', 2, 'getcompra', '2024-02-26 14:03:59', b'1'),
(5580, 'sisesc', 2, 'selcompradetalle', '2024-02-26 14:04:00', b'1'),
(5581, 'sisesc', 2, 'selproducto', '2024-02-26 14:04:00', b'1'),
(5582, 'sisesc', 2, 'getproveedor', '2024-02-26 14:04:00', b'1'),
(5583, 'sisesc', 2, 'getpersona', '2024-02-26 14:04:00', b'1'),
(5584, 'sisesc', 2, 'seloficina', '2024-02-26 14:10:55', b'1'),
(5585, 'sisesc', 2, 'selmarca', '2024-02-26 14:11:00', b'1'),
(5586, 'sisesc', 2, 'selproducto', '2024-02-26 14:11:14', b'1'),
(5587, 'sisesc', 2, 'selmarca', '2024-02-26 14:11:17', b'1'),
(5588, 'sisesc', 2, 'selclasificacionproducto', '2024-02-26 14:11:17', b'1'),
(5589, 'sisesc', 2, 'selproducto', '2024-02-26 14:12:23', b'1'),
(5590, 'sisesc', 2, 'addproducto', '2024-02-26 14:12:23', b'1'),
(5591, 'sisesc', 2, 'selproveedor', '2024-02-26 14:12:29', b'1'),
(5592, 'sisesc', 2, 'getproveedor', '2024-02-26 14:12:39', b'1'),
(5593, 'sisesc', 2, 'getpersona', '2024-02-26 14:12:39', b'1'),
(5594, 'sisesc', 2, 'addcompra', '2024-02-26 14:12:39', b'1'),
(5595, 'sisesc', 2, 'selproducto', '2024-02-26 14:12:39', b'1'),
(5596, 'sisesc', 2, 'getproducto', '2024-02-26 14:12:47', b'1'),
(5597, 'sisesc', 2, 'addcompradetalle', '2024-02-26 14:13:00', b'1'),
(5598, 'sisesc', 2, 'selcompradetalle', '2024-02-26 14:13:00', b'1'),
(5599, 'sisesc', 2, 'papcompra', '2024-02-26 14:13:02', b'1'),
(5600, 'sisesc', 2, 'getcompra', '2024-02-26 14:13:03', b'1'),
(5601, 'sisesc', 2, 'selproveedor', '2024-02-26 14:13:03', b'1'),
(5602, 'sisesc', 2, 'selcompradetalle', '2024-02-26 14:13:03', b'1'),
(5603, 'sisesc', 2, 'selproducto', '2024-02-26 14:13:03', b'1'),
(5604, 'sisesc', 2, 'getproveedor', '2024-02-26 14:13:03', b'1'),
(5605, 'sisesc', 2, 'getpersona', '2024-02-26 14:13:04', b'1'),
(5606, 'sisesc', 2, 'selmarca', '2024-02-26 14:13:29', b'1'),
(5607, 'sisesc', 2, 'selmarca', '2024-02-26 14:13:31', b'1'),
(5608, 'sisesc', 2, 'addmarca', '2024-02-26 14:13:51', b'1'),
(5609, 'sisesc', 2, 'selmarca', '2024-02-26 14:13:51', b'1'),
(5610, 'sisesc', 2, 'selproveedor', '2024-02-26 14:13:57', b'1'),
(5611, 'sisesc', 2, 'selproveedor', '2024-02-26 14:14:06', b'1'),
(5612, 'sisesc', 2, 'getproveedor', '2024-02-26 14:14:12', b'1'),
(5613, 'sisesc', 2, 'getpersona', '2024-02-26 14:14:12', b'1'),
(5614, 'sisesc', 2, 'addcompra', '2024-02-26 14:14:13', b'1'),
(5615, 'sisesc', 2, 'selproducto', '2024-02-26 14:14:13', b'1'),
(5616, 'sisesc', 2, 'selproducto', '2024-02-26 14:14:26', b'1'),
(5617, 'sisesc', 2, 'selmarca', '2024-02-26 14:14:28', b'1'),
(5618, 'sisesc', 2, 'selclasificacionproducto', '2024-02-26 14:14:28', b'1'),
(5619, 'sisesc', 2, 'selproducto', '2024-02-26 14:15:38', b'1'),
(5620, 'sisesc', 2, 'addproducto', '2024-02-26 14:15:38', b'1'),
(5621, 'sisesc', 2, 'selproveedor', '2024-02-26 14:15:41', b'1'),
(5622, 'sisesc', 2, 'getproveedor', '2024-02-26 14:15:45', b'1'),
(5623, 'sisesc', 2, 'getpersona', '2024-02-26 14:15:45', b'1'),
(5624, 'sisesc', 2, 'addcompra', '2024-02-26 14:15:45', b'1'),
(5625, 'sisesc', 2, 'selproducto', '2024-02-26 14:15:46', b'1'),
(5626, 'sisesc', 2, 'getproducto', '2024-02-26 14:15:50', b'1'),
(5627, 'sisesc', 2, 'addcompradetalle', '2024-02-26 14:16:18', b'1'),
(5628, 'sisesc', 2, 'selcompradetalle', '2024-02-26 14:16:19', b'1'),
(5629, 'sisesc', 2, 'papcompra', '2024-02-26 14:16:20', b'1'),
(5630, 'sisesc', 2, 'selproveedor', '2024-02-26 14:16:21', b'1'),
(5631, 'sisesc', 2, 'getcompra', '2024-02-26 14:16:21', b'1'),
(5632, 'sisesc', 2, 'selcompradetalle', '2024-02-26 14:16:21', b'1'),
(5633, 'sisesc', 2, 'selproducto', '2024-02-26 14:16:21', b'1'),
(5634, 'sisesc', 2, 'getproveedor', '2024-02-26 14:16:22', b'1'),
(5635, 'sisesc', 2, 'getpersona', '2024-02-26 14:16:22', b'1'),
(5636, 'sisesc', 2, 'selmarca', '2024-02-26 14:17:09', b'1'),
(5637, 'sisesc', 2, 'selmarca', '2024-02-26 14:17:11', b'1'),
(5638, 'sisesc', 2, 'addmarca', '2024-02-26 14:17:33', b'1'),
(5639, 'sisesc', 2, 'selmarca', '2024-02-26 14:17:33', b'1'),
(5640, 'sisesc', 2, 'selmarca', '2024-02-26 14:17:40', b'1'),
(5641, 'sisesc', 2, 'addmarca', '2024-02-26 14:17:48', b'1'),
(5642, 'sisesc', 2, 'selmarca', '2024-02-26 14:17:48', b'1'),
(5643, 'sisesc', 2, 'selmarca', '2024-02-26 14:17:52', b'1'),
(5644, 'sisesc', 2, 'addmarca', '2024-02-26 14:19:01', b'1'),
(5645, 'sisesc', 2, 'selmarca', '2024-02-26 14:19:01', b'1'),
(5646, 'sisesc', 2, 'selmarca', '2024-02-26 14:19:04', b'1'),
(5647, 'sisesc', 2, 'addmarca', '2024-02-26 14:19:14', b'1'),
(5648, 'sisesc', 2, 'selmarca', '2024-02-26 14:19:15', b'1'),
(5649, 'sisesc', 2, 'selmarca', '2024-02-26 14:20:09', b'1'),
(5650, 'sisesc', 2, 'addmarca', '2024-02-26 14:20:19', b'1'),
(5651, 'sisesc', 2, 'selmarca', '2024-02-26 14:20:19', b'1'),
(5652, 'sisesc', 1, 'seloficina', '2024-02-26 16:20:58', b'1'),
(5653, 'sisesc', 1, 'seloficina', '2024-02-26 16:22:04', b'1'),
(5654, 'sisesc', 1, 'selproveedor', '2024-02-26 16:23:38', b'1'),
(5655, 'sisesc', 1, 'selproveedor', '2024-02-26 16:26:32', b'1'),
(5656, 'sisesc', 1, 'selproveedor', '2024-02-26 16:27:11', b'1'),
(5657, 'sisesc', 1, 'selcliente', '2024-02-26 16:30:30', b'1'),
(5658, 'sisesc', 1, 'selcotizacion', '2024-02-26 16:30:34', b'1'),
(5659, 'sisesc', 1, 'selcliente', '2024-02-26 16:30:37', b'1'),
(5660, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:30:37', b'1'),
(5661, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:30:37', b'1'),
(5662, 'sisesc', 1, 'selproducto', '2024-02-26 16:30:38', b'1'),
(5663, 'sisesc', 1, 'getcliente', '2024-02-26 16:30:38', b'1'),
(5664, 'sisesc', 1, 'getpersona', '2024-02-26 16:30:38', b'1'),
(5665, 'sisesc', 1, 'getproducto', '2024-02-26 16:30:42', b'1'),
(5666, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:40:28', b'1'),
(5667, 'sisesc', 1, 'selcliente', '2024-02-26 16:40:28', b'1'),
(5668, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:40:28', b'1'),
(5669, 'sisesc', 1, 'selproducto', '2024-02-26 16:40:29', b'1'),
(5670, 'sisesc', 1, 'getcliente', '2024-02-26 16:40:29', b'1'),
(5671, 'sisesc', 1, 'getpersona', '2024-02-26 16:40:29', b'1'),
(5672, 'sisesc', 1, 'getproducto', '2024-02-26 16:40:34', b'1'),
(5673, 'sisesc', 1, 'getproducto', '2024-02-26 16:44:54', b'1'),
(5674, 'sisesc', 1, 'selcliente', '2024-02-26 16:47:53', b'1'),
(5675, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:47:53', b'1'),
(5676, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:47:53', b'1'),
(5677, 'sisesc', 1, 'selproducto', '2024-02-26 16:47:53', b'1'),
(5678, 'sisesc', 1, 'getcliente', '2024-02-26 16:47:54', b'1'),
(5679, 'sisesc', 1, 'getpersona', '2024-02-26 16:47:54', b'1'),
(5680, 'sisesc', 1, 'selcliente', '2024-02-26 16:48:03', b'1'),
(5681, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:48:03', b'1'),
(5682, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:48:03', b'1'),
(5683, 'sisesc', 1, 'selproducto', '2024-02-26 16:48:04', b'1'),
(5684, 'sisesc', 1, 'getcliente', '2024-02-26 16:48:04', b'1'),
(5685, 'sisesc', 1, 'getpersona', '2024-02-26 16:48:04', b'1'),
(5686, 'sisesc', 1, 'getproducto', '2024-02-26 16:48:11', b'1'),
(5687, 'sisesc', 1, 'selcliente', '2024-02-26 16:49:03', b'1'),
(5688, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:49:03', b'1'),
(5689, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:49:03', b'1'),
(5690, 'sisesc', 1, 'selproducto', '2024-02-26 16:49:03', b'1');
INSERT INTO `seg_tbllogusuario` (`idlogusuario`, `nombresistema`, `idusuario`, `nombreservicio`, `fecharegistro`, `estadoregistro`) VALUES
(5691, 'sisesc', 1, 'getcliente', '2024-02-26 16:49:03', b'1'),
(5692, 'sisesc', 1, 'getpersona', '2024-02-26 16:49:04', b'1'),
(5693, 'sisesc', 1, 'getproducto', '2024-02-26 16:49:08', b'1'),
(5694, 'sisesc', 1, 'addcotizaciondetalle', '2024-02-26 16:49:19', b'1'),
(5695, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:49:19', b'1'),
(5696, 'sisesc', 1, 'updcotizacion', '2024-02-26 16:50:05', b'1'),
(5697, 'sisesc', 1, 'selcliente', '2024-02-26 16:50:06', b'1'),
(5698, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:50:06', b'1'),
(5699, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:50:06', b'1'),
(5700, 'sisesc', 1, 'selproducto', '2024-02-26 16:50:06', b'1'),
(5701, 'sisesc', 1, 'getcliente', '2024-02-26 16:50:06', b'1'),
(5702, 'sisesc', 1, 'getpersona', '2024-02-26 16:50:07', b'1'),
(5703, 'sisesc', 1, 'selcliente', '2024-02-26 16:50:32', b'1'),
(5704, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:50:32', b'1'),
(5705, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:50:33', b'1'),
(5706, 'sisesc', 1, 'selproducto', '2024-02-26 16:50:33', b'1'),
(5707, 'sisesc', 1, 'getcliente', '2024-02-26 16:50:33', b'1'),
(5708, 'sisesc', 1, 'getpersona', '2024-02-26 16:50:34', b'1'),
(5709, 'sisesc', 1, 'selcliente', '2024-02-26 16:51:05', b'1'),
(5710, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:51:05', b'1'),
(5711, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:51:05', b'1'),
(5712, 'sisesc', 1, 'selproducto', '2024-02-26 16:51:06', b'1'),
(5713, 'sisesc', 1, 'getcliente', '2024-02-26 16:51:06', b'1'),
(5714, 'sisesc', 1, 'getpersona', '2024-02-26 16:51:06', b'1'),
(5715, 'sisesc', 1, 'selcliente', '2024-02-26 16:51:27', b'1'),
(5716, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:51:27', b'1'),
(5717, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:51:27', b'1'),
(5718, 'sisesc', 1, 'selproducto', '2024-02-26 16:51:27', b'1'),
(5719, 'sisesc', 1, 'getcliente', '2024-02-26 16:51:28', b'1'),
(5720, 'sisesc', 1, 'getpersona', '2024-02-26 16:51:28', b'1'),
(5721, 'sisesc', 1, 'selcliente', '2024-02-26 16:53:45', b'1'),
(5722, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:53:45', b'1'),
(5723, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:53:45', b'1'),
(5724, 'sisesc', 1, 'selproducto', '2024-02-26 16:53:45', b'1'),
(5725, 'sisesc', 1, 'getcliente', '2024-02-26 16:53:46', b'1'),
(5726, 'sisesc', 1, 'getpersona', '2024-02-26 16:53:46', b'1'),
(5727, 'sisesc', 1, 'getcotizacion', '2024-02-26 16:53:51', b'1'),
(5728, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-26 16:53:51', b'1'),
(5729, 'sisesc', 1, 'getcliente', '2024-02-26 16:53:52', b'1'),
(5730, 'sisesc', 1, 'getpersona', '2024-02-26 16:53:52', b'1'),
(5731, 'sisesc', 1, 'selcotizacion', '2024-02-26 16:54:22', b'1'),
(5732, 'sisesc', 1, 'selcompra', '2024-02-26 16:55:19', b'1'),
(5733, 'sisesc', 1, 'selcompra', '2024-02-26 16:56:04', b'1'),
(5734, 'sisesc', 1, 'selcotizacion', '2024-02-26 16:56:16', b'1'),
(5735, 'sisesc', 1, 'selcliente', '2024-02-26 16:56:18', b'1'),
(5736, 'sisesc', 1, 'getcliente', '2024-02-26 16:56:21', b'1'),
(5737, 'sisesc', 1, 'getpersona', '2024-02-26 16:56:21', b'1'),
(5738, 'sisesc', 1, 'addcotizacion', '2024-02-26 16:56:21', b'1'),
(5739, 'sisesc', 1, 'selproducto', '2024-02-26 16:56:21', b'1'),
(5740, 'sisesc', 1, 'selcotizacion', '2024-02-26 16:56:27', b'1'),
(5741, 'sisesc', 1, 'selcotizacion', '2024-02-26 17:04:16', b'1'),
(5742, 'sisesc', 1, 'selcliente', '2024-02-26 17:04:20', b'1'),
(5743, 'sisesc', 1, 'getcliente', '2024-02-26 17:04:29', b'1'),
(5744, 'sisesc', 1, 'getpersona', '2024-02-26 17:04:30', b'1'),
(5745, 'sisesc', 1, 'addventa', '2024-02-26 17:04:30', b'1'),
(5746, 'sisesc', 1, 'selproducto', '2024-02-26 17:04:30', b'1'),
(5747, 'sisesc', 1, 'getproducto', '2024-02-26 17:41:04', b'1'),
(5748, 'sisesc', 1, 'selproveedor', '2024-02-26 17:45:10', b'1'),
(5749, 'sisesc', 1, 'selcompra', '2024-02-26 17:45:11', b'1'),
(5750, 'sisesc', 1, 'selcompra', '2024-02-26 17:45:19', b'1'),
(5751, 'sisesc', 1, 'selcompra', '2024-02-26 17:46:00', b'1'),
(5752, 'sisesc', 1, 'selcompra', '2024-02-26 17:46:41', b'1'),
(5753, 'sisesc', 1, 'selcompra', '2024-02-26 17:46:54', b'1'),
(5754, 'sisesc', 1, 'selcompra', '2024-02-26 17:47:05', b'1'),
(5755, 'sisesc', 1, 'selcompra', '2024-02-26 17:47:33', b'1'),
(5756, 'sisesc', 1, 'selventa', '2024-02-26 17:47:43', b'1'),
(5757, 'sisesc', 1, 'selcliente', '2024-02-26 17:47:45', b'1'),
(5758, 'sisesc', 1, 'getventa', '2024-02-26 17:47:45', b'1'),
(5759, 'sisesc', 1, 'selventadetalle', '2024-02-26 17:47:45', b'1'),
(5760, 'sisesc', 1, 'selproducto', '2024-02-26 17:47:45', b'1'),
(5761, 'sisesc', 1, 'selcliente', '2024-02-26 17:48:33', b'1'),
(5762, 'sisesc', 1, 'getventa', '2024-02-26 17:48:33', b'1'),
(5763, 'sisesc', 1, 'selventadetalle', '2024-02-26 17:48:33', b'1'),
(5764, 'sisesc', 1, 'selproducto', '2024-02-26 17:48:33', b'1'),
(5765, 'sisesc', 1, 'getcliente', '2024-02-26 17:48:33', b'1'),
(5766, 'sisesc', 1, 'getpersona', '2024-02-26 17:48:34', b'1'),
(5767, 'sisesc', 1, 'selcliente', '2024-02-26 17:49:10', b'1'),
(5768, 'sisesc', 1, 'getventa', '2024-02-26 17:49:10', b'1'),
(5769, 'sisesc', 1, 'selventadetalle', '2024-02-26 17:49:10', b'1'),
(5770, 'sisesc', 1, 'selproductostock', '2024-02-26 17:49:11', b'1'),
(5771, 'sisesc', 1, 'getcliente', '2024-02-26 17:49:11', b'1'),
(5772, 'sisesc', 1, 'getpersona', '2024-02-26 17:49:11', b'1'),
(5773, 'sisesc', 1, 'selcliente', '2024-02-26 17:52:41', b'1'),
(5774, 'sisesc', 1, 'getventa', '2024-02-26 17:52:41', b'1'),
(5775, 'sisesc', 1, 'selventadetalle', '2024-02-26 17:52:41', b'1'),
(5776, 'sisesc', 1, 'selproductostock', '2024-02-26 17:52:41', b'1'),
(5777, 'sisesc', 1, 'getcliente', '2024-02-26 17:52:41', b'1'),
(5778, 'sisesc', 1, 'getpersona', '2024-02-26 17:52:42', b'1'),
(5779, 'sisesc', 1, 'getproducto', '2024-02-26 17:52:44', b'1'),
(5780, 'sisesc', 1, 'getventa', '2024-02-26 20:07:31', b'1'),
(5781, 'sisesc', 1, 'selcliente', '2024-02-26 20:07:31', b'1'),
(5782, 'sisesc', 1, 'selventadetalle', '2024-02-26 20:07:31', b'1'),
(5783, 'sisesc', 1, 'selproductostock', '2024-02-26 20:07:31', b'1'),
(5784, 'sisesc', 1, 'getcliente', '2024-02-26 20:07:32', b'1'),
(5785, 'sisesc', 1, 'getpersona', '2024-02-26 20:07:32', b'1'),
(5786, 'sisesc', 1, 'selcliente', '2024-02-26 20:09:54', b'1'),
(5787, 'sisesc', 1, 'getventa', '2024-02-26 20:09:54', b'1'),
(5788, 'sisesc', 1, 'selventadetalle', '2024-02-26 20:09:54', b'1'),
(5789, 'sisesc', 1, 'selproductostock', '2024-02-26 20:09:55', b'1'),
(5790, 'sisesc', 1, 'getcliente', '2024-02-26 20:09:55', b'1'),
(5791, 'sisesc', 1, 'getpersona', '2024-02-26 20:09:55', b'1'),
(5792, 'sisesc', 1, 'selcliente', '2024-02-26 20:22:12', b'1'),
(5793, 'sisesc', 1, 'getventa', '2024-02-26 20:22:12', b'1'),
(5794, 'sisesc', 1, 'selventadetalle', '2024-02-26 20:22:12', b'1'),
(5795, 'sisesc', 1, 'selproductostock', '2024-02-26 20:22:13', b'1'),
(5796, 'sisesc', 1, 'getcliente', '2024-02-26 20:22:13', b'1'),
(5797, 'sisesc', 1, 'getpersona', '2024-02-26 20:22:13', b'1'),
(5798, 'sisesc', 1, 'selcliente', '2024-02-26 20:22:54', b'1'),
(5799, 'sisesc', 1, 'getventa', '2024-02-26 20:22:54', b'1'),
(5800, 'sisesc', 1, 'selventadetalle', '2024-02-26 20:22:54', b'1'),
(5801, 'sisesc', 1, 'selproductostock', '2024-02-26 20:22:55', b'1'),
(5802, 'sisesc', 1, 'getcliente', '2024-02-26 20:22:55', b'1'),
(5803, 'sisesc', 1, 'getpersona', '2024-02-26 20:22:55', b'1'),
(5804, 'sisesc', 1, 'getproductostock', '2024-02-26 20:23:53', b'1'),
(5805, 'sisesc', 1, 'getproducto', '2024-02-26 20:23:53', b'1'),
(5806, 'sisesc', 1, 'selcliente', '2024-02-26 20:24:30', b'1'),
(5807, 'sisesc', 1, 'getventa', '2024-02-26 20:24:30', b'1'),
(5808, 'sisesc', 1, 'selventadetalle', '2024-02-26 20:24:30', b'1'),
(5809, 'sisesc', 1, 'selproductostock', '2024-02-26 20:24:31', b'1'),
(5810, 'sisesc', 1, 'getcliente', '2024-02-26 20:24:31', b'1'),
(5811, 'sisesc', 1, 'getpersona', '2024-02-26 20:24:31', b'1'),
(5812, 'sisesc', 1, 'getproductostock', '2024-02-26 20:24:35', b'1'),
(5813, 'sisesc', 1, 'getproducto', '2024-02-26 20:24:35', b'1'),
(5814, 'sisesc', 1, 'addventadetalle', '2024-02-26 20:24:50', b'1'),
(5815, 'sisesc', 1, 'selventadetalle', '2024-02-26 20:24:50', b'1'),
(5816, 'sisesc', 1, 'seloficina', '2024-02-26 22:54:02', b'1'),
(5817, 'sisesc', 1, 'seloficina', '2024-02-26 22:54:05', b'1'),
(5818, 'sisesc', 1, 'selusuario', '2024-02-26 22:54:25', b'1'),
(5819, 'sisesc', 1, 'selcompra', '2024-02-26 22:54:29', b'1'),
(5820, 'sisesc', 1, 'selproveedor', '2024-02-26 22:54:45', b'1'),
(5821, 'sisesc', 1, 'seloficina', '2024-02-27 15:10:13', b'1'),
(5822, 'sisesc', 1, 'selventa', '2024-02-27 15:12:26', b'1'),
(5823, 'sisesc', 1, 'selventa', '2024-02-27 15:12:28', b'1'),
(5824, 'sisesc', 1, 'selcliente', '2024-02-27 15:12:30', b'1'),
(5825, 'sisesc', 1, 'getventa', '2024-02-27 15:12:30', b'1'),
(5826, 'sisesc', 1, 'selventadetalle', '2024-02-27 15:12:31', b'1'),
(5827, 'sisesc', 1, 'selproductostock', '2024-02-27 15:12:31', b'1'),
(5828, 'sisesc', 1, 'getcliente', '2024-02-27 15:12:31', b'1'),
(5829, 'sisesc', 1, 'getpersona', '2024-02-27 15:12:32', b'1'),
(5830, 'sisesc', 1, 'selcliente', '2024-02-27 15:12:47', b'1'),
(5831, 'sisesc', 1, 'getventa', '2024-02-27 15:12:47', b'1'),
(5832, 'sisesc', 1, 'selventadetalle', '2024-02-27 15:12:48', b'1'),
(5833, 'sisesc', 1, 'selproductostock', '2024-02-27 15:12:48', b'1'),
(5834, 'sisesc', 1, 'getcliente', '2024-02-27 15:12:48', b'1'),
(5835, 'sisesc', 1, 'getpersona', '2024-02-27 15:12:49', b'1'),
(5836, 'sisesc', 1, 'selcliente', '2024-02-27 15:13:02', b'1'),
(5837, 'sisesc', 1, 'getventa', '2024-02-27 15:13:02', b'1'),
(5838, 'sisesc', 1, 'selventadetalle', '2024-02-27 15:13:02', b'1'),
(5839, 'sisesc', 1, 'selproductostock', '2024-02-27 15:13:03', b'1'),
(5840, 'sisesc', 1, 'getcliente', '2024-02-27 15:13:03', b'1'),
(5841, 'sisesc', 1, 'getpersona', '2024-02-27 15:13:03', b'1'),
(5842, 'sisesc', 1, 'selcliente', '2024-02-27 15:15:29', b'1'),
(5843, 'sisesc', 1, 'getventa', '2024-02-27 15:15:29', b'1'),
(5844, 'sisesc', 1, 'selventadetalle', '2024-02-27 15:15:29', b'1'),
(5845, 'sisesc', 1, 'selproductostock', '2024-02-27 15:15:30', b'1'),
(5846, 'sisesc', 1, 'getcliente', '2024-02-27 15:15:30', b'1'),
(5847, 'sisesc', 1, 'getpersona', '2024-02-27 15:15:30', b'1'),
(5848, 'sisesc', 1, 'selcliente', '2024-02-27 15:15:43', b'1'),
(5849, 'sisesc', 1, 'getventa', '2024-02-27 15:15:43', b'1'),
(5850, 'sisesc', 1, 'selventadetalle', '2024-02-27 15:15:43', b'1'),
(5851, 'sisesc', 1, 'selproductostock', '2024-02-27 15:15:43', b'1'),
(5852, 'sisesc', 1, 'getcliente', '2024-02-27 15:15:43', b'1'),
(5853, 'sisesc', 1, 'getpersona', '2024-02-27 15:15:44', b'1'),
(5854, 'sisesc', 1, 'selcliente', '2024-02-27 15:24:59', b'1'),
(5855, 'sisesc', 1, 'getventa', '2024-02-27 15:24:59', b'1'),
(5856, 'sisesc', 1, 'selventadetalle', '2024-02-27 15:24:59', b'1'),
(5857, 'sisesc', 1, 'selproductostock', '2024-02-27 15:24:59', b'1'),
(5858, 'sisesc', 1, 'getcliente', '2024-02-27 15:25:00', b'1'),
(5859, 'sisesc', 1, 'getpersona', '2024-02-27 15:25:00', b'1'),
(5860, 'sisesc', 1, 'selcliente', '2024-02-27 15:59:32', b'1'),
(5861, 'sisesc', 1, 'getventa', '2024-02-27 15:59:32', b'1'),
(5862, 'sisesc', 1, 'selventadetalle', '2024-02-27 15:59:32', b'1'),
(5863, 'sisesc', 1, 'selproductostock', '2024-02-27 15:59:33', b'1'),
(5864, 'sisesc', 1, 'getcliente', '2024-02-27 15:59:33', b'1'),
(5865, 'sisesc', 1, 'getpersona', '2024-02-27 15:59:33', b'1'),
(5866, 'sisesc', 1, 'selcliente', '2024-02-27 16:00:44', b'1'),
(5867, 'sisesc', 1, 'getventa', '2024-02-27 16:00:44', b'1'),
(5868, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:00:44', b'1'),
(5869, 'sisesc', 1, 'selproductostock', '2024-02-27 16:00:44', b'1'),
(5870, 'sisesc', 1, 'getcliente', '2024-02-27 16:00:45', b'1'),
(5871, 'sisesc', 1, 'getpersona', '2024-02-27 16:00:45', b'1'),
(5872, 'sisesc', 1, 'getventa', '2024-02-27 16:00:47', b'1'),
(5873, 'sisesc', 1, 'selcliente', '2024-02-27 16:00:47', b'1'),
(5874, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:00:47', b'1'),
(5875, 'sisesc', 1, 'selproductostock', '2024-02-27 16:00:47', b'1'),
(5876, 'sisesc', 1, 'getcliente', '2024-02-27 16:00:47', b'1'),
(5877, 'sisesc', 1, 'getpersona', '2024-02-27 16:00:48', b'1'),
(5878, 'sisesc', 1, 'selcliente', '2024-02-27 16:03:06', b'1'),
(5879, 'sisesc', 1, 'getventa', '2024-02-27 16:03:06', b'1'),
(5880, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:03:06', b'1'),
(5881, 'sisesc', 1, 'selproductostock', '2024-02-27 16:03:06', b'1'),
(5882, 'sisesc', 1, 'getcliente', '2024-02-27 16:03:06', b'1'),
(5883, 'sisesc', 1, 'getpersona', '2024-02-27 16:03:07', b'1'),
(5884, 'sisesc', 1, 'selcliente', '2024-02-27 16:03:14', b'1'),
(5885, 'sisesc', 1, 'getventa', '2024-02-27 16:03:14', b'1'),
(5886, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:03:14', b'1'),
(5887, 'sisesc', 1, 'selproductostock', '2024-02-27 16:03:14', b'1'),
(5888, 'sisesc', 1, 'getcliente', '2024-02-27 16:03:15', b'1'),
(5889, 'sisesc', 1, 'getpersona', '2024-02-27 16:03:15', b'1'),
(5890, 'sisesc', 1, 'selcliente', '2024-02-27 16:03:20', b'1'),
(5891, 'sisesc', 1, 'getventa', '2024-02-27 16:03:20', b'1'),
(5892, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:03:21', b'1'),
(5893, 'sisesc', 1, 'selproductostock', '2024-02-27 16:03:21', b'1'),
(5894, 'sisesc', 1, 'getcliente', '2024-02-27 16:03:21', b'1'),
(5895, 'sisesc', 1, 'getpersona', '2024-02-27 16:03:21', b'1'),
(5896, 'sisesc', 1, 'selcliente', '2024-02-27 16:03:22', b'1'),
(5897, 'sisesc', 1, 'getventa', '2024-02-27 16:03:22', b'1'),
(5898, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:03:23', b'1'),
(5899, 'sisesc', 1, 'selproductostock', '2024-02-27 16:03:23', b'1'),
(5900, 'sisesc', 1, 'getcliente', '2024-02-27 16:03:23', b'1'),
(5901, 'sisesc', 1, 'getpersona', '2024-02-27 16:03:23', b'1'),
(5902, 'sisesc', 1, 'selcliente', '2024-02-27 16:06:32', b'1'),
(5903, 'sisesc', 1, 'getventa', '2024-02-27 16:06:32', b'1'),
(5904, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:06:32', b'1'),
(5905, 'sisesc', 1, 'selproductostock', '2024-02-27 16:06:33', b'1'),
(5906, 'sisesc', 1, 'getcliente', '2024-02-27 16:06:33', b'1'),
(5907, 'sisesc', 1, 'getpersona', '2024-02-27 16:06:33', b'1'),
(5908, 'sisesc', 1, 'selventa', '2024-02-27 16:06:42', b'1'),
(5909, 'sisesc', 1, 'selcliente', '2024-02-27 16:06:44', b'1'),
(5910, 'sisesc', 1, 'getventa', '2024-02-27 16:06:44', b'1'),
(5911, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:06:44', b'1'),
(5912, 'sisesc', 1, 'selproductostock', '2024-02-27 16:06:45', b'1'),
(5913, 'sisesc', 1, 'getcliente', '2024-02-27 16:06:45', b'1'),
(5914, 'sisesc', 1, 'getpersona', '2024-02-27 16:06:45', b'1'),
(5915, 'sisesc', 1, 'selventa', '2024-02-27 16:07:49', b'1'),
(5916, 'sisesc', 1, 'selcliente', '2024-02-27 16:07:50', b'1'),
(5917, 'sisesc', 1, 'getventa', '2024-02-27 16:07:50', b'1'),
(5918, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:07:50', b'1'),
(5919, 'sisesc', 1, 'selproductostock', '2024-02-27 16:07:50', b'1'),
(5920, 'sisesc', 1, 'getcliente', '2024-02-27 16:07:51', b'1'),
(5921, 'sisesc', 1, 'selventa', '2024-02-27 16:07:51', b'1'),
(5922, 'sisesc', 1, 'getpersona', '2024-02-27 16:07:51', b'1'),
(5923, 'sisesc', 1, 'seloficina', '2024-02-27 16:07:52', b'1'),
(5924, 'sisesc', 1, 'seloficina', '2024-02-27 16:07:55', b'1'),
(5925, 'sisesc', 1, 'selusuario', '2024-02-27 16:07:57', b'1'),
(5926, 'sisesc', 1, 'selventa', '2024-02-27 16:08:03', b'1'),
(5927, 'sisesc', 1, 'selcliente', '2024-02-27 16:08:05', b'1'),
(5928, 'sisesc', 1, 'getventa', '2024-02-27 16:08:05', b'1'),
(5929, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:08:05', b'1'),
(5930, 'sisesc', 1, 'selproductostock', '2024-02-27 16:08:05', b'1'),
(5931, 'sisesc', 1, 'getcliente', '2024-02-27 16:08:05', b'1'),
(5932, 'sisesc', 1, 'getpersona', '2024-02-27 16:08:06', b'1'),
(5933, 'sisesc', 1, 'selcliente', '2024-02-27 16:08:22', b'1'),
(5934, 'sisesc', 1, 'getventa', '2024-02-27 16:08:22', b'1'),
(5935, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:08:22', b'1'),
(5936, 'sisesc', 1, 'selproductostock', '2024-02-27 16:08:22', b'1'),
(5937, 'sisesc', 1, 'getcliente', '2024-02-27 16:08:23', b'1'),
(5938, 'sisesc', 1, 'getpersona', '2024-02-27 16:08:23', b'1'),
(5939, 'sisesc', 1, 'getventa', '2024-02-27 16:45:51', b'1'),
(5940, 'sisesc', 1, 'selcliente', '2024-02-27 16:45:51', b'1'),
(5941, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:45:51', b'1'),
(5942, 'sisesc', 1, 'selproductostock', '2024-02-27 16:45:51', b'1'),
(5943, 'sisesc', 1, 'getcliente', '2024-02-27 16:45:52', b'1'),
(5944, 'sisesc', 1, 'getpersona', '2024-02-27 16:45:52', b'1'),
(5945, 'sisesc', 1, 'papventadetalle', '2024-02-27 16:46:04', b'1'),
(5946, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:46:05', b'1'),
(5947, 'sisesc', 1, 'selcliente', '2024-02-27 16:49:49', b'1'),
(5948, 'sisesc', 1, 'getventa', '2024-02-27 16:49:49', b'1'),
(5949, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:49:50', b'1'),
(5950, 'sisesc', 1, 'selproductostock', '2024-02-27 16:49:50', b'1'),
(5951, 'sisesc', 1, 'getcliente', '2024-02-27 16:49:50', b'1'),
(5952, 'sisesc', 1, 'getpersona', '2024-02-27 16:49:50', b'1'),
(5953, 'sisesc', 1, 'papventadetalle', '2024-02-27 16:49:53', b'1'),
(5954, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:49:54', b'1'),
(5955, 'sisesc', 1, 'getproductostock', '2024-02-27 16:50:57', b'1'),
(5956, 'sisesc', 1, 'getproducto', '2024-02-27 16:50:57', b'1'),
(5957, 'sisesc', 1, 'addventadetalle', '2024-02-27 16:50:59', b'1'),
(5958, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:50:59', b'1'),
(5959, 'sisesc', 1, 'papventadetalle', '2024-02-27 16:51:05', b'1'),
(5960, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:51:05', b'1'),
(5961, 'sisesc', 1, 'selcliente', '2024-02-27 16:51:49', b'1'),
(5962, 'sisesc', 1, 'getventa', '2024-02-27 16:51:49', b'1'),
(5963, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:51:49', b'1'),
(5964, 'sisesc', 1, 'selproductostock', '2024-02-27 16:51:49', b'1'),
(5965, 'sisesc', 1, 'getcliente', '2024-02-27 16:51:52', b'1'),
(5966, 'sisesc', 1, 'getpersona', '2024-02-27 16:51:52', b'1'),
(5967, 'sisesc', 1, 'papventadetalle', '2024-02-27 16:51:53', b'1'),
(5968, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:51:53', b'1'),
(5969, 'sisesc', 1, 'selcliente', '2024-02-27 16:56:56', b'1'),
(5970, 'sisesc', 1, 'getventa', '2024-02-27 16:56:56', b'1'),
(5971, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:56:56', b'1'),
(5972, 'sisesc', 1, 'selproductostock', '2024-02-27 16:56:56', b'1'),
(5973, 'sisesc', 1, 'getcliente', '2024-02-27 16:56:57', b'1'),
(5974, 'sisesc', 1, 'getpersona', '2024-02-27 16:56:57', b'1'),
(5975, 'sisesc', 1, 'papventadetalle', '2024-02-27 16:57:03', b'1'),
(5976, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:57:04', b'1'),
(5977, 'sisesc', 1, 'selcliente', '2024-02-27 16:58:55', b'1'),
(5978, 'sisesc', 1, 'getventa', '2024-02-27 16:58:55', b'1'),
(5979, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:58:55', b'1'),
(5980, 'sisesc', 1, 'selproductostock', '2024-02-27 16:58:56', b'1'),
(5981, 'sisesc', 1, 'getcliente', '2024-02-27 16:58:56', b'1'),
(5982, 'sisesc', 1, 'getpersona', '2024-02-27 16:58:56', b'1'),
(5983, 'sisesc', 1, 'papventadetalle', '2024-02-27 16:58:59', b'1'),
(5984, 'sisesc', 1, 'selventadetalle', '2024-02-27 16:58:59', b'1'),
(5985, 'sisesc', 1, 'selcliente', '2024-02-27 17:00:42', b'1'),
(5986, 'sisesc', 1, 'getventa', '2024-02-27 17:00:42', b'1'),
(5987, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:00:42', b'1'),
(5988, 'sisesc', 1, 'selproductostock', '2024-02-27 17:00:43', b'1'),
(5989, 'sisesc', 1, 'getcliente', '2024-02-27 17:00:43', b'1'),
(5990, 'sisesc', 1, 'getpersona', '2024-02-27 17:00:43', b'1'),
(5991, 'sisesc', 1, 'papventadetalle', '2024-02-27 17:00:51', b'1'),
(5992, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:00:51', b'1'),
(5993, 'sisesc', 1, 'papventadetalle', '2024-02-27 17:01:11', b'1'),
(5994, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:01:12', b'1'),
(5995, 'sisesc', 1, 'selcliente', '2024-02-27 17:02:25', b'1'),
(5996, 'sisesc', 1, 'getventa', '2024-02-27 17:02:25', b'1'),
(5997, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:02:25', b'1'),
(5998, 'sisesc', 1, 'selproductostock', '2024-02-27 17:02:25', b'1'),
(5999, 'sisesc', 1, 'getcliente', '2024-02-27 17:02:26', b'1'),
(6000, 'sisesc', 1, 'getpersona', '2024-02-27 17:02:26', b'1'),
(6001, 'sisesc', 1, 'getproductostock', '2024-02-27 17:02:29', b'1'),
(6002, 'sisesc', 1, 'getproducto', '2024-02-27 17:02:29', b'1'),
(6003, 'sisesc', 1, 'addventadetalle', '2024-02-27 17:02:34', b'1'),
(6004, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:02:34', b'1'),
(6005, 'sisesc', 1, 'papventadetalle', '2024-02-27 17:03:00', b'1'),
(6006, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:03:00', b'1'),
(6007, 'sisesc', 1, 'selcliente', '2024-02-27 17:34:34', b'1'),
(6008, 'sisesc', 1, 'getventa', '2024-02-27 17:34:34', b'1'),
(6009, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:34:34', b'1'),
(6010, 'sisesc', 1, 'selproductostock', '2024-02-27 17:34:35', b'1'),
(6011, 'sisesc', 1, 'getcliente', '2024-02-27 17:34:35', b'1'),
(6012, 'sisesc', 1, 'getpersona', '2024-02-27 17:34:35', b'1'),
(6013, 'sisesc', 1, 'selcliente', '2024-02-27 17:35:19', b'1'),
(6014, 'sisesc', 1, 'getventa', '2024-02-27 17:35:19', b'1'),
(6015, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:35:20', b'1'),
(6016, 'sisesc', 1, 'selproductostock', '2024-02-27 17:35:20', b'1'),
(6017, 'sisesc', 1, 'getcliente', '2024-02-27 17:35:20', b'1'),
(6018, 'sisesc', 1, 'getpersona', '2024-02-27 17:35:20', b'1'),
(6019, 'sisesc', 1, 'selcliente', '2024-02-27 17:35:46', b'1'),
(6020, 'sisesc', 1, 'getventa', '2024-02-27 17:35:46', b'1'),
(6021, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:35:46', b'1'),
(6022, 'sisesc', 1, 'selproductostock', '2024-02-27 17:35:47', b'1'),
(6023, 'sisesc', 1, 'getcliente', '2024-02-27 17:35:47', b'1'),
(6024, 'sisesc', 1, 'getpersona', '2024-02-27 17:35:47', b'1'),
(6025, 'sisesc', 1, 'selcliente', '2024-02-27 17:36:35', b'1'),
(6026, 'sisesc', 1, 'getventa', '2024-02-27 17:36:35', b'1'),
(6027, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:36:35', b'1'),
(6028, 'sisesc', 1, 'selproductostock', '2024-02-27 17:36:36', b'1'),
(6029, 'sisesc', 1, 'getcliente', '2024-02-27 17:36:36', b'1'),
(6030, 'sisesc', 1, 'getpersona', '2024-02-27 17:36:36', b'1'),
(6031, 'sisesc', 1, 'getproductostock', '2024-02-27 17:37:38', b'1'),
(6032, 'sisesc', 1, 'getproducto', '2024-02-27 17:37:38', b'1'),
(6033, 'sisesc', 1, 'selcliente', '2024-02-27 17:53:15', b'1'),
(6034, 'sisesc', 1, 'getventa', '2024-02-27 17:53:15', b'1'),
(6035, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:53:15', b'1'),
(6036, 'sisesc', 1, 'selproductostock', '2024-02-27 17:53:15', b'1'),
(6037, 'sisesc', 1, 'getcliente', '2024-02-27 17:53:15', b'1'),
(6038, 'sisesc', 1, 'getpersona', '2024-02-27 17:53:16', b'1'),
(6039, 'sisesc', 1, 'getproductostock', '2024-02-27 17:53:17', b'1'),
(6040, 'sisesc', 1, 'getproducto', '2024-02-27 17:53:17', b'1'),
(6041, 'sisesc', 1, 'addventadetalle', '2024-02-27 17:53:58', b'1'),
(6042, 'sisesc', 1, 'selventadetalle', '2024-02-27 17:53:58', b'1'),
(6043, 'sisesc', 1, 'getventa', '2024-02-27 19:54:16', b'1'),
(6044, 'sisesc', 1, 'selcliente', '2024-02-27 19:54:16', b'1'),
(6045, 'sisesc', 1, 'selventadetalle', '2024-02-27 19:54:16', b'1'),
(6046, 'sisesc', 1, 'selproductostock', '2024-02-27 19:54:16', b'1'),
(6047, 'sisesc', 1, 'getcliente', '2024-02-27 19:54:17', b'1'),
(6048, 'sisesc', 1, 'getpersona', '2024-02-27 19:54:17', b'1'),
(6049, 'sisesc', 1, 'papventadetalle', '2024-02-27 19:54:19', b'1'),
(6050, 'sisesc', 1, 'selventadetalle', '2024-02-27 19:54:20', b'1'),
(6051, 'sisesc', 1, 'papventadetalle', '2024-02-27 19:54:22', b'1'),
(6052, 'sisesc', 1, 'selventadetalle', '2024-02-27 19:54:22', b'1'),
(6053, 'sisesc', 1, 'papventadetalle', '2024-02-27 19:54:24', b'1'),
(6054, 'sisesc', 1, 'selventadetalle', '2024-02-27 19:54:24', b'1'),
(6055, 'sisesc', 1, 'getproductostock', '2024-02-27 19:54:26', b'1'),
(6056, 'sisesc', 1, 'getproducto', '2024-02-27 19:54:27', b'1'),
(6057, 'sisesc', 1, 'addventadetalle', '2024-02-27 19:54:29', b'1'),
(6058, 'sisesc', 1, 'selventadetalle', '2024-02-27 19:54:29', b'1'),
(6059, 'sisesc', 1, 'getproductostock', '2024-02-27 19:54:58', b'1'),
(6060, 'sisesc', 1, 'getproducto', '2024-02-27 19:54:58', b'1'),
(6061, 'sisesc', 1, 'addventadetalle', '2024-02-27 19:55:00', b'1'),
(6062, 'sisesc', 1, 'selventadetalle', '2024-02-27 19:55:00', b'1'),
(6063, 'sisesc', 1, 'selventa', '2024-02-27 20:20:00', b'1'),
(6064, 'sisesc', 1, 'selcliente', '2024-02-27 20:20:02', b'1'),
(6065, 'sisesc', 1, 'getventa', '2024-02-27 20:20:02', b'1'),
(6066, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:20:02', b'1'),
(6067, 'sisesc', 1, 'selproductostock', '2024-02-27 20:20:02', b'1'),
(6068, 'sisesc', 1, 'getcliente', '2024-02-27 20:20:02', b'1'),
(6069, 'sisesc', 1, 'getpersona', '2024-02-27 20:20:03', b'1'),
(6070, 'sisesc', 1, 'papventa', '2024-02-27 20:20:23', b'1'),
(6071, 'sisesc', 1, 'selcliente', '2024-02-27 20:23:44', b'1'),
(6072, 'sisesc', 1, 'getventa', '2024-02-27 20:23:44', b'1'),
(6073, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:23:44', b'1'),
(6074, 'sisesc', 1, 'selproductostock', '2024-02-27 20:23:45', b'1'),
(6075, 'sisesc', 1, 'getcliente', '2024-02-27 20:23:45', b'1'),
(6076, 'sisesc', 1, 'getpersona', '2024-02-27 20:23:45', b'1'),
(6077, 'sisesc', 1, 'papventa', '2024-02-27 20:23:49', b'1'),
(6078, 'sisesc', 1, 'selcliente', '2024-02-27 20:25:38', b'1'),
(6079, 'sisesc', 1, 'getventa', '2024-02-27 20:25:38', b'1'),
(6080, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:25:38', b'1'),
(6081, 'sisesc', 1, 'selproductostock', '2024-02-27 20:25:38', b'1'),
(6082, 'sisesc', 1, 'getcliente', '2024-02-27 20:25:39', b'1'),
(6083, 'sisesc', 1, 'getpersona', '2024-02-27 20:25:39', b'1'),
(6084, 'sisesc', 1, 'papventa', '2024-02-27 20:25:41', b'1'),
(6085, 'sisesc', 1, 'selcliente', '2024-02-27 20:25:43', b'1'),
(6086, 'sisesc', 1, 'getventa', '2024-02-27 20:25:43', b'1'),
(6087, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:25:43', b'1'),
(6088, 'sisesc', 1, 'selproductostock', '2024-02-27 20:25:43', b'1'),
(6089, 'sisesc', 1, 'getcliente', '2024-02-27 20:25:44', b'1'),
(6090, 'sisesc', 1, 'getpersona', '2024-02-27 20:25:44', b'1'),
(6091, 'sisesc', 1, 'selcliente', '2024-02-27 20:27:31', b'1'),
(6092, 'sisesc', 1, 'getventa', '2024-02-27 20:27:31', b'1'),
(6093, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:27:32', b'1'),
(6094, 'sisesc', 1, 'selproductostock', '2024-02-27 20:27:32', b'1'),
(6095, 'sisesc', 1, 'getcliente', '2024-02-27 20:27:32', b'1'),
(6096, 'sisesc', 1, 'getpersona', '2024-02-27 20:27:33', b'1'),
(6097, 'sisesc', 1, 'papventa', '2024-02-27 20:27:36', b'1'),
(6098, 'sisesc', 1, 'selcliente', '2024-02-27 20:27:37', b'1'),
(6099, 'sisesc', 1, 'getventa', '2024-02-27 20:27:37', b'1'),
(6100, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:27:37', b'1'),
(6101, 'sisesc', 1, 'selproductostock', '2024-02-27 20:27:38', b'1'),
(6102, 'sisesc', 1, 'getcliente', '2024-02-27 20:27:38', b'1'),
(6103, 'sisesc', 1, 'getpersona', '2024-02-27 20:27:38', b'1'),
(6104, 'sisesc', 1, 'selcliente', '2024-02-27 20:29:35', b'1'),
(6105, 'sisesc', 1, 'getventa', '2024-02-27 20:29:35', b'1'),
(6106, 'sisesc', 1, 'getventa', '2024-02-27 20:31:47', b'1'),
(6107, 'sisesc', 1, 'selcliente', '2024-02-27 20:31:47', b'1'),
(6108, 'sisesc', 1, 'selventa', '2024-02-27 20:31:51', b'1'),
(6109, 'sisesc', 1, 'selcliente', '2024-02-27 20:31:53', b'1'),
(6110, 'sisesc', 1, 'getcliente', '2024-02-27 20:31:55', b'1'),
(6111, 'sisesc', 1, 'getpersona', '2024-02-27 20:31:56', b'1'),
(6112, 'sisesc', 1, 'addventa', '2024-02-27 20:31:56', b'1'),
(6113, 'sisesc', 1, 'selproducto', '2024-02-27 20:31:56', b'1'),
(6114, 'sisesc', 1, 'getproductostock', '2024-02-27 20:31:59', b'1'),
(6115, 'sisesc', 1, 'selcliente', '2024-02-27 20:32:13', b'1'),
(6116, 'sisesc', 1, 'getventa', '2024-02-27 20:32:13', b'1'),
(6117, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:32:13', b'1'),
(6118, 'sisesc', 1, 'selproductostock', '2024-02-27 20:32:13', b'1'),
(6119, 'sisesc', 1, 'getcliente', '2024-02-27 20:32:13', b'1'),
(6120, 'sisesc', 1, 'getpersona', '2024-02-27 20:32:14', b'1'),
(6121, 'sisesc', 1, 'getproductostock', '2024-02-27 20:32:15', b'1'),
(6122, 'sisesc', 1, 'getproducto', '2024-02-27 20:32:15', b'1'),
(6123, 'sisesc', 1, 'addventadetalle', '2024-02-27 20:32:17', b'1'),
(6124, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:32:17', b'1'),
(6125, 'sisesc', 1, 'selcliente', '2024-02-27 20:33:47', b'1'),
(6126, 'sisesc', 1, 'getventa', '2024-02-27 20:33:47', b'1'),
(6127, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:33:47', b'1'),
(6128, 'sisesc', 1, 'selproductostock', '2024-02-27 20:33:47', b'1'),
(6129, 'sisesc', 1, 'getcliente', '2024-02-27 20:33:47', b'1'),
(6130, 'sisesc', 1, 'getpersona', '2024-02-27 20:33:48', b'1'),
(6131, 'sisesc', 1, 'selcliente', '2024-02-27 20:34:05', b'1'),
(6132, 'sisesc', 1, 'getventa', '2024-02-27 20:34:05', b'1'),
(6133, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:34:05', b'1'),
(6134, 'sisesc', 1, 'selproductostock', '2024-02-27 20:34:05', b'1'),
(6135, 'sisesc', 1, 'getcliente', '2024-02-27 20:34:05', b'1'),
(6136, 'sisesc', 1, 'getpersona', '2024-02-27 20:34:06', b'1'),
(6137, 'sisesc', 1, 'selcliente', '2024-02-27 20:34:21', b'1'),
(6138, 'sisesc', 1, 'getventa', '2024-02-27 20:34:21', b'1'),
(6139, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:34:21', b'1'),
(6140, 'sisesc', 1, 'selproductostock', '2024-02-27 20:34:21', b'1'),
(6141, 'sisesc', 1, 'getcliente', '2024-02-27 20:34:21', b'1'),
(6142, 'sisesc', 1, 'getpersona', '2024-02-27 20:34:22', b'1'),
(6143, 'sisesc', 1, 'selcliente', '2024-02-27 20:34:57', b'1'),
(6144, 'sisesc', 1, 'getventa', '2024-02-27 20:34:57', b'1'),
(6145, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:34:58', b'1'),
(6146, 'sisesc', 1, 'selproductostock', '2024-02-27 20:34:58', b'1'),
(6147, 'sisesc', 1, 'getcliente', '2024-02-27 20:34:58', b'1'),
(6148, 'sisesc', 1, 'getpersona', '2024-02-27 20:34:58', b'1'),
(6149, 'sisesc', 1, 'selcliente', '2024-02-27 20:35:10', b'1'),
(6150, 'sisesc', 1, 'getventa', '2024-02-27 20:35:10', b'1'),
(6151, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:35:10', b'1'),
(6152, 'sisesc', 1, 'selproductostock', '2024-02-27 20:35:11', b'1'),
(6153, 'sisesc', 1, 'getcliente', '2024-02-27 20:35:11', b'1'),
(6154, 'sisesc', 1, 'getpersona', '2024-02-27 20:35:11', b'1'),
(6155, 'sisesc', 1, 'selcliente', '2024-02-27 20:36:21', b'1'),
(6156, 'sisesc', 1, 'getventa', '2024-02-27 20:36:21', b'1'),
(6157, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:36:21', b'1'),
(6158, 'sisesc', 1, 'selproductostock', '2024-02-27 20:36:21', b'1'),
(6159, 'sisesc', 1, 'getcliente', '2024-02-27 20:36:22', b'1'),
(6160, 'sisesc', 1, 'getpersona', '2024-02-27 20:36:22', b'1'),
(6161, 'sisesc', 1, 'selcliente', '2024-02-27 20:36:26', b'1'),
(6162, 'sisesc', 1, 'getventa', '2024-02-27 20:36:26', b'1'),
(6163, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:36:26', b'1'),
(6164, 'sisesc', 1, 'selproductostock', '2024-02-27 20:36:26', b'1'),
(6165, 'sisesc', 1, 'getcliente', '2024-02-27 20:36:26', b'1'),
(6166, 'sisesc', 1, 'getpersona', '2024-02-27 20:36:27', b'1'),
(6167, 'sisesc', 1, 'selcliente', '2024-02-27 20:36:30', b'1'),
(6168, 'sisesc', 1, 'getventa', '2024-02-27 20:36:31', b'1'),
(6169, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:36:31', b'1'),
(6170, 'sisesc', 1, 'selproductostock', '2024-02-27 20:36:31', b'1'),
(6171, 'sisesc', 1, 'getcliente', '2024-02-27 20:36:31', b'1'),
(6172, 'sisesc', 1, 'getpersona', '2024-02-27 20:36:32', b'1'),
(6173, 'sisesc', 1, 'selcliente', '2024-02-27 20:37:00', b'1'),
(6174, 'sisesc', 1, 'getventa', '2024-02-27 20:37:00', b'1'),
(6175, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:37:00', b'1'),
(6176, 'sisesc', 1, 'selproductostock', '2024-02-27 20:37:01', b'1'),
(6177, 'sisesc', 1, 'getcliente', '2024-02-27 20:37:01', b'1'),
(6178, 'sisesc', 1, 'getpersona', '2024-02-27 20:37:01', b'1'),
(6179, 'sisesc', 1, 'getventa', '2024-02-27 20:37:15', b'1'),
(6180, 'sisesc', 1, 'selventadetalle', '2024-02-27 20:37:16', b'1'),
(6181, 'sisesc', 1, 'getcliente', '2024-02-27 20:37:16', b'1'),
(6182, 'sisesc', 1, 'getpersona', '2024-02-27 20:37:16', b'1'),
(6183, 'sisesc', 1, 'selproductostock', '2024-02-27 20:45:03', b'1'),
(6184, 'sisesc', 1, 'selproductostock', '2024-02-27 20:45:29', b'1'),
(6185, 'sisesc', 1, 'selproductostock', '2024-02-27 20:46:07', b'1'),
(6186, 'sisesc', 1, 'seloficina', '2024-02-27 21:30:24', b'1'),
(6187, 'sisesc', 1, 'seloficina', '2024-02-27 21:30:27', b'1'),
(6188, 'sisesc', 1, 'selcliente', '2024-02-27 21:30:28', b'1'),
(6189, 'sisesc', 1, 'selcompra', '2024-02-27 21:30:31', b'1'),
(6190, 'sisesc', 1, 'selcotizacion', '2024-02-27 21:30:35', b'1'),
(6191, 'sisesc', 1, 'selventa', '2024-02-27 21:30:37', b'1'),
(6192, 'sisesc', 1, 'selcliente', '2024-02-27 21:30:39', b'1'),
(6193, 'sisesc', 1, 'selproductostock', '2024-02-27 21:30:41', b'1'),
(6194, 'sisesc', 1, 'seloficina', '2024-02-28 13:07:19', b'1'),
(6195, 'sisesc', 1, 'seloficina', '2024-02-28 13:07:22', b'1'),
(6196, 'sisesc', 1, 'selproductostock', '2024-02-28 13:07:25', b'1'),
(6197, 'sisesc', 1, 'selproductostock', '2024-02-28 13:14:36', b'1'),
(6198, 'sisesc', 1, 'selproductostock', '2024-02-28 13:15:50', b'1'),
(6199, 'sisesc', 1, 'selproductostock', '2024-02-28 13:16:21', b'1'),
(6200, 'sisesc', 1, 'selproductostock', '2024-02-28 13:16:38', b'1'),
(6201, 'sisesc', 1, 'selproductostock', '2024-02-28 13:25:14', b'1'),
(6202, 'sisesc', 1, 'selventa', '2024-02-28 13:31:16', b'1'),
(6203, 'sisesc', 1, 'selventa', '2024-02-28 13:32:08', b'1'),
(6204, 'sisesc', 1, 'selventa', '2024-02-28 13:32:27', b'1'),
(6205, 'sisesc', 1, 'selventa', '2024-02-28 13:32:41', b'1'),
(6206, 'sisesc', 1, 'selcompra', '2024-02-28 13:32:43', b'1'),
(6207, 'sisesc', 1, 'selcompra', '2024-02-28 13:35:46', b'1'),
(6208, 'sisesc', 1, 'selcompra', '2024-02-28 14:00:47', b'1'),
(6209, 'sisesc', 1, 'selcompra', '2024-02-28 14:03:43', b'1'),
(6210, 'sisesc', 1, 'selcompra', '2024-02-28 14:05:02', b'1'),
(6211, 'sisesc', 1, 'selcompra', '2024-02-28 14:05:46', b'1'),
(6212, 'sisesc', 1, 'selcompra', '2024-02-28 14:06:20', b'1'),
(6213, 'sisesc', 1, 'selcompra', '2024-02-28 14:09:56', b'1'),
(6214, 'sisesc', 1, 'selcompra', '2024-02-28 14:10:04', b'1'),
(6215, 'sisesc', 1, 'selcompra', '2024-02-28 14:10:38', b'1'),
(6216, 'sisesc', 1, 'selcompra', '2024-02-28 14:10:46', b'1'),
(6217, 'sisesc', 1, 'selcompra', '2024-02-28 14:11:34', b'1'),
(6218, 'sisesc', 1, 'selcompra', '2024-02-28 14:11:37', b'1'),
(6219, 'sisesc', 1, 'selcompra', '2024-02-28 14:11:41', b'1'),
(6220, 'sisesc', 1, 'selcompra', '2024-02-28 14:41:14', b'1'),
(6221, 'sisesc', 1, 'selcliente', '2024-02-28 14:41:16', b'1'),
(6222, 'sisesc', 1, 'getcliente', '2024-02-28 14:41:20', b'1'),
(6223, 'sisesc', 1, 'getpersona', '2024-02-28 14:41:20', b'1'),
(6224, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:41:20', b'1'),
(6225, 'sisesc', 1, 'selcliente', '2024-02-28 14:41:53', b'1'),
(6226, 'sisesc', 1, 'getcliente', '2024-02-28 14:41:55', b'1'),
(6227, 'sisesc', 1, 'getpersona', '2024-02-28 14:41:55', b'1'),
(6228, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:41:56', b'1'),
(6229, 'sisesc', 1, 'selcliente', '2024-02-28 14:43:17', b'1'),
(6230, 'sisesc', 1, 'selcliente', '2024-02-28 14:43:39', b'1'),
(6231, 'sisesc', 1, 'selcliente', '2024-02-28 14:43:55', b'1'),
(6232, 'sisesc', 1, 'selcliente', '2024-02-28 14:44:24', b'1'),
(6233, 'sisesc', 1, 'getcliente', '2024-02-28 14:44:31', b'1'),
(6234, 'sisesc', 1, 'getpersona', '2024-02-28 14:44:31', b'1'),
(6235, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:44:32', b'1'),
(6236, 'sisesc', 1, 'addcotizacion', '2024-02-28 14:44:33', b'1'),
(6237, 'sisesc', 1, 'selproducto', '2024-02-28 14:44:33', b'1'),
(6238, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:45:10', b'1'),
(6239, 'sisesc', 1, 'selcliente', '2024-02-28 14:45:12', b'1'),
(6240, 'sisesc', 1, 'getcliente', '2024-02-28 14:45:14', b'1'),
(6241, 'sisesc', 1, 'getpersona', '2024-02-28 14:45:14', b'1'),
(6242, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:45:15', b'1'),
(6243, 'sisesc', 1, 'addcotizacion', '2024-02-28 14:45:15', b'1'),
(6244, 'sisesc', 1, 'selproducto', '2024-02-28 14:45:15', b'1'),
(6245, 'sisesc', 1, 'selcliente', '2024-02-28 14:45:39', b'1'),
(6246, 'sisesc', 1, 'getcotizacion', '2024-02-28 14:45:39', b'1'),
(6247, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-28 14:45:40', b'1'),
(6248, 'sisesc', 1, 'selproducto', '2024-02-28 14:45:40', b'1'),
(6249, 'sisesc', 1, 'getcliente', '2024-02-28 14:45:40', b'1'),
(6250, 'sisesc', 1, 'getpersona', '2024-02-28 14:45:41', b'1'),
(6251, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:45:43', b'1'),
(6252, 'sisesc', 1, 'selcliente', '2024-02-28 14:45:44', b'1'),
(6253, 'sisesc', 1, 'getcliente', '2024-02-28 14:45:46', b'1'),
(6254, 'sisesc', 1, 'getpersona', '2024-02-28 14:45:47', b'1'),
(6255, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:45:47', b'1'),
(6256, 'sisesc', 1, 'addcotizacion', '2024-02-28 14:45:47', b'1'),
(6257, 'sisesc', 1, 'selproducto', '2024-02-28 14:45:47', b'1'),
(6258, 'sisesc', 1, 'selcliente', '2024-02-28 14:46:51', b'1'),
(6259, 'sisesc', 1, 'getcotizacion', '2024-02-28 14:46:51', b'1'),
(6260, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-28 14:46:51', b'1'),
(6261, 'sisesc', 1, 'selproducto', '2024-02-28 14:46:52', b'1'),
(6262, 'sisesc', 1, 'getcliente', '2024-02-28 14:46:52', b'1'),
(6263, 'sisesc', 1, 'getpersona', '2024-02-28 14:46:52', b'1'),
(6264, 'sisesc', 1, 'selcliente', '2024-02-28 14:47:06', b'1'),
(6265, 'sisesc', 1, 'getcotizacion', '2024-02-28 14:47:06', b'1'),
(6266, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-28 14:47:06', b'1'),
(6267, 'sisesc', 1, 'selproducto', '2024-02-28 14:47:07', b'1'),
(6268, 'sisesc', 1, 'getcliente', '2024-02-28 14:47:07', b'1'),
(6269, 'sisesc', 1, 'getpersona', '2024-02-28 14:47:07', b'1'),
(6270, 'sisesc', 1, 'selcliente', '2024-02-28 14:47:20', b'1'),
(6271, 'sisesc', 1, 'getcotizacion', '2024-02-28 14:47:20', b'1'),
(6272, 'sisesc', 1, 'selcotizaciondetalle', '2024-02-28 14:47:20', b'1'),
(6273, 'sisesc', 1, 'selproducto', '2024-02-28 14:47:20', b'1'),
(6274, 'sisesc', 1, 'getcliente', '2024-02-28 14:47:20', b'1'),
(6275, 'sisesc', 1, 'getpersona', '2024-02-28 14:47:21', b'1'),
(6276, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:47:26', b'1'),
(6277, 'sisesc', 1, 'selcompra', '2024-02-28 14:47:31', b'1'),
(6278, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:47:35', b'1'),
(6279, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:48:10', b'1'),
(6280, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:48:35', b'1'),
(6281, 'sisesc', 1, 'selcliente', '2024-02-28 14:48:37', b'1'),
(6282, 'sisesc', 1, 'getcliente', '2024-02-28 14:48:39', b'1'),
(6283, 'sisesc', 1, 'getpersona', '2024-02-28 14:48:39', b'1'),
(6284, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:48:39', b'1'),
(6285, 'sisesc', 1, 'addcotizacion', '2024-02-28 14:48:40', b'1'),
(6286, 'sisesc', 1, 'selproducto', '2024-02-28 14:48:40', b'1'),
(6287, 'sisesc', 1, 'selcotizacion', '2024-02-28 14:49:00', b'1'),
(6288, 'sisesc', 1, 'selcompra', '2024-02-28 15:03:10', b'1'),
(6289, 'sisesc', 1, 'selcompra', '2024-02-28 15:04:02', b'1'),
(6290, 'sisesc', 1, 'selcompra', '2024-02-28 15:04:48', b'1'),
(6291, 'sisesc', 1, 'selcompra', '2024-02-28 15:05:08', b'1'),
(6292, 'sisesc', 1, 'selcompra', '2024-02-28 15:05:23', b'1'),
(6293, 'sisesc', 1, 'selcompra', '2024-02-28 15:19:24', b'1'),
(6294, 'sisesc', 1, 'selcompra', '2024-02-28 15:21:06', b'1'),
(6295, 'sisesc', 1, 'selcompra', '2024-02-28 15:23:36', b'1'),
(6296, 'sisesc', 1, 'selparametro', '2024-02-28 15:32:14', b'1'),
(6297, 'sisesc', 1, 'selparametro', '2024-02-28 15:32:27', b'1'),
(6298, 'sisesc', 1, 'selparametro', '2024-02-28 15:32:44', b'1'),
(6299, 'sisesc', 1, 'selparametro', '2024-02-28 15:33:17', b'1'),
(6300, 'sisesc', 1, 'selcompra', '2024-02-28 15:33:18', b'1'),
(6301, 'sisesc', 1, 'selparametro', '2024-02-28 15:35:20', b'1'),
(6302, 'sisesc', 1, 'selcompra', '2024-02-28 15:35:21', b'1'),
(6303, 'sisesc', 1, 'selparametro', '2024-02-28 15:38:01', b'1'),
(6304, 'sisesc', 1, 'selcompra', '2024-02-28 15:38:01', b'1'),
(6305, 'sisesc', 1, 'selparametro', '2024-02-28 15:38:15', b'1'),
(6306, 'sisesc', 1, 'selcompra', '2024-02-28 15:38:16', b'1'),
(6307, 'sisesc', 1, 'selparametro', '2024-02-28 15:38:28', b'1'),
(6308, 'sisesc', 1, 'selcompra', '2024-02-28 15:38:28', b'1'),
(6309, 'sisesc', 1, 'selparametro', '2024-02-28 15:38:38', b'1'),
(6310, 'sisesc', 1, 'selcompra', '2024-02-28 15:38:39', b'1'),
(6311, 'sisesc', 1, 'selparametro', '2024-02-28 15:38:59', b'1'),
(6312, 'sisesc', 1, 'selcompra', '2024-02-28 15:38:59', b'1'),
(6313, 'sisesc', 1, 'selparametro', '2024-02-28 15:41:05', b'1'),
(6314, 'sisesc', 1, 'selcompra', '2024-02-28 15:41:05', b'1'),
(6315, 'sisesc', 1, 'selparametro', '2024-02-28 15:42:02', b'1'),
(6316, 'sisesc', 1, 'selparametro', '2024-02-28 15:42:13', b'1'),
(6317, 'sisesc', 1, 'selparametro', '2024-02-28 15:42:35', b'1'),
(6318, 'sisesc', 1, 'selcompra', '2024-02-28 15:42:39', b'1'),
(6319, 'sisesc', 1, 'selcompra', '2024-02-28 17:06:42', b'1'),
(6320, 'sisesc', 1, 'selcompra', '2024-02-28 17:07:03', b'1'),
(6321, 'sisesc', 1, 'selparametro', '2024-02-28 17:07:37', b'1'),
(6322, 'sisesc', 1, 'selcompra', '2024-02-28 17:07:42', b'1'),
(6323, 'sisesc', 1, 'selcompra', '2024-02-28 17:08:08', b'1'),
(6324, 'sisesc', 1, 'selcompra', '2024-02-28 17:08:08', b'1'),
(6325, 'sisesc', 1, 'selcompra', '2024-02-28 17:08:08', b'1'),
(6326, 'sisesc', 1, 'selcompra', '2024-02-28 17:08:08', b'1'),
(6327, 'sisesc', 1, 'selparametro', '2024-02-28 17:08:12', b'1'),
(6328, 'sisesc', 1, 'selcompra', '2024-02-28 17:08:16', b'1'),
(6329, 'sisesc', 1, 'selcompra', '2024-02-28 17:08:36', b'1'),
(6330, 'sisesc', 1, 'selcompra', '2024-02-28 17:08:47', b'1'),
(6331, 'sisesc', 1, 'selparametro', '2024-02-28 17:08:58', b'1'),
(6332, 'sisesc', 1, 'selcompra', '2024-02-28 17:09:54', b'1'),
(6333, 'sisesc', 1, 'selcompra', '2024-02-28 17:10:33', b'1'),
(6334, 'sisesc', 1, 'selcompra', '2024-02-28 17:10:42', b'1'),
(6335, 'sisesc', 1, 'selcompra', '2024-02-28 17:10:48', b'1'),
(6336, 'sisesc', 1, 'selcompra', '2024-02-28 17:10:53', b'1'),
(6337, 'sisesc', 1, 'selcompra', '2024-02-28 17:11:00', b'1'),
(6338, 'sisesc', 1, 'selcompra', '2024-02-28 17:13:20', b'1'),
(6339, 'sisesc', 1, 'selparametro', '2024-02-28 17:13:20', b'1'),
(6340, 'sisesc', 1, 'selcompra', '2024-02-28 17:13:23', b'1'),
(6341, 'sisesc', 1, 'selcompra', '2024-02-28 17:13:44', b'1'),
(6342, 'sisesc', 1, 'selparametro', '2024-02-28 17:13:44', b'1'),
(6343, 'sisesc', 1, 'selcompra', '2024-02-28 17:13:46', b'1'),
(6344, 'sisesc', 1, 'selcompra', '2024-02-28 17:13:48', b'1'),
(6345, 'sisesc', 1, 'selcompra', '2024-02-28 17:14:53', b'1'),
(6346, 'sisesc', 1, 'selparametro', '2024-02-28 17:14:53', b'1'),
(6347, 'sisesc', 1, 'selcompra', '2024-02-28 17:14:55', b'1'),
(6348, 'sisesc', 1, 'selcompra', '2024-02-28 17:15:32', b'1'),
(6349, 'sisesc', 1, 'selparametro', '2024-02-28 17:15:32', b'1'),
(6350, 'sisesc', 1, 'selcompra', '2024-02-28 17:34:32', b'1'),
(6351, 'sisesc', 1, 'seloficina', '2024-02-28 17:58:25', b'1'),
(6352, 'sisesc', 1, 'selproductostock', '2024-02-28 17:58:28', b'1'),
(6353, 'sisesc', 1, 'selparametro', '2024-02-28 17:58:44', b'1'),
(6354, 'sisesc', 1, 'selcompra', '2024-02-28 17:58:46', b'1'),
(6355, 'sisesc', 1, 'selcompra', '2024-02-28 17:58:53', b'1'),
(6356, 'sisesc', 1, 'seloficina', '2024-02-28 22:52:54', b'1'),
(6357, 'sisesc', 1, 'selusuario', '2024-02-28 22:52:57', b'1'),
(6358, 'sisesc', 1, 'selusuario', '2024-02-28 22:53:24', b'1'),
(6359, 'sisesc', 1, 'selproveedor', '2024-02-28 22:53:27', b'1'),
(6360, 'sisesc', 1, 'selmarca', '2024-02-28 22:53:30', b'1'),
(6361, 'sisesc', 1, 'selproveedor', '2024-02-28 22:53:34', b'1'),
(6362, 'sisesc', 1, 'getproveedor', '2024-02-28 22:53:36', b'1'),
(6363, 'sisesc', 1, 'getpersona', '2024-02-28 22:53:36', b'1'),
(6364, 'sisesc', 1, 'selmarca', '2024-02-28 22:53:36', b'1'),
(6365, 'sisesc', 1, 'selproveedor', '2024-02-28 22:53:41', b'1'),
(6366, 'sisesc', 1, 'selproveedor', '2024-02-28 22:53:43', b'1'),
(6367, 'sisesc', 1, 'selcompra', '2024-02-28 22:53:47', b'1'),
(6368, 'sisesc', 1, 'selproveedor', '2024-02-28 22:53:49', b'1'),
(6369, 'sisesc', 1, 'getcompra', '2024-02-28 22:53:49', b'1'),
(6370, 'sisesc', 1, 'selcompradetalle', '2024-02-28 22:53:50', b'1'),
(6371, 'sisesc', 1, 'selproducto', '2024-02-28 22:53:50', b'1'),
(6372, 'sisesc', 1, 'getproveedor', '2024-02-28 22:53:50', b'1'),
(6373, 'sisesc', 1, 'getpersona', '2024-02-28 22:53:50', b'1'),
(6374, 'sisesc', 1, 'getproducto', '2024-02-28 22:53:55', b'1'),
(6375, 'sisesc', 1, 'addcompradetalle', '2024-02-28 22:54:03', b'1'),
(6376, 'sisesc', 1, 'selcompradetalle', '2024-02-28 22:54:03', b'1'),
(6377, 'sisesc', 1, 'papcompradetalle', '2024-02-28 22:54:08', b'1'),
(6378, 'sisesc', 1, 'selcompradetalle', '2024-02-28 22:54:08', b'1'),
(6379, 'sisesc', 1, 'seloficina', '2024-03-01 12:19:23', b'1'),
(6380, 'sisesc', 1, 'selcliente', '2024-03-01 12:19:28', b'1'),
(6381, 'sisesc', 1, 'selcliente', '2024-03-01 12:19:33', b'1'),
(6382, 'sisesc', 1, 'selcompra', '2024-03-01 12:20:42', b'1'),
(6383, 'sisesc', 1, 'seloficina', '2024-03-01 22:38:15', b'1'),
(6384, 'sisesc', 1, 'seloficina', '2024-03-01 22:38:17', b'1'),
(6385, 'sisesc', 1, 'selusuario', '2024-03-01 22:38:20', b'1'),
(6386, 'sisesc', 1, 'getusuario', '2024-03-01 22:38:29', b'1'),
(6387, 'sisesc', 1, 'getpersona', '2024-03-01 22:38:29', b'1'),
(6388, 'sisesc', 1, 'selrolusuario', '2024-03-01 22:38:30', b'1'),
(6389, 'sisesc', 1, 'selusuario', '2024-03-01 22:38:36', b'1'),
(6390, 'sisesc', 1, 'selproducto', '2024-03-01 22:38:39', b'1'),
(6391, 'sisesc', 1, 'selmarca', '2024-03-01 22:38:42', b'1'),
(6392, 'sisesc', 1, 'selclasificacionproducto', '2024-03-01 22:38:42', b'1'),
(6393, 'sisesc', 1, 'selproducto', '2024-03-01 22:38:45', b'1'),
(6394, 'sisesc', 1, 'getproducto', '2024-03-01 22:38:46', b'1'),
(6395, 'sisesc', 1, 'selmarca', '2024-03-01 22:38:47', b'1'),
(6396, 'sisesc', 1, 'selclasificacionproducto', '2024-03-01 22:38:47', b'1'),
(6397, 'sisesc', 1, 'selproducto', '2024-03-01 22:38:51', b'1'),
(6398, 'sisesc', 1, 'selcompra', '2024-03-01 22:38:54', b'1'),
(6399, 'sisesc', 1, 'selproveedor', '2024-03-01 22:38:56', b'1'),
(6400, 'sisesc', 1, 'getcompra', '2024-03-01 22:38:56', b'1'),
(6401, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:38:56', b'1'),
(6402, 'sisesc', 1, 'selproducto', '2024-03-01 22:38:56', b'1'),
(6403, 'sisesc', 1, 'getproveedor', '2024-03-01 22:38:57', b'1'),
(6404, 'sisesc', 1, 'getpersona', '2024-03-01 22:38:57', b'1'),
(6405, 'sisesc', 1, 'selproductostock', '2024-03-01 22:39:23', b'1'),
(6406, 'sisesc', 1, 'selcompra', '2024-03-01 22:39:36', b'1'),
(6407, 'sisesc', 1, 'getcompra', '2024-03-01 22:39:38', b'1'),
(6408, 'sisesc', 1, 'selproveedor', '2024-03-01 22:39:38', b'1'),
(6409, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:39:38', b'1'),
(6410, 'sisesc', 1, 'selproducto', '2024-03-01 22:39:38', b'1'),
(6411, 'sisesc', 1, 'getproveedor', '2024-03-01 22:39:38', b'1'),
(6412, 'sisesc', 1, 'getpersona', '2024-03-01 22:39:38', b'1'),
(6413, 'sisesc', 1, 'getcompra', '2024-03-01 22:39:58', b'1'),
(6414, 'sisesc', 1, 'selproveedor', '2024-03-01 22:39:58', b'1'),
(6415, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:39:58', b'1'),
(6416, 'sisesc', 1, 'selproducto', '2024-03-01 22:39:58', b'1'),
(6417, 'sisesc', 1, 'getproveedor', '2024-03-01 22:39:59', b'1'),
(6418, 'sisesc', 1, 'getpersona', '2024-03-01 22:39:59', b'1'),
(6419, 'sisesc', 1, 'selproveedor', '2024-03-01 22:40:11', b'1'),
(6420, 'sisesc', 1, 'getcompra', '2024-03-01 22:40:11', b'1'),
(6421, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:40:11', b'1'),
(6422, 'sisesc', 1, 'selproducto', '2024-03-01 22:40:11', b'1'),
(6423, 'sisesc', 1, 'getproveedor', '2024-03-01 22:40:11', b'1'),
(6424, 'sisesc', 1, 'getpersona', '2024-03-01 22:40:12', b'1'),
(6425, 'sisesc', 1, 'selproveedor', '2024-03-01 22:40:19', b'1'),
(6426, 'sisesc', 1, 'getcompra', '2024-03-01 22:40:19', b'1'),
(6427, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:40:19', b'1'),
(6428, 'sisesc', 1, 'selproducto', '2024-03-01 22:40:19', b'1'),
(6429, 'sisesc', 1, 'getproveedor', '2024-03-01 22:40:19', b'1'),
(6430, 'sisesc', 1, 'getpersona', '2024-03-01 22:40:19', b'1'),
(6431, 'sisesc', 1, 'selproveedor', '2024-03-01 22:40:37', b'1'),
(6432, 'sisesc', 1, 'getcompra', '2024-03-01 22:40:37', b'1'),
(6433, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:40:38', b'1'),
(6434, 'sisesc', 1, 'selproducto', '2024-03-01 22:40:38', b'1'),
(6435, 'sisesc', 1, 'getproveedor', '2024-03-01 22:40:38', b'1'),
(6436, 'sisesc', 1, 'getpersona', '2024-03-01 22:40:38', b'1'),
(6437, 'sisesc', 1, 'selproveedor', '2024-03-01 22:41:00', b'1'),
(6438, 'sisesc', 1, 'getcompra', '2024-03-01 22:41:00', b'1'),
(6439, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:41:00', b'1'),
(6440, 'sisesc', 1, 'selproducto', '2024-03-01 22:41:00', b'1'),
(6441, 'sisesc', 1, 'getproveedor', '2024-03-01 22:41:00', b'1'),
(6442, 'sisesc', 1, 'getpersona', '2024-03-01 22:41:01', b'1'),
(6443, 'sisesc', 1, 'selcotizacion', '2024-03-01 22:41:30', b'1'),
(6444, 'sisesc', 1, 'selventa', '2024-03-01 22:41:34', b'1'),
(6445, 'sisesc', 1, 'selparametro', '2024-03-01 22:41:37', b'1'),
(6446, 'sisesc', 1, 'selcompra', '2024-03-01 22:41:39', b'1'),
(6447, 'sisesc', 1, 'selcompra', '2024-03-01 22:42:16', b'1'),
(6448, 'sisesc', 1, 'seloficina', '2024-03-01 22:44:08', b'1'),
(6449, 'sisesc', 1, 'selcompra', '2024-03-01 22:44:15', b'1'),
(6450, 'sisesc', 1, 'selproveedor', '2024-03-01 22:44:16', b'1'),
(6451, 'sisesc', 1, 'getcompra', '2024-03-01 22:44:16', b'1'),
(6452, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:44:17', b'1'),
(6453, 'sisesc', 1, 'selproducto', '2024-03-01 22:44:17', b'1'),
(6454, 'sisesc', 1, 'getproveedor', '2024-03-01 22:44:17', b'1'),
(6455, 'sisesc', 1, 'getpersona', '2024-03-01 22:44:17', b'1'),
(6456, 'sisesc', 1, 'seloficina', '2024-03-01 22:44:42', b'1'),
(6457, 'sisesc', 1, 'selcompra', '2024-03-01 22:44:44', b'1'),
(6458, 'sisesc', 1, 'selcompra', '2024-03-01 22:44:53', b'1'),
(6459, 'sisesc', 1, 'selproveedor', '2024-03-01 22:44:56', b'1'),
(6460, 'sisesc', 1, 'getcompra', '2024-03-01 22:44:56', b'1'),
(6461, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:44:56', b'1'),
(6462, 'sisesc', 1, 'selproducto', '2024-03-01 22:44:56', b'1'),
(6463, 'sisesc', 1, 'getproveedor', '2024-03-01 22:44:56', b'1'),
(6464, 'sisesc', 1, 'getpersona', '2024-03-01 22:44:57', b'1'),
(6465, 'sisesc', 1, 'seloficina', '2024-03-01 22:45:44', b'1'),
(6466, 'sisesc', 1, 'seloficina', '2024-03-01 22:45:54', b'1'),
(6467, 'sisesc', 1, 'seloficina', '2024-03-01 22:46:00', b'1'),
(6468, 'sisesc', 1, 'selproveedor', '2024-03-01 22:46:57', b'1'),
(6469, 'sisesc', 1, 'getcompra', '2024-03-01 22:46:57', b'1'),
(6470, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:46:57', b'1'),
(6471, 'sisesc', 1, 'selproducto', '2024-03-01 22:46:58', b'1'),
(6472, 'sisesc', 1, 'seloficina', '2024-03-01 22:46:58', b'1'),
(6473, 'sisesc', 1, 'getproveedor', '2024-03-01 22:46:58', b'1'),
(6474, 'sisesc', 1, 'getpersona', '2024-03-01 22:46:58', b'1'),
(6475, 'sisesc', 1, 'getcompra', '2024-03-01 22:47:00', b'1');
INSERT INTO `seg_tbllogusuario` (`idlogusuario`, `nombresistema`, `idusuario`, `nombreservicio`, `fecharegistro`, `estadoregistro`) VALUES
(6476, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:47:01', b'1'),
(6477, 'sisesc', 1, 'getproveedor', '2024-03-01 22:47:01', b'1'),
(6478, 'sisesc', 1, 'getpersona', '2024-03-01 22:47:01', b'1'),
(6479, 'sisesc', 1, 'getcompra', '2024-03-01 22:50:44', b'1'),
(6480, 'sisesc', 1, 'selproveedor', '2024-03-01 22:50:44', b'1'),
(6481, 'sisesc', 1, 'getcompra', '2024-03-01 22:50:44', b'1'),
(6482, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:50:44', b'1'),
(6483, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:50:44', b'1'),
(6484, 'sisesc', 1, 'getproveedor', '2024-03-01 22:50:44', b'1'),
(6485, 'sisesc', 1, 'selproducto', '2024-03-01 22:50:44', b'1'),
(6486, 'sisesc', 1, 'getpersona', '2024-03-01 22:50:44', b'1'),
(6487, 'sisesc', 1, 'getproveedor', '2024-03-01 22:50:45', b'1'),
(6488, 'sisesc', 1, 'getpersona', '2024-03-01 22:50:45', b'1'),
(6489, 'sisesc', 1, 'seloficina', '2024-03-01 22:50:45', b'1'),
(6490, 'sisesc', 1, 'selcompra', '2024-03-01 22:50:54', b'1'),
(6491, 'sisesc', 1, 'selproveedor', '2024-03-01 22:50:58', b'1'),
(6492, 'sisesc', 1, 'getcompra', '2024-03-01 22:50:58', b'1'),
(6493, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:50:58', b'1'),
(6494, 'sisesc', 1, 'selproducto', '2024-03-01 22:50:58', b'1'),
(6495, 'sisesc', 1, 'getproveedor', '2024-03-01 22:50:59', b'1'),
(6496, 'sisesc', 1, 'getpersona', '2024-03-01 22:50:59', b'1'),
(6497, 'sisesc', 1, 'selcompra', '2024-03-01 22:51:14', b'1'),
(6498, 'sisesc', 1, 'selproveedor', '2024-03-01 22:51:21', b'1'),
(6499, 'sisesc', 1, 'getcompra', '2024-03-01 22:51:21', b'1'),
(6500, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:51:21', b'1'),
(6501, 'sisesc', 1, 'selproducto', '2024-03-01 22:51:22', b'1'),
(6502, 'sisesc', 1, 'getproveedor', '2024-03-01 22:51:22', b'1'),
(6503, 'sisesc', 1, 'getpersona', '2024-03-01 22:51:22', b'1'),
(6504, 'sisesc', 1, 'getcompra', '2024-03-01 22:51:25', b'1'),
(6505, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:51:25', b'1'),
(6506, 'sisesc', 1, 'getproveedor', '2024-03-01 22:51:25', b'1'),
(6507, 'sisesc', 1, 'getpersona', '2024-03-01 22:51:25', b'1'),
(6508, 'sisesc', 1, 'selproveedor', '2024-03-01 22:52:17', b'1'),
(6509, 'sisesc', 1, 'getcompra', '2024-03-01 22:52:17', b'1'),
(6510, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:52:17', b'1'),
(6511, 'sisesc', 1, 'selproducto', '2024-03-01 22:52:17', b'1'),
(6512, 'sisesc', 1, 'getproveedor', '2024-03-01 22:52:18', b'1'),
(6513, 'sisesc', 1, 'seloficina', '2024-03-01 22:52:18', b'1'),
(6514, 'sisesc', 1, 'getpersona', '2024-03-01 22:52:18', b'1'),
(6515, 'sisesc', 1, 'getcompra', '2024-03-01 22:52:21', b'1'),
(6516, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:52:21', b'1'),
(6517, 'sisesc', 1, 'getproveedor', '2024-03-01 22:52:21', b'1'),
(6518, 'sisesc', 1, 'getpersona', '2024-03-01 22:52:22', b'1'),
(6519, 'sisesc', 1, 'selproveedor', '2024-03-01 22:53:38', b'1'),
(6520, 'sisesc', 1, 'getcompra', '2024-03-01 22:53:38', b'1'),
(6521, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:53:38', b'1'),
(6522, 'sisesc', 1, 'selproducto', '2024-03-01 22:53:38', b'1'),
(6523, 'sisesc', 1, 'getproveedor', '2024-03-01 22:53:38', b'1'),
(6524, 'sisesc', 1, 'getpersona', '2024-03-01 22:53:39', b'1'),
(6525, 'sisesc', 1, 'seloficina', '2024-03-01 22:58:11', b'1'),
(6526, 'sisesc', 1, 'seloficina', '2024-03-01 22:58:14', b'1'),
(6527, 'sisesc', 1, 'selcompra', '2024-03-01 22:58:20', b'1'),
(6528, 'sisesc', 1, 'selproveedor', '2024-03-01 22:58:22', b'1'),
(6529, 'sisesc', 1, 'getcompra', '2024-03-01 22:58:22', b'1'),
(6530, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:58:22', b'1'),
(6531, 'sisesc', 1, 'selproducto', '2024-03-01 22:58:22', b'1'),
(6532, 'sisesc', 1, 'getproveedor', '2024-03-01 22:58:23', b'1'),
(6533, 'sisesc', 1, 'getpersona', '2024-03-01 22:58:23', b'1'),
(6534, 'sisesc', 1, 'getcompra', '2024-03-01 22:58:25', b'1'),
(6535, 'sisesc', 1, 'selcompradetalle', '2024-03-01 22:58:25', b'1'),
(6536, 'sisesc', 1, 'getproveedor', '2024-03-01 22:58:26', b'1'),
(6537, 'sisesc', 1, 'getpersona', '2024-03-01 22:58:26', b'1'),
(6538, 'sisesc', 1, 'seloficina', '2024-03-04 14:06:41', b'1'),
(6539, 'sisesc', 1, 'seloficina', '2024-03-04 14:06:44', b'1'),
(6540, 'sisesc', 1, 'selusuario', '2024-03-04 14:06:47', b'1'),
(6541, 'sisesc', 2, 'seloficina', '2024-03-04 14:07:02', b'1'),
(6542, 'sisesc', 2, 'seloficina', '2024-03-04 14:07:04', b'1'),
(6543, 'sisesc', 2, 'seloficina', '2024-03-04 14:10:59', b'1'),
(6544, 'sisesc', 2, 'seloficina', '2024-03-04 14:11:06', b'1'),
(6545, 'sisesc', 2, 'selusuario', '2024-03-04 14:13:39', b'1'),
(6546, 'sisesc', 2, 'seloficina', '2024-03-04 15:20:08', b'1'),
(6547, 'sisesc', 2, 'seloficina', '2024-03-04 15:20:58', b'1'),
(6548, 'sisesc', 2, 'selusuario', '2024-03-04 15:22:06', b'1'),
(6549, 'sisesc', 2, 'selusuario', '2024-03-04 15:22:26', b'1'),
(6550, 'sisesc', 2, 'selusuario', '2024-03-04 15:22:49', b'1'),
(6551, 'sisesc', 2, 'selproducto', '2024-03-04 15:23:04', b'1'),
(6552, 'sisesc', 2, 'getproducto', '2024-03-04 15:23:16', b'1'),
(6553, 'sisesc', 2, 'selmarca', '2024-03-04 15:23:16', b'1'),
(6554, 'sisesc', 2, 'selclasificacionproducto', '2024-03-04 15:23:16', b'1'),
(6555, 'sisesc', 2, 'selproducto', '2024-03-04 15:23:36', b'1'),
(6556, 'sisesc', 2, 'selmarca', '2024-03-04 15:23:39', b'1'),
(6557, 'sisesc', 2, 'selclasificacionproducto', '2024-03-04 15:23:40', b'1'),
(6558, 'sisesc', 2, 'selproducto', '2024-03-04 15:23:52', b'1'),
(6559, 'sisesc', 2, 'selmarca', '2024-03-04 15:23:56', b'1'),
(6560, 'sisesc', 2, 'selmarca', '2024-03-04 15:24:10', b'1'),
(6561, 'sisesc', 2, 'selmarca', '2024-03-04 15:24:19', b'1'),
(6562, 'sisesc', 2, 'selmarca', '2024-03-04 15:24:38', b'1'),
(6563, 'sisesc', 2, 'addmarca', '2024-03-04 15:24:46', b'1'),
(6564, 'sisesc', 2, 'selmarca', '2024-03-04 15:24:46', b'1'),
(6565, 'sisesc', 2, 'getmarca', '2024-03-04 15:25:24', b'1'),
(6566, 'sisesc', 2, 'selmarca', '2024-03-04 15:25:25', b'1'),
(6567, 'sisesc', 2, 'selmarca', '2024-03-04 15:25:46', b'1'),
(6568, 'sisesc', 2, 'selparametrotipo', '2024-03-04 15:26:11', b'1'),
(6569, 'sisesc', 2, 'selplandecuenta', '2024-03-04 15:26:11', b'1'),
(6570, 'sisesc', 2, 'selproveedor', '2024-03-04 15:26:26', b'1'),
(6571, 'sisesc', 2, 'selcompra', '2024-03-04 15:26:33', b'1'),
(6572, 'sisesc', 2, 'selproveedor', '2024-03-04 15:26:54', b'1'),
(6573, 'sisesc', 2, 'selmarca', '2024-03-04 15:27:06', b'1'),
(6574, 'sisesc', 2, 'selproveedor', '2024-03-04 15:27:15', b'1'),
(6575, 'sisesc', 2, 'selcliente', '2024-03-04 15:27:22', b'1'),
(6576, 'sisesc', 2, 'selventa', '2024-03-04 15:27:37', b'1'),
(6577, 'sisesc', 2, 'selcliente', '2024-03-04 15:27:43', b'1'),
(6578, 'sisesc', 2, 'selcliente', '2024-03-04 15:27:49', b'1'),
(6579, 'sisesc', 2, 'selcotizacion', '2024-03-04 15:27:55', b'1'),
(6580, 'sisesc', 2, 'selproductostock', '2024-03-04 15:27:59', b'1'),
(6581, 'sisesc', 2, 'selcotizacion', '2024-03-04 15:28:21', b'1'),
(6582, 'sisesc', 2, 'selventa', '2024-03-04 15:28:25', b'1'),
(6583, 'sisesc', 2, 'selparametro', '2024-03-04 15:28:42', b'1'),
(6584, 'sisesc', 2, 'selcompra', '2024-03-04 15:28:48', b'1'),
(6585, 'sisesc', 2, 'selcompra', '2024-03-04 15:29:10', b'1'),
(6586, 'sisesc', 2, 'seloficina', '2024-03-04 15:31:33', b'1'),
(6587, 'sisesc', 2, 'selmarca', '2024-03-04 15:31:44', b'1'),
(6588, 'sisesc', 2, 'selcliente', '2024-03-04 15:31:53', b'1'),
(6589, 'sisesc', 2, 'selmarca', '2024-03-04 15:32:06', b'1'),
(6590, 'sisesc', 2, 'getmarca', '2024-03-04 15:32:19', b'1'),
(6591, 'sisesc', 2, 'selmarca', '2024-03-04 15:32:19', b'1'),
(6592, 'sisesc', 2, 'selmarca', '2024-03-04 15:32:24', b'1'),
(6593, 'sisesc', 2, 'selcliente', '2024-03-04 15:37:31', b'1'),
(6594, 'sisesc', 2, 'selcliente', '2024-03-04 15:37:35', b'1'),
(6595, 'sisesc', 2, 'selcliente', '2024-03-04 15:37:38', b'1'),
(6596, 'sisesc', 2, 'selcliente', '2024-03-04 15:37:57', b'1'),
(6597, 'sisesc', 2, 'selcliente', '2024-03-04 15:38:21', b'1'),
(6598, 'sisesc', 1, 'seloficina', '2024-03-04 17:29:46', b'1'),
(6599, 'sisesc', 1, 'seloficina', '2024-03-04 17:29:50', b'1'),
(6600, 'sisesc', 1, 'selusuario', '2024-03-04 17:30:03', b'1'),
(6601, 'sisesc', 1, 'addpersona', '2024-03-04 17:30:55', b'1'),
(6602, 'sisesc', 1, 'addusuario', '2024-03-04 17:30:55', b'1'),
(6603, 'sisesc', 1, 'selusuario', '2024-03-04 17:30:56', b'1'),
(6604, 'sisesc', 1, 'seloficina', '2024-03-05 11:47:38', b'1'),
(6605, 'sisesc', 1, 'selusuario', '2024-03-05 11:47:40', b'1'),
(6606, 'sisesc', 1, 'addpersona', '2024-03-05 11:48:01', b'1'),
(6607, 'sisesc', 1, 'addusuario', '2024-03-05 11:48:01', b'1'),
(6608, 'sisesc', 1, 'selusuario', '2024-03-05 11:48:01', b'1'),
(6609, 'sisesc', 4, 'seloficina', '2024-03-05 11:49:15', b'1'),
(6610, 'sisesc', 4, 'seloficina', '2024-03-05 11:49:34', b'1'),
(6611, 'sisesc', 4, 'selventa', '2024-03-05 11:50:43', b'1'),
(6612, 'sisesc', 4, 'selparametrotipo', '2024-03-05 11:50:55', b'1'),
(6613, 'sisesc', 4, 'selplandecuenta', '2024-03-05 11:50:56', b'1'),
(6614, 'sisesc', 4, 'selcliente', '2024-03-05 11:51:02', b'1'),
(6615, 'sisesc', 4, 'getcliente', '2024-03-05 11:51:05', b'1'),
(6616, 'sisesc', 4, 'getpersona', '2024-03-05 11:51:05', b'1'),
(6617, 'sisesc', 4, 'selmarca', '2024-03-05 11:51:05', b'1'),
(6618, 'sisesc', 4, 'selcliente', '2024-03-05 11:51:08', b'1'),
(6619, 'sisesc', 4, 'selparametrotipo', '2024-03-05 11:51:10', b'1'),
(6620, 'sisesc', 4, 'selplandecuenta', '2024-03-05 11:51:13', b'1'),
(6621, 'sisesc', 1, 'seloficina', '2024-03-05 16:04:45', b'1'),
(6622, 'sisesc', 1, 'selusuario', '2024-03-05 16:04:46', b'1'),
(6623, 'sisesc', 1, 'addpersona', '2024-03-05 16:05:04', b'1'),
(6624, 'sisesc', 1, 'addusuario', '2024-03-05 16:05:05', b'1'),
(6625, 'sisesc', 1, 'selusuario', '2024-03-05 16:05:06', b'1'),
(6626, 'sisesc', 1, 'addpersona', '2024-03-05 17:07:43', b'1'),
(6627, 'sisesc', 1, 'addusuario', '2024-03-05 17:07:43', b'1'),
(6628, 'sisesc', 1, 'selusuario', '2024-03-05 17:07:43', b'1'),
(6629, 'sisesc', 6, 'seloficina', '2024-03-05 17:09:04', b'1'),
(6630, 'sisesc', 6, 'seloficina', '2024-03-05 17:09:28', b'1'),
(6631, 'sisesc', 6, 'seloficina', '2024-03-05 17:39:54', b'1'),
(6632, 'sisesc', 4, 'selparametrotipo', '2024-03-05 21:54:06', b'1'),
(6633, 'sisesc', 4, 'selplandecuenta', '2024-03-05 21:54:06', b'1'),
(6634, 'sisesc', 1, 'seloficina', '2024-03-05 22:49:41', b'1'),
(6635, 'sisesc', 1, 'seloficina', '2024-03-05 22:49:43', b'1'),
(6636, 'sisesc', 1, 'selcompra', '2024-03-05 22:49:47', b'1'),
(6637, 'sisesc', 1, 'selusuario', '2024-03-05 22:49:55', b'1'),
(6638, 'sisesc', 1, 'selcompra', '2024-03-05 22:50:04', b'1'),
(6639, 'sisesc', 4, 'selparametrotipo', '2024-03-05 23:23:34', b'1'),
(6640, 'sisesc', 4, 'selparametrotipo', '2024-03-06 04:50:14', b'1'),
(6641, 'sisesc', 4, 'selplandecuenta', '2024-03-06 04:50:14', b'1'),
(6642, 'sisesc', 6, 'seloficina', '2024-03-06 15:48:53', b'1'),
(6643, 'sisesc', 6, 'seloficina', '2024-03-06 16:59:03', b'1'),
(6644, 'sisesc', 6, 'selusuario', '2024-03-06 16:59:17', b'1'),
(6645, 'sisesc', 6, 'getusuario', '2024-03-06 16:59:23', b'1'),
(6646, 'sisesc', 6, 'getpersona', '2024-03-06 16:59:23', b'1'),
(6647, 'sisesc', 6, 'selrolusuario', '2024-03-06 16:59:23', b'1'),
(6648, 'sisesc', 6, 'selusuario', '2024-03-06 16:59:42', b'1'),
(6649, 'sisesc', 6, 'getusuario', '2024-03-06 16:59:48', b'1'),
(6650, 'sisesc', 6, 'getpersona', '2024-03-06 16:59:48', b'1'),
(6651, 'sisesc', 6, 'selrolusuario', '2024-03-06 16:59:48', b'1'),
(6652, 'sisesc', 6, 'selusuario', '2024-03-06 16:59:57', b'1'),
(6653, 'sisesc', 6, 'selproducto', '2024-03-06 17:06:54', b'1'),
(6654, 'sisesc', 6, 'selusuario', '2024-03-06 17:07:30', b'1'),
(6655, 'sisesc', 6, 'getusuario', '2024-03-06 17:07:53', b'1'),
(6656, 'sisesc', 6, 'getpersona', '2024-03-06 17:07:53', b'1'),
(6657, 'sisesc', 6, 'selrolusuario', '2024-03-06 17:07:54', b'1'),
(6658, 'sisesc', 6, 'selusuario', '2024-03-06 17:08:06', b'1'),
(6659, 'sisesc', 6, 'getusuario', '2024-03-06 17:08:10', b'1'),
(6660, 'sisesc', 6, 'getpersona', '2024-03-06 17:08:10', b'1'),
(6661, 'sisesc', 6, 'selrolusuario', '2024-03-06 17:08:10', b'1'),
(6662, 'sisesc', 6, 'selusuario', '2024-03-06 17:08:22', b'1'),
(6663, 'sisesc', 6, 'getusuario', '2024-03-06 17:08:25', b'1'),
(6664, 'sisesc', 6, 'getpersona', '2024-03-06 17:08:25', b'1'),
(6665, 'sisesc', 6, 'selrolusuario', '2024-03-06 17:08:25', b'1'),
(6666, 'sisesc', 6, 'selusuario', '2024-03-06 17:08:27', b'1'),
(6667, 'sisesc', 6, 'getusuario', '2024-03-06 17:08:37', b'1'),
(6668, 'sisesc', 6, 'getpersona', '2024-03-06 17:08:37', b'1'),
(6669, 'sisesc', 6, 'selrolusuario', '2024-03-06 17:08:37', b'1'),
(6670, 'sisesc', 6, 'selusuario', '2024-03-06 17:08:41', b'1'),
(6671, 'sisesc', 6, 'selproducto', '2024-03-06 17:08:47', b'1'),
(6672, 'sisesc', 6, 'getproducto', '2024-03-06 17:08:56', b'1'),
(6673, 'sisesc', 6, 'selmarca', '2024-03-06 17:08:56', b'1'),
(6674, 'sisesc', 6, 'selclasificacionproducto', '2024-03-06 17:08:56', b'1'),
(6675, 'sisesc', 1, 'seloficina', '2024-03-06 17:10:46', b'1'),
(6676, 'sisesc', 1, 'selusuario', '2024-03-06 17:10:49', b'1'),
(6677, 'sisesc', 6, 'getproducto', '2024-03-06 17:27:04', b'1'),
(6678, 'sisesc', 6, 'selmarca', '2024-03-06 17:27:04', b'1'),
(6679, 'sisesc', 6, 'selclasificacionproducto', '2024-03-06 17:27:05', b'1'),
(6680, 'sisesc', 6, 'selcompra', '2024-03-06 17:27:14', b'1'),
(6681, 'sisesc', 6, 'selusuario', '2024-03-06 17:27:24', b'1'),
(6682, 'sisesc', 6, 'selproveedor', '2024-03-06 17:27:34', b'1'),
(6683, 'sisesc', 6, 'selproducto', '2024-03-06 17:27:43', b'1'),
(6684, 'sisesc', 6, 'getproducto', '2024-03-06 17:27:47', b'1'),
(6685, 'sisesc', 6, 'selmarca', '2024-03-06 17:27:47', b'1'),
(6686, 'sisesc', 6, 'selclasificacionproducto', '2024-03-06 17:27:48', b'1'),
(6687, 'sisesc', 6, 'selusuario', '2024-03-06 17:28:23', b'1'),
(6688, 'sisesc', 6, 'selcompra', '2024-03-06 17:29:18', b'1'),
(6689, 'sisesc', 6, 'selusuario', '2024-03-06 17:33:30', b'1'),
(6690, 'sisesc', 6, 'selproducto', '2024-03-06 17:33:36', b'1'),
(6691, 'sisesc', 6, 'getproducto', '2024-03-06 17:33:42', b'1'),
(6692, 'sisesc', 6, 'selmarca', '2024-03-06 17:33:42', b'1'),
(6693, 'sisesc', 6, 'selclasificacionproducto', '2024-03-06 17:33:43', b'1'),
(6694, 'sisesc', 6, 'selproducto', '2024-03-06 17:33:53', b'1'),
(6695, 'sisesc', 6, 'getproducto', '2024-03-06 17:34:52', b'1'),
(6696, 'sisesc', 6, 'selmarca', '2024-03-06 17:34:53', b'1'),
(6697, 'sisesc', 6, 'selclasificacionproducto', '2024-03-06 17:34:54', b'1'),
(6698, 'sisesc', 6, 'selproducto', '2024-03-06 17:34:58', b'1'),
(6699, 'sisesc', 6, 'getproducto', '2024-03-06 17:35:00', b'1'),
(6700, 'sisesc', 6, 'selmarca', '2024-03-06 17:35:01', b'1'),
(6701, 'sisesc', 6, 'selclasificacionproducto', '2024-03-06 17:35:01', b'1'),
(6702, 'sisesc', 6, 'selproducto', '2024-03-06 17:35:06', b'1'),
(6703, 'sisesc', 6, 'getproducto', '2024-03-06 17:35:55', b'1'),
(6704, 'sisesc', 6, 'selmarca', '2024-03-06 17:35:55', b'1'),
(6705, 'sisesc', 6, 'selclasificacionproducto', '2024-03-06 17:35:55', b'1'),
(6706, 'sisesc', 6, 'selmarca', '2024-03-06 17:39:59', b'1'),
(6707, 'sisesc', 6, 'selparametrotipo', '2024-03-06 17:40:09', b'1'),
(6708, 'sisesc', 6, 'selplandecuenta', '2024-03-06 17:40:09', b'1'),
(6709, 'sisesc', 6, 'getplandecuenta', '2024-03-06 17:40:15', b'1'),
(6710, 'sisesc', 6, 'selparametrotipo', '2024-03-06 17:40:15', b'1'),
(6711, 'sisesc', 6, 'selparametrotipo', '2024-03-06 17:40:28', b'1'),
(6712, 'sisesc', 6, 'selplandecuenta', '2024-03-06 17:40:28', b'1'),
(6713, 'sisesc', 6, 'getplandecuenta', '2024-03-06 17:40:30', b'1'),
(6714, 'sisesc', 6, 'selparametrotipo', '2024-03-06 17:40:30', b'1'),
(6715, 'sisesc', 6, 'selproveedor', '2024-03-06 17:40:35', b'1'),
(6716, 'sisesc', 6, 'getproveedor', '2024-03-06 17:40:39', b'1'),
(6717, 'sisesc', 6, 'getpersona', '2024-03-06 17:40:40', b'1'),
(6718, 'sisesc', 6, 'addcompra', '2024-03-06 17:40:40', b'1'),
(6719, 'sisesc', 6, 'selproducto', '2024-03-06 17:40:41', b'1'),
(6720, 'sisesc', 6, 'getproducto', '2024-03-06 17:43:42', b'1'),
(6721, 'sisesc', 6, 'getproducto', '2024-03-06 17:46:44', b'1'),
(6722, 'sisesc', 6, 'addcompradetalle', '2024-03-06 17:46:44', b'1'),
(6723, 'sisesc', 6, 'selcompradetalle', '2024-03-06 17:46:44', b'1'),
(6724, 'sisesc', 6, 'papcompradetalle', '2024-03-06 17:47:30', b'1'),
(6725, 'sisesc', 6, 'selcompradetalle', '2024-03-06 17:47:31', b'1'),
(6726, 'sisesc', 6, 'getproducto', '2024-03-06 17:47:40', b'1'),
(6727, 'sisesc', 1, 'selusuario', '2024-03-06 17:47:48', b'1'),
(6728, 'sisesc', 1, 'selproveedor', '2024-03-06 17:47:57', b'1'),
(6729, 'sisesc', 1, 'selcompra', '2024-03-06 17:47:59', b'1'),
(6730, 'sisesc', 1, 'selproveedor', '2024-03-06 17:48:11', b'1'),
(6731, 'sisesc', 1, 'getcompra', '2024-03-06 17:48:11', b'1'),
(6732, 'sisesc', 1, 'selcompradetalle', '2024-03-06 17:48:12', b'1'),
(6733, 'sisesc', 1, 'selproducto', '2024-03-06 17:48:12', b'1'),
(6734, 'sisesc', 1, 'getproveedor', '2024-03-06 17:48:12', b'1'),
(6735, 'sisesc', 1, 'getpersona', '2024-03-06 17:48:12', b'1'),
(6736, 'sisesc', 6, 'addcompradetalle', '2024-03-06 17:48:19', b'1'),
(6737, 'sisesc', 6, 'selcompradetalle', '2024-03-06 17:48:19', b'1'),
(6738, 'sisesc', 6, 'papcompradetalle', '2024-03-06 17:54:13', b'1'),
(6739, 'sisesc', 6, 'selcompradetalle', '2024-03-06 17:54:13', b'1'),
(6740, 'sisesc', 6, 'getproducto', '2024-03-06 17:54:15', b'1'),
(6741, 'sisesc', 6, 'addcompradetalle', '2024-03-06 17:54:53', b'1'),
(6742, 'sisesc', 6, 'selcompradetalle', '2024-03-06 17:54:53', b'1'),
(6743, 'sisesc', 6, 'papcompra', '2024-03-06 17:55:05', b'1'),
(6744, 'sisesc', 6, 'selproveedor', '2024-03-06 17:55:08', b'1'),
(6745, 'sisesc', 6, 'selcompra', '2024-03-06 17:55:16', b'1'),
(6746, 'sisesc', 6, 'selproveedor', '2024-03-06 17:55:23', b'1'),
(6747, 'sisesc', 6, 'getcompra', '2024-03-06 17:55:23', b'1'),
(6748, 'sisesc', 6, 'selcompradetalle', '2024-03-06 17:55:23', b'1'),
(6749, 'sisesc', 6, 'selproducto', '2024-03-06 17:55:24', b'1'),
(6750, 'sisesc', 6, 'getproveedor', '2024-03-06 17:55:24', b'1'),
(6751, 'sisesc', 6, 'getpersona', '2024-03-06 17:55:24', b'1'),
(6752, 'sisesc', 6, 'getcompra', '2024-03-06 17:55:32', b'1'),
(6753, 'sisesc', 6, 'selcompradetalle', '2024-03-06 17:55:32', b'1'),
(6754, 'sisesc', 6, 'getproveedor', '2024-03-06 17:55:33', b'1'),
(6755, 'sisesc', 6, 'getpersona', '2024-03-06 17:55:33', b'1'),
(6756, 'sisesc', 6, 'getcompra', '2024-03-06 17:56:21', b'1'),
(6757, 'sisesc', 6, 'selpagocompra', '2024-03-06 17:56:21', b'1'),
(6758, 'sisesc', 6, 'getproveedor', '2024-03-06 17:56:21', b'1'),
(6759, 'sisesc', 6, 'getpersona', '2024-03-06 17:56:22', b'1'),
(6760, 'sisesc', 6, 'getcompra', '2024-03-06 17:56:22', b'1'),
(6761, 'sisesc', 6, 'getcompra', '2024-03-06 17:56:27', b'1'),
(6762, 'sisesc', 6, 'selproveedor', '2024-03-06 17:56:27', b'1'),
(6763, 'sisesc', 6, 'selcompradetalle', '2024-03-06 17:56:27', b'1'),
(6764, 'sisesc', 6, 'selproducto', '2024-03-06 17:56:27', b'1'),
(6765, 'sisesc', 6, 'getproveedor', '2024-03-06 17:56:28', b'1'),
(6766, 'sisesc', 6, 'getpersona', '2024-03-06 17:56:28', b'1'),
(6767, 'sisesc', 6, 'selcompra', '2024-03-06 17:56:36', b'1'),
(6768, 'sisesc', 6, 'selproveedor', '2024-03-06 17:56:52', b'1'),
(6769, 'sisesc', 6, 'getcompra', '2024-03-06 17:56:52', b'1'),
(6770, 'sisesc', 6, 'selcompradetalle', '2024-03-06 17:56:52', b'1'),
(6771, 'sisesc', 6, 'selproducto', '2024-03-06 17:56:53', b'1'),
(6772, 'sisesc', 6, 'getproveedor', '2024-03-06 17:56:53', b'1'),
(6773, 'sisesc', 6, 'getpersona', '2024-03-06 17:56:53', b'1'),
(6774, 'sisesc', 6, 'getcompra', '2024-03-06 17:56:57', b'1'),
(6775, 'sisesc', 6, 'selpagocompra', '2024-03-06 17:56:57', b'1'),
(6776, 'sisesc', 6, 'getproveedor', '2024-03-06 17:56:57', b'1'),
(6777, 'sisesc', 6, 'getpersona', '2024-03-06 17:56:58', b'1'),
(6778, 'sisesc', 6, 'getcompra', '2024-03-06 17:56:58', b'1'),
(6779, 'sisesc', 6, 'getpagocompra', '2024-03-06 17:57:08', b'1'),
(6780, 'sisesc', 6, 'getcompra', '2024-03-06 17:57:08', b'1'),
(6781, 'sisesc', 6, 'getproveedor', '2024-03-06 17:57:08', b'1'),
(6782, 'sisesc', 6, 'getpersona', '2024-03-06 17:57:09', b'1'),
(6783, 'sisesc', 1, 'seloficina', '2024-03-07 16:20:34', b'1'),
(6784, 'sisesc', 1, 'selcompra', '2024-03-07 16:20:37', b'1'),
(6785, 'sisesc', 1, 'selproductostock', '2024-03-07 16:20:42', b'1'),
(6786, 'sisesc', 1, 'selproducto', '2024-03-07 16:21:14', b'1'),
(6787, 'sisesc', 1, 'selmarca', '2024-03-07 16:21:16', b'1'),
(6788, 'sisesc', 1, 'selclasificacionproducto', '2024-03-07 16:21:16', b'1'),
(6789, 'sisesc', 1, 'addproducto', '2024-03-07 16:21:34', b'1'),
(6790, 'sisesc', 1, 'selproducto', '2024-03-07 16:21:34', b'1'),
(6791, 'sisesc', 1, 'selproveedor', '2024-03-07 16:21:36', b'1'),
(6792, 'sisesc', 1, 'getproveedor', '2024-03-07 16:21:39', b'1'),
(6793, 'sisesc', 1, 'getpersona', '2024-03-07 16:21:39', b'1'),
(6794, 'sisesc', 1, 'addcompra', '2024-03-07 16:21:39', b'1'),
(6795, 'sisesc', 1, 'selproducto', '2024-03-07 16:21:40', b'1'),
(6796, 'sisesc', 1, 'getproducto', '2024-03-07 16:21:42', b'1'),
(6797, 'sisesc', 1, 'addcompradetalle', '2024-03-07 16:21:47', b'1'),
(6798, 'sisesc', 1, 'selcompradetalle', '2024-03-07 16:21:48', b'1'),
(6799, 'sisesc', 1, 'papcompra', '2024-03-07 16:21:52', b'1'),
(6800, 'sisesc', 1, 'selproveedor', '2024-03-07 16:21:53', b'1'),
(6801, 'sisesc', 1, 'getcompra', '2024-03-07 16:21:53', b'1'),
(6802, 'sisesc', 1, 'selcompradetalle', '2024-03-07 16:21:53', b'1'),
(6803, 'sisesc', 1, 'selproducto', '2024-03-07 16:21:53', b'1'),
(6804, 'sisesc', 1, 'getproveedor', '2024-03-07 16:21:53', b'1'),
(6805, 'sisesc', 1, 'getpersona', '2024-03-07 16:21:54', b'1'),
(6806, 'sisesc', 1, 'selcompra', '2024-03-07 16:22:02', b'1'),
(6807, 'sisesc', 1, 'selproveedor', '2024-03-07 16:22:12', b'1'),
(6808, 'sisesc', 1, 'getcompra', '2024-03-07 16:22:12', b'1'),
(6809, 'sisesc', 1, 'selcompradetalle', '2024-03-07 16:22:12', b'1'),
(6810, 'sisesc', 1, 'selproducto', '2024-03-07 16:22:12', b'1'),
(6811, 'sisesc', 1, 'getproveedor', '2024-03-07 16:22:12', b'1'),
(6812, 'sisesc', 1, 'getpersona', '2024-03-07 16:22:12', b'1'),
(6813, 'sisesc', 1, 'selproveedor', '2024-03-07 16:27:41', b'1'),
(6814, 'sisesc', 1, 'getproveedor', '2024-03-07 16:27:44', b'1'),
(6815, 'sisesc', 1, 'getpersona', '2024-03-07 16:27:44', b'1'),
(6816, 'sisesc', 1, 'addcompra', '2024-03-07 16:27:44', b'1'),
(6817, 'sisesc', 1, 'selproducto', '2024-03-07 16:27:44', b'1'),
(6818, 'sisesc', 1, 'getproducto', '2024-03-07 16:27:46', b'1'),
(6819, 'sisesc', 1, 'addcompradetalle', '2024-03-07 16:27:52', b'1'),
(6820, 'sisesc', 1, 'selcompradetalle', '2024-03-07 16:27:52', b'1'),
(6821, 'sisesc', 1, 'papcompra', '2024-03-07 16:27:55', b'1'),
(6822, 'sisesc', 1, 'selproveedor', '2024-03-07 16:27:56', b'1'),
(6823, 'sisesc', 1, 'getcompra', '2024-03-07 16:27:56', b'1'),
(6824, 'sisesc', 1, 'selcompradetalle', '2024-03-07 16:27:56', b'1'),
(6825, 'sisesc', 1, 'selproducto', '2024-03-07 16:27:56', b'1'),
(6826, 'sisesc', 1, 'getproveedor', '2024-03-07 16:27:56', b'1'),
(6827, 'sisesc', 1, 'getpersona', '2024-03-07 16:27:57', b'1'),
(6828, 'sisesc', 1, 'selcompra', '2024-03-07 16:28:08', b'1'),
(6829, 'sisesc', 1, 'selcliente', '2024-03-07 16:28:41', b'1'),
(6830, 'sisesc', 1, 'getcliente', '2024-03-07 16:28:44', b'1'),
(6831, 'sisesc', 1, 'getpersona', '2024-03-07 16:28:44', b'1'),
(6832, 'sisesc', 1, 'addventa', '2024-03-07 16:28:44', b'1'),
(6833, 'sisesc', 1, 'selproducto', '2024-03-07 16:28:44', b'1'),
(6834, 'sisesc', 1, 'selproductostock', '2024-03-07 16:28:54', b'1'),
(6835, 'sisesc', 1, 'selcliente', '2024-03-07 16:29:00', b'1'),
(6836, 'sisesc', 1, 'selventa', '2024-03-07 16:29:04', b'1'),
(6837, 'sisesc', 1, 'selcliente', '2024-03-07 16:29:05', b'1'),
(6838, 'sisesc', 1, 'getventa', '2024-03-07 16:29:05', b'1'),
(6839, 'sisesc', 1, 'selventadetalle', '2024-03-07 16:29:05', b'1'),
(6840, 'sisesc', 1, 'selproductostock', '2024-03-07 16:29:06', b'1'),
(6841, 'sisesc', 1, 'getcliente', '2024-03-07 16:29:06', b'1'),
(6842, 'sisesc', 1, 'getpersona', '2024-03-07 16:29:06', b'1'),
(6843, 'sisesc', 1, 'seloficina', '2024-03-07 16:35:37', b'1'),
(6844, 'sisesc', 1, 'selventa', '2024-03-07 16:35:52', b'1'),
(6845, 'sisesc', 1, 'seloficina', '2024-03-07 16:36:24', b'1'),
(6846, 'sisesc', 1, 'selventa', '2024-03-07 16:36:24', b'1'),
(6847, 'sisesc', 1, 'selcotizacion', '2024-03-07 16:37:18', b'1'),
(6848, 'sisesc', 1, 'selcliente', '2024-03-07 16:37:19', b'1'),
(6849, 'sisesc', 1, 'getcliente', '2024-03-07 16:37:21', b'1'),
(6850, 'sisesc', 1, 'getpersona', '2024-03-07 16:37:21', b'1'),
(6851, 'sisesc', 1, 'selcotizacion', '2024-03-07 16:37:21', b'1'),
(6852, 'sisesc', 1, 'addcotizacion', '2024-03-07 16:37:21', b'1'),
(6853, 'sisesc', 1, 'selproducto', '2024-03-07 16:37:21', b'1'),
(6854, 'sisesc', 1, 'getproducto', '2024-03-07 16:37:25', b'1'),
(6855, 'sisesc', 1, 'addcotizaciondetalle', '2024-03-07 16:37:27', b'1'),
(6856, 'sisesc', 1, 'selcotizaciondetalle', '2024-03-07 16:37:27', b'1'),
(6857, 'sisesc', 1, 'updcotizacion', '2024-03-07 16:37:30', b'1'),
(6858, 'sisesc', 1, 'seloficina', '2024-03-07 16:37:30', b'1'),
(6859, 'sisesc', 1, 'selcliente', '2024-03-07 16:37:30', b'1'),
(6860, 'sisesc', 1, 'getcotizacion', '2024-03-07 16:37:30', b'1'),
(6861, 'sisesc', 1, 'selcotizaciondetalle', '2024-03-07 16:37:31', b'1'),
(6862, 'sisesc', 1, 'selproducto', '2024-03-07 16:37:31', b'1'),
(6863, 'sisesc', 1, 'getcliente', '2024-03-07 16:37:31', b'1'),
(6864, 'sisesc', 1, 'getpersona', '2024-03-07 16:37:31', b'1'),
(6865, 'sisesc', 1, 'selcotizacion', '2024-03-07 16:37:37', b'1'),
(6866, 'sisesc', 1, 'selventa', '2024-03-07 16:37:47', b'1'),
(6867, 'sisesc', 1, 'selcliente', '2024-03-07 16:37:48', b'1'),
(6868, 'sisesc', 1, 'getventa', '2024-03-07 16:37:48', b'1'),
(6869, 'sisesc', 1, 'selventadetalle', '2024-03-07 16:37:48', b'1'),
(6870, 'sisesc', 1, 'selproductostock', '2024-03-07 16:37:49', b'1'),
(6871, 'sisesc', 1, 'getcliente', '2024-03-07 16:37:49', b'1'),
(6872, 'sisesc', 1, 'getpersona', '2024-03-07 16:37:49', b'1'),
(6873, 'sisesc', 1, 'selusuario', '2024-03-07 16:38:29', b'1'),
(6874, 'sisesc', 1, 'selventa', '2024-03-07 16:38:32', b'1'),
(6875, 'sisesc', 1, 'selcliente', '2024-03-07 16:38:33', b'1'),
(6876, 'sisesc', 1, 'getventa', '2024-03-07 16:38:33', b'1'),
(6877, 'sisesc', 1, 'selventadetalle', '2024-03-07 16:38:34', b'1'),
(6878, 'sisesc', 1, 'selproductostock', '2024-03-07 16:38:34', b'1'),
(6879, 'sisesc', 1, 'getcliente', '2024-03-07 16:38:34', b'1'),
(6880, 'sisesc', 1, 'getpersona', '2024-03-07 16:38:34', b'1'),
(6881, 'sisesc', 1, 'selproveedor', '2024-03-07 16:39:06', b'1'),
(6882, 'sisesc', 1, 'getproveedor', '2024-03-07 16:39:07', b'1'),
(6883, 'sisesc', 1, 'getpersona', '2024-03-07 16:39:08', b'1'),
(6884, 'sisesc', 1, 'addcompra', '2024-03-07 16:39:08', b'1'),
(6885, 'sisesc', 1, 'selproducto', '2024-03-07 16:39:08', b'1'),
(6886, 'sisesc', 1, 'getproducto', '2024-03-07 16:39:10', b'1'),
(6887, 'sisesc', 1, 'addcompradetalle', '2024-03-07 16:39:15', b'1'),
(6888, 'sisesc', 1, 'selcompradetalle', '2024-03-07 16:39:16', b'1'),
(6889, 'sisesc', 1, 'papcompra', '2024-03-07 16:39:17', b'1'),
(6890, 'sisesc', 1, 'seloficina', '2024-03-07 16:39:17', b'1'),
(6891, 'sisesc', 1, 'selproveedor', '2024-03-07 16:39:17', b'1'),
(6892, 'sisesc', 1, 'getcompra', '2024-03-07 16:39:17', b'1'),
(6893, 'sisesc', 1, 'selcompradetalle', '2024-03-07 16:39:18', b'1'),
(6894, 'sisesc', 1, 'selproducto', '2024-03-07 16:39:18', b'1'),
(6895, 'sisesc', 1, 'getproveedor', '2024-03-07 16:39:18', b'1'),
(6896, 'sisesc', 1, 'getpersona', '2024-03-07 16:39:18', b'1'),
(6897, 'sisesc', 1, 'selcliente', '2024-03-07 16:39:22', b'1'),
(6898, 'sisesc', 1, 'getcliente', '2024-03-07 16:39:23', b'1'),
(6899, 'sisesc', 1, 'getpersona', '2024-03-07 16:39:23', b'1'),
(6900, 'sisesc', 1, 'addventa', '2024-03-07 16:39:23', b'1'),
(6901, 'sisesc', 1, 'selproducto', '2024-03-07 16:39:24', b'1'),
(6902, 'sisesc', 1, 'seloficina', '2024-03-07 16:41:02', b'1'),
(6903, 'sisesc', 1, 'selcliente', '2024-03-07 16:41:02', b'1'),
(6904, 'sisesc', 1, 'getventa', '2024-03-07 16:41:02', b'1'),
(6905, 'sisesc', 1, 'selventadetalle', '2024-03-07 16:41:02', b'1'),
(6906, 'sisesc', 1, 'selproductostock', '2024-03-07 16:41:02', b'1'),
(6907, 'sisesc', 1, 'getcliente', '2024-03-07 16:41:03', b'1'),
(6908, 'sisesc', 1, 'getpersona', '2024-03-07 16:41:03', b'1'),
(6909, 'sisesc', 1, 'getproductostock', '2024-03-07 16:41:05', b'1'),
(6910, 'sisesc', 1, 'getproducto', '2024-03-07 16:41:05', b'1'),
(6911, 'sisesc', 1, 'addventadetalle', '2024-03-07 16:41:08', b'1'),
(6912, 'sisesc', 1, 'selventadetalle', '2024-03-07 16:41:09', b'1'),
(6913, 'sisesc', 1, 'papventa', '2024-03-07 16:41:14', b'1'),
(6914, 'sisesc', 1, 'seloficina', '2024-03-07 16:41:14', b'1'),
(6915, 'sisesc', 1, 'selcliente', '2024-03-07 16:41:14', b'1'),
(6916, 'sisesc', 1, 'getventa', '2024-03-07 16:41:14', b'1'),
(6917, 'sisesc', 1, 'selventadetalle', '2024-03-07 16:41:15', b'1'),
(6918, 'sisesc', 1, 'selproductostock', '2024-03-07 16:41:15', b'1'),
(6919, 'sisesc', 1, 'getcliente', '2024-03-07 16:41:15', b'1'),
(6920, 'sisesc', 1, 'getpersona', '2024-03-07 16:41:15', b'1'),
(6921, 'sisesc', 1, 'selventa', '2024-03-07 16:41:17', b'1'),
(6922, 'sisesc', 1, 'seloficina', '2024-03-07 16:41:34', b'1'),
(6923, 'sisesc', 1, 'selventa', '2024-03-07 16:41:34', b'1'),
(6924, 'sisesc', 1, 'selcompra', '2024-03-07 16:41:40', b'1'),
(6925, 'sisesc', 1, 'selproductostock', '2024-03-07 16:45:14', b'1'),
(6926, 'sisesc', 1, 'seloficina', '2024-03-07 16:47:16', b'1'),
(6927, 'sisesc', 1, 'selproductostock', '2024-03-07 16:47:16', b'1'),
(6928, 'sisesc', 1, 'seloficina', '2024-03-07 16:47:38', b'1'),
(6929, 'sisesc', 1, 'selproductostock', '2024-03-07 16:47:38', b'1'),
(6930, 'sisesc', 1, 'seloficina', '2024-03-07 16:50:14', b'1'),
(6931, 'sisesc', 1, 'selproductostock', '2024-03-07 16:50:14', b'1'),
(6932, 'sisesc', 1, 'selparametro', '2024-03-07 16:50:46', b'1'),
(6933, 'sisesc', 1, 'selcompra', '2024-03-07 16:50:49', b'1'),
(6934, 'sisesc', 1, 'seloficina', '2024-03-07 16:58:44', b'1'),
(6935, 'sisesc', 1, 'selparametro', '2024-03-07 16:58:44', b'1'),
(6936, 'sisesc', 1, 'seloficina', '2024-03-07 16:58:58', b'1'),
(6937, 'sisesc', 1, 'selparametro', '2024-03-07 16:58:58', b'1'),
(6938, 'sisesc', 1, 'seloficina', '2024-03-07 16:59:13', b'1'),
(6939, 'sisesc', 1, 'selparametro', '2024-03-07 16:59:13', b'1'),
(6940, 'sisesc', 1, 'seloficina', '2024-03-07 17:00:04', b'1'),
(6941, 'sisesc', 1, 'selparametro', '2024-03-07 17:00:04', b'1'),
(6942, 'sisesc', 1, 'seloficina', '2024-03-07 17:00:17', b'1'),
(6943, 'sisesc', 1, 'selparametro', '2024-03-07 17:00:17', b'1'),
(6944, 'sisesc', 1, 'seloficina', '2024-03-07 17:00:25', b'1'),
(6945, 'sisesc', 1, 'selparametro', '2024-03-07 17:00:25', b'1'),
(6946, 'sisesc', 1, 'seloficina', '2024-03-07 17:00:54', b'1'),
(6947, 'sisesc', 1, 'selparametro', '2024-03-07 17:00:54', b'1'),
(6948, 'sisesc', 1, 'seloficina', '2024-03-07 18:39:56', b'1'),
(6949, 'sisesc', 1, 'selusuario', '2024-03-07 18:39:57', b'1'),
(6950, 'sisesc', 1, 'getusuario', '2024-03-07 18:40:18', b'1'),
(6951, 'sisesc', 1, 'getpersona', '2024-03-07 18:40:18', b'1'),
(6952, 'sisesc', 1, 'selrolusuario', '2024-03-07 18:40:18', b'1'),
(6953, 'sisesc', 1, 'selusuario', '2024-03-07 18:40:23', b'1'),
(6954, 'sisesc', 1, 'selcompra', '2024-03-07 19:17:36', b'1'),
(6955, 'sisesc', 1, 'selproductostock', '2024-03-07 19:17:48', b'1'),
(6956, 'sisesc', 1, 'seloficina', '2024-03-07 21:10:58', b'1'),
(6957, 'sisesc', 1, 'selusuario', '2024-03-07 21:11:01', b'1'),
(6958, 'sisesc', 1, 'seloficina', '2024-03-07 21:11:14', b'1'),
(6959, 'sisesc', 1, 'selusuario', '2024-03-07 21:11:16', b'1'),
(6960, 'sisesc', 1, 'seloficina', '2024-03-07 22:37:19', b'1'),
(6961, 'sisesc', 1, 'seloficina', '2024-03-07 22:37:21', b'1'),
(6962, 'sisesc', 1, 'selproveedor', '2024-03-07 22:37:24', b'1'),
(6963, 'sisesc', 1, 'getproveedor', '2024-03-07 22:37:27', b'1'),
(6964, 'sisesc', 1, 'getpersona', '2024-03-07 22:37:27', b'1'),
(6965, 'sisesc', 1, 'addcompra', '2024-03-07 22:37:27', b'1'),
(6966, 'sisesc', 1, 'selproducto', '2024-03-07 22:37:27', b'1'),
(6967, 'sisesc', 1, 'getproducto', '2024-03-07 22:37:30', b'1'),
(6968, 'sisesc', 1, 'addcompradetalle', '2024-03-07 22:37:37', b'1'),
(6969, 'sisesc', 1, 'selcompradetalle', '2024-03-07 22:37:37', b'1'),
(6970, 'sisesc', 1, 'getproducto', '2024-03-07 22:37:39', b'1'),
(6971, 'sisesc', 1, 'addcompradetalle', '2024-03-07 22:37:44', b'1'),
(6972, 'sisesc', 1, 'selcompradetalle', '2024-03-07 22:37:44', b'1'),
(6973, 'sisesc', 1, 'papcompra', '2024-03-07 22:37:47', b'1'),
(6974, 'sisesc', 1, 'getcompra', '2024-03-07 22:37:48', b'1'),
(6975, 'sisesc', 1, 'selproveedor', '2024-03-07 22:37:48', b'1'),
(6976, 'sisesc', 1, 'selcompradetalle', '2024-03-07 22:37:48', b'1'),
(6977, 'sisesc', 1, 'selproducto', '2024-03-07 22:37:48', b'1'),
(6978, 'sisesc', 1, 'getproveedor', '2024-03-07 22:37:49', b'1'),
(6979, 'sisesc', 1, 'getpersona', '2024-03-07 22:37:49', b'1'),
(6980, 'sisesc', 1, 'getcompra', '2024-03-07 22:37:52', b'1'),
(6981, 'sisesc', 1, 'selcompradetalle', '2024-03-07 22:37:53', b'1'),
(6982, 'sisesc', 1, 'getproveedor', '2024-03-07 22:37:53', b'1'),
(6983, 'sisesc', 1, 'getpersona', '2024-03-07 22:37:53', b'1'),
(6984, 'sisesc', 1, 'selproductostock', '2024-03-07 22:38:05', b'1'),
(6985, 'sisesc', 1, 'selproveedor', '2024-03-07 22:39:48', b'1'),
(6986, 'sisesc', 1, 'getproveedor', '2024-03-07 22:39:53', b'1'),
(6987, 'sisesc', 1, 'getpersona', '2024-03-07 22:39:53', b'1'),
(6988, 'sisesc', 1, 'addcompra', '2024-03-07 22:39:53', b'1'),
(6989, 'sisesc', 1, 'selproducto', '2024-03-07 22:39:53', b'1'),
(6990, 'sisesc', 1, 'getproducto', '2024-03-07 22:40:05', b'1'),
(6991, 'sisesc', 1, 'addcompradetalle', '2024-03-07 22:40:10', b'1'),
(6992, 'sisesc', 1, 'selcompradetalle', '2024-03-07 22:40:10', b'1'),
(6993, 'sisesc', 1, 'selproducto', '2024-03-07 22:41:03', b'1'),
(6994, 'sisesc', 1, 'getproducto', '2024-03-07 22:41:05', b'1'),
(6995, 'sisesc', 1, 'selmarca', '2024-03-07 22:41:05', b'1'),
(6996, 'sisesc', 1, 'selclasificacionproducto', '2024-03-07 22:41:05', b'1'),
(6997, 'sisesc', 1, 'selusuario', '2024-03-07 22:42:07', b'1'),
(6998, 'sisesc', 1, 'selusuario', '2024-03-07 22:42:12', b'1'),
(6999, 'sisesc', 1, 'getusuario', '2024-03-07 22:42:14', b'1'),
(7000, 'sisesc', 1, 'getpersona', '2024-03-07 22:42:14', b'1'),
(7001, 'sisesc', 1, 'selrolusuario', '2024-03-07 22:42:14', b'1'),
(7002, 'sisesc', 1, 'selcliente', '2024-03-07 22:46:47', b'1'),
(7003, 'sisesc', 1, 'getcliente', '2024-03-07 22:46:48', b'1'),
(7004, 'sisesc', 1, 'getpersona', '2024-03-07 22:46:48', b'1'),
(7005, 'sisesc', 1, 'addventa', '2024-03-07 22:46:49', b'1'),
(7006, 'sisesc', 1, 'selproducto', '2024-03-07 22:46:49', b'1'),
(7007, 'sisesc', 1, 'getproductostock', '2024-03-07 22:46:56', b'1'),
(7008, 'sisesc', 1, 'selcliente', '2024-03-07 22:47:20', b'1'),
(7009, 'sisesc', 1, 'getventa', '2024-03-07 22:47:20', b'1'),
(7010, 'sisesc', 1, 'selventadetalle', '2024-03-07 22:47:20', b'1'),
(7011, 'sisesc', 1, 'selproductostock', '2024-03-07 22:47:20', b'1'),
(7012, 'sisesc', 1, 'getcliente', '2024-03-07 22:47:21', b'1'),
(7013, 'sisesc', 1, 'getpersona', '2024-03-07 22:47:21', b'1'),
(7014, 'sisesc', 1, 'getproductostock', '2024-03-07 22:47:23', b'1'),
(7015, 'sisesc', 1, 'getproducto', '2024-03-07 22:47:23', b'1'),
(7016, 'sisesc', 1, 'addventadetalle', '2024-03-07 22:47:25', b'1'),
(7017, 'sisesc', 1, 'selventadetalle', '2024-03-07 22:47:26', b'1'),
(7018, 'sisesc', 1, 'papventa', '2024-03-07 22:47:37', b'1'),
(7019, 'sisesc', 1, 'selcliente', '2024-03-07 22:47:38', b'1'),
(7020, 'sisesc', 1, 'getventa', '2024-03-07 22:47:38', b'1'),
(7021, 'sisesc', 1, 'selventadetalle', '2024-03-07 22:47:38', b'1'),
(7022, 'sisesc', 1, 'selproductostock', '2024-03-07 22:47:38', b'1'),
(7023, 'sisesc', 1, 'getcliente', '2024-03-07 22:47:39', b'1'),
(7024, 'sisesc', 1, 'getpersona', '2024-03-07 22:47:39', b'1'),
(7025, 'sisesc', 1, 'selproductostock', '2024-03-07 22:48:21', b'1'),
(7026, 'sisesc', 1, 'selcompra', '2024-03-07 22:48:37', b'1'),
(7027, 'sisesc', 1, 'selproveedor', '2024-03-07 22:48:52', b'1'),
(7028, 'sisesc', 1, 'selcompra', '2024-03-07 22:51:08', b'1'),
(7029, 'sisesc', 1, 'getcompra', '2024-03-07 22:51:09', b'1'),
(7030, 'sisesc', 1, 'selproveedor', '2024-03-07 22:51:09', b'1'),
(7031, 'sisesc', 1, 'selcompradetalle', '2024-03-07 22:51:09', b'1'),
(7032, 'sisesc', 1, 'selproducto', '2024-03-07 22:51:10', b'1'),
(7033, 'sisesc', 1, 'getproveedor', '2024-03-07 22:51:10', b'1'),
(7034, 'sisesc', 1, 'getpersona', '2024-03-07 22:51:10', b'1'),
(7035, 'sisesc', 1, 'getproducto', '2024-03-07 22:51:11', b'1'),
(7036, 'sisesc', 1, 'addcompradetalle', '2024-03-07 22:51:13', b'1'),
(7037, 'sisesc', 1, 'selcompradetalle', '2024-03-07 22:51:14', b'1'),
(7038, 'sisesc', 1, 'selusuario', '2024-03-07 22:53:36', b'1'),
(7039, 'sisesc', 1, 'getusuario', '2024-03-07 22:53:37', b'1'),
(7040, 'sisesc', 1, 'getpersona', '2024-03-07 22:53:38', b'1'),
(7041, 'sisesc', 1, 'selrolusuario', '2024-03-07 22:53:38', b'1'),
(7042, 'sisesc', 1, 'selusuario', '2024-03-07 22:57:58', b'1'),
(7043, 'sisesc', 3, 'seloficina', '2024-03-09 15:12:12', b'1'),
(7044, 'sisesc', 3, 'selusuario', '2024-03-09 15:12:16', b'1'),
(7045, 'sisesc', 3, 'selproducto', '2024-03-09 15:12:21', b'1'),
(7046, 'sisesc', 3, 'selmarca', '2024-03-09 15:12:24', b'1'),
(7047, 'sisesc', 3, 'selclasificacionproducto', '2024-03-09 15:12:25', b'1'),
(7048, 'sisesc', 3, 'selmarca', '2024-03-09 15:12:27', b'1'),
(7049, 'sisesc', 3, 'selparametrotipo', '2024-03-09 15:12:30', b'1'),
(7050, 'sisesc', 3, 'selplandecuenta', '2024-03-09 15:12:30', b'1'),
(7051, 'sisesc', 3, 'selproveedor', '2024-03-09 15:12:34', b'1'),
(7052, 'sisesc', 3, 'getproveedor', '2024-03-09 15:12:41', b'1'),
(7053, 'sisesc', 3, 'getpersona', '2024-03-09 15:12:41', b'1'),
(7054, 'sisesc', 3, 'addcompra', '2024-03-09 15:12:42', b'1'),
(7055, 'sisesc', 3, 'selproducto', '2024-03-09 15:12:42', b'1'),
(7056, 'sisesc', 3, 'getproducto', '2024-03-09 15:12:47', b'1'),
(7057, 'sisesc', 3, 'addcompradetalle', '2024-03-09 15:12:54', b'1'),
(7058, 'sisesc', 3, 'selcompradetalle', '2024-03-09 15:12:55', b'1'),
(7059, 'sisesc', 3, 'selproductostock', '2024-03-09 15:15:55', b'1'),
(7060, 'sisesc', 3, 'selusuario', '2024-03-09 15:17:03', b'1'),
(7061, 'sisesc', 3, 'getusuario', '2024-03-09 15:17:09', b'1'),
(7062, 'sisesc', 3, 'getpersona', '2024-03-09 15:17:09', b'1'),
(7063, 'sisesc', 3, 'selrolusuario', '2024-03-09 15:17:09', b'1'),
(7064, 'sisesc', 6, 'seloficina', '2024-03-11 14:00:53', b'1'),
(7065, 'sisesc', 6, 'selusuario', '2024-03-11 14:01:22', b'1'),
(7066, 'sisesc', 6, 'selproducto', '2024-03-11 14:01:28', b'1'),
(7067, 'sisesc', 6, 'getproducto', '2024-03-11 14:01:47', b'1'),
(7068, 'sisesc', 6, 'selmarca', '2024-03-11 14:01:47', b'1'),
(7069, 'sisesc', 6, 'selclasificacionproducto', '2024-03-11 14:01:47', b'1'),
(7070, 'sisesc', 6, 'selproducto', '2024-03-11 14:01:53', b'1'),
(7071, 'sisesc', 6, 'selmarca', '2024-03-11 14:01:56', b'1'),
(7072, 'sisesc', 6, 'selparametrotipo', '2024-03-11 14:02:07', b'1'),
(7073, 'sisesc', 6, 'selplandecuenta', '2024-03-11 14:02:07', b'1'),
(7074, 'sisesc', 6, 'getplandecuenta', '2024-03-11 14:02:11', b'1'),
(7075, 'sisesc', 6, 'selparametrotipo', '2024-03-11 14:02:11', b'1'),
(7076, 'sisesc', 6, 'selparametrotipo', '2024-03-11 14:02:17', b'1'),
(7077, 'sisesc', 6, 'selplandecuenta', '2024-03-11 14:02:18', b'1'),
(7078, 'sisesc', 6, 'getplandecuenta', '2024-03-11 14:02:21', b'1'),
(7079, 'sisesc', 6, 'selparametrotipo', '2024-03-11 14:02:21', b'1'),
(7080, 'sisesc', 6, 'selparametrotipo', '2024-03-11 14:02:23', b'1'),
(7081, 'sisesc', 6, 'selplandecuenta', '2024-03-11 14:02:24', b'1'),
(7082, 'sisesc', 6, 'selproveedor', '2024-03-11 14:02:30', b'1'),
(7083, 'sisesc', 6, 'getproveedor', '2024-03-11 14:02:40', b'1'),
(7084, 'sisesc', 6, 'getpersona', '2024-03-11 14:02:40', b'1'),
(7085, 'sisesc', 6, 'addcompra', '2024-03-11 14:02:40', b'1'),
(7086, 'sisesc', 6, 'selproducto', '2024-03-11 14:02:41', b'1'),
(7087, 'sisesc', 6, 'getproducto', '2024-03-11 14:02:53', b'1'),
(7088, 'sisesc', 6, 'addcompradetalle', '2024-03-11 14:03:13', b'1'),
(7089, 'sisesc', 6, 'selcompradetalle', '2024-03-11 14:03:13', b'1'),
(7090, 'sisesc', 6, 'papcompradetalle', '2024-03-11 14:04:12', b'1'),
(7091, 'sisesc', 6, 'selcompradetalle', '2024-03-11 14:04:12', b'1'),
(7092, 'sisesc', 6, 'selcompra', '2024-03-11 14:04:17', b'1'),
(7093, 'sisesc', 6, 'selproveedor', '2024-03-11 14:04:22', b'1'),
(7094, 'sisesc', 6, 'getcompra', '2024-03-11 14:04:22', b'1'),
(7095, 'sisesc', 6, 'selcompradetalle', '2024-03-11 14:04:22', b'1'),
(7096, 'sisesc', 6, 'selproducto', '2024-03-11 14:04:23', b'1'),
(7097, 'sisesc', 6, 'getproveedor', '2024-03-11 14:04:23', b'1'),
(7098, 'sisesc', 6, 'getpersona', '2024-03-11 14:04:23', b'1'),
(7099, 'sisesc', 6, 'getcompra', '2024-03-11 14:04:25', b'1'),
(7100, 'sisesc', 6, 'selpagocompra', '2024-03-11 14:04:26', b'1'),
(7101, 'sisesc', 6, 'getproveedor', '2024-03-11 14:04:26', b'1'),
(7102, 'sisesc', 6, 'getpersona', '2024-03-11 14:04:26', b'1'),
(7103, 'sisesc', 6, 'getcompra', '2024-03-11 14:04:27', b'1'),
(7104, 'sisesc', 6, 'getpagocompra', '2024-03-11 14:04:39', b'1'),
(7105, 'sisesc', 6, 'getcompra', '2024-03-11 14:04:40', b'1'),
(7106, 'sisesc', 6, 'getproveedor', '2024-03-11 14:04:40', b'1'),
(7107, 'sisesc', 6, 'getpersona', '2024-03-11 14:04:40', b'1'),
(7108, 'sisesc', 6, 'selproveedor', '2024-03-11 14:18:28', b'1'),
(7109, 'sisesc', 6, 'getcompra', '2024-03-11 14:27:44', b'1'),
(7110, 'sisesc', 6, 'selpagocompra', '2024-03-11 14:27:45', b'1'),
(7111, 'sisesc', 6, 'getproveedor', '2024-03-11 14:27:45', b'1'),
(7112, 'sisesc', 6, 'getpersona', '2024-03-11 14:27:45', b'1'),
(7113, 'sisesc', 6, 'getcompra', '2024-03-11 14:27:45', b'1'),
(7114, 'sisesc', 6, 'selusuario', '2024-03-11 14:27:51', b'1'),
(7115, 'sisesc', 6, 'seloficina', '2024-03-11 14:53:29', b'1'),
(7116, 'sisesc', 6, 'seloficina', '2024-03-11 17:36:12', b'1'),
(7117, 'sisesc', 6, 'seloficina', '2024-03-11 17:44:44', b'1'),
(7118, 'sisesc', 6, 'seloficina', '2024-03-11 18:17:04', b'1'),
(7119, 'sisesc', 6, 'seloficina', '2024-03-11 18:17:12', b'1'),
(7120, 'sisesc', 6, 'selusuario', '2024-03-11 18:18:15', b'1'),
(7121, 'sisesc', 6, 'getusuario', '2024-03-11 18:18:22', b'1'),
(7122, 'sisesc', 6, 'getpersona', '2024-03-11 18:18:22', b'1'),
(7123, 'sisesc', 6, 'selrolusuario', '2024-03-11 18:18:23', b'1'),
(7124, 'sisesc', 6, 'seloficina', '2024-03-11 19:34:48', b'1'),
(7125, 'sisesc', 6, 'selusuario', '2024-03-11 19:34:59', b'1'),
(7126, 'sisesc', 6, 'addpersona', '2024-03-11 19:37:08', b'1'),
(7127, 'sisesc', 6, 'addusuario', '2024-03-11 19:37:08', b'1'),
(7128, 'sisesc', 6, 'selusuario', '2024-03-11 19:37:09', b'1'),
(7129, 'sisesc', 6, 'getusuario', '2024-03-11 19:37:21', b'1'),
(7130, 'sisesc', 6, 'getpersona', '2024-03-11 19:37:21', b'1'),
(7131, 'sisesc', 6, 'selrolusuario', '2024-03-11 19:37:21', b'1'),
(7132, 'sisesc', 6, 'selusuario', '2024-03-11 19:37:24', b'1'),
(7133, 'sisesc', 7, 'seloficina', '2024-03-11 19:37:37', b'1'),
(7134, 'sisesc', 7, 'selusuario', '2024-03-11 19:37:43', b'1'),
(7135, 'sisesc', 7, 'getusuario', '2024-03-11 19:38:06', b'1'),
(7136, 'sisesc', 7, 'getpersona', '2024-03-11 19:38:06', b'1'),
(7137, 'sisesc', 7, 'selrolusuario', '2024-03-11 19:38:06', b'1'),
(7138, 'sisesc', 7, 'selcompra', '2024-03-11 19:38:13', b'1'),
(7139, 'sisesc', 7, 'selproveedor', '2024-03-11 19:38:28', b'1'),
(7140, 'sisesc', 7, 'getproveedor', '2024-03-11 19:38:47', b'1'),
(7141, 'sisesc', 7, 'selproveedor', '2024-03-11 19:39:04', b'1'),
(7142, 'sisesc', 7, 'selmarca', '2024-03-11 19:39:06', b'1'),
(7143, 'sisesc', 7, 'selventa', '2024-03-11 19:41:37', b'1'),
(7144, 'sisesc', 7, 'selparametro', '2024-03-11 19:41:51', b'1'),
(7145, 'sisesc', 7, 'selcompra', '2024-03-11 19:42:21', b'1'),
(7146, 'sisesc', 7, 'selcompra', '2024-03-11 19:42:48', b'1'),
(7147, 'sisesc', 7, 'selcliente', '2024-03-11 19:42:53', b'1'),
(7148, 'sisesc', 7, 'getcliente', '2024-03-11 19:42:58', b'1'),
(7149, 'sisesc', 7, 'selcliente', '2024-03-11 19:43:00', b'1'),
(7150, 'sisesc', 7, 'getcliente', '2024-03-11 19:43:06', b'1'),
(7151, 'sisesc', 7, 'getpersona', '2024-03-11 19:43:07', b'1'),
(7152, 'sisesc', 7, 'selmarca', '2024-03-11 19:43:07', b'1'),
(7153, 'sisesc', 7, 'selcliente', '2024-03-11 19:43:13', b'1'),
(7154, 'sisesc', 7, 'selmarca', '2024-03-11 19:43:15', b'1'),
(7155, 'sisesc', 7, 'selcliente', '2024-03-11 19:43:15', b'1'),
(7156, 'sisesc', 7, 'selmarca', '2024-03-11 19:43:15', b'1'),
(7157, 'sisesc', 7, 'selcliente', '2024-03-11 19:43:15', b'1'),
(7158, 'sisesc', 7, 'selmarca', '2024-03-11 19:43:15', b'1'),
(7159, 'sisesc', 7, 'selcliente', '2024-03-11 19:43:16', b'1'),
(7160, 'sisesc', 7, 'selmarca', '2024-03-11 19:43:16', b'1'),
(7161, 'sisesc', 7, 'selmarca', '2024-03-11 19:43:20', b'1'),
(7162, 'sisesc', 7, 'selparametrotipo', '2024-03-11 19:43:33', b'1'),
(7163, 'sisesc', 7, 'selplandecuenta', '2024-03-11 19:43:34', b'1'),
(7164, 'sisesc', 7, 'getplandecuenta', '2024-03-11 19:43:38', b'1'),
(7165, 'sisesc', 7, 'selparametrotipo', '2024-03-11 19:43:38', b'1'),
(7166, 'sisesc', 7, 'selparametrotipo', '2024-03-11 19:43:49', b'1'),
(7167, 'sisesc', 7, 'selplandecuenta', '2024-03-11 19:43:49', b'1'),
(7168, 'sisesc', 7, 'selmarca', '2024-03-11 19:43:49', b'1'),
(7169, 'sisesc', 7, 'seloficina', '2024-03-11 19:45:25', b'1'),
(7170, 'sisesc', 7, 'selproveedor', '2024-03-11 19:46:04', b'1'),
(7171, 'sisesc', 7, 'selmarca', '2024-03-11 19:46:09', b'1'),
(7172, 'sisesc', 7, 'addpersona', '2024-03-11 19:46:28', b'1'),
(7173, 'sisesc', 7, 'addproveedor', '2024-03-11 19:46:28', b'1'),
(7174, 'sisesc', 7, 'selproveedor', '2024-03-11 19:46:29', b'1'),
(7175, 'sisesc', 7, 'getproveedor', '2024-03-11 19:46:36', b'1'),
(7176, 'sisesc', 7, 'getpersona', '2024-03-11 19:46:36', b'1'),
(7177, 'sisesc', 7, 'selmarca', '2024-03-11 19:46:36', b'1'),
(7178, 'sisesc', 7, 'selproveedor', '2024-03-11 19:46:43', b'1'),
(7179, 'sisesc', 7, 'getproveedor', '2024-03-11 19:46:45', b'1'),
(7180, 'sisesc', 7, 'getpersona', '2024-03-11 19:46:45', b'1'),
(7181, 'sisesc', 7, 'selmarca', '2024-03-11 19:46:46', b'1'),
(7182, 'sisesc', 7, 'selproveedor', '2024-03-11 19:46:54', b'1'),
(7183, 'sisesc', 7, 'getproveedor', '2024-03-11 19:46:58', b'1'),
(7184, 'sisesc', 7, 'getpersona', '2024-03-11 19:46:58', b'1'),
(7185, 'sisesc', 7, 'selmarca', '2024-03-11 19:46:58', b'1'),
(7186, 'sisesc', 7, 'updpersona', '2024-03-11 19:47:07', b'1'),
(7187, 'sisesc', 7, 'updproveedor', '2024-03-11 19:47:07', b'1'),
(7188, 'sisesc', 7, 'selproveedor', '2024-03-11 19:47:07', b'1'),
(7189, 'sisesc', 7, 'getproveedor', '2024-03-11 19:47:16', b'1'),
(7190, 'sisesc', 7, 'getpersona', '2024-03-11 19:47:17', b'1'),
(7191, 'sisesc', 7, 'selmarca', '2024-03-11 19:47:17', b'1'),
(7192, 'sisesc', 7, 'updpersona', '2024-03-11 19:47:24', b'1'),
(7193, 'sisesc', 7, 'updproveedor', '2024-03-11 19:47:24', b'1'),
(7194, 'sisesc', 7, 'selproveedor', '2024-03-11 19:47:24', b'1'),
(7195, 'sisesc', 7, 'getproveedor', '2024-03-11 19:47:29', b'1'),
(7196, 'sisesc', 7, 'getpersona', '2024-03-11 19:47:29', b'1'),
(7197, 'sisesc', 7, 'selmarca', '2024-03-11 19:47:29', b'1'),
(7198, 'sisesc', 7, 'updpersona', '2024-03-11 19:47:37', b'1'),
(7199, 'sisesc', 7, 'updproveedor', '2024-03-11 19:47:37', b'1'),
(7200, 'sisesc', 7, 'selproveedor', '2024-03-11 19:47:38', b'1'),
(7201, 'sisesc', 7, 'getproveedor', '2024-03-11 19:47:44', b'1'),
(7202, 'sisesc', 7, 'getpersona', '2024-03-11 19:47:44', b'1'),
(7203, 'sisesc', 7, 'selmarca', '2024-03-11 19:47:44', b'1'),
(7204, 'sisesc', 7, 'selproveedor', '2024-03-11 19:47:48', b'1'),
(7205, 'sisesc', 7, 'selmarca', '2024-03-11 19:54:10', b'1'),
(7206, 'sisesc', 7, 'selparametrotipo', '2024-03-11 19:54:16', b'1'),
(7207, 'sisesc', 7, 'selplandecuenta', '2024-03-11 19:54:16', b'1'),
(7208, 'sisesc', 7, 'selparametrotipo', '2024-03-11 19:54:17', b'1'),
(7209, 'sisesc', 7, 'selparametrotipo', '2024-03-11 19:54:19', b'1'),
(7210, 'sisesc', 7, 'selplandecuenta', '2024-03-11 19:54:21', b'1'),
(7211, 'sisesc', 7, 'getplandecuenta', '2024-03-11 19:54:28', b'1'),
(7212, 'sisesc', 7, 'selparametrotipo', '2024-03-11 19:54:28', b'1'),
(7213, 'sisesc', 7, 'selusuario', '2024-03-11 19:54:38', b'1'),
(7214, 'sisesc', 7, 'getusuario', '2024-03-11 19:56:01', b'1'),
(7215, 'sisesc', 7, 'getpersona', '2024-03-11 19:56:01', b'1'),
(7216, 'sisesc', 7, 'selrolusuario', '2024-03-11 19:56:02', b'1'),
(7217, 'sisesc', 7, 'selusuario', '2024-03-11 19:56:24', b'1'),
(7218, 'sisesc', 7, 'selusuario', '2024-03-11 19:57:25', b'1'),
(7219, 'sisesc', 7, 'addpersona', '2024-03-11 19:59:02', b'1'),
(7220, 'sisesc', 7, 'addusuario', '2024-03-11 19:59:02', b'1'),
(7221, 'sisesc', 7, 'selusuario', '2024-03-11 19:59:03', b'1'),
(7222, 'sisesc', 7, 'getusuario', '2024-03-11 19:59:11', b'1'),
(7223, 'sisesc', 7, 'getpersona', '2024-03-11 19:59:11', b'1'),
(7224, 'sisesc', 7, 'selrolusuario', '2024-03-11 19:59:11', b'1'),
(7225, 'sisesc', 7, 'selproveedor', '2024-03-11 19:59:25', b'1'),
(7226, 'sisesc', 7, 'getproveedor', '2024-03-11 19:59:38', b'1'),
(7227, 'sisesc', 7, 'getpersona', '2024-03-11 19:59:38', b'1'),
(7228, 'sisesc', 7, 'addcompra', '2024-03-11 19:59:39', b'1'),
(7229, 'sisesc', 7, 'selproducto', '2024-03-11 19:59:39', b'1'),
(7230, 'sisesc', 7, 'selcompra', '2024-03-11 19:59:51', b'1'),
(7231, 'sisesc', 7, 'selproveedor', '2024-03-11 19:59:55', b'1'),
(7232, 'sisesc', 7, 'selventa', '2024-03-11 19:59:58', b'1'),
(7233, 'sisesc', 7, 'selcliente', '2024-03-11 20:00:02', b'1'),
(7234, 'sisesc', 7, 'selproveedor', '2024-03-11 20:00:07', b'1'),
(7235, 'sisesc', 7, 'getproveedor', '2024-03-11 20:00:46', b'1'),
(7236, 'sisesc', 7, 'selventa', '2024-03-11 20:03:20', b'1'),
(7237, 'sisesc', 6, 'seloficina', '2024-03-11 20:03:30', b'1'),
(7238, 'sisesc', 7, 'selproductostock', '2024-03-11 20:03:32', b'1'),
(7239, 'sisesc', 6, 'selproveedor', '2024-03-11 20:03:37', b'1'),
(7240, 'sisesc', 6, 'selproveedor', '2024-03-11 20:03:40', b'1'),
(7241, 'sisesc', 7, 'selcliente', '2024-03-11 20:03:43', b'1'),
(7242, 'sisesc', 6, 'getproveedor', '2024-03-11 20:03:47', b'1'),
(7243, 'sisesc', 7, 'getcliente', '2024-03-11 20:03:57', b'1'),
(7244, 'sisesc', 7, 'selusuario', '2024-03-11 20:04:00', b'1'),
(7245, 'sisesc', 7, 'selmarca', '2024-03-11 20:04:30', b'1'),
(7246, 'sisesc', 7, 'getmarca', '2024-03-11 20:06:43', b'1'),
(7247, 'sisesc', 7, 'selmarca', '2024-03-11 20:06:43', b'1'),
(7248, 'sisesc', 7, 'updmarca', '2024-03-11 20:06:51', b'1'),
(7249, 'sisesc', 7, 'selmarca', '2024-03-11 20:06:52', b'1'),
(7250, 'sisesc', 7, 'getmarca', '2024-03-11 20:07:15', b'1'),
(7251, 'sisesc', 7, 'selmarca', '2024-03-11 20:07:16', b'1'),
(7252, 'sisesc', 7, 'selmarca', '2024-03-11 20:07:19', b'1'),
(7253, 'sisesc', 7, 'selproveedor', '2024-03-11 20:20:39', b'1'),
(7254, 'sisesc', 7, 'selproveedor', '2024-03-11 20:20:42', b'1'),
(7255, 'sisesc', 7, 'getproveedor', '2024-03-11 20:20:45', b'1'),
(7256, 'sisesc', 7, 'getpersona', '2024-03-11 20:20:45', b'1'),
(7257, 'sisesc', 7, 'addcompra', '2024-03-11 20:20:46', b'1'),
(7258, 'sisesc', 7, 'selproducto', '2024-03-11 20:20:47', b'1'),
(7259, 'sisesc', 7, 'getproducto', '2024-03-11 20:23:37', b'1'),
(7260, 'sisesc', 7, 'papcompra', '2024-03-11 20:24:25', b'1'),
(7261, 'sisesc', 7, 'selproveedor', '2024-03-11 20:24:30', b'1');
INSERT INTO `seg_tbllogusuario` (`idlogusuario`, `nombresistema`, `idusuario`, `nombreservicio`, `fecharegistro`, `estadoregistro`) VALUES
(7262, 'sisesc', 7, 'selcompra', '2024-03-11 20:24:40', b'1'),
(7263, 'sisesc', 7, 'selproveedor', '2024-03-11 20:24:50', b'1'),
(7264, 'sisesc', 7, 'getcompra', '2024-03-11 20:24:50', b'1'),
(7265, 'sisesc', 7, 'selcompradetalle', '2024-03-11 20:24:50', b'1'),
(7266, 'sisesc', 7, 'selproducto', '2024-03-11 20:24:51', b'1'),
(7267, 'sisesc', 7, 'getproveedor', '2024-03-11 20:24:51', b'1'),
(7268, 'sisesc', 7, 'getpersona', '2024-03-11 20:24:51', b'1'),
(7269, 'sisesc', 7, 'selcompra', '2024-03-11 20:24:58', b'1'),
(7270, 'sisesc', 7, 'selproveedor', '2024-03-11 20:25:31', b'1'),
(7271, 'sisesc', 7, 'getcompra', '2024-03-11 20:25:31', b'1'),
(7272, 'sisesc', 7, 'selcompradetalle', '2024-03-11 20:25:32', b'1'),
(7273, 'sisesc', 7, 'selproducto', '2024-03-11 20:25:32', b'1'),
(7274, 'sisesc', 7, 'getproveedor', '2024-03-11 20:25:32', b'1'),
(7275, 'sisesc', 7, 'getpersona', '2024-03-11 20:25:33', b'1'),
(7276, 'sisesc', 7, 'selcompra', '2024-03-11 20:26:06', b'1'),
(7277, 'sisesc', 7, 'selproveedor', '2024-03-11 20:26:20', b'1'),
(7278, 'sisesc', 7, 'getcompra', '2024-03-11 20:26:20', b'1'),
(7279, 'sisesc', 7, 'selcompradetalle', '2024-03-11 20:26:20', b'1'),
(7280, 'sisesc', 7, 'selproducto', '2024-03-11 20:26:21', b'1'),
(7281, 'sisesc', 7, 'getproveedor', '2024-03-11 20:26:21', b'1'),
(7282, 'sisesc', 7, 'getpersona', '2024-03-11 20:26:21', b'1'),
(7283, 'sisesc', 7, 'selcompra', '2024-03-11 20:40:58', b'1'),
(7284, 'sisesc', 7, 'selproveedor', '2024-03-11 20:41:10', b'1'),
(7285, 'sisesc', 7, 'getcompra', '2024-03-11 20:41:10', b'1'),
(7286, 'sisesc', 7, 'selcompradetalle', '2024-03-11 20:41:10', b'1'),
(7287, 'sisesc', 7, 'selproducto', '2024-03-11 20:41:10', b'1'),
(7288, 'sisesc', 7, 'getproveedor', '2024-03-11 20:41:10', b'1'),
(7289, 'sisesc', 7, 'getpersona', '2024-03-11 20:41:10', b'1'),
(7290, 'sisesc', 7, 'selparametro', '2024-03-11 20:42:16', b'1'),
(7291, 'sisesc', 7, 'selcompra', '2024-03-11 20:42:26', b'1'),
(7292, 'sisesc', 7, 'selcompra', '2024-03-11 20:42:32', b'1'),
(7293, 'sisesc', 7, 'selventa', '2024-03-11 20:42:43', b'1'),
(7294, 'sisesc', 7, 'selproductostock', '2024-03-11 20:42:49', b'1'),
(7295, 'sisesc', 7, 'selcompra', '2024-03-11 20:42:52', b'1'),
(7296, 'sisesc', 7, 'selproveedor', '2024-03-11 20:42:55', b'1'),
(7297, 'sisesc', 7, 'selcompra', '2024-03-11 20:42:58', b'1'),
(7298, 'sisesc', 7, 'selproveedor', '2024-03-11 20:43:04', b'1'),
(7299, 'sisesc', 7, 'getcompra', '2024-03-11 20:43:04', b'1'),
(7300, 'sisesc', 7, 'selcompradetalle', '2024-03-11 20:43:04', b'1'),
(7301, 'sisesc', 7, 'selproducto', '2024-03-11 20:43:04', b'1'),
(7302, 'sisesc', 7, 'getproveedor', '2024-03-11 20:43:04', b'1'),
(7303, 'sisesc', 7, 'getpersona', '2024-03-11 20:43:05', b'1'),
(7304, 'sisesc', 7, 'selventa', '2024-03-11 20:43:16', b'1'),
(7305, 'sisesc', 7, 'selcliente', '2024-03-11 20:43:29', b'1'),
(7306, 'sisesc', 7, 'getcliente', '2024-03-11 20:43:31', b'1'),
(7307, 'sisesc', 7, 'getpersona', '2024-03-11 20:43:32', b'1'),
(7308, 'sisesc', 7, 'addventa', '2024-03-11 20:43:32', b'1'),
(7309, 'sisesc', 7, 'selproducto', '2024-03-11 20:43:32', b'1'),
(7310, 'sisesc', 7, 'getproductostock', '2024-03-11 20:43:46', b'1'),
(7311, 'sisesc', 7, 'selcompra', '2024-03-11 20:44:29', b'1'),
(7312, 'sisesc', 7, 'selproveedor', '2024-03-11 20:44:33', b'1'),
(7313, 'sisesc', 7, 'selmarca', '2024-03-11 20:44:37', b'1'),
(7314, 'sisesc', 7, 'selproveedor', '2024-03-11 20:44:44', b'1'),
(7315, 'sisesc', 7, 'selcompra', '2024-03-11 20:44:50', b'1'),
(7316, 'sisesc', 7, 'selproveedor', '2024-03-11 20:45:08', b'1'),
(7317, 'sisesc', 7, 'getcompra', '2024-03-11 20:45:08', b'1'),
(7318, 'sisesc', 7, 'selcompradetalle', '2024-03-11 20:45:08', b'1'),
(7319, 'sisesc', 7, 'selproducto', '2024-03-11 20:45:09', b'1'),
(7320, 'sisesc', 7, 'getproveedor', '2024-03-11 20:45:09', b'1'),
(7321, 'sisesc', 7, 'getpersona', '2024-03-11 20:45:09', b'1'),
(7322, 'sisesc', 7, 'selcompra', '2024-03-11 20:45:21', b'1'),
(7323, 'sisesc', 7, 'selproducto', '2024-03-11 20:45:49', b'1'),
(7324, 'sisesc', 7, 'selparametrotipo', '2024-03-11 20:46:01', b'1'),
(7325, 'sisesc', 7, 'selplandecuenta', '2024-03-11 20:46:01', b'1'),
(7326, 'sisesc', 7, 'selcompra', '2024-03-11 20:46:18', b'1'),
(7327, 'sisesc', 7, 'selcliente', '2024-03-11 20:46:33', b'1'),
(7328, 'sisesc', 7, 'getcliente', '2024-03-11 20:46:39', b'1'),
(7329, 'sisesc', 7, 'getpersona', '2024-03-11 20:46:39', b'1'),
(7330, 'sisesc', 7, 'addventa', '2024-03-11 20:46:39', b'1'),
(7331, 'sisesc', 7, 'selproducto', '2024-03-11 20:46:39', b'1'),
(7332, 'sisesc', 7, 'getproductostock', '2024-03-11 20:46:41', b'1'),
(7333, 'sisesc', 7, 'papventa', '2024-03-11 20:47:08', b'1'),
(7334, 'sisesc', 7, 'selcliente', '2024-03-11 20:47:10', b'1'),
(7335, 'sisesc', 7, 'getventa', '2024-03-11 20:47:10', b'1'),
(7336, 'sisesc', 7, 'selventadetalle', '2024-03-11 20:47:10', b'1'),
(7337, 'sisesc', 7, 'selproductostock', '2024-03-11 20:47:10', b'1'),
(7338, 'sisesc', 7, 'getcliente', '2024-03-11 20:47:11', b'1'),
(7339, 'sisesc', 7, 'getpersona', '2024-03-11 20:47:11', b'1'),
(7340, 'sisesc', 7, 'selcompra', '2024-03-11 20:47:15', b'1'),
(7341, 'sisesc', 7, 'selcompra', '2024-03-11 20:47:19', b'1'),
(7342, 'sisesc', 7, 'selventa', '2024-03-11 20:47:34', b'1'),
(7343, 'sisesc', 7, 'selcliente', '2024-03-11 20:47:40', b'1'),
(7344, 'sisesc', 7, 'getventa', '2024-03-11 20:47:40', b'1'),
(7345, 'sisesc', 7, 'selventadetalle', '2024-03-11 20:47:40', b'1'),
(7346, 'sisesc', 7, 'selproductostock', '2024-03-11 20:47:40', b'1'),
(7347, 'sisesc', 7, 'getcliente', '2024-03-11 20:47:41', b'1'),
(7348, 'sisesc', 7, 'getpersona', '2024-03-11 20:47:41', b'1'),
(7349, 'sisesc', 7, 'getventa', '2024-03-11 20:47:44', b'1'),
(7350, 'sisesc', 7, 'selpagoventa', '2024-03-11 20:47:44', b'1'),
(7351, 'sisesc', 7, 'getcliente', '2024-03-11 20:47:44', b'1'),
(7352, 'sisesc', 7, 'getpersona', '2024-03-11 20:47:45', b'1'),
(7353, 'sisesc', 7, 'selcliente', '2024-03-11 20:47:53', b'1'),
(7354, 'sisesc', 7, 'getventa', '2024-03-11 20:47:53', b'1'),
(7355, 'sisesc', 7, 'selventadetalle', '2024-03-11 20:47:53', b'1'),
(7356, 'sisesc', 7, 'selproductostock', '2024-03-11 20:47:54', b'1'),
(7357, 'sisesc', 7, 'getcliente', '2024-03-11 20:47:54', b'1'),
(7358, 'sisesc', 7, 'getpersona', '2024-03-11 20:47:54', b'1'),
(7359, 'sisesc', 7, 'getventa', '2024-03-11 20:48:03', b'1'),
(7360, 'sisesc', 7, 'selventadetalle', '2024-03-11 20:48:04', b'1'),
(7361, 'sisesc', 7, 'getcliente', '2024-03-11 20:48:04', b'1'),
(7362, 'sisesc', 7, 'getpersona', '2024-03-11 20:48:04', b'1'),
(7363, 'sisesc', 7, 'selventa', '2024-03-11 20:48:24', b'1'),
(7364, 'sisesc', 7, 'selproductostock', '2024-03-11 20:48:27', b'1'),
(7365, 'sisesc', 7, 'selventa', '2024-03-11 20:48:32', b'1'),
(7366, 'sisesc', 7, 'selcliente', '2024-03-11 20:48:38', b'1'),
(7367, 'sisesc', 7, 'getventa', '2024-03-11 20:49:05', b'1'),
(7368, 'sisesc', 7, 'selventadetalle', '2024-03-11 20:49:06', b'1'),
(7369, 'sisesc', 7, 'getcliente', '2024-03-11 20:49:06', b'1'),
(7370, 'sisesc', 7, 'getpersona', '2024-03-11 20:49:06', b'1'),
(7371, 'sisesc', 3, 'seloficina', '2024-03-11 21:04:23', b'1'),
(7372, 'sisesc', 6, 'selusuario', '2024-03-11 21:13:25', b'1'),
(7373, 'sisesc', 6, 'getusuario', '2024-03-11 21:24:15', b'1'),
(7374, 'sisesc', 6, 'getpersona', '2024-03-11 21:24:15', b'1'),
(7375, 'sisesc', 6, 'selrolusuario', '2024-03-11 21:24:15', b'1'),
(7376, 'sisesc', 6, 'selusuario', '2024-03-11 21:36:22', b'1'),
(7377, 'sisesc', 6, 'getusuario', '2024-03-11 21:36:24', b'1'),
(7378, 'sisesc', 6, 'getpersona', '2024-03-11 21:36:25', b'1'),
(7379, 'sisesc', 6, 'selrolusuario', '2024-03-11 21:36:25', b'1'),
(7380, 'sisesc', 6, 'selusuario', '2024-03-11 21:36:41', b'1'),
(7381, 'sisesc', 6, 'getusuario', '2024-03-11 21:36:45', b'1'),
(7382, 'sisesc', 6, 'getpersona', '2024-03-11 21:36:46', b'1'),
(7383, 'sisesc', 6, 'selrolusuario', '2024-03-11 21:36:46', b'1'),
(7384, 'sisesc', 6, 'updusuario', '2024-03-11 21:37:35', b'1'),
(7385, 'sisesc', 6, 'updpersona', '2024-03-11 21:37:35', b'1'),
(7386, 'sisesc', 6, 'selusuario', '2024-03-11 21:37:38', b'1'),
(7387, 'sisesc', 6, 'getusuario', '2024-03-11 21:37:46', b'1'),
(7388, 'sisesc', 6, 'getpersona', '2024-03-11 21:37:47', b'1'),
(7389, 'sisesc', 6, 'selrolusuario', '2024-03-11 21:37:47', b'1'),
(7390, 'sisesc', 6, 'selusuario', '2024-03-11 21:37:56', b'1'),
(7391, 'sisesc', 6, 'getusuario', '2024-03-11 21:38:15', b'1'),
(7392, 'sisesc', 6, 'getpersona', '2024-03-11 21:38:16', b'1'),
(7393, 'sisesc', 6, 'selrolusuario', '2024-03-11 21:38:16', b'1'),
(7394, 'sisesc', 6, 'selusuario', '2024-03-11 21:38:37', b'1'),
(7395, 'sisesc', 6, 'getusuario', '2024-03-11 21:38:41', b'1'),
(7396, 'sisesc', 6, 'getpersona', '2024-03-11 21:38:41', b'1'),
(7397, 'sisesc', 6, 'selrolusuario', '2024-03-11 21:38:41', b'1'),
(7398, 'sisesc', 6, 'selusuario', '2024-03-11 21:38:48', b'1'),
(7399, 'sisesc', 6, 'getusuario', '2024-03-11 21:39:06', b'1'),
(7400, 'sisesc', 6, 'getpersona', '2024-03-11 21:39:06', b'1'),
(7401, 'sisesc', 6, 'selrolusuario', '2024-03-11 21:39:06', b'1'),
(7402, 'sisesc', 6, 'selusuario', '2024-03-11 21:40:27', b'1'),
(7403, 'sisesc', 6, 'selproveedor', '2024-03-11 21:43:30', b'1'),
(7404, 'sisesc', 6, 'getproveedor', '2024-03-11 21:43:55', b'1'),
(7405, 'sisesc', 6, 'getpersona', '2024-03-11 21:43:55', b'1'),
(7406, 'sisesc', 6, 'addcompra', '2024-03-11 21:43:55', b'1'),
(7407, 'sisesc', 6, 'selproducto', '2024-03-11 21:43:56', b'1'),
(7408, 'sisesc', 6, 'selusuario', '2024-03-11 21:44:05', b'1'),
(7409, 'sisesc', 6, 'selproveedor', '2024-03-11 21:44:08', b'1'),
(7410, 'sisesc', 6, 'getproveedor', '2024-03-11 21:50:46', b'1'),
(7411, 'sisesc', 6, 'selcompra', '2024-03-11 22:31:24', b'1'),
(7412, 'sisesc', 6, 'selproveedor', '2024-03-11 22:31:28', b'1'),
(7413, 'sisesc', 6, 'getcompra', '2024-03-11 22:31:28', b'1'),
(7414, 'sisesc', 6, 'selcompradetalle', '2024-03-11 22:31:28', b'1'),
(7415, 'sisesc', 6, 'selproducto', '2024-03-11 22:31:28', b'1'),
(7416, 'sisesc', 6, 'getproveedor', '2024-03-11 22:31:28', b'1'),
(7417, 'sisesc', 6, 'getpersona', '2024-03-11 22:31:29', b'1'),
(7418, 'sisesc', 6, 'selusuario', '2024-03-11 22:38:38', b'1'),
(7419, 'sisesc', 6, 'selproveedor', '2024-03-11 22:38:42', b'1'),
(7420, 'sisesc', 6, 'getproveedor', '2024-03-11 22:38:51', b'1'),
(7421, 'sisesc', 6, 'getpersona', '2024-03-11 22:38:51', b'1'),
(7422, 'sisesc', 6, 'addcompra', '2024-03-11 22:38:51', b'1'),
(7423, 'sisesc', 6, 'selproducto', '2024-03-11 22:38:52', b'1'),
(7424, 'sisesc', 6, 'getproducto', '2024-03-11 22:55:11', b'1'),
(7425, 'sisesc', 6, 'selusuario', '2024-03-11 23:07:29', b'1'),
(7426, 'sisesc', 6, 'getusuario', '2024-03-11 23:07:32', b'1'),
(7427, 'sisesc', 6, 'getpersona', '2024-03-11 23:07:32', b'1'),
(7428, 'sisesc', 6, 'selrolusuario', '2024-03-11 23:07:33', b'1'),
(7429, 'sisesc', 6, 'seloficina', '2024-03-12 13:04:51', b'1'),
(7430, 'sisesc', 6, 'seloficina', '2024-03-12 13:05:03', b'1'),
(7431, 'sisesc', 6, 'selusuario', '2024-03-12 13:05:08', b'1'),
(7432, 'sisesc', 6, 'selproducto', '2024-03-12 13:05:48', b'1'),
(7433, 'sisesc', 6, 'getproducto', '2024-03-12 13:08:49', b'1'),
(7434, 'sisesc', 6, 'selmarca', '2024-03-12 13:08:50', b'1'),
(7435, 'sisesc', 6, 'selclasificacionproducto', '2024-03-12 13:08:50', b'1'),
(7436, 'sisesc', 6, 'selproducto', '2024-03-12 13:08:53', b'1'),
(7437, 'sisesc', 6, 'selproveedor', '2024-03-12 13:30:44', b'1'),
(7438, 'sisesc', 6, 'selcompra', '2024-03-12 13:30:59', b'1'),
(7439, 'sisesc', 6, 'selproveedor', '2024-03-12 13:31:16', b'1'),
(7440, 'sisesc', 6, 'getcompra', '2024-03-12 13:31:16', b'1'),
(7441, 'sisesc', 6, 'selcompradetalle', '2024-03-12 13:31:16', b'1'),
(7442, 'sisesc', 6, 'selproducto', '2024-03-12 13:31:16', b'1'),
(7443, 'sisesc', 6, 'getproveedor', '2024-03-12 13:31:16', b'1'),
(7444, 'sisesc', 6, 'getpersona', '2024-03-12 13:31:17', b'1'),
(7445, 'sisesc', 6, 'selcompra', '2024-03-12 13:31:37', b'1'),
(7446, 'sisesc', 6, 'selproveedor', '2024-03-12 13:31:43', b'1'),
(7447, 'sisesc', 6, 'getcompra', '2024-03-12 13:31:43', b'1'),
(7448, 'sisesc', 6, 'selcompradetalle', '2024-03-12 13:31:44', b'1'),
(7449, 'sisesc', 6, 'selproducto', '2024-03-12 13:31:44', b'1'),
(7450, 'sisesc', 6, 'getproveedor', '2024-03-12 13:31:44', b'1'),
(7451, 'sisesc', 6, 'getpersona', '2024-03-12 13:31:44', b'1'),
(7452, 'sisesc', 6, 'selcompra', '2024-03-12 13:31:54', b'1'),
(7453, 'sisesc', 6, 'selproveedor', '2024-03-12 13:35:16', b'1'),
(7454, 'sisesc', 6, 'getproveedor', '2024-03-12 13:35:46', b'1'),
(7455, 'sisesc', 6, 'getpersona', '2024-03-12 13:35:46', b'1'),
(7456, 'sisesc', 6, 'addcompra', '2024-03-12 13:35:46', b'1'),
(7457, 'sisesc', 6, 'selproducto', '2024-03-12 13:35:47', b'1'),
(7458, 'sisesc', 6, 'getproducto', '2024-03-12 13:54:16', b'1'),
(7459, 'sisesc', 6, 'addcompradetalle', '2024-03-12 13:54:27', b'1'),
(7460, 'sisesc', 6, 'selcompradetalle', '2024-03-12 13:54:27', b'1'),
(7461, 'sisesc', 6, 'papcompradetalle', '2024-03-12 13:54:42', b'1'),
(7462, 'sisesc', 6, 'selcompradetalle', '2024-03-12 13:54:42', b'1'),
(7463, 'sisesc', 6, 'getproducto', '2024-03-12 13:54:46', b'1'),
(7464, 'sisesc', 6, 'addcompradetalle', '2024-03-12 13:55:03', b'1'),
(7465, 'sisesc', 6, 'selcompradetalle', '2024-03-12 13:55:03', b'1'),
(7466, 'sisesc', 6, 'papcompradetalle', '2024-03-12 13:55:11', b'1'),
(7467, 'sisesc', 6, 'selcompradetalle', '2024-03-12 13:55:11', b'1'),
(7468, 'sisesc', 6, 'getproducto', '2024-03-12 13:55:18', b'1'),
(7469, 'sisesc', 6, 'addcompradetalle', '2024-03-12 14:02:28', b'1'),
(7470, 'sisesc', 6, 'selcompradetalle', '2024-03-12 14:02:28', b'1'),
(7471, 'sisesc', 6, 'papcompra', '2024-03-12 14:32:25', b'1'),
(7472, 'sisesc', 6, 'selproveedor', '2024-03-12 14:32:27', b'1'),
(7473, 'sisesc', 6, 'getcompra', '2024-03-12 14:32:27', b'1'),
(7474, 'sisesc', 6, 'selcompradetalle', '2024-03-12 14:32:27', b'1'),
(7475, 'sisesc', 6, 'selproducto', '2024-03-12 14:32:27', b'1'),
(7476, 'sisesc', 6, 'getproveedor', '2024-03-12 14:32:28', b'1'),
(7477, 'sisesc', 6, 'getpersona', '2024-03-12 14:32:28', b'1'),
(7478, 'sisesc', 6, 'getcompra', '2024-03-12 14:32:33', b'1'),
(7479, 'sisesc', 6, 'selpagocompra', '2024-03-12 14:32:33', b'1'),
(7480, 'sisesc', 6, 'getproveedor', '2024-03-12 14:32:33', b'1'),
(7481, 'sisesc', 6, 'getpersona', '2024-03-12 14:32:33', b'1'),
(7482, 'sisesc', 6, 'getcompra', '2024-03-12 14:32:34', b'1'),
(7483, 'sisesc', 6, 'getcompra', '2024-03-12 18:48:01', b'1'),
(7484, 'sisesc', 6, 'selpagocompra', '2024-03-12 18:48:02', b'1'),
(7485, 'sisesc', 6, 'getproveedor', '2024-03-12 18:48:02', b'1'),
(7486, 'sisesc', 6, 'getpersona', '2024-03-12 18:48:03', b'1'),
(7487, 'sisesc', 6, 'getcompra', '2024-03-12 18:48:03', b'1'),
(7488, 'sisesc', 1, 'seloficina', '2024-03-12 21:32:39', b'1'),
(7489, 'sisesc', 1, 'seloficina', '2024-03-12 21:32:43', b'1'),
(7490, 'sisesc', 1, 'selproveedor', '2024-03-12 21:32:48', b'1'),
(7491, 'sisesc', 1, 'getproveedor', '2024-03-12 21:32:56', b'1'),
(7492, 'sisesc', 1, 'getpersona', '2024-03-12 21:32:56', b'1'),
(7493, 'sisesc', 1, 'addcompra', '2024-03-12 21:32:56', b'1'),
(7494, 'sisesc', 1, 'selproducto', '2024-03-12 21:32:57', b'1'),
(7495, 'sisesc', 1, 'getproducto', '2024-03-12 21:33:06', b'1'),
(7496, 'sisesc', 1, 'addcompradetalle', '2024-03-12 21:33:12', b'1'),
(7497, 'sisesc', 1, 'selcompradetalle', '2024-03-12 21:33:12', b'1'),
(7498, 'sisesc', 1, 'papcompra', '2024-03-12 21:33:25', b'1'),
(7499, 'sisesc', 1, 'selproveedor', '2024-03-12 21:33:26', b'1'),
(7500, 'sisesc', 1, 'getcompra', '2024-03-12 21:33:26', b'1'),
(7501, 'sisesc', 1, 'selcompradetalle', '2024-03-12 21:33:26', b'1'),
(7502, 'sisesc', 1, 'selproducto', '2024-03-12 21:33:27', b'1'),
(7503, 'sisesc', 1, 'getproveedor', '2024-03-12 21:33:27', b'1'),
(7504, 'sisesc', 1, 'getpersona', '2024-03-12 21:33:27', b'1'),
(7505, 'sisesc', 1, 'getcompra', '2024-03-12 21:33:28', b'1'),
(7506, 'sisesc', 1, 'selpagocompra', '2024-03-12 21:33:29', b'1'),
(7507, 'sisesc', 1, 'getproveedor', '2024-03-12 21:33:29', b'1'),
(7508, 'sisesc', 1, 'getpersona', '2024-03-12 21:33:29', b'1'),
(7509, 'sisesc', 1, 'getcompra', '2024-03-12 21:33:30', b'1'),
(7510, 'sisesc', 1, 'getpagocompra', '2024-03-12 21:33:32', b'1'),
(7511, 'sisesc', 1, 'getcompra', '2024-03-12 21:33:32', b'1'),
(7512, 'sisesc', 1, 'getproveedor', '2024-03-12 21:33:32', b'1'),
(7513, 'sisesc', 1, 'getpersona', '2024-03-12 21:33:33', b'1'),
(7514, 'sisesc', 1, 'selusuario', '2024-03-12 21:33:51', b'1'),
(7515, 'sisesc', 1, 'selusuario', '2024-03-12 21:34:02', b'1'),
(7516, 'sisesc', 2, 'seloficina', '2024-03-12 21:34:22', b'1'),
(7517, 'sisesc', 2, 'seloficina', '2024-03-12 21:34:29', b'1'),
(7518, 'sisesc', 2, 'selcompra', '2024-03-12 21:34:42', b'1'),
(7519, 'sisesc', 1, 'selusuario', '2024-03-12 21:36:57', b'1'),
(7520, 'sisesc', 1, 'selcompra', '2024-03-12 21:37:01', b'1'),
(7521, 'sisesc', 1, 'selproveedor', '2024-03-12 21:38:49', b'1'),
(7522, 'sisesc', 1, 'getcompra', '2024-03-12 21:38:49', b'1'),
(7523, 'sisesc', 1, 'selcompradetalle', '2024-03-12 21:38:49', b'1'),
(7524, 'sisesc', 1, 'selproducto', '2024-03-12 21:38:49', b'1'),
(7525, 'sisesc', 1, 'getproveedor', '2024-03-12 21:38:49', b'1'),
(7526, 'sisesc', 1, 'getpersona', '2024-03-12 21:38:50', b'1'),
(7527, 'sisesc', 1, 'getcompra', '2024-03-12 21:38:51', b'1'),
(7528, 'sisesc', 1, 'selpagocompra', '2024-03-12 21:38:52', b'1'),
(7529, 'sisesc', 1, 'getproveedor', '2024-03-12 21:38:52', b'1'),
(7530, 'sisesc', 1, 'getpersona', '2024-03-12 21:38:52', b'1'),
(7531, 'sisesc', 1, 'getcompra', '2024-03-12 21:38:52', b'1'),
(7532, 'sisesc', 1, 'pappagocompra', '2024-03-12 21:39:12', b'1'),
(7533, 'sisesc', 1, 'selpagocompra', '2024-03-12 21:39:12', b'1'),
(7534, 'sisesc', 1, 'getcompra', '2024-03-12 21:39:13', b'1'),
(7535, 'sisesc', 1, 'getpagocompra', '2024-03-12 21:39:16', b'1'),
(7536, 'sisesc', 1, 'getcompra', '2024-03-12 21:39:16', b'1'),
(7537, 'sisesc', 1, 'getproveedor', '2024-03-12 21:39:17', b'1'),
(7538, 'sisesc', 1, 'getpersona', '2024-03-12 21:39:17', b'1'),
(7539, 'sisesc', 1, 'pappagocompra', '2024-03-12 21:40:35', b'1'),
(7540, 'sisesc', 1, 'selpagocompra', '2024-03-12 21:40:35', b'1'),
(7541, 'sisesc', 1, 'getcompra', '2024-03-12 21:40:35', b'1'),
(7542, 'sisesc', 1, 'getpagocompra', '2024-03-12 21:41:38', b'1'),
(7543, 'sisesc', 1, 'getcompra', '2024-03-12 21:41:38', b'1'),
(7544, 'sisesc', 1, 'getproveedor', '2024-03-12 21:41:39', b'1'),
(7545, 'sisesc', 1, 'getpersona', '2024-03-12 21:41:39', b'1'),
(7546, 'sisesc', 1, 'seloficina', '2024-03-12 21:46:31', b'1'),
(7547, 'sisesc', 1, 'seloficina', '2024-03-12 21:46:33', b'1'),
(7548, 'sisesc', 1, 'selusuario', '2024-03-12 21:46:37', b'1'),
(7549, 'sisesc', 1, 'seloficina', '2024-03-12 21:48:23', b'1'),
(7550, 'sisesc', 1, 'selproducto', '2024-03-12 21:48:26', b'1'),
(7551, 'sisesc', 1, 'selcompra', '2024-03-12 21:49:40', b'1'),
(7552, 'sisesc', 1, 'selproductostock', '2024-03-13 01:40:14', b'1'),
(7553, 'sisesc', 6, 'seloficina', '2024-03-15 20:17:58', b'1'),
(7554, 'sisesc', 6, 'seloficina', '2024-03-15 20:18:05', b'1'),
(7555, 'sisesc', 6, 'selproveedor', '2024-03-15 20:18:15', b'1'),
(7556, 'sisesc', 6, 'selproveedor', '2024-03-15 20:21:04', b'1'),
(7557, 'sisesc', 6, 'selcompra', '2024-03-15 20:21:17', b'1'),
(7558, 'sisesc', 6, 'selproveedor', '2024-03-15 20:21:33', b'1'),
(7559, 'sisesc', 6, 'getcompra', '2024-03-15 20:21:33', b'1'),
(7560, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:21:33', b'1'),
(7561, 'sisesc', 6, 'selproducto', '2024-03-15 20:21:33', b'1'),
(7562, 'sisesc', 6, 'getproveedor', '2024-03-15 20:21:33', b'1'),
(7563, 'sisesc', 6, 'getpersona', '2024-03-15 20:21:34', b'1'),
(7564, 'sisesc', 6, 'papcompra', '2024-03-15 20:21:39', b'1'),
(7565, 'sisesc', 6, 'selproveedor', '2024-03-15 20:21:40', b'1'),
(7566, 'sisesc', 6, 'getcompra', '2024-03-15 20:21:40', b'1'),
(7567, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:21:41', b'1'),
(7568, 'sisesc', 6, 'selproducto', '2024-03-15 20:21:41', b'1'),
(7569, 'sisesc', 6, 'getproveedor', '2024-03-15 20:21:41', b'1'),
(7570, 'sisesc', 6, 'getpersona', '2024-03-15 20:21:41', b'1'),
(7571, 'sisesc', 6, 'getcompra', '2024-03-15 20:21:47', b'1'),
(7572, 'sisesc', 6, 'selpagocompra', '2024-03-15 20:21:47', b'1'),
(7573, 'sisesc', 6, 'getproveedor', '2024-03-15 20:21:48', b'1'),
(7574, 'sisesc', 6, 'getpersona', '2024-03-15 20:21:48', b'1'),
(7575, 'sisesc', 6, 'getcompra', '2024-03-15 20:21:48', b'1'),
(7576, 'sisesc', 6, 'selproveedor', '2024-03-15 20:21:53', b'1'),
(7577, 'sisesc', 6, 'getcompra', '2024-03-15 20:21:53', b'1'),
(7578, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:21:53', b'1'),
(7579, 'sisesc', 6, 'selproducto', '2024-03-15 20:21:53', b'1'),
(7580, 'sisesc', 6, 'getproveedor', '2024-03-15 20:21:53', b'1'),
(7581, 'sisesc', 6, 'getpersona', '2024-03-15 20:21:54', b'1'),
(7582, 'sisesc', 6, 'selcompra', '2024-03-15 20:25:23', b'1'),
(7583, 'sisesc', 6, 'selproveedor', '2024-03-15 20:26:49', b'1'),
(7584, 'sisesc', 6, 'getcompra', '2024-03-15 20:26:49', b'1'),
(7585, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:26:49', b'1'),
(7586, 'sisesc', 6, 'selproducto', '2024-03-15 20:26:50', b'1'),
(7587, 'sisesc', 6, 'getproveedor', '2024-03-15 20:26:50', b'1'),
(7588, 'sisesc', 6, 'getpersona', '2024-03-15 20:26:50', b'1'),
(7589, 'sisesc', 6, 'selcompra', '2024-03-15 20:27:10', b'1'),
(7590, 'sisesc', 6, 'selproveedor', '2024-03-15 20:28:16', b'1'),
(7591, 'sisesc', 6, 'getcompra', '2024-03-15 20:28:16', b'1'),
(7592, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:28:16', b'1'),
(7593, 'sisesc', 6, 'selproducto', '2024-03-15 20:28:16', b'1'),
(7594, 'sisesc', 6, 'getproveedor', '2024-03-15 20:28:16', b'1'),
(7595, 'sisesc', 6, 'getpersona', '2024-03-15 20:28:17', b'1'),
(7596, 'sisesc', 6, 'selcompra', '2024-03-15 20:32:14', b'1'),
(7597, 'sisesc', 6, 'selproveedor', '2024-03-15 20:33:57', b'1'),
(7598, 'sisesc', 6, 'getcompra', '2024-03-15 20:33:57', b'1'),
(7599, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:33:57', b'1'),
(7600, 'sisesc', 6, 'selproducto', '2024-03-15 20:33:57', b'1'),
(7601, 'sisesc', 6, 'getproveedor', '2024-03-15 20:33:58', b'1'),
(7602, 'sisesc', 6, 'getpersona', '2024-03-15 20:33:58', b'1'),
(7603, 'sisesc', 6, 'selcompra', '2024-03-15 20:34:23', b'1'),
(7604, 'sisesc', 6, 'selproveedor', '2024-03-15 20:34:25', b'1'),
(7605, 'sisesc', 6, 'getcompra', '2024-03-15 20:34:25', b'1'),
(7606, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:34:25', b'1'),
(7607, 'sisesc', 6, 'selproducto', '2024-03-15 20:34:25', b'1'),
(7608, 'sisesc', 6, 'getproveedor', '2024-03-15 20:34:25', b'1'),
(7609, 'sisesc', 6, 'getpersona', '2024-03-15 20:34:25', b'1'),
(7610, 'sisesc', 6, 'getcompra', '2024-03-15 20:34:32', b'1'),
(7611, 'sisesc', 6, 'selpagocompra', '2024-03-15 20:34:32', b'1'),
(7612, 'sisesc', 6, 'getproveedor', '2024-03-15 20:34:32', b'1'),
(7613, 'sisesc', 6, 'getpersona', '2024-03-15 20:34:32', b'1'),
(7614, 'sisesc', 6, 'getcompra', '2024-03-15 20:34:33', b'1'),
(7615, 'sisesc', 6, 'selproveedor', '2024-03-15 20:35:56', b'1'),
(7616, 'sisesc', 6, 'getcompra', '2024-03-15 20:35:56', b'1'),
(7617, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:35:56', b'1'),
(7618, 'sisesc', 6, 'selproducto', '2024-03-15 20:35:56', b'1'),
(7619, 'sisesc', 6, 'getproveedor', '2024-03-15 20:35:57', b'1'),
(7620, 'sisesc', 6, 'getpersona', '2024-03-15 20:35:57', b'1'),
(7621, 'sisesc', 6, 'selcompra', '2024-03-15 20:36:01', b'1'),
(7622, 'sisesc', 6, 'selproveedor', '2024-03-15 20:36:07', b'1'),
(7623, 'sisesc', 6, 'getcompra', '2024-03-15 20:36:07', b'1'),
(7624, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:36:07', b'1'),
(7625, 'sisesc', 6, 'selproducto', '2024-03-15 20:36:07', b'1'),
(7626, 'sisesc', 6, 'getproveedor', '2024-03-15 20:36:08', b'1'),
(7627, 'sisesc', 6, 'getpersona', '2024-03-15 20:36:08', b'1'),
(7628, 'sisesc', 6, 'papcompra', '2024-03-15 20:36:12', b'1'),
(7629, 'sisesc', 6, 'selproveedor', '2024-03-15 20:36:14', b'1'),
(7630, 'sisesc', 6, 'getcompra', '2024-03-15 20:36:14', b'1'),
(7631, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:36:14', b'1'),
(7632, 'sisesc', 6, 'selproducto', '2024-03-15 20:36:14', b'1'),
(7633, 'sisesc', 6, 'getproveedor', '2024-03-15 20:36:15', b'1'),
(7634, 'sisesc', 6, 'getpersona', '2024-03-15 20:36:15', b'1'),
(7635, 'sisesc', 6, 'getcompra', '2024-03-15 20:36:42', b'1'),
(7636, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:36:43', b'1'),
(7637, 'sisesc', 6, 'getproveedor', '2024-03-15 20:36:43', b'1'),
(7638, 'sisesc', 6, 'getpersona', '2024-03-15 20:36:43', b'1'),
(7639, 'sisesc', 6, 'selcompra', '2024-03-15 20:38:09', b'1'),
(7640, 'sisesc', 6, 'selproveedor', '2024-03-15 20:38:17', b'1'),
(7641, 'sisesc', 6, 'getcompra', '2024-03-15 20:38:17', b'1'),
(7642, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:38:17', b'1'),
(7643, 'sisesc', 6, 'selproducto', '2024-03-15 20:38:17', b'1'),
(7644, 'sisesc', 6, 'getproveedor', '2024-03-15 20:38:17', b'1'),
(7645, 'sisesc', 6, 'getpersona', '2024-03-15 20:38:18', b'1'),
(7646, 'sisesc', 6, 'selcompra', '2024-03-15 20:38:23', b'1'),
(7647, 'sisesc', 6, 'selproveedor', '2024-03-15 20:38:27', b'1'),
(7648, 'sisesc', 6, 'getcompra', '2024-03-15 20:38:27', b'1'),
(7649, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:38:27', b'1'),
(7650, 'sisesc', 6, 'selproducto', '2024-03-15 20:38:27', b'1'),
(7651, 'sisesc', 6, 'getproveedor', '2024-03-15 20:38:28', b'1'),
(7652, 'sisesc', 6, 'getpersona', '2024-03-15 20:38:28', b'1'),
(7653, 'sisesc', 6, 'getproducto', '2024-03-15 20:56:01', b'1'),
(7654, 'sisesc', 6, 'addcompradetalle', '2024-03-15 20:56:11', b'1'),
(7655, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:56:12', b'1'),
(7656, 'sisesc', 6, 'papcompra', '2024-03-15 20:56:46', b'1'),
(7657, 'sisesc', 6, 'selproveedor', '2024-03-15 20:56:47', b'1'),
(7658, 'sisesc', 6, 'getcompra', '2024-03-15 20:56:47', b'1'),
(7659, 'sisesc', 6, 'selcompradetalle', '2024-03-15 20:56:47', b'1'),
(7660, 'sisesc', 6, 'selproducto', '2024-03-15 20:56:47', b'1'),
(7661, 'sisesc', 6, 'getproveedor', '2024-03-15 20:56:48', b'1'),
(7662, 'sisesc', 6, 'getpersona', '2024-03-15 20:56:48', b'1'),
(7663, 'sisesc', 6, 'selcompra', '2024-03-15 21:02:24', b'1'),
(7664, 'sisesc', 6, 'selproveedor', '2024-03-15 21:02:28', b'1'),
(7665, 'sisesc', 6, 'getcompra', '2024-03-15 21:02:28', b'1'),
(7666, 'sisesc', 6, 'selcompradetalle', '2024-03-15 21:02:29', b'1'),
(7667, 'sisesc', 6, 'selproducto', '2024-03-15 21:02:29', b'1'),
(7668, 'sisesc', 6, 'getproveedor', '2024-03-15 21:02:29', b'1'),
(7669, 'sisesc', 6, 'getpersona', '2024-03-15 21:02:29', b'1'),
(7670, 'sisesc', 6, 'selcompra', '2024-03-15 21:02:31', b'1'),
(7671, 'sisesc', 6, 'selcompra', '2024-03-15 21:36:33', b'1'),
(7672, 'sisesc', 6, 'selusuario', '2024-03-15 21:52:13', b'1'),
(7673, 'sisesc', 6, 'selproveedor', '2024-03-15 21:52:20', b'1'),
(7674, 'sisesc', 6, 'getproveedor', '2024-03-15 21:52:31', b'1'),
(7675, 'sisesc', 6, 'getpersona', '2024-03-15 21:52:31', b'1'),
(7676, 'sisesc', 6, 'selmarca', '2024-03-15 21:52:31', b'1'),
(7677, 'sisesc', 6, 'updpersona', '2024-03-15 21:53:19', b'1'),
(7678, 'sisesc', 6, 'updproveedor', '2024-03-15 21:53:19', b'1'),
(7679, 'sisesc', 6, 'selproveedor', '2024-03-15 21:53:19', b'1'),
(7680, 'sisesc', 6, 'getproveedor', '2024-03-15 21:53:27', b'1'),
(7681, 'sisesc', 6, 'getpersona', '2024-03-15 21:53:27', b'1'),
(7682, 'sisesc', 6, 'selmarca', '2024-03-15 21:53:27', b'1'),
(7683, 'sisesc', 6, 'updpersona', '2024-03-15 21:53:38', b'1'),
(7684, 'sisesc', 6, 'updproveedor', '2024-03-15 21:53:38', b'1'),
(7685, 'sisesc', 6, 'selproveedor', '2024-03-15 21:53:38', b'1'),
(7686, 'sisesc', 6, 'selcompra', '2024-03-15 21:54:31', b'1'),
(7687, 'sisesc', 6, 'selcliente', '2024-03-15 21:54:54', b'1'),
(7688, 'sisesc', 6, 'getcliente', '2024-03-15 21:54:59', b'1'),
(7689, 'sisesc', 6, 'getpersona', '2024-03-15 21:54:59', b'1'),
(7690, 'sisesc', 6, 'addventa', '2024-03-15 21:54:59', b'1'),
(7691, 'sisesc', 6, 'selproducto', '2024-03-15 21:55:00', b'1'),
(7692, 'sisesc', 6, 'getproductostock', '2024-03-15 21:55:05', b'1'),
(7693, 'sisesc', 6, 'selcompra', '2024-03-15 21:55:50', b'1'),
(7694, 'sisesc', 6, 'selproveedor', '2024-03-15 22:48:27', b'1'),
(7695, 'sisesc', 6, 'selproveedor', '2024-03-15 22:53:09', b'1'),
(7696, 'sisesc', 6, 'getcompra', '2024-03-15 22:53:09', b'1'),
(7697, 'sisesc', 6, 'selcompradetalle', '2024-03-15 22:53:09', b'1'),
(7698, 'sisesc', 6, 'selproducto', '2024-03-15 22:53:09', b'1'),
(7699, 'sisesc', 6, 'getproveedor', '2024-03-15 22:53:10', b'1'),
(7700, 'sisesc', 6, 'getpersona', '2024-03-15 22:53:10', b'1'),
(7701, 'sisesc', 6, 'getcompra', '2024-03-15 22:53:19', b'1'),
(7702, 'sisesc', 6, 'selcompradetalle', '2024-03-15 22:53:20', b'1'),
(7703, 'sisesc', 6, 'getproveedor', '2024-03-15 22:53:20', b'1'),
(7704, 'sisesc', 6, 'getpersona', '2024-03-15 22:53:20', b'1'),
(7705, 'sisesc', 2, 'seloficina', '2024-03-15 22:56:29', b'1'),
(7706, 'sisesc', 6, 'selproveedor', '2024-03-15 22:58:37', b'1'),
(7707, 'sisesc', 6, 'selmarca', '2024-03-15 22:58:48', b'1'),
(7708, 'sisesc', 6, 'selproveedor', '2024-03-15 22:58:53', b'1'),
(7709, 'sisesc', 6, 'getproveedor', '2024-03-15 22:58:56', b'1'),
(7710, 'sisesc', 6, 'getpersona', '2024-03-15 22:58:56', b'1'),
(7711, 'sisesc', 6, 'selmarca', '2024-03-15 22:58:56', b'1'),
(7712, 'sisesc', 6, 'updpersona', '2024-03-15 22:59:34', b'1'),
(7713, 'sisesc', 6, 'updproveedor', '2024-03-15 22:59:35', b'1'),
(7714, 'sisesc', 6, 'selproveedor', '2024-03-15 22:59:35', b'1'),
(7715, 'sisesc', 6, 'getproveedor', '2024-03-15 22:59:43', b'1'),
(7716, 'sisesc', 6, 'getpersona', '2024-03-15 22:59:43', b'1'),
(7717, 'sisesc', 6, 'selmarca', '2024-03-15 22:59:43', b'1'),
(7718, 'sisesc', 6, 'updpersona', '2024-03-15 22:59:49', b'1'),
(7719, 'sisesc', 6, 'updproveedor', '2024-03-15 22:59:49', b'1'),
(7720, 'sisesc', 6, 'selproveedor', '2024-03-15 22:59:50', b'1'),
(7721, 'sisesc', 6, 'getproveedor', '2024-03-15 23:00:00', b'1'),
(7722, 'sisesc', 6, 'getpersona', '2024-03-15 23:00:00', b'1'),
(7723, 'sisesc', 6, 'selmarca', '2024-03-15 23:00:01', b'1'),
(7724, 'sisesc', 6, 'updpersona', '2024-03-15 23:00:04', b'1'),
(7725, 'sisesc', 6, 'updproveedor', '2024-03-15 23:00:04', b'1'),
(7726, 'sisesc', 6, 'selproveedor', '2024-03-15 23:00:04', b'1'),
(7727, 'sisesc', 6, 'getproveedor', '2024-03-15 23:00:08', b'1'),
(7728, 'sisesc', 6, 'getpersona', '2024-03-15 23:00:09', b'1'),
(7729, 'sisesc', 6, 'selmarca', '2024-03-15 23:00:09', b'1'),
(7730, 'sisesc', 6, 'updpersona', '2024-03-15 23:00:13', b'1'),
(7731, 'sisesc', 6, 'updproveedor', '2024-03-15 23:00:13', b'1'),
(7732, 'sisesc', 6, 'selproveedor', '2024-03-15 23:00:13', b'1'),
(7733, 'sisesc', 6, 'getproveedor', '2024-03-15 23:00:18', b'1'),
(7734, 'sisesc', 6, 'getpersona', '2024-03-15 23:00:18', b'1'),
(7735, 'sisesc', 6, 'selmarca', '2024-03-15 23:00:18', b'1'),
(7736, 'sisesc', 2, 'seloficina', '2024-03-15 23:00:19', b'1'),
(7737, 'sisesc', 6, 'updpersona', '2024-03-15 23:00:22', b'1'),
(7738, 'sisesc', 6, 'updproveedor', '2024-03-15 23:00:22', b'1'),
(7739, 'sisesc', 6, 'selproveedor', '2024-03-15 23:00:22', b'1'),
(7740, 'sisesc', 6, 'getproveedor', '2024-03-15 23:00:32', b'1'),
(7741, 'sisesc', 6, 'getpersona', '2024-03-15 23:00:33', b'1'),
(7742, 'sisesc', 6, 'selmarca', '2024-03-15 23:00:33', b'1'),
(7743, 'sisesc', 6, 'updpersona', '2024-03-15 23:00:37', b'1'),
(7744, 'sisesc', 6, 'updproveedor', '2024-03-15 23:00:38', b'1'),
(7745, 'sisesc', 6, 'selproveedor', '2024-03-15 23:00:38', b'1'),
(7746, 'sisesc', 2, 'selusuario', '2024-03-15 23:01:14', b'1'),
(7747, 'sisesc', 2, 'addpersona', '2024-03-15 23:03:35', b'1'),
(7748, 'sisesc', 2, 'addusuario', '2024-03-15 23:03:35', b'1'),
(7749, 'sisesc', 2, 'selusuario', '2024-03-15 23:03:36', b'1'),
(7750, 'sisesc', 2, 'selusuario', '2024-03-15 23:04:21', b'1'),
(7751, 'sisesc', 2, 'getusuario', '2024-03-15 23:04:26', b'1'),
(7752, 'sisesc', 2, 'getpersona', '2024-03-15 23:04:27', b'1'),
(7753, 'sisesc', 2, 'selrolusuario', '2024-03-15 23:04:27', b'1'),
(7754, 'sisesc', 2, 'selproducto', '2024-03-15 23:19:56', b'1'),
(7755, 'sisesc', 2, 'getproducto', '2024-03-15 23:20:09', b'1'),
(7756, 'sisesc', 2, 'selmarca', '2024-03-15 23:20:09', b'1'),
(7757, 'sisesc', 2, 'selclasificacionproducto', '2024-03-15 23:20:09', b'1'),
(7758, 'sisesc', 2, 'selproducto', '2024-03-15 23:20:42', b'1'),
(7759, 'sisesc', 2, 'updproducto', '2024-03-15 23:20:42', b'1'),
(7760, 'sisesc', 2, 'getproducto', '2024-03-15 23:21:05', b'1'),
(7761, 'sisesc', 2, 'selmarca', '2024-03-15 23:21:05', b'1'),
(7762, 'sisesc', 2, 'selclasificacionproducto', '2024-03-15 23:21:05', b'1'),
(7763, 'sisesc', 2, 'selproducto', '2024-03-15 23:21:23', b'1'),
(7764, 'sisesc', 2, 'selmarca', '2024-03-15 23:21:25', b'1'),
(7765, 'sisesc', 2, 'selclasificacionproducto', '2024-03-15 23:21:25', b'1'),
(7766, 'sisesc', 2, 'selproducto', '2024-03-15 23:21:50', b'1'),
(7767, 'sisesc', 2, 'getproducto', '2024-03-15 23:22:02', b'1'),
(7768, 'sisesc', 2, 'selmarca', '2024-03-15 23:22:03', b'1'),
(7769, 'sisesc', 2, 'selclasificacionproducto', '2024-03-15 23:22:03', b'1'),
(7770, 'sisesc', 2, 'selproducto', '2024-03-15 23:22:10', b'1'),
(7771, 'sisesc', 2, 'selmarca', '2024-03-15 23:22:16', b'1'),
(7772, 'sisesc', 2, 'selclasificacionproducto', '2024-03-15 23:22:16', b'1'),
(7773, 'sisesc', 2, 'selproducto', '2024-03-15 23:24:05', b'1'),
(7774, 'sisesc', 6, 'selmarca', '2024-03-15 23:32:02', b'1'),
(7775, 'sisesc', 6, 'addpersona', '2024-03-15 23:33:17', b'1'),
(7776, 'sisesc', 6, 'addproveedor', '2024-03-15 23:33:18', b'1'),
(7777, 'sisesc', 6, 'selproveedor', '2024-03-15 23:33:18', b'1'),
(7778, 'sisesc', 6, 'getproveedor', '2024-03-15 23:33:27', b'1'),
(7779, 'sisesc', 6, 'getpersona', '2024-03-15 23:33:27', b'1'),
(7780, 'sisesc', 6, 'selmarca', '2024-03-15 23:33:27', b'1'),
(7781, 'sisesc', 6, 'updpersona', '2024-03-15 23:33:32', b'1'),
(7782, 'sisesc', 6, 'updproveedor', '2024-03-15 23:33:33', b'1'),
(7783, 'sisesc', 6, 'selproveedor', '2024-03-15 23:33:33', b'1'),
(7784, 'sisesc', 6, 'getproveedor', '2024-03-15 23:33:44', b'1'),
(7785, 'sisesc', 6, 'getpersona', '2024-03-15 23:33:44', b'1'),
(7786, 'sisesc', 6, 'selmarca', '2024-03-15 23:33:44', b'1'),
(7787, 'sisesc', 6, 'updpersona', '2024-03-15 23:33:50', b'1'),
(7788, 'sisesc', 6, 'updproveedor', '2024-03-15 23:33:50', b'1'),
(7789, 'sisesc', 6, 'selproveedor', '2024-03-15 23:33:50', b'1'),
(7790, 'sisesc', 6, 'getproveedor', '2024-03-15 23:33:53', b'1'),
(7791, 'sisesc', 6, 'getpersona', '2024-03-15 23:33:54', b'1'),
(7792, 'sisesc', 6, 'selmarca', '2024-03-15 23:33:54', b'1'),
(7793, 'sisesc', 6, 'updpersona', '2024-03-15 23:33:58', b'1'),
(7794, 'sisesc', 6, 'updproveedor', '2024-03-15 23:33:59', b'1'),
(7795, 'sisesc', 6, 'selproveedor', '2024-03-15 23:33:59', b'1'),
(7796, 'sisesc', 6, 'selcompra', '2024-03-15 23:34:39', b'1'),
(7797, 'sisesc', 2, 'selmarca', '2024-03-15 23:34:54', b'1'),
(7798, 'sisesc', 2, 'selclasificacionproducto', '2024-03-15 23:34:54', b'1'),
(7799, 'sisesc', 6, 'selcompra', '2024-03-15 23:36:06', b'1'),
(7800, 'sisesc', 6, 'selproveedor', '2024-03-15 23:36:14', b'1'),
(7801, 'sisesc', 6, 'selcompra', '2024-03-15 23:36:20', b'1'),
(7802, 'sisesc', 6, 'selproveedor', '2024-03-15 23:36:41', b'1'),
(7803, 'sisesc', 6, 'getcompra', '2024-03-15 23:36:41', b'1'),
(7804, 'sisesc', 6, 'selcompradetalle', '2024-03-15 23:36:41', b'1'),
(7805, 'sisesc', 6, 'selproducto', '2024-03-15 23:36:42', b'1'),
(7806, 'sisesc', 6, 'getproveedor', '2024-03-15 23:36:42', b'1'),
(7807, 'sisesc', 6, 'getpersona', '2024-03-15 23:36:42', b'1'),
(7808, 'sisesc', 2, 'selproducto', '2024-03-15 23:37:11', b'1'),
(7809, 'sisesc', 2, 'addproducto', '2024-03-15 23:37:11', b'1'),
(7810, 'sisesc', 2, 'selventa', '2024-03-15 23:37:57', b'1'),
(7811, 'sisesc', 2, 'selcliente', '2024-03-15 23:38:02', b'1'),
(7812, 'sisesc', 2, 'selcotizacion', '2024-03-15 23:38:06', b'1'),
(7813, 'sisesc', 2, 'selparametro', '2024-03-15 23:38:14', b'1'),
(7814, 'sisesc', 2, 'selproducto', '2024-03-15 23:38:46', b'1'),
(7815, 'sisesc', 2, 'getproducto', '2024-03-15 23:38:57', b'1'),
(7816, 'sisesc', 2, 'selmarca', '2024-03-15 23:38:57', b'1'),
(7817, 'sisesc', 2, 'selclasificacionproducto', '2024-03-15 23:38:57', b'1'),
(7818, 'sisesc', 2, 'updproducto', '2024-03-15 23:39:24', b'1'),
(7819, 'sisesc', 2, 'selproducto', '2024-03-15 23:39:24', b'1'),
(7820, 'sisesc', 2, 'getproducto', '2024-03-15 23:39:33', b'1'),
(7821, 'sisesc', 2, 'selmarca', '2024-03-15 23:39:33', b'1'),
(7822, 'sisesc', 2, 'selclasificacionproducto', '2024-03-15 23:39:33', b'1'),
(7823, 'sisesc', 2, 'selmarca', '2024-03-15 23:42:23', b'1'),
(7824, 'sisesc', 2, 'getmarca', '2024-03-15 23:42:27', b'1'),
(7825, 'sisesc', 2, 'selmarca', '2024-03-15 23:42:27', b'1'),
(7826, 'sisesc', 2, 'updmarca', '2024-03-15 23:42:38', b'1'),
(7827, 'sisesc', 2, 'selmarca', '2024-03-15 23:42:38', b'1'),
(7828, 'sisesc', 2, 'getmarca', '2024-03-15 23:42:49', b'1'),
(7829, 'sisesc', 2, 'selmarca', '2024-03-15 23:42:49', b'1'),
(7830, 'sisesc', 2, 'selmarca', '2024-03-15 23:42:55', b'1'),
(7831, 'sisesc', 6, 'getcompra', '2024-03-15 23:43:00', b'1'),
(7832, 'sisesc', 6, 'selpagocompra', '2024-03-15 23:43:01', b'1'),
(7833, 'sisesc', 6, 'getproveedor', '2024-03-15 23:43:01', b'1'),
(7834, 'sisesc', 6, 'getpersona', '2024-03-15 23:43:01', b'1'),
(7835, 'sisesc', 6, 'getcompra', '2024-03-15 23:43:01', b'1'),
(7836, 'sisesc', 2, 'selmarca', '2024-03-15 23:43:03', b'1'),
(7837, 'sisesc', 6, 'selcompra', '2024-03-15 23:43:26', b'1'),
(7838, 'sisesc', 6, 'selproveedor', '2024-03-15 23:43:28', b'1'),
(7839, 'sisesc', 6, 'getcompra', '2024-03-15 23:43:28', b'1'),
(7840, 'sisesc', 6, 'selcompradetalle', '2024-03-15 23:43:29', b'1'),
(7841, 'sisesc', 6, 'selproducto', '2024-03-15 23:43:29', b'1'),
(7842, 'sisesc', 6, 'getproveedor', '2024-03-15 23:43:29', b'1'),
(7843, 'sisesc', 6, 'getpersona', '2024-03-15 23:43:29', b'1'),
(7844, 'sisesc', 6, 'getcompra', '2024-03-15 23:43:31', b'1'),
(7845, 'sisesc', 6, 'selpagocompra', '2024-03-15 23:43:31', b'1'),
(7846, 'sisesc', 6, 'getproveedor', '2024-03-15 23:43:32', b'1'),
(7847, 'sisesc', 6, 'getpersona', '2024-03-15 23:43:32', b'1'),
(7848, 'sisesc', 6, 'getcompra', '2024-03-15 23:43:32', b'1'),
(7849, 'sisesc', 6, 'pappagocompra', '2024-03-15 23:44:20', b'1'),
(7850, 'sisesc', 6, 'selpagocompra', '2024-03-15 23:44:20', b'1'),
(7851, 'sisesc', 6, 'getcompra', '2024-03-15 23:44:20', b'1'),
(7852, 'sisesc', 6, 'getpagocompra', '2024-03-15 23:44:55', b'1'),
(7853, 'sisesc', 6, 'getcompra', '2024-03-15 23:44:55', b'1'),
(7854, 'sisesc', 6, 'getproveedor', '2024-03-15 23:44:55', b'1'),
(7855, 'sisesc', 6, 'getpersona', '2024-03-15 23:44:55', b'1'),
(7856, 'sisesc', 6, 'getpagocompra', '2024-03-15 23:46:04', b'1'),
(7857, 'sisesc', 6, 'getcompra', '2024-03-15 23:46:04', b'1'),
(7858, 'sisesc', 6, 'getproveedor', '2024-03-15 23:46:04', b'1'),
(7859, 'sisesc', 6, 'getpersona', '2024-03-15 23:46:04', b'1'),
(7860, 'sisesc', 6, 'selcompra', '2024-03-15 23:47:45', b'1'),
(7861, 'sisesc', 6, 'selproveedor', '2024-03-15 23:48:07', b'1'),
(7862, 'sisesc', 6, 'getcompra', '2024-03-15 23:48:07', b'1'),
(7863, 'sisesc', 6, 'selcompradetalle', '2024-03-15 23:48:07', b'1'),
(7864, 'sisesc', 6, 'selproducto', '2024-03-15 23:48:08', b'1'),
(7865, 'sisesc', 6, 'getproveedor', '2024-03-15 23:48:08', b'1'),
(7866, 'sisesc', 6, 'getpersona', '2024-03-15 23:48:08', b'1'),
(7867, 'sisesc', 6, 'getcompra', '2024-03-15 23:48:15', b'1'),
(7868, 'sisesc', 6, 'selpagocompra', '2024-03-15 23:48:15', b'1'),
(7869, 'sisesc', 6, 'getproveedor', '2024-03-15 23:48:15', b'1'),
(7870, 'sisesc', 6, 'getpersona', '2024-03-15 23:48:15', b'1'),
(7871, 'sisesc', 6, 'getcompra', '2024-03-15 23:48:16', b'1'),
(7872, 'sisesc', 6, 'pappagocompra', '2024-03-15 23:50:54', b'1'),
(7873, 'sisesc', 6, 'selpagocompra', '2024-03-15 23:50:54', b'1'),
(7874, 'sisesc', 6, 'getcompra', '2024-03-15 23:50:54', b'1'),
(7875, 'sisesc', 6, 'getpagocompra', '2024-03-15 23:51:06', b'1'),
(7876, 'sisesc', 6, 'getcompra', '2024-03-15 23:51:06', b'1'),
(7877, 'sisesc', 6, 'getproveedor', '2024-03-15 23:51:06', b'1'),
(7878, 'sisesc', 6, 'getpersona', '2024-03-15 23:51:06', b'1'),
(7879, 'sisesc', 6, 'selcompra', '2024-03-16 10:52:54', b'1'),
(7880, 'sisesc', 6, 'getpagocompra', '2024-03-16 11:00:28', b'1'),
(7881, 'sisesc', 6, 'getcompra', '2024-03-16 11:00:29', b'1'),
(7882, 'sisesc', 6, 'getproveedor', '2024-03-16 11:00:29', b'1'),
(7883, 'sisesc', 6, 'getpersona', '2024-03-16 11:00:29', b'1'),
(7884, 'sisesc', 6, 'getcompra', '2024-03-16 11:43:13', b'1'),
(7885, 'sisesc', 6, 'selpagocompra', '2024-03-16 11:43:14', b'1'),
(7886, 'sisesc', 6, 'getproveedor', '2024-03-16 11:43:14', b'1'),
(7887, 'sisesc', 6, 'getpersona', '2024-03-16 11:43:14', b'1'),
(7888, 'sisesc', 6, 'getcompra', '2024-03-16 11:43:14', b'1'),
(7889, 'sisesc', 1, 'seloficina', '2024-03-16 12:22:57', b'1'),
(7890, 'sisesc', 1, 'seloficina', '2024-03-16 12:22:59', b'1'),
(7891, 'sisesc', 1, 'selproducto', '2024-03-16 12:23:02', b'1'),
(7892, 'sisesc', 1, 'selcompra', '2024-03-16 12:23:07', b'1'),
(7893, 'sisesc', 1, 'selproveedor', '2024-03-16 12:24:01', b'1'),
(7894, 'sisesc', 1, 'getcompra', '2024-03-16 12:24:01', b'1'),
(7895, 'sisesc', 1, 'selcompradetalle', '2024-03-16 12:24:01', b'1'),
(7896, 'sisesc', 1, 'selproducto', '2024-03-16 12:24:02', b'1'),
(7897, 'sisesc', 1, 'getproveedor', '2024-03-16 12:24:02', b'1'),
(7898, 'sisesc', 1, 'getpersona', '2024-03-16 12:24:02', b'1'),
(7899, 'sisesc', 1, 'getcompra', '2024-03-16 12:24:07', b'1'),
(7900, 'sisesc', 1, 'selpagocompra', '2024-03-16 12:24:07', b'1'),
(7901, 'sisesc', 1, 'getproveedor', '2024-03-16 12:24:07', b'1'),
(7902, 'sisesc', 1, 'getpersona', '2024-03-16 12:24:07', b'1'),
(7903, 'sisesc', 1, 'getcompra', '2024-03-16 12:24:08', b'1'),
(7904, 'sisesc', 1, 'pappagocompra', '2024-03-16 12:24:29', b'1'),
(7905, 'sisesc', 1, 'selpagocompra', '2024-03-16 12:24:30', b'1'),
(7906, 'sisesc', 1, 'getcompra', '2024-03-16 12:24:30', b'1'),
(7907, 'sisesc', 1, 'selcompra', '2024-03-16 12:24:44', b'1'),
(7908, 'sisesc', 1, 'selproveedor', '2024-03-16 12:24:53', b'1'),
(7909, 'sisesc', 1, 'getcompra', '2024-03-16 12:24:53', b'1'),
(7910, 'sisesc', 1, 'selcompradetalle', '2024-03-16 12:24:53', b'1'),
(7911, 'sisesc', 1, 'selproducto', '2024-03-16 12:24:53', b'1'),
(7912, 'sisesc', 1, 'getproveedor', '2024-03-16 12:24:53', b'1'),
(7913, 'sisesc', 1, 'getpersona', '2024-03-16 12:24:53', b'1'),
(7914, 'sisesc', 1, 'getcompra', '2024-03-16 12:24:56', b'1'),
(7915, 'sisesc', 1, 'selpagocompra', '2024-03-16 12:24:56', b'1'),
(7916, 'sisesc', 1, 'getproveedor', '2024-03-16 12:24:56', b'1'),
(7917, 'sisesc', 1, 'getpersona', '2024-03-16 12:24:56', b'1'),
(7918, 'sisesc', 1, 'getcompra', '2024-03-16 12:24:56', b'1'),
(7919, 'sisesc', 1, 'selcompra', '2024-03-16 12:29:41', b'1'),
(7920, 'sisesc', 1, 'selproveedor', '2024-03-16 12:43:59', b'1'),
(7921, 'sisesc', 1, 'getcompra', '2024-03-16 12:43:59', b'1'),
(7922, 'sisesc', 1, 'selcompradetalle', '2024-03-16 12:44:00', b'1'),
(7923, 'sisesc', 1, 'selproducto', '2024-03-16 12:44:01', b'1'),
(7924, 'sisesc', 1, 'getproveedor', '2024-03-16 12:44:01', b'1'),
(7925, 'sisesc', 1, 'selcompra', '2024-03-16 12:44:01', b'1'),
(7926, 'sisesc', 1, 'getpersona', '2024-03-16 12:44:01', b'1'),
(7927, 'sisesc', 1, 'getcompra', '2024-03-16 12:44:18', b'1'),
(7928, 'sisesc', 1, 'selproveedor', '2024-03-16 12:44:18', b'1'),
(7929, 'sisesc', 1, 'selcompradetalle', '2024-03-16 12:44:18', b'1'),
(7930, 'sisesc', 1, 'selproducto', '2024-03-16 12:44:18', b'1'),
(7931, 'sisesc', 1, 'getproveedor', '2024-03-16 12:44:18', b'1'),
(7932, 'sisesc', 1, 'getpersona', '2024-03-16 12:44:19', b'1'),
(7933, 'sisesc', 6, 'getcompra', '2024-03-18 12:50:52', b'1'),
(7934, 'sisesc', 6, 'selpagocompra', '2024-03-18 12:50:52', b'1'),
(7935, 'sisesc', 6, 'getproveedor', '2024-03-18 12:50:52', b'1'),
(7936, 'sisesc', 6, 'getpersona', '2024-03-18 12:50:52', b'1'),
(7937, 'sisesc', 6, 'getcompra', '2024-03-18 12:50:53', b'1'),
(7938, 'sisesc', 6, 'getcompra', '2024-03-18 14:20:49', b'1'),
(7939, 'sisesc', 6, 'selpagocompra', '2024-03-18 14:20:50', b'1'),
(7940, 'sisesc', 6, 'getproveedor', '2024-03-18 14:20:50', b'1'),
(7941, 'sisesc', 6, 'getpersona', '2024-03-18 14:20:50', b'1'),
(7942, 'sisesc', 6, 'getcompra', '2024-03-18 14:20:51', b'1'),
(7943, 'sisesc', 6, 'getcompra', '2024-03-18 14:39:24', b'1'),
(7944, 'sisesc', 6, 'selpagocompra', '2024-03-18 14:39:25', b'1'),
(7945, 'sisesc', 6, 'getproveedor', '2024-03-18 14:39:25', b'1'),
(7946, 'sisesc', 6, 'getpersona', '2024-03-18 14:39:25', b'1'),
(7947, 'sisesc', 6, 'getcompra', '2024-03-18 14:39:25', b'1'),
(7948, 'sisesc', 6, 'getcompra', '2024-03-18 14:40:17', b'1'),
(7949, 'sisesc', 6, 'selpagocompra', '2024-03-18 14:40:17', b'1'),
(7950, 'sisesc', 6, 'getproveedor', '2024-03-18 14:40:17', b'1'),
(7951, 'sisesc', 6, 'getpersona', '2024-03-18 14:40:18', b'1'),
(7952, 'sisesc', 6, 'getcompra', '2024-03-18 14:40:18', b'1'),
(7953, 'sisesc', 6, 'selusuario', '2024-03-18 14:40:27', b'1'),
(7954, 'sisesc', 6, 'getusuario', '2024-03-18 14:40:38', b'1'),
(7955, 'sisesc', 6, 'getpersona', '2024-03-18 14:40:38', b'1'),
(7956, 'sisesc', 6, 'selrolusuario', '2024-03-18 14:40:38', b'1'),
(7957, 'sisesc', 6, 'selusuario', '2024-03-18 14:40:50', b'1'),
(7958, 'sisesc', 6, 'selproveedor', '2024-03-18 14:40:59', b'1'),
(7959, 'sisesc', 6, 'selcompra', '2024-03-18 14:41:05', b'1'),
(7960, 'sisesc', 6, 'selproveedor', '2024-03-18 14:41:13', b'1'),
(7961, 'sisesc', 6, 'getcompra', '2024-03-18 14:41:13', b'1'),
(7962, 'sisesc', 6, 'selcompradetalle', '2024-03-18 14:41:13', b'1'),
(7963, 'sisesc', 6, 'selproducto', '2024-03-18 14:41:13', b'1'),
(7964, 'sisesc', 6, 'getproveedor', '2024-03-18 14:41:13', b'1'),
(7965, 'sisesc', 6, 'getpersona', '2024-03-18 14:41:14', b'1'),
(7966, 'sisesc', 6, 'getcompra', '2024-03-18 17:59:49', b'1'),
(7967, 'sisesc', 6, 'selproveedor', '2024-03-18 17:59:49', b'1'),
(7968, 'sisesc', 6, 'selcompradetalle', '2024-03-18 17:59:53', b'1'),
(7969, 'sisesc', 6, 'selproducto', '2024-03-18 17:59:54', b'1'),
(7970, 'sisesc', 6, 'getproveedor', '2024-03-18 17:59:55', b'1'),
(7971, 'sisesc', 6, 'getpersona', '2024-03-18 17:59:57', b'1'),
(7972, 'sisesc', 4, 'selparametrotipo', '2024-03-25 10:42:28', b'1'),
(7973, 'sisesc', 4, 'selplandecuenta', '2024-03-25 10:42:29', b'1'),
(7974, 'sisesc', 4, 'selventa', '2024-03-25 10:42:35', b'1'),
(7975, 'sisesc', 6, 'selproveedor', '2024-03-26 22:26:19', b'1'),
(7976, 'sisesc', 6, 'getcompra', '2024-03-26 22:26:19', b'1'),
(7977, 'sisesc', 6, 'selcompradetalle', '2024-03-26 22:26:19', b'1'),
(7978, 'sisesc', 6, 'selproducto', '2024-03-26 22:26:20', b'1'),
(7979, 'sisesc', 6, 'getproveedor', '2024-03-26 22:26:20', b'1'),
(7980, 'sisesc', 6, 'getpersona', '2024-03-26 22:26:20', b'1'),
(7981, 'sisesc', 1, 'seloficina', '2024-03-27 01:35:34', b'1'),
(7982, 'sisesc', 1, 'seloficina', '2024-03-27 01:35:39', b'1'),
(7983, 'sisesc', 1, 'selcompra', '2024-03-27 01:36:09', b'1'),
(7984, 'sisesc', 1, 'selproducto', '2024-03-27 01:36:23', b'1'),
(7985, 'sisesc', 1, 'selusuario', '2024-03-27 01:36:32', b'1'),
(7986, 'sisesc', 1, 'selproducto', '2024-03-27 01:36:39', b'1'),
(7987, 'sisesc', 1, 'selmarca', '2024-03-27 01:36:41', b'1'),
(7988, 'sisesc', 1, 'selclasificacionproducto', '2024-03-27 01:36:41', b'1'),
(7989, 'sisesc', 1, 'selproducto', '2024-03-27 01:37:20', b'1'),
(7990, 'sisesc', 1, 'addproducto', '2024-03-27 01:37:20', b'1'),
(7991, 'sisesc', 1, 'selproveedor', '2024-03-27 01:37:28', b'1'),
(7992, 'sisesc', 1, 'selmarca', '2024-03-27 01:37:33', b'1'),
(7993, 'sisesc', 1, 'addpersona', '2024-03-27 01:37:53', b'1'),
(7994, 'sisesc', 1, 'addproveedor', '2024-03-27 01:37:53', b'1'),
(7995, 'sisesc', 1, 'selproveedor', '2024-03-27 01:37:53', b'1'),
(7996, 'sisesc', 1, 'selproveedor', '2024-03-27 01:38:04', b'1'),
(7997, 'sisesc', 1, 'getproveedor', '2024-03-27 01:38:21', b'1'),
(7998, 'sisesc', 1, 'getpersona', '2024-03-27 01:38:21', b'1'),
(7999, 'sisesc', 1, 'addcompra', '2024-03-27 01:38:22', b'1'),
(8000, 'sisesc', 1, 'selproducto', '2024-03-27 01:38:22', b'1'),
(8001, 'sisesc', 1, 'getproducto', '2024-03-27 01:38:28', b'1'),
(8002, 'sisesc', 1, 'addcompradetalle', '2024-03-27 01:38:40', b'1'),
(8003, 'sisesc', 1, 'selcompradetalle', '2024-03-27 01:38:40', b'1'),
(8004, 'sisesc', 3, 'seloficina', '2024-03-27 15:08:14', b'1'),
(8005, 'sisesc', 3, 'selcompra', '2024-03-27 15:08:16', b'1'),
(8006, 'sisesc', 3, 'selproveedor', '2024-03-27 15:08:17', b'1'),
(8007, 'sisesc', 3, 'getcompra', '2024-03-27 15:08:17', b'1'),
(8008, 'sisesc', 3, 'selcompradetalle', '2024-03-27 15:08:18', b'1'),
(8009, 'sisesc', 3, 'selproducto', '2024-03-27 15:08:18', b'1'),
(8010, 'sisesc', 3, 'getproveedor', '2024-03-27 15:08:18', b'1'),
(8011, 'sisesc', 3, 'getpersona', '2024-03-27 15:08:18', b'1'),
(8012, 'sisesc', 1, 'seloficina', '2024-03-27 21:12:33', b'1'),
(8013, 'sisesc', 3, 'getcompra', '2024-03-28 11:36:30', b'1'),
(8014, 'sisesc', 3, 'selproveedor', '2024-03-28 11:36:30', b'1'),
(8015, 'sisesc', 3, 'selcompradetalle', '2024-03-28 11:36:30', b'1'),
(8016, 'sisesc', 3, 'selproducto', '2024-03-28 11:36:30', b'1'),
(8017, 'sisesc', 3, 'getproveedor', '2024-03-28 11:36:31', b'1'),
(8018, 'sisesc', 3, 'getpersona', '2024-03-28 11:36:31', b'1'),
(8019, 'sisesc', 3, 'selproveedor', '2024-03-28 12:41:36', b'1'),
(8020, 'sisesc', 3, 'getcompra', '2024-03-28 12:41:36', b'1'),
(8021, 'sisesc', 3, 'selcompradetalle', '2024-03-28 12:41:36', b'1'),
(8022, 'sisesc', 3, 'selproducto', '2024-03-28 12:41:36', b'1'),
(8023, 'sisesc', 3, 'getproveedor', '2024-03-28 12:41:37', b'1'),
(8024, 'sisesc', 3, 'getpersona', '2024-03-28 12:41:37', b'1'),
(8025, 'sisesc', 3, 'seloficina', '2024-04-02 20:31:53', b'1'),
(8026, 'sisesc', 3, 'selusuario', '2024-04-02 20:31:54', b'1'),
(8027, 'sisesc', 3, 'selusuario', '2024-04-03 12:31:14', b'1'),
(8028, 'sisesc', 3, 'selusuario', '2024-04-03 17:06:23', b'1'),
(8029, 'sisesc', 1, 'seloficina', '2024-05-04 19:17:19', b'1'),
(8030, 'sisesc', 1, 'seloficina', '2024-05-04 19:17:21', b'1'),
(8031, 'sisesc', 1, 'selusuario', '2024-05-04 19:18:12', b'1'),
(8032, 'sisesc', 1, 'getusuario', '2024-05-04 19:18:27', b'1'),
(8033, 'sisesc', 1, 'getpersona', '2024-05-04 19:18:27', b'1'),
(8034, 'sisesc', 1, 'selrolusuario', '2024-05-04 19:18:28', b'1'),
(8035, 'sisesc', 1, 'selusuario', '2024-05-04 19:18:30', b'1'),
(8036, 'sisesc', 1, 'selproducto', '2024-05-04 19:18:41', b'1'),
(8037, 'sisesc', 1, 'getproducto', '2024-05-04 19:18:44', b'1'),
(8038, 'sisesc', 1, 'selmarca', '2024-05-04 19:18:44', b'1'),
(8039, 'sisesc', 1, 'selclasificacionproducto', '2024-05-04 19:18:45', b'1'),
(8040, 'sisesc', 1, 'selusuario', '2024-08-05 19:59:02', b'1'),
(8041, 'sisesc', 1, 'selusuario', '2024-08-05 20:05:47', b'1'),
(8042, 'sisesc', 1, 'selusuario', '2024-08-05 20:06:08', b'1'),
(8043, 'sisesc', 1, 'selusuario', '2024-08-05 20:09:09', b'1'),
(8044, 'sisesc', 1, 'selusuario', '2024-09-19 14:38:41', b'1'),
(8045, 'sisesc', 1, 'selusuario', '2024-09-19 14:47:24', b'1'),
(8046, 'sisesc', 1, 'selusuario', '2024-09-19 14:47:44', b'1'),
(8047, 'sisesc', 1, 'getusuario', '2024-09-19 14:48:54', b'1'),
(8048, 'sisesc', 1, 'selusuario', '2024-09-19 14:53:10', b'1'),
(8049, 'sisesc', 1, 'getusuario', '2024-09-19 14:53:13', b'1'),
(8050, 'sisesc', 1, 'getusuario', '2024-09-19 14:53:17', b'1');
INSERT INTO `seg_tbllogusuario` (`idlogusuario`, `nombresistema`, `idusuario`, `nombreservicio`, `fecharegistro`, `estadoregistro`) VALUES
(8051, 'sisesc', 1, 'getusuario', '2024-09-19 14:53:25', b'1'),
(8052, 'sisesc', 1, 'getusuario', '2024-09-19 14:55:30', b'1'),
(8053, 'sisesc', 1, 'getpersona', '2024-09-19 14:55:30', b'1'),
(8054, 'sisesc', 1, 'selrolusuario', '2024-09-19 14:55:31', b'1'),
(8055, 'sisesc', 1, 'getusuario', '2024-09-19 15:03:02', b'1'),
(8056, 'sisesc', 1, 'getpersona', '2024-09-19 15:03:02', b'1'),
(8057, 'sisesc', 1, 'selrolusuario', '2024-09-19 15:03:02', b'1'),
(8058, 'sisesc', 1, 'getusuario', '2024-09-19 15:03:25', b'1'),
(8059, 'sisesc', 1, 'getpersona', '2024-09-19 15:03:25', b'1'),
(8060, 'sisesc', 1, 'selrolusuario', '2024-09-19 15:03:25', b'1'),
(8061, 'sisesc', 1, 'getusuario', '2024-09-19 15:05:18', b'1'),
(8062, 'sisesc', 1, 'getpersona', '2024-09-19 15:05:19', b'1'),
(8063, 'sisesc', 1, 'selrolusuario', '2024-09-19 15:05:19', b'1'),
(8064, 'sisesc', 1, 'getusuario', '2024-09-19 15:27:02', b'1'),
(8065, 'sisesc', 1, 'getpersona', '2024-09-19 15:27:02', b'1'),
(8066, 'sisesc', 1, 'selrolusuario', '2024-09-19 15:27:03', b'1'),
(8067, 'sisesc', 1, 'getusuario', '2024-09-19 15:29:05', b'1'),
(8068, 'sisesc', 1, 'getpersona', '2024-09-19 15:29:06', b'1'),
(8069, 'sisesc', 1, 'selrolusuario', '2024-09-19 15:29:06', b'1'),
(8070, 'sisesc', 1, 'getusuario', '2024-09-19 15:29:21', b'1'),
(8071, 'sisesc', 1, 'getpersona', '2024-09-19 15:29:21', b'1'),
(8072, 'sisesc', 1, 'selrolusuario', '2024-09-19 15:29:21', b'1'),
(8073, 'sisesc', 1, 'selusuario', '2024-09-19 16:21:44', b'1'),
(8074, 'sisesc', 1, 'getusuario', '2024-09-19 16:21:47', b'1'),
(8075, 'sisesc', 1, 'getpersona', '2024-09-19 16:21:47', b'1'),
(8076, 'sisesc', 1, 'selrolusuario', '2024-09-19 16:21:48', b'1'),
(8077, 'sisesc', 1, 'getusuario', '2024-09-19 16:21:57', b'1'),
(8078, 'sisesc', 1, 'getpersona', '2024-09-19 16:21:57', b'1'),
(8079, 'sisesc', 1, 'selrolusuario', '2024-09-19 16:21:57', b'1'),
(8080, 'sisesc', 1, 'selusuario', '2024-09-19 16:37:30', b'1'),
(8081, 'sisesc', 1, 'selusuario', '2024-09-19 16:37:36', b'1'),
(8082, 'sisesc', 1, 'getusuario', '2024-09-19 16:37:38', b'1'),
(8083, 'sisesc', 1, 'getpersona', '2024-09-19 16:37:38', b'1'),
(8084, 'sisesc', 1, 'selrolusuario', '2024-09-19 16:37:38', b'1'),
(8085, 'sisesc', 1, 'selusuario', '2024-09-19 16:37:40', b'1'),
(8086, 'sisesc', 1, 'getusuario', '2024-09-19 16:37:42', b'1'),
(8087, 'sisesc', 1, 'getpersona', '2024-09-19 16:37:42', b'1'),
(8088, 'sisesc', 1, 'selrolusuario', '2024-09-19 16:37:42', b'1'),
(8089, 'sisesc', 1, 'selusuario', '2024-09-19 16:37:49', b'1'),
(8090, 'sisesc', 1, 'getusuario', '2024-09-19 16:54:33', b'1'),
(8091, 'sisesc', 1, 'getpersona', '2024-09-19 16:54:33', b'1'),
(8092, 'sisesc', 1, 'selrolusuario', '2024-09-19 16:54:33', b'1'),
(8093, 'sisesc', 1, 'selusuario', '2024-09-19 16:54:36', b'1'),
(8094, 'sisesc', 1, 'selusuario', '2024-09-19 16:58:46', b'1'),
(8095, 'sisesc', 1, 'selusuario', '2024-09-19 17:02:03', b'1'),
(8096, 'sisesc', 1, 'selusuario', '2024-09-19 17:05:52', b'1'),
(8097, 'sisesc', 1, 'selusuario', '2024-09-19 21:37:58', b'1'),
(8098, 'sisesc', 1, 'selusuario', '2024-09-19 21:41:57', b'1'),
(8099, 'sisesc', 1, 'selusuario', '2024-09-19 21:41:58', b'1'),
(8100, 'sisesc', 1, 'selusuario', '2024-09-20 12:23:59', b'1'),
(8101, 'sisesc', 1, 'selusuario', '2024-09-20 12:24:18', b'1'),
(8102, 'sisesc', 1, 'selusuario', '2024-09-20 12:25:02', b'1'),
(8103, 'sisesc', 1, 'selusuario', '2024-09-20 14:46:53', b'1'),
(8104, 'sisesc', 1, 'selusuario', '2024-09-20 14:52:00', b'1'),
(8105, 'sisesc', 1, 'getusuario', '2024-09-20 14:52:33', b'1'),
(8106, 'sisesc', 1, 'getpersona', '2024-09-20 14:52:33', b'1'),
(8107, 'sisesc', 1, 'selrolusuario', '2024-09-20 14:52:33', b'1'),
(8108, 'sisesc', 1, 'updusuario', '2024-09-20 14:52:51', b'1'),
(8109, 'sisesc', 1, 'updpersona', '2024-09-20 14:52:51', b'1'),
(8110, 'sisesc', 44, 'selusuario', '2024-09-20 14:59:36', b'1'),
(8111, 'sisesc', 44, 'selusuario', '2024-09-20 14:59:49', b'1'),
(8112, 'sisesc', 44, 'selusuario', '2024-09-20 14:59:56', b'1'),
(8113, 'sisesc', 1, 'selusuario', '2024-09-23 22:08:43', b'1'),
(8114, 'sisesc', 1, 'getusuario', '2024-09-23 22:29:45', b'1'),
(8115, 'sisesc', 1, 'getpersona', '2024-09-23 22:29:45', b'1'),
(8116, 'sisesc', 1, 'selrolusuario', '2024-09-23 22:29:45', b'1'),
(8117, 'sisesc', 1, 'getusuario', '2024-09-25 12:25:28', b'1'),
(8118, 'sisesc', 1, 'getpersona', '2024-09-25 12:25:29', b'1'),
(8119, 'sisesc', 1, 'selrolusuario', '2024-09-25 12:25:29', b'1'),
(8120, 'sisesc', 44, 'selusuario', '2024-10-01 20:27:16', b'1'),
(8121, 'sisesc', 44, 'getusuario', '2024-10-01 20:35:22', b'1'),
(8122, 'sisesc', 44, 'getpersona', '2024-10-01 20:35:22', b'1'),
(8123, 'sisesc', 44, 'selrolusuario', '2024-10-01 20:35:22', b'1'),
(8124, 'sisesc', 44, 'selusuario', '2024-10-01 20:35:38', b'1'),
(8125, 'sisesc', 44, 'selusuario', '2024-10-01 20:36:15', b'1'),
(8126, 'sisesc', 44, 'selusuario', '2024-10-01 20:41:15', b'1'),
(8127, 'sisesc', 44, 'getusuario', '2024-10-01 20:41:19', b'1'),
(8128, 'sisesc', 44, 'getpersona', '2024-10-01 20:41:19', b'1'),
(8129, 'sisesc', 44, 'selrolusuario', '2024-10-01 20:41:19', b'1'),
(8130, 'sisesc', 44, 'selusuario', '2024-10-01 20:41:25', b'1'),
(8131, 'sisesc', 1, 'selusuario', '2024-10-20 18:40:49', b'1'),
(8132, 'sisesc', 44, 'selusuario', '2024-10-22 21:51:06', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seg_tblparametro`
--

CREATE TABLE `seg_tblparametro` (
  `idparametro` int(11) DEFAULT NULL,
  `nombretabla` varchar(50) DEFAULT NULL,
  `nombrecampo` varchar(50) DEFAULT NULL,
  `valorcampo` int(11) DEFAULT NULL,
  `descripcion` varchar(2024) DEFAULT NULL,
  `habilitado` bit(1) DEFAULT NULL,
  `idparametropadre` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `seg_tblparametro`
--

INSERT INTO `seg_tblparametro` (`idparametro`, `nombretabla`, `nombrecampo`, `valorcampo`, `descripcion`, `habilitado`, `idparametropadre`, `fecharegistro`, `estadoregistro`) VALUES
(1, 'alm_tblcompra', 'idestadocompra', 1, 'EN PROCESO', b'1', 0, '2024-02-28 09:51:07', b'1'),
(2, 'alm_tblcompra', 'idestadocompra', 2, 'PAGADO', b'1', 0, '2024-02-28 09:51:07', b'1'),
(4, 'alm_tblventa', 'idestadoventa', 1, 'EN PROCESO', b'1', 0, '2024-02-28 09:51:07', b'1'),
(3, 'alm_tblcompra', 'idestadocompra', 3, 'POR PAGAR', b'1', 0, '2024-02-28 09:51:07', b'1'),
(5, 'alm_tblventa', 'idestadoventa', 2, 'PAGADO', b'1', 0, '2024-02-28 09:57:39', b'1'),
(6, 'alm_tblventa', 'idestadoventa', 3, 'POR PAGAR', b'1', 0, '2024-02-28 09:57:43', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seg_tblparametrotipo`
--

CREATE TABLE `seg_tblparametrotipo` (
  `idparametrotipo` int(11) DEFAULT NULL,
  `nombretabla` varchar(50) DEFAULT NULL,
  `nombrecampo` varchar(50) DEFAULT NULL,
  `valorcampo` int(11) DEFAULT NULL,
  `descripcion` varchar(2024) DEFAULT NULL,
  `habilitado` bit(1) DEFAULT NULL,
  `idparametrotipopadre` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `seg_tblparametrotipo`
--

INSERT INTO `seg_tblparametrotipo` (`idparametrotipo`, `nombretabla`, `nombrecampo`, `valorcampo`, `descripcion`, `habilitado`, `idparametrotipopadre`, `fecharegistro`, `estadoregistro`) VALUES
(1, 'alm_tblplandecuenta', 'idtipoplandecuenta', 1, 'INGRESO', b'1', 0, '2024-02-18 20:24:06', b'1'),
(2, 'alm_tblplandecuenta', 'idtipoplandecuenta', 2, 'EGRESO', b'1', 0, '2024-02-18 20:24:08', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seg_tblrol`
--

CREATE TABLE `seg_tblrol` (
  `idrol` int(11) DEFAULT NULL,
  `nombrerol` varchar(100) DEFAULT NULL,
  `imagen` blob DEFAULT NULL,
  `idsistema` int(11) DEFAULT NULL,
  `idnivelacceso` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `seg_tblrol`
--

INSERT INTO `seg_tblrol` (`idrol`, `nombrerol`, `imagen`, `idsistema`, `idnivelacceso`, `fecharegistro`, `estadoregistro`) VALUES
(1, 'ADMIN', 0x20, 1, 1, '2023-11-29 13:52:16', b'1'),
(2, 'SECRETARIA', 0x20, 1, 1, '2023-11-29 13:52:34', b'1'),
(3, 'MEDICO', 0x20, 1, 1, '2023-11-29 13:52:47', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seg_tblrolusuario`
--

CREATE TABLE `seg_tblrolusuario` (
  `idrolusuario` int(11) DEFAULT NULL,
  `idrol` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `idestadorolusuario` int(11) DEFAULT NULL,
  `idubicacion` int(11) DEFAULT NULL,
  `idtiporolusuario` int(11) DEFAULT NULL,
  `idusuariocreacion` int(11) DEFAULT NULL,
  `fechabaja` datetime DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `seg_tblrolusuario`
--

INSERT INTO `seg_tblrolusuario` (`idrolusuario`, `idrol`, `idusuario`, `idestadorolusuario`, `idubicacion`, `idtiporolusuario`, `idusuariocreacion`, `fechabaja`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 1, 1, 2, 1, 1, '2023-11-29 13:43:13', '2023-11-29 13:43:15', b'1'),
(2, 3, 1, 2, 1, 0, 0, '2023-11-29 14:50:04', '2023-11-29 18:50:11', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seg_tblusuario`
--

CREATE TABLE `seg_tblusuario` (
  `idusuario` int(11) DEFAULT NULL,
  `idpersona` int(11) DEFAULT NULL,
  `nombreusuario` varchar(100) DEFAULT NULL,
  `clave` varchar(200) DEFAULT NULL,
  `salt` varchar(20) DEFAULT NULL,
  `pin` int(11) DEFAULT NULL,
  `idestadousuario` int(11) DEFAULT NULL,
  `idtipousuario` int(11) DEFAULT NULL,
  `estilo` varchar(100) DEFAULT NULL,
  `idsucursal` int(11) DEFAULT NULL,
  `idrol` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `seg_tblusuario`
--

INSERT INTO `seg_tblusuario` (`idusuario`, `idpersona`, `nombreusuario`, `clave`, `salt`, `pin`, `idestadousuario`, `idtipousuario`, `estilo`, `idsucursal`, `idrol`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 'admin.root', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(2, 2, 'rosemary.alachi', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(3, 3, 'martha.almendras', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(4, 4, 'leyla aracely.arroyo', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(5, 5, 'maria elena.caba', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(6, 6, 'juan carlos.castro', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(7, 7, 'maria elena.choque', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(8, 8, 'julia.coca', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(9, 9, 'trifonia.colque', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(10, 10, 'yamil fernando.crespo', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(11, 11, 'sergio.echalar', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(12, 12, 'susana.encinas', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(13, 13, 'gladys vanesa.fernandez', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(14, 14, 'liliana vanessa.flores', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(15, 15, 'paola wendy.flores', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(16, 16, 'juan.garcia', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(17, 17, 'mirtha mercedes.gomez', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(18, 18, 'waldir.lazo', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(19, 19, 'mauricio.lora', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(20, 20, 'jorge.lucuy', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(21, 21, 'gisela mabel.macias', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(22, 22, 'lizeth.maldonado', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(23, 23, 'elizabeth.mamani', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(24, 24, 'pascuala.maras', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(25, 25, 'waldid lucio.marin', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(26, 26, 'damiana.menchaca', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(27, 27, 'maria.mendez', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(28, 28, 'marina.navarro', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(29, 29, 'raquel.nogales', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(30, 30, 'marina.paco', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(31, 31, 'carmela.paracta', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(32, 32, 'tomas.perez', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(33, 33, 'maria alicia.prado', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(34, 34, 'donata.puma', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(35, 35, 'claudia dayana.quiroga', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(36, 36, 'richard timoteo.rendon', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(37, 37, 'fabiola martha.rivera', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(38, 38, 'abigail.rodriguez', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(39, 39, 'martina.sossa', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(40, 40, 'carlos marcelo.soto', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(41, 41, 'lupe ninoska.uribe', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(42, 42, 'mauricio percy.velasco', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(43, 43, 'viviana.villca', '$1$bJY0o3Q/$wCaRIkeZsgDT71GFgnzhj1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1'),
(44, 44, 'franco.viscarra', '$1$8p4x4QKa$JHfN8q6.cYMAYAybTrxwE1', '123', 1, 1, 1, '', 1, 1, '2024-09-19 21:36:48', b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seg_tblusuariologueado`
--

CREATE TABLE `seg_tblusuariologueado` (
  `idusuariologueado` int(11) DEFAULT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `idrolusuario` int(11) DEFAULT NULL,
  `llave` varchar(300) DEFAULT NULL,
  `idestadollave` int(11) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `direccionip` varchar(25) DEFAULT NULL,
  `direccionhost` varchar(25) DEFAULT NULL,
  `direcciondest` varchar(250) DEFAULT NULL,
  `idsucursal` int(11) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `estadoregistro` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `seg_tblusuariologueado`
--

INSERT INTO `seg_tblusuariologueado` (`idusuariologueado`, `idusuario`, `idrolusuario`, `llave`, `idestadollave`, `fecha`, `direccionip`, `direccionhost`, `direcciondest`, `idsucursal`, `fecharegistro`, `estadoregistro`) VALUES
(1, 1, 1, '$1$hRLmgbg2$AnUBnIcQibmX32kM6KFCN/', 2, '2024-09-19 21:37:52', 'NA', 'NA', 'NA', 1, '2024-09-19 21:37:52', b'1'),
(2, 1, 1, '$1$E0Ree3Zz$.OSl9rmhJEh6/bBNneHva0', 2, '2024-09-20 12:24:58', 'NA', 'NA', 'NA', 1, '2024-09-20 12:24:58', b'1'),
(3, 2, 1, '$1$lp0PpGUb$TxeT3X1e14HUPUKtehYG8.', 1, '2024-09-20 14:52:09', 'NA', 'NA', 'NA', 1, '2024-09-20 14:52:09', b'1'),
(4, 44, 1, '$1$4Wk6WlXX$Ak.Igb42EmPW20MCQd1RS0', 2, '2024-09-20 14:53:08', 'NA', 'NA', 'NA', 1, '2024-09-20 14:53:08', b'1'),
(5, 44, 1, '$1$BUGS96Qe$LhU0Lra.hFh667mCW5fOd.', 2, '2024-09-20 14:59:20', 'NA', 'NA', 'NA', 1, '2024-09-20 14:59:20', b'1'),
(6, 44, 1, '$1$n7Zfan36$YsiXTwxqe54PgamAa9sAp/', 2, '2024-09-20 14:59:46', 'NA', 'NA', 'NA', 1, '2024-09-20 14:59:46', b'1'),
(7, 1, 1, '$1$lAErl4Fp$KQrOT7c.BcimL5.bGlYCn.', 1, '2024-09-23 22:08:26', 'NA', 'NA', 'NA', 1, '2024-09-23 22:08:26', b'1'),
(8, 44, 1, '$1$8J1BysxO$4MYSEszHL2WBBfPeYguol.', 2, '2024-10-01 20:35:45', 'NA', 'NA', 'NA', 1, '2024-10-01 20:35:45', b'1'),
(9, 44, 1, '$1$koDpzMQy$Zh3YBWUfiKT.1wAttji/t/', 1, '2024-10-01 20:36:01', 'NA', 'NA', 'NA', 1, '2024-10-01 20:36:01', b'1');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seg_visestado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seg_visestado` (
`idestado` int(11)
,`nombretabla` varchar(50)
,`nombrecampo` varchar(50)
,`valorcampo` varchar(2048)
,`habilitado` bit(1)
,`idestadopadre` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seg_vislogusuario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seg_vislogusuario` (
`idlogusuario` int(11)
,`nombresistema` char(6)
,`idusuario` int(11)
,`nombreservicio` char(32)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seg_visparametro`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seg_visparametro` (
`idparametro` int(11)
,`nombretabla` varchar(50)
,`nombrecampo` varchar(50)
,`valorcampo` int(11)
,`descripcion` varchar(2024)
,`habilitado` bit(1)
,`idparametropadre` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seg_visparametrotipo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seg_visparametrotipo` (
`idparametrotipo` int(11)
,`nombretabla` varchar(50)
,`nombrecampo` varchar(50)
,`valorcampo` int(11)
,`descripcion` varchar(2024)
,`habilitado` bit(1)
,`idparametrotipopadre` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seg_visrol`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seg_visrol` (
`idrol` int(11)
,`nombrerol` varchar(100)
,`imagen` blob
,`idsistema` int(11)
,`idnivelacceso` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seg_visrolusuario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seg_visrolusuario` (
`idrolusuario` int(11)
,`idrol` int(11)
,`idusuario` int(11)
,`nombreusuario` varchar(100)
,`nombrerol` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seg_visusuario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seg_visusuario` (
`idusuario` int(11)
,`idestadousuario` int(11)
,`idpersona` int(11)
,`nombreusuario` varchar(100)
,`idrol` int(11)
,`nombre` varchar(50)
,`paterno` varchar(50)
,`materno` varchar(50)
,`idsucursal` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seg_visusuariologueado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seg_visusuariologueado` (
`idusuariologueado` int(11)
,`idusuario` int(11)
,`idrolusuario` int(11)
,`llave` varchar(300)
,`idestadollave` int(11)
,`fecha` datetime
,`direccionip` varchar(25)
,`direccionhost` varchar(25)
,`direcciondest` varchar(250)
,`idsucursal` int(11)
,`fecharegistro` datetime
,`estadoregistro` bit(1)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_viscierrecaja`
--
DROP TABLE IF EXISTS `alm_viscierrecaja`;

CREATE  VIEW `alm_viscierrecaja`  AS SELECT `alm_tblcierrecaja`.`idcierrecaja` AS `idcierrecaja`, `alm_tblcierrecaja`.`idoficina` AS `idoficina`, `alm_tblcierrecaja`.`idusuario` AS `idusuario`, `alm_tblcierrecaja`.`montoinicio` AS `montoinicio`, `alm_tblcierrecaja`.`montofinal` AS `montofinal`, `alm_tblcierrecaja`.`idusuariocierre` AS `idusuariocierre`, `alm_tblcierrecaja`.`idestadocierrecaja` AS `idestadocierrecaja`, `alm_tblcierrecaja`.`fechainicio` AS `fechainicio`, `alm_tblcierrecaja`.`fechafinal` AS `fechafinal`, `alm_tblcierrecaja`.`fecharegistro` AS `fecharegistro`, `alm_tblcierrecaja`.`estadoregistro` AS `estadoregistro` FROM `alm_tblcierrecaja` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_visclasificacionproducto`
--
DROP TABLE IF EXISTS `alm_visclasificacionproducto`;

CREATE  VIEW `alm_visclasificacionproducto`  AS SELECT `alm_tblclasificacionproducto`.`idclasificacionproducto` AS `idclasificacionproducto`, `alm_tblclasificacionproducto`.`nombreclasificacionproducto` AS `nombreclasificacionproducto`, `alm_tblclasificacionproducto`.`descripcion` AS `descripcion`, `alm_tblclasificacionproducto`.`idclasificacionproductopadre` AS `idclasificacionproductopadre`, `alm_tblclasificacionproducto`.`primario` AS `primario`, `alm_tblclasificacionproducto`.`idtipoclasificacionproducto` AS `idtipoclasificacionproducto`, `alm_tblclasificacionproducto`.`fecharegistro` AS `fecharegistro`, `alm_tblclasificacionproducto`.`estadoregistro` AS `estadoregistro` FROM `alm_tblclasificacionproducto` WHERE `alm_tblclasificacionproducto`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_viscompra`
--
DROP TABLE IF EXISTS `alm_viscompra`;

CREATE  VIEW `alm_viscompra`  AS SELECT `d`.`idcompra` AS `idcompra`, `d`.`numerocompra` AS `numerocompra`, `d`.`nombrecompra` AS `nombrecompra`, `d`.`titulo` AS `titulo`, `d`.`idusuario` AS `idusuario`, `d`.`idproveedor` AS `idproveedor`, `d`.`fechacompra` AS `fechacompra`, `d`.`tipocompra` AS `tipocompra`, `d`.`idoficina` AS `idoficina`, `d`.`subtotal` AS `subtotal`, `d`.`descuento` AS `descuento`, `d`.`total` AS `total`, `d`.`idmoneda` AS `idmoneda`, `d`.`descripcion` AS `descripcion`, `d`.`idestadocompra` AS `idestadocompra`, `d`.`pagado` AS `pagado`, `d`.`cambio` AS `cambio`, `d`.`idusuarioresponsable` AS `idusuarioresponsable`, `d`.`idaperturacierrecaja` AS `idaperturacierrecaja`, `d`.`fecharegistro` AS `fecharegistro`, `d`.`estadoregistro` AS `estadoregistro`, `p`.`descripcion` AS `nombreestadocompra` FROM (`alm_tblcompra` `d` join `seg_tblparametro` `p`) WHERE `d`.`idestadocompra` = `p`.`valorcampo` AND `p`.`nombrecampo` = 'idestadocompra' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_viscompradetalle`
--
DROP TABLE IF EXISTS `alm_viscompradetalle`;

CREATE  VIEW `alm_viscompradetalle`  AS SELECT `alm_tblcompradetalle`.`idcompradetalle` AS `idcompradetalle`, `alm_tblcompradetalle`.`idcompra` AS `idcompra`, `alm_tblcompradetalle`.`nombrecompradetalle` AS `nombrecompradetalle`, `alm_tblcompradetalle`.`idproducto` AS `idproducto`, `alm_tblcompradetalle`.`cantidad` AS `cantidad`, `alm_tblcompradetalle`.`preciounitario` AS `preciounitario`, `alm_tblcompradetalle`.`precioventa` AS `precioventa`, `alm_tblcompradetalle`.`subtotal` AS `subtotal`, `alm_tblcompradetalle`.`fechaini` AS `fechaini`, `alm_tblcompradetalle`.`fechafin` AS `fechafin`, `alm_tblcompradetalle`.`idestadocompradetalle` AS `idestadocompradetalle`, `alm_tblcompradetalle`.`fecharegistro` AS `fecharegistro`, `alm_tblcompradetalle`.`estadoregistro` AS `estadoregistro` FROM `alm_tblcompradetalle` WHERE `alm_tblcompradetalle`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_viscotizacion`
--
DROP TABLE IF EXISTS `alm_viscotizacion`;

CREATE  VIEW `alm_viscotizacion`  AS SELECT `alm_tblcotizacion`.`idcotizacion` AS `idcotizacion`, `alm_tblcotizacion`.`numerocotizacion` AS `numerocotizacion`, `alm_tblcotizacion`.`nombrecotizacion` AS `nombrecotizacion`, `alm_tblcotizacion`.`titulo` AS `titulo`, `alm_tblcotizacion`.`idusuario` AS `idusuario`, `alm_tblcotizacion`.`idcliente` AS `idcliente`, `alm_tblcotizacion`.`fechacotizacion` AS `fechacotizacion`, `alm_tblcotizacion`.`tipocotizacion` AS `tipocotizacion`, `alm_tblcotizacion`.`idoficina` AS `idoficina`, `alm_tblcotizacion`.`subtotal` AS `subtotal`, `alm_tblcotizacion`.`descuento` AS `descuento`, `alm_tblcotizacion`.`total` AS `total`, `alm_tblcotizacion`.`idmoneda` AS `idmoneda`, `alm_tblcotizacion`.`descripcion` AS `descripcion`, `alm_tblcotizacion`.`idestadocotizacion` AS `idestadocotizacion`, `alm_tblcotizacion`.`pagado` AS `pagado`, `alm_tblcotizacion`.`cambio` AS `cambio`, `alm_tblcotizacion`.`idusuarioresponsable` AS `idusuarioresponsable`, `alm_tblcotizacion`.`idaperturacierrecaja` AS `idaperturacierrecaja`, `alm_tblcotizacion`.`fecharegistro` AS `fecharegistro`, `alm_tblcotizacion`.`estadoregistro` AS `estadoregistro` FROM `alm_tblcotizacion` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_viscotizaciondetalle`
--
DROP TABLE IF EXISTS `alm_viscotizaciondetalle`;

CREATE  VIEW `alm_viscotizaciondetalle`  AS SELECT `alm_tblcotizaciondetalle`.`idcotizaciondetalle` AS `idcotizaciondetalle`, `alm_tblcotizaciondetalle`.`idcotizacion` AS `idcotizacion`, `alm_tblcotizaciondetalle`.`nombrecotizaciondetalle` AS `nombrecotizaciondetalle`, `alm_tblcotizaciondetalle`.`idproducto` AS `idproducto`, `alm_tblcotizaciondetalle`.`cantidad` AS `cantidad`, `alm_tblcotizaciondetalle`.`preciounitario` AS `preciounitario`, `alm_tblcotizaciondetalle`.`precioventa` AS `precioventa`, `alm_tblcotizaciondetalle`.`subtotal` AS `subtotal`, `alm_tblcotizaciondetalle`.`fechaini` AS `fechaini`, `alm_tblcotizaciondetalle`.`fechafin` AS `fechafin`, `alm_tblcotizaciondetalle`.`idestadocotizaciondetalle` AS `idestadocotizaciondetalle`, `alm_tblcotizaciondetalle`.`idcompradetalle` AS `idcompradetalle`, `alm_tblcotizaciondetalle`.`fecharegistro` AS `fecharegistro`, `alm_tblcotizaciondetalle`.`estadoregistro` AS `estadoregistro` FROM `alm_tblcotizaciondetalle` WHERE `alm_tblcotizaciondetalle`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_visingresoegreso`
--
DROP TABLE IF EXISTS `alm_visingresoegreso`;

CREATE  VIEW `alm_visingresoegreso`  AS SELECT `alm_tblingresoegreso`.`idingresoegreso` AS `idingresoegreso`, `alm_tblingresoegreso`.`descripcion` AS `descripcion`, `alm_tblingresoegreso`.`fechaingresoegreso` AS `fechaingresoegreso`, `alm_tblingresoegreso`.`idplandecuenta` AS `idplandecuenta`, `alm_tblingresoegreso`.`monto` AS `monto`, `alm_tblingresoegreso`.`idmoneda` AS `idmoneda`, `alm_tblingresoegreso`.`idtipopago` AS `idtipopago`, `alm_tblingresoegreso`.`idusuario` AS `idusuario`, `alm_tblingresoegreso`.`idoficina` AS `idoficina`, `alm_tblingresoegreso`.`idcierrecaja` AS `idcierrecaja`, `alm_tblingresoegreso`.`fecharegistro` AS `fecharegistro`, `alm_tblingresoegreso`.`estadoregistro` AS `estadoregistro` FROM `alm_tblingresoegreso` WHERE `alm_tblingresoegreso`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_vismarca`
--
DROP TABLE IF EXISTS `alm_vismarca`;

CREATE  VIEW `alm_vismarca`  AS SELECT `alm_tblmarca`.`idmarca` AS `idmarca`, `alm_tblmarca`.`nombremarca` AS `nombremarca`, `alm_tblmarca`.`fecharegistro` AS `fecharegistro`, `alm_tblmarca`.`estadoregistro` AS `estadoregistro` FROM `alm_tblmarca` WHERE `alm_tblmarca`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_vispagocompra`
--
DROP TABLE IF EXISTS `alm_vispagocompra`;

CREATE  VIEW `alm_vispagocompra`  AS SELECT `alm_tblpagocompra`.`idpagocompra` AS `idpagocompra`, `alm_tblpagocompra`.`idcompra` AS `idcompra`, `alm_tblpagocompra`.`idingresoegreso` AS `idingresoegreso`, `alm_tblpagocompra`.`fecha` AS `fecha`, `alm_tblpagocompra`.`descripcion` AS `descripcion`, `alm_tblpagocompra`.`monto` AS `monto`, `alm_tblpagocompra`.`idtipopago` AS `idtipopago`, `alm_tblpagocompra`.`idcotizacionmoneda` AS `idcotizacionmoneda`, `alm_tblpagocompra`.`idusuario` AS `idusuario`, `alm_tblpagocompra`.`idoficina` AS `idoficina`, `alm_tblpagocompra`.`fecharegistro` AS `fecharegistro`, `alm_tblpagocompra`.`estadoregistro` AS `estadoregistro` FROM `alm_tblpagocompra` WHERE `alm_tblpagocompra`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_vispagoventa`
--
DROP TABLE IF EXISTS `alm_vispagoventa`;

CREATE  VIEW `alm_vispagoventa`  AS SELECT `alm_tblpagoventa`.`idpagoventa` AS `idpagoventa`, `alm_tblpagoventa`.`idventa` AS `idventa`, `alm_tblpagoventa`.`idingresoegreso` AS `idingresoegreso`, `alm_tblpagoventa`.`fecha` AS `fecha`, `alm_tblpagoventa`.`descripcion` AS `descripcion`, `alm_tblpagoventa`.`monto` AS `monto`, `alm_tblpagoventa`.`idtipopago` AS `idtipopago`, `alm_tblpagoventa`.`idcotizacionmoneda` AS `idcotizacionmoneda`, `alm_tblpagoventa`.`idusuario` AS `idusuario`, `alm_tblpagoventa`.`idoficina` AS `idoficina`, `alm_tblpagoventa`.`fecharegistro` AS `fecharegistro`, `alm_tblpagoventa`.`estadoregistro` AS `estadoregistro` FROM `alm_tblpagoventa` WHERE `alm_tblpagoventa`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_visplandecuenta`
--
DROP TABLE IF EXISTS `alm_visplandecuenta`;

CREATE  VIEW `alm_visplandecuenta`  AS SELECT `alm_tblplandecuenta`.`idplandecuenta` AS `idplandecuenta`, `alm_tblplandecuenta`.`descripcion` AS `descripcion`, `alm_tblplandecuenta`.`idplandecuentapadre` AS `idplandecuentapadre`, `alm_tblplandecuenta`.`primario` AS `primario`, `alm_tblplandecuenta`.`idtipoplandecuenta` AS `idtipoplandecuenta`, `alm_tblplandecuenta`.`fecharegistro` AS `fecharegistro`, `alm_tblplandecuenta`.`estadoregistro` AS `estadoregistro` FROM `alm_tblplandecuenta` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_visproducto`
--
DROP TABLE IF EXISTS `alm_visproducto`;

CREATE  VIEW `alm_visproducto`  AS SELECT `alm_tblproducto`.`idproducto` AS `idproducto`, `alm_tblproducto`.`nombreproducto` AS `nombreproducto`, `alm_tblproducto`.`idclasificacionproducto` AS `idclasificacionproducto`, `alm_tblproducto`.`referencia` AS `referencia`, `alm_tblproducto`.`descripcion` AS `descripcion`, `alm_tblproducto`.`color` AS `color`, `alm_tblproducto`.`talla` AS `talla`, `alm_tblproducto`.`idmarca` AS `idmarca`, `alm_tblproducto`.`codigobarra1` AS `codigobarra1`, `alm_tblproducto`.`codigobarra2` AS `codigobarra2`, `alm_tblproducto`.`idtipounidad` AS `idtipounidad`, `alm_tblproducto`.`tipoproducto` AS `tipoproducto`, `alm_tblproducto`.`ventacongarantia` AS `ventacongarantia`, `alm_tblproducto`.`connumeroserie` AS `connumeroserie`, `alm_tblproducto`.`conrfid` AS `conrfid`, `alm_tblproducto`.`diasvalides` AS `diasvalides`, `alm_tblproducto`.`montocompra` AS `montocompra`, `alm_tblproducto`.`montoventa` AS `montoventa`, `alm_tblproducto`.`modelo` AS `modelo`, `alm_tblproducto`.`idusuarioactualiza` AS `idusuarioactualiza`, `alm_tblproducto`.`fecharegistro` AS `fecharegistro`, `alm_tblproducto`.`estadoregistro` AS `estadoregistro` FROM `alm_tblproducto` WHERE `alm_tblproducto`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_visproductostock`
--
DROP TABLE IF EXISTS `alm_visproductostock`;

CREATE  VIEW `alm_visproductostock`  AS SELECT `ps`.`idproductostock` AS `idproductostock`, `ps`.`idproducto` AS `idproducto`, `ps`.`idoficina` AS `idoficina`, `ps`.`cantidad` AS `cantidad`, `ps`.`cantidadminima` AS `cantidadminima`, `ps`.`cantidadmaxima` AS `cantidadmaxima`, `ps`.`preciocompra` AS `preciocompra`, `ps`.`precioventa` AS `precioventa`, `ps`.`idusuarioregistra` AS `idusuarioregistra`, `ps`.`idcompradetalle` AS `idcompradetalle`, `ps`.`idcompradetalledato` AS `idcompradetalledato`, `ps`.`fecharegistro` AS `fecharegistro`, `ps`.`estadoregistro` AS `estadoregistro`, `p`.`codigobarra1` AS `codigobarra1`, `p`.`nombreproducto` AS `nombreproducto`, `p`.`montocompra` AS `montocompra`, `p`.`montoventa` AS `montoventa` FROM (`alm_tblproductostock` `ps` join `alm_tblproducto` `p`) WHERE `p`.`idproducto` = `ps`.`idproducto` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_visventa`
--
DROP TABLE IF EXISTS `alm_visventa`;

CREATE  VIEW `alm_visventa`  AS SELECT `d`.`idventa` AS `idventa`, `d`.`numeroventa` AS `numeroventa`, `d`.`nombreventa` AS `nombreventa`, `d`.`titulo` AS `titulo`, `d`.`idusuario` AS `idusuario`, `d`.`idcliente` AS `idcliente`, `d`.`fechaventa` AS `fechaventa`, `d`.`tipoventa` AS `tipoventa`, `d`.`idoficina` AS `idoficina`, `d`.`subtotal` AS `subtotal`, `d`.`descuento` AS `descuento`, `d`.`total` AS `total`, `d`.`idmoneda` AS `idmoneda`, `d`.`descripcion` AS `descripcion`, `d`.`idestadoventa` AS `idestadoventa`, `d`.`pagado` AS `pagado`, `d`.`cambio` AS `cambio`, `d`.`idusuarioresponsable` AS `idusuarioresponsable`, `d`.`idaperturacierrecaja` AS `idaperturacierrecaja`, `d`.`fecharegistro` AS `fecharegistro`, `d`.`estadoregistro` AS `estadoregistro`, `p`.`descripcion` AS `nombreestadoventa` FROM (`alm_tblventa` `d` join `seg_tblparametro` `p`) WHERE `d`.`idestadoventa` = `p`.`valorcampo` AND `p`.`nombrecampo` = 'idestadoventa' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `alm_visventadetalle`
--
DROP TABLE IF EXISTS `alm_visventadetalle`;

CREATE  VIEW `alm_visventadetalle`  AS SELECT `alm_tblventadetalle`.`idventadetalle` AS `idventadetalle`, `alm_tblventadetalle`.`idventa` AS `idventa`, `alm_tblventadetalle`.`nombreventadetalle` AS `nombreventadetalle`, `alm_tblventadetalle`.`idproducto` AS `idproducto`, `alm_tblventadetalle`.`cantidad` AS `cantidad`, `alm_tblventadetalle`.`preciounitario` AS `preciounitario`, `alm_tblventadetalle`.`subtotal` AS `subtotal`, `alm_tblventadetalle`.`fechaini` AS `fechaini`, `alm_tblventadetalle`.`fechafin` AS `fechafin`, `alm_tblventadetalle`.`idestadoventadetalle` AS `idestadoventadetalle`, `alm_tblventadetalle`.`idcompradetalle` AS `idcompradetalle`, `alm_tblventadetalle`.`fecharegistro` AS `fecharegistro`, `alm_tblventadetalle`.`estadoregistro` AS `estadoregistro` FROM `alm_tblventadetalle` WHERE `alm_tblventadetalle`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `cli_visconsultorio`
--
DROP TABLE IF EXISTS `cli_visconsultorio`;

CREATE  VIEW `cli_visconsultorio`  AS SELECT `cli_tblconsultorio`.`idconsultorio` AS `idconsultorio`, `cli_tblconsultorio`.`nombreconsultorio` AS `nombreconsultorio`, `cli_tblconsultorio`.`numeroconsultorio` AS `numeroconsultorio`, `cli_tblconsultorio`.`detalle` AS `detalle`, `cli_tblconsultorio`.`horainiciorefrigerio` AS `horainiciorefrigerio`, `cli_tblconsultorio`.`horafinrefrigerio` AS `horafinrefrigerio`, `cli_tblconsultorio`.`fecharegistro` AS `fecharegistro`, `cli_tblconsultorio`.`estadoregistro` AS `estadoregistro` FROM `cli_tblconsultorio` WHERE `cli_tblconsultorio`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `cli_visespecialidad`
--
DROP TABLE IF EXISTS `cli_visespecialidad`;

CREATE  VIEW `cli_visespecialidad`  AS SELECT `cli_tblespecialidad`.`idespecialidad` AS `idespecialidad`, `cli_tblespecialidad`.`idoficina` AS `idoficina`, `cli_tblespecialidad`.`nombreespecialidad` AS `nombreespecialidad`, `cli_tblespecialidad`.`titulo` AS `titulo`, `cli_tblespecialidad`.`detalle` AS `detalle`, `cli_tblespecialidad`.`pieespecialidad` AS `pieespecialidad`, `cli_tblespecialidad`.`orden` AS `orden`, `cli_tblespecialidad`.`agendarcita` AS `agendarcita`, `cli_tblespecialidad`.`fecharegistro` AS `fecharegistro`, `cli_tblespecialidad`.`estadoregistro` AS `estadoregistro` FROM `cli_tblespecialidad` WHERE `cli_tblespecialidad`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `cli_visespecialidadmedico`
--
DROP TABLE IF EXISTS `cli_visespecialidadmedico`;

CREATE  VIEW `cli_visespecialidadmedico`  AS SELECT `cli_tblespecialidadmedico`.`idespecialidadmedico` AS `idespecialidadmedico`, `cli_tblespecialidadmedico`.`idmedico` AS `idmedico`, `cli_tblespecialidadmedico`.`idespecialidad` AS `idespecialidad`, `cli_tblespecialidadmedico`.`idusuario` AS `idusuario`, `cli_tblespecialidadmedico`.`fecharegistro` AS `fecharegistro`, `cli_tblespecialidadmedico`.`estadoregistro` AS `estadoregistro` FROM `cli_tblespecialidadmedico` WHERE `cli_tblespecialidadmedico`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `cli_vismedico`
--
DROP TABLE IF EXISTS `cli_vismedico`;

CREATE  VIEW `cli_vismedico`  AS SELECT `cli_tblmedico`.`idmedico` AS `idmedico`, `cli_tblmedico`.`idusuario` AS `idusuario`, `cli_tblmedico`.`matricula` AS `matricula`, `cli_tblmedico`.`fecharegistro` AS `fecharegistro`, `cli_tblmedico`.`estadoregistro` AS `estadoregistro` FROM `cli_tblmedico` WHERE `cli_tblmedico`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `cli_visreserva`
--
DROP TABLE IF EXISTS `cli_visreserva`;

CREATE  VIEW `cli_visreserva`  AS SELECT `cli_tblreserva`.`idreserva` AS `idreserva`, `cli_tblreserva`.`idoficina` AS `idoficina`, `cli_tblreserva`.`idespecialidad` AS `idespecialidad`, `cli_tblreserva`.`fechareserva` AS `fechareserva`, `cli_tblreserva`.`horainicio` AS `horainicio`, `cli_tblreserva`.`horafin` AS `horafin`, `cli_tblreserva`.`fechaevento` AS `fechaevento`, `cli_tblreserva`.`idestadoreserva` AS `idestadoreserva`, `cli_tblreserva`.`fechacancelacion` AS `fechacancelacion`, `cli_tblreserva`.`idusuario` AS `idusuario`, `cli_tblreserva`.`observaciones` AS `observaciones`, `cli_tblreserva`.`carnetidentidad` AS `carnetidentidad`, `cli_tblreserva`.`idtipodocumento` AS `idtipodocumento`, `cli_tblreserva`.`nombre` AS `nombre`, `cli_tblreserva`.`paterno` AS `paterno`, `cli_tblreserva`.`materno` AS `materno`, `cli_tblreserva`.`celular` AS `celular`, `cli_tblreserva`.`email` AS `email`, `cli_tblreserva`.`idconsultorio` AS `idconsultorio`, `cli_tblreserva`.`fecharegistro` AS `fecharegistro`, `cli_tblreserva`.`estadoregistro` AS `estadoregistro` FROM `cli_tblreserva` WHERE `cli_tblreserva`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `per_viscliente`
--
DROP TABLE IF EXISTS `per_viscliente`;

CREATE  VIEW `per_viscliente`  AS SELECT `pro`.`idcliente` AS `idcliente`, `per`.`nombre`+ ' ' + `per`.`paterno` + ' ' + `per`.`materno` AS `nombrecliente`, `per`.`idpersona` AS `idpersona`, `per`.`idtipopersona` AS `idtipopersona`, `per`.`nombre` AS `nombre`, `per`.`paterno` AS `paterno`, `per`.`materno` AS `materno`, `per`.`direccion` AS `direccion`, `per`.`celular` AS `celular`, `per`.`celularcontacto` AS `celularcontacto`, `per`.`fechanacimiento` AS `fechanacimiento`, `per`.`idtiposexo` AS `idtiposexo`, `per`.`observaciones` AS `observaciones`, `per`.`nrodocumento` AS `nrodocumento`, `per`.`idtipodocumento` AS `idtipodocumento`, `per`.`nit` AS `nit`, `per`.`fecharegistro` AS `fecharegistro`, `per`.`estadoregistro` AS `estadoregistro` FROM (`per_tblcliente` `pro` join `per_tblpersona` `per`) WHERE `pro`.`idpersona` = `per`.`idpersona` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `per_vispersona`
--
DROP TABLE IF EXISTS `per_vispersona`;

CREATE  VIEW `per_vispersona`  AS SELECT `per_tblpersona`.`idpersona` AS `idpersona`, `per_tblpersona`.`idtipopersona` AS `idtipopersona`, `per_tblpersona`.`nombre` AS `nombre`, `per_tblpersona`.`paterno` AS `paterno`, `per_tblpersona`.`materno` AS `materno`, `per_tblpersona`.`direccion` AS `direccion`, `per_tblpersona`.`celular` AS `celular`, `per_tblpersona`.`celularcontacto` AS `celularcontacto`, `per_tblpersona`.`fechanacimiento` AS `fechanacimiento`, `per_tblpersona`.`idtiposexo` AS `idtiposexo`, `per_tblpersona`.`observaciones` AS `observaciones`, `per_tblpersona`.`nrodocumento` AS `nrodocumento`, `per_tblpersona`.`idtipodocumento` AS `idtipodocumento`, `per_tblpersona`.`nit` AS `nit`, `per_tblpersona`.`fecharegistro` AS `fecharegistro`, `per_tblpersona`.`estadoregistro` AS `estadoregistro` FROM `per_tblpersona` WHERE `per_tblpersona`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `per_visproveedor`
--
DROP TABLE IF EXISTS `per_visproveedor`;

CREATE  VIEW `per_visproveedor`  AS SELECT `pro`.`idproveedor` AS `idproveedor`, `per`.`nombre`+ ' ' + `per`.`paterno` + ' ' + `per`.`materno` AS `nombreproveedor`, `per`.`idpersona` AS `idpersona`, `per`.`idtipopersona` AS `idtipopersona`, `per`.`nombre` AS `nombre`, `per`.`paterno` AS `paterno`, `per`.`materno` AS `materno`, `per`.`direccion` AS `direccion`, `per`.`celular` AS `celular`, `per`.`celularcontacto` AS `celularcontacto`, `per`.`fechanacimiento` AS `fechanacimiento`, `per`.`idtiposexo` AS `idtiposexo`, `per`.`observaciones` AS `observaciones`, `per`.`nrodocumento` AS `nrodocumento`, `per`.`idtipodocumento` AS `idtipodocumento`, `per`.`nit` AS `nit`, `per`.`fecharegistro` AS `fecharegistro`, `per`.`estadoregistro` AS `estadoregistro` FROM (`per_tblproveedor` `pro` join `per_tblpersona` `per`) WHERE `pro`.`idpersona` = `per`.`idpersona` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `res_vishorariogeneral`
--
DROP TABLE IF EXISTS `res_vishorariogeneral`;

CREATE  VIEW `res_vishorariogeneral`  AS SELECT `res_tblhorariogeneral`.`idhorariogeneral` AS `idhorariogeneral`, `res_tblhorariogeneral`.`idhorario` AS `idhorario`, `res_tblhorariogeneral`.`fecha` AS `fecha`, `res_tblhorariogeneral`.`diasemana` AS `diasemana`, `res_tblhorariogeneral`.`idferiado` AS `idferiado`, `res_tblhorariogeneral`.`idtipofecha` AS `idtipofecha`, `res_tblhorariogeneral`.`fecharegistro` AS `fecharegistro`, `res_tblhorariogeneral`.`estadoregistro` AS `estadoregistro` FROM `res_tblhorariogeneral` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `res_visoficina`
--
DROP TABLE IF EXISTS `res_visoficina`;

CREATE  VIEW `res_visoficina`  AS SELECT `res_tbloficina`.`idoficina` AS `idoficina`, `res_tbloficina`.`nombreoficina` AS `nombreoficina`, `res_tbloficina`.`iddepartamento` AS `iddepartamento`, `res_tbloficina`.`direccion` AS `direccion`, `res_tbloficina`.`ubicacion` AS `ubicacion`, `res_tbloficina`.`fecharegistro` AS `fecharegistro`, `res_tbloficina`.`estadoregistro` AS `estadoregistro` FROM `res_tbloficina` WHERE `res_tbloficina`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `res_visreserva`
--
DROP TABLE IF EXISTS `res_visreserva`;

CREATE  VIEW `res_visreserva`  AS SELECT `r`.`idreserva` AS `idreserva`, `r`.`idoficina` AS `idoficina`, `r`.`idtramite` AS `idtramite`, `r`.`fechareserva` AS `fechareserva`, `r`.`horainicio` AS `horainicio`, `r`.`horafin` AS `horafin`, `r`.`fechaevento` AS `fechaevento`, `r`.`estadoreserva` AS `estadoreserva`, `r`.`historico` AS `historico`, `r`.`urlsolicitud` AS `urlsolicitud`, `r`.`fechacancelacion` AS `fechacancelacion`, `r`.`idusuario` AS `idusuario`, `r`.`llave` AS `llave`, `r`.`presente` AS `presente`, `r`.`observaciones` AS `observaciones`, `r`.`carnetidentidad` AS `carnetidentidad`, `r`.`complemento` AS `complemento`, `r`.`idtipodocumento` AS `idtipodocumento`, `r`.`nombre` AS `nombre`, `r`.`paterno` AS `paterno`, `r`.`materno` AS `materno`, `r`.`celular` AS `celular`, `r`.`email` AS `email`, `r`.`idubicacion` AS `idubicacion`, `r`.`preferencial` AS `preferencial`, `r`.`fecharegistro` AS `fecharegistro`, `r`.`estadoregistro` AS `estadoregistro`, `u`.`idtramitegrupo` AS `idtramitegrupo` FROM (`res_tblreserva` `r` join `res_tblubicacion` `u`) WHERE `r`.`estadoregistro` = 1 AND `r`.`idubicacion` = `u`.`idubicacion` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `res_vistramitegrupo`
--
DROP TABLE IF EXISTS `res_vistramitegrupo`;

CREATE  VIEW `res_vistramitegrupo`  AS SELECT `res_tbltramitegrupo`.`idtramitegrupo` AS `idtramitegrupo`, `res_tbltramitegrupo`.`idoficina` AS `idoficina`, `res_tbltramitegrupo`.`nombretramitegrupo` AS `nombretramitegrupo`, `res_tbltramitegrupo`.`titulo` AS `titulo`, `res_tbltramitegrupo`.`fecharegistro` AS `fecharegistro`, `res_tbltramitegrupo`.`estadoregistro` AS `estadoregistro` FROM `res_tbltramitegrupo` WHERE `res_tbltramitegrupo`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `res_vistramitemenu`
--
DROP TABLE IF EXISTS `res_vistramitemenu`;

CREATE  VIEW `res_vistramitemenu`  AS SELECT `res_tbltramitemenu`.`idtramitemenu` AS `idtramitemenu`, `res_tbltramitemenu`.`nombretramitemenu` AS `nombretramitemenu`, `res_tbltramitemenu`.`idoficina` AS `idoficina`, `res_tbltramitemenu`.`titulo` AS `titulo`, `res_tbltramitemenu`.`detalle` AS `detalle`, `res_tbltramitemenu`.`pietramitemenu` AS `pietramitemenu`, `res_tbltramitemenu`.`orden` AS `orden`, `res_tbltramitemenu`.`programacita` AS `programacita`, `res_tbltramitemenu`.`fecharegistro` AS `fecharegistro`, `res_tbltramitemenu`.`estadoregistro` AS `estadoregistro` FROM `res_tbltramitemenu` WHERE `res_tbltramitemenu`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `res_vistramitemenuespecialidad`
--
DROP TABLE IF EXISTS `res_vistramitemenuespecialidad`;

CREATE  VIEW `res_vistramitemenuespecialidad`  AS SELECT `tme`.`idtramitemenuespecialidad` AS `idtramitemenuespecialidad`, `tme`.`idtramitemenu` AS `idtramitemenu`, `tme`.`idespecialidad` AS `idespecialidad`, `e`.`nombreespecialidad` AS `nombreespecialidad` FROM (`res_tbltramitemenuespecialidad` `tme` join `cli_tblespecialidad` `e`) WHERE `e`.`idespecialidad` = `tme`.`idespecialidad` AND `e`.`estadoregistro` = 1 AND `tme`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `res_visubicacion`
--
DROP TABLE IF EXISTS `res_visubicacion`;

CREATE  VIEW `res_visubicacion`  AS SELECT `res_tblubicacion`.`idubicacion` AS `idubicacion`, `res_tblubicacion`.`idtramitegrupo` AS `idtramitegrupo`, `res_tblubicacion`.`idconsultorio` AS `idconsultorio`, `res_tblubicacion`.`tiempoestimado` AS `tiempoestimado`, `res_tblubicacion`.`numeroubicacion` AS `numeroubicacion`, `res_tblubicacion`.`nombreubicacion` AS `nombreubicacion`, `res_tblubicacion`.`servicio` AS `servicio`, `res_tblubicacion`.`programarcita` AS `programarcita`, `res_tblubicacion`.`fecharegistro` AS `fecharegistro`, `res_tblubicacion`.`estadoregistro` AS `estadoregistro` FROM `res_tblubicacion` WHERE `res_tblubicacion`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `res_visubicacionhorario`
--
DROP TABLE IF EXISTS `res_visubicacionhorario`;

CREATE  VIEW `res_visubicacionhorario`  AS SELECT `res_tblubicacionhorario`.`idubicacionhorario` AS `idubicacionhorario`, `res_tblubicacionhorario`.`idubicacion` AS `idubicacion`, `res_tblubicacionhorario`.`diasemana` AS `diasemana`, `res_tblubicacionhorario`.`horareinicio` AS `horareinicio`, `res_tblubicacionhorario`.`horarefin` AS `horarefin`, `res_tblubicacionhorario`.`horarefrigerioinicio` AS `horarefrigerioinicio`, `res_tblubicacionhorario`.`horarefrigeriofin` AS `horarefrigeriofin`, `res_tblubicacionhorario`.`programarcita` AS `programarcita`, `res_tblubicacionhorario`.`idusuario` AS `idusuario`, `res_tblubicacionhorario`.`fecharegistro` AS `fecharegistro`, `res_tblubicacionhorario`.`estadoregistro` AS `estadoregistro` FROM `res_tblubicacionhorario` WHERE `res_tblubicacionhorario`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `seg_visestado`
--
DROP TABLE IF EXISTS `seg_visestado`;

CREATE  VIEW `seg_visestado`  AS SELECT `seg_tblestado`.`idestado` AS `idestado`, `seg_tblestado`.`nombretabla` AS `nombretabla`, `seg_tblestado`.`nombrecampo` AS `nombrecampo`, `seg_tblestado`.`valorcampo` AS `valorcampo`, `seg_tblestado`.`habilitado` AS `habilitado`, `seg_tblestado`.`idestadopadre` AS `idestadopadre`, `seg_tblestado`.`fecharegistro` AS `fecharegistro`, `seg_tblestado`.`estadoregistro` AS `estadoregistro` FROM `seg_tblestado` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `seg_vislogusuario`
--
DROP TABLE IF EXISTS `seg_vislogusuario`;

CREATE  VIEW `seg_vislogusuario`  AS SELECT `seg_tbllogusuario`.`idlogusuario` AS `idlogusuario`, `seg_tbllogusuario`.`nombresistema` AS `nombresistema`, `seg_tbllogusuario`.`idusuario` AS `idusuario`, `seg_tbllogusuario`.`nombreservicio` AS `nombreservicio`, `seg_tbllogusuario`.`fecharegistro` AS `fecharegistro`, `seg_tbllogusuario`.`estadoregistro` AS `estadoregistro` FROM `seg_tbllogusuario` WHERE `seg_tbllogusuario`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `seg_visparametro`
--
DROP TABLE IF EXISTS `seg_visparametro`;

CREATE  VIEW `seg_visparametro`  AS SELECT `seg_tblparametro`.`idparametro` AS `idparametro`, `seg_tblparametro`.`nombretabla` AS `nombretabla`, `seg_tblparametro`.`nombrecampo` AS `nombrecampo`, `seg_tblparametro`.`valorcampo` AS `valorcampo`, `seg_tblparametro`.`descripcion` AS `descripcion`, `seg_tblparametro`.`habilitado` AS `habilitado`, `seg_tblparametro`.`idparametropadre` AS `idparametropadre`, `seg_tblparametro`.`fecharegistro` AS `fecharegistro`, `seg_tblparametro`.`estadoregistro` AS `estadoregistro` FROM `seg_tblparametro` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `seg_visparametrotipo`
--
DROP TABLE IF EXISTS `seg_visparametrotipo`;

CREATE  VIEW `seg_visparametrotipo`  AS SELECT `seg_tblparametrotipo`.`idparametrotipo` AS `idparametrotipo`, `seg_tblparametrotipo`.`nombretabla` AS `nombretabla`, `seg_tblparametrotipo`.`nombrecampo` AS `nombrecampo`, `seg_tblparametrotipo`.`valorcampo` AS `valorcampo`, `seg_tblparametrotipo`.`descripcion` AS `descripcion`, `seg_tblparametrotipo`.`habilitado` AS `habilitado`, `seg_tblparametrotipo`.`idparametrotipopadre` AS `idparametrotipopadre`, `seg_tblparametrotipo`.`fecharegistro` AS `fecharegistro`, `seg_tblparametrotipo`.`estadoregistro` AS `estadoregistro` FROM `seg_tblparametrotipo` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `seg_visrol`
--
DROP TABLE IF EXISTS `seg_visrol`;

CREATE  VIEW `seg_visrol`  AS SELECT `seg_tblrol`.`idrol` AS `idrol`, `seg_tblrol`.`nombrerol` AS `nombrerol`, `seg_tblrol`.`imagen` AS `imagen`, `seg_tblrol`.`idsistema` AS `idsistema`, `seg_tblrol`.`idnivelacceso` AS `idnivelacceso`, `seg_tblrol`.`fecharegistro` AS `fecharegistro`, `seg_tblrol`.`estadoregistro` AS `estadoregistro` FROM `seg_tblrol` WHERE `seg_tblrol`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `seg_visrolusuario`
--
DROP TABLE IF EXISTS `seg_visrolusuario`;

CREATE  VIEW `seg_visrolusuario`  AS SELECT `ru`.`idrolusuario` AS `idrolusuario`, `ru`.`idrol` AS `idrol`, `ru`.`idusuario` AS `idusuario`, `us`.`nombreusuario` AS `nombreusuario`, `ro`.`nombrerol` AS `nombrerol` FROM ((`seg_tblusuario` `us` join `seg_tblrolusuario` `ru`) join `seg_tblrol` `ro`) WHERE `us`.`idusuario` = `ru`.`idusuario` AND `ru`.`idrol` = `ro`.`idrol` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `seg_visusuario`
--
DROP TABLE IF EXISTS `seg_visusuario`;

CREATE  VIEW `seg_visusuario`  AS SELECT `u`.`idusuario` AS `idusuario`, `u`.`idestadousuario` AS `idestadousuario`, `u`.`idpersona` AS `idpersona`, `u`.`nombreusuario` AS `nombreusuario`, `u`.`idrol` AS `idrol`, `p`.`nombre` AS `nombre`, `p`.`paterno` AS `paterno`, `p`.`materno` AS `materno`, `u`.`idsucursal` AS `idsucursal` FROM (`seg_tblusuario` `u` join `per_tblpersona` `p`) WHERE `u`.`idpersona` = `p`.`idpersona` AND `u`.`estadoregistro` = 1 AND `p`.`estadoregistro` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `seg_visusuariologueado`
--
DROP TABLE IF EXISTS `seg_visusuariologueado`;

CREATE  VIEW `seg_visusuariologueado`  AS SELECT `seg_tblusuariologueado`.`idusuariologueado` AS `idusuariologueado`, `seg_tblusuariologueado`.`idusuario` AS `idusuario`, `seg_tblusuariologueado`.`idrolusuario` AS `idrolusuario`, `seg_tblusuariologueado`.`llave` AS `llave`, `seg_tblusuariologueado`.`idestadollave` AS `idestadollave`, `seg_tblusuariologueado`.`fecha` AS `fecha`, `seg_tblusuariologueado`.`direccionip` AS `direccionip`, `seg_tblusuariologueado`.`direccionhost` AS `direccionhost`, `seg_tblusuariologueado`.`direcciondest` AS `direcciondest`, `seg_tblusuariologueado`.`idsucursal` AS `idsucursal`, `seg_tblusuariologueado`.`fecharegistro` AS `fecharegistro`, `seg_tblusuariologueado`.`estadoregistro` AS `estadoregistro` FROM `seg_tblusuariologueado` WHERE `seg_tblusuariologueado`.`estadoregistro` = 1 ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cli_tblreserva`
--
ALTER TABLE `cli_tblreserva`
  ADD PRIMARY KEY (`idreserva`) USING BTREE,
  ADD KEY `idconsultorio` (`idconsultorio`) USING BTREE;

--
-- Indices de la tabla `per_tblasistencia`
--
ALTER TABLE `per_tblasistencia`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `userid` (`userid`,`fechahora`);

--
-- Indices de la tabla `res_tblreserva`
--
ALTER TABLE `res_tblreserva`
  ADD PRIMARY KEY (`idreserva`) USING BTREE,
  ADD KEY `idubicacion` (`idubicacion`) USING BTREE;

--
-- Indices de la tabla `res_tblubicacion`
--
ALTER TABLE `res_tblubicacion`
  ADD PRIMARY KEY (`idubicacion`) USING BTREE;

--
-- Indices de la tabla `res_tblubicacionhorario`
--
ALTER TABLE `res_tblubicacionhorario`
  ADD PRIMARY KEY (`idubicacionhorario`) USING BTREE;

--
-- Indices de la tabla `seg_tbllogusuario`
--
ALTER TABLE `seg_tbllogusuario`
  ADD PRIMARY KEY (`idlogusuario`) USING BTREE;

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cli_tblreserva`
--
ALTER TABLE `cli_tblreserva`
  MODIFY `idreserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=285512;

--
-- AUTO_INCREMENT de la tabla `per_tblasistencia`
--
ALTER TABLE `per_tblasistencia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=722173;

--
-- AUTO_INCREMENT de la tabla `res_tblreserva`
--
ALTER TABLE `res_tblreserva`
  MODIFY `idreserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=283825;

--
-- AUTO_INCREMENT de la tabla `res_tblubicacion`
--
ALTER TABLE `res_tblubicacion`
  MODIFY `idubicacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `res_tblubicacionhorario`
--
ALTER TABLE `res_tblubicacionhorario`
  MODIFY `idubicacionhorario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `seg_tbllogusuario`
--
ALTER TABLE `seg_tbllogusuario`
  MODIFY `idlogusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8133;
COMMIT;


