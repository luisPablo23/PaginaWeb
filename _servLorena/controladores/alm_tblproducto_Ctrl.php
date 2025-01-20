<?php
//gen 25/2/2024 22:21:43 dst
class alm_tblproducto_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selproducto($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selproducto',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('alm_visproducto' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addproducto($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addproducto',$f3)) {
$Tipo = 'C';
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$nombreproducto = is_null($f3->get('POST.pnombreproducto')) ? 'T' : $f3->get('POST.pnombreproducto');
$idclasificacionproducto = is_null($f3->get('POST.pidclasificacionproducto')) ? 'T' : $f3->get('POST.pidclasificacionproducto');
$referencia = is_null($f3->get('POST.preferencia')) ? 'T' : $f3->get('POST.preferencia');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$color = is_null($f3->get('POST.pcolor')) ? 'T' : $f3->get('POST.pcolor');
$talla = is_null($f3->get('POST.ptalla')) ? 'T' : $f3->get('POST.ptalla');
$idmarca = is_null($f3->get('POST.pidmarca')) ? 'T' : $f3->get('POST.pidmarca');
$codigobarra1 = is_null($f3->get('POST.pcodigobarra1')) ? 'T' : $f3->get('POST.pcodigobarra1');
$codigobarra2 = is_null($f3->get('POST.pcodigobarra2')) ? 'T' : $f3->get('POST.pcodigobarra2');
$idtipounidad = is_null($f3->get('POST.pidtipounidad')) ? 'T' : $f3->get('POST.pidtipounidad');
$tipoproducto = is_null($f3->get('POST.ptipoproducto')) ? 'T' : $f3->get('POST.ptipoproducto');
$ventacongarantia = is_null($f3->get('POST.pventacongarantia')) ? 'T' : $f3->get('POST.pventacongarantia');
$connumeroserie = is_null($f3->get('POST.pconnumeroserie')) ? 'T' : $f3->get('POST.pconnumeroserie');
$conrfid = is_null($f3->get('POST.pconrfid')) ? 'T' : $f3->get('POST.pconrfid');
$diasvalides = is_null($f3->get('POST.pdiasvalides')) ? 'T' : $f3->get('POST.pdiasvalides');
$montocompra = is_null($f3->get('POST.pmontocompra')) ? 'T' : $f3->get('POST.pmontocompra');
$montoventa = is_null($f3->get('POST.pmontoventa')) ? 'T' : $f3->get('POST.pmontoventa');
$modelo = is_null($f3->get('POST.pmodelo')) ? 'T' : $f3->get('POST.pmodelo');
$idusuarioactualiza = is_null($f3->get('POST.pidusuarioactualiza')) ? 'T' : $f3->get('POST.pidusuarioactualiza');
$sql = "CALL alm_pagproducto('" . $Tipo . "','". $idproducto . "','". $nombreproducto . "','". $idclasificacionproducto . "','". $referencia . "','". $descripcion . "','". $color . "','". $talla . "','". $idmarca . "','". $codigobarra1 . "','". $codigobarra2 . "','". $idtipounidad . "','". $tipoproducto . "','". $ventacongarantia . "','". $connumeroserie . "','". $conrfid . "','". $diasvalides . "','". $montocompra . "','". $montoventa . "','". $modelo . "','". $idusuarioactualiza. "'); "; 
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

public function getproducto($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getproducto',$f3)) {
$Tipo = 'R';
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$nombreproducto = is_null($f3->get('POST.pnombreproducto')) ? 'T' : $f3->get('POST.pnombreproducto');
$idclasificacionproducto = is_null($f3->get('POST.pidclasificacionproducto')) ? 'T' : $f3->get('POST.pidclasificacionproducto');
$referencia = is_null($f3->get('POST.preferencia')) ? 'T' : $f3->get('POST.preferencia');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$color = is_null($f3->get('POST.pcolor')) ? 'T' : $f3->get('POST.pcolor');
$talla = is_null($f3->get('POST.ptalla')) ? 'T' : $f3->get('POST.ptalla');
$idmarca = is_null($f3->get('POST.pidmarca')) ? 'T' : $f3->get('POST.pidmarca');
$codigobarra1 = is_null($f3->get('POST.pcodigobarra1')) ? 'T' : $f3->get('POST.pcodigobarra1');
$codigobarra2 = is_null($f3->get('POST.pcodigobarra2')) ? 'T' : $f3->get('POST.pcodigobarra2');
$idtipounidad = is_null($f3->get('POST.pidtipounidad')) ? 'T' : $f3->get('POST.pidtipounidad');
$tipoproducto = is_null($f3->get('POST.ptipoproducto')) ? 'T' : $f3->get('POST.ptipoproducto');
$ventacongarantia = is_null($f3->get('POST.pventacongarantia')) ? 'T' : $f3->get('POST.pventacongarantia');
$connumeroserie = is_null($f3->get('POST.pconnumeroserie')) ? 'T' : $f3->get('POST.pconnumeroserie');
$conrfid = is_null($f3->get('POST.pconrfid')) ? 'T' : $f3->get('POST.pconrfid');
$diasvalides = is_null($f3->get('POST.pdiasvalides')) ? 'T' : $f3->get('POST.pdiasvalides');
$montocompra = is_null($f3->get('POST.pmontocompra')) ? 'T' : $f3->get('POST.pmontocompra');
$montoventa = is_null($f3->get('POST.pmontoventa')) ? 'T' : $f3->get('POST.pmontoventa');
$modelo = is_null($f3->get('POST.pmodelo')) ? 'T' : $f3->get('POST.pmodelo');
$idusuarioactualiza = is_null($f3->get('POST.pidusuarioactualiza')) ? 'T' : $f3->get('POST.pidusuarioactualiza');
$sql = "CALL alm_pagproducto('" . $Tipo . "','". $idproducto . "','". $nombreproducto . "','". $idclasificacionproducto . "','". $referencia . "','". $descripcion . "','". $color . "','". $talla . "','". $idmarca . "','". $codigobarra1 . "','". $codigobarra2 . "','". $idtipounidad . "','". $tipoproducto . "','". $ventacongarantia . "','". $connumeroserie . "','". $conrfid . "','". $diasvalides . "','". $montocompra . "','". $montoventa . "','". $modelo . "','". $idusuarioactualiza. "'); "; 
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

public function updproducto($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updproducto',$f3)) {
$Tipo = 'U';
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$nombreproducto = is_null($f3->get('POST.pnombreproducto')) ? 'T' : $f3->get('POST.pnombreproducto');
$idclasificacionproducto = is_null($f3->get('POST.pidclasificacionproducto')) ? 'T' : $f3->get('POST.pidclasificacionproducto');
$referencia = is_null($f3->get('POST.preferencia')) ? 'T' : $f3->get('POST.preferencia');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$color = is_null($f3->get('POST.pcolor')) ? 'T' : $f3->get('POST.pcolor');
$talla = is_null($f3->get('POST.ptalla')) ? 'T' : $f3->get('POST.ptalla');
$idmarca = is_null($f3->get('POST.pidmarca')) ? 'T' : $f3->get('POST.pidmarca');
$codigobarra1 = is_null($f3->get('POST.pcodigobarra1')) ? 'T' : $f3->get('POST.pcodigobarra1');
$codigobarra2 = is_null($f3->get('POST.pcodigobarra2')) ? 'T' : $f3->get('POST.pcodigobarra2');
$idtipounidad = is_null($f3->get('POST.pidtipounidad')) ? 'T' : $f3->get('POST.pidtipounidad');
$tipoproducto = is_null($f3->get('POST.ptipoproducto')) ? 'T' : $f3->get('POST.ptipoproducto');
$ventacongarantia = is_null($f3->get('POST.pventacongarantia')) ? 'T' : $f3->get('POST.pventacongarantia');
$connumeroserie = is_null($f3->get('POST.pconnumeroserie')) ? 'T' : $f3->get('POST.pconnumeroserie');
$conrfid = is_null($f3->get('POST.pconrfid')) ? 'T' : $f3->get('POST.pconrfid');
$diasvalides = is_null($f3->get('POST.pdiasvalides')) ? 'T' : $f3->get('POST.pdiasvalides');
$montocompra = is_null($f3->get('POST.pmontocompra')) ? 'T' : $f3->get('POST.pmontocompra');
$montoventa = is_null($f3->get('POST.pmontoventa')) ? 'T' : $f3->get('POST.pmontoventa');
$modelo = is_null($f3->get('POST.pmodelo')) ? 'T' : $f3->get('POST.pmodelo');
$idusuarioactualiza = is_null($f3->get('POST.pidusuarioactualiza')) ? 'T' : $f3->get('POST.pidusuarioactualiza');
$sql = "CALL alm_pagproducto('" . $Tipo . "','". $idproducto . "','". $nombreproducto . "','". $idclasificacionproducto . "','". $referencia . "','". $descripcion . "','". $color . "','". $talla . "','". $idmarca . "','". $codigobarra1 . "','". $codigobarra2 . "','". $idtipounidad . "','". $tipoproducto . "','". $ventacongarantia . "','". $connumeroserie . "','". $conrfid . "','". $diasvalides . "','". $montocompra . "','". $montoventa . "','". $modelo . "','". $idusuarioactualiza. "'); "; 
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

public function papproducto($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papproducto',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idproducto = is_null($f3->get('POST.pidproducto')) ? 'T' : $f3->get('POST.pidproducto');
$nombreproducto = is_null($f3->get('POST.pnombreproducto')) ? 'T' : $f3->get('POST.pnombreproducto');
$idclasificacionproducto = is_null($f3->get('POST.pidclasificacionproducto')) ? 'T' : $f3->get('POST.pidclasificacionproducto');
$referencia = is_null($f3->get('POST.preferencia')) ? 'T' : $f3->get('POST.preferencia');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$color = is_null($f3->get('POST.pcolor')) ? 'T' : $f3->get('POST.pcolor');
$talla = is_null($f3->get('POST.ptalla')) ? 'T' : $f3->get('POST.ptalla');
$idmarca = is_null($f3->get('POST.pidmarca')) ? 'T' : $f3->get('POST.pidmarca');
$codigobarra1 = is_null($f3->get('POST.pcodigobarra1')) ? 'T' : $f3->get('POST.pcodigobarra1');
$codigobarra2 = is_null($f3->get('POST.pcodigobarra2')) ? 'T' : $f3->get('POST.pcodigobarra2');
$idtipounidad = is_null($f3->get('POST.pidtipounidad')) ? 'T' : $f3->get('POST.pidtipounidad');
$tipoproducto = is_null($f3->get('POST.ptipoproducto')) ? 'T' : $f3->get('POST.ptipoproducto');
$ventacongarantia = is_null($f3->get('POST.pventacongarantia')) ? 'T' : $f3->get('POST.pventacongarantia');
$connumeroserie = is_null($f3->get('POST.pconnumeroserie')) ? 'T' : $f3->get('POST.pconnumeroserie');
$conrfid = is_null($f3->get('POST.pconrfid')) ? 'T' : $f3->get('POST.pconrfid');
$diasvalides = is_null($f3->get('POST.pdiasvalides')) ? 'T' : $f3->get('POST.pdiasvalides');
$montocompra = is_null($f3->get('POST.pmontocompra')) ? 'T' : $f3->get('POST.pmontocompra');
$montoventa = is_null($f3->get('POST.pmontoventa')) ? 'T' : $f3->get('POST.pmontoventa');
$modelo = is_null($f3->get('POST.pmodelo')) ? 'T' : $f3->get('POST.pmodelo');
$idusuarioactualiza = is_null($f3->get('POST.pidusuarioactualiza')) ? 'T' : $f3->get('POST.pidusuarioactualiza');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idproducto . "','". $nombreproducto . "','". $idclasificacionproducto . "','". $referencia . "','". $descripcion . "','". $color . "','". $talla . "','". $idmarca . "','". $codigobarra1 . "','". $codigobarra2 . "','". $idtipounidad . "','". $tipoproducto . "','". $ventacongarantia . "','". $connumeroserie . "','". $conrfid . "','". $diasvalides . "','". $montocompra . "','". $montoventa . "','". $modelo . "','". $idusuarioactualiza. "'); "; 
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
