<?php
//gen 25/2/2024 22:21:47 dst
class alm_tblventa_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selventa',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('alm_visventa' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addventa',$f3)) {
$Tipo = 'C';
$idventa = is_null($f3->get('POST.pidventa')) ? 'T' : $f3->get('POST.pidventa');
$numeroventa = is_null($f3->get('POST.pnumeroventa')) ? 'T' : $f3->get('POST.pnumeroventa');
$nombreventa = is_null($f3->get('POST.pnombreventa')) ? 'T' : $f3->get('POST.pnombreventa');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idcliente = is_null($f3->get('POST.pidcliente')) ? 'T' : $f3->get('POST.pidcliente');
$fechaventa = is_null($f3->get('POST.pfechaventa')) ? 'T' : $f3->get('POST.pfechaventa');
$tipoventa = is_null($f3->get('POST.ptipoventa')) ? 'T' : $f3->get('POST.ptipoventa');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$descuento = is_null($f3->get('POST.pdescuento')) ? 'T' : $f3->get('POST.pdescuento');
$total = is_null($f3->get('POST.ptotal')) ? 'T' : $f3->get('POST.ptotal');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idestadoventa = is_null($f3->get('POST.pidestadoventa')) ? 'T' : $f3->get('POST.pidestadoventa');
$pagado = is_null($f3->get('POST.ppagado')) ? 'T' : $f3->get('POST.ppagado');
$cambio = is_null($f3->get('POST.pcambio')) ? 'T' : $f3->get('POST.pcambio');
$idusuarioresponsable = is_null($f3->get('POST.pidusuarioresponsable')) ? 'T' : $f3->get('POST.pidusuarioresponsable');
$idaperturacierrecaja = is_null($f3->get('POST.pidaperturacierrecaja')) ? 'T' : $f3->get('POST.pidaperturacierrecaja');
$sql = "CALL alm_pagventa('" . $Tipo . "','". $idventa . "','". $numeroventa . "','". $nombreventa . "','". $titulo . "','". $idusuario . "','". $idcliente . "','". $fechaventa . "','". $tipoventa . "','". $idoficina . "','". $subtotal . "','". $descuento . "','". $total . "','". $idmoneda . "','". $descripcion . "','". $idestadoventa . "','". $pagado . "','". $cambio . "','". $idusuarioresponsable . "','". $idaperturacierrecaja. "'); "; 
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

public function getventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getventa',$f3)) {
$Tipo = 'R';
$idventa = is_null($f3->get('POST.pidventa')) ? 'T' : $f3->get('POST.pidventa');
$numeroventa = is_null($f3->get('POST.pnumeroventa')) ? 'T' : $f3->get('POST.pnumeroventa');
$nombreventa = is_null($f3->get('POST.pnombreventa')) ? 'T' : $f3->get('POST.pnombreventa');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idcliente = is_null($f3->get('POST.pidcliente')) ? 'T' : $f3->get('POST.pidcliente');
$fechaventa = is_null($f3->get('POST.pfechaventa')) ? 'T' : $f3->get('POST.pfechaventa');
$tipoventa = is_null($f3->get('POST.ptipoventa')) ? 'T' : $f3->get('POST.ptipoventa');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$descuento = is_null($f3->get('POST.pdescuento')) ? 'T' : $f3->get('POST.pdescuento');
$total = is_null($f3->get('POST.ptotal')) ? 'T' : $f3->get('POST.ptotal');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idestadoventa = is_null($f3->get('POST.pidestadoventa')) ? 'T' : $f3->get('POST.pidestadoventa');
$pagado = is_null($f3->get('POST.ppagado')) ? 'T' : $f3->get('POST.ppagado');
$cambio = is_null($f3->get('POST.pcambio')) ? 'T' : $f3->get('POST.pcambio');
$idusuarioresponsable = is_null($f3->get('POST.pidusuarioresponsable')) ? 'T' : $f3->get('POST.pidusuarioresponsable');
$idaperturacierrecaja = is_null($f3->get('POST.pidaperturacierrecaja')) ? 'T' : $f3->get('POST.pidaperturacierrecaja');
$sql = "CALL alm_pagventa('" . $Tipo . "','". $idventa . "','". $numeroventa . "','". $nombreventa . "','". $titulo . "','". $idusuario . "','". $idcliente . "','". $fechaventa . "','". $tipoventa . "','". $idoficina . "','". $subtotal . "','". $descuento . "','". $total . "','". $idmoneda . "','". $descripcion . "','". $idestadoventa . "','". $pagado . "','". $cambio . "','". $idusuarioresponsable . "','". $idaperturacierrecaja. "'); "; 
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

public function updventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updventa',$f3)) {
$Tipo = 'U';
$idventa = is_null($f3->get('POST.pidventa')) ? 'T' : $f3->get('POST.pidventa');
$numeroventa = is_null($f3->get('POST.pnumeroventa')) ? 'T' : $f3->get('POST.pnumeroventa');
$nombreventa = is_null($f3->get('POST.pnombreventa')) ? 'T' : $f3->get('POST.pnombreventa');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idcliente = is_null($f3->get('POST.pidcliente')) ? 'T' : $f3->get('POST.pidcliente');
$fechaventa = is_null($f3->get('POST.pfechaventa')) ? 'T' : $f3->get('POST.pfechaventa');
$tipoventa = is_null($f3->get('POST.ptipoventa')) ? 'T' : $f3->get('POST.ptipoventa');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$descuento = is_null($f3->get('POST.pdescuento')) ? 'T' : $f3->get('POST.pdescuento');
$total = is_null($f3->get('POST.ptotal')) ? 'T' : $f3->get('POST.ptotal');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idestadoventa = is_null($f3->get('POST.pidestadoventa')) ? 'T' : $f3->get('POST.pidestadoventa');
$pagado = is_null($f3->get('POST.ppagado')) ? 'T' : $f3->get('POST.ppagado');
$cambio = is_null($f3->get('POST.pcambio')) ? 'T' : $f3->get('POST.pcambio');
$idusuarioresponsable = is_null($f3->get('POST.pidusuarioresponsable')) ? 'T' : $f3->get('POST.pidusuarioresponsable');
$idaperturacierrecaja = is_null($f3->get('POST.pidaperturacierrecaja')) ? 'T' : $f3->get('POST.pidaperturacierrecaja');
$sql = "CALL alm_pagventa('" . $Tipo . "','". $idventa . "','". $numeroventa . "','". $nombreventa . "','". $titulo . "','". $idusuario . "','". $idcliente . "','". $fechaventa . "','". $tipoventa . "','". $idoficina . "','". $subtotal . "','". $descuento . "','". $total . "','". $idmoneda . "','". $descripcion . "','". $idestadoventa . "','". $pagado . "','". $cambio . "','". $idusuarioresponsable . "','". $idaperturacierrecaja. "'); "; 
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

public function papventa($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papventa',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idventa = is_null($f3->get('POST.pidventa')) ? 'T' : $f3->get('POST.pidventa');
$numeroventa = is_null($f3->get('POST.pnumeroventa')) ? 'T' : $f3->get('POST.pnumeroventa');
$nombreventa = is_null($f3->get('POST.pnombreventa')) ? 'T' : $f3->get('POST.pnombreventa');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idcliente = is_null($f3->get('POST.pidcliente')) ? 'T' : $f3->get('POST.pidcliente');
$fechaventa = is_null($f3->get('POST.pfechaventa')) ? 'T' : $f3->get('POST.pfechaventa');
$tipoventa = is_null($f3->get('POST.ptipoventa')) ? 'T' : $f3->get('POST.ptipoventa');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$descuento = is_null($f3->get('POST.pdescuento')) ? 'T' : $f3->get('POST.pdescuento');
$total = is_null($f3->get('POST.ptotal')) ? 'T' : $f3->get('POST.ptotal');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idestadoventa = is_null($f3->get('POST.pidestadoventa')) ? 'T' : $f3->get('POST.pidestadoventa');
$pagado = is_null($f3->get('POST.ppagado')) ? 'T' : $f3->get('POST.ppagado');
$cambio = is_null($f3->get('POST.pcambio')) ? 'T' : $f3->get('POST.pcambio');
$idusuarioresponsable = is_null($f3->get('POST.pidusuarioresponsable')) ? 'T' : $f3->get('POST.pidusuarioresponsable');
$idaperturacierrecaja = is_null($f3->get('POST.pidaperturacierrecaja')) ? 'T' : $f3->get('POST.pidaperturacierrecaja');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idventa . "','". $numeroventa . "','". $nombreventa . "','". $titulo . "','". $idusuario . "','". $idcliente . "','". $fechaventa . "','". $tipoventa . "','". $idoficina . "','". $subtotal . "','". $descuento . "','". $total . "','". $idmoneda . "','". $descripcion . "','". $idestadoventa . "','". $pagado . "','". $cambio . "','". $idusuarioresponsable . "','". $idaperturacierrecaja. "'); "; 
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
