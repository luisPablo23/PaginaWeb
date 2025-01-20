<?php
//gen 25/2/2024 22:21:53 dst
class cli_tblreserva_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selreserva($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selreserva',$f3)) {
$pCampo0 = is_null($f3->get('POST.pCampo0')) ? 'T' : $f3->get('POST.pCampo0');
$pValor0 = is_null($f3->get('POST.pValor0')) ? '' : $f3->get('POST.pValor0');
$pCampo1 = is_null($f3->get('POST.pCampo1')) ? 'T' : $f3->get('POST.pCampo1');
$pValor1 = is_null($f3->get('POST.pValor1')) ? '' : $f3->get('POST.pValor1');
$pCampo2 = is_null($f3->get('POST.pCampo2')) ? 'T' : $f3->get('POST.pCampo2');
$pValor2 = is_null($f3->get('POST.pValor2')) ? '' : $f3->get('POST.pValor2');
$pCampo3 = is_null($f3->get('POST.pCampo3')) ? 'T' : $f3->get('POST.pCampo3');
$pValor3 = is_null($f3->get('POST.pValor3')) ? '' : $f3->get('POST.pValor3');
$pCampo4 = is_null($f3->get('POST.pCampo4')) ? 'T' : $f3->get('POST.pCampo4');
$pValor4 = is_null($f3->get('POST.pValor4')) ? '' : $f3->get('POST.pValor4');
$pCampo5 = is_null($f3->get('POST.pCampo5')) ? 'T' : $f3->get('POST.pCampo5');
$pValor5 = is_null($f3->get('POST.pValor5')) ? '' : $f3->get('POST.pValor5');
$pCampo6 = is_null($f3->get('POST.pCampo6')) ? 'T' : $f3->get('POST.pCampo6');
$pValor6 = is_null($f3->get('POST.pValor6')) ? '' : $f3->get('POST.pValor6');
$pCampo7 = is_null($f3->get('POST.pCampo7')) ? 'T' : $f3->get('POST.pCampo7');
$pValor7 = is_null($f3->get('POST.pValor7')) ? '' : $f3->get('POST.pValor7');
$oDav_Ctrol = new _Dav_Ctrol();
$Con = $oDav_Ctrol->fnDevuelveConsulta('cli_visreserva' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
$sql = $Con;
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function addreserva($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addreserva',$f3)) {
$Tipo = 'C';
$idreserva = is_null($f3->get('POST.pidreserva')) ? 'T' : $f3->get('POST.pidreserva');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$fechareserva = is_null($f3->get('POST.pfechareserva')) ? 'T' : $f3->get('POST.pfechareserva');
$horainicio = is_null($f3->get('POST.phorainicio')) ? 'T' : $f3->get('POST.phorainicio');
$horafin = is_null($f3->get('POST.phorafin')) ? 'T' : $f3->get('POST.phorafin');
$fechaevento = is_null($f3->get('POST.pfechaevento')) ? 'T' : $f3->get('POST.pfechaevento');
$idestadoreserva = is_null($f3->get('POST.pidestadoreserva')) ? 'T' : $f3->get('POST.pidestadoreserva');
$fechacancelacion = is_null($f3->get('POST.pfechacancelacion')) ? 'T' : $f3->get('POST.pfechacancelacion');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$observaciones = is_null($f3->get('POST.pobservaciones')) ? 'T' : $f3->get('POST.pobservaciones');
$carnetidentidad = is_null($f3->get('POST.pcarnetidentidad')) ? 'T' : $f3->get('POST.pcarnetidentidad');
$idtipodocumento = is_null($f3->get('POST.pidtipodocumento')) ? 'T' : $f3->get('POST.pidtipodocumento');
$nombre = is_null($f3->get('POST.pnombre')) ? 'T' : $f3->get('POST.pnombre');
$paterno = is_null($f3->get('POST.ppaterno')) ? 'T' : $f3->get('POST.ppaterno');
$materno = is_null($f3->get('POST.pmaterno')) ? 'T' : $f3->get('POST.pmaterno');
$celular = is_null($f3->get('POST.pcelular')) ? 'T' : $f3->get('POST.pcelular');
$email = is_null($f3->get('POST.pemail')) ? 'T' : $f3->get('POST.pemail');
$idconsultorio = is_null($f3->get('POST.pidconsultorio')) ? 'T' : $f3->get('POST.pidconsultorio');
$sql = "CALL cli_pagreserva('" . $Tipo . "','". $idreserva . "','". $idoficina . "','". $idespecialidad . "','". $fechareserva . "','". $horainicio . "','". $horafin . "','". $fechaevento . "','". $idestadoreserva . "','". $fechacancelacion . "','". $idusuario . "','". $observaciones . "','". $carnetidentidad . "','". $idtipodocumento . "','". $nombre . "','". $paterno . "','". $materno . "','". $celular . "','". $email . "','". $idconsultorio. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function getreserva($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getreserva',$f3)) {
$Tipo = 'R';
$idreserva = is_null($f3->get('POST.pidreserva')) ? 'T' : $f3->get('POST.pidreserva');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$fechareserva = is_null($f3->get('POST.pfechareserva')) ? 'T' : $f3->get('POST.pfechareserva');
$horainicio = is_null($f3->get('POST.phorainicio')) ? 'T' : $f3->get('POST.phorainicio');
$horafin = is_null($f3->get('POST.phorafin')) ? 'T' : $f3->get('POST.phorafin');
$fechaevento = is_null($f3->get('POST.pfechaevento')) ? 'T' : $f3->get('POST.pfechaevento');
$idestadoreserva = is_null($f3->get('POST.pidestadoreserva')) ? 'T' : $f3->get('POST.pidestadoreserva');
$fechacancelacion = is_null($f3->get('POST.pfechacancelacion')) ? 'T' : $f3->get('POST.pfechacancelacion');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$observaciones = is_null($f3->get('POST.pobservaciones')) ? 'T' : $f3->get('POST.pobservaciones');
$carnetidentidad = is_null($f3->get('POST.pcarnetidentidad')) ? 'T' : $f3->get('POST.pcarnetidentidad');
$idtipodocumento = is_null($f3->get('POST.pidtipodocumento')) ? 'T' : $f3->get('POST.pidtipodocumento');
$nombre = is_null($f3->get('POST.pnombre')) ? 'T' : $f3->get('POST.pnombre');
$paterno = is_null($f3->get('POST.ppaterno')) ? 'T' : $f3->get('POST.ppaterno');
$materno = is_null($f3->get('POST.pmaterno')) ? 'T' : $f3->get('POST.pmaterno');
$celular = is_null($f3->get('POST.pcelular')) ? 'T' : $f3->get('POST.pcelular');
$email = is_null($f3->get('POST.pemail')) ? 'T' : $f3->get('POST.pemail');
$idconsultorio = is_null($f3->get('POST.pidconsultorio')) ? 'T' : $f3->get('POST.pidconsultorio');
$sql = "CALL cli_pagreserva('" . $Tipo . "','". $idreserva . "','". $idoficina . "','". $idespecialidad . "','". $fechareserva . "','". $horainicio . "','". $horafin . "','". $fechaevento . "','". $idestadoreserva . "','". $fechacancelacion . "','". $idusuario . "','". $observaciones . "','". $carnetidentidad . "','". $idtipodocumento . "','". $nombre . "','". $paterno . "','". $materno . "','". $celular . "','". $email . "','". $idconsultorio. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function updreserva($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updreserva',$f3)) {
$Tipo = 'U';
$idreserva = is_null($f3->get('POST.pidreserva')) ? 'T' : $f3->get('POST.pidreserva');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$fechareserva = is_null($f3->get('POST.pfechareserva')) ? 'T' : $f3->get('POST.pfechareserva');
$horainicio = is_null($f3->get('POST.phorainicio')) ? 'T' : $f3->get('POST.phorainicio');
$horafin = is_null($f3->get('POST.phorafin')) ? 'T' : $f3->get('POST.phorafin');
$fechaevento = is_null($f3->get('POST.pfechaevento')) ? 'T' : $f3->get('POST.pfechaevento');
$idestadoreserva = is_null($f3->get('POST.pidestadoreserva')) ? 'T' : $f3->get('POST.pidestadoreserva');
$fechacancelacion = is_null($f3->get('POST.pfechacancelacion')) ? 'T' : $f3->get('POST.pfechacancelacion');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$observaciones = is_null($f3->get('POST.pobservaciones')) ? 'T' : $f3->get('POST.pobservaciones');
$carnetidentidad = is_null($f3->get('POST.pcarnetidentidad')) ? 'T' : $f3->get('POST.pcarnetidentidad');
$idtipodocumento = is_null($f3->get('POST.pidtipodocumento')) ? 'T' : $f3->get('POST.pidtipodocumento');
$nombre = is_null($f3->get('POST.pnombre')) ? 'T' : $f3->get('POST.pnombre');
$paterno = is_null($f3->get('POST.ppaterno')) ? 'T' : $f3->get('POST.ppaterno');
$materno = is_null($f3->get('POST.pmaterno')) ? 'T' : $f3->get('POST.pmaterno');
$celular = is_null($f3->get('POST.pcelular')) ? 'T' : $f3->get('POST.pcelular');
$email = is_null($f3->get('POST.pemail')) ? 'T' : $f3->get('POST.pemail');
$idconsultorio = is_null($f3->get('POST.pidconsultorio')) ? 'T' : $f3->get('POST.pidconsultorio');
$sql = "CALL cli_pagreserva('" . $Tipo . "','". $idreserva . "','". $idoficina . "','". $idespecialidad . "','". $fechareserva . "','". $horainicio . "','". $horafin . "','". $fechaevento . "','". $idestadoreserva . "','". $fechacancelacion . "','". $idusuario . "','". $observaciones . "','". $carnetidentidad . "','". $idtipodocumento . "','". $nombre . "','". $paterno . "','". $materno . "','". $celular . "','". $email . "','". $idconsultorio. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function papreserva($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papreserva',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idreserva = is_null($f3->get('POST.pidreserva')) ? 'T' : $f3->get('POST.pidreserva');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$fechareserva = is_null($f3->get('POST.pfechareserva')) ? 'T' : $f3->get('POST.pfechareserva');
$horainicio = is_null($f3->get('POST.phorainicio')) ? 'T' : $f3->get('POST.phorainicio');
$horafin = is_null($f3->get('POST.phorafin')) ? 'T' : $f3->get('POST.phorafin');
$fechaevento = is_null($f3->get('POST.pfechaevento')) ? 'T' : $f3->get('POST.pfechaevento');
$idestadoreserva = is_null($f3->get('POST.pidestadoreserva')) ? 'T' : $f3->get('POST.pidestadoreserva');
$fechacancelacion = is_null($f3->get('POST.pfechacancelacion')) ? 'T' : $f3->get('POST.pfechacancelacion');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$observaciones = is_null($f3->get('POST.pobservaciones')) ? 'T' : $f3->get('POST.pobservaciones');
$carnetidentidad = is_null($f3->get('POST.pcarnetidentidad')) ? 'T' : $f3->get('POST.pcarnetidentidad');
$idtipodocumento = is_null($f3->get('POST.pidtipodocumento')) ? 'T' : $f3->get('POST.pidtipodocumento');
$nombre = is_null($f3->get('POST.pnombre')) ? 'T' : $f3->get('POST.pnombre');
$paterno = is_null($f3->get('POST.ppaterno')) ? 'T' : $f3->get('POST.ppaterno');
$materno = is_null($f3->get('POST.pmaterno')) ? 'T' : $f3->get('POST.pmaterno');
$celular = is_null($f3->get('POST.pcelular')) ? 'T' : $f3->get('POST.pcelular');
$email = is_null($f3->get('POST.pemail')) ? 'T' : $f3->get('POST.pemail');
$idconsultorio = is_null($f3->get('POST.pidconsultorio')) ? 'T' : $f3->get('POST.pidconsultorio');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idreserva . "','". $idoficina . "','". $idespecialidad . "','". $fechareserva . "','". $horainicio . "','". $horafin . "','". $fechaevento . "','". $idestadoreserva . "','". $fechacancelacion . "','". $idusuario . "','". $observaciones . "','". $carnetidentidad . "','". $idtipodocumento . "','". $nombre . "','". $paterno . "','". $materno . "','". $celular . "','". $email . "','". $idconsultorio. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}
}
