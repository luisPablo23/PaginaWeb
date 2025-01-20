<?php
//gen 25/2/2024 22:21:33 dst
class alm_tblcompradetalle_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selcompradetalle($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selcompradetalle',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('alm_viscompradetalle' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addcompradetalle($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addcompradetalle',$f3)) {
$Tipo = 'C';
$idcompradetalle = is_null($f3->get('POST.pidcompradetalle')) ? 'T' : $f3->get('POST.pidcompradetalle');
$idcompra = is_null($f3->get('POST.pidcompra')) ? 'T' : $f3->get('POST.pidcompra');
$nombrecompradetalle = is_null($f3->get('POST.pnombrecompradetalle')) ? 'T' : $f3->get('POST.pnombrecompradetalle');
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$cantidad = is_null($f3->get('POST.pcantidad')) ? 'T' : $f3->get('POST.pcantidad');
$preciounitario = is_null($f3->get('POST.ppreciounitario')) ? 'T' : $f3->get('POST.ppreciounitario');
$precioventa = is_null($f3->get('POST.pprecioventa')) ? 'T' : $f3->get('POST.pprecioventa');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$fechaini = is_null($f3->get('POST.pfechaini')) ? 'T' : $f3->get('POST.pfechaini');
$fechafin = is_null($f3->get('POST.pfechafin')) ? 'T' : $f3->get('POST.pfechafin');
$idestadocompradetalle = is_null($f3->get('POST.pidestadocompradetalle')) ? 'T' : $f3->get('POST.pidestadocompradetalle');
$sql = "CALL alm_pagcompradetalle('" . $Tipo . "','". $idcompradetalle . "','". $idcompra . "','". $nombrecompradetalle . "','". $idproducto . "','". $cantidad . "','". $preciounitario . "','". $precioventa . "','". $subtotal . "','". $fechaini . "','". $fechafin . "','". $idestadocompradetalle. "'); "; 
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

public function getcompradetalle($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getcompradetalle',$f3)) {
$Tipo = 'R';
$idcompradetalle = is_null($f3->get('POST.pidcompradetalle')) ? 'T' : $f3->get('POST.pidcompradetalle');
$idcompra = is_null($f3->get('POST.pidcompra')) ? 'T' : $f3->get('POST.pidcompra');
$nombrecompradetalle = is_null($f3->get('POST.pnombrecompradetalle')) ? 'T' : $f3->get('POST.pnombrecompradetalle');
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$cantidad = is_null($f3->get('POST.pcantidad')) ? 'T' : $f3->get('POST.pcantidad');
$preciounitario = is_null($f3->get('POST.ppreciounitario')) ? 'T' : $f3->get('POST.ppreciounitario');
$precioventa = is_null($f3->get('POST.pprecioventa')) ? 'T' : $f3->get('POST.pprecioventa');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$fechaini = is_null($f3->get('POST.pfechaini')) ? 'T' : $f3->get('POST.pfechaini');
$fechafin = is_null($f3->get('POST.pfechafin')) ? 'T' : $f3->get('POST.pfechafin');
$idestadocompradetalle = is_null($f3->get('POST.pidestadocompradetalle')) ? 'T' : $f3->get('POST.pidestadocompradetalle');
$sql = "CALL alm_pagcompradetalle('" . $Tipo . "','". $idcompradetalle . "','". $idcompra . "','". $nombrecompradetalle . "','". $idproducto . "','". $cantidad . "','". $preciounitario . "','". $precioventa . "','". $subtotal . "','". $fechaini . "','". $fechafin . "','". $idestadocompradetalle. "'); "; 
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

public function updcompradetalle($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updcompradetalle',$f3)) {
$Tipo = 'U';
$idcompradetalle = is_null($f3->get('POST.pidcompradetalle')) ? 'T' : $f3->get('POST.pidcompradetalle');
$idcompra = is_null($f3->get('POST.pidcompra')) ? 'T' : $f3->get('POST.pidcompra');
$nombrecompradetalle = is_null($f3->get('POST.pnombrecompradetalle')) ? 'T' : $f3->get('POST.pnombrecompradetalle');
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$cantidad = is_null($f3->get('POST.pcantidad')) ? 'T' : $f3->get('POST.pcantidad');
$preciounitario = is_null($f3->get('POST.ppreciounitario')) ? 'T' : $f3->get('POST.ppreciounitario');
$precioventa = is_null($f3->get('POST.pprecioventa')) ? 'T' : $f3->get('POST.pprecioventa');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$fechaini = is_null($f3->get('POST.pfechaini')) ? 'T' : $f3->get('POST.pfechaini');
$fechafin = is_null($f3->get('POST.pfechafin')) ? 'T' : $f3->get('POST.pfechafin');
$idestadocompradetalle = is_null($f3->get('POST.pidestadocompradetalle')) ? 'T' : $f3->get('POST.pidestadocompradetalle');
$sql = "CALL alm_pagcompradetalle('" . $Tipo . "','". $idcompradetalle . "','". $idcompra . "','". $nombrecompradetalle . "','". $idproducto . "','". $cantidad . "','". $preciounitario . "','". $precioventa . "','". $subtotal . "','". $fechaini . "','". $fechafin . "','". $idestadocompradetalle. "'); "; 
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

public function papcompradetalle($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papcompradetalle',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idcompradetalle = is_null($f3->get('POST.pidcompradetalle')) ? 'T' : $f3->get('POST.pidcompradetalle');
$idcompra = is_null($f3->get('POST.pidcompra')) ? 'T' : $f3->get('POST.pidcompra');
$nombrecompradetalle = is_null($f3->get('POST.pnombrecompradetalle')) ? 'T' : $f3->get('POST.pnombrecompradetalle');
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$cantidad = is_null($f3->get('POST.pcantidad')) ? 'T' : $f3->get('POST.pcantidad');
$preciounitario = is_null($f3->get('POST.ppreciounitario')) ? 'T' : $f3->get('POST.ppreciounitario');
$precioventa = is_null($f3->get('POST.pprecioventa')) ? 'T' : $f3->get('POST.pprecioventa');
$subtotal = is_null($f3->get('POST.psubtotal')) ? 'T' : $f3->get('POST.psubtotal');
$fechaini = is_null($f3->get('POST.pfechaini')) ? 'T' : $f3->get('POST.pfechaini');
$fechafin = is_null($f3->get('POST.pfechafin')) ? 'T' : $f3->get('POST.pfechafin');
$idestadocompradetalle = is_null($f3->get('POST.pidestadocompradetalle')) ? 'T' : $f3->get('POST.pidestadocompradetalle');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idcompradetalle . "','". $idcompra . "','". $nombrecompradetalle . "','". $idproducto . "','". $cantidad . "','". $preciounitario . "','". $precioventa . "','". $subtotal . "','". $fechaini . "','". $fechafin . "','". $idestadocompradetalle. "'); "; 
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
