<?php
//gen 25/2/2024 22:21:34 dst
class alm_tblcotizacion_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selcotizacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selcotizacion',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('alm_viscotizacion' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addcotizacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addcotizacion',$f3)) {
$Tipo = 'C';
$idcotizacion = is_null($f3->get('POST.pidcotizacion')) ? 'T' : $f3->get('POST.pidcotizacion');
$numerocotizacion = is_null($f3->get('POST.pnumerocotizacion')) ? 'T' : $f3->get('POST.pnumerocotizacion');
$nombrecotizacion = is_null($f3->get('POST.pnombrecotizacion')) ? 'T' : $f3->get('POST.pnombrecotizacion');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idcliente = is_null($f3->get('POST.pidcliente')) ? 'T' : $f3->get('POST.pidcliente');
$fechacotizacion = is_null($f3->get('POST.pfechacotizacion')) ? 'T' : $f3->get('POST.pfechacotizacion');
$tipocotizacion = is_null($f3->get('POST.ptipocotizacion')) ? 'T' : $f3->get('POST.ptipocotizacion');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$descuento = is_null($f3->get('POST.pdescuento')) ? 'T' : $f3->get('POST.pdescuento');
$total = is_null($f3->get('POST.ptotal')) ? 'T' : $f3->get('POST.ptotal');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idestadocotizacion = is_null($f3->get('POST.pidestadocotizacion')) ? 'T' : $f3->get('POST.pidestadocotizacion');
$pagado = is_null($f3->get('POST.ppagado')) ? 'T' : $f3->get('POST.ppagado');
$cambio = is_null($f3->get('POST.pcambio')) ? 'T' : $f3->get('POST.pcambio');
$idusuarioresponsable = is_null($f3->get('POST.pidusuarioresponsable')) ? 'T' : $f3->get('POST.pidusuarioresponsable');
$idaperturacierrecaja = is_null($f3->get('POST.pidaperturacierrecaja')) ? 'T' : $f3->get('POST.pidaperturacierrecaja');
$sql = "CALL alm_pagcotizacion('" . $Tipo . "','". $idcotizacion . "','". $numerocotizacion . "','". $nombrecotizacion . "','". $titulo . "','". $idusuario . "','". $idcliente . "','". $fechacotizacion . "','". $tipocotizacion . "','". $idoficina . "','". $subtotal . "','". $descuento . "','". $total . "','". $idmoneda . "','". $descripcion . "','". $idestadocotizacion . "','". $pagado . "','". $cambio . "','". $idusuarioresponsable . "','". $idaperturacierrecaja. "'); "; 
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

public function getcotizacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getcotizacion',$f3)) {
$Tipo = 'R';
$idcotizacion = is_null($f3->get('POST.pidcotizacion')) ? 'T' : $f3->get('POST.pidcotizacion');
$numerocotizacion = is_null($f3->get('POST.pnumerocotizacion')) ? 'T' : $f3->get('POST.pnumerocotizacion');
$nombrecotizacion = is_null($f3->get('POST.pnombrecotizacion')) ? 'T' : $f3->get('POST.pnombrecotizacion');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idcliente = is_null($f3->get('POST.pidcliente')) ? 'T' : $f3->get('POST.pidcliente');
$fechacotizacion = is_null($f3->get('POST.pfechacotizacion')) ? 'T' : $f3->get('POST.pfechacotizacion');
$tipocotizacion = is_null($f3->get('POST.ptipocotizacion')) ? 'T' : $f3->get('POST.ptipocotizacion');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$descuento = is_null($f3->get('POST.pdescuento')) ? 'T' : $f3->get('POST.pdescuento');
$total = is_null($f3->get('POST.ptotal')) ? 'T' : $f3->get('POST.ptotal');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idestadocotizacion = is_null($f3->get('POST.pidestadocotizacion')) ? 'T' : $f3->get('POST.pidestadocotizacion');
$pagado = is_null($f3->get('POST.ppagado')) ? 'T' : $f3->get('POST.ppagado');
$cambio = is_null($f3->get('POST.pcambio')) ? 'T' : $f3->get('POST.pcambio');
$idusuarioresponsable = is_null($f3->get('POST.pidusuarioresponsable')) ? 'T' : $f3->get('POST.pidusuarioresponsable');
$idaperturacierrecaja = is_null($f3->get('POST.pidaperturacierrecaja')) ? 'T' : $f3->get('POST.pidaperturacierrecaja');
$sql = "CALL alm_pagcotizacion('" . $Tipo . "','". $idcotizacion . "','". $numerocotizacion . "','". $nombrecotizacion . "','". $titulo . "','". $idusuario . "','". $idcliente . "','". $fechacotizacion . "','". $tipocotizacion . "','". $idoficina . "','". $subtotal . "','". $descuento . "','". $total . "','". $idmoneda . "','". $descripcion . "','". $idestadocotizacion . "','". $pagado . "','". $cambio . "','". $idusuarioresponsable . "','". $idaperturacierrecaja. "'); "; 
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

public function updcotizacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updcotizacion',$f3)) {
$Tipo = 'U';
$idcotizacion = is_null($f3->get('POST.pidcotizacion')) ? 'T' : $f3->get('POST.pidcotizacion');
$numerocotizacion = is_null($f3->get('POST.pnumerocotizacion')) ? 'T' : $f3->get('POST.pnumerocotizacion');
$nombrecotizacion = is_null($f3->get('POST.pnombrecotizacion')) ? 'T' : $f3->get('POST.pnombrecotizacion');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idcliente = is_null($f3->get('POST.pidcliente')) ? 'T' : $f3->get('POST.pidcliente');
$fechacotizacion = is_null($f3->get('POST.pfechacotizacion')) ? 'T' : $f3->get('POST.pfechacotizacion');
$tipocotizacion = is_null($f3->get('POST.ptipocotizacion')) ? 'T' : $f3->get('POST.ptipocotizacion');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$descuento = is_null($f3->get('POST.pdescuento')) ? 'T' : $f3->get('POST.pdescuento');
$total = is_null($f3->get('POST.ptotal')) ? 'T' : $f3->get('POST.ptotal');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idestadocotizacion = is_null($f3->get('POST.pidestadocotizacion')) ? 'T' : $f3->get('POST.pidestadocotizacion');
$pagado = is_null($f3->get('POST.ppagado')) ? 'T' : $f3->get('POST.ppagado');
$cambio = is_null($f3->get('POST.pcambio')) ? 'T' : $f3->get('POST.pcambio');
$idusuarioresponsable = is_null($f3->get('POST.pidusuarioresponsable')) ? 'T' : $f3->get('POST.pidusuarioresponsable');
$idaperturacierrecaja = is_null($f3->get('POST.pidaperturacierrecaja')) ? 'T' : $f3->get('POST.pidaperturacierrecaja');
$sql = "CALL alm_pagcotizacion('" . $Tipo . "','". $idcotizacion . "','". $numerocotizacion . "','". $nombrecotizacion . "','". $titulo . "','". $idusuario . "','". $idcliente . "','". $fechacotizacion . "','". $tipocotizacion . "','". $idoficina . "','". $subtotal . "','". $descuento . "','". $total . "','". $idmoneda . "','". $descripcion . "','". $idestadocotizacion . "','". $pagado . "','". $cambio . "','". $idusuarioresponsable . "','". $idaperturacierrecaja. "'); "; 
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

public function papcotizacion($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papcotizacion',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idcotizacion = is_null($f3->get('POST.pidcotizacion')) ? 'T' : $f3->get('POST.pidcotizacion');
$numerocotizacion = is_null($f3->get('POST.pnumerocotizacion')) ? 'T' : $f3->get('POST.pnumerocotizacion');
$nombrecotizacion = is_null($f3->get('POST.pnombrecotizacion')) ? 'T' : $f3->get('POST.pnombrecotizacion');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idcliente = is_null($f3->get('POST.pidcliente')) ? 'T' : $f3->get('POST.pidcliente');
$fechacotizacion = is_null($f3->get('POST.pfechacotizacion')) ? 'T' : $f3->get('POST.pfechacotizacion');
$tipocotizacion = is_null($f3->get('POST.ptipocotizacion')) ? 'T' : $f3->get('POST.ptipocotizacion');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$descuento = is_null($f3->get('POST.pdescuento')) ? 'T' : $f3->get('POST.pdescuento');
$total = is_null($f3->get('POST.ptotal')) ? 'T' : $f3->get('POST.ptotal');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idestadocotizacion = is_null($f3->get('POST.pidestadocotizacion')) ? 'T' : $f3->get('POST.pidestadocotizacion');
$pagado = is_null($f3->get('POST.ppagado')) ? 'T' : $f3->get('POST.ppagado');
$cambio = is_null($f3->get('POST.pcambio')) ? 'T' : $f3->get('POST.pcambio');
$idusuarioresponsable = is_null($f3->get('POST.pidusuarioresponsable')) ? 'T' : $f3->get('POST.pidusuarioresponsable');
$idaperturacierrecaja = is_null($f3->get('POST.pidaperturacierrecaja')) ? 'T' : $f3->get('POST.pidaperturacierrecaja');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idcotizacion . "','". $numerocotizacion . "','". $nombrecotizacion . "','". $titulo . "','". $idusuario . "','". $idcliente . "','". $fechacotizacion . "','". $tipocotizacion . "','". $idoficina . "','". $subtotal . "','". $descuento . "','". $total . "','". $idmoneda . "','". $descripcion . "','". $idestadocotizacion . "','". $pagado . "','". $cambio . "','". $idusuarioresponsable . "','". $idaperturacierrecaja. "'); "; 
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
