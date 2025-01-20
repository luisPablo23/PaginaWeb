<?php
//gen 25/2/2024 22:21:58 dst
class res_tblhorariogeneral_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selhorariogeneral($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selhorariogeneral',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('res_vishorariogeneral' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addhorariogeneral($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addhorariogeneral',$f3)) {
$Tipo = 'C';
$idhorariogeneral = is_null($f3->get('POST.pidhorariogeneral')) ? 'T' : $f3->get('POST.pidhorariogeneral');
$idhorario = is_null($f3->get('POST.pidhorario')) ? 'T' : $f3->get('POST.pidhorario');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$diasemana = is_null($f3->get('POST.pdiasemana')) ? 'T' : $f3->get('POST.pdiasemana');
$idferiado = is_null($f3->get('POST.pidferiado')) ? 'T' : $f3->get('POST.pidferiado');
$idtipofecha = is_null($f3->get('POST.pidtipofecha')) ? 'T' : $f3->get('POST.pidtipofecha');
$sql = "CALL res_paghorariogeneral('" . $Tipo . "','". $idhorariogeneral . "','". $idhorario . "','". $fecha . "','". $diasemana . "','". $idferiado . "','". $idtipofecha. "'); "; 
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

public function gethorariogeneral($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'gethorariogeneral',$f3)) {
$Tipo = 'R';
$idhorariogeneral = is_null($f3->get('POST.pidhorariogeneral')) ? 'T' : $f3->get('POST.pidhorariogeneral');
$idhorario = is_null($f3->get('POST.pidhorario')) ? 'T' : $f3->get('POST.pidhorario');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$diasemana = is_null($f3->get('POST.pdiasemana')) ? 'T' : $f3->get('POST.pdiasemana');
$idferiado = is_null($f3->get('POST.pidferiado')) ? 'T' : $f3->get('POST.pidferiado');
$idtipofecha = is_null($f3->get('POST.pidtipofecha')) ? 'T' : $f3->get('POST.pidtipofecha');
$sql = "CALL res_paghorariogeneral('" . $Tipo . "','". $idhorariogeneral . "','". $idhorario . "','". $fecha . "','". $diasemana . "','". $idferiado . "','". $idtipofecha. "'); "; 
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

public function updhorariogeneral($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updhorariogeneral',$f3)) {
$Tipo = 'U';
$idhorariogeneral = is_null($f3->get('POST.pidhorariogeneral')) ? 'T' : $f3->get('POST.pidhorariogeneral');
$idhorario = is_null($f3->get('POST.pidhorario')) ? 'T' : $f3->get('POST.pidhorario');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$diasemana = is_null($f3->get('POST.pdiasemana')) ? 'T' : $f3->get('POST.pdiasemana');
$idferiado = is_null($f3->get('POST.pidferiado')) ? 'T' : $f3->get('POST.pidferiado');
$idtipofecha = is_null($f3->get('POST.pidtipofecha')) ? 'T' : $f3->get('POST.pidtipofecha');
$sql = "CALL res_paghorariogeneral('" . $Tipo . "','". $idhorariogeneral . "','". $idhorario . "','". $fecha . "','". $diasemana . "','". $idferiado . "','". $idtipofecha. "'); "; 
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

public function paphorariogeneral($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'paphorariogeneral',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idhorariogeneral = is_null($f3->get('POST.pidhorariogeneral')) ? 'T' : $f3->get('POST.pidhorariogeneral');
$idhorario = is_null($f3->get('POST.pidhorario')) ? 'T' : $f3->get('POST.pidhorario');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$diasemana = is_null($f3->get('POST.pdiasemana')) ? 'T' : $f3->get('POST.pdiasemana');
$idferiado = is_null($f3->get('POST.pidferiado')) ? 'T' : $f3->get('POST.pidferiado');
$idtipofecha = is_null($f3->get('POST.pidtipofecha')) ? 'T' : $f3->get('POST.pidtipofecha');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idhorariogeneral . "','". $idhorario . "','". $fecha . "','". $diasemana . "','". $idferiado . "','". $idtipofecha. "'); "; 
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
