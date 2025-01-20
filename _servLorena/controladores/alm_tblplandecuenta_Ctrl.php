<?php
//gen 25/2/2024 22:21:42 dst
class alm_tblplandecuenta_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selplandecuenta($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selplandecuenta',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('alm_visplandecuenta' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addplandecuenta($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addplandecuenta',$f3)) {
$Tipo = 'C';
$idplandecuenta = is_null($f3->get('POST.pidplandecuenta')) ? 'T' : $f3->get('POST.pidplandecuenta');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idplandecuentapadre = is_null($f3->get('POST.pidplandecuentapadre')) ? 'T' : $f3->get('POST.pidplandecuentapadre');
$primario = is_null($f3->get('POST.pprimario')) ? 'T' : $f3->get('POST.pprimario');
$idtipoplandecuenta = is_null($f3->get('POST.pidtipoplandecuenta')) ? 'T' : $f3->get('POST.pidtipoplandecuenta');
$sql = "CALL alm_pagplandecuenta('" . $Tipo . "','". $idplandecuenta . "','". $descripcion . "','". $idplandecuentapadre . "','". $primario . "','". $idtipoplandecuenta. "'); "; 
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

public function getplandecuenta($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getplandecuenta',$f3)) {
$Tipo = 'R';
$idplandecuenta = is_null($f3->get('POST.pidplandecuenta')) ? 'T' : $f3->get('POST.pidplandecuenta');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idplandecuentapadre = is_null($f3->get('POST.pidplandecuentapadre')) ? 'T' : $f3->get('POST.pidplandecuentapadre');
$primario = is_null($f3->get('POST.pprimario')) ? 'T' : $f3->get('POST.pprimario');
$idtipoplandecuenta = is_null($f3->get('POST.pidtipoplandecuenta')) ? 'T' : $f3->get('POST.pidtipoplandecuenta');
$sql = "CALL alm_pagplandecuenta('" . $Tipo . "','". $idplandecuenta . "','". $descripcion . "','". $idplandecuentapadre . "','". $primario . "','". $idtipoplandecuenta. "'); "; 
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

public function updplandecuenta($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updplandecuenta',$f3)) {
$Tipo = 'U';
$idplandecuenta = is_null($f3->get('POST.pidplandecuenta')) ? 'T' : $f3->get('POST.pidplandecuenta');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idplandecuentapadre = is_null($f3->get('POST.pidplandecuentapadre')) ? 'T' : $f3->get('POST.pidplandecuentapadre');
$primario = is_null($f3->get('POST.pprimario')) ? 'T' : $f3->get('POST.pprimario');
$idtipoplandecuenta = is_null($f3->get('POST.pidtipoplandecuenta')) ? 'T' : $f3->get('POST.pidtipoplandecuenta');
$sql = "CALL alm_pagplandecuenta('" . $Tipo . "','". $idplandecuenta . "','". $descripcion . "','". $idplandecuentapadre . "','". $primario . "','". $idtipoplandecuenta. "'); "; 
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

public function papplandecuenta($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papplandecuenta',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idplandecuenta = is_null($f3->get('POST.pidplandecuenta')) ? 'T' : $f3->get('POST.pidplandecuenta');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$idplandecuentapadre = is_null($f3->get('POST.pidplandecuentapadre')) ? 'T' : $f3->get('POST.pidplandecuentapadre');
$primario = is_null($f3->get('POST.pprimario')) ? 'T' : $f3->get('POST.pprimario');
$idtipoplandecuenta = is_null($f3->get('POST.pidtipoplandecuenta')) ? 'T' : $f3->get('POST.pidtipoplandecuenta');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idplandecuenta . "','". $descripcion . "','". $idplandecuentapadre . "','". $primario . "','". $idtipoplandecuenta. "'); "; 
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
