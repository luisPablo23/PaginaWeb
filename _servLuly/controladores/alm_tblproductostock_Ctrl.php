<?php
//gen 25/2/2024 22:21:45 dst
class alm_tblproductostock_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selproductostock($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selproductostock',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('alm_visproductostock' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addproductostock($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addproductostock',$f3)) {
$Tipo = 'C';
$idproductostock = is_null($f3->get('POST.pidproductostock')) ? 'T' : $f3->get('POST.pidproductostock');
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$cantidad = is_null($f3->get('POST.pcantidad')) ? 'T' : $f3->get('POST.pcantidad');
$cantidadminima = is_null($f3->get('POST.pcantidadminima')) ? 'T' : $f3->get('POST.pcantidadminima');
$cantidadmaxima = is_null($f3->get('POST.pcantidadmaxima')) ? 'T' : $f3->get('POST.pcantidadmaxima');
$preciocompra = is_null($f3->get('POST.ppreciocompra')) ? 'T' : $f3->get('POST.ppreciocompra');
$precioventa = is_null($f3->get('POST.pprecioventa')) ? 'T' : $f3->get('POST.pprecioventa');
$idusuarioregistra = is_null($f3->get('POST.pidusuarioregistra')) ? 'T' : $f3->get('POST.pidusuarioregistra');
$idcompradetalle = is_null($f3->get('POST.pidcompradetalle')) ? 'T' : $f3->get('POST.pidcompradetalle');
$idcompradetalledato = is_null($f3->get('POST.pidcompradetalledato')) ? 'T' : $f3->get('POST.pidcompradetalledato');
$sql = "CALL alm_pagproductostock('" . $Tipo . "','". $idproductostock . "','". $idproducto . "','". $idoficina . "','". $cantidad . "','". $cantidadminima . "','". $cantidadmaxima . "','". $preciocompra . "','". $precioventa . "','". $idusuarioregistra . "','". $idcompradetalle . "','". $idcompradetalledato. "'); "; 
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

public function getproductostock($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getproductostock',$f3)) {
$Tipo = 'R';
$idproductostock = is_null($f3->get('POST.pidproductostock')) ? 'T' : $f3->get('POST.pidproductostock');
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$cantidad = is_null($f3->get('POST.pcantidad')) ? 'T' : $f3->get('POST.pcantidad');
$cantidadminima = is_null($f3->get('POST.pcantidadminima')) ? 'T' : $f3->get('POST.pcantidadminima');
$cantidadmaxima = is_null($f3->get('POST.pcantidadmaxima')) ? 'T' : $f3->get('POST.pcantidadmaxima');
$preciocompra = is_null($f3->get('POST.ppreciocompra')) ? 'T' : $f3->get('POST.ppreciocompra');
$precioventa = is_null($f3->get('POST.pprecioventa')) ? 'T' : $f3->get('POST.pprecioventa');
$idusuarioregistra = is_null($f3->get('POST.pidusuarioregistra')) ? 'T' : $f3->get('POST.pidusuarioregistra');
$idcompradetalle = is_null($f3->get('POST.pidcompradetalle')) ? 'T' : $f3->get('POST.pidcompradetalle');
$idcompradetalledato = is_null($f3->get('POST.pidcompradetalledato')) ? 'T' : $f3->get('POST.pidcompradetalledato');
$sql = "CALL alm_pagproductostock('" . $Tipo . "','". $idproductostock . "','". $idproducto . "','". $idoficina . "','". $cantidad . "','". $cantidadminima . "','". $cantidadmaxima . "','". $preciocompra . "','". $precioventa . "','". $idusuarioregistra . "','". $idcompradetalle . "','". $idcompradetalledato. "'); "; 
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

public function updproductostock($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updproductostock',$f3)) {
$Tipo = 'U';
$idproductostock = is_null($f3->get('POST.pidproductostock')) ? 'T' : $f3->get('POST.pidproductostock');
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$cantidad = is_null($f3->get('POST.pcantidad')) ? 'T' : $f3->get('POST.pcantidad');
$cantidadminima = is_null($f3->get('POST.pcantidadminima')) ? 'T' : $f3->get('POST.pcantidadminima');
$cantidadmaxima = is_null($f3->get('POST.pcantidadmaxima')) ? 'T' : $f3->get('POST.pcantidadmaxima');
$preciocompra = is_null($f3->get('POST.ppreciocompra')) ? 'T' : $f3->get('POST.ppreciocompra');
$precioventa = is_null($f3->get('POST.pprecioventa')) ? 'T' : $f3->get('POST.pprecioventa');
$idusuarioregistra = is_null($f3->get('POST.pidusuarioregistra')) ? 'T' : $f3->get('POST.pidusuarioregistra');
$idcompradetalle = is_null($f3->get('POST.pidcompradetalle')) ? 'T' : $f3->get('POST.pidcompradetalle');
$idcompradetalledato = is_null($f3->get('POST.pidcompradetalledato')) ? 'T' : $f3->get('POST.pidcompradetalledato');
$sql = "CALL alm_pagproductostock('" . $Tipo . "','". $idproductostock . "','". $idproducto . "','". $idoficina . "','". $cantidad . "','". $cantidadminima . "','". $cantidadmaxima . "','". $preciocompra . "','". $precioventa . "','". $idusuarioregistra . "','". $idcompradetalle . "','". $idcompradetalledato. "'); "; 
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

public function papproductostock($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papproductostock',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idproductostock = is_null($f3->get('POST.pidproductostock')) ? 'T' : $f3->get('POST.pidproductostock');
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$cantidad = is_null($f3->get('POST.pcantidad')) ? 'T' : $f3->get('POST.pcantidad');
$cantidadminima = is_null($f3->get('POST.pcantidadminima')) ? 'T' : $f3->get('POST.pcantidadminima');
$cantidadmaxima = is_null($f3->get('POST.pcantidadmaxima')) ? 'T' : $f3->get('POST.pcantidadmaxima');
$preciocompra = is_null($f3->get('POST.ppreciocompra')) ? 'T' : $f3->get('POST.ppreciocompra');
$precioventa = is_null($f3->get('POST.pprecioventa')) ? 'T' : $f3->get('POST.pprecioventa');
$idusuarioregistra = is_null($f3->get('POST.pidusuarioregistra')) ? 'T' : $f3->get('POST.pidusuarioregistra');
$idcompradetalle = is_null($f3->get('POST.pidcompradetalle')) ? 'T' : $f3->get('POST.pidcompradetalle');
$idcompradetalledato = is_null($f3->get('POST.pidcompradetalledato')) ? 'T' : $f3->get('POST.pidcompradetalledato');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idproductostock . "','". $idproducto . "','". $idoficina . "','". $cantidad . "','". $cantidadminima . "','". $cantidadmaxima . "','". $preciocompra . "','". $precioventa . "','". $idusuarioregistra . "','". $idcompradetalle . "','". $idcompradetalledato. "'); "; 
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
