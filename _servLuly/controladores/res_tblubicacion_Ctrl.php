<?php
//gen 25/2/2024 22:22:06 dst
class res_tblubicacion_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selubicacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selubicacion',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('res_visubicacion' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addubicacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addubicacion',$f3)) {
$Tipo = 'C';
$idubicacion = is_null($f3->get('POST.pidubicacion')) ? 'T' : $f3->get('POST.pidubicacion');
$idtramitegrupo = is_null($f3->get('POST.pidtramitegrupo')) ? 'T' : $f3->get('POST.pidtramitegrupo');
$idconsultorio = is_null($f3->get('POST.pidconsultorio')) ? 'T' : $f3->get('POST.pidconsultorio');
$tiempoestimado = is_null($f3->get('POST.ptiempoestimado')) ? 'T' : $f3->get('POST.ptiempoestimado');
$numeroubicacion = is_null($f3->get('POST.pnumeroubicacion')) ? 'T' : $f3->get('POST.pnumeroubicacion');
$nombreubicacion = is_null($f3->get('POST.pnombreubicacion')) ? 'T' : $f3->get('POST.pnombreubicacion');
$servicio = is_null($f3->get('POST.pservicio')) ? 'T' : $f3->get('POST.pservicio');
$programarcita = is_null($f3->get('POST.pprogramarcita')) ? 'T' : $f3->get('POST.pprogramarcita');
$sql = "CALL res_pagubicacion('" . $Tipo . "','". $idubicacion . "','". $idtramitegrupo . "','". $idconsultorio . "','". $tiempoestimado . "','". $numeroubicacion . "','". $nombreubicacion . "','". $servicio . "','". $programarcita. "'); "; 
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

public function getubicacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getubicacion',$f3)) {
$Tipo = 'R';
$idubicacion = is_null($f3->get('POST.pidubicacion')) ? 'T' : $f3->get('POST.pidubicacion');
$idtramitegrupo = is_null($f3->get('POST.pidtramitegrupo')) ? 'T' : $f3->get('POST.pidtramitegrupo');
$idconsultorio = is_null($f3->get('POST.pidconsultorio')) ? 'T' : $f3->get('POST.pidconsultorio');
$tiempoestimado = is_null($f3->get('POST.ptiempoestimado')) ? 'T' : $f3->get('POST.ptiempoestimado');
$numeroubicacion = is_null($f3->get('POST.pnumeroubicacion')) ? 'T' : $f3->get('POST.pnumeroubicacion');
$nombreubicacion = is_null($f3->get('POST.pnombreubicacion')) ? 'T' : $f3->get('POST.pnombreubicacion');
$servicio = is_null($f3->get('POST.pservicio')) ? 'T' : $f3->get('POST.pservicio');
$programarcita = is_null($f3->get('POST.pprogramarcita')) ? 'T' : $f3->get('POST.pprogramarcita');
$sql = "CALL res_pagubicacion('" . $Tipo . "','". $idubicacion . "','". $idtramitegrupo . "','". $idconsultorio . "','". $tiempoestimado . "','". $numeroubicacion . "','". $nombreubicacion . "','". $servicio . "','". $programarcita. "'); "; 
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

public function updubicacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updubicacion',$f3)) {
$Tipo = 'U';
$idubicacion = is_null($f3->get('POST.pidubicacion')) ? 'T' : $f3->get('POST.pidubicacion');
$idtramitegrupo = is_null($f3->get('POST.pidtramitegrupo')) ? 'T' : $f3->get('POST.pidtramitegrupo');
$idconsultorio = is_null($f3->get('POST.pidconsultorio')) ? 'T' : $f3->get('POST.pidconsultorio');
$tiempoestimado = is_null($f3->get('POST.ptiempoestimado')) ? 'T' : $f3->get('POST.ptiempoestimado');
$numeroubicacion = is_null($f3->get('POST.pnumeroubicacion')) ? 'T' : $f3->get('POST.pnumeroubicacion');
$nombreubicacion = is_null($f3->get('POST.pnombreubicacion')) ? 'T' : $f3->get('POST.pnombreubicacion');
$servicio = is_null($f3->get('POST.pservicio')) ? 'T' : $f3->get('POST.pservicio');
$programarcita = is_null($f3->get('POST.pprogramarcita')) ? 'T' : $f3->get('POST.pprogramarcita');
$sql = "CALL res_pagubicacion('" . $Tipo . "','". $idubicacion . "','". $idtramitegrupo . "','". $idconsultorio . "','". $tiempoestimado . "','". $numeroubicacion . "','". $nombreubicacion . "','". $servicio . "','". $programarcita. "'); "; 
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

public function papubicacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papubicacion',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idubicacion = is_null($f3->get('POST.pidubicacion')) ? 'T' : $f3->get('POST.pidubicacion');
$idtramitegrupo = is_null($f3->get('POST.pidtramitegrupo')) ? 'T' : $f3->get('POST.pidtramitegrupo');
$idconsultorio = is_null($f3->get('POST.pidconsultorio')) ? 'T' : $f3->get('POST.pidconsultorio');
$tiempoestimado = is_null($f3->get('POST.ptiempoestimado')) ? 'T' : $f3->get('POST.ptiempoestimado');
$numeroubicacion = is_null($f3->get('POST.pnumeroubicacion')) ? 'T' : $f3->get('POST.pnumeroubicacion');
$nombreubicacion = is_null($f3->get('POST.pnombreubicacion')) ? 'T' : $f3->get('POST.pnombreubicacion');
$servicio = is_null($f3->get('POST.pservicio')) ? 'T' : $f3->get('POST.pservicio');
$programarcita = is_null($f3->get('POST.pprogramarcita')) ? 'T' : $f3->get('POST.pprogramarcita');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idubicacion . "','". $idtramitegrupo . "','". $idconsultorio . "','". $tiempoestimado . "','". $numeroubicacion . "','". $nombreubicacion . "','". $servicio . "','". $programarcita. "'); "; 
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
