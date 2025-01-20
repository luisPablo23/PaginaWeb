<?php
//gen 25/2/2024 22:21:41 dst
class alm_tblpagoventa_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selpagoventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selpagoventa',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('alm_vispagoventa' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addpagoventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addpagoventa',$f3)) {
$Tipo = 'C';
$idpagoventa = is_null($f3->get('POST.pidpagoventa')) ? 'T' : $f3->get('POST.pidpagoventa');
$idventa = is_null($f3->get('POST.pidventa')) ? 'T' : $f3->get('POST.pidventa');
$idingresoegreso = is_null($f3->get('POST.pidingresoegreso')) ? 'T' : $f3->get('POST.pidingresoegreso');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$monto = is_null($f3->get('POST.pmonto')) ? 'T' : $f3->get('POST.pmonto');
$idtipopago = is_null($f3->get('POST.pidtipopago')) ? 'T' : $f3->get('POST.pidtipopago');
$idcotizacionmoneda = is_null($f3->get('POST.pidcotizacionmoneda')) ? 'T' : $f3->get('POST.pidcotizacionmoneda');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$sql = "CALL alm_pagpagoventa('" . $Tipo . "','". $idpagoventa . "','". $idventa . "','". $idingresoegreso . "','". $fecha . "','". $descripcion . "','". $monto . "','". $idtipopago . "','". $idcotizacionmoneda . "','". $idusuario . "','". $idoficina. "'); "; 
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

public function getpagoventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getpagoventa',$f3)) {
$Tipo = 'R';
$idpagoventa = is_null($f3->get('POST.pidpagoventa')) ? 'T' : $f3->get('POST.pidpagoventa');
$idventa = is_null($f3->get('POST.pidventa')) ? 'T' : $f3->get('POST.pidventa');
$idingresoegreso = is_null($f3->get('POST.pidingresoegreso')) ? 'T' : $f3->get('POST.pidingresoegreso');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$monto = is_null($f3->get('POST.pmonto')) ? 'T' : $f3->get('POST.pmonto');
$idtipopago = is_null($f3->get('POST.pidtipopago')) ? 'T' : $f3->get('POST.pidtipopago');
$idcotizacionmoneda = is_null($f3->get('POST.pidcotizacionmoneda')) ? 'T' : $f3->get('POST.pidcotizacionmoneda');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$sql = "CALL alm_pagpagoventa('" . $Tipo . "','". $idpagoventa . "','". $idventa . "','". $idingresoegreso . "','". $fecha . "','". $descripcion . "','". $monto . "','". $idtipopago . "','". $idcotizacionmoneda . "','". $idusuario . "','". $idoficina. "'); "; 
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

public function updpagoventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updpagoventa',$f3)) {
$Tipo = 'U';
$idpagoventa = is_null($f3->get('POST.pidpagoventa')) ? 'T' : $f3->get('POST.pidpagoventa');
$idventa = is_null($f3->get('POST.pidventa')) ? 'T' : $f3->get('POST.pidventa');
$idingresoegreso = is_null($f3->get('POST.pidingresoegreso')) ? 'T' : $f3->get('POST.pidingresoegreso');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$monto = is_null($f3->get('POST.pmonto')) ? 'T' : $f3->get('POST.pmonto');
$idtipopago = is_null($f3->get('POST.pidtipopago')) ? 'T' : $f3->get('POST.pidtipopago');
$idcotizacionmoneda = is_null($f3->get('POST.pidcotizacionmoneda')) ? 'T' : $f3->get('POST.pidcotizacionmoneda');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$sql = "CALL alm_pagpagoventa('" . $Tipo . "','". $idpagoventa . "','". $idventa . "','". $idingresoegreso . "','". $fecha . "','". $descripcion . "','". $monto . "','". $idtipopago . "','". $idcotizacionmoneda . "','". $idusuario . "','". $idoficina. "'); "; 
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

public function pappagoventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'pappagoventa',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idpagoventa = is_null($f3->get('POST.pidpagoventa')) ? 'T' : $f3->get('POST.pidpagoventa');
$idventa = is_null($f3->get('POST.pidventa')) ? 'T' : $f3->get('POST.pidventa');
$idingresoegreso = is_null($f3->get('POST.pidingresoegreso')) ? 'T' : $f3->get('POST.pidingresoegreso');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$monto = is_null($f3->get('POST.pmonto')) ? 'T' : $f3->get('POST.pmonto');
$idtipopago = is_null($f3->get('POST.pidtipopago')) ? 'T' : $f3->get('POST.pidtipopago');
$idcotizacionmoneda = is_null($f3->get('POST.pidcotizacionmoneda')) ? 'T' : $f3->get('POST.pidcotizacionmoneda');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idpagoventa . "','". $idventa . "','". $idingresoegreso . "','". $fecha . "','". $descripcion . "','". $monto . "','". $idtipopago . "','". $idcotizacionmoneda . "','". $idusuario . "','". $idoficina. "'); "; 
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
